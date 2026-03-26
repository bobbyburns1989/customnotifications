import 'package:freezed_annotation/freezed_annotation.dart';

import 'history_action.dart';

part 'history_entry.freezed.dart';
part 'history_entry.g.dart';

/// A record of a notification event (delivered, tapped, dismissed, snoozed).
///
/// Stores a snapshot of the notification's title and body at the time
/// of the event, so history remains accurate even if the notification
/// is later edited or deleted.
@freezed
class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry({
    /// Auto-increment primary key.
    required int id,

    /// The UUID of the notification this event relates to.
    required String notificationId,

    /// Snapshot of the notification title at fire time.
    required String title,

    /// Snapshot of the notification body at fire time.
    required String body,

    /// When this event occurred.
    required DateTime firedAt,

    /// What happened (delivered, tapped, dismissed, snoozed).
    required HistoryAction action,
  }) = _HistoryEntry;

  factory HistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryFromJson(json);
}
