// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) {
  return _NotificationItem.fromJson(json);
}

/// @nodoc
mixin _$NotificationItem {
  /// Unique identifier (UUID v4).
  String get id => throw _privateConstructorUsedError;

  /// Notification title shown to the user.
  String get title => throw _privateConstructorUsedError;

  /// Notification body text.
  String get body => throw _privateConstructorUsedError;

  /// Determines how this notification is scheduled.
  ScheduleType get scheduleType => throw _privateConstructorUsedError;

  /// The first/next fire time, stored as UTC.
  DateTime get scheduledAt => throw _privateConstructorUsedError;

  /// Whether this notification is currently active and being scheduled.
  bool get isActive => throw _privateConstructorUsedError;

  /// When this notification was created.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When this notification was last modified.
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // --- Schedule-type-specific fields (nullable) ---
  /// For weekly: which days of the week to fire [1=Mon..7=Sun].
  List<int>? get weekdays => throw _privateConstructorUsedError;

  /// For interval: minutes between each firing.
  int? get intervalMinutes => throw _privateConstructorUsedError;

  /// For random: earliest minute-of-day (0-1439) for the random window.
  int? get randomMinFrom => throw _privateConstructorUsedError;

  /// For random: latest minute-of-day (0-1439) for the random window.
  int? get randomMinTo => throw _privateConstructorUsedError;

  /// For custom: cron-like expression (future use).
  String? get cronExpression =>
      throw _privateConstructorUsedError; // --- Appearance ---
  /// Custom sound filename from assets/sounds/ (null = default system sound).
  String? get soundName => throw _privateConstructorUsedError;

  /// Icon identifier from a predefined set (null = default app icon).
  String? get iconName => throw _privateConstructorUsedError;

  /// Notification accent color stored as an int (null = theme default).
  int? get colorValue =>
      throw _privateConstructorUsedError; // --- Behavior (premium features) ---
  /// If true, notification stays in tray until explicitly dismissed.
  bool get isPersistent => throw _privateConstructorUsedError;

  /// Re-fire interval in minutes if user hasn't dismissed (null = off).
  int? get naggingIntervalMinutes => throw _privateConstructorUsedError;

  /// Number of escalation re-fires before giving up (null = off).
  int? get escalationSteps => throw _privateConstructorUsedError;

  /// Custom snooze duration in minutes (null = system default).
  int? get snoozeMinutes =>
      throw _privateConstructorUsedError; // --- Organization ---
  /// Optional category ID for grouping (future use).
  String? get categoryId => throw _privateConstructorUsedError;

  /// Template ID if this was created from a template.
  String? get templateId => throw _privateConstructorUsedError;

  /// Serializes this NotificationItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationItemCopyWith<NotificationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationItemCopyWith<$Res> {
  factory $NotificationItemCopyWith(
          NotificationItem value, $Res Function(NotificationItem) then) =
      _$NotificationItemCopyWithImpl<$Res, NotificationItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      ScheduleType scheduleType,
      DateTime scheduledAt,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      List<int>? weekdays,
      int? intervalMinutes,
      int? randomMinFrom,
      int? randomMinTo,
      String? cronExpression,
      String? soundName,
      String? iconName,
      int? colorValue,
      bool isPersistent,
      int? naggingIntervalMinutes,
      int? escalationSteps,
      int? snoozeMinutes,
      String? categoryId,
      String? templateId});
}

