import 'package:workmanager/workmanager.dart';

import '../../core/utils/logger.dart';
import '../../data/database/app_database.dart';
import '../../data/services/notification_plugin_service.dart';
import 'schedule_service.dart';

/// Top-level callback for WorkManager background execution.
///
/// Runs in a separate isolate — no access to the widget tree or
/// existing ProviderContainer. Must create its own service instances.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    Logger.info('Background task started: $taskName', tag: 'BackgroundSync');

    try {
      // Initialize the notification plugin (timezone + platform config).
      // Safe to call multiple times — idempotent after first init.
      await NotificationPluginService.instance.init();

      // Create a fresh database connection for this isolate.
      final db = AppDatabase();
      final dao = db.notificationDao;
      final pluginService = NotificationPluginService.instance;
      final scheduleService = ScheduleService(pluginService, dao);

      await scheduleService.syncAll();
      await db.close();

      Logger.info('Background sync complete', tag: 'BackgroundSync');
      return true;
    } catch (e, st) {
      Logger.info('Background sync failed: $e\n$st', tag: 'BackgroundSync');
      return false;
    }
  });
}

/// Manages WorkManager periodic sync to keep scheduled notifications
/// alive even if the OS kills the app or the device reboots.
///
/// Call [initialize] once at app startup (in main.dart).
class BackgroundSyncService {
  BackgroundSyncService._();

  /// Unique task name registered with WorkManager.
  static const String _taskName = 'com.customnotifications.sync';

  /// Minimum interval between periodic syncs.
  /// WorkManager enforces a 15-minute minimum on both platforms.
  static const Duration _frequency = Duration(minutes: 30);

  /// Initialize WorkManager and register the periodic sync task.
  ///
  /// Safe to call on every app launch — WorkManager deduplicates
  /// by task name using [ExistingWorkPolicy.keep].
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      // Disable debug logging in production builds.
      isInDebugMode: false,
    );

    await Workmanager().registerPeriodicTask(
      _taskName,
      _taskName,
      frequency: _frequency,
      existingWorkPolicy: ExistingWorkPolicy.keep,
      constraints: Constraints(
        // Run on any network state — we don't need network for local sync.
        networkType: NetworkType.not_required,
      ),
    );

    Logger.info(
      'WorkManager periodic sync registered (${_frequency.inMinutes}min)',
      tag: 'BackgroundSync',
    );
  }
}
