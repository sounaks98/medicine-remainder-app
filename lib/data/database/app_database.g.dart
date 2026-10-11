// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, displayName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    String? id,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrescriptionsTable extends Prescriptions
    with TableInfo<$PrescriptionsTable, Prescription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrescriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validToMeta = const VerificationMeta(
    'validTo',
  );
  @override
  late final GeneratedColumn<DateTime> validTo = GeneratedColumn<DateTime>(
    'valid_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _humanReviewedAtMeta = const VerificationMeta(
    'humanReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> humanReviewedAt =
      GeneratedColumn<DateTime>(
        'human_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisMeta = const VerificationMeta(
    'diagnosis',
  );
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
    'diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testsSuggestedMeta = const VerificationMeta(
    'testsSuggested',
  );
  @override
  late final GeneratedColumn<String> testsSuggested = GeneratedColumn<String>(
    'tests_suggested',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _facilityNameMeta = const VerificationMeta(
    'facilityName',
  );
  @override
  late final GeneratedColumn<String> facilityName = GeneratedColumn<String>(
    'facility_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prescriptionLikelihoodMeta =
      const VerificationMeta('prescriptionLikelihood');
  @override
  late final GeneratedColumn<String> prescriptionLikelihood =
      GeneratedColumn<String>(
        'prescription_likelihood',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    capturedAt,
    validFrom,
    validTo,
    source,
    imagePath,
    reviewStatus,
    humanReviewedAt,
    doctorName,
    diagnosis,
    testsSuggested,
    facilityName,
    notes,
    prescriptionLikelihood,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prescriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prescription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    }
    if (data.containsKey('valid_to')) {
      context.handle(
        _validToMeta,
        validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewStatusMeta);
    }
    if (data.containsKey('human_reviewed_at')) {
      context.handle(
        _humanReviewedAtMeta,
        humanReviewedAt.isAcceptableOrUnknown(
          data['human_reviewed_at']!,
          _humanReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    }
    if (data.containsKey('diagnosis')) {
      context.handle(
        _diagnosisMeta,
        diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta),
      );
    }
    if (data.containsKey('tests_suggested')) {
      context.handle(
        _testsSuggestedMeta,
        testsSuggested.isAcceptableOrUnknown(
          data['tests_suggested']!,
          _testsSuggestedMeta,
        ),
      );
    }
    if (data.containsKey('facility_name')) {
      context.handle(
        _facilityNameMeta,
        facilityName.isAcceptableOrUnknown(
          data['facility_name']!,
          _facilityNameMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('prescription_likelihood')) {
      context.handle(
        _prescriptionLikelihoodMeta,
        prescriptionLikelihood.isAcceptableOrUnknown(
          data['prescription_likelihood']!,
          _prescriptionLikelihoodMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prescription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prescription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      ),
      validTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_to'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      humanReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}human_reviewed_at'],
      ),
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      ),
      diagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis'],
      ),
      testsSuggested: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tests_suggested'],
      ),
      facilityName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facility_name'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      prescriptionLikelihood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescription_likelihood'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PrescriptionsTable createAlias(String alias) {
    return $PrescriptionsTable(attachedDatabase, alias);
  }
}

class Prescription extends DataClass implements Insertable<Prescription> {
  final String id;
  final String userId;
  final DateTime capturedAt;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String source;
  final String? imagePath;
  final String reviewStatus;
  final DateTime? humanReviewedAt;
  final String? doctorName;
  final String? diagnosis;
  final String? testsSuggested;
  final String? facilityName;
  final String? notes;
  final String? prescriptionLikelihood;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Prescription({
    required this.id,
    required this.userId,
    required this.capturedAt,
    this.validFrom,
    this.validTo,
    required this.source,
    this.imagePath,
    required this.reviewStatus,
    this.humanReviewedAt,
    this.doctorName,
    this.diagnosis,
    this.testsSuggested,
    this.facilityName,
    this.notes,
    this.prescriptionLikelihood,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<DateTime>(validFrom);
    }
    if (!nullToAbsent || validTo != null) {
      map['valid_to'] = Variable<DateTime>(validTo);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['review_status'] = Variable<String>(reviewStatus);
    if (!nullToAbsent || humanReviewedAt != null) {
      map['human_reviewed_at'] = Variable<DateTime>(humanReviewedAt);
    }
    if (!nullToAbsent || doctorName != null) {
      map['doctor_name'] = Variable<String>(doctorName);
    }
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    if (!nullToAbsent || testsSuggested != null) {
      map['tests_suggested'] = Variable<String>(testsSuggested);
    }
    if (!nullToAbsent || facilityName != null) {
      map['facility_name'] = Variable<String>(facilityName);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || prescriptionLikelihood != null) {
      map['prescription_likelihood'] = Variable<String>(prescriptionLikelihood);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PrescriptionsCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionsCompanion(
      id: Value(id),
      userId: Value(userId),
      capturedAt: Value(capturedAt),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validTo: validTo == null && nullToAbsent
          ? const Value.absent()
          : Value(validTo),
      source: Value(source),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      reviewStatus: Value(reviewStatus),
      humanReviewedAt: humanReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(humanReviewedAt),
      doctorName: doctorName == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorName),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      testsSuggested: testsSuggested == null && nullToAbsent
          ? const Value.absent()
          : Value(testsSuggested),
      facilityName: facilityName == null && nullToAbsent
          ? const Value.absent()
          : Value(facilityName),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      prescriptionLikelihood: prescriptionLikelihood == null && nullToAbsent
          ? const Value.absent()
          : Value(prescriptionLikelihood),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Prescription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prescription(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      validFrom: serializer.fromJson<DateTime?>(json['validFrom']),
      validTo: serializer.fromJson<DateTime?>(json['validTo']),
      source: serializer.fromJson<String>(json['source']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      humanReviewedAt: serializer.fromJson<DateTime?>(json['humanReviewedAt']),
      doctorName: serializer.fromJson<String?>(json['doctorName']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      testsSuggested: serializer.fromJson<String?>(json['testsSuggested']),
      facilityName: serializer.fromJson<String?>(json['facilityName']),
      notes: serializer.fromJson<String?>(json['notes']),
      prescriptionLikelihood: serializer.fromJson<String?>(
        json['prescriptionLikelihood'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'validFrom': serializer.toJson<DateTime?>(validFrom),
      'validTo': serializer.toJson<DateTime?>(validTo),
      'source': serializer.toJson<String>(source),
      'imagePath': serializer.toJson<String?>(imagePath),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'humanReviewedAt': serializer.toJson<DateTime?>(humanReviewedAt),
      'doctorName': serializer.toJson<String?>(doctorName),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'testsSuggested': serializer.toJson<String?>(testsSuggested),
      'facilityName': serializer.toJson<String?>(facilityName),
      'notes': serializer.toJson<String?>(notes),
      'prescriptionLikelihood': serializer.toJson<String?>(
        prescriptionLikelihood,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Prescription copyWith({
    String? id,
    String? userId,
    DateTime? capturedAt,
    Value<DateTime?> validFrom = const Value.absent(),
    Value<DateTime?> validTo = const Value.absent(),
    String? source,
    Value<String?> imagePath = const Value.absent(),
    String? reviewStatus,
    Value<DateTime?> humanReviewedAt = const Value.absent(),
    Value<String?> doctorName = const Value.absent(),
    Value<String?> diagnosis = const Value.absent(),
    Value<String?> testsSuggested = const Value.absent(),
    Value<String?> facilityName = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> prescriptionLikelihood = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Prescription(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    capturedAt: capturedAt ?? this.capturedAt,
    validFrom: validFrom.present ? validFrom.value : this.validFrom,
    validTo: validTo.present ? validTo.value : this.validTo,
    source: source ?? this.source,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    humanReviewedAt: humanReviewedAt.present
        ? humanReviewedAt.value
        : this.humanReviewedAt,
    doctorName: doctorName.present ? doctorName.value : this.doctorName,
    diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
    testsSuggested: testsSuggested.present
        ? testsSuggested.value
        : this.testsSuggested,
    facilityName: facilityName.present ? facilityName.value : this.facilityName,
    notes: notes.present ? notes.value : this.notes,
    prescriptionLikelihood: prescriptionLikelihood.present
        ? prescriptionLikelihood.value
        : this.prescriptionLikelihood,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Prescription copyWithCompanion(PrescriptionsCompanion data) {
    return Prescription(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      source: data.source.present ? data.source.value : this.source,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      humanReviewedAt: data.humanReviewedAt.present
          ? data.humanReviewedAt.value
          : this.humanReviewedAt,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      testsSuggested: data.testsSuggested.present
          ? data.testsSuggested.value
          : this.testsSuggested,
      facilityName: data.facilityName.present
          ? data.facilityName.value
          : this.facilityName,
      notes: data.notes.present ? data.notes.value : this.notes,
      prescriptionLikelihood: data.prescriptionLikelihood.present
          ? data.prescriptionLikelihood.value
          : this.prescriptionLikelihood,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prescription(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('source: $source, ')
          ..write('imagePath: $imagePath, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('humanReviewedAt: $humanReviewedAt, ')
          ..write('doctorName: $doctorName, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('testsSuggested: $testsSuggested, ')
          ..write('facilityName: $facilityName, ')
          ..write('notes: $notes, ')
          ..write('prescriptionLikelihood: $prescriptionLikelihood, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    capturedAt,
    validFrom,
    validTo,
    source,
    imagePath,
    reviewStatus,
    humanReviewedAt,
    doctorName,
    diagnosis,
    testsSuggested,
    facilityName,
    notes,
    prescriptionLikelihood,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prescription &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.capturedAt == this.capturedAt &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.source == this.source &&
          other.imagePath == this.imagePath &&
          other.reviewStatus == this.reviewStatus &&
          other.humanReviewedAt == this.humanReviewedAt &&
          other.doctorName == this.doctorName &&
          other.diagnosis == this.diagnosis &&
          other.testsSuggested == this.testsSuggested &&
          other.facilityName == this.facilityName &&
          other.notes == this.notes &&
          other.prescriptionLikelihood == this.prescriptionLikelihood &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PrescriptionsCompanion extends UpdateCompanion<Prescription> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> capturedAt;
  final Value<DateTime?> validFrom;
  final Value<DateTime?> validTo;
  final Value<String> source;
  final Value<String?> imagePath;
  final Value<String> reviewStatus;
  final Value<DateTime?> humanReviewedAt;
  final Value<String?> doctorName;
  final Value<String?> diagnosis;
  final Value<String?> testsSuggested;
  final Value<String?> facilityName;
  final Value<String?> notes;
  final Value<String?> prescriptionLikelihood;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PrescriptionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.source = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.humanReviewedAt = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.testsSuggested = const Value.absent(),
    this.facilityName = const Value.absent(),
    this.notes = const Value.absent(),
    this.prescriptionLikelihood = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrescriptionsCompanion.insert({
    required String id,
    required String userId,
    required DateTime capturedAt,
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    required String source,
    this.imagePath = const Value.absent(),
    required String reviewStatus,
    this.humanReviewedAt = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.testsSuggested = const Value.absent(),
    this.facilityName = const Value.absent(),
    this.notes = const Value.absent(),
    this.prescriptionLikelihood = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       capturedAt = Value(capturedAt),
       source = Value(source),
       reviewStatus = Value(reviewStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Prescription> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? capturedAt,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validTo,
    Expression<String>? source,
    Expression<String>? imagePath,
    Expression<String>? reviewStatus,
    Expression<DateTime>? humanReviewedAt,
    Expression<String>? doctorName,
    Expression<String>? diagnosis,
    Expression<String>? testsSuggested,
    Expression<String>? facilityName,
    Expression<String>? notes,
    Expression<String>? prescriptionLikelihood,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (source != null) 'source': source,
      if (imagePath != null) 'image_path': imagePath,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (humanReviewedAt != null) 'human_reviewed_at': humanReviewedAt,
      if (doctorName != null) 'doctor_name': doctorName,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (testsSuggested != null) 'tests_suggested': testsSuggested,
      if (facilityName != null) 'facility_name': facilityName,
      if (notes != null) 'notes': notes,
      if (prescriptionLikelihood != null)
        'prescription_likelihood': prescriptionLikelihood,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrescriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? capturedAt,
    Value<DateTime?>? validFrom,
    Value<DateTime?>? validTo,
    Value<String>? source,
    Value<String?>? imagePath,
    Value<String>? reviewStatus,
    Value<DateTime?>? humanReviewedAt,
    Value<String?>? doctorName,
    Value<String?>? diagnosis,
    Value<String?>? testsSuggested,
    Value<String?>? facilityName,
    Value<String?>? notes,
    Value<String?>? prescriptionLikelihood,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PrescriptionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      capturedAt: capturedAt ?? this.capturedAt,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      source: source ?? this.source,
      imagePath: imagePath ?? this.imagePath,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      humanReviewedAt: humanReviewedAt ?? this.humanReviewedAt,
      doctorName: doctorName ?? this.doctorName,
      diagnosis: diagnosis ?? this.diagnosis,
      testsSuggested: testsSuggested ?? this.testsSuggested,
      facilityName: facilityName ?? this.facilityName,
      notes: notes ?? this.notes,
      prescriptionLikelihood:
          prescriptionLikelihood ?? this.prescriptionLikelihood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<DateTime>(validTo.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (humanReviewedAt.present) {
      map['human_reviewed_at'] = Variable<DateTime>(humanReviewedAt.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (testsSuggested.present) {
      map['tests_suggested'] = Variable<String>(testsSuggested.value);
    }
    if (facilityName.present) {
      map['facility_name'] = Variable<String>(facilityName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (prescriptionLikelihood.present) {
      map['prescription_likelihood'] = Variable<String>(
        prescriptionLikelihood.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('source: $source, ')
          ..write('imagePath: $imagePath, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('humanReviewedAt: $humanReviewedAt, ')
          ..write('doctorName: $doctorName, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('testsSuggested: $testsSuggested, ')
          ..write('facilityName: $facilityName, ')
          ..write('notes: $notes, ')
          ..write('prescriptionLikelihood: $prescriptionLikelihood, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _prescriptionIdMeta = const VerificationMeta(
    'prescriptionId',
  );
  @override
  late final GeneratedColumn<String> prescriptionId = GeneratedColumn<String>(
    'prescription_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prescriptions (id) ON DELETE CASCADE',
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
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthUnitMeta = const VerificationMeta(
    'strengthUnit',
  );
  @override
  late final GeneratedColumn<String> strengthUnit = GeneratedColumn<String>(
    'strength_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseInstructionsMeta = const VerificationMeta(
    'doseInstructions',
  );
  @override
  late final GeneratedColumn<String> doseInstructions = GeneratedColumn<String>(
    'dose_instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
    'route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timingMeta = const VerificationMeta('timing');
  @override
  late final GeneratedColumn<String> timing = GeneratedColumn<String>(
    'timing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<String> startAt = GeneratedColumn<String>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<String> endAt = GeneratedColumn<String>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmedByUserMeta = const VerificationMeta(
    'confirmedByUser',
  );
  @override
  late final GeneratedColumn<bool> confirmedByUser = GeneratedColumn<bool>(
    'confirmed_by_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confirmed_by_user" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scheduleRuleIdMeta = const VerificationMeta(
    'scheduleRuleId',
  );
  @override
  late final GeneratedColumn<String> scheduleRuleId = GeneratedColumn<String>(
    'schedule_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyConfidenceMeta =
      const VerificationMeta('frequencyConfidence');
  @override
  late final GeneratedColumn<String> frequencyConfidence =
      GeneratedColumn<String>(
        'frequency_confidence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    prescriptionId,
    name,
    strength,
    strengthUnit,
    doseInstructions,
    route,
    frequency,
    duration,
    timing,
    startAt,
    endAt,
    reviewStatus,
    confirmedAt,
    confirmedByUser,
    scheduleRuleId,
    frequencyConfidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medicine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('prescription_id')) {
      context.handle(
        _prescriptionIdMeta,
        prescriptionId.isAcceptableOrUnknown(
          data['prescription_id']!,
          _prescriptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prescriptionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    } else if (isInserting) {
      context.missing(_strengthMeta);
    }
    if (data.containsKey('strength_unit')) {
      context.handle(
        _strengthUnitMeta,
        strengthUnit.isAcceptableOrUnknown(
          data['strength_unit']!,
          _strengthUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strengthUnitMeta);
    }
    if (data.containsKey('dose_instructions')) {
      context.handle(
        _doseInstructionsMeta,
        doseInstructions.isAcceptableOrUnknown(
          data['dose_instructions']!,
          _doseInstructionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_doseInstructionsMeta);
    }
    if (data.containsKey('route')) {
      context.handle(
        _routeMeta,
        route.isAcceptableOrUnknown(data['route']!, _routeMeta),
      );
    } else if (isInserting) {
      context.missing(_routeMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('timing')) {
      context.handle(
        _timingMeta,
        timing.isAcceptableOrUnknown(data['timing']!, _timingMeta),
      );
    } else if (isInserting) {
      context.missing(_timingMeta);
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewStatusMeta);
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    }
    if (data.containsKey('confirmed_by_user')) {
      context.handle(
        _confirmedByUserMeta,
        confirmedByUser.isAcceptableOrUnknown(
          data['confirmed_by_user']!,
          _confirmedByUserMeta,
        ),
      );
    }
    if (data.containsKey('schedule_rule_id')) {
      context.handle(
        _scheduleRuleIdMeta,
        scheduleRuleId.isAcceptableOrUnknown(
          data['schedule_rule_id']!,
          _scheduleRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('frequency_confidence')) {
      context.handle(
        _frequencyConfidenceMeta,
        frequencyConfidence.isAcceptableOrUnknown(
          data['frequency_confidence']!,
          _frequencyConfidenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyConfidenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      prescriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescription_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      )!,
      strengthUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength_unit'],
      )!,
      doseInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_instructions'],
      )!,
      route: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      )!,
      timing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timing'],
      )!,
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_at'],
      ),
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_at'],
      ),
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at'],
      ),
      confirmedByUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmed_by_user'],
      )!,
      scheduleRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_rule_id'],
      ),
      frequencyConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_confidence'],
      )!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final String id;
  final String userId;
  final String prescriptionId;
  final String name;
  final String strength;
  final String strengthUnit;
  final String doseInstructions;
  final String route;
  final String frequency;
  final String duration;
  final String timing;
  final String? startAt;
  final String? endAt;
  final String reviewStatus;
  final DateTime? confirmedAt;
  final bool confirmedByUser;
  final String? scheduleRuleId;
  final String frequencyConfidence;
  const Medicine({
    required this.id,
    required this.userId,
    required this.prescriptionId,
    required this.name,
    required this.strength,
    required this.strengthUnit,
    required this.doseInstructions,
    required this.route,
    required this.frequency,
    required this.duration,
    required this.timing,
    this.startAt,
    this.endAt,
    required this.reviewStatus,
    this.confirmedAt,
    required this.confirmedByUser,
    this.scheduleRuleId,
    required this.frequencyConfidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['prescription_id'] = Variable<String>(prescriptionId);
    map['name'] = Variable<String>(name);
    map['strength'] = Variable<String>(strength);
    map['strength_unit'] = Variable<String>(strengthUnit);
    map['dose_instructions'] = Variable<String>(doseInstructions);
    map['route'] = Variable<String>(route);
    map['frequency'] = Variable<String>(frequency);
    map['duration'] = Variable<String>(duration);
    map['timing'] = Variable<String>(timing);
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<String>(startAt);
    }
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<String>(endAt);
    }
    map['review_status'] = Variable<String>(reviewStatus);
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    }
    map['confirmed_by_user'] = Variable<bool>(confirmedByUser);
    if (!nullToAbsent || scheduleRuleId != null) {
      map['schedule_rule_id'] = Variable<String>(scheduleRuleId);
    }
    map['frequency_confidence'] = Variable<String>(frequencyConfidence);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      userId: Value(userId),
      prescriptionId: Value(prescriptionId),
      name: Value(name),
      strength: Value(strength),
      strengthUnit: Value(strengthUnit),
      doseInstructions: Value(doseInstructions),
      route: Value(route),
      frequency: Value(frequency),
      duration: Value(duration),
      timing: Value(timing),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      reviewStatus: Value(reviewStatus),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
      confirmedByUser: Value(confirmedByUser),
      scheduleRuleId: scheduleRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleRuleId),
      frequencyConfidence: Value(frequencyConfidence),
    );
  }

  factory Medicine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      prescriptionId: serializer.fromJson<String>(json['prescriptionId']),
      name: serializer.fromJson<String>(json['name']),
      strength: serializer.fromJson<String>(json['strength']),
      strengthUnit: serializer.fromJson<String>(json['strengthUnit']),
      doseInstructions: serializer.fromJson<String>(json['doseInstructions']),
      route: serializer.fromJson<String>(json['route']),
      frequency: serializer.fromJson<String>(json['frequency']),
      duration: serializer.fromJson<String>(json['duration']),
      timing: serializer.fromJson<String>(json['timing']),
      startAt: serializer.fromJson<String?>(json['startAt']),
      endAt: serializer.fromJson<String?>(json['endAt']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
      confirmedByUser: serializer.fromJson<bool>(json['confirmedByUser']),
      scheduleRuleId: serializer.fromJson<String?>(json['scheduleRuleId']),
      frequencyConfidence: serializer.fromJson<String>(
        json['frequencyConfidence'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'prescriptionId': serializer.toJson<String>(prescriptionId),
      'name': serializer.toJson<String>(name),
      'strength': serializer.toJson<String>(strength),
      'strengthUnit': serializer.toJson<String>(strengthUnit),
      'doseInstructions': serializer.toJson<String>(doseInstructions),
      'route': serializer.toJson<String>(route),
      'frequency': serializer.toJson<String>(frequency),
      'duration': serializer.toJson<String>(duration),
      'timing': serializer.toJson<String>(timing),
      'startAt': serializer.toJson<String?>(startAt),
      'endAt': serializer.toJson<String?>(endAt),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
      'confirmedByUser': serializer.toJson<bool>(confirmedByUser),
      'scheduleRuleId': serializer.toJson<String?>(scheduleRuleId),
      'frequencyConfidence': serializer.toJson<String>(frequencyConfidence),
    };
  }

  Medicine copyWith({
    String? id,
    String? userId,
    String? prescriptionId,
    String? name,
    String? strength,
    String? strengthUnit,
    String? doseInstructions,
    String? route,
    String? frequency,
    String? duration,
    String? timing,
    Value<String?> startAt = const Value.absent(),
    Value<String?> endAt = const Value.absent(),
    String? reviewStatus,
    Value<DateTime?> confirmedAt = const Value.absent(),
    bool? confirmedByUser,
    Value<String?> scheduleRuleId = const Value.absent(),
    String? frequencyConfidence,
  }) => Medicine(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    prescriptionId: prescriptionId ?? this.prescriptionId,
    name: name ?? this.name,
    strength: strength ?? this.strength,
    strengthUnit: strengthUnit ?? this.strengthUnit,
    doseInstructions: doseInstructions ?? this.doseInstructions,
    route: route ?? this.route,
    frequency: frequency ?? this.frequency,
    duration: duration ?? this.duration,
    timing: timing ?? this.timing,
    startAt: startAt.present ? startAt.value : this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
    confirmedByUser: confirmedByUser ?? this.confirmedByUser,
    scheduleRuleId: scheduleRuleId.present
        ? scheduleRuleId.value
        : this.scheduleRuleId,
    frequencyConfidence: frequencyConfidence ?? this.frequencyConfidence,
  );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      prescriptionId: data.prescriptionId.present
          ? data.prescriptionId.value
          : this.prescriptionId,
      name: data.name.present ? data.name.value : this.name,
      strength: data.strength.present ? data.strength.value : this.strength,
      strengthUnit: data.strengthUnit.present
          ? data.strengthUnit.value
          : this.strengthUnit,
      doseInstructions: data.doseInstructions.present
          ? data.doseInstructions.value
          : this.doseInstructions,
      route: data.route.present ? data.route.value : this.route,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      duration: data.duration.present ? data.duration.value : this.duration,
      timing: data.timing.present ? data.timing.value : this.timing,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
      confirmedByUser: data.confirmedByUser.present
          ? data.confirmedByUser.value
          : this.confirmedByUser,
      scheduleRuleId: data.scheduleRuleId.present
          ? data.scheduleRuleId.value
          : this.scheduleRuleId,
      frequencyConfidence: data.frequencyConfidence.present
          ? data.frequencyConfidence.value
          : this.frequencyConfidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('prescriptionId: $prescriptionId, ')
          ..write('name: $name, ')
          ..write('strength: $strength, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('doseInstructions: $doseInstructions, ')
          ..write('route: $route, ')
          ..write('frequency: $frequency, ')
          ..write('duration: $duration, ')
          ..write('timing: $timing, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('confirmedByUser: $confirmedByUser, ')
          ..write('scheduleRuleId: $scheduleRuleId, ')
          ..write('frequencyConfidence: $frequencyConfidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    prescriptionId,
    name,
    strength,
    strengthUnit,
    doseInstructions,
    route,
    frequency,
    duration,
    timing,
    startAt,
    endAt,
    reviewStatus,
    confirmedAt,
    confirmedByUser,
    scheduleRuleId,
    frequencyConfidence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.prescriptionId == this.prescriptionId &&
          other.name == this.name &&
          other.strength == this.strength &&
          other.strengthUnit == this.strengthUnit &&
          other.doseInstructions == this.doseInstructions &&
          other.route == this.route &&
          other.frequency == this.frequency &&
          other.duration == this.duration &&
          other.timing == this.timing &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.reviewStatus == this.reviewStatus &&
          other.confirmedAt == this.confirmedAt &&
          other.confirmedByUser == this.confirmedByUser &&
          other.scheduleRuleId == this.scheduleRuleId &&
          other.frequencyConfidence == this.frequencyConfidence);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> prescriptionId;
  final Value<String> name;
  final Value<String> strength;
  final Value<String> strengthUnit;
  final Value<String> doseInstructions;
  final Value<String> route;
  final Value<String> frequency;
  final Value<String> duration;
  final Value<String> timing;
  final Value<String?> startAt;
  final Value<String?> endAt;
  final Value<String> reviewStatus;
  final Value<DateTime?> confirmedAt;
  final Value<bool> confirmedByUser;
  final Value<String?> scheduleRuleId;
  final Value<String> frequencyConfidence;
  final Value<int> rowid;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.prescriptionId = const Value.absent(),
    this.name = const Value.absent(),
    this.strength = const Value.absent(),
    this.strengthUnit = const Value.absent(),
    this.doseInstructions = const Value.absent(),
    this.route = const Value.absent(),
    this.frequency = const Value.absent(),
    this.duration = const Value.absent(),
    this.timing = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.confirmedByUser = const Value.absent(),
    this.scheduleRuleId = const Value.absent(),
    this.frequencyConfidence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicinesCompanion.insert({
    required String id,
    required String userId,
    required String prescriptionId,
    required String name,
    required String strength,
    required String strengthUnit,
    required String doseInstructions,
    required String route,
    required String frequency,
    required String duration,
    required String timing,
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    required String reviewStatus,
    this.confirmedAt = const Value.absent(),
    this.confirmedByUser = const Value.absent(),
    this.scheduleRuleId = const Value.absent(),
    required String frequencyConfidence,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       prescriptionId = Value(prescriptionId),
       name = Value(name),
       strength = Value(strength),
       strengthUnit = Value(strengthUnit),
       doseInstructions = Value(doseInstructions),
       route = Value(route),
       frequency = Value(frequency),
       duration = Value(duration),
       timing = Value(timing),
       reviewStatus = Value(reviewStatus),
       frequencyConfidence = Value(frequencyConfidence);
  static Insertable<Medicine> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? prescriptionId,
    Expression<String>? name,
    Expression<String>? strength,
    Expression<String>? strengthUnit,
    Expression<String>? doseInstructions,
    Expression<String>? route,
    Expression<String>? frequency,
    Expression<String>? duration,
    Expression<String>? timing,
    Expression<String>? startAt,
    Expression<String>? endAt,
    Expression<String>? reviewStatus,
    Expression<DateTime>? confirmedAt,
    Expression<bool>? confirmedByUser,
    Expression<String>? scheduleRuleId,
    Expression<String>? frequencyConfidence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (prescriptionId != null) 'prescription_id': prescriptionId,
      if (name != null) 'name': name,
      if (strength != null) 'strength': strength,
      if (strengthUnit != null) 'strength_unit': strengthUnit,
      if (doseInstructions != null) 'dose_instructions': doseInstructions,
      if (route != null) 'route': route,
      if (frequency != null) 'frequency': frequency,
      if (duration != null) 'duration': duration,
      if (timing != null) 'timing': timing,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (confirmedByUser != null) 'confirmed_by_user': confirmedByUser,
      if (scheduleRuleId != null) 'schedule_rule_id': scheduleRuleId,
      if (frequencyConfidence != null)
        'frequency_confidence': frequencyConfidence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicinesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? prescriptionId,
    Value<String>? name,
    Value<String>? strength,
    Value<String>? strengthUnit,
    Value<String>? doseInstructions,
    Value<String>? route,
    Value<String>? frequency,
    Value<String>? duration,
    Value<String>? timing,
    Value<String?>? startAt,
    Value<String?>? endAt,
    Value<String>? reviewStatus,
    Value<DateTime?>? confirmedAt,
    Value<bool>? confirmedByUser,
    Value<String?>? scheduleRuleId,
    Value<String>? frequencyConfidence,
    Value<int>? rowid,
  }) {
    return MedicinesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      name: name ?? this.name,
      strength: strength ?? this.strength,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      doseInstructions: doseInstructions ?? this.doseInstructions,
      route: route ?? this.route,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      timing: timing ?? this.timing,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      confirmedByUser: confirmedByUser ?? this.confirmedByUser,
      scheduleRuleId: scheduleRuleId ?? this.scheduleRuleId,
      frequencyConfidence: frequencyConfidence ?? this.frequencyConfidence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (prescriptionId.present) {
      map['prescription_id'] = Variable<String>(prescriptionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (strengthUnit.present) {
      map['strength_unit'] = Variable<String>(strengthUnit.value);
    }
    if (doseInstructions.present) {
      map['dose_instructions'] = Variable<String>(doseInstructions.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (timing.present) {
      map['timing'] = Variable<String>(timing.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<String>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<String>(endAt.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (confirmedByUser.present) {
      map['confirmed_by_user'] = Variable<bool>(confirmedByUser.value);
    }
    if (scheduleRuleId.present) {
      map['schedule_rule_id'] = Variable<String>(scheduleRuleId.value);
    }
    if (frequencyConfidence.present) {
      map['frequency_confidence'] = Variable<String>(frequencyConfidence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('prescriptionId: $prescriptionId, ')
          ..write('name: $name, ')
          ..write('strength: $strength, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('doseInstructions: $doseInstructions, ')
          ..write('route: $route, ')
          ..write('frequency: $frequency, ')
          ..write('duration: $duration, ')
          ..write('timing: $timing, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('confirmedByUser: $confirmedByUser, ')
          ..write('scheduleRuleId: $scheduleRuleId, ')
          ..write('frequencyConfidence: $frequencyConfidence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderEventsTable extends ReminderEvents
    with TableInfo<$ReminderEventsTable, ReminderEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medicines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<DateTime> fireAt = GeneratedColumn<DateTime>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    medicineId,
    fireAt,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_id'],
      )!,
      fireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fire_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReminderEventsTable createAlias(String alias) {
    return $ReminderEventsTable(attachedDatabase, alias);
  }
}

class ReminderEvent extends DataClass implements Insertable<ReminderEvent> {
  final String id;
  final String userId;
  final String medicineId;
  final DateTime fireAt;
  final String status;
  final DateTime createdAt;
  const ReminderEvent({
    required this.id,
    required this.userId,
    required this.medicineId,
    required this.fireAt,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['medicine_id'] = Variable<String>(medicineId);
    map['fire_at'] = Variable<DateTime>(fireAt);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReminderEventsCompanion toCompanion(bool nullToAbsent) {
    return ReminderEventsCompanion(
      id: Value(id),
      userId: Value(userId),
      medicineId: Value(medicineId),
      fireAt: Value(fireAt),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ReminderEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderEvent(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      medicineId: serializer.fromJson<String>(json['medicineId']),
      fireAt: serializer.fromJson<DateTime>(json['fireAt']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'medicineId': serializer.toJson<String>(medicineId),
      'fireAt': serializer.toJson<DateTime>(fireAt),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReminderEvent copyWith({
    String? id,
    String? userId,
    String? medicineId,
    DateTime? fireAt,
    String? status,
    DateTime? createdAt,
  }) => ReminderEvent(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    medicineId: medicineId ?? this.medicineId,
    fireAt: fireAt ?? this.fireAt,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ReminderEvent copyWithCompanion(ReminderEventsCompanion data) {
    return ReminderEvent(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderEvent(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('medicineId: $medicineId, ')
          ..write('fireAt: $fireAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, medicineId, fireAt, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderEvent &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.medicineId == this.medicineId &&
          other.fireAt == this.fireAt &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ReminderEventsCompanion extends UpdateCompanion<ReminderEvent> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> medicineId;
  final Value<DateTime> fireAt;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReminderEventsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderEventsCompanion.insert({
    required String id,
    required String userId,
    required String medicineId,
    required DateTime fireAt,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       medicineId = Value(medicineId),
       fireAt = Value(fireAt),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ReminderEvent> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? medicineId,
    Expression<DateTime>? fireAt,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (medicineId != null) 'medicine_id': medicineId,
      if (fireAt != null) 'fire_at': fireAt,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? medicineId,
    Value<DateTime>? fireAt,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReminderEventsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      medicineId: medicineId ?? this.medicineId,
      fireAt: fireAt ?? this.fireAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<DateTime>(fireAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderEventsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('medicineId: $medicineId, ')
          ..write('fireAt: $fireAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdherenceEntriesTable extends AdherenceEntries
    with TableInfo<$AdherenceEntriesTable, AdherenceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdherenceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reminderEventIdMeta = const VerificationMeta(
    'reminderEventId',
  );
  @override
  late final GeneratedColumn<String> reminderEventId = GeneratedColumn<String>(
    'reminder_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminder_events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    reminderEventId,
    status,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adherence_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdherenceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('reminder_event_id')) {
      context.handle(
        _reminderEventIdMeta,
        reminderEventId.isAcceptableOrUnknown(
          data['reminder_event_id']!,
          _reminderEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderEventIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdherenceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdherenceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      reminderEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_event_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $AdherenceEntriesTable createAlias(String alias) {
    return $AdherenceEntriesTable(attachedDatabase, alias);
  }
}

class AdherenceEntry extends DataClass implements Insertable<AdherenceEntry> {
  final String id;
  final String userId;
  final String reminderEventId;
  final String status;
  final DateTime recordedAt;
  const AdherenceEntry({
    required this.id,
    required this.userId,
    required this.reminderEventId,
    required this.status,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['reminder_event_id'] = Variable<String>(reminderEventId);
    map['status'] = Variable<String>(status);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  AdherenceEntriesCompanion toCompanion(bool nullToAbsent) {
    return AdherenceEntriesCompanion(
      id: Value(id),
      userId: Value(userId),
      reminderEventId: Value(reminderEventId),
      status: Value(status),
      recordedAt: Value(recordedAt),
    );
  }

  factory AdherenceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdherenceEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      reminderEventId: serializer.fromJson<String>(json['reminderEventId']),
      status: serializer.fromJson<String>(json['status']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'reminderEventId': serializer.toJson<String>(reminderEventId),
      'status': serializer.toJson<String>(status),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  AdherenceEntry copyWith({
    String? id,
    String? userId,
    String? reminderEventId,
    String? status,
    DateTime? recordedAt,
  }) => AdherenceEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    reminderEventId: reminderEventId ?? this.reminderEventId,
    status: status ?? this.status,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  AdherenceEntry copyWithCompanion(AdherenceEntriesCompanion data) {
    return AdherenceEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      reminderEventId: data.reminderEventId.present
          ? data.reminderEventId.value
          : this.reminderEventId,
      status: data.status.present ? data.status.value : this.status,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdherenceEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('reminderEventId: $reminderEventId, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, reminderEventId, status, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdherenceEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.reminderEventId == this.reminderEventId &&
          other.status == this.status &&
          other.recordedAt == this.recordedAt);
}

class AdherenceEntriesCompanion extends UpdateCompanion<AdherenceEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> reminderEventId;
  final Value<String> status;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const AdherenceEntriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.reminderEventId = const Value.absent(),
    this.status = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdherenceEntriesCompanion.insert({
    required String id,
    required String userId,
    required String reminderEventId,
    required String status,
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       reminderEventId = Value(reminderEventId),
       status = Value(status),
       recordedAt = Value(recordedAt);
  static Insertable<AdherenceEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? reminderEventId,
    Expression<String>? status,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (reminderEventId != null) 'reminder_event_id': reminderEventId,
      if (status != null) 'status': status,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdherenceEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? reminderEventId,
    Value<String>? status,
    Value<DateTime>? recordedAt,
    Value<int>? rowid,
  }) {
    return AdherenceEntriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reminderEventId: reminderEventId ?? this.reminderEventId,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (reminderEventId.present) {
      map['reminder_event_id'] = Variable<String>(reminderEventId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdherenceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('reminderEventId: $reminderEventId, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PrescriptionsTable prescriptions = $PrescriptionsTable(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $ReminderEventsTable reminderEvents = $ReminderEventsTable(this);
  late final $AdherenceEntriesTable adherenceEntries = $AdherenceEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    prescriptions,
    medicines,
    reminderEvents,
    adherenceEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('prescriptions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medicines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'prescriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medicines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminder_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medicines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminder_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('adherence_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminder_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('adherence_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String displayName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> displayName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PrescriptionsTable, List<Prescription>>
  _prescriptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.prescriptions,
    aliasName: 'users__id__prescriptions__user_id',
  );

  $$PrescriptionsTableProcessedTableManager get prescriptionsRefs {
    final manager = $$PrescriptionsTableTableManager(
      $_db,
      $_db.prescriptions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_prescriptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicinesTable, List<Medicine>>
  _medicinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicines,
    aliasName: 'users__id__medicines__user_id',
  );

  $$MedicinesTableProcessedTableManager get medicinesRefs {
    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReminderEventsTable, List<ReminderEvent>>
  _reminderEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderEvents,
    aliasName: 'users__id__reminder_events__user_id',
  );

  $$ReminderEventsTableProcessedTableManager get reminderEventsRefs {
    final manager = $$ReminderEventsTableTableManager(
      $_db,
      $_db.reminderEvents,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reminderEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AdherenceEntriesTable, List<AdherenceEntry>>
  _adherenceEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.adherenceEntries,
    aliasName: 'users__id__adherence_entries__user_id',
  );

  $$AdherenceEntriesTableProcessedTableManager get adherenceEntriesRefs {
    final manager = $$AdherenceEntriesTableTableManager(
      $_db,
      $_db.adherenceEntries,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _adherenceEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> prescriptionsRefs(
    Expression<bool> Function($$PrescriptionsTableFilterComposer f) f,
  ) {
    final $$PrescriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableFilterComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicinesRefs(
    Expression<bool> Function($$MedicinesTableFilterComposer f) f,
  ) {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reminderEventsRefs(
    Expression<bool> Function($$ReminderEventsTableFilterComposer f) f,
  ) {
    final $$ReminderEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableFilterComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> adherenceEntriesRefs(
    Expression<bool> Function($$AdherenceEntriesTableFilterComposer f) f,
  ) {
    final $$AdherenceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adherenceEntries,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdherenceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.adherenceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> prescriptionsRefs<T extends Object>(
    Expression<T> Function($$PrescriptionsTableAnnotationComposer a) f,
  ) {
    final $$PrescriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicinesRefs<T extends Object>(
    Expression<T> Function($$MedicinesTableAnnotationComposer a) f,
  ) {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reminderEventsRefs<T extends Object>(
    Expression<T> Function($$ReminderEventsTableAnnotationComposer a) f,
  ) {
    final $$ReminderEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> adherenceEntriesRefs<T extends Object>(
    Expression<T> Function($$AdherenceEntriesTableAnnotationComposer a) f,
  ) {
    final $$AdherenceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adherenceEntries,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdherenceEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.adherenceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool prescriptionsRefs,
            bool medicinesRefs,
            bool reminderEventsRefs,
            bool adherenceEntriesRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, User>(table),
                  $$UsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                prescriptionsRefs = false,
                medicinesRefs = false,
                reminderEventsRefs = false,
                adherenceEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (prescriptionsRefs) db.prescriptions,
                    if (medicinesRefs) db.medicines,
                    if (reminderEventsRefs) db.reminderEvents,
                    if (adherenceEntriesRefs) db.adherenceEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (prescriptionsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          Prescription
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._prescriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).prescriptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicinesRefs)
                        await $_getPrefetchedData<User, $UsersTable, Medicine>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._medicinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).medicinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reminderEventsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          ReminderEvent
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._reminderEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (adherenceEntriesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          AdherenceEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._adherenceEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).adherenceEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool prescriptionsRefs,
        bool medicinesRefs,
        bool reminderEventsRefs,
        bool adherenceEntriesRefs,
      })
    >;
typedef $$PrescriptionsTableCreateCompanionBuilder =
    PrescriptionsCompanion Function({
      required String id,
      required String userId,
      required DateTime capturedAt,
      Value<DateTime?> validFrom,
      Value<DateTime?> validTo,
      required String source,
      Value<String?> imagePath,
      required String reviewStatus,
      Value<DateTime?> humanReviewedAt,
      Value<String?> doctorName,
      Value<String?> diagnosis,
      Value<String?> testsSuggested,
      Value<String?> facilityName,
      Value<String?> notes,
      Value<String?> prescriptionLikelihood,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PrescriptionsTableUpdateCompanionBuilder =
    PrescriptionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> capturedAt,
      Value<DateTime?> validFrom,
      Value<DateTime?> validTo,
      Value<String> source,
      Value<String?> imagePath,
      Value<String> reviewStatus,
      Value<DateTime?> humanReviewedAt,
      Value<String?> doctorName,
      Value<String?> diagnosis,
      Value<String?> testsSuggested,
      Value<String?> facilityName,
      Value<String?> notes,
      Value<String?> prescriptionLikelihood,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PrescriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $PrescriptionsTable, Prescription> {
  $$PrescriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('prescriptions__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MedicinesTable, List<Medicine>>
  _medicinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicines,
    aliasName: 'prescriptions__id__medicines__prescription_id',
  );

  $$MedicinesTableProcessedTableManager get medicinesRefs {
    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.prescriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrescriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get humanReviewedAt => $composableBuilder(
    column: $table.humanReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testsSuggested => $composableBuilder(
    column: $table.testsSuggested,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facilityName => $composableBuilder(
    column: $table.facilityName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prescriptionLikelihood => $composableBuilder(
    column: $table.prescriptionLikelihood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicinesRefs(
    Expression<bool> Function($$MedicinesTableFilterComposer f) f,
  ) {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.prescriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrescriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get humanReviewedAt => $composableBuilder(
    column: $table.humanReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testsSuggested => $composableBuilder(
    column: $table.testsSuggested,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facilityName => $composableBuilder(
    column: $table.facilityName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prescriptionLikelihood => $composableBuilder(
    column: $table.prescriptionLikelihood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get humanReviewedAt => $composableBuilder(
    column: $table.humanReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get testsSuggested => $composableBuilder(
    column: $table.testsSuggested,
    builder: (column) => column,
  );

  GeneratedColumn<String> get facilityName => $composableBuilder(
    column: $table.facilityName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get prescriptionLikelihood => $composableBuilder(
    column: $table.prescriptionLikelihood,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> medicinesRefs<T extends Object>(
    Expression<T> Function($$MedicinesTableAnnotationComposer a) f,
  ) {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.prescriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrescriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrescriptionsTable,
          Prescription,
          $$PrescriptionsTableFilterComposer,
          $$PrescriptionsTableOrderingComposer,
          $$PrescriptionsTableAnnotationComposer,
          $$PrescriptionsTableCreateCompanionBuilder,
          $$PrescriptionsTableUpdateCompanionBuilder,
          (Prescription, $$PrescriptionsTableReferences),
          Prescription,
          PrefetchHooks Function({bool userId, bool medicinesRefs})
        > {
  $$PrescriptionsTableTableManager(_$AppDatabase db, $PrescriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrescriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrescriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrescriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<DateTime?> humanReviewedAt = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> testsSuggested = const Value.absent(),
                Value<String?> facilityName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> prescriptionLikelihood = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrescriptionsCompanion(
                id: id,
                userId: userId,
                capturedAt: capturedAt,
                validFrom: validFrom,
                validTo: validTo,
                source: source,
                imagePath: imagePath,
                reviewStatus: reviewStatus,
                humanReviewedAt: humanReviewedAt,
                doctorName: doctorName,
                diagnosis: diagnosis,
                testsSuggested: testsSuggested,
                facilityName: facilityName,
                notes: notes,
                prescriptionLikelihood: prescriptionLikelihood,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime capturedAt,
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                required String source,
                Value<String?> imagePath = const Value.absent(),
                required String reviewStatus,
                Value<DateTime?> humanReviewedAt = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> testsSuggested = const Value.absent(),
                Value<String?> facilityName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> prescriptionLikelihood = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PrescriptionsCompanion.insert(
                id: id,
                userId: userId,
                capturedAt: capturedAt,
                validFrom: validFrom,
                validTo: validTo,
                source: source,
                imagePath: imagePath,
                reviewStatus: reviewStatus,
                humanReviewedAt: humanReviewedAt,
                doctorName: doctorName,
                diagnosis: diagnosis,
                testsSuggested: testsSuggested,
                facilityName: facilityName,
                notes: notes,
                prescriptionLikelihood: prescriptionLikelihood,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrescriptionsTable, Prescription>(table),
                  $$PrescriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, medicinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (medicinesRefs) db.medicines],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$PrescriptionsTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$PrescriptionsTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicinesRefs)
                    await $_getPrefetchedData<
                      Prescription,
                      $PrescriptionsTable,
                      Medicine
                    >(
                      currentTable: table,
                      referencedTable: $$PrescriptionsTableReferences
                          ._medicinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PrescriptionsTableReferences(
                            db,
                            table,
                            p0,
                          ).medicinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.prescriptionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PrescriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrescriptionsTable,
      Prescription,
      $$PrescriptionsTableFilterComposer,
      $$PrescriptionsTableOrderingComposer,
      $$PrescriptionsTableAnnotationComposer,
      $$PrescriptionsTableCreateCompanionBuilder,
      $$PrescriptionsTableUpdateCompanionBuilder,
      (Prescription, $$PrescriptionsTableReferences),
      Prescription,
      PrefetchHooks Function({bool userId, bool medicinesRefs})
    >;
typedef $$MedicinesTableCreateCompanionBuilder = MedicinesCompanion Function({
  required String id,
  required String userId,
  required String prescriptionId,
  required String name,
  required String strength,
  required String strengthUnit,
  required String doseInstructions,
  required String route,
  required String frequency,
  required String duration,
  required String timing,
  Value<String?> startAt,
  Value<String?> endAt,
  required String reviewStatus,
  Value<DateTime?> confirmedAt,
  Value<bool> confirmedByUser,
  Value<String?> scheduleRuleId,
  required String frequencyConfidence,
  Value<int> rowid,
});
typedef $$MedicinesTableUpdateCompanionBuilder = MedicinesCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> prescriptionId,
  Value<String> name,
  Value<String> strength,
  Value<String> strengthUnit,
  Value<String> doseInstructions,
  Value<String> route,
  Value<String> frequency,
  Value<String> duration,
  Value<String> timing,
  Value<String?> startAt,
  Value<String?> endAt,
  Value<String> reviewStatus,
  Value<DateTime?> confirmedAt,
  Value<bool> confirmedByUser,
  Value<String?> scheduleRuleId,
  Value<String> frequencyConfidence,
  Value<int> rowid,
});

final class $$MedicinesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicinesTable, Medicine> {
  $$MedicinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('medicines__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PrescriptionsTable _prescriptionIdTable(_$AppDatabase db) => db
      .prescriptions
      .createAlias('medicines__prescription_id__prescriptions__id');

  $$PrescriptionsTableProcessedTableManager get prescriptionId {
    final $_column = $_itemColumn<String>('prescription_id')!;

    final manager = $$PrescriptionsTableTableManager(
      $_db,
      $_db.prescriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prescriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReminderEventsTable, List<ReminderEvent>>
  _reminderEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderEvents,
    aliasName: 'medicines__id__reminder_events__medicine_id',
  );

  $$ReminderEventsTableProcessedTableManager get reminderEventsRefs {
    final manager = $$ReminderEventsTableTableManager(
      $_db,
      $_db.reminderEvents,
    ).filter((f) => f.medicineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reminderEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strengthUnit => $composableBuilder(
    column: $table.strengthUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doseInstructions => $composableBuilder(
    column: $table.doseInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmedByUser => $composableBuilder(
    column: $table.confirmedByUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleRuleId => $composableBuilder(
    column: $table.scheduleRuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyConfidence => $composableBuilder(
    column: $table.frequencyConfidence,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrescriptionsTableFilterComposer get prescriptionId {
    final $$PrescriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriptionId,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableFilterComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reminderEventsRefs(
    Expression<bool> Function($$ReminderEventsTableFilterComposer f) f,
  ) {
    final $$ReminderEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableFilterComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strengthUnit => $composableBuilder(
    column: $table.strengthUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doseInstructions => $composableBuilder(
    column: $table.doseInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmedByUser => $composableBuilder(
    column: $table.confirmedByUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleRuleId => $composableBuilder(
    column: $table.scheduleRuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyConfidence => $composableBuilder(
    column: $table.frequencyConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrescriptionsTableOrderingComposer get prescriptionId {
    final $$PrescriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriptionId,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get strengthUnit => $composableBuilder(
    column: $table.strengthUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doseInstructions => $composableBuilder(
    column: $table.doseInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<String> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<String> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get confirmedByUser => $composableBuilder(
    column: $table.confirmedByUser,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleRuleId => $composableBuilder(
    column: $table.scheduleRuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequencyConfidence => $composableBuilder(
    column: $table.frequencyConfidence,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrescriptionsTableAnnotationComposer get prescriptionId {
    final $$PrescriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriptionId,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reminderEventsRefs<T extends Object>(
    Expression<T> Function($$ReminderEventsTableAnnotationComposer a) f,
  ) {
    final $$ReminderEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicinesTable,
          Medicine,
          $$MedicinesTableFilterComposer,
          $$MedicinesTableOrderingComposer,
          $$MedicinesTableAnnotationComposer,
          $$MedicinesTableCreateCompanionBuilder,
          $$MedicinesTableUpdateCompanionBuilder,
          (Medicine, $$MedicinesTableReferences),
          Medicine,
          PrefetchHooks Function({
            bool userId,
            bool prescriptionId,
            bool reminderEventsRefs,
          })
        > {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> prescriptionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> strength = const Value.absent(),
                Value<String> strengthUnit = const Value.absent(),
                Value<String> doseInstructions = const Value.absent(),
                Value<String> route = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> duration = const Value.absent(),
                Value<String> timing = const Value.absent(),
                Value<String?> startAt = const Value.absent(),
                Value<String?> endAt = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<DateTime?> confirmedAt = const Value.absent(),
                Value<bool> confirmedByUser = const Value.absent(),
                Value<String?> scheduleRuleId = const Value.absent(),
                Value<String> frequencyConfidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicinesCompanion(
                id: id,
                userId: userId,
                prescriptionId: prescriptionId,
                name: name,
                strength: strength,
                strengthUnit: strengthUnit,
                doseInstructions: doseInstructions,
                route: route,
                frequency: frequency,
                duration: duration,
                timing: timing,
                startAt: startAt,
                endAt: endAt,
                reviewStatus: reviewStatus,
                confirmedAt: confirmedAt,
                confirmedByUser: confirmedByUser,
                scheduleRuleId: scheduleRuleId,
                frequencyConfidence: frequencyConfidence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String prescriptionId,
                required String name,
                required String strength,
                required String strengthUnit,
                required String doseInstructions,
                required String route,
                required String frequency,
                required String duration,
                required String timing,
                Value<String?> startAt = const Value.absent(),
                Value<String?> endAt = const Value.absent(),
                required String reviewStatus,
                Value<DateTime?> confirmedAt = const Value.absent(),
                Value<bool> confirmedByUser = const Value.absent(),
                Value<String?> scheduleRuleId = const Value.absent(),
                required String frequencyConfidence,
                Value<int> rowid = const Value.absent(),
              }) => MedicinesCompanion.insert(
                id: id,
                userId: userId,
                prescriptionId: prescriptionId,
                name: name,
                strength: strength,
                strengthUnit: strengthUnit,
                doseInstructions: doseInstructions,
                route: route,
                frequency: frequency,
                duration: duration,
                timing: timing,
                startAt: startAt,
                endAt: endAt,
                reviewStatus: reviewStatus,
                confirmedAt: confirmedAt,
                confirmedByUser: confirmedByUser,
                scheduleRuleId: scheduleRuleId,
                frequencyConfidence: frequencyConfidence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicinesTable, Medicine>(table),
                  $$MedicinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                prescriptionId = false,
                reminderEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reminderEventsRefs) db.reminderEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$MedicinesTableReferences
                                ._userIdTable(db),
                            referencedColumn: $$MedicinesTableReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (prescriptionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.prescriptionId,
                            referencedTable: $$MedicinesTableReferences
                                ._prescriptionIdTable(db),
                            referencedColumn: $$MedicinesTableReferences
                                ._prescriptionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reminderEventsRefs)
                        await $_getPrefetchedData<
                          Medicine,
                          $MedicinesTable,
                          ReminderEvent
                        >(
                          currentTable: table,
                          referencedTable: $$MedicinesTableReferences
                              ._reminderEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicinesTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicinesTable,
      Medicine,
      $$MedicinesTableFilterComposer,
      $$MedicinesTableOrderingComposer,
      $$MedicinesTableAnnotationComposer,
      $$MedicinesTableCreateCompanionBuilder,
      $$MedicinesTableUpdateCompanionBuilder,
      (Medicine, $$MedicinesTableReferences),
      Medicine,
      PrefetchHooks Function({
        bool userId,
        bool prescriptionId,
        bool reminderEventsRefs,
      })
    >;
typedef $$ReminderEventsTableCreateCompanionBuilder =
    ReminderEventsCompanion Function({
      required String id,
      required String userId,
      required String medicineId,
      required DateTime fireAt,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReminderEventsTableUpdateCompanionBuilder =
    ReminderEventsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> medicineId,
      Value<DateTime> fireAt,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReminderEventsTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderEventsTable, ReminderEvent> {
  $$ReminderEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('reminder_events__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias('reminder_events__medicine_id__medicines__id');

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<String>('medicine_id')!;

    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AdherenceEntriesTable, List<AdherenceEntry>>
  _adherenceEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.adherenceEntries,
    aliasName: 'reminder_events__id__adherence_entries__reminder_event_id',
  );

  $$AdherenceEntriesTableProcessedTableManager get adherenceEntriesRefs {
    final manager =
        $$AdherenceEntriesTableTableManager($_db, $_db.adherenceEntries).filter(
          (f) => f.reminderEventId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _adherenceEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReminderEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderEventsTable> {
  $$ReminderEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> adherenceEntriesRefs(
    Expression<bool> Function($$AdherenceEntriesTableFilterComposer f) f,
  ) {
    final $$AdherenceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adherenceEntries,
      getReferencedColumn: (t) => t.reminderEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdherenceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.adherenceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReminderEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderEventsTable> {
  $$ReminderEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableOrderingComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderEventsTable> {
  $$ReminderEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> adherenceEntriesRefs<T extends Object>(
    Expression<T> Function($$AdherenceEntriesTableAnnotationComposer a) f,
  ) {
    final $$AdherenceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adherenceEntries,
      getReferencedColumn: (t) => t.reminderEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdherenceEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.adherenceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReminderEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderEventsTable,
          ReminderEvent,
          $$ReminderEventsTableFilterComposer,
          $$ReminderEventsTableOrderingComposer,
          $$ReminderEventsTableAnnotationComposer,
          $$ReminderEventsTableCreateCompanionBuilder,
          $$ReminderEventsTableUpdateCompanionBuilder,
          (ReminderEvent, $$ReminderEventsTableReferences),
          ReminderEvent,
          PrefetchHooks Function({
            bool userId,
            bool medicineId,
            bool adherenceEntriesRefs,
          })
        > {
  $$ReminderEventsTableTableManager(
    _$AppDatabase db,
    $ReminderEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> medicineId = const Value.absent(),
                Value<DateTime> fireAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderEventsCompanion(
                id: id,
                userId: userId,
                medicineId: medicineId,
                fireAt: fireAt,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String medicineId,
                required DateTime fireAt,
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderEventsCompanion.insert(
                id: id,
                userId: userId,
                medicineId: medicineId,
                fireAt: fireAt,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderEventsTable, ReminderEvent>(table),
                  $$ReminderEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                medicineId = false,
                adherenceEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (adherenceEntriesRefs) db.adherenceEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$ReminderEventsTableReferences
                                ._userIdTable(db),
                            referencedColumn: $$ReminderEventsTableReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (medicineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicineId,
                            referencedTable: $$ReminderEventsTableReferences
                                ._medicineIdTable(db),
                            referencedColumn: $$ReminderEventsTableReferences
                                ._medicineIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (adherenceEntriesRefs)
                        await $_getPrefetchedData<
                          ReminderEvent,
                          $ReminderEventsTable,
                          AdherenceEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ReminderEventsTableReferences
                              ._adherenceEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReminderEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).adherenceEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reminderEventId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReminderEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderEventsTable,
      ReminderEvent,
      $$ReminderEventsTableFilterComposer,
      $$ReminderEventsTableOrderingComposer,
      $$ReminderEventsTableAnnotationComposer,
      $$ReminderEventsTableCreateCompanionBuilder,
      $$ReminderEventsTableUpdateCompanionBuilder,
      (ReminderEvent, $$ReminderEventsTableReferences),
      ReminderEvent,
      PrefetchHooks Function({
        bool userId,
        bool medicineId,
        bool adherenceEntriesRefs,
      })
    >;
typedef $$AdherenceEntriesTableCreateCompanionBuilder =
    AdherenceEntriesCompanion Function({
      required String id,
      required String userId,
      required String reminderEventId,
      required String status,
      required DateTime recordedAt,
      Value<int> rowid,
    });
typedef $$AdherenceEntriesTableUpdateCompanionBuilder =
    AdherenceEntriesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> reminderEventId,
      Value<String> status,
      Value<DateTime> recordedAt,
      Value<int> rowid,
    });

final class $$AdherenceEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $AdherenceEntriesTable, AdherenceEntry> {
  $$AdherenceEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('adherence_entries__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReminderEventsTable _reminderEventIdTable(_$AppDatabase db) => db
      .reminderEvents
      .createAlias('adherence_entries__reminder_event_id__reminder_events__id');

  $$ReminderEventsTableProcessedTableManager get reminderEventId {
    final $_column = $_itemColumn<String>('reminder_event_id')!;

    final manager = $$ReminderEventsTableTableManager(
      $_db,
      $_db.reminderEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderEventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AdherenceEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AdherenceEntriesTable> {
  $$AdherenceEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReminderEventsTableFilterComposer get reminderEventId {
    final $$ReminderEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderEventId,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableFilterComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdherenceEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AdherenceEntriesTable> {
  $$AdherenceEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReminderEventsTableOrderingComposer get reminderEventId {
    final $$ReminderEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderEventId,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableOrderingComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdherenceEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdherenceEntriesTable> {
  $$AdherenceEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReminderEventsTableAnnotationComposer get reminderEventId {
    final $$ReminderEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderEventId,
      referencedTable: $db.reminderEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdherenceEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdherenceEntriesTable,
          AdherenceEntry,
          $$AdherenceEntriesTableFilterComposer,
          $$AdherenceEntriesTableOrderingComposer,
          $$AdherenceEntriesTableAnnotationComposer,
          $$AdherenceEntriesTableCreateCompanionBuilder,
          $$AdherenceEntriesTableUpdateCompanionBuilder,
          (AdherenceEntry, $$AdherenceEntriesTableReferences),
          AdherenceEntry,
          PrefetchHooks Function({bool userId, bool reminderEventId})
        > {
  $$AdherenceEntriesTableTableManager(
    _$AppDatabase db,
    $AdherenceEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdherenceEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdherenceEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdherenceEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> reminderEventId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdherenceEntriesCompanion(
                id: id,
                userId: userId,
                reminderEventId: reminderEventId,
                status: status,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String reminderEventId,
                required String status,
                required DateTime recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => AdherenceEntriesCompanion.insert(
                id: id,
                userId: userId,
                reminderEventId: reminderEventId,
                status: status,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AdherenceEntriesTable, AdherenceEntry>(table),
                  $$AdherenceEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, reminderEventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$AdherenceEntriesTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$AdherenceEntriesTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (reminderEventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.reminderEventId,
                        referencedTable: $$AdherenceEntriesTableReferences
                            ._reminderEventIdTable(db),
                        referencedColumn: $$AdherenceEntriesTableReferences
                            ._reminderEventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AdherenceEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdherenceEntriesTable,
      AdherenceEntry,
      $$AdherenceEntriesTableFilterComposer,
      $$AdherenceEntriesTableOrderingComposer,
      $$AdherenceEntriesTableAnnotationComposer,
      $$AdherenceEntriesTableCreateCompanionBuilder,
      $$AdherenceEntriesTableUpdateCompanionBuilder,
      (AdherenceEntry, $$AdherenceEntriesTableReferences),
      AdherenceEntry,
      PrefetchHooks Function({bool userId, bool reminderEventId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PrescriptionsTableTableManager get prescriptions =>
      $$PrescriptionsTableTableManager(_db, _db.prescriptions);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$ReminderEventsTableTableManager get reminderEvents =>
      $$ReminderEventsTableTableManager(_db, _db.reminderEvents);
  $$AdherenceEntriesTableTableManager get adherenceEntries =>
      $$AdherenceEntriesTableTableManager(_db, _db.adherenceEntries);
}