/// @nodoc
class _$NotificationItemCopyWithImpl<$Res, $Val extends NotificationItem>
    implements $NotificationItemCopyWith<$Res> {
  _$NotificationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduleType = null,
    Object? scheduledAt = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? weekdays = freezed,
    Object? intervalMinutes = freezed,
    Object? randomMinFrom = freezed,
    Object? randomMinTo = freezed,
    Object? cronExpression = freezed,
    Object? soundName = freezed,
    Object? iconName = freezed,
    Object? colorValue = freezed,
    Object? isPersistent = null,
    Object? naggingIntervalMinutes = freezed,
    Object? escalationSteps = freezed,
    Object? snoozeMinutes = freezed,
    Object? categoryId = freezed,
    Object? templateId = freezed,
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
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekdays: freezed == weekdays
          ? _value.weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      intervalMinutes: freezed == intervalMinutes
          ? _value.intervalMinutes
          : intervalMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      randomMinFrom: freezed == randomMinFrom
          ? _value.randomMinFrom
          : randomMinFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      randomMinTo: freezed == randomMinTo
          ? _value.randomMinTo
          : randomMinTo // ignore: cast_nullable_to_non_nullable
              as int?,
      cronExpression: freezed == cronExpression
          ? _value.cronExpression
          : cronExpression // ignore: cast_nullable_to_non_nullable
              as String?,
      soundName: freezed == soundName
          ? _value.soundName
          : soundName // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
      isPersistent: null == isPersistent
          ? _value.isPersistent
          : isPersistent // ignore: cast_nullable_to_non_nullable
              as bool,
      naggingIntervalMinutes: freezed == naggingIntervalMinutes
          ? _value.naggingIntervalMinutes
          : naggingIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      escalationSteps: freezed == escalationSteps
          ? _value.escalationSteps
          : escalationSteps // ignore: cast_nullable_to_non_nullable
              as int?,
      snoozeMinutes: freezed == snoozeMinutes
          ? _value.snoozeMinutes
          : snoozeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationItemImplCopyWith<$Res>
    implements $NotificationItemCopyWith<$Res> {
  factory _$$NotificationItemImplCopyWith(_$NotificationItemImpl value,
          $Res Function(_$NotificationItemImpl) then) =
      __$$NotificationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      ScheduleType scheduleType,
      DateTime scheduledAt,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      List<int>? weekdays,
      int? intervalMinutes,
      int? randomMinFrom,
      int? randomMinTo,
      String? cronExpression,
      String? soundName,
      String? iconName,
      int? colorValue,
      bool isPersistent,
      int? naggingIntervalMinutes,
      int? escalationSteps,
      int? snoozeMinutes,
      String? categoryId,
      String? templateId});
}

