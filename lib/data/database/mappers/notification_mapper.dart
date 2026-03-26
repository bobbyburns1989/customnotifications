import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/models/notification_item.dart' as domain;
import '../../../domain/models/schedule_type.dart';
import '../app_database.dart';

/// Converts between Drift-generated [NotificationItemEntity] and the
/// Freezed [domain.NotificationItem] domain model.
///
/// Handles:
/// - ScheduleType enum to/from string conversion
/// - Weekdays `List<int>` to/from JSON string conversion
/// - All nullable fields pass through directly
extension NotificationItemMapper on NotificationItemEntity {
  /// Convert a Drift data class to the Freezed domain model.
  domain.NotificationItem toDomain() {
    return domain.NotificationItem(
      id: id,
      title: title,
      body: body,
      scheduleType: ScheduleType.values.byName(scheduleType),
      scheduledAt: scheduledAt,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      weekdays: weekdays != null
          ? (jsonDecode(weekdays!) as List).cast<int>()
          : null,
      intervalMinutes: intervalMinutes,
      randomMinFrom: randomMinFrom,
      randomMinTo: randomMinTo,
      cronExpression: cronExpression,
      soundName: soundName,
      iconName: iconName,
      colorValue: colorValue,
      isPersistent: isPersistent,
      naggingIntervalMinutes: naggingIntervalMinutes,
      escalationSteps: escalationSteps,
      snoozeMinutes: snoozeMinutes,
      categoryId: categoryId,
      templateId: templateId,
    );
  }
}

/// Extension on the Freezed domain model to create a Drift companion
/// for insert/update operations.
extension NotificationItemToCompanion on domain.NotificationItem {
  /// Convert the Freezed domain model to a Drift companion for DB writes.
  NotificationItemsCompanion toCompanion() {
    return NotificationItemsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      scheduleType: Value(scheduleType.name),
      scheduledAt: Value(scheduledAt),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      weekdays: Value(weekdays != null ? jsonEncode(weekdays) : null),
      intervalMinutes: Value(intervalMinutes),
      randomMinFrom: Value(randomMinFrom),
      randomMinTo: Value(randomMinTo),
      cronExpression: Value(cronExpression),
      soundName: Value(soundName),
      iconName: Value(iconName),
      colorValue: Value(colorValue),
      isPersistent: Value(isPersistent),
      naggingIntervalMinutes: Value(naggingIntervalMinutes),
      escalationSteps: Value(escalationSteps),
      snoozeMinutes: Value(snoozeMinutes),
      categoryId: Value(categoryId),
      templateId: Value(templateId),
    );
  }
}
