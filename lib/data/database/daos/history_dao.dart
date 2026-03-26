import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/history_entries_table.dart';

part 'history_dao.g.dart';

/// Data Access Object for notification history operations.
///
/// History entries are immutable once created. The only mutations are
/// inserting new entries and pruning old ones.
@DriftAccessor(tables: [HistoryEntries])
class HistoryDao extends DatabaseAccessor<AppDatabase>
    with _$HistoryDaoMixin {
  HistoryDao(super.db);

  /// Watch recent history entries, newest first.
  /// [limit] caps the result set to avoid loading thousands of rows.
  Stream<List<HistoryEntryEntity>> watchAll({int limit = 200}) {
    return (select(historyEntries)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.firedAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch();
  }

  /// Watch history for a specific notification.
  Stream<List<HistoryEntryEntity>> watchForNotification(
      String notificationId) {
    return (select(historyEntries)
          ..where((t) => t.notificationId.equals(notificationId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.firedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Insert a new history entry.
  Future<void> insertEntry(HistoryEntriesCompanion entry) {
    return into(historyEntries).insert(entry);
  }

  /// Delete history entries older than [cutoff] to keep the DB lean.
  /// Default retention: 30 days.
  Future<int> deleteOlderThan(DateTime cutoff) {
    return (delete(historyEntries)
          ..where((t) => t.firedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Count total history entries (for analytics).
  Future<int> countAll() async {
    final count = historyEntries.id.count();
    final query = selectOnly(historyEntries)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
