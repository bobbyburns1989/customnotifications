import 'package:drift/drift.dart';

import '../../core/utils/logger.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/history_dao.dart';
import '../../data/database/daos/notification_dao.dart';
import '../models/history_action.dart';

/// Records notification lifecycle events into the history table.
///
/// Called from notification plugin callbacks (tap, dismiss) and from
/// the schedule service when a notification fires. Snapshots the
/// notification's title and body at the time of the event so history
/// stays accurate even after edits or deletes.
class HistoryService {
  HistoryService(this._historyDao, this._notificationDao);

  final HistoryDao _historyDao;
  final NotificationDao _notificationDao;

  /// Record a history event for a notification.
  ///
  /// [notificationId] is the UUID of the NotificationItem.
  /// [action] is what happened (delivered, tapped, dismissed, snoozed).
  ///
  /// Looks up the notification to snapshot its current title/body. If the
  /// notification has been deleted, uses fallback values so the history
  /// entry is still recorded.
  Future<void> recordEvent(
    String notificationId,
    HistoryAction action,
  ) async {
    try {
      // Look up current notification for title/body snapshot.
      final entity = await _notificationDao.getById(notificationId);
      final title = entity?.title ?? 'Deleted notification';
      final body = entity?.body ?? '';

      await _historyDao.insertEntry(
        HistoryEntriesCompanion(
          notificationId: Value(notificationId),
          title: Value(title),
          body: Value(body),
          firedAt: Value(DateTime.now().toUtc()),
          action: Value(action.name),
        ),
      );

      Logger.info(
        'Recorded ${action.name} for $notificationId',
        tag: 'HistoryService',
      );
    } catch (e) {
      // Never let history recording crash the app.
      Logger.info(
        'Failed to record history: $e',
        tag: 'HistoryService',
      );
    }
  }

  /// Prune history entries older than [retentionDays].
  Future<int> pruneOldEntries({int retentionDays = 30}) async {
    final cutoff =
        DateTime.now().toUtc().subtract(Duration(days: retentionDays));
    return _historyDao.deleteOlderThan(cutoff);
  }
}
