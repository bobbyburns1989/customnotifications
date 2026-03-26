import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/history_dao.dart';
import 'daos/notification_dao.dart';
import 'tables/history_entries_table.dart';
import 'tables/notification_items_table.dart';

part 'app_database.g.dart';

/// The single Drift database for the CustomNotify app.
///
/// Contains two tables:
/// - [NotificationItems] — user-created notifications with scheduling data
/// - [HistoryEntries] — log of notification events (delivered, tapped, etc.)
///
/// Database file is stored in the app's documents directory and opened
/// on a background isolate via [NativeDatabase.createInBackground] for
/// non-blocking I/O.
@DriftDatabase(
  tables: [NotificationItems, HistoryEntries],
  daos: [NotificationDao, HistoryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing: accept an in-memory executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  /// Opens a native SQLite connection on a background isolate.
  /// The DB file lives at `documents/custom_notify.sqlite`.
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'custom_notify.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
