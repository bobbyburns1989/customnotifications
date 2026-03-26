import 'package:drift/drift.dart';

/// Drift table definition for notification items.
///
/// Maps 1:1 to the [NotificationItem] Freezed model. Schedule-type-specific
/// fields are nullable since only certain fields apply to each schedule type.
/// Weekdays are stored as a JSON string (e.g., "[1,3,5]") and parsed by the
/// mapper layer.
@DataClassName('NotificationItemEntity')
class NotificationItems extends Table {
  // --- Core fields ---
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get body => text().withLength(min: 1, max: 1000)();
  TextColumn get scheduleType => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // --- Schedule-type-specific (nullable) ---
  TextColumn get weekdays => text().nullable()();
  IntColumn get intervalMinutes => integer().nullable()();
  IntColumn get randomMinFrom => integer().nullable()();
  IntColumn get randomMinTo => integer().nullable()();
  TextColumn get cronExpression => text().nullable()();

  // --- Appearance ---
  TextColumn get soundName => text().nullable()();
  TextColumn get iconName => text().nullable()();
  IntColumn get colorValue => integer().nullable()();

  // --- Behavior (premium) ---
  BoolColumn get isPersistent =>
      boolean().withDefault(const Constant(false))();
  IntColumn get naggingIntervalMinutes => integer().nullable()();
  IntColumn get escalationSteps => integer().nullable()();
  IntColumn get snoozeMinutes => integer().nullable()();

  // --- Organization ---
  TextColumn get categoryId => text().nullable()();
  TextColumn get templateId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
