import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_type.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

/// Core domain model for a user-created notification.
///
/// Uses a flat structure with nullable schedule-specific fields rather than
/// inheritance, which maps cleanly to a single SQLite table via Drift.
/// The [scheduleType] discriminator determines which optional fields are
/// relevant for a given instance.
@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    /// Unique identifier (UUID v4).
    required String id,

    /// Notification title shown to the user.
    required String title,

    /// Notification body text.
    required String body,

    /// Determines how this notification is scheduled.
    required ScheduleType scheduleType,

    /// The first/next fire time, stored as UTC.
    required DateTime scheduledAt,

    /// Whether this notification is currently active and being scheduled.
    @Default(true) bool isActive,

    /// When this notification was created.
    required DateTime createdAt,

    /// When this notification was last modified.
    required DateTime updatedAt,

    // --- Schedule-type-specific fields (nullable) ---

    /// For weekly: which days of the week to fire [1=Mon..7=Sun].
    List<int>? weekdays,

    /// For interval: minutes between each firing.
    int? intervalMinutes,

    /// For random: earliest minute-of-day (0-1439) for the random window.
    int? randomMinFrom,

    /// For random: latest minute-of-day (0-1439) for the random window.
    int? randomMinTo,

    /// For custom: cron-like expression (future use).
    String? cronExpression,

    // --- Appearance ---

    /// Custom sound filename from assets/sounds/ (null = default system sound).
    String? soundName,

    /// Icon identifier from a predefined set (null = default app icon).
    String? iconName,

    /// Notification accent color stored as an int (null = theme default).
    int? colorValue,

    // --- Behavior (premium features) ---

    /// If true, notification stays in tray until explicitly dismissed.
    @Default(false) bool isPersistent,

    /// Re-fire interval in minutes if user hasn't dismissed (null = off).
    int? naggingIntervalMinutes,

    /// Number of escalation re-fires before giving up (null = off).
    int? escalationSteps,

    /// Custom snooze duration in minutes (null = system default).
    int? snoozeMinutes,

    // --- Organization ---

    /// Optional category ID for grouping (future use).
    String? categoryId,

    /// Template ID if this was created from a template.
    String? templateId,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
