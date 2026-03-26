import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../core/utils/logger.dart';

/// Callback invoked when the user taps a notification while the app is running.
/// The [payload] is the notification UUID set at schedule time.
typedef NotificationTapCallback = void Function(String? payload);

/// Top-level callback for background notification responses.
///
/// Must be a top-level or static function — not a closure or instance method —
/// because it runs on a background isolate.
@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(NotificationResponse response) {
  // No-op for now. Background actions (e.g. dismiss, snooze) can be wired
  // here in the future. We cannot access Flutter engine state from this
  // isolate, so any work must be self-contained.
  Logger.info(
    'Background notification response: ${response.actionId}',
    tag: 'NotificationPlugin',
  );
}

/// Low-level wrapper around [FlutterLocalNotificationsPlugin].
///
/// Responsibilities:
/// - Initialize the plugin with platform-specific settings
/// - Request notification permissions from the OS
/// - Schedule, cancel, and query pending notifications
/// - Convert UTC [DateTime] → [tz.TZDateTime] for scheduling
/// - Generate deterministic int IDs from (UUID + fireTime)
///
/// This service does NOT decide which notifications to schedule — that
/// logic lives in ScheduleService (the rolling window scheduler). This
/// is purely the OS bridge.
class NotificationPluginService {
  NotificationPluginService._();
  static final NotificationPluginService instance =
      NotificationPluginService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Callback set by the app layer to handle notification taps.
  /// Set this before calling [init] so taps that launched the app are handled.
  NotificationTapCallback? onNotificationTap;

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Android notification channel constants
  // ---------------------------------------------------------------------------