/// @nodoc
class __$$NotificationItemImplCopyWithImpl<$Res>
    extends _$NotificationItemCopyWithImpl<$Res, _$NotificationItemImpl>
    implements _$$NotificationItemImplCopyWith<$Res> {
  __$$NotificationItemImplCopyWithImpl(_$NotificationItemImpl _value,
      $Res Function(_$NotificationItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduleType = null,
    Object? scheduledAt = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? weekdays = freezed,
    Object? intervalMinutes = freezed,
    Object? randomMinFrom = freezed,
    Object? randomMinTo = freezed,
    Object? cronExpression = freezed,
    Object? soundName = freezed,
    Object? iconName = freezed,
    Object? colorValue = freezed,
    Object? isPersistent = null,
    Object? naggingIntervalMinutes = freezed,
    Object? escalationSteps = freezed,
    Object? snoozeMinutes = freezed,
    Object? categoryId = freezed,
    Object? templateId = freezed,
  }) {
    return _then(_$NotificationItemImpl(
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
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekdays: freezed == weekdays
          ? _value._weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      intervalMinutes: freezed == intervalMinutes
          ? _value.intervalMinutes
          : intervalMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      randomMinFrom: freezed == randomMinFrom
          ? _value.randomMinFrom
          : randomMinFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      randomMinTo: freezed == randomMinTo
          ? _value.randomMinTo
          : randomMinTo // ignore: cast_nullable_to_non_nullable
              as int?,
      cronExpression: freezed == cronExpression
          ? _value.cronExpression
          : cronExpression // ignore: cast_nullable_to_non_nullable
              as String?,
      soundName: freezed == soundName
          ? _value.soundName
          : soundName // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
      isPersistent: null == isPersistent
          ? _value.isPersistent
          : isPersistent // ignore: cast_nullable_to_non_nullable
              as bool,
      naggingIntervalMinutes: freezed == naggingIntervalMinutes
          ? _value.naggingIntervalMinutes
          : naggingIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      escalationSteps: freezed == escalationSteps
          ? _value.escalationSteps
          : escalationSteps // ignore: cast_nullable_to_non_nullable
              as int?,
      snoozeMinutes: freezed == snoozeMinutes
          ? _value.snoozeMinutes
          : snoozeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationItemImpl implements _NotificationItem {
  const _$NotificationItemImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.scheduleType,
      required this.scheduledAt,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      final List<int>? weekdays,
      this.intervalMinutes,
      this.randomMinFrom,
      this.randomMinTo,
      this.cronExpression,
      this.soundName,
      this.iconName,
      this.colorValue,
      this.isPersistent = false,
      this.naggingIntervalMinutes,
      this.escalationSteps,
      this.snoozeMinutes,
      this.categoryId,
      this.templateId})
      : _weekdays = weekdays;

  factory _$NotificationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationItemImplFromJson(json);

  /// Unique identifier (UUID v4).
  @override
  final String id;

  /// Notification title shown to the user.
  @override
  final String title;

  /// Notification body text.
  @override
  final String body;

  /// Determines how this notification is scheduled.
  @override
  final ScheduleType scheduleType;

  /// The first/next fire time, stored as UTC.
  @override
  final DateTime scheduledAt;

  /// Whether this notification is currently active and being scheduled.
  @override
  @JsonKey()
  final bool isActive;

  /// When this notification was created.
  @override
  final DateTime createdAt;

  /// When this notification was last modified.
  @override
  final DateTime updatedAt;
// --- Schedule-type-specific fields (nullable) ---
  /// For weekly: which days of the week to fire [1=Mon..7=Sun].
  final List<int>? _weekdays;
// --- Schedule-type-specific fields (nullable) ---
  /// For weekly: which days of the week to fire [1=Mon..7=Sun].
  @override
  List<int>? get weekdays {
    final value = _weekdays;
    if (value == null) return null;
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// For interval: minutes between each firing.
  @override
  final int? intervalMinutes;

  /// For random: earliest minute-of-day (0-1439) for the random window.
  @override
  final int? randomMinFrom;

  /// For random: latest minute-of-day (0-1439) for the random window.
  @override
  final int? randomMinTo;

  /// For custom: cron-like expression (future use).
  @override
  final String? cronExpression;
// --- Appearance ---
  /// Custom sound filename from assets/sounds/ (null = default system sound).
  @override
  final String? soundName;

  /// Icon identifier from a predefined set (null = default app icon).
  @override
  final String? iconName;

  /// Notification accent color stored as an int (null = theme default).
  @override
  final int? colorValue;
// --- Behavior (premium features) ---
  /// If true, notification stays in tray until explicitly dismissed.
  @override
  @JsonKey()
  final bool isPersistent;

  /// Re-fire interval in minutes if user hasn't dismissed (null = off).
  @override
  final int? naggingIntervalMinutes;

  /// Number of escalation re-fires before giving up (null = off).
  @override
  final int? escalationSteps;

  /// Custom snooze duration in minutes (null = system default).
  @override
  final int? snoozeMinutes;
// --- Organization ---
  /// Optional category ID for grouping (future use).
  @override
  final String? categoryId;

  /// Template ID if this was created from a template.
  @override
  final String? templateId;

  @override
  String toString() {
    return 'NotificationItem(id: $id, title: $title, body: $body, scheduleType: $scheduleType, scheduledAt: $scheduledAt, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, weekdays: $weekdays, intervalMinutes: $intervalMinutes, randomMinFrom: $randomMinFrom, randomMinTo: $randomMinTo, cronExpression: $cronExpression, soundName: $soundName, iconName: $iconName, colorValue: $colorValue, isPersistent: $isPersistent, naggingIntervalMinutes: $naggingIntervalMinutes, escalationSteps: $escalationSteps, snoozeMinutes: $snoozeMinutes, categoryId: $categoryId, templateId: $templateId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.scheduleType, scheduleType) ||
                other.scheduleType == scheduleType) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays) &&
            (identical(other.intervalMinutes, intervalMinutes) ||
                other.intervalMinutes == intervalMinutes) &&
            (identical(other.randomMinFrom, randomMinFrom) ||
                other.randomMinFrom == randomMinFrom) &&
            (identical(other.randomMinTo, randomMinTo) ||
                other.randomMinTo == randomMinTo) &&
            (identical(other.cronExpression, cronExpression) ||
                other.cronExpression == cronExpression) &&
            (identical(other.soundName, soundName) ||
                other.soundName == soundName) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.isPersistent, isPersistent) ||
                other.isPersistent == isPersistent) &&
            (identical(other.naggingIntervalMinutes, naggingIntervalMinutes) ||
                other.naggingIntervalMinutes == naggingIntervalMinutes) &&
            (identical(other.escalationSteps, escalationSteps) ||
                other.escalationSteps == escalationSteps) &&
            (identical(other.snoozeMinutes, snoozeMinutes) ||
                other.snoozeMinutes == snoozeMinutes) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        body,
        scheduleType,
        scheduledAt,
        isActive,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_weekdays),
        intervalMinutes,
        randomMinFrom,
        randomMinTo,
        cronExpression,
        soundName,
        iconName,
        colorValue,
        isPersistent,
        naggingIntervalMinutes,
        escalationSteps,
        snoozeMinutes,
        categoryId,
        templateId
      ]);

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationItemImplCopyWith<_$NotificationItemImpl> get copyWith =>
      __$$NotificationItemImplCopyWithImpl<_$NotificationItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationItemImplToJson(
      this,
    );
  }
}

