// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalAppSettingsTable extends LocalAppSettings
    with TableInfo<$LocalAppSettingsTable, LocalAppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
  );
  static const VerificationMeta _goalModeMeta = const VerificationMeta(
    'goalMode',
  );
  @override
  late final GeneratedColumn<String> goalMode = GeneratedColumn<String>(
    'goal_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caffeineLimitMgMeta = const VerificationMeta(
    'caffeineLimitMg',
  );
  @override
  late final GeneratedColumn<int> caffeineLimitMg = GeneratedColumn<int>(
    'caffeine_limit_mg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themePresetMeta = const VerificationMeta(
    'themePreset',
  );
  @override
  late final GeneratedColumn<String> themePreset = GeneratedColumn<String>(
    'theme_preset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smartReminderEnabledMeta =
      const VerificationMeta('smartReminderEnabled');
  @override
  late final GeneratedColumn<bool> smartReminderEnabled = GeneratedColumn<bool>(
    'smart_reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("smart_reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    onboardingComplete,
    goalMode,
    caffeineLimitMg,
    themePreset,
    smartReminderEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onboardingCompleteMeta);
    }
    if (data.containsKey('goal_mode')) {
      context.handle(
        _goalModeMeta,
        goalMode.isAcceptableOrUnknown(data['goal_mode']!, _goalModeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalModeMeta);
    }
    if (data.containsKey('caffeine_limit_mg')) {
      context.handle(
        _caffeineLimitMgMeta,
        caffeineLimitMg.isAcceptableOrUnknown(
          data['caffeine_limit_mg']!,
          _caffeineLimitMgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caffeineLimitMgMeta);
    }
    if (data.containsKey('theme_preset')) {
      context.handle(
        _themePresetMeta,
        themePreset.isAcceptableOrUnknown(
          data['theme_preset']!,
          _themePresetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_themePresetMeta);
    }
    if (data.containsKey('smart_reminder_enabled')) {
      context.handle(
        _smartReminderEnabledMeta,
        smartReminderEnabled.isAcceptableOrUnknown(
          data['smart_reminder_enabled']!,
          _smartReminderEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      goalMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_mode'],
      )!,
      caffeineLimitMg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caffeine_limit_mg'],
      )!,
      themePreset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preset'],
      )!,
      smartReminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}smart_reminder_enabled'],
      )!,
    );
  }

  @override
  $LocalAppSettingsTable createAlias(String alias) {
    return $LocalAppSettingsTable(attachedDatabase, alias);
  }
}

class LocalAppSetting extends DataClass implements Insertable<LocalAppSetting> {
  final int id;
  final bool onboardingComplete;
  final String goalMode;
  final int caffeineLimitMg;
  final String themePreset;
  final bool smartReminderEnabled;
  const LocalAppSetting({
    required this.id,
    required this.onboardingComplete,
    required this.goalMode,
    required this.caffeineLimitMg,
    required this.themePreset,
    required this.smartReminderEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['goal_mode'] = Variable<String>(goalMode);
    map['caffeine_limit_mg'] = Variable<int>(caffeineLimitMg);
    map['theme_preset'] = Variable<String>(themePreset);
    map['smart_reminder_enabled'] = Variable<bool>(smartReminderEnabled);
    return map;
  }

  LocalAppSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalAppSettingsCompanion(
      id: Value(id),
      onboardingComplete: Value(onboardingComplete),
      goalMode: Value(goalMode),
      caffeineLimitMg: Value(caffeineLimitMg),
      themePreset: Value(themePreset),
      smartReminderEnabled: Value(smartReminderEnabled),
    );
  }

