// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduleType: $enumDecode(_$ScheduleTypeEnumMap, json['scheduleType']),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      weekdays: (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      intervalMinutes: (json['intervalMinutes'] as num?)?.toInt(),
      randomMinFrom: (json['randomMinFrom'] as num?)?.toInt(),
      randomMinTo: (json['randomMinTo'] as num?)?.toInt(),
      cronExpression: json['cronExpression'] as String?,
      soundName: json['soundName'] as String?,
      iconName: json['iconName'] as String?,
      colorValue: (json['colorValue'] as num?)?.toInt(),
      isPersistent: json['isPersistent'] as bool? ?? false,
      naggingIntervalMinutes: (json['naggingIntervalMinutes'] as num?)?.toInt(),
      escalationSteps: (json['escalationSteps'] as num?)?.toInt(),
      snoozeMinutes: (json['snoozeMinutes'] as num?)?.toInt(),
      categoryId: json['categoryId'] as String?,
      templateId: json['templateId'] as String?,
    );

Map<String, dynamic> _$$NotificationItemImplToJson(
        _$NotificationItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'scheduleType': _$ScheduleTypeEnumMap[instance.scheduleType]!,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'weekdays': instance.weekdays,
      'intervalMinutes': instance.intervalMinutes,
      'randomMinFrom': instance.randomMinFrom,
      'randomMinTo': instance.randomMinTo,
      'cronExpression': instance.cronExpression,
      'soundName': instance.soundName,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'isPersistent': instance.isPersistent,
      'naggingIntervalMinutes': instance.naggingIntervalMinutes,
      'escalationSteps': instance.escalationSteps,
      'snoozeMinutes': instance.snoozeMinutes,
      'categoryId': instance.categoryId,
      'templateId': instance.templateId,
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.oneTime: 'oneTime',
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.interval: 'interval',
  ScheduleType.random: 'random',
  ScheduleType.custom: 'custom',
};
