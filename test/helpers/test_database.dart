import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:custom_notify/data/database/app_database.dart';
import 'package:custom_notify/data/database/daos/notification_dao.dart';
import 'package:custom_notify/data/database/daos/history_dao.dart';

/// Creates a fresh in-memory Drift database for each test.
///
/// The in-memory DB is destroyed when [db.close()] is called,
/// giving each test a clean slate. Uses NativeDatabase.memory()
/// which works on macOS/Linux/Windows host machines.
///
/// Suppresses Drift's "multiple databases" warning since tests
/// intentionally create many short-lived instances.
AppDatabase createTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase.forTesting(NativeDatabase.memory());
}

/// Convenience: creates DB + DAOs in one call.
/// Returns a record so tests can destructure what they need.
({AppDatabase db, NotificationDao notificationDao, HistoryDao historyDao})
    createTestDatabaseWithDaos() {
  final db = createTestDatabase();
  return (
    db: db,
    notificationDao: NotificationDao(db),
    historyDao: HistoryDao(db),
  );
}
