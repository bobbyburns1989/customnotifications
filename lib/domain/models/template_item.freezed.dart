// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateItem _$TemplateItemFromJson(Map<String, dynamic> json) {
  return _TemplateItem.fromJson(json);
}

/// @nodoc
mixin _$TemplateItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  ScheduleType get scheduleType => throw _privateConstructorUsedError;

  /// Category for grouping: "Health", "Work", "Personal", "Fitness", "Custom".
  String get category => throw _privateConstructorUsedError;

  /// Material icon name for display in the template gallery.
  String get iconName => throw _privateConstructorUsedError;

  /// Weekday integers [1–7] for weekly schedule templates.
  List<int>? get weekdays => throw _privateConstructorUsedError;

  /// Interval in minutes for interval schedule templates.
  int? get intervalMinutes => throw _privateConstructorUsedError;

  /// Whether this template requires a premium subscription.
  bool get isPremium => throw _privateConstructorUsedError;

  /// Serializes this TemplateItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateItemCopyWith<TemplateItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateItemCopyWith<$Res> {
  factory $TemplateItemCopyWith(
          TemplateItem value, $Res Function(TemplateItem) then) =
      _$TemplateItemCopyWithImpl<$Res, TemplateItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      ScheduleType scheduleType,
      String category,
      String iconName,
      List<int>? weekdays,
      int? intervalMinutes,
      bool isPremium});
}

/// @nodoc
class _$TemplateItemCopyWithImpl<$Res, $Val extends TemplateItem>
    implements $TemplateItemCopyWith<$Res> {
  _$TemplateItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduleType = null,
    Object? category = null,
    Object? iconName = null,
    Object? weekdays = freezed,
    Object? intervalMinutes = freezed,
    Object? isPremium = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleType: null == scheduleType
          ? _value.scheduleType
          : scheduleType // ignore: cast_nullable_to_non_nullable
              as ScheduleType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      weekdays: freezed == weekdays
          ? _value.weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      intervalMinutes: freezed == intervalMinutes
          ? _value.intervalMinutes
          : intervalMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateItemImplCopyWith<$Res>
    implements $TemplateItemCopyWith<$Res> {
  factory _$$TemplateItemImplCopyWith(
          _$TemplateItemImpl value, $Res Function(_$TemplateItemImpl) then) =
      __$$TemplateItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      ScheduleType scheduleType,
      String category,
      String iconName,
      List<int>? weekdays,
      int? intervalMinutes,
      bool isPremium});
}

/// @nodoc
class __$$TemplateItemImplCopyWithImpl<$Res>
    extends _$TemplateItemCopyWithImpl<$Res, _$TemplateItemImpl>
    implements _$$TemplateItemImplCopyWith<$Res> {
  __$$TemplateItemImplCopyWithImpl(
      _$TemplateItemImpl _value, $Res Function(_$TemplateItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduleType = null,
    Object? category = null,
    Object? iconName = null,
    Object? weekdays = freezed,
    Object? intervalMinutes = freezed,
    Object? isPremium = null,
  }) {
    return _then(_$TemplateItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleType: null == scheduleType
          ? _value.scheduleType
          : scheduleType // ignore: cast_nullable_to_non_nullable
              as ScheduleType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      weekdays: freezed == weekdays
          ? _value._weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      intervalMinutes: freezed == intervalMinutes
          ? _value.intervalMinutes
          : intervalMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateItemImpl implements _TemplateItem {
  const _$TemplateItemImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.scheduleType,
      required this.category,
      required this.iconName,
      final List<int>? weekdays,
      this.intervalMinutes,
      this.isPremium = false})
      : _weekdays = weekdays;

  factory _$TemplateItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final ScheduleType scheduleType;

  /// Category for grouping: "Health", "Work", "Personal", "Fitness", "Custom".
  @override
  final String category;

  /// Material icon name for display in the template gallery.
  @override
  final String iconName;

  /// Weekday integers [1–7] for weekly schedule templates.
  final List<int>? _weekdays;

  /// Weekday integers [1–7] for weekly schedule templates.
  @override
  List<int>? get weekdays {
    final value = _weekdays;
    if (value == null) return null;
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Interval in minutes for interval schedule templates.
  @override
  final int? intervalMinutes;

  /// Whether this template requires a premium subscription.
  @override
  @JsonKey()
  final bool isPremium;

  @override
  String toString() {
    return 'TemplateItem(id: $id, title: $title, body: $body, scheduleType: $scheduleType, category: $category, iconName: $iconName, weekdays: $weekdays, intervalMinutes: $intervalMinutes, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.scheduleType, scheduleType) ||
                other.scheduleType == scheduleType) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays) &&
            (identical(other.intervalMinutes, intervalMinutes) ||
                other.intervalMinutes == intervalMinutes) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      body,
      scheduleType,
      category,
      iconName,
      const DeepCollectionEquality().hash(_weekdays),
      intervalMinutes,
      isPremium);

  /// Create a copy of TemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateItemImplCopyWith<_$TemplateItemImpl> get copyWith =>
      __$$TemplateItemImplCopyWithImpl<_$TemplateItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateItemImplToJson(
      this,
    );
  }
}

abstract class _TemplateItem implements TemplateItem {
  const factory _TemplateItem(
      {required final String id,
      required final String title,
      required final String body,
      required final ScheduleType scheduleType,
      required final String category,
      required final String iconName,
      final List<int>? weekdays,
      final int? intervalMinutes,
      final bool isPremium}) = _$TemplateItemImpl;

  factory _TemplateItem.fromJson(Map<String, dynamic> json) =
      _$TemplateItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  ScheduleType get scheduleType;

  /// Category for grouping: "Health", "Work", "Personal", "Fitness", "Custom".
  @override
  String get category;

  /// Material icon name for display in the template gallery.
  @override
  String get iconName;

  /// Weekday integers [1–7] for weekly schedule templates.
  @override
  List<int>? get weekdays;

  /// Interval in minutes for interval schedule templates.
  @override
  int? get intervalMinutes;

  /// Whether this template requires a premium subscription.
  @override
  bool get isPremium;

  /// Create a copy of TemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateItemImplCopyWith<_$TemplateItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
