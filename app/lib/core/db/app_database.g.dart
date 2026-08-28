// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, displayName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String displayName;
  final DateTime createdAt;
  const Profile(
      {required this.id, required this.displayName, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({int? id, String? displayName, DateTime? createdAt}) =>
      Profile(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        createdAt: createdAt ?? this.createdAt,
      );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? displayName,
      Value<DateTime>? createdAt}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsJsonMeta =
      const VerificationMeta('detailsJson');
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
      'details_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, profileId, type, name, detailsJson, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(Insertable<Asset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('details_json')) {
      context.handle(
          _detailsJsonMeta,
          detailsJson.isAcceptableOrUnknown(
              data['details_json']!, _detailsJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      detailsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final int id;
  final int profileId;
  final String type;
  final String name;
  final String detailsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Asset(
      {required this.id,
      required this.profileId,
      required this.type,
      required this.name,
      required this.detailsJson,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['details_json'] = Variable<String>(detailsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      type: Value(type),
      name: Value(name),
      detailsJson: Value(detailsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Asset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      detailsJson: serializer.fromJson<String>(json['detailsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'detailsJson': serializer.toJson<String>(detailsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Asset copyWith(
          {int? id,
          int? profileId,
          String? type,
          String? name,
          String? detailsJson,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Asset(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        type: type ?? this.type,
        name: name ?? this.name,
        detailsJson: detailsJson ?? this.detailsJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      detailsJson:
          data.detailsJson.present ? data.detailsJson.value : this.detailsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, type, name, detailsJson, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.type == this.type &&
          other.name == this.name &&
          other.detailsJson == this.detailsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> type;
  final Value<String> name;
  final Value<String> detailsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AssetsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String type,
    required String name,
    this.detailsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : profileId = Value(profileId),
        type = Value(type),
        name = Value(name);
  static Insertable<Asset> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? detailsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (detailsJson != null) 'details_json': detailsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AssetsCompanion copyWith(
      {Value<int>? id,
      Value<int>? profileId,
      Value<String>? type,
      Value<String>? name,
      Value<String>? detailsJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AssetsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      type: type ?? this.type,
      name: name ?? this.name,
      detailsJson: detailsJson ?? this.detailsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PoliciesTable extends Policies with TableInfo<$PoliciesTable, Policy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoliciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<int> assetId = GeneratedColumn<int>(
      'asset_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _insuranceTypeMeta =
      const VerificationMeta('insuranceType');
  @override
  late final GeneratedColumn<String> insuranceType = GeneratedColumn<String>(
      'insurance_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _insurerMeta =
      const VerificationMeta('insurer');
  @override
  late final GeneratedColumn<String> insurer = GeneratedColumn<String>(
      'insurer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _insurerKeyMeta =
      const VerificationMeta('insurerKey');
  @override
  late final GeneratedColumn<String> insurerKey = GeneratedColumn<String>(
      'insurer_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _policyNumberMeta =
      const VerificationMeta('policyNumber');
  @override
  late final GeneratedColumn<String> policyNumber = GeneratedColumn<String>(
      'policy_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _policyTypeMeta =
      const VerificationMeta('policyType');
  @override
  late final GeneratedColumn<String> policyType = GeneratedColumn<String>(
      'policy_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _premiumCentsMeta =
      const VerificationMeta('premiumCents');
  @override
  late final GeneratedColumn<int> premiumCents = GeneratedColumn<int>(
      'premium_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _excessCentsMeta =
      const VerificationMeta('excessCents');
  @override
  late final GeneratedColumn<int> excessCents = GeneratedColumn<int>(
      'excess_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sumInsuredCentsMeta =
      const VerificationMeta('sumInsuredCents');
  @override
  late final GeneratedColumn<int> sumInsuredCents = GeneratedColumn<int>(
      'sum_insured_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _renewalDateMeta =
      const VerificationMeta('renewalDate');
  @override
  late final GeneratedColumn<DateTime> renewalDate = GeneratedColumn<DateTime>(
      'renewal_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        assetId,
        insuranceType,
        insurer,
        insurerKey,
        policyNumber,
        policyType,
        premiumCents,
        excessCents,
        sumInsuredCents,
        startDate,
        endDate,
        renewalDate,
        status,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'policies';
  @override
  VerificationContext validateIntegrity(Insertable<Policy> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    }
    if (data.containsKey('insurance_type')) {
      context.handle(
          _insuranceTypeMeta,
          insuranceType.isAcceptableOrUnknown(
              data['insurance_type']!, _insuranceTypeMeta));
    } else if (isInserting) {
      context.missing(_insuranceTypeMeta);
    }
    if (data.containsKey('insurer')) {
      context.handle(_insurerMeta,
          insurer.isAcceptableOrUnknown(data['insurer']!, _insurerMeta));
    } else if (isInserting) {
      context.missing(_insurerMeta);
    }
    if (data.containsKey('insurer_key')) {
      context.handle(
          _insurerKeyMeta,
          insurerKey.isAcceptableOrUnknown(
              data['insurer_key']!, _insurerKeyMeta));
    }
    if (data.containsKey('policy_number')) {
      context.handle(
          _policyNumberMeta,
          policyNumber.isAcceptableOrUnknown(
              data['policy_number']!, _policyNumberMeta));
    }
    if (data.containsKey('policy_type')) {
      context.handle(
          _policyTypeMeta,
          policyType.isAcceptableOrUnknown(
              data['policy_type']!, _policyTypeMeta));
    }
    if (data.containsKey('premium_cents')) {
      context.handle(
          _premiumCentsMeta,
          premiumCents.isAcceptableOrUnknown(
              data['premium_cents']!, _premiumCentsMeta));
    }
    if (data.containsKey('excess_cents')) {
      context.handle(
          _excessCentsMeta,
          excessCents.isAcceptableOrUnknown(
              data['excess_cents']!, _excessCentsMeta));
    }
    if (data.containsKey('sum_insured_cents')) {
      context.handle(
          _sumInsuredCentsMeta,
          sumInsuredCents.isAcceptableOrUnknown(
              data['sum_insured_cents']!, _sumInsuredCentsMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('renewal_date')) {
      context.handle(
          _renewalDateMeta,
          renewalDate.isAcceptableOrUnknown(
              data['renewal_date']!, _renewalDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Policy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Policy(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile_id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}asset_id']),
      insuranceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}insurance_type'])!,
      insurer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}insurer'])!,
      insurerKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}insurer_key']),
      policyNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}policy_number'])!,
      policyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}policy_type'])!,
      premiumCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}premium_cents'])!,
      excessCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}excess_cents'])!,
      sumInsuredCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sum_insured_cents'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      renewalDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}renewal_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PoliciesTable createAlias(String alias) {
    return $PoliciesTable(attachedDatabase, alias);
  }
}

class Policy extends DataClass implements Insertable<Policy> {
  final int id;
  final int profileId;
  final int? assetId;
  final String insuranceType;
  final String insurer;
  final String? insurerKey;
  final String policyNumber;
  final String policyType;
  final int premiumCents;
  final int excessCents;
  final int sumInsuredCents;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? renewalDate;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Policy(
      {required this.id,
      required this.profileId,
      this.assetId,
      required this.insuranceType,
      required this.insurer,
      this.insurerKey,
      required this.policyNumber,
      required this.policyType,
      required this.premiumCents,
      required this.excessCents,
      required this.sumInsuredCents,
      this.startDate,
      this.endDate,
      this.renewalDate,
      required this.status,
      required this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<int>(assetId);
    }
    map['insurance_type'] = Variable<String>(insuranceType);
    map['insurer'] = Variable<String>(insurer);
    if (!nullToAbsent || insurerKey != null) {
      map['insurer_key'] = Variable<String>(insurerKey);
    }
    map['policy_number'] = Variable<String>(policyNumber);
    map['policy_type'] = Variable<String>(policyType);
    map['premium_cents'] = Variable<int>(premiumCents);
    map['excess_cents'] = Variable<int>(excessCents);
    map['sum_insured_cents'] = Variable<int>(sumInsuredCents);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || renewalDate != null) {
      map['renewal_date'] = Variable<DateTime>(renewalDate);
    }
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PoliciesCompanion toCompanion(bool nullToAbsent) {
    return PoliciesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      insuranceType: Value(insuranceType),
      insurer: Value(insurer),
      insurerKey: insurerKey == null && nullToAbsent
          ? const Value.absent()
          : Value(insurerKey),
      policyNumber: Value(policyNumber),
      policyType: Value(policyType),
      premiumCents: Value(premiumCents),
      excessCents: Value(excessCents),
      sumInsuredCents: Value(sumInsuredCents),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      renewalDate: renewalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(renewalDate),
      status: Value(status),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Policy.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Policy(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      assetId: serializer.fromJson<int?>(json['assetId']),
      insuranceType: serializer.fromJson<String>(json['insuranceType']),
      insurer: serializer.fromJson<String>(json['insurer']),
      insurerKey: serializer.fromJson<String?>(json['insurerKey']),
      policyNumber: serializer.fromJson<String>(json['policyNumber']),
      policyType: serializer.fromJson<String>(json['policyType']),
      premiumCents: serializer.fromJson<int>(json['premiumCents']),
      excessCents: serializer.fromJson<int>(json['excessCents']),
      sumInsuredCents: serializer.fromJson<int>(json['sumInsuredCents']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      renewalDate: serializer.fromJson<DateTime?>(json['renewalDate']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'assetId': serializer.toJson<int?>(assetId),
      'insuranceType': serializer.toJson<String>(insuranceType),
      'insurer': serializer.toJson<String>(insurer),
      'insurerKey': serializer.toJson<String?>(insurerKey),
      'policyNumber': serializer.toJson<String>(policyNumber),
      'policyType': serializer.toJson<String>(policyType),
      'premiumCents': serializer.toJson<int>(premiumCents),
      'excessCents': serializer.toJson<int>(excessCents),
      'sumInsuredCents': serializer.toJson<int>(sumInsuredCents),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'renewalDate': serializer.toJson<DateTime?>(renewalDate),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Policy copyWith(
          {int? id,
          int? profileId,
          Value<int?> assetId = const Value.absent(),
          String? insuranceType,
          String? insurer,
          Value<String?> insurerKey = const Value.absent(),
          String? policyNumber,
          String? policyType,
          int? premiumCents,
          int? excessCents,
          int? sumInsuredCents,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<DateTime?> renewalDate = const Value.absent(),
          String? status,
          String? notes,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Policy(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        assetId: assetId.present ? assetId.value : this.assetId,
        insuranceType: insuranceType ?? this.insuranceType,
        insurer: insurer ?? this.insurer,
        insurerKey: insurerKey.present ? insurerKey.value : this.insurerKey,
        policyNumber: policyNumber ?? this.policyNumber,
        policyType: policyType ?? this.policyType,
        premiumCents: premiumCents ?? this.premiumCents,
        excessCents: excessCents ?? this.excessCents,
        sumInsuredCents: sumInsuredCents ?? this.sumInsuredCents,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        renewalDate: renewalDate.present ? renewalDate.value : this.renewalDate,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Policy copyWithCompanion(PoliciesCompanion data) {
    return Policy(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      insuranceType: data.insuranceType.present
          ? data.insuranceType.value
          : this.insuranceType,
      insurer: data.insurer.present ? data.insurer.value : this.insurer,
      insurerKey:
          data.insurerKey.present ? data.insurerKey.value : this.insurerKey,
      policyNumber: data.policyNumber.present
          ? data.policyNumber.value
          : this.policyNumber,
      policyType:
          data.policyType.present ? data.policyType.value : this.policyType,
      premiumCents: data.premiumCents.present
          ? data.premiumCents.value
          : this.premiumCents,
      excessCents:
          data.excessCents.present ? data.excessCents.value : this.excessCents,
      sumInsuredCents: data.sumInsuredCents.present
          ? data.sumInsuredCents.value
          : this.sumInsuredCents,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      renewalDate:
          data.renewalDate.present ? data.renewalDate.value : this.renewalDate,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Policy(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('assetId: $assetId, ')
          ..write('insuranceType: $insuranceType, ')
          ..write('insurer: $insurer, ')
          ..write('insurerKey: $insurerKey, ')
          ..write('policyNumber: $policyNumber, ')
          ..write('policyType: $policyType, ')
          ..write('premiumCents: $premiumCents, ')
          ..write('excessCents: $excessCents, ')
          ..write('sumInsuredCents: $sumInsuredCents, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('renewalDate: $renewalDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      assetId,
      insuranceType,
      insurer,
      insurerKey,
      policyNumber,
      policyType,
      premiumCents,
      excessCents,
      sumInsuredCents,
      startDate,
      endDate,
      renewalDate,
      status,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Policy &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.assetId == this.assetId &&
          other.insuranceType == this.insuranceType &&
          other.insurer == this.insurer &&
          other.insurerKey == this.insurerKey &&
          other.policyNumber == this.policyNumber &&
          other.policyType == this.policyType &&
          other.premiumCents == this.premiumCents &&
          other.excessCents == this.excessCents &&
          other.sumInsuredCents == this.sumInsuredCents &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.renewalDate == this.renewalDate &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PoliciesCompanion extends UpdateCompanion<Policy> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int?> assetId;
  final Value<String> insuranceType;
  final Value<String> insurer;
  final Value<String?> insurerKey;
  final Value<String> policyNumber;
  final Value<String> policyType;
  final Value<int> premiumCents;
  final Value<int> excessCents;
  final Value<int> sumInsuredCents;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> renewalDate;
  final Value<String> status;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PoliciesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.insuranceType = const Value.absent(),
    this.insurer = const Value.absent(),
    this.insurerKey = const Value.absent(),
    this.policyNumber = const Value.absent(),
    this.policyType = const Value.absent(),
    this.premiumCents = const Value.absent(),
    this.excessCents = const Value.absent(),
    this.sumInsuredCents = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.renewalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PoliciesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    this.assetId = const Value.absent(),
    required String insuranceType,
    required String insurer,
    this.insurerKey = const Value.absent(),
    this.policyNumber = const Value.absent(),
    this.policyType = const Value.absent(),
    this.premiumCents = const Value.absent(),
    this.excessCents = const Value.absent(),
    this.sumInsuredCents = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.renewalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : profileId = Value(profileId),
        insuranceType = Value(insuranceType),
        insurer = Value(insurer);
  static Insertable<Policy> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? assetId,
    Expression<String>? insuranceType,
    Expression<String>? insurer,
    Expression<String>? insurerKey,
    Expression<String>? policyNumber,
    Expression<String>? policyType,
    Expression<int>? premiumCents,
    Expression<int>? excessCents,
    Expression<int>? sumInsuredCents,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? renewalDate,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (assetId != null) 'asset_id': assetId,
      if (insuranceType != null) 'insurance_type': insuranceType,
      if (insurer != null) 'insurer': insurer,
      if (insurerKey != null) 'insurer_key': insurerKey,
      if (policyNumber != null) 'policy_number': policyNumber,
      if (policyType != null) 'policy_type': policyType,
      if (premiumCents != null) 'premium_cents': premiumCents,
      if (excessCents != null) 'excess_cents': excessCents,
      if (sumInsuredCents != null) 'sum_insured_cents': sumInsuredCents,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (renewalDate != null) 'renewal_date': renewalDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PoliciesCompanion copyWith(
      {Value<int>? id,
      Value<int>? profileId,
      Value<int?>? assetId,
      Value<String>? insuranceType,
      Value<String>? insurer,
      Value<String?>? insurerKey,
      Value<String>? policyNumber,
      Value<String>? policyType,
      Value<int>? premiumCents,
      Value<int>? excessCents,
      Value<int>? sumInsuredCents,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<DateTime?>? renewalDate,
      Value<String>? status,
      Value<String>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PoliciesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      assetId: assetId ?? this.assetId,
      insuranceType: insuranceType ?? this.insuranceType,
      insurer: insurer ?? this.insurer,
      insurerKey: insurerKey ?? this.insurerKey,
      policyNumber: policyNumber ?? this.policyNumber,
      policyType: policyType ?? this.policyType,
      premiumCents: premiumCents ?? this.premiumCents,
      excessCents: excessCents ?? this.excessCents,
      sumInsuredCents: sumInsuredCents ?? this.sumInsuredCents,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      renewalDate: renewalDate ?? this.renewalDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<int>(assetId.value);
    }
    if (insuranceType.present) {
      map['insurance_type'] = Variable<String>(insuranceType.value);
    }
    if (insurer.present) {
      map['insurer'] = Variable<String>(insurer.value);
    }
    if (insurerKey.present) {
      map['insurer_key'] = Variable<String>(insurerKey.value);
    }
    if (policyNumber.present) {
      map['policy_number'] = Variable<String>(policyNumber.value);
    }
    if (policyType.present) {
      map['policy_type'] = Variable<String>(policyType.value);
    }
    if (premiumCents.present) {
      map['premium_cents'] = Variable<int>(premiumCents.value);
    }
    if (excessCents.present) {
      map['excess_cents'] = Variable<int>(excessCents.value);
    }
    if (sumInsuredCents.present) {
      map['sum_insured_cents'] = Variable<int>(sumInsuredCents.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (renewalDate.present) {
      map['renewal_date'] = Variable<DateTime>(renewalDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoliciesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('assetId: $assetId, ')
          ..write('insuranceType: $insuranceType, ')
          ..write('insurer: $insurer, ')
          ..write('insurerKey: $insurerKey, ')
          ..write('policyNumber: $policyNumber, ')
          ..write('policyType: $policyType, ')
          ..write('premiumCents: $premiumCents, ')
          ..write('excessCents: $excessCents, ')
          ..write('sumInsuredCents: $sumInsuredCents, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('renewalDate: $renewalDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, Quote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _policyIdMeta =
      const VerificationMeta('policyId');
  @override
  late final GeneratedColumn<int> policyId = GeneratedColumn<int>(
      'policy_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _insurerMeta =
      const VerificationMeta('insurer');
  @override
  late final GeneratedColumn<String> insurer = GeneratedColumn<String>(
      'insurer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _premiumCentsMeta =
      const VerificationMeta('premiumCents');
  @override
  late final GeneratedColumn<int> premiumCents = GeneratedColumn<int>(
      'premium_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _excessCentsMeta =
      const VerificationMeta('excessCents');
  @override
  late final GeneratedColumn<int> excessCents = GeneratedColumn<int>(
      'excess_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sumInsuredCentsMeta =
      const VerificationMeta('sumInsuredCents');
  @override
  late final GeneratedColumn<int> sumInsuredCents = GeneratedColumn<int>(
      'sum_insured_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _coverSummaryMeta =
      const VerificationMeta('coverSummary');
  @override
  late final GeneratedColumn<String> coverSummary = GeneratedColumn<String>(
      'cover_summary', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isMockMeta = const VerificationMeta('isMock');
  @override
  late final GeneratedColumn<bool> isMock = GeneratedColumn<bool>(
      'is_mock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_mock" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sourceFileMeta =
      const VerificationMeta('sourceFile');
  @override
  late final GeneratedColumn<String> sourceFile = GeneratedColumn<String>(
      'source_file', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        policyId,
        insurer,
        premiumCents,
        excessCents,
        sumInsuredCents,
        coverSummary,
        isMock,
        sourceFile,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotes';
  @override
  VerificationContext validateIntegrity(Insertable<Quote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('policy_id')) {
      context.handle(_policyIdMeta,
          policyId.isAcceptableOrUnknown(data['policy_id']!, _policyIdMeta));
    } else if (isInserting) {
      context.missing(_policyIdMeta);
    }
    if (data.containsKey('insurer')) {
      context.handle(_insurerMeta,
          insurer.isAcceptableOrUnknown(data['insurer']!, _insurerMeta));
    } else if (isInserting) {
      context.missing(_insurerMeta);
    }
    if (data.containsKey('premium_cents')) {
      context.handle(
          _premiumCentsMeta,
          premiumCents.isAcceptableOrUnknown(
              data['premium_cents']!, _premiumCentsMeta));
    }
    if (data.containsKey('excess_cents')) {
      context.handle(
          _excessCentsMeta,
          excessCents.isAcceptableOrUnknown(
              data['excess_cents']!, _excessCentsMeta));
    }
    if (data.containsKey('sum_insured_cents')) {
      context.handle(
          _sumInsuredCentsMeta,
          sumInsuredCents.isAcceptableOrUnknown(
              data['sum_insured_cents']!, _sumInsuredCentsMeta));
    }
    if (data.containsKey('cover_summary')) {
      context.handle(
          _coverSummaryMeta,
          coverSummary.isAcceptableOrUnknown(
              data['cover_summary']!, _coverSummaryMeta));
    }
    if (data.containsKey('is_mock')) {
      context.handle(_isMockMeta,
          isMock.isAcceptableOrUnknown(data['is_mock']!, _isMockMeta));
    }
    if (data.containsKey('source_file')) {
      context.handle(
          _sourceFileMeta,
          sourceFile.isAcceptableOrUnknown(
              data['source_file']!, _sourceFileMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      policyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}policy_id'])!,
      insurer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}insurer'])!,
      premiumCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}premium_cents'])!,
      excessCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}excess_cents'])!,
      sumInsuredCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sum_insured_cents'])!,
      coverSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_summary'])!,
      isMock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_mock'])!,
      sourceFile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_file'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(attachedDatabase, alias);
  }
}

class Quote extends DataClass implements Insertable<Quote> {
  final int id;
  final int policyId;
  final String insurer;
  final int premiumCents;
  final int excessCents;
  final int sumInsuredCents;
  final String coverSummary;
  final bool isMock;
  final String sourceFile;
  final DateTime createdAt;
  const Quote(
      {required this.id,
      required this.policyId,
      required this.insurer,
      required this.premiumCents,
      required this.excessCents,
      required this.sumInsuredCents,
      required this.coverSummary,
      required this.isMock,
      required this.sourceFile,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['policy_id'] = Variable<int>(policyId);
    map['insurer'] = Variable<String>(insurer);
    map['premium_cents'] = Variable<int>(premiumCents);
    map['excess_cents'] = Variable<int>(excessCents);
    map['sum_insured_cents'] = Variable<int>(sumInsuredCents);
    map['cover_summary'] = Variable<String>(coverSummary);
    map['is_mock'] = Variable<bool>(isMock);
    map['source_file'] = Variable<String>(sourceFile);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuotesCompanion toCompanion(bool nullToAbsent) {
    return QuotesCompanion(
      id: Value(id),
      policyId: Value(policyId),
      insurer: Value(insurer),
      premiumCents: Value(premiumCents),
      excessCents: Value(excessCents),
      sumInsuredCents: Value(sumInsuredCents),
      coverSummary: Value(coverSummary),
      isMock: Value(isMock),
      sourceFile: Value(sourceFile),
      createdAt: Value(createdAt),
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quote(
      id: serializer.fromJson<int>(json['id']),
      policyId: serializer.fromJson<int>(json['policyId']),
      insurer: serializer.fromJson<String>(json['insurer']),
      premiumCents: serializer.fromJson<int>(json['premiumCents']),
      excessCents: serializer.fromJson<int>(json['excessCents']),
      sumInsuredCents: serializer.fromJson<int>(json['sumInsuredCents']),
      coverSummary: serializer.fromJson<String>(json['coverSummary']),
      isMock: serializer.fromJson<bool>(json['isMock']),
      sourceFile: serializer.fromJson<String>(json['sourceFile']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'policyId': serializer.toJson<int>(policyId),
      'insurer': serializer.toJson<String>(insurer),
      'premiumCents': serializer.toJson<int>(premiumCents),
      'excessCents': serializer.toJson<int>(excessCents),
      'sumInsuredCents': serializer.toJson<int>(sumInsuredCents),
      'coverSummary': serializer.toJson<String>(coverSummary),
      'isMock': serializer.toJson<bool>(isMock),
      'sourceFile': serializer.toJson<String>(sourceFile),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Quote copyWith(
          {int? id,
          int? policyId,
          String? insurer,
          int? premiumCents,
          int? excessCents,
          int? sumInsuredCents,
          String? coverSummary,
          bool? isMock,
          String? sourceFile,
          DateTime? createdAt}) =>
      Quote(
        id: id ?? this.id,
        policyId: policyId ?? this.policyId,
        insurer: insurer ?? this.insurer,
        premiumCents: premiumCents ?? this.premiumCents,
        excessCents: excessCents ?? this.excessCents,
        sumInsuredCents: sumInsuredCents ?? this.sumInsuredCents,
        coverSummary: coverSummary ?? this.coverSummary,
        isMock: isMock ?? this.isMock,
        sourceFile: sourceFile ?? this.sourceFile,
        createdAt: createdAt ?? this.createdAt,
      );
  Quote copyWithCompanion(QuotesCompanion data) {
    return Quote(
      id: data.id.present ? data.id.value : this.id,
      policyId: data.policyId.present ? data.policyId.value : this.policyId,
      insurer: data.insurer.present ? data.insurer.value : this.insurer,
      premiumCents: data.premiumCents.present
          ? data.premiumCents.value
          : this.premiumCents,
      excessCents:
          data.excessCents.present ? data.excessCents.value : this.excessCents,
      sumInsuredCents: data.sumInsuredCents.present
          ? data.sumInsuredCents.value
          : this.sumInsuredCents,
      coverSummary: data.coverSummary.present
          ? data.coverSummary.value
          : this.coverSummary,
      isMock: data.isMock.present ? data.isMock.value : this.isMock,
      sourceFile:
          data.sourceFile.present ? data.sourceFile.value : this.sourceFile,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quote(')
          ..write('id: $id, ')
          ..write('policyId: $policyId, ')
          ..write('insurer: $insurer, ')
          ..write('premiumCents: $premiumCents, ')
          ..write('excessCents: $excessCents, ')
          ..write('sumInsuredCents: $sumInsuredCents, ')
          ..write('coverSummary: $coverSummary, ')
          ..write('isMock: $isMock, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      policyId,
      insurer,
      premiumCents,
      excessCents,
      sumInsuredCents,
      coverSummary,
      isMock,
      sourceFile,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quote &&
          other.id == this.id &&
          other.policyId == this.policyId &&
          other.insurer == this.insurer &&
          other.premiumCents == this.premiumCents &&
          other.excessCents == this.excessCents &&
          other.sumInsuredCents == this.sumInsuredCents &&
          other.coverSummary == this.coverSummary &&
          other.isMock == this.isMock &&
          other.sourceFile == this.sourceFile &&
          other.createdAt == this.createdAt);
}

class QuotesCompanion extends UpdateCompanion<Quote> {
  final Value<int> id;
  final Value<int> policyId;
  final Value<String> insurer;
  final Value<int> premiumCents;
  final Value<int> excessCents;
  final Value<int> sumInsuredCents;
  final Value<String> coverSummary;
  final Value<bool> isMock;
  final Value<String> sourceFile;
  final Value<DateTime> createdAt;
  const QuotesCompanion({
    this.id = const Value.absent(),
    this.policyId = const Value.absent(),
    this.insurer = const Value.absent(),
    this.premiumCents = const Value.absent(),
    this.excessCents = const Value.absent(),
    this.sumInsuredCents = const Value.absent(),
    this.coverSummary = const Value.absent(),
    this.isMock = const Value.absent(),
    this.sourceFile = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuotesCompanion.insert({
    this.id = const Value.absent(),
    required int policyId,
    required String insurer,
    this.premiumCents = const Value.absent(),
    this.excessCents = const Value.absent(),
    this.sumInsuredCents = const Value.absent(),
    this.coverSummary = const Value.absent(),
    this.isMock = const Value.absent(),
    this.sourceFile = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : policyId = Value(policyId),
        insurer = Value(insurer);
  static Insertable<Quote> custom({
    Expression<int>? id,
    Expression<int>? policyId,
    Expression<String>? insurer,
    Expression<int>? premiumCents,
    Expression<int>? excessCents,
    Expression<int>? sumInsuredCents,
    Expression<String>? coverSummary,
    Expression<bool>? isMock,
    Expression<String>? sourceFile,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (policyId != null) 'policy_id': policyId,
      if (insurer != null) 'insurer': insurer,
      if (premiumCents != null) 'premium_cents': premiumCents,
      if (excessCents != null) 'excess_cents': excessCents,
      if (sumInsuredCents != null) 'sum_insured_cents': sumInsuredCents,
      if (coverSummary != null) 'cover_summary': coverSummary,
      if (isMock != null) 'is_mock': isMock,
      if (sourceFile != null) 'source_file': sourceFile,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuotesCompanion copyWith(
      {Value<int>? id,
      Value<int>? policyId,
      Value<String>? insurer,
      Value<int>? premiumCents,
      Value<int>? excessCents,
      Value<int>? sumInsuredCents,
      Value<String>? coverSummary,
      Value<bool>? isMock,
      Value<String>? sourceFile,
      Value<DateTime>? createdAt}) {
    return QuotesCompanion(
      id: id ?? this.id,
      policyId: policyId ?? this.policyId,
      insurer: insurer ?? this.insurer,
      premiumCents: premiumCents ?? this.premiumCents,
      excessCents: excessCents ?? this.excessCents,
      sumInsuredCents: sumInsuredCents ?? this.sumInsuredCents,
      coverSummary: coverSummary ?? this.coverSummary,
      isMock: isMock ?? this.isMock,
      sourceFile: sourceFile ?? this.sourceFile,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (policyId.present) {
      map['policy_id'] = Variable<int>(policyId.value);
    }
    if (insurer.present) {
      map['insurer'] = Variable<String>(insurer.value);
    }
    if (premiumCents.present) {
      map['premium_cents'] = Variable<int>(premiumCents.value);
    }
    if (excessCents.present) {
      map['excess_cents'] = Variable<int>(excessCents.value);
    }
    if (sumInsuredCents.present) {
      map['sum_insured_cents'] = Variable<int>(sumInsuredCents.value);
    }
    if (coverSummary.present) {
      map['cover_summary'] = Variable<String>(coverSummary.value);
    }
    if (isMock.present) {
      map['is_mock'] = Variable<bool>(isMock.value);
    }
    if (sourceFile.present) {
      map['source_file'] = Variable<String>(sourceFile.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotesCompanion(')
          ..write('id: $id, ')
          ..write('policyId: $policyId, ')
          ..write('insurer: $insurer, ')
          ..write('premiumCents: $premiumCents, ')
          ..write('excessCents: $excessCents, ')
          ..write('sumInsuredCents: $sumInsuredCents, ')
          ..write('coverSummary: $coverSummary, ')
          ..write('isMock: $isMock, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _policyIdMeta =
      const VerificationMeta('policyId');
  @override
  late final GeneratedColumn<int> policyId = GeneratedColumn<int>(
      'policy_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('other'));
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _extractedJsonMeta =
      const VerificationMeta('extractedJson');
  @override
  late final GeneratedColumn<String> extractedJson = GeneratedColumn<String>(
      'extracted_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, policyId, kind, fileName, localPath, extractedJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('policy_id')) {
      context.handle(_policyIdMeta,
          policyId.isAcceptableOrUnknown(data['policy_id']!, _policyIdMeta));
    } else if (isInserting) {
      context.missing(_policyIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('extracted_json')) {
      context.handle(
          _extractedJsonMeta,
          extractedJson.isAcceptableOrUnknown(
              data['extracted_json']!, _extractedJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      policyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}policy_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      extractedJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extracted_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final int policyId;
  final String kind;
  final String fileName;
  final String localPath;
  final String extractedJson;
  final DateTime createdAt;
  const Document(
      {required this.id,
      required this.policyId,
      required this.kind,
      required this.fileName,
      required this.localPath,
      required this.extractedJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['policy_id'] = Variable<int>(policyId);
    map['kind'] = Variable<String>(kind);
    map['file_name'] = Variable<String>(fileName);
    map['local_path'] = Variable<String>(localPath);
    map['extracted_json'] = Variable<String>(extractedJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      policyId: Value(policyId),
      kind: Value(kind),
      fileName: Value(fileName),
      localPath: Value(localPath),
      extractedJson: Value(extractedJson),
      createdAt: Value(createdAt),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      policyId: serializer.fromJson<int>(json['policyId']),
      kind: serializer.fromJson<String>(json['kind']),
      fileName: serializer.fromJson<String>(json['fileName']),
      localPath: serializer.fromJson<String>(json['localPath']),
      extractedJson: serializer.fromJson<String>(json['extractedJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'policyId': serializer.toJson<int>(policyId),
      'kind': serializer.toJson<String>(kind),
      'fileName': serializer.toJson<String>(fileName),
      'localPath': serializer.toJson<String>(localPath),
      'extractedJson': serializer.toJson<String>(extractedJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Document copyWith(
          {int? id,
          int? policyId,
          String? kind,
          String? fileName,
          String? localPath,
          String? extractedJson,
          DateTime? createdAt}) =>
      Document(
        id: id ?? this.id,
        policyId: policyId ?? this.policyId,
        kind: kind ?? this.kind,
        fileName: fileName ?? this.fileName,
        localPath: localPath ?? this.localPath,
        extractedJson: extractedJson ?? this.extractedJson,
        createdAt: createdAt ?? this.createdAt,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      policyId: data.policyId.present ? data.policyId.value : this.policyId,
      kind: data.kind.present ? data.kind.value : this.kind,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      extractedJson: data.extractedJson.present
          ? data.extractedJson.value
          : this.extractedJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('policyId: $policyId, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('extractedJson: $extractedJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, policyId, kind, fileName, localPath, extractedJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.policyId == this.policyId &&
          other.kind == this.kind &&
          other.fileName == this.fileName &&
          other.localPath == this.localPath &&
          other.extractedJson == this.extractedJson &&
          other.createdAt == this.createdAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<int> policyId;
  final Value<String> kind;
  final Value<String> fileName;
  final Value<String> localPath;
  final Value<String> extractedJson;
  final Value<DateTime> createdAt;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.policyId = const Value.absent(),
    this.kind = const Value.absent(),
    this.fileName = const Value.absent(),
    this.localPath = const Value.absent(),
    this.extractedJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    required int policyId,
    this.kind = const Value.absent(),
    required String fileName,
    required String localPath,
    this.extractedJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : policyId = Value(policyId),
        fileName = Value(fileName),
        localPath = Value(localPath);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<int>? policyId,
    Expression<String>? kind,
    Expression<String>? fileName,
    Expression<String>? localPath,
    Expression<String>? extractedJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (policyId != null) 'policy_id': policyId,
      if (kind != null) 'kind': kind,
      if (fileName != null) 'file_name': fileName,
      if (localPath != null) 'local_path': localPath,
      if (extractedJson != null) 'extracted_json': extractedJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocumentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? policyId,
      Value<String>? kind,
      Value<String>? fileName,
      Value<String>? localPath,
      Value<String>? extractedJson,
      Value<DateTime>? createdAt}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      policyId: policyId ?? this.policyId,
      kind: kind ?? this.kind,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      extractedJson: extractedJson ?? this.extractedJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (policyId.present) {
      map['policy_id'] = Variable<int>(policyId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (extractedJson.present) {
      map['extracted_json'] = Variable<String>(extractedJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('policyId: $policyId, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('extractedJson: $extractedJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $PoliciesTable policies = $PoliciesTable(this);
  late final $QuotesTable quotes = $QuotesTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [profiles, assets, policies, quotes, documents];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> displayName,
  Value<DateTime> createdAt,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> displayName,
  Value<DateTime> createdAt,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
    Profile,
    PrefetchHooks Function()> {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ProfilesCompanion(
            id: id,
            displayName: displayName,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            id: id,
            displayName: displayName,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
    Profile,
    PrefetchHooks Function()>;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  Value<int> id,
  required int profileId,
  required String type,
  required String name,
  Value<String> detailsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> type,
  Value<String> name,
  Value<String> detailsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
    Asset,
    PrefetchHooks Function()> {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> profileId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> detailsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AssetsCompanion(
            id: id,
            profileId: profileId,
            type: type,
            name: name,
            detailsJson: detailsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int profileId,
            required String type,
            required String name,
            Value<String> detailsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AssetsCompanion.insert(
            id: id,
            profileId: profileId,
            type: type,
            name: name,
            detailsJson: detailsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
    Asset,
    PrefetchHooks Function()>;
typedef $$PoliciesTableCreateCompanionBuilder = PoliciesCompanion Function({
  Value<int> id,
  required int profileId,
  Value<int?> assetId,
  required String insuranceType,
  required String insurer,
  Value<String?> insurerKey,
  Value<String> policyNumber,
  Value<String> policyType,
  Value<int> premiumCents,
  Value<int> excessCents,
  Value<int> sumInsuredCents,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime?> renewalDate,
  Value<String> status,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$PoliciesTableUpdateCompanionBuilder = PoliciesCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<int?> assetId,
  Value<String> insuranceType,
  Value<String> insurer,
  Value<String?> insurerKey,
  Value<String> policyNumber,
  Value<String> policyType,
  Value<int> premiumCents,
  Value<int> excessCents,
  Value<int> sumInsuredCents,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime?> renewalDate,
  Value<String> status,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$PoliciesTableFilterComposer
    extends Composer<_$AppDatabase, $PoliciesTable> {
  $$PoliciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assetId => $composableBuilder(
      column: $table.assetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insuranceType => $composableBuilder(
      column: $table.insuranceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insurer => $composableBuilder(
      column: $table.insurer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insurerKey => $composableBuilder(
      column: $table.insurerKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get policyNumber => $composableBuilder(
      column: $table.policyNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get policyType => $composableBuilder(
      column: $table.policyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get premiumCents => $composableBuilder(
      column: $table.premiumCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get excessCents => $composableBuilder(
      column: $table.excessCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sumInsuredCents => $composableBuilder(
      column: $table.sumInsuredCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get renewalDate => $composableBuilder(
      column: $table.renewalDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PoliciesTableOrderingComposer
    extends Composer<_$AppDatabase, $PoliciesTable> {
  $$PoliciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assetId => $composableBuilder(
      column: $table.assetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insuranceType => $composableBuilder(
      column: $table.insuranceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insurer => $composableBuilder(
      column: $table.insurer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insurerKey => $composableBuilder(
      column: $table.insurerKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get policyNumber => $composableBuilder(
      column: $table.policyNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get policyType => $composableBuilder(
      column: $table.policyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get premiumCents => $composableBuilder(
      column: $table.premiumCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get excessCents => $composableBuilder(
      column: $table.excessCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sumInsuredCents => $composableBuilder(
      column: $table.sumInsuredCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get renewalDate => $composableBuilder(
      column: $table.renewalDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PoliciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoliciesTable> {
  $$PoliciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get insuranceType => $composableBuilder(
      column: $table.insuranceType, builder: (column) => column);

  GeneratedColumn<String> get insurer =>
      $composableBuilder(column: $table.insurer, builder: (column) => column);

  GeneratedColumn<String> get insurerKey => $composableBuilder(
      column: $table.insurerKey, builder: (column) => column);

  GeneratedColumn<String> get policyNumber => $composableBuilder(
      column: $table.policyNumber, builder: (column) => column);

  GeneratedColumn<String> get policyType => $composableBuilder(
      column: $table.policyType, builder: (column) => column);

  GeneratedColumn<int> get premiumCents => $composableBuilder(
      column: $table.premiumCents, builder: (column) => column);

  GeneratedColumn<int> get excessCents => $composableBuilder(
      column: $table.excessCents, builder: (column) => column);

  GeneratedColumn<int> get sumInsuredCents => $composableBuilder(
      column: $table.sumInsuredCents, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get renewalDate => $composableBuilder(
      column: $table.renewalDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PoliciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PoliciesTable,
    Policy,
    $$PoliciesTableFilterComposer,
    $$PoliciesTableOrderingComposer,
    $$PoliciesTableAnnotationComposer,
    $$PoliciesTableCreateCompanionBuilder,
    $$PoliciesTableUpdateCompanionBuilder,
    (Policy, BaseReferences<_$AppDatabase, $PoliciesTable, Policy>),
    Policy,
    PrefetchHooks Function()> {
  $$PoliciesTableTableManager(_$AppDatabase db, $PoliciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoliciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PoliciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PoliciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> profileId = const Value.absent(),
            Value<int?> assetId = const Value.absent(),
            Value<String> insuranceType = const Value.absent(),
            Value<String> insurer = const Value.absent(),
            Value<String?> insurerKey = const Value.absent(),
            Value<String> policyNumber = const Value.absent(),
            Value<String> policyType = const Value.absent(),
            Value<int> premiumCents = const Value.absent(),
            Value<int> excessCents = const Value.absent(),
            Value<int> sumInsuredCents = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime?> renewalDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PoliciesCompanion(
            id: id,
            profileId: profileId,
            assetId: assetId,
            insuranceType: insuranceType,
            insurer: insurer,
            insurerKey: insurerKey,
            policyNumber: policyNumber,
            policyType: policyType,
            premiumCents: premiumCents,
            excessCents: excessCents,
            sumInsuredCents: sumInsuredCents,
            startDate: startDate,
            endDate: endDate,
            renewalDate: renewalDate,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int profileId,
            Value<int?> assetId = const Value.absent(),
            required String insuranceType,
            required String insurer,
            Value<String?> insurerKey = const Value.absent(),
            Value<String> policyNumber = const Value.absent(),
            Value<String> policyType = const Value.absent(),
            Value<int> premiumCents = const Value.absent(),
            Value<int> excessCents = const Value.absent(),
            Value<int> sumInsuredCents = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime?> renewalDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PoliciesCompanion.insert(
            id: id,
            profileId: profileId,
            assetId: assetId,
            insuranceType: insuranceType,
            insurer: insurer,
            insurerKey: insurerKey,
            policyNumber: policyNumber,
            policyType: policyType,
            premiumCents: premiumCents,
            excessCents: excessCents,
            sumInsuredCents: sumInsuredCents,
            startDate: startDate,
            endDate: endDate,
            renewalDate: renewalDate,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PoliciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PoliciesTable,
    Policy,
    $$PoliciesTableFilterComposer,
    $$PoliciesTableOrderingComposer,
    $$PoliciesTableAnnotationComposer,
    $$PoliciesTableCreateCompanionBuilder,
    $$PoliciesTableUpdateCompanionBuilder,
    (Policy, BaseReferences<_$AppDatabase, $PoliciesTable, Policy>),
    Policy,
    PrefetchHooks Function()>;
typedef $$QuotesTableCreateCompanionBuilder = QuotesCompanion Function({
  Value<int> id,
  required int policyId,
  required String insurer,
  Value<int> premiumCents,
  Value<int> excessCents,
  Value<int> sumInsuredCents,
  Value<String> coverSummary,
  Value<bool> isMock,
  Value<String> sourceFile,
  Value<DateTime> createdAt,
});
typedef $$QuotesTableUpdateCompanionBuilder = QuotesCompanion Function({
  Value<int> id,
  Value<int> policyId,
  Value<String> insurer,
  Value<int> premiumCents,
  Value<int> excessCents,
  Value<int> sumInsuredCents,
  Value<String> coverSummary,
  Value<bool> isMock,
  Value<String> sourceFile,
  Value<DateTime> createdAt,
});

class $$QuotesTableFilterComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get policyId => $composableBuilder(
      column: $table.policyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insurer => $composableBuilder(
      column: $table.insurer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get premiumCents => $composableBuilder(
      column: $table.premiumCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get excessCents => $composableBuilder(
      column: $table.excessCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sumInsuredCents => $composableBuilder(
      column: $table.sumInsuredCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverSummary => $composableBuilder(
      column: $table.coverSummary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMock => $composableBuilder(
      column: $table.isMock, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceFile => $composableBuilder(
      column: $table.sourceFile, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$QuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get policyId => $composableBuilder(
      column: $table.policyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insurer => $composableBuilder(
      column: $table.insurer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get premiumCents => $composableBuilder(
      column: $table.premiumCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get excessCents => $composableBuilder(
      column: $table.excessCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sumInsuredCents => $composableBuilder(
      column: $table.sumInsuredCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverSummary => $composableBuilder(
      column: $table.coverSummary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMock => $composableBuilder(
      column: $table.isMock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceFile => $composableBuilder(
      column: $table.sourceFile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$QuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get policyId =>
      $composableBuilder(column: $table.policyId, builder: (column) => column);

  GeneratedColumn<String> get insurer =>
      $composableBuilder(column: $table.insurer, builder: (column) => column);

  GeneratedColumn<int> get premiumCents => $composableBuilder(
      column: $table.premiumCents, builder: (column) => column);

  GeneratedColumn<int> get excessCents => $composableBuilder(
      column: $table.excessCents, builder: (column) => column);

  GeneratedColumn<int> get sumInsuredCents => $composableBuilder(
      column: $table.sumInsuredCents, builder: (column) => column);

  GeneratedColumn<String> get coverSummary => $composableBuilder(
      column: $table.coverSummary, builder: (column) => column);

  GeneratedColumn<bool> get isMock =>
      $composableBuilder(column: $table.isMock, builder: (column) => column);

  GeneratedColumn<String> get sourceFile => $composableBuilder(
      column: $table.sourceFile, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$QuotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuotesTable,
    Quote,
    $$QuotesTableFilterComposer,
    $$QuotesTableOrderingComposer,
    $$QuotesTableAnnotationComposer,
    $$QuotesTableCreateCompanionBuilder,
    $$QuotesTableUpdateCompanionBuilder,
    (Quote, BaseReferences<_$AppDatabase, $QuotesTable, Quote>),
    Quote,
    PrefetchHooks Function()> {
  $$QuotesTableTableManager(_$AppDatabase db, $QuotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> policyId = const Value.absent(),
            Value<String> insurer = const Value.absent(),
            Value<int> premiumCents = const Value.absent(),
            Value<int> excessCents = const Value.absent(),
            Value<int> sumInsuredCents = const Value.absent(),
            Value<String> coverSummary = const Value.absent(),
            Value<bool> isMock = const Value.absent(),
            Value<String> sourceFile = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              QuotesCompanion(
            id: id,
            policyId: policyId,
            insurer: insurer,
            premiumCents: premiumCents,
            excessCents: excessCents,
            sumInsuredCents: sumInsuredCents,
            coverSummary: coverSummary,
            isMock: isMock,
            sourceFile: sourceFile,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int policyId,
            required String insurer,
            Value<int> premiumCents = const Value.absent(),
            Value<int> excessCents = const Value.absent(),
            Value<int> sumInsuredCents = const Value.absent(),
            Value<String> coverSummary = const Value.absent(),
            Value<bool> isMock = const Value.absent(),
            Value<String> sourceFile = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              QuotesCompanion.insert(
            id: id,
            policyId: policyId,
            insurer: insurer,
            premiumCents: premiumCents,
            excessCents: excessCents,
            sumInsuredCents: sumInsuredCents,
            coverSummary: coverSummary,
            isMock: isMock,
            sourceFile: sourceFile,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuotesTable,
    Quote,
    $$QuotesTableFilterComposer,
    $$QuotesTableOrderingComposer,
    $$QuotesTableAnnotationComposer,
    $$QuotesTableCreateCompanionBuilder,
    $$QuotesTableUpdateCompanionBuilder,
    (Quote, BaseReferences<_$AppDatabase, $QuotesTable, Quote>),
    Quote,
    PrefetchHooks Function()>;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  required int policyId,
  Value<String> kind,
  required String fileName,
  required String localPath,
  Value<String> extractedJson,
  Value<DateTime> createdAt,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<int> policyId,
  Value<String> kind,
  Value<String> fileName,
  Value<String> localPath,
  Value<String> extractedJson,
  Value<DateTime> createdAt,
});

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get policyId => $composableBuilder(
      column: $table.policyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extractedJson => $composableBuilder(
      column: $table.extractedJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get policyId => $composableBuilder(
      column: $table.policyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extractedJson => $composableBuilder(
      column: $table.extractedJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get policyId =>
      $composableBuilder(column: $table.policyId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get extractedJson => $composableBuilder(
      column: $table.extractedJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> policyId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<String> extractedJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            policyId: policyId,
            kind: kind,
            fileName: fileName,
            localPath: localPath,
            extractedJson: extractedJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int policyId,
            Value<String> kind = const Value.absent(),
            required String fileName,
            required String localPath,
            Value<String> extractedJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            policyId: policyId,
            kind: kind,
            fileName: fileName,
            localPath: localPath,
            extractedJson: extractedJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$PoliciesTableTableManager get policies =>
      $$PoliciesTableTableManager(_db, _db.policies);
  $$QuotesTableTableManager get quotes =>
      $$QuotesTableTableManager(_db, _db.quotes);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
}
