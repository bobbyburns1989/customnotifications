import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:custom_notify/data/database/mappers/notification_mapper.dart';
import 'package:custom_notify/domain/models/notification_item.dart';
import 'package:custom_notify/domain/models/schedule_type.dart';
import 'package:custom_notify/domain/services/schedule_service.dart';

import '../../helpers/mocks.mocks.dart';
import '../../helpers/test_database.dart';

/// Helper to build a valid test notification.
NotificationItem _makeItem({
  String id = 'test-id-1',
  String title = 'Test',
  String body = 'Test body',
  ScheduleType scheduleType = ScheduleType.oneTime,
  DateTime? scheduledAt,
  bool isActive = true,
  List<int>? weekdays,
  int? intervalMinutes,
}) {
  final now = DateTime.now().toUtc();
  return NotificationItem(
    id: id,
    title: title,
    body: body,
    scheduleType: scheduleType,
    scheduledAt: scheduledAt ?? now.add(const Duration(hours: 1)),
    isActive: isActive,
    createdAt: now,
    updatedAt: now,
    weekdays: weekdays,
    intervalMinutes: intervalMinutes,
  );
}

void main() {
  late MockNotificationPluginService mockPlugin;

  /// Returns all fire times that were passed to scheduleNotification.
  List<DateTime> getCapturedFireTimes(MockNotificationPluginService mock) {
    // Extract fireTime arguments from all scheduleNotification calls.
    final calls = verify(mock.scheduleNotification(
      notificationUuid: anyNamed('notificationUuid'),
      fireTime: captureAnyNamed('fireTime'),
      title: anyNamed('title'),
      body: anyNamed('body'),
      soundName: anyNamed('soundName'),
    )).captured;
    return calls.cast<DateTime>();
  }

  setUp(() {
    mockPlugin = MockNotificationPluginService();
  });

  group('syncAll', () {
    test('schedules one-time notification in the future', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      final futureTime = DateTime.now().toUtc().add(const Duration(hours: 2));
      final item = _makeItem(scheduledAt: futureTime);
      await deps.notificationDao.insertItem(item.toCompanion());

      await svc.syncAll();

      verify(mockPlugin.cancelAll()).called(1);
      final fireTimes = getCapturedFireTimes(mockPlugin);
      expect(fireTimes, hasLength(1));
      expect(
        fireTimes.first.difference(futureTime).inSeconds.abs(),
        lessThan(2),
      );
    });

    test('skips one-time notification in the past', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      final pastTime = DateTime.now().toUtc().subtract(const Duration(hours: 1));
      final item = _makeItem(scheduledAt: pastTime);
      await deps.notificationDao.insertItem(item.toCompanion());

      await svc.syncAll();

      verify(mockPlugin.cancelAll()).called(1);
      verifyNever(mockPlugin.scheduleNotification(
        notificationUuid: anyNamed('notificationUuid'),
        fireTime: anyNamed('fireTime'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        soundName: anyNamed('soundName'),
      ));
    });

    test('daily notification generates fire times for ~30 days', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      final item = _makeItem(
        scheduleType: ScheduleType.daily,
        scheduledAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      await deps.notificationDao.insertItem(item.toCompanion());

      await svc.syncAll();

      final fireTimes = getCapturedFireTimes(mockPlugin);
      // Daily for 30 days should produce ~29-30 fire times.
      expect(fireTimes.length, greaterThanOrEqualTo(28));
      expect(fireTimes.length, lessThanOrEqualTo(30));

      // Verify chronological order.
      for (var i = 1; i < fireTimes.length; i++) {
        expect(fireTimes[i].isAfter(fireTimes[i - 1]), isTrue);
      }
    });

    test('weekly notification fires only on selected weekdays', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      // Monday (1) and Friday (5) only.
      final item = _makeItem(
        scheduleType: ScheduleType.weekly,
        weekdays: [1, 5],
        scheduledAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      await deps.notificationDao.insertItem(item.toCompanion());

      await svc.syncAll();

      final fireTimes = getCapturedFireTimes(mockPlugin);
      expect(fireTimes, isNotEmpty);

      // Every fire time should be on Monday or Friday.
      for (final ft in fireTimes) {
        expect(
          ft.weekday == DateTime.monday || ft.weekday == DateTime.friday,
          isTrue,
          reason: 'Expected Mon or Fri, got weekday ${ft.weekday} for $ft',
        );
      }
    });

    test('interval notification fires every N minutes', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      final startTime = DateTime.now().toUtc().add(const Duration(minutes: 30));
      final item = _makeItem(
        scheduleType: ScheduleType.interval,
        intervalMinutes: 60,
        scheduledAt: startTime,
      );
      await deps.notificationDao.insertItem(item.toCompanion());

      await svc.syncAll();

      final fireTimes = getCapturedFireTimes(mockPlugin);
      expect(fireTimes, isNotEmpty);

      // Verify 60-minute spacing between consecutive fires.
      for (var i = 1; i < fireTimes.length; i++) {
        final diff = fireTimes[i].difference(fireTimes[i - 1]).inMinutes;
        expect(diff, equals(60));
      }
    });

    test('respects 60-slot budget across multiple notifications', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      // 5 daily notifications × ~30 fires each = ~150 total.
      // Should be capped at 60.
      for (var i = 0; i < 5; i++) {
        final item = _makeItem(
          id: 'daily-$i',
          scheduleType: ScheduleType.daily,
          scheduledAt:
              DateTime.now().toUtc().add(Duration(hours: 1, minutes: i)),
        );
        await deps.notificationDao.insertItem(item.toCompanion());
      }

      await svc.syncAll();

      final fireTimes = getCapturedFireTimes(mockPlugin);
      expect(fireTimes.length, equals(ScheduleService.maxPendingSlots));
    });

    test('cancels all and schedules nothing for empty DB', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      await svc.syncAll();

      verify(mockPlugin.cancelAll()).called(1);
      verifyNever(mockPlugin.scheduleNotification(
        notificationUuid: anyNamed('notificationUuid'),
        fireTime: anyNamed('fireTime'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        soundName: anyNamed('soundName'),
      ));
    });

    test('ignores inactive notifications', () async {
      final deps = createTestDatabaseWithDaos();
      final svc = ScheduleService(mockPlugin, deps.notificationDao);

      final active = _makeItem(
        id: 'active',
        scheduledAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      final inactive = _makeItem(
        id: 'inactive',
        isActive: false,
        scheduledAt: DateTime.now().toUtc().add(const Duration(hours: 2)),
      );
      await deps.notificationDao.insertItem(active.toCompanion());
      await deps.notificationDao.insertItem(inactive.toCompanion());

      await svc.syncAll();

      final fireTimes = getCapturedFireTimes(mockPlugin);
      expect(fireTimes, hasLength(1));
    });
  });
}
