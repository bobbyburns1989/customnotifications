import 'package:drift/drift.dart';

/// Drift table definition for notification history entries.
///
/// Records events like delivered, tapped, dismissed, snoozed.
/// Stores a snapshot of title/body at fire time so history
/// remains accurate even after the notification is edited or deleted.
@DataClassName('HistoryEntryEntity')
class HistoryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get notificationId => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get firedAt => dateTime()();
  TextColumn get action => text()();
}
