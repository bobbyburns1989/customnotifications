// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateItemImpl _$$TemplateItemImplFromJson(Map<String, dynamic> json) =>
    _$TemplateItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduleType: $enumDecode(_$ScheduleTypeEnumMap, json['scheduleType']),
      category: json['category'] as String,
      iconName: json['iconName'] as String,
      weekdays: (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      intervalMinutes: (json['intervalMinutes'] as num?)?.toInt(),
      isPremium: json['isPremium'] as bool? ?? false,
    );

Map<String, dynamic> _$$TemplateItemImplToJson(_$TemplateItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'scheduleType': _$ScheduleTypeEnumMap[instance.scheduleType]!,
      'category': instance.category,
      'iconName': instance.iconName,
      'weekdays': instance.weekdays,
      'intervalMinutes': instance.intervalMinutes,
      'isPremium': instance.isPremium,
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.oneTime: 'oneTime',
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.interval: 'interval',
  ScheduleType.random: 'random',
  ScheduleType.custom: 'custom',
};
