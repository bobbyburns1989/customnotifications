import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/daos/history_dao.dart';
import '../../data/database/daos/notification_dao.dart';
import '../../data/services/notification_plugin_service.dart';
import '../../domain/services/history_service.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/services/schedule_service.dart';
import 'premium_provider.dart';

/// Singleton database instance. Created once and shared across the app.
/// Automatically closed when the ProviderScope is disposed.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provides the NotificationDao for notification CRUD operations.
final notificationDaoProvider = Provider<NotificationDao>((ref) {
  return ref.watch(databaseProvider).notificationDao;
});

/// Provides the HistoryDao for history read/write operations.
final historyDaoProvider = Provider<HistoryDao>((ref) {
  return ref.watch(databaseProvider).historyDao;
});

/// Provides the notification plugin service singleton.
/// Initialized in main() before runApp, so it's always ready.
final notificationPluginProvider = Provider<NotificationPluginService>((ref) {
  return NotificationPluginService.instance;
});

/// Provides the ScheduleService (rolling window scheduler).
/// Depends on the plugin service (OS bridge) and the DAO (DB reads).
final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService(
    ref.watch(notificationPluginProvider),
    ref.watch(notificationDaoProvider),
  );
});

/// Provides the HistoryService for recording notification lifecycle events.
final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService(
    ref.watch(historyDaoProvider),
    ref.watch(notificationDaoProvider),
  );
});

/// Provides the NotificationService for business logic operations.
/// Wraps the DAO with validation, free tier limit enforcement,
/// and triggers OS schedule sync after every mutation.
/// Provides the current count of pending OS notifications.
/// Auto-disposes so it refreshes each time the Settings screen is visited.
final pendingCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(notificationPluginProvider).getPendingCount();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  // Watch premium status so the service rebuilds when subscription changes.
  // Defaults to false if the stream hasn't emitted yet (safe fallback).
  final isPremium = ref.watch(premiumStatusProvider).valueOrNull ?? false;

  return NotificationService(
    ref.watch(notificationDaoProvider),
    ref.watch(scheduleServiceProvider),
    ref.watch(notificationPluginProvider),
    isPremium: isPremium,
  );
});
