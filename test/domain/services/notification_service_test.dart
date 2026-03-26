import 'package:flutter_test/flutter_test.dart';
import 'package:custom_notify/domain/models/notification_item.dart';
import 'package:custom_notify/domain/models/schedule_type.dart';
import 'package:custom_notify/domain/services/notification_service.dart';
import 'package:custom_notify/domain/services/schedule_service.dart';

import '../../helpers/mocks.mocks.dart';
import '../../helpers/test_database.dart';

/// Helper to build a valid test notification with sensible defaults.
NotificationItem _makeItem({
  String id = 'test-id-1',
  String title = 'Test Title',
  String body = 'Test body text',
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
  late NotificationService service;
  late NotificationService premiumService;

  // Use a real in-memory DB so we test the full DAO path.
  // Generated mocks prevent OS-level scheduling calls.
  setUp(() {
    final deps = createTestDatabaseWithDaos();
    final mockPlugin = MockNotificationPluginService();
    final scheduleService = ScheduleService(mockPlugin, deps.notificationDao);

    service = NotificationService(
      deps.notificationDao,
      scheduleService,
      mockPlugin,
    );

    premiumService = NotificationService(
      deps.notificationDao,
      scheduleService,
      mockPlugin,
      isPremium: true,
    );
  });

  group('createNotification', () {
    test('inserts valid notification and it becomes retrievable', () async {
      final item = _makeItem();
      await service.createNotification(item);

      final fetched = await service.getById(item.id);
      expect(fetched, isNotNull);
      expect(fetched!.title, equals('Test Title'));
    });

    test('throws validation error for empty title', () async {
      final item = _makeItem(title: '');
      expect(
        () => service.createNotification(item),
        throwsA(isA<NotificationValidationException>()),
      );
    });

    test('throws validation error for empty body', () async {
      final item = _makeItem(body: '');
      expect(
        () => service.createNotification(item),
        throwsA(isA<NotificationValidationException>()),
      );
    });

    test('throws validation error for title over 200 chars', () async {
      final item = _makeItem(title: 'A' * 201);
      expect(
        () => service.createNotification(item),
        throwsA(isA<NotificationValidationException>()),
      );
    });

    test('throws validation error for body over 1000 chars', () async {
      final item = _makeItem(body: 'B' * 1001);
      expect(
        () => service.createNotification(item),
        throwsA(isA<NotificationValidationException>()),
      );
    });

    test('throws validation error for weekly without weekdays', () async {
      final item = _makeItem(
        scheduleType: ScheduleType.weekly,
        weekdays: [],
      );
      expect(
        () => service.createNotification(item),
        throwsA(isA<NotificationValidationException>()),
      );
    });

    test('throws validation error for interval with 0 minutes', () async {
      final item = _makeItem(
        scheduleType: ScheduleType.interval,
        intervalMinutes: 0,
      );
      expect(
        () => service.createNotification(item),
        throwsA(isA<NotificationValidationException>()),
      );
    });

    test('enforces free tier limit of 10 active notifications', () async {
      // Create 10 notifications (the limit).
      for (var i = 0; i < 10; i++) {
        await service.createNotification(_makeItem(id: 'item-$i'));
      }

      // The 11th should fail.
      expect(
        () => service.createNotification(_makeItem(id: 'item-10')),
        throwsA(isA<NotificationLimitException>()),
      );
    });

    test('premium user bypasses free tier limit', () async {
      for (var i = 0; i < 10; i++) {
        await premiumService.createNotification(_makeItem(id: 'item-$i'));
      }

      // 11th should succeed for premium users.
      await premiumService.createNotification(_makeItem(id: 'item-10'));
      final fetched = await premiumService.getById('item-10');
      expect(fetched, isNotNull);
    });
  });

  group('updateNotification', () {
    test('updates existing notification', () async {
      final item = _makeItem();
      await service.createNotification(item);

      final updated = item.copyWith(title: 'Updated Title');
      await service.updateNotification(updated);

      final fetched = await service.getById(item.id);
      expect(fetched!.title, equals('Updated Title'));
    });

    test('validates fields on update', () async {
      final item = _makeItem();
      await service.createNotification(item);

      final invalid = item.copyWith(title: '');
      expect(
        () => service.updateNotification(invalid),
        throwsA(isA<NotificationValidationException>()),
      );
    });
  });

  group('deleteNotification', () {
    test('removes notification', () async {
      final item = _makeItem();
      await service.createNotification(item);

      await service.deleteNotification(item.id);

      final fetched = await service.getById(item.id);
      expect(fetched, isNull);
    });
  });

  group('toggleActive', () {
    test('disables a notification', () async {
      final item = _makeItem();
      await service.createNotification(item);

      await service.toggleActive(item.id, isActive: false);

      final fetched = await service.getById(item.id);
      expect(fetched!.isActive, isFalse);
    });

    test('re-enables a notification within free tier limit', () async {
      final item = _makeItem();
      await service.createNotification(item);
      await service.toggleActive(item.id, isActive: false);

      await service.toggleActive(item.id, isActive: true);

      final fetched = await service.getById(item.id);
      expect(fetched!.isActive, isTrue);
    });

    test('re-enable fails when at free tier limit', () async {
      // Fill up the 10 active slots.
      for (var i = 0; i < 10; i++) {
        await service.createNotification(_makeItem(id: 'item-$i'));
      }

      // Disable one to make room, create 11th, so we still have 10 active.
      await service.toggleActive('item-0', isActive: false);
      await service.createNotification(_makeItem(id: 'item-10'));

      // Now 10 active. Re-enabling item-0 would make 11 — should fail.
      expect(
        () => service.toggleActive('item-0', isActive: true),
        throwsA(isA<NotificationLimitException>()),
      );
    });
  });

  group('getById', () {
    test('returns null for nonexistent ID', () async {
      final result = await service.getById('nonexistent');
      expect(result, isNull);
    });
  });
}