  /// Channel ID for all scheduled notifications.
  static const String _channelId = 'custom_notify_default';
  static const String _channelName = 'Scheduled Notifications';
  static const String _channelDescription =
      'Notifications you created in CustomNotify';

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Initialize the timezone database and the notification plugin.
  ///
  /// Call this once at app startup, before scheduling any notifications.
  /// On iOS, this defers the permission prompt — call [requestPermissions]
  /// separately when the user is ready.
  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone database and set the local timezone.
    tz.initializeTimeZones();
    final String tzName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName));
    Logger.info('Timezone set to $tzName', tag: 'NotificationPlugin');

    // Platform-specific initialization settings.
    const androidSettings = AndroidInitializationSettings(
      // Uses the app's default launcher icon. Replace with a custom
      // drawable resource name (without extension) if you add one later.
      '@mipmap/ic_launcher',
    );

    // Defer the iOS permission prompt so we can show it at the right moment
    // (e.g. after onboarding) instead of on first launch.
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings, // macOS uses the same Darwin settings.
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onForegroundResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationResponse,
    );

    _initialized = true;
    Logger.info('Notification plugin initialized', tag: 'NotificationPlugin');
  }

  /// Handles taps on notifications while the app is in the foreground or
  /// was brought to the foreground by the tap.
  void _onForegroundResponse(NotificationResponse response) {
    Logger.info(
      'Notification tapped: id=${response.id}, payload=${response.payload}',
      tag: 'NotificationPlugin',
    );
    onNotificationTap?.call(response.payload);
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  /// Request notification permissions from the OS.
  ///
  /// On iOS, shows the system permission dialog for alert, badge, and sound.
  /// On Android 13+, requests the POST_NOTIFICATIONS runtime permission.
  /// Returns true if permission was granted (or already granted).
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      Logger.info(
        'iOS permissions granted: $granted',
        tag: 'NotificationPlugin',
      );
      return granted ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      // requestNotificationsPermission() handles the Android 13+ runtime
      // permission dialog. On older versions it returns true immediately.
      final granted = await androidPlugin?.requestNotificationsPermission();
      Logger.info(
        'Android permissions granted: $granted',
        tag: 'NotificationPlugin',
      );
      return granted ?? false;
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // Scheduling
  // ---------------------------------------------------------------------------

  /// Schedule a notification to fire at [fireTime] (UTC).
  ///
  /// [notificationUuid] is the UUID from the NotificationItem model.
  /// [fireTime] is the exact UTC DateTime when this notification should fire.
  /// [title] and [body] are the notification content.
  /// [soundName] is an optional custom sound filename (without extension on
  /// iOS; with extension on Android).
  ///
  /// The int notification ID is derived deterministically from
  /// (notificationUuid + fireTime) so we can cancel specific scheduled
  /// instances without storing a separate ID mapping.
  Future<void> scheduleNotification({
    required String notificationUuid,
    required DateTime fireTime,
    required String title,
    required String body,
    String? soundName,
  }) async {
    _ensureInitialized();

    final int id = generateNotificationId(notificationUuid, fireTime);
    final tz.TZDateTime tzFireTime = _utcToLocal(fireTime);

    // Don't schedule notifications in the past — they'd fire immediately,
    // which is confusing for the user.
    if (tzFireTime.isBefore(tz.TZDateTime.now(tz.local))) {
      Logger.info(
        'Skipping past notification: $notificationUuid at $fireTime',
        tag: 'NotificationPlugin',
      );
      return;
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        // Use the custom sound if provided, otherwise system default.
        sound: soundName != null
            ? RawResourceAndroidNotificationSound(soundName)
            : null,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        // On iOS, the sound filename needs the extension.
        sound: soundName != null ? '$soundName.aiff' : null,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // Use timeSensitive for higher visibility. Requires the
        // "Time Sensitive Notifications" capability.
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzFireTime,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Payload is the notification UUID so we can look it up when tapped.
      payload: notificationUuid,
    );
  }

  // ---------------------------------------------------------------------------
  // Cancellation
  // ---------------------------------------------------------------------------

  /// Cancel a specific scheduled notification by its deterministic ID.
  ///
  /// Pass the same [notificationUuid] and [fireTime] that were used to
  /// schedule it.
  Future<void> cancelNotification({
    required String notificationUuid,
    required DateTime fireTime,
  }) async {
    _ensureInitialized();
    final int id = generateNotificationId(notificationUuid, fireTime);
    await _plugin.cancel(id: id);
  }

  /// Cancel all pending notifications. Used during a full re-sync
  /// by the rolling window scheduler.
  Future<void> cancelAll() async {
    _ensureInitialized();
    await _plugin.cancelAll();
    Logger.info('Cancelled all notifications', tag: 'NotificationPlugin');
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Returns the number of currently pending (scheduled) notifications.
  ///
  /// Useful for monitoring the iOS 64-notification limit.
  Future<int> getPendingCount() async {
    _ensureInitialized();
    final pending = await _plugin.pendingNotificationRequests();
    return pending.length;
  }

  /// Returns all pending notification request IDs.
  ///
  /// Used by the schedule service to diff against the desired set.
  Future<List<int>> getPendingIds() async {
    _ensureInitialized();
    final pending = await _plugin.pendingNotificationRequests();
    return pending.map((r) => r.id).toList();
  }

  // ---------------------------------------------------------------------------
  // App launch details
  // ---------------------------------------------------------------------------

  /// Check if the app was launched by tapping a notification.
  ///
  /// Call this after [init] to handle the cold-start tap. Returns the
  /// notification payload (UUID) if the app was launched from a notification,
  /// or null otherwise.
  Future<String?> getNotificationLaunchPayload() async {
    _ensureInitialized();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse != null) {
      return details.notificationResponse!.payload;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Generate a stable, deterministic int ID from (UUID + fireTime).
  ///
  /// Uses hashCode of the combined string. Masked to positive 31-bit int
  /// to satisfy the flutter_local_notifications int ID requirement and
  /// avoid negative IDs which can cause issues on some Android versions.
  static int generateNotificationId(String uuid, DateTime fireTime) {
    final key = '$uuid|${fireTime.toUtc().millisecondsSinceEpoch}';
    return key.hashCode & 0x7FFFFFFF;
  }

  /// Convert a UTC DateTime to a TZDateTime in the device's local timezone.
  tz.TZDateTime _utcToLocal(DateTime utcDateTime) {
    return tz.TZDateTime.from(utcDateTime.toUtc(), tz.local);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'NotificationPluginService.init() must be called before '
        'scheduling or cancelling notifications.',
      );
    }
  }
}
