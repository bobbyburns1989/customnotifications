import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/notification_items_table.dart';

part 'notification_dao.g.dart';

/// Data Access Object for notification CRUD operations.
///
/// All queries are Drift typed queries — no raw SQL.
/// Returns Drift-generated [NotificationItemEntity] data classes;
/// the mapper layer converts these to Freezed domain models.
@DriftAccessor(tables: [NotificationItems])
class NotificationDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationDaoMixin {
  NotificationDao(super.db);

  /// Watch all notifications, most recently created first.
  Stream<List<NotificationItemEntity>> watchAll() {
    return (select(notificationItems)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Watch only active notifications, sorted by next fire time.
  Stream<List<NotificationItemEntity>> watchActive() {
    return (select(notificationItems)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.scheduledAt, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  /// Get all active notifications as a one-shot query (for schedule sync).
  Future<List<NotificationItemEntity>> getActive() {
    return (select(notificationItems)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  /// Get a single notification by its UUID.
  Future<NotificationItemEntity?> getById(String id) {
    return (select(notificationItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert a new notification.
  Future<void> insertItem(NotificationItemsCompanion item) {
    return into(notificationItems).insert(item);
  }

  /// Update an existing notification.
  Future<void> updateItem(NotificationItemsCompanion item) {
    return (update(notificationItems)
          ..where((t) => t.id.equals(item.id.value)))
        .write(item);
  }

  /// Delete a notification by its UUID.
  Future<void> deleteItem(String id) {
    return (delete(notificationItems)..where((t) => t.id.equals(id))).go();
  }

  /// Toggle a notification's active state.
  Future<void> toggleActive(String id, {required bool isActive}) {
    return (update(notificationItems)..where((t) => t.id.equals(id))).write(
      NotificationItemsCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// Count the number of active notifications (for free tier limit check).
  Future<int> countActive() async {
    final count = notificationItems.id.count();
    final query = selectOnly(notificationItems)
      ..where(notificationItems.isActive.equals(true))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
