import '../../core/utils/logger.dart';
import '../../data/database/daos/notification_dao.dart';
import '../../data/database/mappers/notification_mapper.dart';
import '../../data/services/notification_plugin_service.dart';
import '../models/notification_item.dart';
import '../models/schedule_type.dart';

/// A single pending fire event to be scheduled with the OS.
///
/// Internal to the schedule service — not exposed to the UI layer.
class ScheduledFire {
  const ScheduledFire({
    required this.notificationId,
    required this.fireTime,
    required this.title,
    required this.body,
    this.soundName,
  });

  /// UUID of the parent NotificationItem.
  final String notificationId;

  /// Exact UTC time this notification should fire.
  final DateTime fireTime;

  /// Notification title text.
  final String title;

  /// Notification body text.
  final String body;

  /// Optional custom sound filename.
  final String? soundName;
}

/// Rolling window scheduler that respects the iOS 64 pending notification limit.
///
/// Orchestrates which fire times get scheduled with the OS by:
/// 1. Computing future fire times for every active notification
/// 2. Sorting all fire times chronologically
/// 3. Taking only the soonest [maxPendingSlots] (60)
/// 4. Cancelling all existing OS notifications and re-scheduling the winners
///
/// This "cancel-all-then-reschedule" approach is simple and correct for
/// apps with <100 active notifications. A diff-based approach would be
/// an optimization for a much larger scale that we don't need.
class ScheduleService {
  ScheduleService(this._pluginService, this._dao);

  final NotificationPluginService _pluginService;
  final NotificationDao _dao;

  /// Maximum OS notification slots to use. iOS allows 64 pending;
  /// we reserve 4 as buffer for system use or edge-case timing.
  static const int maxPendingSlots = 60;

  /// How far into the future to compute fire times for recurring schedules.
  /// 30 days is a good balance between coverage and avoiding excessive
  /// computation for high-frequency intervals.
  static const Duration scheduleHorizon = Duration(days: 30);

  /// Re-sync all OS-level pending notifications with the current DB state.
  ///
  /// Call this after every CRUD operation on notifications, on app
  /// foreground, and periodically via WorkManager.
  Future<void> syncAll() async {
    try {
      // 1. Fetch all active notifications from the database.
      final entities = await _dao.getActive();
      final items = entities.map((e) => e.toDomain()).toList();

      // 2. Compute upcoming fire times for each active notification.
      final now = DateTime.now().toUtc();
      final horizon = now.add(scheduleHorizon);
      final List<ScheduledFire> allFires = [];

      for (final item in items) {
        allFires.addAll(_computeFireTimes(item, now, horizon));
      }

      // 3. Sort by fire time (soonest first) and take the top N.
      allFires.sort((a, b) => a.fireTime.compareTo(b.fireTime));
      final toSchedule = allFires.length > maxPendingSlots
          ? allFires.sublist(0, maxPendingSlots)
          : allFires;

      // 4. Cancel all existing OS notifications and re-schedule.
      await _pluginService.cancelAll();

      for (final fire in toSchedule) {
        await _pluginService.scheduleNotification(
          notificationUuid: fire.notificationId,
          fireTime: fire.fireTime,
          title: fire.title,
          body: fire.body,
          soundName: fire.soundName,
        );
      }

      Logger.info(
        'syncAll complete: scheduled ${toSchedule.length} fires '
        'for ${items.length} active notifications',
        tag: 'ScheduleService',
      );
    } catch (e, st) {
      // Never let a sync failure crash the app. Log and move on.
      Logger.info(
        'syncAll failed: $e\n$st',
        tag: 'ScheduleService',
      );
    }
  }

  /// Convenience wrapper — semantically indicates we're syncing because
  /// a specific item changed. Currently just calls [syncAll] since the
  /// cancel-all-reschedule approach rebuilds the full schedule anyway.
  Future<void> syncForItem(String id) => syncAll();

  // ---------------------------------------------------------------------------
  // Fire time computation
  // ---------------------------------------------------------------------------

  /// Compute all future fire times for [item] between [now] and [horizon].
  ///
  /// Returns an empty list if the item's schedule type produces no future
  /// fire times (e.g. a one-time notification in the past, or an
  /// unimplemented premium type).
  List<ScheduledFire> _computeFireTimes(
    NotificationItem item,
    DateTime now,
    DateTime horizon,
  ) {
    switch (item.scheduleType) {
      case ScheduleType.oneTime:
        return _computeOneTime(item, now);
      case ScheduleType.daily:
        return _computeDaily(item, now, horizon);
      case ScheduleType.weekly:
        return _computeWeekly(item, now, horizon);
      case ScheduleType.interval:
        return _computeInterval(item, now, horizon);
      case ScheduleType.random:
      case ScheduleType.custom:
        // Not implemented in v1 — return no fire times.
        return [];
    }
  }