abstract class _NotificationItem implements NotificationItem {
  const factory _NotificationItem(
      {required final String id,
      required final String title,
      required final String body,
      required final ScheduleType scheduleType,
      required final DateTime scheduledAt,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<int>? weekdays,
      final int? intervalMinutes,
      final int? randomMinFrom,
      final int? randomMinTo,
      final String? cronExpression,
      final String? soundName,
      final String? iconName,
      final int? colorValue,
      final bool isPersistent,
      final int? naggingIntervalMinutes,
      final int? escalationSteps,
      final int? snoozeMinutes,
      final String? categoryId,
      final String? templateId}) = _$NotificationItemImpl;

  factory _NotificationItem.fromJson(Map<String, dynamic> json) =
      _$NotificationItemImpl.fromJson;

  /// Unique identifier (UUID v4).
  @override
  String get id;

  /// Notification title shown to the user.
  @override
  String get title;

  /// Notification body text.
  @override
  String get body;

  /// Determines how this notification is scheduled.
  @override
  ScheduleType get scheduleType;

  /// The first/next fire time, stored as UTC.
  @override
  DateTime get scheduledAt;

  /// Whether this notification is currently active and being scheduled.
  @override
  bool get isActive;

  /// When this notification was created.
  @override
  DateTime get createdAt;

  /// When this notification was last modified.
  @override
  DateTime get updatedAt; // --- Schedule-type-specific fields (nullable) ---
  /// For weekly: which days of the week to fire [1=Mon..7=Sun].
  @override
  List<int>? get weekdays;

  /// For interval: minutes between each firing.
  @override
  int? get intervalMinutes;

  /// For random: earliest minute-of-day (0-1439) for the random window.
  @override
  int? get randomMinFrom;

  /// For random: latest minute-of-day (0-1439) for the random window.
  @override
  int? get randomMinTo;

  /// For custom: cron-like expression (future use).
  @override
  String? get cronExpression; // --- Appearance ---
  /// Custom sound filename from assets/sounds/ (null = default system sound).
  @override
  String? get soundName;

  /// Icon identifier from a predefined set (null = default app icon).
  @override
  String? get iconName;

  /// Notification accent color stored as an int (null = theme default).
  @override
  int? get colorValue; // --- Behavior (premium features) ---
  /// If true, notification stays in tray until explicitly dismissed.
  @override
  bool get isPersistent;

  /// Re-fire interval in minutes if user hasn't dismissed (null = off).
  @override
  int? get naggingIntervalMinutes;

  /// Number of escalation re-fires before giving up (null = off).
  @override
  int? get escalationSteps;

  /// Custom snooze duration in minutes (null = system default).
  @override
  int? get snoozeMinutes; // --- Organization ---
  /// Optional category ID for grouping (future use).
  @override
  String? get categoryId;

  /// Template ID if this was created from a template.
  @override
  String? get templateId;

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationItemImplCopyWith<_$NotificationItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
