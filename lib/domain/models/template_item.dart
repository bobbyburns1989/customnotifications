import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_type.dart';

part 'template_item.freezed.dart';
part 'template_item.g.dart';

/// A pre-built notification template that users can tap to
/// quickly create a notification with pre-filled fields.
///
/// Templates are loaded from a bundled JSON asset (read-only).
/// Free tier users can access the first 10; the rest require premium.
@freezed
class TemplateItem with _$TemplateItem {
  const factory TemplateItem({
    required String id,
    required String title,
    required String body,
    required ScheduleType scheduleType,

    /// Category for grouping: "Health", "Work", "Personal", "Fitness", "Custom".
    required String category,

    /// Material icon name for display in the template gallery.
    required String iconName,

    /// Weekday integers [1–7] for weekly schedule templates.
    List<int>? weekdays,

    /// Interval in minutes for interval schedule templates.
    int? intervalMinutes,

    /// Whether this template requires a premium subscription.
    @Default(false) bool isPremium,
  }) = _TemplateItem;

  factory TemplateItem.fromJson(Map<String, dynamic> json) =>
      _$TemplateItemFromJson(json);
}