  /// One-time: single fire if it's still in the future.
  List<ScheduledFire> _computeOneTime(NotificationItem item, DateTime now) {
    if (item.scheduledAt.isAfter(now)) {
      return [
        ScheduledFire(
          notificationId: item.id,
          fireTime: item.scheduledAt,
          title: item.title,
          body: item.body,
          soundName: item.soundName,
        ),
      ];
    }
    return [];
  }

  /// Daily: emit one fire per day at the scheduled time-of-day,
  /// starting from today (or tomorrow if today's time already passed).
  List<ScheduledFire> _computeDaily(
    NotificationItem item,
    DateTime now,
    DateTime horizon,
  ) {
    final fires = <ScheduledFire>[];
    final timeOfDay = _extractTimeOfDay(item.scheduledAt);

    // Start from today at the scheduled time.
    var candidate = DateTime.utc(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If today's time already passed, start tomorrow.
    if (candidate.isBefore(now) || candidate.isAtSameMomentAs(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    while (candidate.isBefore(horizon)) {
      fires.add(ScheduledFire(
        notificationId: item.id,
        fireTime: candidate,
        title: item.title,
        body: item.body,
        soundName: item.soundName,
      ));
      candidate = candidate.add(const Duration(days: 1));
    }

    return fires;
  }

  /// Weekly: emit fire times only on the selected weekdays at the
  /// scheduled time-of-day.
  List<ScheduledFire> _computeWeekly(
    NotificationItem item,
    DateTime now,
    DateTime horizon,
  ) {
    if (item.weekdays == null || item.weekdays!.isEmpty) return [];

    final fires = <ScheduledFire>[];
    final timeOfDay = _extractTimeOfDay(item.scheduledAt);
    final weekdaySet = item.weekdays!.toSet();

    // Start from today at the scheduled time.
    var candidate = DateTime.utc(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If today's time already passed, start tomorrow.
    if (candidate.isBefore(now) || candidate.isAtSameMomentAs(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    while (candidate.isBefore(horizon)) {
      // DateTime.weekday uses ISO: 1=Monday .. 7=Sunday, matching our model.
      if (weekdaySet.contains(candidate.weekday)) {
        fires.add(ScheduledFire(
          notificationId: item.id,
          fireTime: candidate,
          title: item.title,
          body: item.body,
          soundName: item.soundName,
        ));
      }
      candidate = candidate.add(const Duration(days: 1));
    }

    return fires;
  }

  /// Interval: emit fire times every [intervalMinutes] starting from
  /// the scheduled time, skipping any in the past.
  List<ScheduledFire> _computeInterval(
    NotificationItem item,
    DateTime now,
    DateTime horizon,
  ) {
    if (item.intervalMinutes == null || item.intervalMinutes! <= 0) return [];

    final fires = <ScheduledFire>[];
    final interval = Duration(minutes: item.intervalMinutes!);

    // Start from the original scheduled time.
    var candidate = item.scheduledAt;

    // Fast-forward past missed instances to avoid iterating from the
    // distant past. Calculate how many intervals have elapsed since
    // the scheduled time and jump ahead.
    if (candidate.isBefore(now)) {
      final elapsed = now.difference(candidate);
      final missedCount = elapsed.inMinutes ~/ item.intervalMinutes!;
      candidate = candidate.add(interval * missedCount);
      // If we're still in the past after the jump, go one more.
      if (candidate.isBefore(now) || candidate.isAtSameMomentAs(now)) {
        candidate = candidate.add(interval);
      }
    }

    while (candidate.isBefore(horizon)) {
      fires.add(ScheduledFire(
        notificationId: item.id,
        fireTime: candidate,
        title: item.title,
        body: item.body,
        soundName: item.soundName,
      ));
      candidate = candidate.add(interval);
    }

    return fires;
  }

  /// Extract the hour and minute from a UTC DateTime.
  ({int hour, int minute}) _extractTimeOfDay(DateTime dt) {
    return (hour: dt.hour, minute: dt.minute);
  }
}