  factory LocalAppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAppSetting(
      id: serializer.fromJson<int>(json['id']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      goalMode: serializer.fromJson<String>(json['goalMode']),
      caffeineLimitMg: serializer.fromJson<int>(json['caffeineLimitMg']),
      themePreset: serializer.fromJson<String>(json['themePreset']),
      smartReminderEnabled: serializer.fromJson<bool>(
        json['smartReminderEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'goalMode': serializer.toJson<String>(goalMode),
      'caffeineLimitMg': serializer.toJson<int>(caffeineLimitMg),
      'themePreset': serializer.toJson<String>(themePreset),
      'smartReminderEnabled': serializer.toJson<bool>(smartReminderEnabled),
    };
  }

  LocalAppSetting copyWith({
    int? id,
    bool? onboardingComplete,
    String? goalMode,
    int? caffeineLimitMg,
    String? themePreset,
    bool? smartReminderEnabled,
  }) => LocalAppSetting(
    id: id ?? this.id,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    goalMode: goalMode ?? this.goalMode,
    caffeineLimitMg: caffeineLimitMg ?? this.caffeineLimitMg,
    themePreset: themePreset ?? this.themePreset,
    smartReminderEnabled: smartReminderEnabled ?? this.smartReminderEnabled,
  );
  LocalAppSetting copyWithCompanion(LocalAppSettingsCompanion data) {
    return LocalAppSetting(
      id: data.id.present ? data.id.value : this.id,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      goalMode: data.goalMode.present ? data.goalMode.value : this.goalMode,
      caffeineLimitMg: data.caffeineLimitMg.present
          ? data.caffeineLimitMg.value
          : this.caffeineLimitMg,
      themePreset: data.themePreset.present
          ? data.themePreset.value
          : this.themePreset,
      smartReminderEnabled: data.smartReminderEnabled.present
          ? data.smartReminderEnabled.value
          : this.smartReminderEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppSetting(')
          ..write('id: $id, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('goalMode: $goalMode, ')
          ..write('caffeineLimitMg: $caffeineLimitMg, ')
          ..write('themePreset: $themePreset, ')
          ..write('smartReminderEnabled: $smartReminderEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    onboardingComplete,
    goalMode,
    caffeineLimitMg,
    themePreset,
    smartReminderEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAppSetting &&
          other.id == this.id &&
          other.onboardingComplete == this.onboardingComplete &&
          other.goalMode == this.goalMode &&
          other.caffeineLimitMg == this.caffeineLimitMg &&
          other.themePreset == this.themePreset &&
          other.smartReminderEnabled == this.smartReminderEnabled);
}

class LocalAppSettingsCompanion extends UpdateCompanion<LocalAppSetting> {
  final Value<int> id;
  final Value<bool> onboardingComplete;
  final Value<String> goalMode;
  final Value<int> caffeineLimitMg;
  final Value<String> themePreset;
  final Value<bool> smartReminderEnabled;
  const LocalAppSettingsCompanion({
    this.id = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.goalMode = const Value.absent(),
    this.caffeineLimitMg = const Value.absent(),
    this.themePreset = const Value.absent(),
    this.smartReminderEnabled = const Value.absent(),
  });
  LocalAppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required bool onboardingComplete,
    required String goalMode,
    required int caffeineLimitMg,
    required String themePreset,
    this.smartReminderEnabled = const Value.absent(),
  }) : onboardingComplete = Value(onboardingComplete),
       goalMode = Value(goalMode),
       caffeineLimitMg = Value(caffeineLimitMg),
       themePreset = Value(themePreset);
  static Insertable<LocalAppSetting> custom({
    Expression<int>? id,
    Expression<bool>? onboardingComplete,
    Expression<String>? goalMode,
    Expression<int>? caffeineLimitMg,
    Expression<String>? themePreset,
    Expression<bool>? smartReminderEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (goalMode != null) 'goal_mode': goalMode,
      if (caffeineLimitMg != null) 'caffeine_limit_mg': caffeineLimitMg,
      if (themePreset != null) 'theme_preset': themePreset,
      if (smartReminderEnabled != null)
        'smart_reminder_enabled': smartReminderEnabled,
    });
  }

  LocalAppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? onboardingComplete,
    Value<String>? goalMode,
    Value<int>? caffeineLimitMg,
    Value<String>? themePreset,
    Value<bool>? smartReminderEnabled,
  }) {
    return LocalAppSettingsCompanion(
      id: id ?? this.id,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      goalMode: goalMode ?? this.goalMode,
      caffeineLimitMg: caffeineLimitMg ?? this.caffeineLimitMg,
      themePreset: themePreset ?? this.themePreset,
      smartReminderEnabled: smartReminderEnabled ?? this.smartReminderEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (goalMode.present) {
      map['goal_mode'] = Variable<String>(goalMode.value);
    }
    if (caffeineLimitMg.present) {
      map['caffeine_limit_mg'] = Variable<int>(caffeineLimitMg.value);
    }
    if (themePreset.present) {
      map['theme_preset'] = Variable<String>(themePreset.value);
    }
    if (smartReminderEnabled.present) {
      map['smart_reminder_enabled'] = Variable<bool>(
        smartReminderEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('goalMode: $goalMode, ')
          ..write('caffeineLimitMg: $caffeineLimitMg, ')
          ..write('themePreset: $themePreset, ')
          ..write('smartReminderEnabled: $smartReminderEnabled')
          ..write(')'))
        .toString();
  }
}

class $FavoriteDrinkRowsTable extends FavoriteDrinkRows
    with TableInfo<$FavoriteDrinkRowsTable, FavoriteDrinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteDrinkRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _drinkIdMeta = const VerificationMeta(
    'drinkId',
  );
  @override
  late final GeneratedColumn<String> drinkId = GeneratedColumn<String>(
    'drink_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [drinkId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_drink_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteDrinkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('drink_id')) {
      context.handle(
        _drinkIdMeta,
        drinkId.isAcceptableOrUnknown(data['drink_id']!, _drinkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_drinkIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {drinkId};
  @override
  FavoriteDrinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteDrinkRow(
      drinkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drink_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $FavoriteDrinkRowsTable createAlias(String alias) {
    return $FavoriteDrinkRowsTable(attachedDatabase, alias);
  }
}

class FavoriteDrinkRow extends DataClass
    implements Insertable<FavoriteDrinkRow> {
  final String drinkId;
  final int position;
  const FavoriteDrinkRow({required this.drinkId, required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['drink_id'] = Variable<String>(drinkId);
    map['position'] = Variable<int>(position);
    return map;
  }

  FavoriteDrinkRowsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteDrinkRowsCompanion(
      drinkId: Value(drinkId),
      position: Value(position),
    );
  }

  factory FavoriteDrinkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteDrinkRow(
      drinkId: serializer.fromJson<String>(json['drinkId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'drinkId': serializer.toJson<String>(drinkId),
      'position': serializer.toJson<int>(position),
    };
  }

  FavoriteDrinkRow copyWith({String? drinkId, int? position}) =>
      FavoriteDrinkRow(
        drinkId: drinkId ?? this.drinkId,
        position: position ?? this.position,
      );
  FavoriteDrinkRow copyWithCompanion(FavoriteDrinkRowsCompanion data) {
    return FavoriteDrinkRow(
      drinkId: data.drinkId.present ? data.drinkId.value : this.drinkId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteDrinkRow(')
          ..write('drinkId: $drinkId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(drinkId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteDrinkRow &&
          other.drinkId == this.drinkId &&
          other.position == this.position);
}

class FavoriteDrinkRowsCompanion extends UpdateCompanion<FavoriteDrinkRow> {
  final Value<String> drinkId;
  final Value<int> position;
  final Value<int> rowid;
  const FavoriteDrinkRowsCompanion({
    this.drinkId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteDrinkRowsCompanion.insert({
    required String drinkId,
    required int position,
    this.rowid = const Value.absent(),
  }) : drinkId = Value(drinkId),
       position = Value(position);
  static Insertable<FavoriteDrinkRow> custom({
    Expression<String>? drinkId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (drinkId != null) 'drink_id': drinkId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteDrinkRowsCompanion copyWith({
    Value<String>? drinkId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return FavoriteDrinkRowsCompanion(
      drinkId: drinkId ?? this.drinkId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (drinkId.present) {
      map['drink_id'] = Variable<String>(drinkId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteDrinkRowsCompanion(')
          ..write('drinkId: $drinkId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DrinkEntriesTable extends DrinkEntries
    with TableInfo<$DrinkEntriesTable, DrinkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrinkEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caffeineMgMeta = const VerificationMeta(
    'caffeineMg',
  );
  @override
  late final GeneratedColumn<int> caffeineMg = GeneratedColumn<int>(
    'caffeine_mg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeMlMeta = const VerificationMeta(
    'volumeMl',
  );
  @override
  late final GeneratedColumn<int> volumeMl = GeneratedColumn<int>(
    'volume_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumedAtUtcMeta = const VerificationMeta(
    'consumedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> consumedAtUtc =
      GeneratedColumn<DateTime>(
        'consumed_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<String> temperature = GeneratedColumn<String>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Hot'),
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('home'),
  );
  static const VerificationMeta _cafeNameMeta = const VerificationMeta(
    'cafeName',
  );
  @override
  late final GeneratedColumn<String> cafeName = GeneratedColumn<String>(
    'cafe_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cupStyleMeta = const VerificationMeta(
    'cupStyle',
  );
  @override
  late final GeneratedColumn<String> cupStyle = GeneratedColumn<String>(
    'cup_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Ceramic Mug'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    caffeineMg,
    volumeMl,
    consumedAtUtc,
    priceCents,
    temperature,
    location,
    cafeName,
    cupStyle,
    note,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drink_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrinkEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('caffeine_mg')) {
      context.handle(
        _caffeineMgMeta,
        caffeineMg.isAcceptableOrUnknown(data['caffeine_mg']!, _caffeineMgMeta),
      );
    } else if (isInserting) {
      context.missing(_caffeineMgMeta);
    }
    if (data.containsKey('volume_ml')) {
      context.handle(
        _volumeMlMeta,
        volumeMl.isAcceptableOrUnknown(data['volume_ml']!, _volumeMlMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeMlMeta);
    }
    if (data.containsKey('consumed_at_utc')) {
      context.handle(
        _consumedAtUtcMeta,
        consumedAtUtc.isAcceptableOrUnknown(
          data['consumed_at_utc']!,
          _consumedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consumedAtUtcMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('cafe_name')) {
      context.handle(
        _cafeNameMeta,
        cafeName.isAcceptableOrUnknown(data['cafe_name']!, _cafeNameMeta),
      );
    }
    if (data.containsKey('cup_style')) {
      context.handle(
        _cupStyleMeta,
        cupStyle.isAcceptableOrUnknown(data['cup_style']!, _cupStyleMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrinkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrinkEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      caffeineMg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caffeine_mg'],
      )!,
      volumeMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_ml'],
      )!,
      consumedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consumed_at_utc'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temperature'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      cafeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cafe_name'],
      ),
      cupStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cup_style'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $DrinkEntriesTable createAlias(String alias) {
    return $DrinkEntriesTable(attachedDatabase, alias);
  }
}

class DrinkEntry extends DataClass implements Insertable<DrinkEntry> {
  final int id;
  final String name;
  final int caffeineMg;
  final int volumeMl;
  final DateTime consumedAtUtc;
  final int priceCents;
  final String temperature;
  final String location;
  final String? cafeName;
  final String cupStyle;
  final String? note;
  final String? photoPath;
  const DrinkEntry({
    required this.id,
    required this.name,
    required this.caffeineMg,
    required this.volumeMl,
    required this.consumedAtUtc,
    required this.priceCents,
    required this.temperature,
    required this.location,
    this.cafeName,
    required this.cupStyle,
    this.note,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['caffeine_mg'] = Variable<int>(caffeineMg);
    map['volume_ml'] = Variable<int>(volumeMl);
    map['consumed_at_utc'] = Variable<DateTime>(consumedAtUtc);
    map['price_cents'] = Variable<int>(priceCents);
    map['temperature'] = Variable<String>(temperature);
    map['location'] = Variable<String>(location);
    if (!nullToAbsent || cafeName != null) {
      map['cafe_name'] = Variable<String>(cafeName);
    }
    map['cup_style'] = Variable<String>(cupStyle);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  DrinkEntriesCompanion toCompanion(bool nullToAbsent) {
    return DrinkEntriesCompanion(
      id: Value(id),
      name: Value(name),
      caffeineMg: Value(caffeineMg),
      volumeMl: Value(volumeMl),
      consumedAtUtc: Value(consumedAtUtc),
      priceCents: Value(priceCents),
      temperature: Value(temperature),
      location: Value(location),
      cafeName: cafeName == null && nullToAbsent
          ? const Value.absent()
          : Value(cafeName),
      cupStyle: Value(cupStyle),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory DrinkEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrinkEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      caffeineMg: serializer.fromJson<int>(json['caffeineMg']),
      volumeMl: serializer.fromJson<int>(json['volumeMl']),
      consumedAtUtc: serializer.fromJson<DateTime>(json['consumedAtUtc']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      temperature: serializer.fromJson<String>(json['temperature']),
      location: serializer.fromJson<String>(json['location']),
      cafeName: serializer.fromJson<String?>(json['cafeName']),
      cupStyle: serializer.fromJson<String>(json['cupStyle']),
      note: serializer.fromJson<String?>(json['note']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'caffeineMg': serializer.toJson<int>(caffeineMg),
      'volumeMl': serializer.toJson<int>(volumeMl),
      'consumedAtUtc': serializer.toJson<DateTime>(consumedAtUtc),
      'priceCents': serializer.toJson<int>(priceCents),
      'temperature': serializer.toJson<String>(temperature),
      'location': serializer.toJson<String>(location),
      'cafeName': serializer.toJson<String?>(cafeName),
      'cupStyle': serializer.toJson<String>(cupStyle),
      'note': serializer.toJson<String?>(note),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  DrinkEntry copyWith({
    int? id,
    String? name,
    int? caffeineMg,
    int? volumeMl,
    DateTime? consumedAtUtc,
    int? priceCents,
    String? temperature,
    String? location,
    Value<String?> cafeName = const Value.absent(),
    String? cupStyle,
    Value<String?> note = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
  }) => DrinkEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    caffeineMg: caffeineMg ?? this.caffeineMg,
    volumeMl: volumeMl ?? this.volumeMl,
    consumedAtUtc: consumedAtUtc ?? this.consumedAtUtc,
    priceCents: priceCents ?? this.priceCents,
    temperature: temperature ?? this.temperature,
    location: location ?? this.location,
    cafeName: cafeName.present ? cafeName.value : this.cafeName,
    cupStyle: cupStyle ?? this.cupStyle,
    note: note.present ? note.value : this.note,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  DrinkEntry copyWithCompanion(DrinkEntriesCompanion data) {
    return DrinkEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      caffeineMg: data.caffeineMg.present
          ? data.caffeineMg.value
          : this.caffeineMg,
      volumeMl: data.volumeMl.present ? data.volumeMl.value : this.volumeMl,
      consumedAtUtc: data.consumedAtUtc.present
          ? data.consumedAtUtc.value
          : this.consumedAtUtc,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      location: data.location.present ? data.location.value : this.location,
      cafeName: data.cafeName.present ? data.cafeName.value : this.cafeName,
      cupStyle: data.cupStyle.present ? data.cupStyle.value : this.cupStyle,
      note: data.note.present ? data.note.value : this.note,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrinkEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('caffeineMg: $caffeineMg, ')
          ..write('volumeMl: $volumeMl, ')
          ..write('consumedAtUtc: $consumedAtUtc, ')
          ..write('priceCents: $priceCents, ')
          ..write('temperature: $temperature, ')
          ..write('location: $location, ')
          ..write('cafeName: $cafeName, ')
          ..write('cupStyle: $cupStyle, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    caffeineMg,
    volumeMl,
    consumedAtUtc,
    priceCents,
    temperature,
    location,
    cafeName,
    cupStyle,
    note,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrinkEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.caffeineMg == this.caffeineMg &&
          other.volumeMl == this.volumeMl &&
          other.consumedAtUtc == this.consumedAtUtc &&
          other.priceCents == this.priceCents &&
          other.temperature == this.temperature &&
          other.location == this.location &&
          other.cafeName == this.cafeName &&
          other.cupStyle == this.cupStyle &&
          other.note == this.note &&
          other.photoPath == this.photoPath);
}

class DrinkEntriesCompanion extends UpdateCompanion<DrinkEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> caffeineMg;
  final Value<int> volumeMl;
  final Value<DateTime> consumedAtUtc;
  final Value<int> priceCents;
  final Value<String> temperature;
  final Value<String> location;
  final Value<String?> cafeName;
  final Value<String> cupStyle;
  final Value<String?> note;
  final Value<String?> photoPath;
  const DrinkEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.caffeineMg = const Value.absent(),
    this.volumeMl = const Value.absent(),
    this.consumedAtUtc = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.temperature = const Value.absent(),
    this.location = const Value.absent(),
    this.cafeName = const Value.absent(),
    this.cupStyle = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  DrinkEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int caffeineMg,
    required int volumeMl,
    required DateTime consumedAtUtc,
    this.priceCents = const Value.absent(),
    this.temperature = const Value.absent(),
    this.location = const Value.absent(),
    this.cafeName = const Value.absent(),
    this.cupStyle = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
  }) : name = Value(name),
       caffeineMg = Value(caffeineMg),
       volumeMl = Value(volumeMl),
       consumedAtUtc = Value(consumedAtUtc);
  static Insertable<DrinkEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? caffeineMg,
    Expression<int>? volumeMl,
    Expression<DateTime>? consumedAtUtc,
    Expression<int>? priceCents,
    Expression<String>? temperature,
    Expression<String>? location,
    Expression<String>? cafeName,
    Expression<String>? cupStyle,
    Expression<String>? note,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (caffeineMg != null) 'caffeine_mg': caffeineMg,
      if (volumeMl != null) 'volume_ml': volumeMl,
      if (consumedAtUtc != null) 'consumed_at_utc': consumedAtUtc,
      if (priceCents != null) 'price_cents': priceCents,
      if (temperature != null) 'temperature': temperature,
      if (location != null) 'location': location,
      if (cafeName != null) 'cafe_name': cafeName,
      if (cupStyle != null) 'cup_style': cupStyle,
      if (note != null) 'note': note,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  DrinkEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? caffeineMg,
    Value<int>? volumeMl,
    Value<DateTime>? consumedAtUtc,
    Value<int>? priceCents,
    Value<String>? temperature,
    Value<String>? location,
    Value<String?>? cafeName,
    Value<String>? cupStyle,
    Value<String?>? note,
    Value<String?>? photoPath,
  }) {
    return DrinkEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      caffeineMg: caffeineMg ?? this.caffeineMg,
      volumeMl: volumeMl ?? this.volumeMl,
      consumedAtUtc: consumedAtUtc ?? this.consumedAtUtc,
      priceCents: priceCents ?? this.priceCents,
      temperature: temperature ?? this.temperature,
      location: location ?? this.location,
      cafeName: cafeName ?? this.cafeName,
      cupStyle: cupStyle ?? this.cupStyle,
      note: note ?? this.note,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (caffeineMg.present) {
      map['caffeine_mg'] = Variable<int>(caffeineMg.value);
    }
    if (volumeMl.present) {
      map['volume_ml'] = Variable<int>(volumeMl.value);
    }
    if (consumedAtUtc.present) {
      map['consumed_at_utc'] = Variable<DateTime>(consumedAtUtc.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<String>(temperature.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (cafeName.present) {
      map['cafe_name'] = Variable<String>(cafeName.value);
    }
    if (cupStyle.present) {
      map['cup_style'] = Variable<String>(cupStyle.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrinkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('caffeineMg: $caffeineMg, ')
          ..write('volumeMl: $volumeMl, ')
          ..write('consumedAtUtc: $consumedAtUtc, ')
          ..write('priceCents: $priceCents, ')
          ..write('temperature: $temperature, ')
          ..write('location: $location, ')
          ..write('cafeName: $cafeName, ')
          ..write('cupStyle: $cupStyle, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $FeatureIdeasTable extends FeatureIdeas
    with TableInfo<$FeatureIdeasTable, FeatureIdea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureIdeasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anonymousMeta = const VerificationMeta(
    'anonymous',
  );
  @override
  late final GeneratedColumn<bool> anonymous = GeneratedColumn<bool>(
    'anonymous',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("anonymous" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _votedMeta = const VerificationMeta('voted');
  @override
  late final GeneratedColumn<bool> voted = GeneratedColumn<bool>(
    'voted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("voted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    anonymous,
    voted,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_ideas';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureIdea> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('anonymous')) {
      context.handle(
        _anonymousMeta,
        anonymous.isAcceptableOrUnknown(data['anonymous']!, _anonymousMeta),
      );
    }
    if (data.containsKey('voted')) {
      context.handle(
        _votedMeta,
        voted.isAcceptableOrUnknown(data['voted']!, _votedMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureIdea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureIdea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      anonymous: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}anonymous'],
      )!,
      voted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}voted'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $FeatureIdeasTable createAlias(String alias) {
    return $FeatureIdeasTable(attachedDatabase, alias);
  }
}

class FeatureIdea extends DataClass implements Insertable<FeatureIdea> {
  final int id;
  final String title;
  final String description;
  final bool anonymous;
  final bool voted;
  final DateTime createdAtUtc;
  const FeatureIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.anonymous,
    required this.voted,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['anonymous'] = Variable<bool>(anonymous);
    map['voted'] = Variable<bool>(voted);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  FeatureIdeasCompanion toCompanion(bool nullToAbsent) {
    return FeatureIdeasCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      anonymous: Value(anonymous),
      voted: Value(voted),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory FeatureIdea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureIdea(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      anonymous: serializer.fromJson<bool>(json['anonymous']),
      voted: serializer.fromJson<bool>(json['voted']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'anonymous': serializer.toJson<bool>(anonymous),
      'voted': serializer.toJson<bool>(voted),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  FeatureIdea copyWith({
    int? id,
    String? title,
    String? description,
    bool? anonymous,
    bool? voted,
    DateTime? createdAtUtc,
  }) => FeatureIdea(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    anonymous: anonymous ?? this.anonymous,
    voted: voted ?? this.voted,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  FeatureIdea copyWithCompanion(FeatureIdeasCompanion data) {
    return FeatureIdea(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      anonymous: data.anonymous.present ? data.anonymous.value : this.anonymous,
      voted: data.voted.present ? data.voted.value : this.voted,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureIdea(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('anonymous: $anonymous, ')
          ..write('voted: $voted, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, anonymous, voted, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureIdea &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.anonymous == this.anonymous &&
          other.voted == this.voted &&
          other.createdAtUtc == this.createdAtUtc);
}

class FeatureIdeasCompanion extends UpdateCompanion<FeatureIdea> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<bool> anonymous;
  final Value<bool> voted;
  final Value<DateTime> createdAtUtc;
  const FeatureIdeasCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.anonymous = const Value.absent(),
    this.voted = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
  });
  FeatureIdeasCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.anonymous = const Value.absent(),
    this.voted = const Value.absent(),
    required DateTime createdAtUtc,
  }) : title = Value(title),
       description = Value(description),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<FeatureIdea> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? anonymous,
    Expression<bool>? voted,
    Expression<DateTime>? createdAtUtc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (anonymous != null) 'anonymous': anonymous,
      if (voted != null) 'voted': voted,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
    });
  }

  FeatureIdeasCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<bool>? anonymous,
    Value<bool>? voted,
    Value<DateTime>? createdAtUtc,
  }) {
    return FeatureIdeasCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      anonymous: anonymous ?? this.anonymous,
      voted: voted ?? this.voted,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (anonymous.present) {
      map['anonymous'] = Variable<bool>(anonymous.value);
    }
    if (voted.present) {
      map['voted'] = Variable<bool>(voted.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureIdeasCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('anonymous: $anonymous, ')
          ..write('voted: $voted, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }
}

class $LocalRemindersTable extends LocalReminders
    with TableInfo<$LocalRemindersTable, LocalReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, hour, minute, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalReminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $LocalRemindersTable createAlias(String alias) {
    return $LocalRemindersTable(attachedDatabase, alias);
  }
}

class LocalReminder extends DataClass implements Insertable<LocalReminder> {
  final int id;
  final int hour;
  final int minute;
  final bool enabled;
  const LocalReminder({
    required this.id,
    required this.hour,
    required this.minute,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  LocalRemindersCompanion toCompanion(bool nullToAbsent) {
    return LocalRemindersCompanion(
      id: Value(id),
      hour: Value(hour),
      minute: Value(minute),
      enabled: Value(enabled),
    );
  }

  factory LocalReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalReminder(
      id: serializer.fromJson<int>(json['id']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  LocalReminder copyWith({int? id, int? hour, int? minute, bool? enabled}) =>
      LocalReminder(
        id: id ?? this.id,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        enabled: enabled ?? this.enabled,
      );
  LocalReminder copyWithCompanion(LocalRemindersCompanion data) {
    return LocalReminder(
      id: data.id.present ? data.id.value : this.id,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalReminder(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hour, minute, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalReminder &&
          other.id == this.id &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.enabled == this.enabled);
}

class LocalRemindersCompanion extends UpdateCompanion<LocalReminder> {
  final Value<int> id;
  final Value<int> hour;
  final Value<int> minute;
  final Value<bool> enabled;
  const LocalRemindersCompanion({
    this.id = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  LocalRemindersCompanion.insert({
    this.id = const Value.absent(),
    required int hour,
    required int minute,
    this.enabled = const Value.absent(),
  }) : hour = Value(hour),
       minute = Value(minute);
  static Insertable<LocalReminder> custom({
    Expression<int>? id,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (enabled != null) 'enabled': enabled,
    });
  }

  LocalRemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? hour,
    Value<int>? minute,
    Value<bool>? enabled,
  }) {
    return LocalRemindersCompanion(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRemindersCompanion(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $CustomLocationsTable extends CustomLocations
    with TableInfo<$CustomLocationsTable, CustomLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $CustomLocationsTable createAlias(String alias) {
    return $CustomLocationsTable(attachedDatabase, alias);
  }
}

class CustomLocation extends DataClass implements Insertable<CustomLocation> {
  final int id;
  final String name;
  final DateTime createdAtUtc;
  const CustomLocation({
    required this.id,
    required this.name,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  CustomLocationsCompanion toCompanion(bool nullToAbsent) {
    return CustomLocationsCompanion(
      id: Value(id),
      name: Value(name),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory CustomLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  CustomLocation copyWith({int? id, String? name, DateTime? createdAtUtc}) =>
      CustomLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      );
  CustomLocation copyWithCompanion(CustomLocationsCompanion data) {
    return CustomLocation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAtUtc == this.createdAtUtc);
}

class CustomLocationsCompanion extends UpdateCompanion<CustomLocation> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAtUtc;
  const CustomLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
  });
  CustomLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAtUtc,
  }) : name = Value(name),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<CustomLocation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAtUtc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
    });
  }

  CustomLocationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAtUtc,
  }) {
    return CustomLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalAppSettingsTable localAppSettings = $LocalAppSettingsTable(
    this,
  );
  late final $FavoriteDrinkRowsTable favoriteDrinkRows =
      $FavoriteDrinkRowsTable(this);
  late final $DrinkEntriesTable drinkEntries = $DrinkEntriesTable(this);
  late final $FeatureIdeasTable featureIdeas = $FeatureIdeasTable(this);
  late final $LocalRemindersTable localReminders = $LocalRemindersTable(this);
  late final $CustomLocationsTable customLocations = $CustomLocationsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localAppSettings,
    favoriteDrinkRows,
    drinkEntries,
    featureIdeas,
    localReminders,
    customLocations,
  ];
}

typedef $$LocalAppSettingsTableCreateCompanionBuilder =
    LocalAppSettingsCompanion Function({
      Value<int> id,
      required bool onboardingComplete,
      required String goalMode,
      required int caffeineLimitMg,
      required String themePreset,
      Value<bool> smartReminderEnabled,
    });
typedef $$LocalAppSettingsTableUpdateCompanionBuilder =
    LocalAppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingComplete,
      Value<String> goalMode,
      Value<int> caffeineLimitMg,
      Value<String> themePreset,
      Value<bool> smartReminderEnabled,
    });

class $$LocalAppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAppSettingsTable> {
  $$LocalAppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalMode => $composableBuilder(
    column: $table.goalMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caffeineLimitMg => $composableBuilder(
    column: $table.caffeineLimitMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreset => $composableBuilder(
    column: $table.themePreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get smartReminderEnabled => $composableBuilder(
    column: $table.smartReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAppSettingsTable> {
  $$LocalAppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalMode => $composableBuilder(
    column: $table.goalMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caffeineLimitMg => $composableBuilder(
    column: $table.caffeineLimitMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreset => $composableBuilder(
    column: $table.themePreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get smartReminderEnabled => $composableBuilder(
    column: $table.smartReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAppSettingsTable> {
  $$LocalAppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalMode =>
      $composableBuilder(column: $table.goalMode, builder: (column) => column);

  GeneratedColumn<int> get caffeineLimitMg => $composableBuilder(
    column: $table.caffeineLimitMg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themePreset => $composableBuilder(
    column: $table.themePreset,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get smartReminderEnabled => $composableBuilder(
    column: $table.smartReminderEnabled,
    builder: (column) => column,
  );
}

class $$LocalAppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAppSettingsTable,
          LocalAppSetting,
          $$LocalAppSettingsTableFilterComposer,
          $$LocalAppSettingsTableOrderingComposer,
          $$LocalAppSettingsTableAnnotationComposer,
          $$LocalAppSettingsTableCreateCompanionBuilder,
          $$LocalAppSettingsTableUpdateCompanionBuilder,
          (
            LocalAppSetting,
            BaseReferences<
              _$AppDatabase,
              $LocalAppSettingsTable,
              LocalAppSetting
            >,
          ),
          LocalAppSetting,
          PrefetchHooks Function()
        > {
  $$LocalAppSettingsTableTableManager(
    _$AppDatabase db,
    $LocalAppSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> goalMode = const Value.absent(),
                Value<int> caffeineLimitMg = const Value.absent(),
                Value<String> themePreset = const Value.absent(),
                Value<bool> smartReminderEnabled = const Value.absent(),
              }) => LocalAppSettingsCompanion(
                id: id,
                onboardingComplete: onboardingComplete,
                goalMode: goalMode,
                caffeineLimitMg: caffeineLimitMg,
                themePreset: themePreset,
                smartReminderEnabled: smartReminderEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required bool onboardingComplete,
                required String goalMode,
                required int caffeineLimitMg,
                required String themePreset,
                Value<bool> smartReminderEnabled = const Value.absent(),
              }) => LocalAppSettingsCompanion.insert(
                id: id,
                onboardingComplete: onboardingComplete,
                goalMode: goalMode,
                caffeineLimitMg: caffeineLimitMg,
                themePreset: themePreset,
                smartReminderEnabled: smartReminderEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAppSettingsTable,
      LocalAppSetting,
      $$LocalAppSettingsTableFilterComposer,
      $$LocalAppSettingsTableOrderingComposer,
      $$LocalAppSettingsTableAnnotationComposer,
      $$LocalAppSettingsTableCreateCompanionBuilder,
      $$LocalAppSettingsTableUpdateCompanionBuilder,
      (
        LocalAppSetting,
        BaseReferences<_$AppDatabase, $LocalAppSettingsTable, LocalAppSetting>,
      ),
      LocalAppSetting,
      PrefetchHooks Function()
    >;
typedef $$FavoriteDrinkRowsTableCreateCompanionBuilder =
    FavoriteDrinkRowsCompanion Function({
      required String drinkId,
      required int position,
      Value<int> rowid,
    });
typedef $$FavoriteDrinkRowsTableUpdateCompanionBuilder =
    FavoriteDrinkRowsCompanion Function({
      Value<String> drinkId,
      Value<int> position,
      Value<int> rowid,
    });

class $$FavoriteDrinkRowsTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteDrinkRowsTable> {
  $$FavoriteDrinkRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get drinkId => $composableBuilder(
    column: $table.drinkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoriteDrinkRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteDrinkRowsTable> {
  $$FavoriteDrinkRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get drinkId => $composableBuilder(
    column: $table.drinkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoriteDrinkRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteDrinkRowsTable> {
  $$FavoriteDrinkRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get drinkId =>
      $composableBuilder(column: $table.drinkId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$FavoriteDrinkRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteDrinkRowsTable,
          FavoriteDrinkRow,
          $$FavoriteDrinkRowsTableFilterComposer,
          $$FavoriteDrinkRowsTableOrderingComposer,
          $$FavoriteDrinkRowsTableAnnotationComposer,
          $$FavoriteDrinkRowsTableCreateCompanionBuilder,
          $$FavoriteDrinkRowsTableUpdateCompanionBuilder,
          (
            FavoriteDrinkRow,
            BaseReferences<
              _$AppDatabase,
              $FavoriteDrinkRowsTable,
              FavoriteDrinkRow
            >,
          ),
          FavoriteDrinkRow,
          PrefetchHooks Function()
        > {
  $$FavoriteDrinkRowsTableTableManager(
    _$AppDatabase db,
    $FavoriteDrinkRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteDrinkRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteDrinkRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteDrinkRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> drinkId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteDrinkRowsCompanion(
                drinkId: drinkId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String drinkId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteDrinkRowsCompanion.insert(
                drinkId: drinkId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteDrinkRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteDrinkRowsTable,
      FavoriteDrinkRow,
      $$FavoriteDrinkRowsTableFilterComposer,
      $$FavoriteDrinkRowsTableOrderingComposer,
      $$FavoriteDrinkRowsTableAnnotationComposer,
      $$FavoriteDrinkRowsTableCreateCompanionBuilder,
      $$FavoriteDrinkRowsTableUpdateCompanionBuilder,
      (
        FavoriteDrinkRow,
        BaseReferences<
          _$AppDatabase,
          $FavoriteDrinkRowsTable,
          FavoriteDrinkRow
        >,
      ),
      FavoriteDrinkRow,
      PrefetchHooks Function()
    >;
typedef $$DrinkEntriesTableCreateCompanionBuilder =
    DrinkEntriesCompanion Function({
      Value<int> id,
      required String name,
      required int caffeineMg,
      required int volumeMl,
      required DateTime consumedAtUtc,
      Value<int> priceCents,
      Value<String> temperature,
      Value<String> location,
      Value<String?> cafeName,
      Value<String> cupStyle,
      Value<String?> note,
      Value<String?> photoPath,
    });
typedef $$DrinkEntriesTableUpdateCompanionBuilder =
    DrinkEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> caffeineMg,
      Value<int> volumeMl,
      Value<DateTime> consumedAtUtc,
      Value<int> priceCents,
      Value<String> temperature,
      Value<String> location,
      Value<String?> cafeName,
      Value<String> cupStyle,
      Value<String?> note,
      Value<String?> photoPath,
    });

class $$DrinkEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DrinkEntriesTable> {
  $$DrinkEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caffeineMg => $composableBuilder(
    column: $table.caffeineMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volumeMl => $composableBuilder(
    column: $table.volumeMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consumedAtUtc => $composableBuilder(
    column: $table.consumedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cafeName => $composableBuilder(
    column: $table.cafeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cupStyle => $composableBuilder(
    column: $table.cupStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DrinkEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DrinkEntriesTable> {
  $$DrinkEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caffeineMg => $composableBuilder(
    column: $table.caffeineMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeMl => $composableBuilder(
    column: $table.volumeMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consumedAtUtc => $composableBuilder(
    column: $table.consumedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cafeName => $composableBuilder(
    column: $table.cafeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cupStyle => $composableBuilder(
    column: $table.cupStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DrinkEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrinkEntriesTable> {
  $$DrinkEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get caffeineMg => $composableBuilder(
    column: $table.caffeineMg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get volumeMl =>
      $composableBuilder(column: $table.volumeMl, builder: (column) => column);

  GeneratedColumn<DateTime> get consumedAtUtc => $composableBuilder(
    column: $table.consumedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get cafeName =>
      $composableBuilder(column: $table.cafeName, builder: (column) => column);

  GeneratedColumn<String> get cupStyle =>
      $composableBuilder(column: $table.cupStyle, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$DrinkEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrinkEntriesTable,
          DrinkEntry,
          $$DrinkEntriesTableFilterComposer,
          $$DrinkEntriesTableOrderingComposer,
          $$DrinkEntriesTableAnnotationComposer,
          $$DrinkEntriesTableCreateCompanionBuilder,
          $$DrinkEntriesTableUpdateCompanionBuilder,
          (
            DrinkEntry,
            BaseReferences<_$AppDatabase, $DrinkEntriesTable, DrinkEntry>,
          ),
          DrinkEntry,
          PrefetchHooks Function()
        > {
  $$DrinkEntriesTableTableManager(_$AppDatabase db, $DrinkEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrinkEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrinkEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrinkEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> caffeineMg = const Value.absent(),
                Value<int> volumeMl = const Value.absent(),
                Value<DateTime> consumedAtUtc = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<String> temperature = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String?> cafeName = const Value.absent(),
                Value<String> cupStyle = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => DrinkEntriesCompanion(
                id: id,
                name: name,
                caffeineMg: caffeineMg,
                volumeMl: volumeMl,
                consumedAtUtc: consumedAtUtc,
                priceCents: priceCents,
                temperature: temperature,
                location: location,
                cafeName: cafeName,
                cupStyle: cupStyle,
                note: note,
                photoPath: photoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int caffeineMg,
                required int volumeMl,
                required DateTime consumedAtUtc,
                Value<int> priceCents = const Value.absent(),
                Value<String> temperature = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String?> cafeName = const Value.absent(),
                Value<String> cupStyle = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => DrinkEntriesCompanion.insert(
                id: id,
                name: name,
                caffeineMg: caffeineMg,
                volumeMl: volumeMl,
                consumedAtUtc: consumedAtUtc,
                priceCents: priceCents,
                temperature: temperature,
                location: location,
                cafeName: cafeName,
                cupStyle: cupStyle,
                note: note,
                photoPath: photoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DrinkEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrinkEntriesTable,
      DrinkEntry,
      $$DrinkEntriesTableFilterComposer,
      $$DrinkEntriesTableOrderingComposer,
      $$DrinkEntriesTableAnnotationComposer,
      $$DrinkEntriesTableCreateCompanionBuilder,
      $$DrinkEntriesTableUpdateCompanionBuilder,
      (
        DrinkEntry,
        BaseReferences<_$AppDatabase, $DrinkEntriesTable, DrinkEntry>,
      ),
      DrinkEntry,
      PrefetchHooks Function()
    >;
typedef $$FeatureIdeasTableCreateCompanionBuilder =
    FeatureIdeasCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      Value<bool> anonymous,
      Value<bool> voted,
      required DateTime createdAtUtc,
    });
typedef $$FeatureIdeasTableUpdateCompanionBuilder =
    FeatureIdeasCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<bool> anonymous,
      Value<bool> voted,
      Value<DateTime> createdAtUtc,
    });

class $$FeatureIdeasTableFilterComposer
    extends Composer<_$AppDatabase, $FeatureIdeasTable> {
  $$FeatureIdeasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get anonymous => $composableBuilder(
    column: $table.anonymous,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get voted => $composableBuilder(
    column: $table.voted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeatureIdeasTableOrderingComposer
    extends Composer<_$AppDatabase, $FeatureIdeasTable> {
  $$FeatureIdeasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get anonymous => $composableBuilder(
    column: $table.anonymous,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get voted => $composableBuilder(
    column: $table.voted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeatureIdeasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeatureIdeasTable> {
  $$FeatureIdeasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get anonymous =>
      $composableBuilder(column: $table.anonymous, builder: (column) => column);

  GeneratedColumn<bool> get voted =>
      $composableBuilder(column: $table.voted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$FeatureIdeasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeatureIdeasTable,
          FeatureIdea,
          $$FeatureIdeasTableFilterComposer,
          $$FeatureIdeasTableOrderingComposer,
          $$FeatureIdeasTableAnnotationComposer,
          $$FeatureIdeasTableCreateCompanionBuilder,
          $$FeatureIdeasTableUpdateCompanionBuilder,
          (
            FeatureIdea,
            BaseReferences<_$AppDatabase, $FeatureIdeasTable, FeatureIdea>,
          ),
          FeatureIdea,
          PrefetchHooks Function()
        > {
  $$FeatureIdeasTableTableManager(_$AppDatabase db, $FeatureIdeasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatureIdeasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatureIdeasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeatureIdeasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> anonymous = const Value.absent(),
                Value<bool> voted = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
              }) => FeatureIdeasCompanion(
                id: id,
                title: title,
                description: description,
                anonymous: anonymous,
                voted: voted,
                createdAtUtc: createdAtUtc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                Value<bool> anonymous = const Value.absent(),
                Value<bool> voted = const Value.absent(),
                required DateTime createdAtUtc,
              }) => FeatureIdeasCompanion.insert(
                id: id,
                title: title,
                description: description,
                anonymous: anonymous,
                voted: voted,
                createdAtUtc: createdAtUtc,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeatureIdeasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeatureIdeasTable,
      FeatureIdea,
      $$FeatureIdeasTableFilterComposer,
      $$FeatureIdeasTableOrderingComposer,
      $$FeatureIdeasTableAnnotationComposer,
      $$FeatureIdeasTableCreateCompanionBuilder,
      $$FeatureIdeasTableUpdateCompanionBuilder,
      (
        FeatureIdea,
        BaseReferences<_$AppDatabase, $FeatureIdeasTable, FeatureIdea>,
      ),
      FeatureIdea,
      PrefetchHooks Function()
    >;
typedef $$LocalRemindersTableCreateCompanionBuilder =
    LocalRemindersCompanion Function({
      Value<int> id,
      required int hour,
      required int minute,
      Value<bool> enabled,
    });
typedef $$LocalRemindersTableUpdateCompanionBuilder =
    LocalRemindersCompanion Function({
      Value<int> id,
      Value<int> hour,
      Value<int> minute,
      Value<bool> enabled,
    });

class $$LocalRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRemindersTable> {
  $$LocalRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRemindersTable> {
  $$LocalRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRemindersTable> {
  $$LocalRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$LocalRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRemindersTable,
          LocalReminder,
          $$LocalRemindersTableFilterComposer,
          $$LocalRemindersTableOrderingComposer,
          $$LocalRemindersTableAnnotationComposer,
          $$LocalRemindersTableCreateCompanionBuilder,
          $$LocalRemindersTableUpdateCompanionBuilder,
          (
            LocalReminder,
            BaseReferences<_$AppDatabase, $LocalRemindersTable, LocalReminder>,
          ),
          LocalReminder,
          PrefetchHooks Function()
        > {
  $$LocalRemindersTableTableManager(
    _$AppDatabase db,
    $LocalRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => LocalRemindersCompanion(
                id: id,
                hour: hour,
                minute: minute,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int hour,
                required int minute,
                Value<bool> enabled = const Value.absent(),
              }) => LocalRemindersCompanion.insert(
                id: id,
                hour: hour,
                minute: minute,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRemindersTable,
      LocalReminder,
      $$LocalRemindersTableFilterComposer,
      $$LocalRemindersTableOrderingComposer,
      $$LocalRemindersTableAnnotationComposer,
      $$LocalRemindersTableCreateCompanionBuilder,
      $$LocalRemindersTableUpdateCompanionBuilder,
      (
        LocalReminder,
        BaseReferences<_$AppDatabase, $LocalRemindersTable, LocalReminder>,
      ),
      LocalReminder,
      PrefetchHooks Function()
    >;
typedef $$CustomLocationsTableCreateCompanionBuilder =
    CustomLocationsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAtUtc,
    });
typedef $$CustomLocationsTableUpdateCompanionBuilder =
    CustomLocationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAtUtc,
    });

class $$CustomLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomLocationsTable> {
  $$CustomLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomLocationsTable> {
  $$CustomLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomLocationsTable> {
  $$CustomLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$CustomLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomLocationsTable,
          CustomLocation,
          $$CustomLocationsTableFilterComposer,
          $$CustomLocationsTableOrderingComposer,
          $$CustomLocationsTableAnnotationComposer,
          $$CustomLocationsTableCreateCompanionBuilder,
          $$CustomLocationsTableUpdateCompanionBuilder,
          (
            CustomLocation,
            BaseReferences<
              _$AppDatabase,
              $CustomLocationsTable,
              CustomLocation
            >,
          ),
          CustomLocation,
          PrefetchHooks Function()
        > {
  $$CustomLocationsTableTableManager(
    _$AppDatabase db,
    $CustomLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
              }) => CustomLocationsCompanion(
                id: id,
                name: name,
                createdAtUtc: createdAtUtc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAtUtc,
              }) => CustomLocationsCompanion.insert(
                id: id,
                name: name,
                createdAtUtc: createdAtUtc,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomLocationsTable,
      CustomLocation,
      $$CustomLocationsTableFilterComposer,
      $$CustomLocationsTableOrderingComposer,
      $$CustomLocationsTableAnnotationComposer,
      $$CustomLocationsTableCreateCompanionBuilder,
      $$CustomLocationsTableUpdateCompanionBuilder,
      (
        CustomLocation,
        BaseReferences<_$AppDatabase, $CustomLocationsTable, CustomLocation>,
      ),
      CustomLocation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalAppSettingsTableTableManager get localAppSettings =>
      $$LocalAppSettingsTableTableManager(_db, _db.localAppSettings);
  $$FavoriteDrinkRowsTableTableManager get favoriteDrinkRows =>
      $$FavoriteDrinkRowsTableTableManager(_db, _db.favoriteDrinkRows);
  $$DrinkEntriesTableTableManager get drinkEntries =>
      $$DrinkEntriesTableTableManager(_db, _db.drinkEntries);
  $$FeatureIdeasTableTableManager get featureIdeas =>
      $$FeatureIdeasTableTableManager(_db, _db.featureIdeas);
  $$LocalRemindersTableTableManager get localReminders =>
      $$LocalRemindersTableTableManager(_db, _db.localReminders);
  $$CustomLocationsTableTableManager get customLocations =>
      $$CustomLocationsTableTableManager(_db, _db.customLocations);
}
