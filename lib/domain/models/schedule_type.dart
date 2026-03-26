/// All supported notification schedule types.
///
/// Free tier gets oneTime, daily, weekly.
/// Premium tier unlocks interval, random, custom.
enum ScheduleType {
  oneTime,
  daily,
  weekly,
  interval,
  random,
  custom;

  /// Whether this schedule type requires a premium subscription.
  bool get isPremium => switch (this) {
        ScheduleType.oneTime ||
        ScheduleType.daily ||
        ScheduleType.weekly =>
          false,
        _ => true,
      };

  /// Human-readable label for display in the UI.
  String get label => switch (this) {
        ScheduleType.oneTime => 'One Time',
        ScheduleType.daily => 'Daily',
        ScheduleType.weekly => 'Weekly',
        ScheduleType.interval => 'Interval',
        ScheduleType.random => 'Random',
        ScheduleType.custom => 'Custom',
      };
}
