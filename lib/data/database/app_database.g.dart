// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotificationItemsTable extends NotificationItems
    with TableInfo<$NotificationItemsTable, NotificationItemEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _weekdaysMeta =
      const VerificationMeta('weekdays');
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
      'weekdays', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _intervalMinutesMeta =
      const VerificationMeta('intervalMinutes');
  @override
  late final GeneratedColumn<int> intervalMinutes = GeneratedColumn<int>(
      'interval_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _randomMinFromMeta =
      const VerificationMeta('randomMinFrom');
  @override
  late final GeneratedColumn<int> randomMinFrom = GeneratedColumn<int>(
      'random_min_from', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _randomMinToMeta =
      const VerificationMeta('randomMinTo');
  @override
  late final GeneratedColumn<int> randomMinTo = GeneratedColumn<int>(
      'random_min_to', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cronExpressionMeta =
      const VerificationMeta('cronExpression');
  @override
  late final GeneratedColumn<String> cronExpression = GeneratedColumn<String>(
      'cron_expression', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _soundNameMeta =
      const VerificationMeta('soundName');
  @override
  late final GeneratedColumn<String> soundName = GeneratedColumn<String>(
      'sound_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isPersistentMeta =
      const VerificationMeta('isPersistent');
  @override
  late final GeneratedColumn<bool> isPersistent = GeneratedColumn<bool>(
      'is_persistent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_persistent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _naggingIntervalMinutesMeta =
      const VerificationMeta('naggingIntervalMinutes');
  @override
  late final GeneratedColumn<int> naggingIntervalMinutes = GeneratedColumn<int>(
      'nagging_interval_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _escalationStepsMeta =
      const VerificationMeta('escalationSteps');
  @override
  late final GeneratedColumn<int> escalationSteps = GeneratedColumn<int>(
      'escalation_steps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _snoozeMinutesMeta =
      const VerificationMeta('snoozeMinutes');
  @override
  late final GeneratedColumn<int> snoozeMinutes = GeneratedColumn<int>(
      'snooze_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        body,
        scheduleType,
        scheduledAt,
        isActive,
        createdAt,
        updatedAt,
        weekdays,
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
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationItemEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(_weekdaysMeta,
          weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta));
    }
    if (data.containsKey('interval_minutes')) {
      context.handle(
          _intervalMinutesMeta,
          intervalMinutes.isAcceptableOrUnknown(
              data['interval_minutes']!, _intervalMinutesMeta));
    }
    if (data.containsKey('random_min_from')) {
      context.handle(
          _randomMinFromMeta,
          randomMinFrom.isAcceptableOrUnknown(
              data['random_min_from']!, _randomMinFromMeta));
    }
    if (data.containsKey('random_min_to')) {
      context.handle(
          _randomMinToMeta,
          randomMinTo.isAcceptableOrUnknown(
              data['random_min_to']!, _randomMinToMeta));
    }
    if (data.containsKey('cron_expression')) {
      context.handle(
          _cronExpressionMeta,
          cronExpression.isAcceptableOrUnknown(
              data['cron_expression']!, _cronExpressionMeta));
    }
    if (data.containsKey('sound_name')) {
      context.handle(_soundNameMeta,
          soundName.isAcceptableOrUnknown(data['sound_name']!, _soundNameMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('is_persistent')) {
      context.handle(
          _isPersistentMeta,
          isPersistent.isAcceptableOrUnknown(
              data['is_persistent']!, _isPersistentMeta));
    }
    if (data.containsKey('nagging_interval_minutes')) {
      context.handle(
          _naggingIntervalMinutesMeta,
          naggingIntervalMinutes.isAcceptableOrUnknown(
              data['nagging_interval_minutes']!, _naggingIntervalMinutesMeta));
    }
    if (data.containsKey('escalation_steps')) {
      context.handle(
          _escalationStepsMeta,
          escalationSteps.isAcceptableOrUnknown(
              data['escalation_steps']!, _escalationStepsMeta));
    }
    if (data.containsKey('snooze_minutes')) {
      context.handle(
          _snoozeMinutesMeta,
          snoozeMinutes.isAcceptableOrUnknown(
              data['snooze_minutes']!, _snoozeMinutesMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationItemEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationItemEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      weekdays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekdays']),
      intervalMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_minutes']),
      randomMinFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}random_min_from']),
      randomMinTo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}random_min_to']),
      cronExpression: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cron_expression']),
      soundName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sound_name']),
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value']),
      isPersistent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_persistent'])!,
      naggingIntervalMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}nagging_interval_minutes']),
      escalationSteps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}escalation_steps']),
      snoozeMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}snooze_minutes']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id']),
    );
  }

  @override
  $NotificationItemsTable createAlias(String alias) {
    return $NotificationItemsTable(attachedDatabase, alias);
  }
}

class NotificationItemEntity extends DataClass
    implements Insertable<NotificationItemEntity> {
  final String id;
  final String title;
  final String body;
  final String scheduleType;
  final DateTime scheduledAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? weekdays;
  final int? intervalMinutes;
  final int? randomMinFrom;
  final int? randomMinTo;
  final String? cronExpression;
  final String? soundName;
  final String? iconName;
  final int? colorValue;
  final bool isPersistent;
  final int? naggingIntervalMinutes;
  final int? escalationSteps;
  final int? snoozeMinutes;
  final String? categoryId;
  final String? templateId;
  const NotificationItemEntity(
      {required this.id,
      required this.title,
      required this.body,
      required this.scheduleType,
      required this.scheduledAt,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      this.weekdays,
      this.intervalMinutes,
      this.randomMinFrom,
      this.randomMinTo,
      this.cronExpression,
      this.soundName,
      this.iconName,
      this.colorValue,
      required this.isPersistent,
      this.naggingIntervalMinutes,
      this.escalationSteps,
      this.snoozeMinutes,
      this.categoryId,
      this.templateId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['schedule_type'] = Variable<String>(scheduleType);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    if (!nullToAbsent || intervalMinutes != null) {
      map['interval_minutes'] = Variable<int>(intervalMinutes);
    }
    if (!nullToAbsent || randomMinFrom != null) {
      map['random_min_from'] = Variable<int>(randomMinFrom);
    }
    if (!nullToAbsent || randomMinTo != null) {
      map['random_min_to'] = Variable<int>(randomMinTo);
    }
    if (!nullToAbsent || cronExpression != null) {
      map['cron_expression'] = Variable<String>(cronExpression);
    }
    if (!nullToAbsent || soundName != null) {
      map['sound_name'] = Variable<String>(soundName);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['is_persistent'] = Variable<bool>(isPersistent);
    if (!nullToAbsent || naggingIntervalMinutes != null) {
      map['nagging_interval_minutes'] = Variable<int>(naggingIntervalMinutes);
    }
    if (!nullToAbsent || escalationSteps != null) {
      map['escalation_steps'] = Variable<int>(escalationSteps);
    }
    if (!nullToAbsent || snoozeMinutes != null) {
      map['snooze_minutes'] = Variable<int>(snoozeMinutes);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    return map;
  }

  NotificationItemsCompanion toCompanion(bool nullToAbsent) {
    return NotificationItemsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      scheduleType: Value(scheduleType),
      scheduledAt: Value(scheduledAt),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      intervalMinutes: intervalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMinutes),
      randomMinFrom: randomMinFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(randomMinFrom),
      randomMinTo: randomMinTo == null && nullToAbsent
          ? const Value.absent()
          : Value(randomMinTo),
      cronExpression: cronExpression == null && nullToAbsent
          ? const Value.absent()
          : Value(cronExpression),
      soundName: soundName == null && nullToAbsent
          ? const Value.absent()
          : Value(soundName),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      isPersistent: Value(isPersistent),
      naggingIntervalMinutes: naggingIntervalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(naggingIntervalMinutes),
      escalationSteps: escalationSteps == null && nullToAbsent
          ? const Value.absent()
          : Value(escalationSteps),
      snoozeMinutes: snoozeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozeMinutes),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
    );
  }

  factory NotificationItemEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationItemEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
      intervalMinutes: serializer.fromJson<int?>(json['intervalMinutes']),
      randomMinFrom: serializer.fromJson<int?>(json['randomMinFrom']),
      randomMinTo: serializer.fromJson<int?>(json['randomMinTo']),
      cronExpression: serializer.fromJson<String?>(json['cronExpression']),
      soundName: serializer.fromJson<String?>(json['soundName']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      isPersistent: serializer.fromJson<bool>(json['isPersistent']),
      naggingIntervalMinutes:
          serializer.fromJson<int?>(json['naggingIntervalMinutes']),
      escalationSteps: serializer.fromJson<int?>(json['escalationSteps']),
      snoozeMinutes: serializer.fromJson<int?>(json['snoozeMinutes']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      templateId: serializer.fromJson<String?>(json['templateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'weekdays': serializer.toJson<String?>(weekdays),
      'intervalMinutes': serializer.toJson<int?>(intervalMinutes),
      'randomMinFrom': serializer.toJson<int?>(randomMinFrom),
      'randomMinTo': serializer.toJson<int?>(randomMinTo),
      'cronExpression': serializer.toJson<String?>(cronExpression),
      'soundName': serializer.toJson<String?>(soundName),
      'iconName': serializer.toJson<String?>(iconName),
      'colorValue': serializer.toJson<int?>(colorValue),
      'isPersistent': serializer.toJson<bool>(isPersistent),
      'naggingIntervalMinutes': serializer.toJson<int?>(naggingIntervalMinutes),
      'escalationSteps': serializer.toJson<int?>(escalationSteps),
      'snoozeMinutes': serializer.toJson<int?>(snoozeMinutes),
      'categoryId': serializer.toJson<String?>(categoryId),
      'templateId': serializer.toJson<String?>(templateId),
    };
  }

  NotificationItemEntity copyWith(
          {String? id,
          String? title,
          String? body,
          String? scheduleType,
          DateTime? scheduledAt,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> weekdays = const Value.absent(),
          Value<int?> intervalMinutes = const Value.absent(),
          Value<int?> randomMinFrom = const Value.absent(),
          Value<int?> randomMinTo = const Value.absent(),
          Value<String?> cronExpression = const Value.absent(),
          Value<String?> soundName = const Value.absent(),
          Value<String?> iconName = const Value.absent(),
          Value<int?> colorValue = const Value.absent(),
          bool? isPersistent,
          Value<int?> naggingIntervalMinutes = const Value.absent(),
          Value<int?> escalationSteps = const Value.absent(),
          Value<int?> snoozeMinutes = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          Value<String?> templateId = const Value.absent()}) =>
      NotificationItemEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        scheduleType: scheduleType ?? this.scheduleType,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        weekdays: weekdays.present ? weekdays.value : this.weekdays,
        intervalMinutes: intervalMinutes.present
            ? intervalMinutes.value
            : this.intervalMinutes,
        randomMinFrom:
            randomMinFrom.present ? randomMinFrom.value : this.randomMinFrom,
        randomMinTo: randomMinTo.present ? randomMinTo.value : this.randomMinTo,
        cronExpression:
            cronExpression.present ? cronExpression.value : this.cronExpression,
        soundName: soundName.present ? soundName.value : this.soundName,
        iconName: iconName.present ? iconName.value : this.iconName,
        colorValue: colorValue.present ? colorValue.value : this.colorValue,
        isPersistent: isPersistent ?? this.isPersistent,
        naggingIntervalMinutes: naggingIntervalMinutes.present
            ? naggingIntervalMinutes.value
            : this.naggingIntervalMinutes,
        escalationSteps: escalationSteps.present
            ? escalationSteps.value
            : this.escalationSteps,
        snoozeMinutes:
            snoozeMinutes.present ? snoozeMinutes.value : this.snoozeMinutes,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        templateId: templateId.present ? templateId.value : this.templateId,
      );
  NotificationItemEntity copyWithCompanion(NotificationItemsCompanion data) {
    return NotificationItemEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      intervalMinutes: data.intervalMinutes.present
          ? data.intervalMinutes.value
          : this.intervalMinutes,
      randomMinFrom: data.randomMinFrom.present
          ? data.randomMinFrom.value
          : this.randomMinFrom,
      randomMinTo:
          data.randomMinTo.present ? data.randomMinTo.value : this.randomMinTo,
      cronExpression: data.cronExpression.present
          ? data.cronExpression.value
          : this.cronExpression,
      soundName: data.soundName.present ? data.soundName.value : this.soundName,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      isPersistent: data.isPersistent.present
          ? data.isPersistent.value
          : this.isPersistent,
      naggingIntervalMinutes: data.naggingIntervalMinutes.present
          ? data.naggingIntervalMinutes.value
          : this.naggingIntervalMinutes,
      escalationSteps: data.escalationSteps.present
          ? data.escalationSteps.value
          : this.escalationSteps,
      snoozeMinutes: data.snoozeMinutes.present
          ? data.snoozeMinutes.value
          : this.snoozeMinutes,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationItemEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('randomMinFrom: $randomMinFrom, ')
          ..write('randomMinTo: $randomMinTo, ')
          ..write('cronExpression: $cronExpression, ')
          ..write('soundName: $soundName, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('isPersistent: $isPersistent, ')
          ..write('naggingIntervalMinutes: $naggingIntervalMinutes, ')
          ..write('escalationSteps: $escalationSteps, ')
          ..write('snoozeMinutes: $snoozeMinutes, ')
          ..write('categoryId: $categoryId, ')
          ..write('templateId: $templateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        body,
        scheduleType,
        scheduledAt,
        isActive,
        createdAt,
        updatedAt,
        weekdays,
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
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationItemEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.scheduleType == this.scheduleType &&
          other.scheduledAt == this.scheduledAt &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.weekdays == this.weekdays &&
          other.intervalMinutes == this.intervalMinutes &&
          other.randomMinFrom == this.randomMinFrom &&
          other.randomMinTo == this.randomMinTo &&
          other.cronExpression == this.cronExpression &&
          other.soundName == this.soundName &&
          other.iconName == this.iconName &&
          other.colorValue == this.colorValue &&
          other.isPersistent == this.isPersistent &&
          other.naggingIntervalMinutes == this.naggingIntervalMinutes &&
          other.escalationSteps == this.escalationSteps &&
          other.snoozeMinutes == this.snoozeMinutes &&
          other.categoryId == this.categoryId &&
          other.templateId == this.templateId);
}

class NotificationItemsCompanion
    extends UpdateCompanion<NotificationItemEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> scheduleType;
  final Value<DateTime> scheduledAt;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> weekdays;
  final Value<int?> intervalMinutes;
  final Value<int?> randomMinFrom;
  final Value<int?> randomMinTo;
  final Value<String?> cronExpression;
  final Value<String?> soundName;
  final Value<String?> iconName;
  final Value<int?> colorValue;
  final Value<bool> isPersistent;
  final Value<int?> naggingIntervalMinutes;
  final Value<int?> escalationSteps;
  final Value<int?> snoozeMinutes;
  final Value<String?> categoryId;
  final Value<String?> templateId;
  final Value<int> rowid;
  const NotificationItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.randomMinFrom = const Value.absent(),
    this.randomMinTo = const Value.absent(),
    this.cronExpression = const Value.absent(),
    this.soundName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isPersistent = const Value.absent(),
    this.naggingIntervalMinutes = const Value.absent(),
    this.escalationSteps = const Value.absent(),
    this.snoozeMinutes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationItemsCompanion.insert({
    required String id,
    required String title,
    required String body,
    required String scheduleType,
    required DateTime scheduledAt,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.weekdays = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.randomMinFrom = const Value.absent(),
    this.randomMinTo = const Value.absent(),
    this.cronExpression = const Value.absent(),
    this.soundName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isPersistent = const Value.absent(),
    this.naggingIntervalMinutes = const Value.absent(),
    this.escalationSteps = const Value.absent(),
    this.snoozeMinutes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        scheduleType = Value(scheduleType),
        scheduledAt = Value(scheduledAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NotificationItemEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? scheduleType,
    Expression<DateTime>? scheduledAt,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? weekdays,
    Expression<int>? intervalMinutes,
    Expression<int>? randomMinFrom,
    Expression<int>? randomMinTo,
    Expression<String>? cronExpression,
    Expression<String>? soundName,
    Expression<String>? iconName,
    Expression<int>? colorValue,
    Expression<bool>? isPersistent,
    Expression<int>? naggingIntervalMinutes,
    Expression<int>? escalationSteps,
    Expression<int>? snoozeMinutes,
    Expression<String>? categoryId,
    Expression<String>? templateId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (weekdays != null) 'weekdays': weekdays,
      if (intervalMinutes != null) 'interval_minutes': intervalMinutes,
      if (randomMinFrom != null) 'random_min_from': randomMinFrom,
      if (randomMinTo != null) 'random_min_to': randomMinTo,
      if (cronExpression != null) 'cron_expression': cronExpression,
      if (soundName != null) 'sound_name': soundName,
      if (iconName != null) 'icon_name': iconName,
      if (colorValue != null) 'color_value': colorValue,
      if (isPersistent != null) 'is_persistent': isPersistent,
      if (naggingIntervalMinutes != null)
        'nagging_interval_minutes': naggingIntervalMinutes,
      if (escalationSteps != null) 'escalation_steps': escalationSteps,
      if (snoozeMinutes != null) 'snooze_minutes': snoozeMinutes,
      if (categoryId != null) 'category_id': categoryId,
      if (templateId != null) 'template_id': templateId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String>? scheduleType,
      Value<DateTime>? scheduledAt,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? weekdays,
      Value<int?>? intervalMinutes,
      Value<int?>? randomMinFrom,
      Value<int?>? randomMinTo,
      Value<String?>? cronExpression,
      Value<String?>? soundName,
      Value<String?>? iconName,
      Value<int?>? colorValue,
      Value<bool>? isPersistent,
      Value<int?>? naggingIntervalMinutes,
      Value<int?>? escalationSteps,
      Value<int?>? snoozeMinutes,
      Value<String?>? categoryId,
      Value<String?>? templateId,
      Value<int>? rowid}) {
    return NotificationItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      weekdays: weekdays ?? this.weekdays,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      randomMinFrom: randomMinFrom ?? this.randomMinFrom,
      randomMinTo: randomMinTo ?? this.randomMinTo,
      cronExpression: cronExpression ?? this.cronExpression,
      soundName: soundName ?? this.soundName,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      isPersistent: isPersistent ?? this.isPersistent,
      naggingIntervalMinutes:
          naggingIntervalMinutes ?? this.naggingIntervalMinutes,
      escalationSteps: escalationSteps ?? this.escalationSteps,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      categoryId: categoryId ?? this.categoryId,
      templateId: templateId ?? this.templateId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (intervalMinutes.present) {
      map['interval_minutes'] = Variable<int>(intervalMinutes.value);
    }
    if (randomMinFrom.present) {
      map['random_min_from'] = Variable<int>(randomMinFrom.value);
    }
    if (randomMinTo.present) {
      map['random_min_to'] = Variable<int>(randomMinTo.value);
    }
    if (cronExpression.present) {
      map['cron_expression'] = Variable<String>(cronExpression.value);
    }
    if (soundName.present) {
      map['sound_name'] = Variable<String>(soundName.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isPersistent.present) {
      map['is_persistent'] = Variable<bool>(isPersistent.value);
    }
    if (naggingIntervalMinutes.present) {
      map['nagging_interval_minutes'] =
          Variable<int>(naggingIntervalMinutes.value);
    }
    if (escalationSteps.present) {
      map['escalation_steps'] = Variable<int>(escalationSteps.value);
    }
    if (snoozeMinutes.present) {
      map['snooze_minutes'] = Variable<int>(snoozeMinutes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('randomMinFrom: $randomMinFrom, ')
          ..write('randomMinTo: $randomMinTo, ')
          ..write('cronExpression: $cronExpression, ')
          ..write('soundName: $soundName, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('isPersistent: $isPersistent, ')
          ..write('naggingIntervalMinutes: $naggingIntervalMinutes, ')
          ..write('escalationSteps: $escalationSteps, ')
          ..write('snoozeMinutes: $snoozeMinutes, ')
          ..write('categoryId: $categoryId, ')
          ..write('templateId: $templateId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryEntriesTable extends HistoryEntries
    with TableInfo<$HistoryEntriesTable, HistoryEntryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<String> notificationId = GeneratedColumn<String>(
      'notification_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firedAtMeta =
      const VerificationMeta('firedAt');
  @override
  late final GeneratedColumn<DateTime> firedAt = GeneratedColumn<DateTime>(
      'fired_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, notificationId, title, body, firedAt, action];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_entries';
  @override
  VerificationContext validateIntegrity(Insertable<HistoryEntryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('fired_at')) {
      context.handle(_firedAtMeta,
          firedAt.isAcceptableOrUnknown(data['fired_at']!, _firedAtMeta));
    } else if (isInserting) {
      context.missing(_firedAtMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryEntryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryEntryEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      notificationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      firedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fired_at'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
    );
  }

  @override
  $HistoryEntriesTable createAlias(String alias) {
    return $HistoryEntriesTable(attachedDatabase, alias);
  }
}

class HistoryEntryEntity extends DataClass
    implements Insertable<HistoryEntryEntity> {
  final int id;
  final String notificationId;
  final String title;
  final String body;
  final DateTime firedAt;
  final String action;
  const HistoryEntryEntity(
      {required this.id,
      required this.notificationId,
      required this.title,
      required this.body,
      required this.firedAt,
      required this.action});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['notification_id'] = Variable<String>(notificationId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['fired_at'] = Variable<DateTime>(firedAt);
    map['action'] = Variable<String>(action);
    return map;
  }

  HistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return HistoryEntriesCompanion(
      id: Value(id),
      notificationId: Value(notificationId),
      title: Value(title),
      body: Value(body),
      firedAt: Value(firedAt),
      action: Value(action),
    );
  }

  factory HistoryEntryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryEntryEntity(
      id: serializer.fromJson<int>(json['id']),
      notificationId: serializer.fromJson<String>(json['notificationId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      firedAt: serializer.fromJson<DateTime>(json['firedAt']),
      action: serializer.fromJson<String>(json['action']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notificationId': serializer.toJson<String>(notificationId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'firedAt': serializer.toJson<DateTime>(firedAt),
      'action': serializer.toJson<String>(action),
    };
  }

  HistoryEntryEntity copyWith(
          {int? id,
          String? notificationId,
          String? title,
          String? body,
          DateTime? firedAt,
          String? action}) =>
      HistoryEntryEntity(
        id: id ?? this.id,
        notificationId: notificationId ?? this.notificationId,
        title: title ?? this.title,
        body: body ?? this.body,
        firedAt: firedAt ?? this.firedAt,
        action: action ?? this.action,
      );
  HistoryEntryEntity copyWithCompanion(HistoryEntriesCompanion data) {
    return HistoryEntryEntity(
      id: data.id.present ? data.id.value : this.id,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      firedAt: data.firedAt.present ? data.firedAt.value : this.firedAt,
      action: data.action.present ? data.action.value : this.action,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEntryEntity(')
          ..write('id: $id, ')
          ..write('notificationId: $notificationId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('firedAt: $firedAt, ')
          ..write('action: $action')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, notificationId, title, body, firedAt, action);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryEntryEntity &&
          other.id == this.id &&
          other.notificationId == this.notificationId &&
          other.title == this.title &&
          other.body == this.body &&
          other.firedAt == this.firedAt &&
          other.action == this.action);
}

class HistoryEntriesCompanion extends UpdateCompanion<HistoryEntryEntity> {
  final Value<int> id;
  final Value<String> notificationId;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> firedAt;
  final Value<String> action;
  const HistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.firedAt = const Value.absent(),
    this.action = const Value.absent(),
  });
  HistoryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String notificationId,
    required String title,
    required String body,
    required DateTime firedAt,
    required String action,
  })  : notificationId = Value(notificationId),
        title = Value(title),
        body = Value(body),
        firedAt = Value(firedAt),
        action = Value(action);
  static Insertable<HistoryEntryEntity> custom({
    Expression<int>? id,
    Expression<String>? notificationId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? firedAt,
    Expression<String>? action,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notificationId != null) 'notification_id': notificationId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (firedAt != null) 'fired_at': firedAt,
      if (action != null) 'action': action,
    });
  }

  HistoryEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? notificationId,
      Value<String>? title,
      Value<String>? body,
      Value<DateTime>? firedAt,
      Value<String>? action}) {
    return HistoryEntriesCompanion(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      firedAt: firedAt ?? this.firedAt,
      action: action ?? this.action,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<String>(notificationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (firedAt.present) {
      map['fired_at'] = Variable<DateTime>(firedAt.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('notificationId: $notificationId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('firedAt: $firedAt, ')
          ..write('action: $action')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotificationItemsTable notificationItems =
      $NotificationItemsTable(this);
  late final $HistoryEntriesTable historyEntries = $HistoryEntriesTable(this);
  late final NotificationDao notificationDao =
      NotificationDao(this as AppDatabase);
  late final HistoryDao historyDao = HistoryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notificationItems, historyEntries];
}

typedef $$NotificationItemsTableCreateCompanionBuilder
    = NotificationItemsCompanion Function({
  required String id,
  required String title,
  required String body,
  required String scheduleType,
  required DateTime scheduledAt,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> weekdays,
  Value<int?> intervalMinutes,
  Value<int?> randomMinFrom,
  Value<int?> randomMinTo,
  Value<String?> cronExpression,
  Value<String?> soundName,
  Value<String?> iconName,
  Value<int?> colorValue,
  Value<bool> isPersistent,
  Value<int?> naggingIntervalMinutes,
  Value<int?> escalationSteps,
  Value<int?> snoozeMinutes,
  Value<String?> categoryId,
  Value<String?> templateId,
  Value<int> rowid,
});
typedef $$NotificationItemsTableUpdateCompanionBuilder
    = NotificationItemsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> body,
  Value<String> scheduleType,
  Value<DateTime> scheduledAt,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> weekdays,
  Value<int?> intervalMinutes,
  Value<int?> randomMinFrom,
  Value<int?> randomMinTo,
  Value<String?> cronExpression,
  Value<String?> soundName,
  Value<String?> iconName,
  Value<int?> colorValue,
  Value<bool> isPersistent,
  Value<int?> naggingIntervalMinutes,
  Value<int?> escalationSteps,
  Value<int?> snoozeMinutes,
  Value<String?> categoryId,
  Value<String?> templateId,
  Value<int> rowid,
});

class $$NotificationItemsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationItemsTable> {
  $$NotificationItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalMinutes => $composableBuilder(
      column: $table.intervalMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get randomMinFrom => $composableBuilder(
      column: $table.randomMinFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get randomMinTo => $composableBuilder(
      column: $table.randomMinTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cronExpression => $composableBuilder(
      column: $table.cronExpression,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get soundName => $composableBuilder(
      column: $table.soundName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPersistent => $composableBuilder(
      column: $table.isPersistent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get naggingIntervalMinutes => $composableBuilder(
      column: $table.naggingIntervalMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get escalationSteps => $composableBuilder(
      column: $table.escalationSteps,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get snoozeMinutes => $composableBuilder(
      column: $table.snoozeMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnFilters(column));
}

class $$NotificationItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationItemsTable> {
  $$NotificationItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalMinutes => $composableBuilder(
      column: $table.intervalMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get randomMinFrom => $composableBuilder(
      column: $table.randomMinFrom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get randomMinTo => $composableBuilder(
      column: $table.randomMinTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cronExpression => $composableBuilder(
      column: $table.cronExpression,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get soundName => $composableBuilder(
      column: $table.soundName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPersistent => $composableBuilder(
      column: $table.isPersistent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get naggingIntervalMinutes => $composableBuilder(
      column: $table.naggingIntervalMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get escalationSteps => $composableBuilder(
      column: $table.escalationSteps,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get snoozeMinutes => $composableBuilder(
      column: $table.snoozeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnOrderings(column));
}

class $$NotificationItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationItemsTable> {
  $$NotificationItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get intervalMinutes => $composableBuilder(
      column: $table.intervalMinutes, builder: (column) => column);

  GeneratedColumn<int> get randomMinFrom => $composableBuilder(
      column: $table.randomMinFrom, builder: (column) => column);

  GeneratedColumn<int> get randomMinTo => $composableBuilder(
      column: $table.randomMinTo, builder: (column) => column);

  GeneratedColumn<String> get cronExpression => $composableBuilder(
      column: $table.cronExpression, builder: (column) => column);

  GeneratedColumn<String> get soundName =>
      $composableBuilder(column: $table.soundName, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<bool> get isPersistent => $composableBuilder(
      column: $table.isPersistent, builder: (column) => column);

  GeneratedColumn<int> get naggingIntervalMinutes => $composableBuilder(
      column: $table.naggingIntervalMinutes, builder: (column) => column);

  GeneratedColumn<int> get escalationSteps => $composableBuilder(
      column: $table.escalationSteps, builder: (column) => column);

  GeneratedColumn<int> get snoozeMinutes => $composableBuilder(
      column: $table.snoozeMinutes, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => column);
}

class $$NotificationItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationItemsTable,
    NotificationItemEntity,
    $$NotificationItemsTableFilterComposer,
    $$NotificationItemsTableOrderingComposer,
    $$NotificationItemsTableAnnotationComposer,
    $$NotificationItemsTableCreateCompanionBuilder,
    $$NotificationItemsTableUpdateCompanionBuilder,
    (
      NotificationItemEntity,
      BaseReferences<_$AppDatabase, $NotificationItemsTable,
          NotificationItemEntity>
    ),
    NotificationItemEntity,
    PrefetchHooks Function()> {
  $$NotificationItemsTableTableManager(
      _$AppDatabase db, $NotificationItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int?> intervalMinutes = const Value.absent(),
            Value<int?> randomMinFrom = const Value.absent(),
            Value<int?> randomMinTo = const Value.absent(),
            Value<String?> cronExpression = const Value.absent(),
            Value<String?> soundName = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<bool> isPersistent = const Value.absent(),
            Value<int?> naggingIntervalMinutes = const Value.absent(),
            Value<int?> escalationSteps = const Value.absent(),
            Value<int?> snoozeMinutes = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> templateId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationItemsCompanion(
            id: id,
            title: title,
            body: body,
            scheduleType: scheduleType,
            scheduledAt: scheduledAt,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            weekdays: weekdays,
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
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String body,
            required String scheduleType,
            required DateTime scheduledAt,
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String?> weekdays = const Value.absent(),
            Value<int?> intervalMinutes = const Value.absent(),
            Value<int?> randomMinFrom = const Value.absent(),
            Value<int?> randomMinTo = const Value.absent(),
            Value<String?> cronExpression = const Value.absent(),
            Value<String?> soundName = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<bool> isPersistent = const Value.absent(),
            Value<int?> naggingIntervalMinutes = const Value.absent(),
            Value<int?> escalationSteps = const Value.absent(),
            Value<int?> snoozeMinutes = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> templateId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationItemsCompanion.insert(
            id: id,
            title: title,
            body: body,
            scheduleType: scheduleType,
            scheduledAt: scheduledAt,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            weekdays: weekdays,
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
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationItemsTable,
    NotificationItemEntity,
    $$NotificationItemsTableFilterComposer,
    $$NotificationItemsTableOrderingComposer,
    $$NotificationItemsTableAnnotationComposer,
    $$NotificationItemsTableCreateCompanionBuilder,
    $$NotificationItemsTableUpdateCompanionBuilder,
    (
      NotificationItemEntity,
      BaseReferences<_$AppDatabase, $NotificationItemsTable,
          NotificationItemEntity>
    ),
    NotificationItemEntity,
    PrefetchHooks Function()>;
typedef $$HistoryEntriesTableCreateCompanionBuilder = HistoryEntriesCompanion
    Function({
  Value<int> id,
  required String notificationId,
  required String title,
  required String body,
  required DateTime firedAt,
  required String action,
});
typedef $$HistoryEntriesTableUpdateCompanionBuilder = HistoryEntriesCompanion
    Function({
  Value<int> id,
  Value<String> notificationId,
  Value<String> title,
  Value<String> body,
  Value<DateTime> firedAt,
  Value<String> action,
});

class $$HistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryEntriesTable> {
  $$HistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get firedAt => $composableBuilder(
      column: $table.firedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));
}

class $$HistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryEntriesTable> {
  $$HistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get firedAt => $composableBuilder(
      column: $table.firedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));
}

class $$HistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryEntriesTable> {
  $$HistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get firedAt =>
      $composableBuilder(column: $table.firedAt, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);
}

class $$HistoryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoryEntriesTable,
    HistoryEntryEntity,
    $$HistoryEntriesTableFilterComposer,
    $$HistoryEntriesTableOrderingComposer,
    $$HistoryEntriesTableAnnotationComposer,
    $$HistoryEntriesTableCreateCompanionBuilder,
    $$HistoryEntriesTableUpdateCompanionBuilder,
    (
      HistoryEntryEntity,
      BaseReferences<_$AppDatabase, $HistoryEntriesTable, HistoryEntryEntity>
    ),
    HistoryEntryEntity,
    PrefetchHooks Function()> {
  $$HistoryEntriesTableTableManager(
      _$AppDatabase db, $HistoryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> notificationId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<DateTime> firedAt = const Value.absent(),
            Value<String> action = const Value.absent(),
          }) =>
              HistoryEntriesCompanion(
            id: id,
            notificationId: notificationId,
            title: title,
            body: body,
            firedAt: firedAt,
            action: action,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String notificationId,
            required String title,
            required String body,
            required DateTime firedAt,
            required String action,
          }) =>
              HistoryEntriesCompanion.insert(
            id: id,
            notificationId: notificationId,
            title: title,
            body: body,
            firedAt: firedAt,
            action: action,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistoryEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoryEntriesTable,
    HistoryEntryEntity,
    $$HistoryEntriesTableFilterComposer,
    $$HistoryEntriesTableOrderingComposer,
    $$HistoryEntriesTableAnnotationComposer,
    $$HistoryEntriesTableCreateCompanionBuilder,
    $$HistoryEntriesTableUpdateCompanionBuilder,
    (
      HistoryEntryEntity,
      BaseReferences<_$AppDatabase, $HistoryEntriesTable, HistoryEntryEntity>
    ),
    HistoryEntryEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotificationItemsTableTableManager get notificationItems =>
      $$NotificationItemsTableTableManager(_db, _db.notificationItems);
  $$HistoryEntriesTableTableManager get historyEntries =>
      $$HistoryEntriesTableTableManager(_db, _db.historyEntries);
}
