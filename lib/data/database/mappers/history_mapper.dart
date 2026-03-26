import 'package:drift/drift.dart';

import '../../../domain/models/history_action.dart';
import '../../../domain/models/history_entry.dart' as domain;
import '../app_database.dart';

/// Converts between Drift-generated [HistoryEntryEntity] and the
/// Freezed [domain.HistoryEntry] domain model.
extension HistoryEntryMapper on HistoryEntryEntity {
  /// Convert a Drift data class to the Freezed domain model.
  domain.HistoryEntry toDomain() {
    return domain.HistoryEntry(
      id: id,
      notificationId: notificationId,
      title: title,
      body: body,
      firedAt: firedAt,
      action: HistoryAction.values.byName(action),
    );
  }
}

/// Extension on the Freezed domain model to create a Drift companion
/// for insert operations.
/// Note: [id] uses Value.absent() so the auto-increment takes effect.
extension HistoryEntryToCompanion on domain.HistoryEntry {
  /// Convert to a Drift companion for DB inserts.
  HistoryEntriesCompanion toCompanion() {
    return HistoryEntriesCompanion(
      id: const Value.absent(),
      notificationId: Value(notificationId),
      title: Value(title),
      body: Value(body),
      firedAt: Value(firedAt),
      action: Value(action.name),
    );
  }
}
