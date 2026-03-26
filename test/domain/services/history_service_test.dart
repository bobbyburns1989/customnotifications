import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_notify/data/database/app_database.dart';
import 'package:custom_notify/data/database/mappers/notification_mapper.dart';
import 'package:custom_notify/domain/models/history_action.dart';
import 'package:custom_notify/domain/models/notification_item.dart';
import 'package:custom_notify/domain/models/schedule_type.dart';
import 'package:custom_notify/domain/services/history_service.dart';

import '../../helpers/test_database.dart';

void main() {
  group('HistoryService', () {
    test('records event with correct title and body snapshot', () async {
      final deps = createTestDatabaseWithDaos();
      final historyService = HistoryService(
        deps.historyDao,
        deps.notificationDao,
      );

      // Insert a notification so the service can snapshot its text.
      final now = DateTime.now().toUtc();
      final item = NotificationItem(
        id: 'notif-1',
        title: 'Take Medication',
        body: 'Time for your daily vitamins',
        scheduleType: ScheduleType.daily,
        scheduledAt: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
      await deps.notificationDao.insertItem(item.toCompanion());

      // Record a "delivered" event.
      await historyService.recordEvent('notif-1', HistoryAction.delivered);

      // Verify the history entry was created with the correct snapshot.
      final entries = await deps.historyDao.watchAll().first;
      expect(entries, hasLength(1));
      expect(entries.first.title, equals('Take Medication'));
      expect(entries.first.body, equals('Time for your daily vitamins'));
      expect(entries.first.action, equals('delivered'));
      expect(entries.first.notificationId, equals('notif-1'));
    });

    test('uses fallback text for deleted notification', () async {
      final deps = createTestDatabaseWithDaos();
      final historyService = HistoryService(
        deps.historyDao,
        deps.notificationDao,
      );

      // Record an event for a notification that doesn't exist in DB.
      await historyService.recordEvent('deleted-id', HistoryAction.tapped);

      final entries = await deps.historyDao.watchAll().first;
      expect(entries, hasLength(1));
      expect(entries.first.title, equals('Deleted notification'));
      expect(entries.first.body, equals(''));
    });

    test('records multiple event types for the same notification', () async {
      final deps = createTestDatabaseWithDaos();
      final historyService = HistoryService(
        deps.historyDao,
        deps.notificationDao,
      );

      final now = DateTime.now().toUtc();
      final item = NotificationItem(
        id: 'notif-2',
        title: 'Standup',
        body: 'Daily standup in 5 minutes',
        scheduleType: ScheduleType.daily,
        scheduledAt: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
      await deps.notificationDao.insertItem(item.toCompanion());

      await historyService.recordEvent('notif-2', HistoryAction.delivered);
      await historyService.recordEvent('notif-2', HistoryAction.tapped);

      final entries = await deps.historyDao.watchAll().first;
      expect(entries, hasLength(2));

      // Most recent first (tapped, then delivered).
      final actions = entries.map((e) => e.action).toList();
      expect(actions, contains('delivered'));
      expect(actions, contains('tapped'));
    });

    test('pruneOldEntries removes entries beyond retention period', () async {
      final deps = createTestDatabaseWithDaos();
      final historyService = HistoryService(
        deps.historyDao,
        deps.notificationDao,
      );

      // Insert an old entry directly (45 days ago).
      final oldDate = DateTime.now().toUtc().subtract(const Duration(days: 45));
      await deps.historyDao.insertEntry(
        HistoryEntriesCompanion(
          notificationId: const Value('old-notif'),
          title: const Value('Old notification'),
          body: const Value('This is old'),
          firedAt: Value(oldDate),
          action: const Value('delivered'),
        ),
      );

      // Insert a recent entry (1 day ago).
      final recentDate = DateTime.now().toUtc().subtract(const Duration(days: 1));
      await deps.historyDao.insertEntry(
        HistoryEntriesCompanion(
          notificationId: const Value('recent-notif'),
          title: const Value('Recent notification'),
          body: const Value('This is recent'),
          firedAt: Value(recentDate),
          action: const Value('tapped'),
        ),
      );

      // Prune with 30-day retention.
      final pruned = await historyService.pruneOldEntries(retentionDays: 30);
      expect(pruned, equals(1));

      // Only the recent entry should remain.
      final remaining = await deps.historyDao.watchAll().first;
      expect(remaining, hasLength(1));
      expect(remaining.first.title, equals('Recent notification'));
    });

    test('pruneOldEntries returns 0 when nothing to prune', () async {
      final deps = createTestDatabaseWithDaos();
      final historyService = HistoryService(
        deps.historyDao,
        deps.notificationDao,
      );

      // Insert a recent entry only.
      final recentDate = DateTime.now().toUtc().subtract(const Duration(days: 5));
      await deps.historyDao.insertEntry(
        HistoryEntriesCompanion(
          notificationId: const Value('recent-notif'),
          title: const Value('Recent'),
          body: const Value('Still fresh'),
          firedAt: Value(recentDate),
          action: const Value('delivered'),
        ),
      );

      final pruned = await historyService.pruneOldEntries(retentionDays: 30);
      expect(pruned, equals(0));

      final remaining = await deps.historyDao.watchAll().first;
      expect(remaining, hasLength(1));
    });
  });
}
