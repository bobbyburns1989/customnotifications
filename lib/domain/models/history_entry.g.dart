// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryEntryImpl _$$HistoryEntryImplFromJson(Map<String, dynamic> json) =>
    _$HistoryEntryImpl(
      id: (json['id'] as num).toInt(),
      notificationId: json['notificationId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      firedAt: DateTime.parse(json['firedAt'] as String),
      action: $enumDecode(_$HistoryActionEnumMap, json['action']),
    );

Map<String, dynamic> _$$HistoryEntryImplToJson(_$HistoryEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notificationId': instance.notificationId,
      'title': instance.title,
      'body': instance.body,
      'firedAt': instance.firedAt.toIso8601String(),
      'action': _$HistoryActionEnumMap[instance.action]!,
    };

const _$HistoryActionEnumMap = {
  HistoryAction.delivered: 'delivered',
  HistoryAction.tapped: 'tapped',
  HistoryAction.dismissed: 'dismissed',
  HistoryAction.snoozed: 'snoozed',
};
