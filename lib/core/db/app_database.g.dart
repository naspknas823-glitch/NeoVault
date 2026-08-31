// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ps5PriceMeta =
      const VerificationMeta('ps5Price');
  @override
  late final GeneratedColumn<int> ps5Price = GeneratedColumn<int>(
      'ps5_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monitorPriceMeta =
      const VerificationMeta('monitorPrice');
  @override
  late final GeneratedColumn<int> monitorPrice = GeneratedColumn<int>(
      'monitor_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, ps5Price, monitorPrice, createdAt, completed, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
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
    if (data.containsKey('ps5_price')) {
      context.handle(_ps5PriceMeta,
          ps5Price.isAcceptableOrUnknown(data['ps5_price']!, _ps5PriceMeta));
    } else if (isInserting) {
      context.missing(_ps5PriceMeta);
    }
    if (data.containsKey('monitor_price')) {
      context.handle(
          _monitorPriceMeta,
          monitorPrice.isAcceptableOrUnknown(
              data['monitor_price']!, _monitorPriceMeta));
    } else if (isInserting) {
      context.missing(_monitorPriceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      ps5Price: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ps5_price'])!,
      monitorPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}monitor_price'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String title;
  final int ps5Price;
  final int monitorPrice;
  final int createdAt;
  final bool completed;
  final bool synced;
  const Goal(
      {required this.id,
      required this.title,
      required this.ps5Price,
      required this.monitorPrice,
      required this.createdAt,
      required this.completed,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['ps5_price'] = Variable<int>(ps5Price);
    map['monitor_price'] = Variable<int>(monitorPrice);
    map['created_at'] = Variable<int>(createdAt);
    map['completed'] = Variable<bool>(completed);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      ps5Price: Value(ps5Price),
      monitorPrice: Value(monitorPrice),
      createdAt: Value(createdAt),
      completed: Value(completed),
      synced: Value(synced),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      ps5Price: serializer.fromJson<int>(json['ps5Price']),
      monitorPrice: serializer.fromJson<int>(json['monitorPrice']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      completed: serializer.fromJson<bool>(json['completed']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'ps5Price': serializer.toJson<int>(ps5Price),
      'monitorPrice': serializer.toJson<int>(monitorPrice),
      'createdAt': serializer.toJson<int>(createdAt),
      'completed': serializer.toJson<bool>(completed),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Goal copyWith(
          {String? id,
          String? title,
          int? ps5Price,
          int? monitorPrice,
          int? createdAt,
          bool? completed,
          bool? synced}) =>
      Goal(
        id: id ?? this.id,
        title: title ?? this.title,
        ps5Price: ps5Price ?? this.ps5Price,
        monitorPrice: monitorPrice ?? this.monitorPrice,
        createdAt: createdAt ?? this.createdAt,
        completed: completed ?? this.completed,
        synced: synced ?? this.synced,
      );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      ps5Price: data.ps5Price.present ? data.ps5Price.value : this.ps5Price,
      monitorPrice: data.monitorPrice.present
          ? data.monitorPrice.value
          : this.monitorPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completed: data.completed.present ? data.completed.value : this.completed,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('ps5Price: $ps5Price, ')
          ..write('monitorPrice: $monitorPrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('completed: $completed, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, ps5Price, monitorPrice, createdAt, completed, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.title == this.title &&
          other.ps5Price == this.ps5Price &&
          other.monitorPrice == this.monitorPrice &&
          other.createdAt == this.createdAt &&
          other.completed == this.completed &&
          other.synced == this.synced);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> ps5Price;
  final Value<int> monitorPrice;
  final Value<int> createdAt;
  final Value<bool> completed;
  final Value<bool> synced;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.ps5Price = const Value.absent(),
    this.monitorPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String title,
    required int ps5Price,
    required int monitorPrice,
    required int createdAt,
    this.completed = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        ps5Price = Value(ps5Price),
        monitorPrice = Value(monitorPrice),
        createdAt = Value(createdAt);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? ps5Price,
    Expression<int>? monitorPrice,
    Expression<int>? createdAt,
    Expression<bool>? completed,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (ps5Price != null) 'ps5_price': ps5Price,
      if (monitorPrice != null) 'monitor_price': monitorPrice,
      if (createdAt != null) 'created_at': createdAt,
      if (completed != null) 'completed': completed,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? ps5Price,
      Value<int>? monitorPrice,
      Value<int>? createdAt,
      Value<bool>? completed,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      ps5Price: ps5Price ?? this.ps5Price,
      monitorPrice: monitorPrice ?? this.monitorPrice,
      createdAt: createdAt ?? this.createdAt,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
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
    if (ps5Price.present) {
      map['ps5_price'] = Variable<int>(ps5Price.value);
    }
    if (monitorPrice.present) {
      map['monitor_price'] = Variable<int>(monitorPrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('ps5Price: $ps5Price, ')
          ..write('monitorPrice: $monitorPrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('completed: $completed, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalItemsTable extends GoalItems
    with TableInfo<$GoalItemsTable, GoalItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetPriceMeta =
      const VerificationMeta('targetPrice');
  @override
  late final GeneratedColumn<int> targetPrice = GeneratedColumn<int>(
      'target_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, goalId, kind, title, targetPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_items';
  @override
  VerificationContext validateIntegrity(Insertable<GoalItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_price')) {
      context.handle(
          _targetPriceMeta,
          targetPrice.isAcceptableOrUnknown(
              data['target_price']!, _targetPriceMeta));
    } else if (isInserting) {
      context.missing(_targetPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      targetPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_price'])!,
    );
  }

  @override
  $GoalItemsTable createAlias(String alias) {
    return $GoalItemsTable(attachedDatabase, alias);
  }
}

class GoalItem extends DataClass implements Insertable<GoalItem> {
  final String id;
  final String goalId;
  final String kind;
  final String title;
  final int targetPrice;
  const GoalItem(
      {required this.id,
      required this.goalId,
      required this.kind,
      required this.title,
      required this.targetPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['target_price'] = Variable<int>(targetPrice);
    return map;
  }

  GoalItemsCompanion toCompanion(bool nullToAbsent) {
    return GoalItemsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      kind: Value(kind),
      title: Value(title),
      targetPrice: Value(targetPrice),
    );
  }

  factory GoalItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalItem(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      targetPrice: serializer.fromJson<int>(json['targetPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'targetPrice': serializer.toJson<int>(targetPrice),
    };
  }

  GoalItem copyWith(
          {String? id,
          String? goalId,
          String? kind,
          String? title,
          int? targetPrice}) =>
      GoalItem(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        kind: kind ?? this.kind,
        title: title ?? this.title,
        targetPrice: targetPrice ?? this.targetPrice,
      );
  GoalItem copyWithCompanion(GoalItemsCompanion data) {
    return GoalItem(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      targetPrice:
          data.targetPrice.present ? data.targetPrice.value : this.targetPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalItem(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('targetPrice: $targetPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, kind, title, targetPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalItem &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.targetPrice == this.targetPrice);
}

class GoalItemsCompanion extends UpdateCompanion<GoalItem> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> kind;
  final Value<String> title;
  final Value<int> targetPrice;
  final Value<int> rowid;
  const GoalItemsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalItemsCompanion.insert({
    required String id,
    required String goalId,
    required String kind,
    required String title,
    required int targetPrice,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        kind = Value(kind),
        title = Value(title),
        targetPrice = Value(targetPrice);
  static Insertable<GoalItem> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<int>? targetPrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (targetPrice != null) 'target_price': targetPrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<String>? kind,
      Value<String>? title,
      Value<int>? targetPrice,
      Value<int>? rowid}) {
    return GoalItemsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      targetPrice: targetPrice ?? this.targetPrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetPrice.present) {
      map['target_price'] = Variable<int>(targetPrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalItemsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContributionsTable extends Contributions
    with TableInfo<$ContributionsTable, Contribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiptPathMeta =
      const VerificationMeta('receiptPath');
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
      'receipt_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakBonusMeta =
      const VerificationMeta('streakBonus');
  @override
  late final GeneratedColumn<int> streakBonus = GeneratedColumn<int>(
      'streak_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        goalId,
        amount,
        comment,
        receiptPath,
        xpEarned,
        streakBonus,
        occurredAt,
        createdAt,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contributions';
  @override
  VerificationContext validateIntegrity(Insertable<Contribution> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
          _receiptPathMeta,
          receiptPath.isAcceptableOrUnknown(
              data['receipt_path']!, _receiptPathMeta));
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    }
    if (data.containsKey('streak_bonus')) {
      context.handle(
          _streakBonusMeta,
          streakBonus.isAcceptableOrUnknown(
              data['streak_bonus']!, _streakBonusMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contribution(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      receiptPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_path']),
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
      streakBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_bonus'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}occurred_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $ContributionsTable createAlias(String alias) {
    return $ContributionsTable(attachedDatabase, alias);
  }
}

class Contribution extends DataClass implements Insertable<Contribution> {
  final String id;
  final String goalId;
  final int amount;
  final String? comment;
  final String? receiptPath;
  final int xpEarned;
  final int streakBonus;
  final int occurredAt;
  final int createdAt;
  final bool synced;
  const Contribution(
      {required this.id,
      required this.goalId,
      required this.amount,
      this.comment,
      this.receiptPath,
      required this.xpEarned,
      required this.streakBonus,
      required this.occurredAt,
      required this.createdAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    map['xp_earned'] = Variable<int>(xpEarned);
    map['streak_bonus'] = Variable<int>(streakBonus);
    map['occurred_at'] = Variable<int>(occurredAt);
    map['created_at'] = Variable<int>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ContributionsCompanion toCompanion(bool nullToAbsent) {
    return ContributionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      amount: Value(amount),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      xpEarned: Value(xpEarned),
      streakBonus: Value(streakBonus),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory Contribution.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contribution(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      amount: serializer.fromJson<int>(json['amount']),
      comment: serializer.fromJson<String?>(json['comment']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      streakBonus: serializer.fromJson<int>(json['streakBonus']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'amount': serializer.toJson<int>(amount),
      'comment': serializer.toJson<String?>(comment),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'streakBonus': serializer.toJson<int>(streakBonus),
      'occurredAt': serializer.toJson<int>(occurredAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Contribution copyWith(
          {String? id,
          String? goalId,
          int? amount,
          Value<String?> comment = const Value.absent(),
          Value<String?> receiptPath = const Value.absent(),
          int? xpEarned,
          int? streakBonus,
          int? occurredAt,
          int? createdAt,
          bool? synced}) =>
      Contribution(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        amount: amount ?? this.amount,
        comment: comment.present ? comment.value : this.comment,
        receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
        xpEarned: xpEarned ?? this.xpEarned,
        streakBonus: streakBonus ?? this.streakBonus,
        occurredAt: occurredAt ?? this.occurredAt,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
  Contribution copyWithCompanion(ContributionsCompanion data) {
    return Contribution(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amount: data.amount.present ? data.amount.value : this.amount,
      comment: data.comment.present ? data.comment.value : this.comment,
      receiptPath:
          data.receiptPath.present ? data.receiptPath.value : this.receiptPath,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      streakBonus:
          data.streakBonus.present ? data.streakBonus.value : this.streakBonus,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contribution(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('comment: $comment, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('streakBonus: $streakBonus, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, amount, comment, receiptPath,
      xpEarned, streakBonus, occurredAt, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contribution &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.amount == this.amount &&
          other.comment == this.comment &&
          other.receiptPath == this.receiptPath &&
          other.xpEarned == this.xpEarned &&
          other.streakBonus == this.streakBonus &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class ContributionsCompanion extends UpdateCompanion<Contribution> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<int> amount;
  final Value<String?> comment;
  final Value<String?> receiptPath;
  final Value<int> xpEarned;
  final Value<int> streakBonus;
  final Value<int> occurredAt;
  final Value<int> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const ContributionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amount = const Value.absent(),
    this.comment = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.streakBonus = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContributionsCompanion.insert({
    required String id,
    required String goalId,
    required int amount,
    this.comment = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.streakBonus = const Value.absent(),
    required int occurredAt,
    required int createdAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        amount = Value(amount),
        occurredAt = Value(occurredAt),
        createdAt = Value(createdAt);
  static Insertable<Contribution> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<int>? amount,
    Expression<String>? comment,
    Expression<String>? receiptPath,
    Expression<int>? xpEarned,
    Expression<int>? streakBonus,
    Expression<int>? occurredAt,
    Expression<int>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (amount != null) 'amount': amount,
      if (comment != null) 'comment': comment,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (streakBonus != null) 'streak_bonus': streakBonus,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContributionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<int>? amount,
      Value<String?>? comment,
      Value<String?>? receiptPath,
      Value<int>? xpEarned,
      Value<int>? streakBonus,
      Value<int>? occurredAt,
      Value<int>? createdAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return ContributionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      comment: comment ?? this.comment,
      receiptPath: receiptPath ?? this.receiptPath,
      xpEarned: xpEarned ?? this.xpEarned,
      streakBonus: streakBonus ?? this.streakBonus,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (streakBonus.present) {
      map['streak_bonus'] = Variable<int>(streakBonus.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContributionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('comment: $comment, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('streakBonus: $streakBonus, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bonusXpMeta =
      const VerificationMeta('bonusXp');
  @override
  late final GeneratedColumn<int> bonusXp = GeneratedColumn<int>(
      'bonus_xp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _secretMeta = const VerificationMeta('secret');
  @override
  late final GeneratedColumn<bool> secret = GeneratedColumn<bool>(
      'secret', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("secret" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, category, bonusXp, secret];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(Insertable<Achievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('bonus_xp')) {
      context.handle(_bonusXpMeta,
          bonusXp.isAcceptableOrUnknown(data['bonus_xp']!, _bonusXpMeta));
    } else if (isInserting) {
      context.missing(_bonusXpMeta);
    }
    if (data.containsKey('secret')) {
      context.handle(_secretMeta,
          secret.isAcceptableOrUnknown(data['secret']!, _secretMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      bonusXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus_xp'])!,
      secret: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}secret'])!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final String id;
  final String category;
  final int bonusXp;
  final bool secret;
  const Achievement(
      {required this.id,
      required this.category,
      required this.bonusXp,
      required this.secret});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['bonus_xp'] = Variable<int>(bonusXp);
    map['secret'] = Variable<bool>(secret);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      category: Value(category),
      bonusXp: Value(bonusXp),
      secret: Value(secret),
    );
  }

  factory Achievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      bonusXp: serializer.fromJson<int>(json['bonusXp']),
      secret: serializer.fromJson<bool>(json['secret']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'bonusXp': serializer.toJson<int>(bonusXp),
      'secret': serializer.toJson<bool>(secret),
    };
  }

  Achievement copyWith(
          {String? id, String? category, int? bonusXp, bool? secret}) =>
      Achievement(
        id: id ?? this.id,
        category: category ?? this.category,
        bonusXp: bonusXp ?? this.bonusXp,
        secret: secret ?? this.secret,
      );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      bonusXp: data.bonusXp.present ? data.bonusXp.value : this.bonusXp,
      secret: data.secret.present ? data.secret.value : this.secret,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('bonusXp: $bonusXp, ')
          ..write('secret: $secret')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, bonusXp, secret);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.category == this.category &&
          other.bonusXp == this.bonusXp &&
          other.secret == this.secret);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> id;
  final Value<String> category;
  final Value<int> bonusXp;
  final Value<bool> secret;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.bonusXp = const Value.absent(),
    this.secret = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String id,
    required String category,
    required int bonusXp,
    this.secret = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        category = Value(category),
        bonusXp = Value(bonusXp);
  static Insertable<Achievement> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<int>? bonusXp,
    Expression<bool>? secret,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (bonusXp != null) 'bonus_xp': bonusXp,
      if (secret != null) 'secret': secret,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? category,
      Value<int>? bonusXp,
      Value<bool>? secret,
      Value<int>? rowid}) {
    return AchievementsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      bonusXp: bonusXp ?? this.bonusXp,
      secret: secret ?? this.secret,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (bonusXp.present) {
      map['bonus_xp'] = Variable<int>(bonusXp.value);
    }
    if (secret.present) {
      map['secret'] = Variable<bool>(secret.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('bonusXp: $bonusXp, ')
          ..write('secret: $secret, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsUnlockedTable extends AchievementsUnlocked
    with TableInfo<$AchievementsUnlockedTable, AchievementsUnlockedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsUnlockedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _achievementIdMeta =
      const VerificationMeta('achievementId');
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
      'achievement_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<int> unlockedAt = GeneratedColumn<int>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [achievementId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements_unlocked';
  @override
  VerificationContext validateIntegrity(
      Insertable<AchievementsUnlockedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('achievement_id')) {
      context.handle(
          _achievementIdMeta,
          achievementId.isAcceptableOrUnknown(
              data['achievement_id']!, _achievementIdMeta));
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {achievementId};
  @override
  AchievementsUnlockedData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementsUnlockedData(
      achievementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}achievement_id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $AchievementsUnlockedTable createAlias(String alias) {
    return $AchievementsUnlockedTable(attachedDatabase, alias);
  }
}

class AchievementsUnlockedData extends DataClass
    implements Insertable<AchievementsUnlockedData> {
  final String achievementId;
  final int unlockedAt;
  const AchievementsUnlockedData(
      {required this.achievementId, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['achievement_id'] = Variable<String>(achievementId);
    map['unlocked_at'] = Variable<int>(unlockedAt);
    return map;
  }

  AchievementsUnlockedCompanion toCompanion(bool nullToAbsent) {
    return AchievementsUnlockedCompanion(
      achievementId: Value(achievementId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory AchievementsUnlockedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementsUnlockedData(
      achievementId: serializer.fromJson<String>(json['achievementId']),
      unlockedAt: serializer.fromJson<int>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'achievementId': serializer.toJson<String>(achievementId),
      'unlockedAt': serializer.toJson<int>(unlockedAt),
    };
  }

  AchievementsUnlockedData copyWith({String? achievementId, int? unlockedAt}) =>
      AchievementsUnlockedData(
        achievementId: achievementId ?? this.achievementId,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  AchievementsUnlockedData copyWithCompanion(
      AchievementsUnlockedCompanion data) {
    return AchievementsUnlockedData(
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsUnlockedData(')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(achievementId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementsUnlockedData &&
          other.achievementId == this.achievementId &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsUnlockedCompanion
    extends UpdateCompanion<AchievementsUnlockedData> {
  final Value<String> achievementId;
  final Value<int> unlockedAt;
  final Value<int> rowid;
  const AchievementsUnlockedCompanion({
    this.achievementId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsUnlockedCompanion.insert({
    required String achievementId,
    required int unlockedAt,
    this.rowid = const Value.absent(),
  })  : achievementId = Value(achievementId),
        unlockedAt = Value(unlockedAt);
  static Insertable<AchievementsUnlockedData> custom({
    Expression<String>? achievementId,
    Expression<int>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (achievementId != null) 'achievement_id': achievementId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsUnlockedCompanion copyWith(
      {Value<String>? achievementId,
      Value<int>? unlockedAt,
      Value<int>? rowid}) {
    return AchievementsUnlockedCompanion(
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<int>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsUnlockedCompanion(')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  final int updatedAt;
  const Setting(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Setting copyWith({String? key, String? value, int? updatedAt}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTableTable extends UserStatsTable
    with TableInfo<$UserStatsTableTable, UserStatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalXpMeta =
      const VerificationMeta('totalXp');
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
      'total_xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _streakDaysMeta =
      const VerificationMeta('streakDays');
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
      'streak_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastContributionDayMeta =
      const VerificationMeta('lastContributionDay');
  @override
  late final GeneratedColumn<String> lastContributionDay =
      GeneratedColumn<String>('last_contribution_day', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contributionsCountMeta =
      const VerificationMeta('contributionsCount');
  @override
  late final GeneratedColumn<int> contributionsCount = GeneratedColumn<int>(
      'contributions_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxSingleContributionMeta =
      const VerificationMeta('maxSingleContribution');
  @override
  late final GeneratedColumn<int> maxSingleContribution = GeneratedColumn<int>(
      'max_single_contribution', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _scannerChecksMeta =
      const VerificationMeta('scannerChecks');
  @override
  late final GeneratedColumn<int> scannerChecks = GeneratedColumn<int>(
      'scanner_checks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _priceDropsSeenMeta =
      const VerificationMeta('priceDropsSeen');
  @override
  late final GeneratedColumn<int> priceDropsSeen = GeneratedColumn<int>(
      'price_drops_seen', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _goodDealSeenMeta =
      const VerificationMeta('goodDealSeen');
  @override
  late final GeneratedColumn<bool> goodDealSeen = GeneratedColumn<bool>(
      'good_deal_seen', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("good_deal_seen" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _visitedScreensMeta =
      const VerificationMeta('visitedScreens');
  @override
  late final GeneratedColumn<String> visitedScreens = GeneratedColumn<String>(
      'visited_screens', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _themeChangesMeta =
      const VerificationMeta('themeChanges');
  @override
  late final GeneratedColumn<int> themeChanges = GeneratedColumn<int>(
      'theme_changes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _aiQuestionsMeta =
      const VerificationMeta('aiQuestions');
  @override
  late final GeneratedColumn<int> aiQuestions = GeneratedColumn<int>(
      'ai_questions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _historyViewed30dMeta =
      const VerificationMeta('historyViewed30d');
  @override
  late final GeneratedColumn<bool> historyViewed30d = GeneratedColumn<bool>(
      'history_viewed30d', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("history_viewed30d" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _installDateMeta =
      const VerificationMeta('installDate');
  @override
  late final GeneratedColumn<int> installDate = GeneratedColumn<int>(
      'install_date', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _avatarSeedMeta =
      const VerificationMeta('avatarSeed');
  @override
  late final GeneratedColumn<String> avatarSeed = GeneratedColumn<String>(
      'avatar_seed', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('nv'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authedMeta = const VerificationMeta('authed');
  @override
  late final GeneratedColumn<bool> authed = GeneratedColumn<bool>(
      'authed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("authed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _registeredAtMeta =
      const VerificationMeta('registeredAt');
  @override
  late final GeneratedColumn<int> registeredAt = GeneratedColumn<int>(
      'registered_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        totalXp,
        level,
        streakDays,
        lastContributionDay,
        contributionsCount,
        maxSingleContribution,
        scannerChecks,
        priceDropsSeen,
        goodDealSeen,
        visitedScreens,
        themeChanges,
        aiQuestions,
        historyViewed30d,
        installDate,
        nickname,
        avatarSeed,
        userId,
        email,
        authed,
        registeredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserStatsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('total_xp')) {
      context.handle(_totalXpMeta,
          totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('streak_days')) {
      context.handle(
          _streakDaysMeta,
          streakDays.isAcceptableOrUnknown(
              data['streak_days']!, _streakDaysMeta));
    }
    if (data.containsKey('last_contribution_day')) {
      context.handle(
          _lastContributionDayMeta,
          lastContributionDay.isAcceptableOrUnknown(
              data['last_contribution_day']!, _lastContributionDayMeta));
    }
    if (data.containsKey('contributions_count')) {
      context.handle(
          _contributionsCountMeta,
          contributionsCount.isAcceptableOrUnknown(
              data['contributions_count']!, _contributionsCountMeta));
    }
    if (data.containsKey('max_single_contribution')) {
      context.handle(
          _maxSingleContributionMeta,
          maxSingleContribution.isAcceptableOrUnknown(
              data['max_single_contribution']!, _maxSingleContributionMeta));
    }
    if (data.containsKey('scanner_checks')) {
      context.handle(
          _scannerChecksMeta,
          scannerChecks.isAcceptableOrUnknown(
              data['scanner_checks']!, _scannerChecksMeta));
    }
    if (data.containsKey('price_drops_seen')) {
      context.handle(
          _priceDropsSeenMeta,
          priceDropsSeen.isAcceptableOrUnknown(
              data['price_drops_seen']!, _priceDropsSeenMeta));
    }
    if (data.containsKey('good_deal_seen')) {
      context.handle(
          _goodDealSeenMeta,
          goodDealSeen.isAcceptableOrUnknown(
              data['good_deal_seen']!, _goodDealSeenMeta));
    }
    if (data.containsKey('visited_screens')) {
      context.handle(
          _visitedScreensMeta,
          visitedScreens.isAcceptableOrUnknown(
              data['visited_screens']!, _visitedScreensMeta));
    }
    if (data.containsKey('theme_changes')) {
      context.handle(
          _themeChangesMeta,
          themeChanges.isAcceptableOrUnknown(
              data['theme_changes']!, _themeChangesMeta));
    }
    if (data.containsKey('ai_questions')) {
      context.handle(
          _aiQuestionsMeta,
          aiQuestions.isAcceptableOrUnknown(
              data['ai_questions']!, _aiQuestionsMeta));
    }
    if (data.containsKey('history_viewed30d')) {
      context.handle(
          _historyViewed30dMeta,
          historyViewed30d.isAcceptableOrUnknown(
              data['history_viewed30d']!, _historyViewed30dMeta));
    }
    if (data.containsKey('install_date')) {
      context.handle(
          _installDateMeta,
          installDate.isAcceptableOrUnknown(
              data['install_date']!, _installDateMeta));
    } else if (isInserting) {
      context.missing(_installDateMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    }
    if (data.containsKey('avatar_seed')) {
      context.handle(
          _avatarSeedMeta,
          avatarSeed.isAcceptableOrUnknown(
              data['avatar_seed']!, _avatarSeedMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('authed')) {
      context.handle(_authedMeta,
          authed.isAcceptableOrUnknown(data['authed']!, _authedMeta));
    }
    if (data.containsKey('registered_at')) {
      context.handle(
          _registeredAtMeta,
          registeredAt.isAcceptableOrUnknown(
              data['registered_at']!, _registeredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStatsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      totalXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_xp'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      streakDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_days'])!,
      lastContributionDay: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_contribution_day']),
      contributionsCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}contributions_count'])!,
      maxSingleContribution: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}max_single_contribution'])!,
      scannerChecks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scanner_checks'])!,
      priceDropsSeen: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_drops_seen'])!,
      goodDealSeen: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}good_deal_seen'])!,
      visitedScreens: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}visited_screens'])!,
      themeChanges: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}theme_changes'])!,
      aiQuestions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ai_questions'])!,
      historyViewed30d: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}history_viewed30d'])!,
      installDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}install_date'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname'])!,
      avatarSeed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_seed'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      authed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}authed'])!,
      registeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}registered_at']),
    );
  }

  @override
  $UserStatsTableTable createAlias(String alias) {
    return $UserStatsTableTable(attachedDatabase, alias);
  }
}

class UserStatsTableData extends DataClass
    implements Insertable<UserStatsTableData> {
  final String id;
  final int totalXp;
  final int level;
  final int streakDays;
  final String? lastContributionDay;
  final int contributionsCount;
  final int maxSingleContribution;
  final int scannerChecks;
  final int priceDropsSeen;
  final bool goodDealSeen;
  final String visitedScreens;
  final int themeChanges;
  final int aiQuestions;
  final bool historyViewed30d;
  final int installDate;
  final String nickname;
  final String avatarSeed;
  final String userId;
  final String? email;
  final bool authed;
  final int? registeredAt;
  const UserStatsTableData(
      {required this.id,
      required this.totalXp,
      required this.level,
      required this.streakDays,
      this.lastContributionDay,
      required this.contributionsCount,
      required this.maxSingleContribution,
      required this.scannerChecks,
      required this.priceDropsSeen,
      required this.goodDealSeen,
      required this.visitedScreens,
      required this.themeChanges,
      required this.aiQuestions,
      required this.historyViewed30d,
      required this.installDate,
      required this.nickname,
      required this.avatarSeed,
      required this.userId,
      this.email,
      required this.authed,
      this.registeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['total_xp'] = Variable<int>(totalXp);
    map['level'] = Variable<int>(level);
    map['streak_days'] = Variable<int>(streakDays);
    if (!nullToAbsent || lastContributionDay != null) {
      map['last_contribution_day'] = Variable<String>(lastContributionDay);
    }
    map['contributions_count'] = Variable<int>(contributionsCount);
    map['max_single_contribution'] = Variable<int>(maxSingleContribution);
    map['scanner_checks'] = Variable<int>(scannerChecks);
    map['price_drops_seen'] = Variable<int>(priceDropsSeen);
    map['good_deal_seen'] = Variable<bool>(goodDealSeen);
    map['visited_screens'] = Variable<String>(visitedScreens);
    map['theme_changes'] = Variable<int>(themeChanges);
    map['ai_questions'] = Variable<int>(aiQuestions);
    map['history_viewed30d'] = Variable<bool>(historyViewed30d);
    map['install_date'] = Variable<int>(installDate);
    map['nickname'] = Variable<String>(nickname);
    map['avatar_seed'] = Variable<String>(avatarSeed);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['authed'] = Variable<bool>(authed);
    if (!nullToAbsent || registeredAt != null) {
      map['registered_at'] = Variable<int>(registeredAt);
    }
    return map;
  }

  UserStatsTableCompanion toCompanion(bool nullToAbsent) {
    return UserStatsTableCompanion(
      id: Value(id),
      totalXp: Value(totalXp),
      level: Value(level),
      streakDays: Value(streakDays),
      lastContributionDay: lastContributionDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastContributionDay),
      contributionsCount: Value(contributionsCount),
      maxSingleContribution: Value(maxSingleContribution),
      scannerChecks: Value(scannerChecks),
      priceDropsSeen: Value(priceDropsSeen),
      goodDealSeen: Value(goodDealSeen),
      visitedScreens: Value(visitedScreens),
      themeChanges: Value(themeChanges),
      aiQuestions: Value(aiQuestions),
      historyViewed30d: Value(historyViewed30d),
      installDate: Value(installDate),
      nickname: Value(nickname),
      avatarSeed: Value(avatarSeed),
      userId: Value(userId),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      authed: Value(authed),
      registeredAt: registeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(registeredAt),
    );
  }

  factory UserStatsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStatsTableData(
      id: serializer.fromJson<String>(json['id']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      level: serializer.fromJson<int>(json['level']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      lastContributionDay:
          serializer.fromJson<String?>(json['lastContributionDay']),
      contributionsCount: serializer.fromJson<int>(json['contributionsCount']),
      maxSingleContribution:
          serializer.fromJson<int>(json['maxSingleContribution']),
      scannerChecks: serializer.fromJson<int>(json['scannerChecks']),
      priceDropsSeen: serializer.fromJson<int>(json['priceDropsSeen']),
      goodDealSeen: serializer.fromJson<bool>(json['goodDealSeen']),
      visitedScreens: serializer.fromJson<String>(json['visitedScreens']),
      themeChanges: serializer.fromJson<int>(json['themeChanges']),
      aiQuestions: serializer.fromJson<int>(json['aiQuestions']),
      historyViewed30d: serializer.fromJson<bool>(json['historyViewed30d']),
      installDate: serializer.fromJson<int>(json['installDate']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarSeed: serializer.fromJson<String>(json['avatarSeed']),
      userId: serializer.fromJson<String>(json['userId']),
      email: serializer.fromJson<String?>(json['email']),
      authed: serializer.fromJson<bool>(json['authed']),
      registeredAt: serializer.fromJson<int?>(json['registeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'totalXp': serializer.toJson<int>(totalXp),
      'level': serializer.toJson<int>(level),
      'streakDays': serializer.toJson<int>(streakDays),
      'lastContributionDay': serializer.toJson<String?>(lastContributionDay),
      'contributionsCount': serializer.toJson<int>(contributionsCount),
      'maxSingleContribution': serializer.toJson<int>(maxSingleContribution),
      'scannerChecks': serializer.toJson<int>(scannerChecks),
      'priceDropsSeen': serializer.toJson<int>(priceDropsSeen),
      'goodDealSeen': serializer.toJson<bool>(goodDealSeen),
      'visitedScreens': serializer.toJson<String>(visitedScreens),
      'themeChanges': serializer.toJson<int>(themeChanges),
      'aiQuestions': serializer.toJson<int>(aiQuestions),
      'historyViewed30d': serializer.toJson<bool>(historyViewed30d),
      'installDate': serializer.toJson<int>(installDate),
      'nickname': serializer.toJson<String>(nickname),
      'avatarSeed': serializer.toJson<String>(avatarSeed),
      'userId': serializer.toJson<String>(userId),
      'email': serializer.toJson<String?>(email),
      'authed': serializer.toJson<bool>(authed),
      'registeredAt': serializer.toJson<int?>(registeredAt),
    };
  }

  UserStatsTableData copyWith(
          {String? id,
          int? totalXp,
          int? level,
          int? streakDays,
          Value<String?> lastContributionDay = const Value.absent(),
          int? contributionsCount,
          int? maxSingleContribution,
          int? scannerChecks,
          int? priceDropsSeen,
          bool? goodDealSeen,
          String? visitedScreens,
          int? themeChanges,
          int? aiQuestions,
          bool? historyViewed30d,
          int? installDate,
          String? nickname,
          String? avatarSeed,
          String? userId,
          Value<String?> email = const Value.absent(),
          bool? authed,
          Value<int?> registeredAt = const Value.absent()}) =>
      UserStatsTableData(
        id: id ?? this.id,
        totalXp: totalXp ?? this.totalXp,
        level: level ?? this.level,
        streakDays: streakDays ?? this.streakDays,
        lastContributionDay: lastContributionDay.present
            ? lastContributionDay.value
            : this.lastContributionDay,
        contributionsCount: contributionsCount ?? this.contributionsCount,
        maxSingleContribution:
            maxSingleContribution ?? this.maxSingleContribution,
        scannerChecks: scannerChecks ?? this.scannerChecks,
        priceDropsSeen: priceDropsSeen ?? this.priceDropsSeen,
        goodDealSeen: goodDealSeen ?? this.goodDealSeen,
        visitedScreens: visitedScreens ?? this.visitedScreens,
        themeChanges: themeChanges ?? this.themeChanges,
        aiQuestions: aiQuestions ?? this.aiQuestions,
        historyViewed30d: historyViewed30d ?? this.historyViewed30d,
        installDate: installDate ?? this.installDate,
        nickname: nickname ?? this.nickname,
        avatarSeed: avatarSeed ?? this.avatarSeed,
        userId: userId ?? this.userId,
        email: email.present ? email.value : this.email,
        authed: authed ?? this.authed,
        registeredAt:
            registeredAt.present ? registeredAt.value : this.registeredAt,
      );
  UserStatsTableData copyWithCompanion(UserStatsTableCompanion data) {
    return UserStatsTableData(
      id: data.id.present ? data.id.value : this.id,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      level: data.level.present ? data.level.value : this.level,
      streakDays:
          data.streakDays.present ? data.streakDays.value : this.streakDays,
      lastContributionDay: data.lastContributionDay.present
          ? data.lastContributionDay.value
          : this.lastContributionDay,
      contributionsCount: data.contributionsCount.present
          ? data.contributionsCount.value
          : this.contributionsCount,
      maxSingleContribution: data.maxSingleContribution.present
          ? data.maxSingleContribution.value
          : this.maxSingleContribution,
      scannerChecks: data.scannerChecks.present
          ? data.scannerChecks.value
          : this.scannerChecks,
      priceDropsSeen: data.priceDropsSeen.present
          ? data.priceDropsSeen.value
          : this.priceDropsSeen,
      goodDealSeen: data.goodDealSeen.present
          ? data.goodDealSeen.value
          : this.goodDealSeen,
      visitedScreens: data.visitedScreens.present
          ? data.visitedScreens.value
          : this.visitedScreens,
      themeChanges: data.themeChanges.present
          ? data.themeChanges.value
          : this.themeChanges,
      aiQuestions:
          data.aiQuestions.present ? data.aiQuestions.value : this.aiQuestions,
      historyViewed30d: data.historyViewed30d.present
          ? data.historyViewed30d.value
          : this.historyViewed30d,
      installDate:
          data.installDate.present ? data.installDate.value : this.installDate,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarSeed:
          data.avatarSeed.present ? data.avatarSeed.value : this.avatarSeed,
      userId: data.userId.present ? data.userId.value : this.userId,
      email: data.email.present ? data.email.value : this.email,
      authed: data.authed.present ? data.authed.value : this.authed,
      registeredAt: data.registeredAt.present
          ? data.registeredAt.value
          : this.registeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableData(')
          ..write('id: $id, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('streakDays: $streakDays, ')
          ..write('lastContributionDay: $lastContributionDay, ')
          ..write('contributionsCount: $contributionsCount, ')
          ..write('maxSingleContribution: $maxSingleContribution, ')
          ..write('scannerChecks: $scannerChecks, ')
          ..write('priceDropsSeen: $priceDropsSeen, ')
          ..write('goodDealSeen: $goodDealSeen, ')
          ..write('visitedScreens: $visitedScreens, ')
          ..write('themeChanges: $themeChanges, ')
          ..write('aiQuestions: $aiQuestions, ')
          ..write('historyViewed30d: $historyViewed30d, ')
          ..write('installDate: $installDate, ')
          ..write('nickname: $nickname, ')
          ..write('avatarSeed: $avatarSeed, ')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('authed: $authed, ')
          ..write('registeredAt: $registeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        totalXp,
        level,
        streakDays,
        lastContributionDay,
        contributionsCount,
        maxSingleContribution,
        scannerChecks,
        priceDropsSeen,
        goodDealSeen,
        visitedScreens,
        themeChanges,
        aiQuestions,
        historyViewed30d,
        installDate,
        nickname,
        avatarSeed,
        userId,
        email,
        authed,
        registeredAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStatsTableData &&
          other.id == this.id &&
          other.totalXp == this.totalXp &&
          other.level == this.level &&
          other.streakDays == this.streakDays &&
          other.lastContributionDay == this.lastContributionDay &&
          other.contributionsCount == this.contributionsCount &&
          other.maxSingleContribution == this.maxSingleContribution &&
          other.scannerChecks == this.scannerChecks &&
          other.priceDropsSeen == this.priceDropsSeen &&
          other.goodDealSeen == this.goodDealSeen &&
          other.visitedScreens == this.visitedScreens &&
          other.themeChanges == this.themeChanges &&
          other.aiQuestions == this.aiQuestions &&
          other.historyViewed30d == this.historyViewed30d &&
          other.installDate == this.installDate &&
          other.nickname == this.nickname &&
          other.avatarSeed == this.avatarSeed &&
          other.userId == this.userId &&
          other.email == this.email &&
          other.authed == this.authed &&
          other.registeredAt == this.registeredAt);
}

class UserStatsTableCompanion extends UpdateCompanion<UserStatsTableData> {
  final Value<String> id;
  final Value<int> totalXp;
  final Value<int> level;
  final Value<int> streakDays;
  final Value<String?> lastContributionDay;
  final Value<int> contributionsCount;
  final Value<int> maxSingleContribution;
  final Value<int> scannerChecks;
  final Value<int> priceDropsSeen;
  final Value<bool> goodDealSeen;
  final Value<String> visitedScreens;
  final Value<int> themeChanges;
  final Value<int> aiQuestions;
  final Value<bool> historyViewed30d;
  final Value<int> installDate;
  final Value<String> nickname;
  final Value<String> avatarSeed;
  final Value<String> userId;
  final Value<String?> email;
  final Value<bool> authed;
  final Value<int?> registeredAt;
  final Value<int> rowid;
  const UserStatsTableCompanion({
    this.id = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.lastContributionDay = const Value.absent(),
    this.contributionsCount = const Value.absent(),
    this.maxSingleContribution = const Value.absent(),
    this.scannerChecks = const Value.absent(),
    this.priceDropsSeen = const Value.absent(),
    this.goodDealSeen = const Value.absent(),
    this.visitedScreens = const Value.absent(),
    this.themeChanges = const Value.absent(),
    this.aiQuestions = const Value.absent(),
    this.historyViewed30d = const Value.absent(),
    this.installDate = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarSeed = const Value.absent(),
    this.userId = const Value.absent(),
    this.email = const Value.absent(),
    this.authed = const Value.absent(),
    this.registeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserStatsTableCompanion.insert({
    required String id,
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.lastContributionDay = const Value.absent(),
    this.contributionsCount = const Value.absent(),
    this.maxSingleContribution = const Value.absent(),
    this.scannerChecks = const Value.absent(),
    this.priceDropsSeen = const Value.absent(),
    this.goodDealSeen = const Value.absent(),
    this.visitedScreens = const Value.absent(),
    this.themeChanges = const Value.absent(),
    this.aiQuestions = const Value.absent(),
    this.historyViewed30d = const Value.absent(),
    required int installDate,
    this.nickname = const Value.absent(),
    this.avatarSeed = const Value.absent(),
    required String userId,
    this.email = const Value.absent(),
    this.authed = const Value.absent(),
    this.registeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        installDate = Value(installDate),
        userId = Value(userId);
  static Insertable<UserStatsTableData> custom({
    Expression<String>? id,
    Expression<int>? totalXp,
    Expression<int>? level,
    Expression<int>? streakDays,
    Expression<String>? lastContributionDay,
    Expression<int>? contributionsCount,
    Expression<int>? maxSingleContribution,
    Expression<int>? scannerChecks,
    Expression<int>? priceDropsSeen,
    Expression<bool>? goodDealSeen,
    Expression<String>? visitedScreens,
    Expression<int>? themeChanges,
    Expression<int>? aiQuestions,
    Expression<bool>? historyViewed30d,
    Expression<int>? installDate,
    Expression<String>? nickname,
    Expression<String>? avatarSeed,
    Expression<String>? userId,
    Expression<String>? email,
    Expression<bool>? authed,
    Expression<int>? registeredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalXp != null) 'total_xp': totalXp,
      if (level != null) 'level': level,
      if (streakDays != null) 'streak_days': streakDays,
      if (lastContributionDay != null)
        'last_contribution_day': lastContributionDay,
      if (contributionsCount != null) 'contributions_count': contributionsCount,
      if (maxSingleContribution != null)
        'max_single_contribution': maxSingleContribution,
      if (scannerChecks != null) 'scanner_checks': scannerChecks,
      if (priceDropsSeen != null) 'price_drops_seen': priceDropsSeen,
      if (goodDealSeen != null) 'good_deal_seen': goodDealSeen,
      if (visitedScreens != null) 'visited_screens': visitedScreens,
      if (themeChanges != null) 'theme_changes': themeChanges,
      if (aiQuestions != null) 'ai_questions': aiQuestions,
      if (historyViewed30d != null) 'history_viewed30d': historyViewed30d,
      if (installDate != null) 'install_date': installDate,
      if (nickname != null) 'nickname': nickname,
      if (avatarSeed != null) 'avatar_seed': avatarSeed,
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
      if (authed != null) 'authed': authed,
      if (registeredAt != null) 'registered_at': registeredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserStatsTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? totalXp,
      Value<int>? level,
      Value<int>? streakDays,
      Value<String?>? lastContributionDay,
      Value<int>? contributionsCount,
      Value<int>? maxSingleContribution,
      Value<int>? scannerChecks,
      Value<int>? priceDropsSeen,
      Value<bool>? goodDealSeen,
      Value<String>? visitedScreens,
      Value<int>? themeChanges,
      Value<int>? aiQuestions,
      Value<bool>? historyViewed30d,
      Value<int>? installDate,
      Value<String>? nickname,
      Value<String>? avatarSeed,
      Value<String>? userId,
      Value<String?>? email,
      Value<bool>? authed,
      Value<int?>? registeredAt,
      Value<int>? rowid}) {
    return UserStatsTableCompanion(
      id: id ?? this.id,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      lastContributionDay: lastContributionDay ?? this.lastContributionDay,
      contributionsCount: contributionsCount ?? this.contributionsCount,
      maxSingleContribution:
          maxSingleContribution ?? this.maxSingleContribution,
      scannerChecks: scannerChecks ?? this.scannerChecks,
      priceDropsSeen: priceDropsSeen ?? this.priceDropsSeen,
      goodDealSeen: goodDealSeen ?? this.goodDealSeen,
      visitedScreens: visitedScreens ?? this.visitedScreens,
      themeChanges: themeChanges ?? this.themeChanges,
      aiQuestions: aiQuestions ?? this.aiQuestions,
      historyViewed30d: historyViewed30d ?? this.historyViewed30d,
      installDate: installDate ?? this.installDate,
      nickname: nickname ?? this.nickname,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      authed: authed ?? this.authed,
      registeredAt: registeredAt ?? this.registeredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (lastContributionDay.present) {
      map['last_contribution_day'] =
          Variable<String>(lastContributionDay.value);
    }
    if (contributionsCount.present) {
      map['contributions_count'] = Variable<int>(contributionsCount.value);
    }
    if (maxSingleContribution.present) {
      map['max_single_contribution'] =
          Variable<int>(maxSingleContribution.value);
    }
    if (scannerChecks.present) {
      map['scanner_checks'] = Variable<int>(scannerChecks.value);
    }
    if (priceDropsSeen.present) {
      map['price_drops_seen'] = Variable<int>(priceDropsSeen.value);
    }
    if (goodDealSeen.present) {
      map['good_deal_seen'] = Variable<bool>(goodDealSeen.value);
    }
    if (visitedScreens.present) {
      map['visited_screens'] = Variable<String>(visitedScreens.value);
    }
    if (themeChanges.present) {
      map['theme_changes'] = Variable<int>(themeChanges.value);
    }
    if (aiQuestions.present) {
      map['ai_questions'] = Variable<int>(aiQuestions.value);
    }
    if (historyViewed30d.present) {
      map['history_viewed30d'] = Variable<bool>(historyViewed30d.value);
    }
    if (installDate.present) {
      map['install_date'] = Variable<int>(installDate.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarSeed.present) {
      map['avatar_seed'] = Variable<String>(avatarSeed.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (authed.present) {
      map['authed'] = Variable<bool>(authed.value);
    }
    if (registeredAt.present) {
      map['registered_at'] = Variable<int>(registeredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableCompanion(')
          ..write('id: $id, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('streakDays: $streakDays, ')
          ..write('lastContributionDay: $lastContributionDay, ')
          ..write('contributionsCount: $contributionsCount, ')
          ..write('maxSingleContribution: $maxSingleContribution, ')
          ..write('scannerChecks: $scannerChecks, ')
          ..write('priceDropsSeen: $priceDropsSeen, ')
          ..write('goodDealSeen: $goodDealSeen, ')
          ..write('visitedScreens: $visitedScreens, ')
          ..write('themeChanges: $themeChanges, ')
          ..write('aiQuestions: $aiQuestions, ')
          ..write('historyViewed30d: $historyViewed30d, ')
          ..write('installDate: $installDate, ')
          ..write('nickname: $nickname, ')
          ..write('avatarSeed: $avatarSeed, ')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('authed: $authed, ')
          ..write('registeredAt: $registeredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromFallbackMeta =
      const VerificationMeta('fromFallback');
  @override
  late final GeneratedColumn<bool> fromFallback = GeneratedColumn<bool>(
      'from_fallback', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("from_fallback" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, role, mode, content, createdAt, fromFallback, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('from_fallback')) {
      context.handle(
          _fromFallbackMeta,
          fromFallback.isAcceptableOrUnknown(
              data['from_fallback']!, _fromFallbackMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      fromFallback: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}from_fallback'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final String id;
  final String role;
  final String mode;
  final String content;
  final int createdAt;
  final bool fromFallback;
  final bool synced;
  const ChatMessage(
      {required this.id,
      required this.role,
      required this.mode,
      required this.content,
      required this.createdAt,
      required this.fromFallback,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['role'] = Variable<String>(role);
    map['mode'] = Variable<String>(mode);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<int>(createdAt);
    map['from_fallback'] = Variable<bool>(fromFallback);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      role: Value(role),
      mode: Value(mode),
      content: Value(content),
      createdAt: Value(createdAt),
      fromFallback: Value(fromFallback),
      synced: Value(synced),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      mode: serializer.fromJson<String>(json['mode']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      fromFallback: serializer.fromJson<bool>(json['fromFallback']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'mode': serializer.toJson<String>(mode),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<int>(createdAt),
      'fromFallback': serializer.toJson<bool>(fromFallback),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ChatMessage copyWith(
          {String? id,
          String? role,
          String? mode,
          String? content,
          int? createdAt,
          bool? fromFallback,
          bool? synced}) =>
      ChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        mode: mode ?? this.mode,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        fromFallback: fromFallback ?? this.fromFallback,
        synced: synced ?? this.synced,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      mode: data.mode.present ? data.mode.value : this.mode,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      fromFallback: data.fromFallback.present
          ? data.fromFallback.value
          : this.fromFallback,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('mode: $mode, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('fromFallback: $fromFallback, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, role, mode, content, createdAt, fromFallback, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.role == this.role &&
          other.mode == this.mode &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.fromFallback == this.fromFallback &&
          other.synced == this.synced);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<String> id;
  final Value<String> role;
  final Value<String> mode;
  final Value<String> content;
  final Value<int> createdAt;
  final Value<bool> fromFallback;
  final Value<bool> synced;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.mode = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.fromFallback = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String role,
    required String mode,
    required String content,
    required int createdAt,
    this.fromFallback = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        role = Value(role),
        mode = Value(mode),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<ChatMessage> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? mode,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<bool>? fromFallback,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (mode != null) 'mode': mode,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (fromFallback != null) 'from_fallback': fromFallback,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? role,
      Value<String>? mode,
      Value<String>? content,
      Value<int>? createdAt,
      Value<bool>? fromFallback,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      mode: mode ?? this.mode,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      fromFallback: fromFallback ?? this.fromFallback,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (fromFallback.present) {
      map['from_fallback'] = Variable<bool>(fromFallback.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('mode: $mode, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('fromFallback: $fromFallback, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceHistoryTable extends PriceHistory
    with TableInfo<$PriceHistoryTable, PriceHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storeIdMeta =
      const VerificationMeta('storeId');
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
      'store_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productMeta =
      const VerificationMeta('product');
  @override
  late final GeneratedColumn<String> product = GeneratedColumn<String>(
      'product', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
      'price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _urlVerifiedMeta =
      const VerificationMeta('urlVerified');
  @override
  late final GeneratedColumn<bool> urlVerified = GeneratedColumn<bool>(
      'url_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("url_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _checkedAtMeta =
      const VerificationMeta('checkedAt');
  @override
  late final GeneratedColumn<int> checkedAt = GeneratedColumn<int>(
      'checked_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _availabilityMeta =
      const VerificationMeta('availability');
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
      'availability', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _warrantyMonthsMeta =
      const VerificationMeta('warrantyMonths');
  @override
  late final GeneratedColumn<int> warrantyMonths = GeneratedColumn<int>(
      'warranty_months', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(12));
  static const VerificationMeta _returnDaysMeta =
      const VerificationMeta('returnDays');
  @override
  late final GeneratedColumn<int> returnDays = GeneratedColumn<int>(
      'return_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(14));
  static const VerificationMeta _kitMeta = const VerificationMeta('kit');
  @override
  late final GeneratedColumn<String> kit = GeneratedColumn<String>(
      'kit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('full'));
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('new'));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('server_scrape'));
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deliveryCostMeta =
      const VerificationMeta('deliveryCost');
  @override
  late final GeneratedColumn<int> deliveryCost = GeneratedColumn<int>(
      'delivery_cost', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _otherCostsMeta =
      const VerificationMeta('otherCosts');
  @override
  late final GeneratedColumn<int> otherCosts = GeneratedColumn<int>(
      'other_costs', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isSeedMeta = const VerificationMeta('isSeed');
  @override
  late final GeneratedColumn<bool> isSeed = GeneratedColumn<bool>(
      'is_seed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_seed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        storeId,
        product,
        price,
        url,
        urlVerified,
        checkedAt,
        availability,
        warrantyMonths,
        returnDays,
        kit,
        state,
        source,
        city,
        deliveryCost,
        otherCosts,
        isSeed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_history';
  @override
  VerificationContext validateIntegrity(Insertable<PriceHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(_storeIdMeta,
          storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta));
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('product')) {
      context.handle(_productMeta,
          product.isAcceptableOrUnknown(data['product']!, _productMeta));
    } else if (isInserting) {
      context.missing(_productMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('url_verified')) {
      context.handle(
          _urlVerifiedMeta,
          urlVerified.isAcceptableOrUnknown(
              data['url_verified']!, _urlVerifiedMeta));
    }
    if (data.containsKey('checked_at')) {
      context.handle(_checkedAtMeta,
          checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta));
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    if (data.containsKey('availability')) {
      context.handle(
          _availabilityMeta,
          availability.isAcceptableOrUnknown(
              data['availability']!, _availabilityMeta));
    } else if (isInserting) {
      context.missing(_availabilityMeta);
    }
    if (data.containsKey('warranty_months')) {
      context.handle(
          _warrantyMonthsMeta,
          warrantyMonths.isAcceptableOrUnknown(
              data['warranty_months']!, _warrantyMonthsMeta));
    }
    if (data.containsKey('return_days')) {
      context.handle(
          _returnDaysMeta,
          returnDays.isAcceptableOrUnknown(
              data['return_days']!, _returnDaysMeta));
    }
    if (data.containsKey('kit')) {
      context.handle(
          _kitMeta, kit.isAcceptableOrUnknown(data['kit']!, _kitMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('delivery_cost')) {
      context.handle(
          _deliveryCostMeta,
          deliveryCost.isAcceptableOrUnknown(
              data['delivery_cost']!, _deliveryCostMeta));
    }
    if (data.containsKey('other_costs')) {
      context.handle(
          _otherCostsMeta,
          otherCosts.isAcceptableOrUnknown(
              data['other_costs']!, _otherCostsMeta));
    }
    if (data.containsKey('is_seed')) {
      context.handle(_isSeedMeta,
          isSeed.isAcceptableOrUnknown(data['is_seed']!, _isSeedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_id'])!,
      product: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      urlVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}url_verified'])!,
      checkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}checked_at'])!,
      availability: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}availability'])!,
      warrantyMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warranty_months'])!,
      returnDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}return_days'])!,
      kit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kit'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      deliveryCost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delivery_cost'])!,
      otherCosts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}other_costs'])!,
      isSeed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_seed'])!,
    );
  }

  @override
  $PriceHistoryTable createAlias(String alias) {
    return $PriceHistoryTable(attachedDatabase, alias);
  }
}

class PriceHistoryData extends DataClass
    implements Insertable<PriceHistoryData> {
  final String id;
  final String storeId;
  final String product;
  final int price;
  final String url;
  final bool urlVerified;
  final int checkedAt;
  final String availability;
  final int warrantyMonths;
  final int returnDays;
  final String kit;
  final String state;
  final String source;
  final String? city;
  final int deliveryCost;
  final int otherCosts;
  final bool isSeed;
  const PriceHistoryData(
      {required this.id,
      required this.storeId,
      required this.product,
      required this.price,
      required this.url,
      required this.urlVerified,
      required this.checkedAt,
      required this.availability,
      required this.warrantyMonths,
      required this.returnDays,
      required this.kit,
      required this.state,
      required this.source,
      this.city,
      required this.deliveryCost,
      required this.otherCosts,
      required this.isSeed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['product'] = Variable<String>(product);
    map['price'] = Variable<int>(price);
    map['url'] = Variable<String>(url);
    map['url_verified'] = Variable<bool>(urlVerified);
    map['checked_at'] = Variable<int>(checkedAt);
    map['availability'] = Variable<String>(availability);
    map['warranty_months'] = Variable<int>(warrantyMonths);
    map['return_days'] = Variable<int>(returnDays);
    map['kit'] = Variable<String>(kit);
    map['state'] = Variable<String>(state);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    map['delivery_cost'] = Variable<int>(deliveryCost);
    map['other_costs'] = Variable<int>(otherCosts);
    map['is_seed'] = Variable<bool>(isSeed);
    return map;
  }

  PriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return PriceHistoryCompanion(
      id: Value(id),
      storeId: Value(storeId),
      product: Value(product),
      price: Value(price),
      url: Value(url),
      urlVerified: Value(urlVerified),
      checkedAt: Value(checkedAt),
      availability: Value(availability),
      warrantyMonths: Value(warrantyMonths),
      returnDays: Value(returnDays),
      kit: Value(kit),
      state: Value(state),
      source: Value(source),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      deliveryCost: Value(deliveryCost),
      otherCosts: Value(otherCosts),
      isSeed: Value(isSeed),
    );
  }

  factory PriceHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceHistoryData(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      product: serializer.fromJson<String>(json['product']),
      price: serializer.fromJson<int>(json['price']),
      url: serializer.fromJson<String>(json['url']),
      urlVerified: serializer.fromJson<bool>(json['urlVerified']),
      checkedAt: serializer.fromJson<int>(json['checkedAt']),
      availability: serializer.fromJson<String>(json['availability']),
      warrantyMonths: serializer.fromJson<int>(json['warrantyMonths']),
      returnDays: serializer.fromJson<int>(json['returnDays']),
      kit: serializer.fromJson<String>(json['kit']),
      state: serializer.fromJson<String>(json['state']),
      source: serializer.fromJson<String>(json['source']),
      city: serializer.fromJson<String?>(json['city']),
      deliveryCost: serializer.fromJson<int>(json['deliveryCost']),
      otherCosts: serializer.fromJson<int>(json['otherCosts']),
      isSeed: serializer.fromJson<bool>(json['isSeed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'product': serializer.toJson<String>(product),
      'price': serializer.toJson<int>(price),
      'url': serializer.toJson<String>(url),
      'urlVerified': serializer.toJson<bool>(urlVerified),
      'checkedAt': serializer.toJson<int>(checkedAt),
      'availability': serializer.toJson<String>(availability),
      'warrantyMonths': serializer.toJson<int>(warrantyMonths),
      'returnDays': serializer.toJson<int>(returnDays),
      'kit': serializer.toJson<String>(kit),
      'state': serializer.toJson<String>(state),
      'source': serializer.toJson<String>(source),
      'city': serializer.toJson<String?>(city),
      'deliveryCost': serializer.toJson<int>(deliveryCost),
      'otherCosts': serializer.toJson<int>(otherCosts),
      'isSeed': serializer.toJson<bool>(isSeed),
    };
  }

  PriceHistoryData copyWith(
          {String? id,
          String? storeId,
          String? product,
          int? price,
          String? url,
          bool? urlVerified,
          int? checkedAt,
          String? availability,
          int? warrantyMonths,
          int? returnDays,
          String? kit,
          String? state,
          String? source,
          Value<String?> city = const Value.absent(),
          int? deliveryCost,
          int? otherCosts,
          bool? isSeed}) =>
      PriceHistoryData(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        product: product ?? this.product,
        price: price ?? this.price,
        url: url ?? this.url,
        urlVerified: urlVerified ?? this.urlVerified,
        checkedAt: checkedAt ?? this.checkedAt,
        availability: availability ?? this.availability,
        warrantyMonths: warrantyMonths ?? this.warrantyMonths,
        returnDays: returnDays ?? this.returnDays,
        kit: kit ?? this.kit,
        state: state ?? this.state,
        source: source ?? this.source,
        city: city.present ? city.value : this.city,
        deliveryCost: deliveryCost ?? this.deliveryCost,
        otherCosts: otherCosts ?? this.otherCosts,
        isSeed: isSeed ?? this.isSeed,
      );
  PriceHistoryData copyWithCompanion(PriceHistoryCompanion data) {
    return PriceHistoryData(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      product: data.product.present ? data.product.value : this.product,
      price: data.price.present ? data.price.value : this.price,
      url: data.url.present ? data.url.value : this.url,
      urlVerified:
          data.urlVerified.present ? data.urlVerified.value : this.urlVerified,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      warrantyMonths: data.warrantyMonths.present
          ? data.warrantyMonths.value
          : this.warrantyMonths,
      returnDays:
          data.returnDays.present ? data.returnDays.value : this.returnDays,
      kit: data.kit.present ? data.kit.value : this.kit,
      state: data.state.present ? data.state.value : this.state,
      source: data.source.present ? data.source.value : this.source,
      city: data.city.present ? data.city.value : this.city,
      deliveryCost: data.deliveryCost.present
          ? data.deliveryCost.value
          : this.deliveryCost,
      otherCosts:
          data.otherCosts.present ? data.otherCosts.value : this.otherCosts,
      isSeed: data.isSeed.present ? data.isSeed.value : this.isSeed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryData(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('product: $product, ')
          ..write('price: $price, ')
          ..write('url: $url, ')
          ..write('urlVerified: $urlVerified, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('availability: $availability, ')
          ..write('warrantyMonths: $warrantyMonths, ')
          ..write('returnDays: $returnDays, ')
          ..write('kit: $kit, ')
          ..write('state: $state, ')
          ..write('source: $source, ')
          ..write('city: $city, ')
          ..write('deliveryCost: $deliveryCost, ')
          ..write('otherCosts: $otherCosts, ')
          ..write('isSeed: $isSeed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      storeId,
      product,
      price,
      url,
      urlVerified,
      checkedAt,
      availability,
      warrantyMonths,
      returnDays,
      kit,
      state,
      source,
      city,
      deliveryCost,
      otherCosts,
      isSeed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceHistoryData &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.product == this.product &&
          other.price == this.price &&
          other.url == this.url &&
          other.urlVerified == this.urlVerified &&
          other.checkedAt == this.checkedAt &&
          other.availability == this.availability &&
          other.warrantyMonths == this.warrantyMonths &&
          other.returnDays == this.returnDays &&
          other.kit == this.kit &&
          other.state == this.state &&
          other.source == this.source &&
          other.city == this.city &&
          other.deliveryCost == this.deliveryCost &&
          other.otherCosts == this.otherCosts &&
          other.isSeed == this.isSeed);
}

class PriceHistoryCompanion extends UpdateCompanion<PriceHistoryData> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> product;
  final Value<int> price;
  final Value<String> url;
  final Value<bool> urlVerified;
  final Value<int> checkedAt;
  final Value<String> availability;
  final Value<int> warrantyMonths;
  final Value<int> returnDays;
  final Value<String> kit;
  final Value<String> state;
  final Value<String> source;
  final Value<String?> city;
  final Value<int> deliveryCost;
  final Value<int> otherCosts;
  final Value<bool> isSeed;
  final Value<int> rowid;
  const PriceHistoryCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.product = const Value.absent(),
    this.price = const Value.absent(),
    this.url = const Value.absent(),
    this.urlVerified = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.availability = const Value.absent(),
    this.warrantyMonths = const Value.absent(),
    this.returnDays = const Value.absent(),
    this.kit = const Value.absent(),
    this.state = const Value.absent(),
    this.source = const Value.absent(),
    this.city = const Value.absent(),
    this.deliveryCost = const Value.absent(),
    this.otherCosts = const Value.absent(),
    this.isSeed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceHistoryCompanion.insert({
    required String id,
    required String storeId,
    required String product,
    required int price,
    this.url = const Value.absent(),
    this.urlVerified = const Value.absent(),
    required int checkedAt,
    required String availability,
    this.warrantyMonths = const Value.absent(),
    this.returnDays = const Value.absent(),
    this.kit = const Value.absent(),
    this.state = const Value.absent(),
    this.source = const Value.absent(),
    this.city = const Value.absent(),
    this.deliveryCost = const Value.absent(),
    this.otherCosts = const Value.absent(),
    this.isSeed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storeId = Value(storeId),
        product = Value(product),
        price = Value(price),
        checkedAt = Value(checkedAt),
        availability = Value(availability);
  static Insertable<PriceHistoryData> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? product,
    Expression<int>? price,
    Expression<String>? url,
    Expression<bool>? urlVerified,
    Expression<int>? checkedAt,
    Expression<String>? availability,
    Expression<int>? warrantyMonths,
    Expression<int>? returnDays,
    Expression<String>? kit,
    Expression<String>? state,
    Expression<String>? source,
    Expression<String>? city,
    Expression<int>? deliveryCost,
    Expression<int>? otherCosts,
    Expression<bool>? isSeed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (product != null) 'product': product,
      if (price != null) 'price': price,
      if (url != null) 'url': url,
      if (urlVerified != null) 'url_verified': urlVerified,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (availability != null) 'availability': availability,
      if (warrantyMonths != null) 'warranty_months': warrantyMonths,
      if (returnDays != null) 'return_days': returnDays,
      if (kit != null) 'kit': kit,
      if (state != null) 'state': state,
      if (source != null) 'source': source,
      if (city != null) 'city': city,
      if (deliveryCost != null) 'delivery_cost': deliveryCost,
      if (otherCosts != null) 'other_costs': otherCosts,
      if (isSeed != null) 'is_seed': isSeed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? storeId,
      Value<String>? product,
      Value<int>? price,
      Value<String>? url,
      Value<bool>? urlVerified,
      Value<int>? checkedAt,
      Value<String>? availability,
      Value<int>? warrantyMonths,
      Value<int>? returnDays,
      Value<String>? kit,
      Value<String>? state,
      Value<String>? source,
      Value<String?>? city,
      Value<int>? deliveryCost,
      Value<int>? otherCosts,
      Value<bool>? isSeed,
      Value<int>? rowid}) {
    return PriceHistoryCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      product: product ?? this.product,
      price: price ?? this.price,
      url: url ?? this.url,
      urlVerified: urlVerified ?? this.urlVerified,
      checkedAt: checkedAt ?? this.checkedAt,
      availability: availability ?? this.availability,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      returnDays: returnDays ?? this.returnDays,
      kit: kit ?? this.kit,
      state: state ?? this.state,
      source: source ?? this.source,
      city: city ?? this.city,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      otherCosts: otherCosts ?? this.otherCosts,
      isSeed: isSeed ?? this.isSeed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (product.present) {
      map['product'] = Variable<String>(product.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (urlVerified.present) {
      map['url_verified'] = Variable<bool>(urlVerified.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<int>(checkedAt.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (warrantyMonths.present) {
      map['warranty_months'] = Variable<int>(warrantyMonths.value);
    }
    if (returnDays.present) {
      map['return_days'] = Variable<int>(returnDays.value);
    }
    if (kit.present) {
      map['kit'] = Variable<String>(kit.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (deliveryCost.present) {
      map['delivery_cost'] = Variable<int>(deliveryCost.value);
    }
    if (otherCosts.present) {
      map['other_costs'] = Variable<int>(otherCosts.value);
    }
    if (isSeed.present) {
      map['is_seed'] = Variable<bool>(isSeed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('product: $product, ')
          ..write('price: $price, ')
          ..write('url: $url, ')
          ..write('urlVerified: $urlVerified, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('availability: $availability, ')
          ..write('warrantyMonths: $warrantyMonths, ')
          ..write('returnDays: $returnDays, ')
          ..write('kit: $kit, ')
          ..write('state: $state, ')
          ..write('source: $source, ')
          ..write('city: $city, ')
          ..write('deliveryCost: $deliveryCost, ')
          ..write('otherCosts: $otherCosts, ')
          ..write('isSeed: $isSeed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanRunsTable extends ScanRuns with TableInfo<$ScanRunsTable, ScanRun> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productMeta =
      const VerificationMeta('product');
  @override
  late final GeneratedColumn<String> product = GeneratedColumn<String>(
      'product', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scannedAtMeta =
      const VerificationMeta('scannedAt');
  @override
  late final GeneratedColumn<int> scannedAt = GeneratedColumn<int>(
      'scanned_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lowestPriceMeta =
      const VerificationMeta('lowestPrice');
  @override
  late final GeneratedColumn<int> lowestPrice = GeneratedColumn<int>(
      'lowest_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _averagePriceMeta =
      const VerificationMeta('averagePrice');
  @override
  late final GeneratedColumn<int> averagePrice = GeneratedColumn<int>(
      'average_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avg30dPriceMeta =
      const VerificationMeta('avg30dPrice');
  @override
  late final GeneratedColumn<int> avg30dPrice = GeneratedColumn<int>(
      'avg30d_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changePercentMeta =
      const VerificationMeta('changePercent');
  @override
  late final GeneratedColumn<double> changePercent = GeneratedColumn<double>(
      'change_percent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _changeDirMeta =
      const VerificationMeta('changeDir');
  @override
  late final GeneratedColumn<String> changeDir = GeneratedColumn<String>(
      'change_dir', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('flat'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        product,
        scannedAt,
        lowestPrice,
        averagePrice,
        avg30dPrice,
        changePercent,
        changeDir
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_runs';
  @override
  VerificationContext validateIntegrity(Insertable<ScanRun> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product')) {
      context.handle(_productMeta,
          product.isAcceptableOrUnknown(data['product']!, _productMeta));
    } else if (isInserting) {
      context.missing(_productMeta);
    }
    if (data.containsKey('scanned_at')) {
      context.handle(_scannedAtMeta,
          scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta));
    } else if (isInserting) {
      context.missing(_scannedAtMeta);
    }
    if (data.containsKey('lowest_price')) {
      context.handle(
          _lowestPriceMeta,
          lowestPrice.isAcceptableOrUnknown(
              data['lowest_price']!, _lowestPriceMeta));
    } else if (isInserting) {
      context.missing(_lowestPriceMeta);
    }
    if (data.containsKey('average_price')) {
      context.handle(
          _averagePriceMeta,
          averagePrice.isAcceptableOrUnknown(
              data['average_price']!, _averagePriceMeta));
    } else if (isInserting) {
      context.missing(_averagePriceMeta);
    }
    if (data.containsKey('avg30d_price')) {
      context.handle(
          _avg30dPriceMeta,
          avg30dPrice.isAcceptableOrUnknown(
              data['avg30d_price']!, _avg30dPriceMeta));
    } else if (isInserting) {
      context.missing(_avg30dPriceMeta);
    }
    if (data.containsKey('change_percent')) {
      context.handle(
          _changePercentMeta,
          changePercent.isAcceptableOrUnknown(
              data['change_percent']!, _changePercentMeta));
    }
    if (data.containsKey('change_dir')) {
      context.handle(_changeDirMeta,
          changeDir.isAcceptableOrUnknown(data['change_dir']!, _changeDirMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanRun map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanRun(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      product: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product'])!,
      scannedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scanned_at'])!,
      lowestPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lowest_price'])!,
      averagePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}average_price'])!,
      avg30dPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avg30d_price'])!,
      changePercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_percent'])!,
      changeDir: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_dir'])!,
    );
  }

  @override
  $ScanRunsTable createAlias(String alias) {
    return $ScanRunsTable(attachedDatabase, alias);
  }
}

class ScanRun extends DataClass implements Insertable<ScanRun> {
  final int id;
  final String product;
  final int scannedAt;
  final int lowestPrice;
  final int averagePrice;
  final int avg30dPrice;
  final double changePercent;
  final String changeDir;
  const ScanRun(
      {required this.id,
      required this.product,
      required this.scannedAt,
      required this.lowestPrice,
      required this.averagePrice,
      required this.avg30dPrice,
      required this.changePercent,
      required this.changeDir});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product'] = Variable<String>(product);
    map['scanned_at'] = Variable<int>(scannedAt);
    map['lowest_price'] = Variable<int>(lowestPrice);
    map['average_price'] = Variable<int>(averagePrice);
    map['avg30d_price'] = Variable<int>(avg30dPrice);
    map['change_percent'] = Variable<double>(changePercent);
    map['change_dir'] = Variable<String>(changeDir);
    return map;
  }

  ScanRunsCompanion toCompanion(bool nullToAbsent) {
    return ScanRunsCompanion(
      id: Value(id),
      product: Value(product),
      scannedAt: Value(scannedAt),
      lowestPrice: Value(lowestPrice),
      averagePrice: Value(averagePrice),
      avg30dPrice: Value(avg30dPrice),
      changePercent: Value(changePercent),
      changeDir: Value(changeDir),
    );
  }

  factory ScanRun.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanRun(
      id: serializer.fromJson<int>(json['id']),
      product: serializer.fromJson<String>(json['product']),
      scannedAt: serializer.fromJson<int>(json['scannedAt']),
      lowestPrice: serializer.fromJson<int>(json['lowestPrice']),
      averagePrice: serializer.fromJson<int>(json['averagePrice']),
      avg30dPrice: serializer.fromJson<int>(json['avg30dPrice']),
      changePercent: serializer.fromJson<double>(json['changePercent']),
      changeDir: serializer.fromJson<String>(json['changeDir']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'product': serializer.toJson<String>(product),
      'scannedAt': serializer.toJson<int>(scannedAt),
      'lowestPrice': serializer.toJson<int>(lowestPrice),
      'averagePrice': serializer.toJson<int>(averagePrice),
      'avg30dPrice': serializer.toJson<int>(avg30dPrice),
      'changePercent': serializer.toJson<double>(changePercent),
      'changeDir': serializer.toJson<String>(changeDir),
    };
  }

  ScanRun copyWith(
          {int? id,
          String? product,
          int? scannedAt,
          int? lowestPrice,
          int? averagePrice,
          int? avg30dPrice,
          double? changePercent,
          String? changeDir}) =>
      ScanRun(
        id: id ?? this.id,
        product: product ?? this.product,
        scannedAt: scannedAt ?? this.scannedAt,
        lowestPrice: lowestPrice ?? this.lowestPrice,
        averagePrice: averagePrice ?? this.averagePrice,
        avg30dPrice: avg30dPrice ?? this.avg30dPrice,
        changePercent: changePercent ?? this.changePercent,
        changeDir: changeDir ?? this.changeDir,
      );
  ScanRun copyWithCompanion(ScanRunsCompanion data) {
    return ScanRun(
      id: data.id.present ? data.id.value : this.id,
      product: data.product.present ? data.product.value : this.product,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
      lowestPrice:
          data.lowestPrice.present ? data.lowestPrice.value : this.lowestPrice,
      averagePrice: data.averagePrice.present
          ? data.averagePrice.value
          : this.averagePrice,
      avg30dPrice:
          data.avg30dPrice.present ? data.avg30dPrice.value : this.avg30dPrice,
      changePercent: data.changePercent.present
          ? data.changePercent.value
          : this.changePercent,
      changeDir: data.changeDir.present ? data.changeDir.value : this.changeDir,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanRun(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('lowestPrice: $lowestPrice, ')
          ..write('averagePrice: $averagePrice, ')
          ..write('avg30dPrice: $avg30dPrice, ')
          ..write('changePercent: $changePercent, ')
          ..write('changeDir: $changeDir')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, product, scannedAt, lowestPrice,
      averagePrice, avg30dPrice, changePercent, changeDir);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanRun &&
          other.id == this.id &&
          other.product == this.product &&
          other.scannedAt == this.scannedAt &&
          other.lowestPrice == this.lowestPrice &&
          other.averagePrice == this.averagePrice &&
          other.avg30dPrice == this.avg30dPrice &&
          other.changePercent == this.changePercent &&
          other.changeDir == this.changeDir);
}

class ScanRunsCompanion extends UpdateCompanion<ScanRun> {
  final Value<int> id;
  final Value<String> product;
  final Value<int> scannedAt;
  final Value<int> lowestPrice;
  final Value<int> averagePrice;
  final Value<int> avg30dPrice;
  final Value<double> changePercent;
  final Value<String> changeDir;
  const ScanRunsCompanion({
    this.id = const Value.absent(),
    this.product = const Value.absent(),
    this.scannedAt = const Value.absent(),
    this.lowestPrice = const Value.absent(),
    this.averagePrice = const Value.absent(),
    this.avg30dPrice = const Value.absent(),
    this.changePercent = const Value.absent(),
    this.changeDir = const Value.absent(),
  });
  ScanRunsCompanion.insert({
    this.id = const Value.absent(),
    required String product,
    required int scannedAt,
    required int lowestPrice,
    required int averagePrice,
    required int avg30dPrice,
    this.changePercent = const Value.absent(),
    this.changeDir = const Value.absent(),
  })  : product = Value(product),
        scannedAt = Value(scannedAt),
        lowestPrice = Value(lowestPrice),
        averagePrice = Value(averagePrice),
        avg30dPrice = Value(avg30dPrice);
  static Insertable<ScanRun> custom({
    Expression<int>? id,
    Expression<String>? product,
    Expression<int>? scannedAt,
    Expression<int>? lowestPrice,
    Expression<int>? averagePrice,
    Expression<int>? avg30dPrice,
    Expression<double>? changePercent,
    Expression<String>? changeDir,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (product != null) 'product': product,
      if (scannedAt != null) 'scanned_at': scannedAt,
      if (lowestPrice != null) 'lowest_price': lowestPrice,
      if (averagePrice != null) 'average_price': averagePrice,
      if (avg30dPrice != null) 'avg30d_price': avg30dPrice,
      if (changePercent != null) 'change_percent': changePercent,
      if (changeDir != null) 'change_dir': changeDir,
    });
  }

  ScanRunsCompanion copyWith(
      {Value<int>? id,
      Value<String>? product,
      Value<int>? scannedAt,
      Value<int>? lowestPrice,
      Value<int>? averagePrice,
      Value<int>? avg30dPrice,
      Value<double>? changePercent,
      Value<String>? changeDir}) {
    return ScanRunsCompanion(
      id: id ?? this.id,
      product: product ?? this.product,
      scannedAt: scannedAt ?? this.scannedAt,
      lowestPrice: lowestPrice ?? this.lowestPrice,
      averagePrice: averagePrice ?? this.averagePrice,
      avg30dPrice: avg30dPrice ?? this.avg30dPrice,
      changePercent: changePercent ?? this.changePercent,
      changeDir: changeDir ?? this.changeDir,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (product.present) {
      map['product'] = Variable<String>(product.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<int>(scannedAt.value);
    }
    if (lowestPrice.present) {
      map['lowest_price'] = Variable<int>(lowestPrice.value);
    }
    if (averagePrice.present) {
      map['average_price'] = Variable<int>(averagePrice.value);
    }
    if (avg30dPrice.present) {
      map['avg30d_price'] = Variable<int>(avg30dPrice.value);
    }
    if (changePercent.present) {
      map['change_percent'] = Variable<double>(changePercent.value);
    }
    if (changeDir.present) {
      map['change_dir'] = Variable<String>(changeDir.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanRunsCompanion(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('lowestPrice: $lowestPrice, ')
          ..write('averagePrice: $averagePrice, ')
          ..write('avg30dPrice: $avg30dPrice, ')
          ..write('changePercent: $changePercent, ')
          ..write('changeDir: $changeDir')
          ..write(')'))
        .toString();
  }
}

class $MonitorSpecsTable extends MonitorSpecs
    with TableInfo<$MonitorSpecsTable, MonitorSpec> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonitorSpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _priceIdMeta =
      const VerificationMeta('priceId');
  @override
  late final GeneratedColumn<String> priceId = GeneratedColumn<String>(
      'price_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diagonalMeta =
      const VerificationMeta('diagonal');
  @override
  late final GeneratedColumn<double> diagonal = GeneratedColumn<double>(
      'diagonal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refreshHzMeta =
      const VerificationMeta('refreshHz');
  @override
  late final GeneratedColumn<int> refreshHz = GeneratedColumn<int>(
      'refresh_hz', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hdmiVersionMeta =
      const VerificationMeta('hdmiVersion');
  @override
  late final GeneratedColumn<int> hdmiVersion = GeneratedColumn<int>(
      'hdmi_version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vrrMeta = const VerificationMeta('vrr');
  @override
  late final GeneratedColumn<bool> vrr = GeneratedColumn<bool>(
      'vrr', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("vrr" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _hdrMeta = const VerificationMeta('hdr');
  @override
  late final GeneratedColumn<String> hdr = GeneratedColumn<String>(
      'hdr', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hdr10'));
  static const VerificationMeta _allmMeta = const VerificationMeta('allm');
  @override
  late final GeneratedColumn<bool> allm = GeneratedColumn<bool>(
      'allm', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("allm" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _vesaMeta = const VerificationMeta('vesa');
  @override
  late final GeneratedColumn<String> vesa = GeneratedColumn<String>(
      'vesa', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('100x100'));
  @override
  List<GeneratedColumn> get $columns => [
        priceId,
        model,
        diagonal,
        resolution,
        refreshHz,
        hdmiVersion,
        vrr,
        hdr,
        allm,
        vesa
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monitor_specs';
  @override
  VerificationContext validateIntegrity(Insertable<MonitorSpec> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('price_id')) {
      context.handle(_priceIdMeta,
          priceId.isAcceptableOrUnknown(data['price_id']!, _priceIdMeta));
    } else if (isInserting) {
      context.missing(_priceIdMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('diagonal')) {
      context.handle(_diagonalMeta,
          diagonal.isAcceptableOrUnknown(data['diagonal']!, _diagonalMeta));
    } else if (isInserting) {
      context.missing(_diagonalMeta);
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    } else if (isInserting) {
      context.missing(_resolutionMeta);
    }
    if (data.containsKey('refresh_hz')) {
      context.handle(_refreshHzMeta,
          refreshHz.isAcceptableOrUnknown(data['refresh_hz']!, _refreshHzMeta));
    } else if (isInserting) {
      context.missing(_refreshHzMeta);
    }
    if (data.containsKey('hdmi_version')) {
      context.handle(
          _hdmiVersionMeta,
          hdmiVersion.isAcceptableOrUnknown(
              data['hdmi_version']!, _hdmiVersionMeta));
    } else if (isInserting) {
      context.missing(_hdmiVersionMeta);
    }
    if (data.containsKey('vrr')) {
      context.handle(
          _vrrMeta, vrr.isAcceptableOrUnknown(data['vrr']!, _vrrMeta));
    }
    if (data.containsKey('hdr')) {
      context.handle(
          _hdrMeta, hdr.isAcceptableOrUnknown(data['hdr']!, _hdrMeta));
    }
    if (data.containsKey('allm')) {
      context.handle(
          _allmMeta, allm.isAcceptableOrUnknown(data['allm']!, _allmMeta));
    }
    if (data.containsKey('vesa')) {
      context.handle(
          _vesaMeta, vesa.isAcceptableOrUnknown(data['vesa']!, _vesaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {priceId};
  @override
  MonitorSpec map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonitorSpec(
      priceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_id'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      diagonal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}diagonal'])!,
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution'])!,
      refreshHz: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}refresh_hz'])!,
      hdmiVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hdmi_version'])!,
      vrr: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}vrr'])!,
      hdr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hdr'])!,
      allm: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}allm'])!,
      vesa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vesa'])!,
    );
  }

  @override
  $MonitorSpecsTable createAlias(String alias) {
    return $MonitorSpecsTable(attachedDatabase, alias);
  }
}

class MonitorSpec extends DataClass implements Insertable<MonitorSpec> {
  final String priceId;
  final String model;
  final double diagonal;
  final String resolution;
  final int refreshHz;
  final int hdmiVersion;
  final bool vrr;
  final String hdr;
  final bool allm;
  final String vesa;
  const MonitorSpec(
      {required this.priceId,
      required this.model,
      required this.diagonal,
      required this.resolution,
      required this.refreshHz,
      required this.hdmiVersion,
      required this.vrr,
      required this.hdr,
      required this.allm,
      required this.vesa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['price_id'] = Variable<String>(priceId);
    map['model'] = Variable<String>(model);
    map['diagonal'] = Variable<double>(diagonal);
    map['resolution'] = Variable<String>(resolution);
    map['refresh_hz'] = Variable<int>(refreshHz);
    map['hdmi_version'] = Variable<int>(hdmiVersion);
    map['vrr'] = Variable<bool>(vrr);
    map['hdr'] = Variable<String>(hdr);
    map['allm'] = Variable<bool>(allm);
    map['vesa'] = Variable<String>(vesa);
    return map;
  }

  MonitorSpecsCompanion toCompanion(bool nullToAbsent) {
    return MonitorSpecsCompanion(
      priceId: Value(priceId),
      model: Value(model),
      diagonal: Value(diagonal),
      resolution: Value(resolution),
      refreshHz: Value(refreshHz),
      hdmiVersion: Value(hdmiVersion),
      vrr: Value(vrr),
      hdr: Value(hdr),
      allm: Value(allm),
      vesa: Value(vesa),
    );
  }

  factory MonitorSpec.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonitorSpec(
      priceId: serializer.fromJson<String>(json['priceId']),
      model: serializer.fromJson<String>(json['model']),
      diagonal: serializer.fromJson<double>(json['diagonal']),
      resolution: serializer.fromJson<String>(json['resolution']),
      refreshHz: serializer.fromJson<int>(json['refreshHz']),
      hdmiVersion: serializer.fromJson<int>(json['hdmiVersion']),
      vrr: serializer.fromJson<bool>(json['vrr']),
      hdr: serializer.fromJson<String>(json['hdr']),
      allm: serializer.fromJson<bool>(json['allm']),
      vesa: serializer.fromJson<String>(json['vesa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'priceId': serializer.toJson<String>(priceId),
      'model': serializer.toJson<String>(model),
      'diagonal': serializer.toJson<double>(diagonal),
      'resolution': serializer.toJson<String>(resolution),
      'refreshHz': serializer.toJson<int>(refreshHz),
      'hdmiVersion': serializer.toJson<int>(hdmiVersion),
      'vrr': serializer.toJson<bool>(vrr),
      'hdr': serializer.toJson<String>(hdr),
      'allm': serializer.toJson<bool>(allm),
      'vesa': serializer.toJson<String>(vesa),
    };
  }

  MonitorSpec copyWith(
          {String? priceId,
          String? model,
          double? diagonal,
          String? resolution,
          int? refreshHz,
          int? hdmiVersion,
          bool? vrr,
          String? hdr,
          bool? allm,
          String? vesa}) =>
      MonitorSpec(
        priceId: priceId ?? this.priceId,
        model: model ?? this.model,
        diagonal: diagonal ?? this.diagonal,
        resolution: resolution ?? this.resolution,
        refreshHz: refreshHz ?? this.refreshHz,
        hdmiVersion: hdmiVersion ?? this.hdmiVersion,
        vrr: vrr ?? this.vrr,
        hdr: hdr ?? this.hdr,
        allm: allm ?? this.allm,
        vesa: vesa ?? this.vesa,
      );
  MonitorSpec copyWithCompanion(MonitorSpecsCompanion data) {
    return MonitorSpec(
      priceId: data.priceId.present ? data.priceId.value : this.priceId,
      model: data.model.present ? data.model.value : this.model,
      diagonal: data.diagonal.present ? data.diagonal.value : this.diagonal,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      refreshHz: data.refreshHz.present ? data.refreshHz.value : this.refreshHz,
      hdmiVersion:
          data.hdmiVersion.present ? data.hdmiVersion.value : this.hdmiVersion,
      vrr: data.vrr.present ? data.vrr.value : this.vrr,
      hdr: data.hdr.present ? data.hdr.value : this.hdr,
      allm: data.allm.present ? data.allm.value : this.allm,
      vesa: data.vesa.present ? data.vesa.value : this.vesa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonitorSpec(')
          ..write('priceId: $priceId, ')
          ..write('model: $model, ')
          ..write('diagonal: $diagonal, ')
          ..write('resolution: $resolution, ')
          ..write('refreshHz: $refreshHz, ')
          ..write('hdmiVersion: $hdmiVersion, ')
          ..write('vrr: $vrr, ')
          ..write('hdr: $hdr, ')
          ..write('allm: $allm, ')
          ..write('vesa: $vesa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(priceId, model, diagonal, resolution,
      refreshHz, hdmiVersion, vrr, hdr, allm, vesa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitorSpec &&
          other.priceId == this.priceId &&
          other.model == this.model &&
          other.diagonal == this.diagonal &&
          other.resolution == this.resolution &&
          other.refreshHz == this.refreshHz &&
          other.hdmiVersion == this.hdmiVersion &&
          other.vrr == this.vrr &&
          other.hdr == this.hdr &&
          other.allm == this.allm &&
          other.vesa == this.vesa);
}

class MonitorSpecsCompanion extends UpdateCompanion<MonitorSpec> {
  final Value<String> priceId;
  final Value<String> model;
  final Value<double> diagonal;
  final Value<String> resolution;
  final Value<int> refreshHz;
  final Value<int> hdmiVersion;
  final Value<bool> vrr;
  final Value<String> hdr;
  final Value<bool> allm;
  final Value<String> vesa;
  final Value<int> rowid;
  const MonitorSpecsCompanion({
    this.priceId = const Value.absent(),
    this.model = const Value.absent(),
    this.diagonal = const Value.absent(),
    this.resolution = const Value.absent(),
    this.refreshHz = const Value.absent(),
    this.hdmiVersion = const Value.absent(),
    this.vrr = const Value.absent(),
    this.hdr = const Value.absent(),
    this.allm = const Value.absent(),
    this.vesa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonitorSpecsCompanion.insert({
    required String priceId,
    required String model,
    required double diagonal,
    required String resolution,
    required int refreshHz,
    required int hdmiVersion,
    this.vrr = const Value.absent(),
    this.hdr = const Value.absent(),
    this.allm = const Value.absent(),
    this.vesa = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : priceId = Value(priceId),
        model = Value(model),
        diagonal = Value(diagonal),
        resolution = Value(resolution),
        refreshHz = Value(refreshHz),
        hdmiVersion = Value(hdmiVersion);
  static Insertable<MonitorSpec> custom({
    Expression<String>? priceId,
    Expression<String>? model,
    Expression<double>? diagonal,
    Expression<String>? resolution,
    Expression<int>? refreshHz,
    Expression<int>? hdmiVersion,
    Expression<bool>? vrr,
    Expression<String>? hdr,
    Expression<bool>? allm,
    Expression<String>? vesa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (priceId != null) 'price_id': priceId,
      if (model != null) 'model': model,
      if (diagonal != null) 'diagonal': diagonal,
      if (resolution != null) 'resolution': resolution,
      if (refreshHz != null) 'refresh_hz': refreshHz,
      if (hdmiVersion != null) 'hdmi_version': hdmiVersion,
      if (vrr != null) 'vrr': vrr,
      if (hdr != null) 'hdr': hdr,
      if (allm != null) 'allm': allm,
      if (vesa != null) 'vesa': vesa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonitorSpecsCompanion copyWith(
      {Value<String>? priceId,
      Value<String>? model,
      Value<double>? diagonal,
      Value<String>? resolution,
      Value<int>? refreshHz,
      Value<int>? hdmiVersion,
      Value<bool>? vrr,
      Value<String>? hdr,
      Value<bool>? allm,
      Value<String>? vesa,
      Value<int>? rowid}) {
    return MonitorSpecsCompanion(
      priceId: priceId ?? this.priceId,
      model: model ?? this.model,
      diagonal: diagonal ?? this.diagonal,
      resolution: resolution ?? this.resolution,
      refreshHz: refreshHz ?? this.refreshHz,
      hdmiVersion: hdmiVersion ?? this.hdmiVersion,
      vrr: vrr ?? this.vrr,
      hdr: hdr ?? this.hdr,
      allm: allm ?? this.allm,
      vesa: vesa ?? this.vesa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (priceId.present) {
      map['price_id'] = Variable<String>(priceId.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (diagonal.present) {
      map['diagonal'] = Variable<double>(diagonal.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (refreshHz.present) {
      map['refresh_hz'] = Variable<int>(refreshHz.value);
    }
    if (hdmiVersion.present) {
      map['hdmi_version'] = Variable<int>(hdmiVersion.value);
    }
    if (vrr.present) {
      map['vrr'] = Variable<bool>(vrr.value);
    }
    if (hdr.present) {
      map['hdr'] = Variable<String>(hdr.value);
    }
    if (allm.present) {
      map['allm'] = Variable<bool>(allm.value);
    }
    if (vesa.present) {
      map['vesa'] = Variable<String>(vesa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonitorSpecsCompanion(')
          ..write('priceId: $priceId, ')
          ..write('model: $model, ')
          ..write('diagonal: $diagonal, ')
          ..write('resolution: $resolution, ')
          ..write('refreshHz: $refreshHz, ')
          ..write('hdmiVersion: $hdmiVersion, ')
          ..write('vrr: $vrr, ')
          ..write('hdr: $hdr, ')
          ..write('allm: $allm, ')
          ..write('vesa: $vesa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $Ps5SpecsTable extends Ps5Specs with TableInfo<$Ps5SpecsTable, Ps5Spec> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Ps5SpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _priceIdMeta =
      const VerificationMeta('priceId');
  @override
  late final GeneratedColumn<String> priceId = GeneratedColumn<String>(
      'price_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _consoleTypeMeta =
      const VerificationMeta('consoleType');
  @override
  late final GeneratedColumn<String> consoleType = GeneratedColumn<String>(
      'console_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memoryGbMeta =
      const VerificationMeta('memoryGb');
  @override
  late final GeneratedColumn<int> memoryGb = GeneratedColumn<int>(
      'memory_gb', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isSlimMeta = const VerificationMeta('isSlim');
  @override
  late final GeneratedColumn<bool> isSlim = GeneratedColumn<bool>(
      'is_slim', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_slim" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [priceId, consoleType, memoryGb, isSlim];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ps5_specs';
  @override
  VerificationContext validateIntegrity(Insertable<Ps5Spec> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('price_id')) {
      context.handle(_priceIdMeta,
          priceId.isAcceptableOrUnknown(data['price_id']!, _priceIdMeta));
    } else if (isInserting) {
      context.missing(_priceIdMeta);
    }
    if (data.containsKey('console_type')) {
      context.handle(
          _consoleTypeMeta,
          consoleType.isAcceptableOrUnknown(
              data['console_type']!, _consoleTypeMeta));
    } else if (isInserting) {
      context.missing(_consoleTypeMeta);
    }
    if (data.containsKey('memory_gb')) {
      context.handle(_memoryGbMeta,
          memoryGb.isAcceptableOrUnknown(data['memory_gb']!, _memoryGbMeta));
    } else if (isInserting) {
      context.missing(_memoryGbMeta);
    }
    if (data.containsKey('is_slim')) {
      context.handle(_isSlimMeta,
          isSlim.isAcceptableOrUnknown(data['is_slim']!, _isSlimMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {priceId};
  @override
  Ps5Spec map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ps5Spec(
      priceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_id'])!,
      consoleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}console_type'])!,
      memoryGb: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}memory_gb'])!,
      isSlim: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_slim'])!,
    );
  }

  @override
  $Ps5SpecsTable createAlias(String alias) {
    return $Ps5SpecsTable(attachedDatabase, alias);
  }
}

class Ps5Spec extends DataClass implements Insertable<Ps5Spec> {
  final String priceId;
  final String consoleType;
  final int memoryGb;
  final bool isSlim;
  const Ps5Spec(
      {required this.priceId,
      required this.consoleType,
      required this.memoryGb,
      required this.isSlim});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['price_id'] = Variable<String>(priceId);
    map['console_type'] = Variable<String>(consoleType);
    map['memory_gb'] = Variable<int>(memoryGb);
    map['is_slim'] = Variable<bool>(isSlim);
    return map;
  }

  Ps5SpecsCompanion toCompanion(bool nullToAbsent) {
    return Ps5SpecsCompanion(
      priceId: Value(priceId),
      consoleType: Value(consoleType),
      memoryGb: Value(memoryGb),
      isSlim: Value(isSlim),
    );
  }

  factory Ps5Spec.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ps5Spec(
      priceId: serializer.fromJson<String>(json['priceId']),
      consoleType: serializer.fromJson<String>(json['consoleType']),
      memoryGb: serializer.fromJson<int>(json['memoryGb']),
      isSlim: serializer.fromJson<bool>(json['isSlim']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'priceId': serializer.toJson<String>(priceId),
      'consoleType': serializer.toJson<String>(consoleType),
      'memoryGb': serializer.toJson<int>(memoryGb),
      'isSlim': serializer.toJson<bool>(isSlim),
    };
  }

  Ps5Spec copyWith(
          {String? priceId,
          String? consoleType,
          int? memoryGb,
          bool? isSlim}) =>
      Ps5Spec(
        priceId: priceId ?? this.priceId,
        consoleType: consoleType ?? this.consoleType,
        memoryGb: memoryGb ?? this.memoryGb,
        isSlim: isSlim ?? this.isSlim,
      );
  Ps5Spec copyWithCompanion(Ps5SpecsCompanion data) {
    return Ps5Spec(
      priceId: data.priceId.present ? data.priceId.value : this.priceId,
      consoleType:
          data.consoleType.present ? data.consoleType.value : this.consoleType,
      memoryGb: data.memoryGb.present ? data.memoryGb.value : this.memoryGb,
      isSlim: data.isSlim.present ? data.isSlim.value : this.isSlim,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ps5Spec(')
          ..write('priceId: $priceId, ')
          ..write('consoleType: $consoleType, ')
          ..write('memoryGb: $memoryGb, ')
          ..write('isSlim: $isSlim')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(priceId, consoleType, memoryGb, isSlim);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ps5Spec &&
          other.priceId == this.priceId &&
          other.consoleType == this.consoleType &&
          other.memoryGb == this.memoryGb &&
          other.isSlim == this.isSlim);
}

class Ps5SpecsCompanion extends UpdateCompanion<Ps5Spec> {
  final Value<String> priceId;
  final Value<String> consoleType;
  final Value<int> memoryGb;
  final Value<bool> isSlim;
  final Value<int> rowid;
  const Ps5SpecsCompanion({
    this.priceId = const Value.absent(),
    this.consoleType = const Value.absent(),
    this.memoryGb = const Value.absent(),
    this.isSlim = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  Ps5SpecsCompanion.insert({
    required String priceId,
    required String consoleType,
    required int memoryGb,
    this.isSlim = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : priceId = Value(priceId),
        consoleType = Value(consoleType),
        memoryGb = Value(memoryGb);
  static Insertable<Ps5Spec> custom({
    Expression<String>? priceId,
    Expression<String>? consoleType,
    Expression<int>? memoryGb,
    Expression<bool>? isSlim,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (priceId != null) 'price_id': priceId,
      if (consoleType != null) 'console_type': consoleType,
      if (memoryGb != null) 'memory_gb': memoryGb,
      if (isSlim != null) 'is_slim': isSlim,
      if (rowid != null) 'rowid': rowid,
    });
  }

  Ps5SpecsCompanion copyWith(
      {Value<String>? priceId,
      Value<String>? consoleType,
      Value<int>? memoryGb,
      Value<bool>? isSlim,
      Value<int>? rowid}) {
    return Ps5SpecsCompanion(
      priceId: priceId ?? this.priceId,
      consoleType: consoleType ?? this.consoleType,
      memoryGb: memoryGb ?? this.memoryGb,
      isSlim: isSlim ?? this.isSlim,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (priceId.present) {
      map['price_id'] = Variable<String>(priceId.value);
    }
    if (consoleType.present) {
      map['console_type'] = Variable<String>(consoleType.value);
    }
    if (memoryGb.present) {
      map['memory_gb'] = Variable<int>(memoryGb.value);
    }
    if (isSlim.present) {
      map['is_slim'] = Variable<bool>(isSlim.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Ps5SpecsCompanion(')
          ..write('priceId: $priceId, ')
          ..write('consoleType: $consoleType, ')
          ..write('memoryGb: $memoryGb, ')
          ..write('isSlim: $isSlim, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsCacheTable extends NotificationsCache
    with TableInfo<$NotificationsCacheTable, NotificationsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleKeyMeta =
      const VerificationMeta('titleKey');
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
      'title_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyKeyMeta =
      const VerificationMeta('bodyKey');
  @override
  late final GeneratedColumn<String> bodyKey = GeneratedColumn<String>(
      'body_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyParamsJsonMeta =
      const VerificationMeta('bodyParamsJson');
  @override
  late final GeneratedColumn<String> bodyParamsJson = GeneratedColumn<String>(
      'body_params_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _deepLinkMeta =
      const VerificationMeta('deepLink');
  @override
  late final GeneratedColumn<String> deepLink = GeneratedColumn<String>(
      'deep_link', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
      'read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isPushMeta = const VerificationMeta('isPush');
  @override
  late final GeneratedColumn<bool> isPush = GeneratedColumn<bool>(
      'is_push', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_push" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        titleKey,
        bodyKey,
        bodyParamsJson,
        deepLink,
        createdAt,
        read,
        isPush
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationsCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(_titleKeyMeta,
          titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta));
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('body_key')) {
      context.handle(_bodyKeyMeta,
          bodyKey.isAcceptableOrUnknown(data['body_key']!, _bodyKeyMeta));
    } else if (isInserting) {
      context.missing(_bodyKeyMeta);
    }
    if (data.containsKey('body_params_json')) {
      context.handle(
          _bodyParamsJsonMeta,
          bodyParamsJson.isAcceptableOrUnknown(
              data['body_params_json']!, _bodyParamsJsonMeta));
    }
    if (data.containsKey('deep_link')) {
      context.handle(_deepLinkMeta,
          deepLink.isAcceptableOrUnknown(data['deep_link']!, _deepLinkMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('read')) {
      context.handle(
          _readMeta, read.isAcceptableOrUnknown(data['read']!, _readMeta));
    }
    if (data.containsKey('is_push')) {
      context.handle(_isPushMeta,
          isPush.isAcceptableOrUnknown(data['is_push']!, _isPushMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationsCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      titleKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_key'])!,
      bodyKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body_key'])!,
      bodyParamsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}body_params_json'])!,
      deepLink: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deep_link']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      read: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}read'])!,
      isPush: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_push'])!,
    );
  }

  @override
  $NotificationsCacheTable createAlias(String alias) {
    return $NotificationsCacheTable(attachedDatabase, alias);
  }
}

class NotificationsCacheData extends DataClass
    implements Insertable<NotificationsCacheData> {
  final String id;
  final String type;
  final String titleKey;
  final String bodyKey;
  final String bodyParamsJson;
  final String? deepLink;
  final int createdAt;
  final bool read;
  final bool isPush;
  const NotificationsCacheData(
      {required this.id,
      required this.type,
      required this.titleKey,
      required this.bodyKey,
      required this.bodyParamsJson,
      this.deepLink,
      required this.createdAt,
      required this.read,
      required this.isPush});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title_key'] = Variable<String>(titleKey);
    map['body_key'] = Variable<String>(bodyKey);
    map['body_params_json'] = Variable<String>(bodyParamsJson);
    if (!nullToAbsent || deepLink != null) {
      map['deep_link'] = Variable<String>(deepLink);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['read'] = Variable<bool>(read);
    map['is_push'] = Variable<bool>(isPush);
    return map;
  }

  NotificationsCacheCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCacheCompanion(
      id: Value(id),
      type: Value(type),
      titleKey: Value(titleKey),
      bodyKey: Value(bodyKey),
      bodyParamsJson: Value(bodyParamsJson),
      deepLink: deepLink == null && nullToAbsent
          ? const Value.absent()
          : Value(deepLink),
      createdAt: Value(createdAt),
      read: Value(read),
      isPush: Value(isPush),
    );
  }

  factory NotificationsCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationsCacheData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      bodyKey: serializer.fromJson<String>(json['bodyKey']),
      bodyParamsJson: serializer.fromJson<String>(json['bodyParamsJson']),
      deepLink: serializer.fromJson<String?>(json['deepLink']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      read: serializer.fromJson<bool>(json['read']),
      isPush: serializer.fromJson<bool>(json['isPush']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'titleKey': serializer.toJson<String>(titleKey),
      'bodyKey': serializer.toJson<String>(bodyKey),
      'bodyParamsJson': serializer.toJson<String>(bodyParamsJson),
      'deepLink': serializer.toJson<String?>(deepLink),
      'createdAt': serializer.toJson<int>(createdAt),
      'read': serializer.toJson<bool>(read),
      'isPush': serializer.toJson<bool>(isPush),
    };
  }

  NotificationsCacheData copyWith(
          {String? id,
          String? type,
          String? titleKey,
          String? bodyKey,
          String? bodyParamsJson,
          Value<String?> deepLink = const Value.absent(),
          int? createdAt,
          bool? read,
          bool? isPush}) =>
      NotificationsCacheData(
        id: id ?? this.id,
        type: type ?? this.type,
        titleKey: titleKey ?? this.titleKey,
        bodyKey: bodyKey ?? this.bodyKey,
        bodyParamsJson: bodyParamsJson ?? this.bodyParamsJson,
        deepLink: deepLink.present ? deepLink.value : this.deepLink,
        createdAt: createdAt ?? this.createdAt,
        read: read ?? this.read,
        isPush: isPush ?? this.isPush,
      );
  NotificationsCacheData copyWithCompanion(NotificationsCacheCompanion data) {
    return NotificationsCacheData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      bodyKey: data.bodyKey.present ? data.bodyKey.value : this.bodyKey,
      bodyParamsJson: data.bodyParamsJson.present
          ? data.bodyParamsJson.value
          : this.bodyParamsJson,
      deepLink: data.deepLink.present ? data.deepLink.value : this.deepLink,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      read: data.read.present ? data.read.value : this.read,
      isPush: data.isPush.present ? data.isPush.value : this.isPush,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCacheData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('titleKey: $titleKey, ')
          ..write('bodyKey: $bodyKey, ')
          ..write('bodyParamsJson: $bodyParamsJson, ')
          ..write('deepLink: $deepLink, ')
          ..write('createdAt: $createdAt, ')
          ..write('read: $read, ')
          ..write('isPush: $isPush')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, titleKey, bodyKey, bodyParamsJson,
      deepLink, createdAt, read, isPush);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationsCacheData &&
          other.id == this.id &&
          other.type == this.type &&
          other.titleKey == this.titleKey &&
          other.bodyKey == this.bodyKey &&
          other.bodyParamsJson == this.bodyParamsJson &&
          other.deepLink == this.deepLink &&
          other.createdAt == this.createdAt &&
          other.read == this.read &&
          other.isPush == this.isPush);
}

class NotificationsCacheCompanion
    extends UpdateCompanion<NotificationsCacheData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> titleKey;
  final Value<String> bodyKey;
  final Value<String> bodyParamsJson;
  final Value<String?> deepLink;
  final Value<int> createdAt;
  final Value<bool> read;
  final Value<bool> isPush;
  final Value<int> rowid;
  const NotificationsCacheCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.bodyKey = const Value.absent(),
    this.bodyParamsJson = const Value.absent(),
    this.deepLink = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.read = const Value.absent(),
    this.isPush = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCacheCompanion.insert({
    required String id,
    required String type,
    required String titleKey,
    required String bodyKey,
    this.bodyParamsJson = const Value.absent(),
    this.deepLink = const Value.absent(),
    required int createdAt,
    this.read = const Value.absent(),
    this.isPush = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        titleKey = Value(titleKey),
        bodyKey = Value(bodyKey),
        createdAt = Value(createdAt);
  static Insertable<NotificationsCacheData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? titleKey,
    Expression<String>? bodyKey,
    Expression<String>? bodyParamsJson,
    Expression<String>? deepLink,
    Expression<int>? createdAt,
    Expression<bool>? read,
    Expression<bool>? isPush,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (titleKey != null) 'title_key': titleKey,
      if (bodyKey != null) 'body_key': bodyKey,
      if (bodyParamsJson != null) 'body_params_json': bodyParamsJson,
      if (deepLink != null) 'deep_link': deepLink,
      if (createdAt != null) 'created_at': createdAt,
      if (read != null) 'read': read,
      if (isPush != null) 'is_push': isPush,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCacheCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? titleKey,
      Value<String>? bodyKey,
      Value<String>? bodyParamsJson,
      Value<String?>? deepLink,
      Value<int>? createdAt,
      Value<bool>? read,
      Value<bool>? isPush,
      Value<int>? rowid}) {
    return NotificationsCacheCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      titleKey: titleKey ?? this.titleKey,
      bodyKey: bodyKey ?? this.bodyKey,
      bodyParamsJson: bodyParamsJson ?? this.bodyParamsJson,
      deepLink: deepLink ?? this.deepLink,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      isPush: isPush ?? this.isPush,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (bodyKey.present) {
      map['body_key'] = Variable<String>(bodyKey.value);
    }
    if (bodyParamsJson.present) {
      map['body_params_json'] = Variable<String>(bodyParamsJson.value);
    }
    if (deepLink.present) {
      map['deep_link'] = Variable<String>(deepLink.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (isPush.present) {
      map['is_push'] = Variable<bool>(isPush.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCacheCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('titleKey: $titleKey, ')
          ..write('bodyKey: $bodyKey, ')
          ..write('bodyParamsJson: $bodyParamsJson, ')
          ..write('deepLink: $deepLink, ')
          ..write('createdAt: $createdAt, ')
          ..write('read: $read, ')
          ..write('isPush: $isPush, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<int> nextAttemptAt = GeneratedColumn<int>(
      'next_attempt_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityId,
        entityType,
        payloadJson,
        attempts,
        nextAttemptAt,
        lastError,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      nextAttemptAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_attempt_at'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String entityId;
  final String entityType;
  final String payloadJson;
  final int attempts;
  final int nextAttemptAt;
  final String? lastError;
  final int createdAt;
  const SyncQueueData(
      {required this.id,
      required this.entityId,
      required this.entityType,
      required this.payloadJson,
      required this.attempts,
      required this.nextAttemptAt,
      this.lastError,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_type'] = Variable<String>(entityType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['attempts'] = Variable<int>(attempts);
    map['next_attempt_at'] = Variable<int>(nextAttemptAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityId: Value(entityId),
      entityType: Value(entityType),
      payloadJson: Value(payloadJson),
      attempts: Value(attempts),
      nextAttemptAt: Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<int>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityId': serializer.toJson<String>(entityId),
      'entityType': serializer.toJson<String>(entityType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<int>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? entityId,
          String? entityType,
          String? payloadJson,
          int? attempts,
          int? nextAttemptAt,
          Value<String?> lastError = const Value.absent(),
          int? createdAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        entityId: entityId ?? this.entityId,
        entityType: entityType ?? this.entityType,
        payloadJson: payloadJson ?? this.payloadJson,
        attempts: attempts ?? this.attempts,
        nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityId, entityType, payloadJson,
      attempts, nextAttemptAt, lastError, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityId == this.entityId &&
          other.entityType == this.entityType &&
          other.payloadJson == this.payloadJson &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityId;
  final Value<String> entityType;
  final Value<String> payloadJson;
  final Value<int> attempts;
  final Value<int> nextAttemptAt;
  final Value<String?> lastError;
  final Value<int> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityId,
    required String entityType,
    required String payloadJson,
    this.attempts = const Value.absent(),
    required int nextAttemptAt,
    this.lastError = const Value.absent(),
    required int createdAt,
  })  : entityId = Value(entityId),
        entityType = Value(entityType),
        payloadJson = Value(payloadJson),
        nextAttemptAt = Value(nextAttemptAt),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityId,
    Expression<String>? entityType,
    Expression<String>? payloadJson,
    Expression<int>? attempts,
    Expression<int>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityId,
      Value<String>? entityType,
      Value<String>? payloadJson,
      Value<int>? attempts,
      Value<int>? nextAttemptAt,
      Value<String?>? lastError,
      Value<int>? createdAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      payloadJson: payloadJson ?? this.payloadJson,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<int>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ChipsWalletTableTable extends ChipsWalletTable
    with TableInfo<$ChipsWalletTableTable, ChipsWalletTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChipsWalletTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
      'balance', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dustMeta = const VerificationMeta('dust');
  @override
  late final GeneratedColumn<int> dust = GeneratedColumn<int>(
      'dust', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, balance, dust, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chips_wallet_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChipsWalletTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('dust')) {
      context.handle(
          _dustMeta, dust.isAcceptableOrUnknown(data['dust']!, _dustMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChipsWalletTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChipsWalletTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance'])!,
      dust: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dust'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $ChipsWalletTableTable createAlias(String alias) {
    return $ChipsWalletTableTable(attachedDatabase, alias);
  }
}

class ChipsWalletTableData extends DataClass
    implements Insertable<ChipsWalletTableData> {
  final String id;
  final int balance;
  final int dust;
  final bool synced;
  const ChipsWalletTableData(
      {required this.id,
      required this.balance,
      required this.dust,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['balance'] = Variable<int>(balance);
    map['dust'] = Variable<int>(dust);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChipsWalletTableCompanion toCompanion(bool nullToAbsent) {
    return ChipsWalletTableCompanion(
      id: Value(id),
      balance: Value(balance),
      dust: Value(dust),
      synced: Value(synced),
    );
  }

  factory ChipsWalletTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChipsWalletTableData(
      id: serializer.fromJson<String>(json['id']),
      balance: serializer.fromJson<int>(json['balance']),
      dust: serializer.fromJson<int>(json['dust']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'balance': serializer.toJson<int>(balance),
      'dust': serializer.toJson<int>(dust),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ChipsWalletTableData copyWith(
          {String? id, int? balance, int? dust, bool? synced}) =>
      ChipsWalletTableData(
        id: id ?? this.id,
        balance: balance ?? this.balance,
        dust: dust ?? this.dust,
        synced: synced ?? this.synced,
      );
  ChipsWalletTableData copyWithCompanion(ChipsWalletTableCompanion data) {
    return ChipsWalletTableData(
      id: data.id.present ? data.id.value : this.id,
      balance: data.balance.present ? data.balance.value : this.balance,
      dust: data.dust.present ? data.dust.value : this.dust,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChipsWalletTableData(')
          ..write('id: $id, ')
          ..write('balance: $balance, ')
          ..write('dust: $dust, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, balance, dust, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChipsWalletTableData &&
          other.id == this.id &&
          other.balance == this.balance &&
          other.dust == this.dust &&
          other.synced == this.synced);
}

class ChipsWalletTableCompanion extends UpdateCompanion<ChipsWalletTableData> {
  final Value<String> id;
  final Value<int> balance;
  final Value<int> dust;
  final Value<bool> synced;
  final Value<int> rowid;
  const ChipsWalletTableCompanion({
    this.id = const Value.absent(),
    this.balance = const Value.absent(),
    this.dust = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChipsWalletTableCompanion.insert({
    required String id,
    this.balance = const Value.absent(),
    this.dust = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ChipsWalletTableData> custom({
    Expression<String>? id,
    Expression<int>? balance,
    Expression<int>? dust,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (balance != null) 'balance': balance,
      if (dust != null) 'dust': dust,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChipsWalletTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? balance,
      Value<int>? dust,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return ChipsWalletTableCompanion(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      dust: dust ?? this.dust,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (dust.present) {
      map['dust'] = Variable<int>(dust.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChipsWalletTableCompanion(')
          ..write('id: $id, ')
          ..write('balance: $balance, ')
          ..write('dust: $dust, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChipsLedgerTable extends ChipsLedger
    with TableInfo<$ChipsLedgerTable, ChipsLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChipsLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
      'delta', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
      'ref_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, reason, delta, refId, createdAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chips_ledger';
  @override
  VerificationContext validateIntegrity(Insertable<ChipsLedgerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
          _deltaMeta, delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta));
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
          _refIdMeta, refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChipsLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChipsLedgerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      delta: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delta'])!,
      refId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $ChipsLedgerTable createAlias(String alias) {
    return $ChipsLedgerTable(attachedDatabase, alias);
  }
}

class ChipsLedgerData extends DataClass implements Insertable<ChipsLedgerData> {
  final int id;
  final String reason;
  final int delta;
  final String? refId;
  final int createdAt;
  final bool synced;
  const ChipsLedgerData(
      {required this.id,
      required this.reason,
      required this.delta,
      this.refId,
      required this.createdAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reason'] = Variable<String>(reason);
    map['delta'] = Variable<int>(delta);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChipsLedgerCompanion toCompanion(bool nullToAbsent) {
    return ChipsLedgerCompanion(
      id: Value(id),
      reason: Value(reason),
      delta: Value(delta),
      refId:
          refId == null && nullToAbsent ? const Value.absent() : Value(refId),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory ChipsLedgerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChipsLedgerData(
      id: serializer.fromJson<int>(json['id']),
      reason: serializer.fromJson<String>(json['reason']),
      delta: serializer.fromJson<int>(json['delta']),
      refId: serializer.fromJson<String?>(json['refId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reason': serializer.toJson<String>(reason),
      'delta': serializer.toJson<int>(delta),
      'refId': serializer.toJson<String?>(refId),
      'createdAt': serializer.toJson<int>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ChipsLedgerData copyWith(
          {int? id,
          String? reason,
          int? delta,
          Value<String?> refId = const Value.absent(),
          int? createdAt,
          bool? synced}) =>
      ChipsLedgerData(
        id: id ?? this.id,
        reason: reason ?? this.reason,
        delta: delta ?? this.delta,
        refId: refId.present ? refId.value : this.refId,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
  ChipsLedgerData copyWithCompanion(ChipsLedgerCompanion data) {
    return ChipsLedgerData(
      id: data.id.present ? data.id.value : this.id,
      reason: data.reason.present ? data.reason.value : this.reason,
      delta: data.delta.present ? data.delta.value : this.delta,
      refId: data.refId.present ? data.refId.value : this.refId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChipsLedgerData(')
          ..write('id: $id, ')
          ..write('reason: $reason, ')
          ..write('delta: $delta, ')
          ..write('refId: $refId, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, reason, delta, refId, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChipsLedgerData &&
          other.id == this.id &&
          other.reason == this.reason &&
          other.delta == this.delta &&
          other.refId == this.refId &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class ChipsLedgerCompanion extends UpdateCompanion<ChipsLedgerData> {
  final Value<int> id;
  final Value<String> reason;
  final Value<int> delta;
  final Value<String?> refId;
  final Value<int> createdAt;
  final Value<bool> synced;
  const ChipsLedgerCompanion({
    this.id = const Value.absent(),
    this.reason = const Value.absent(),
    this.delta = const Value.absent(),
    this.refId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ChipsLedgerCompanion.insert({
    this.id = const Value.absent(),
    required String reason,
    required int delta,
    this.refId = const Value.absent(),
    required int createdAt,
    this.synced = const Value.absent(),
  })  : reason = Value(reason),
        delta = Value(delta),
        createdAt = Value(createdAt);
  static Insertable<ChipsLedgerData> custom({
    Expression<int>? id,
    Expression<String>? reason,
    Expression<int>? delta,
    Expression<String>? refId,
    Expression<int>? createdAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reason != null) 'reason': reason,
      if (delta != null) 'delta': delta,
      if (refId != null) 'ref_id': refId,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
    });
  }

  ChipsLedgerCompanion copyWith(
      {Value<int>? id,
      Value<String>? reason,
      Value<int>? delta,
      Value<String?>? refId,
      Value<int>? createdAt,
      Value<bool>? synced}) {
    return ChipsLedgerCompanion(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      delta: delta ?? this.delta,
      refId: refId ?? this.refId,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChipsLedgerCompanion(')
          ..write('id: $id, ')
          ..write('reason: $reason, ')
          ..write('delta: $delta, ')
          ..write('refId: $refId, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $PetsTable extends Pets with TableInfo<$PetsTable, Pet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
      'form', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('egg'));
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
      'mood', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('happy'));
  static const VerificationMeta _skinMeta = const VerificationMeta('skin');
  @override
  late final GeneratedColumn<String> skin = GeneratedColumn<String>(
      'skin', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('neon_cyan'));
  static const VerificationMeta _hatchedAtMeta =
      const VerificationMeta('hatchedAt');
  @override
  late final GeneratedColumn<int> hatchedAt = GeneratedColumn<int>(
      'hatched_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _feedCountMeta =
      const VerificationMeta('feedCount');
  @override
  late final GeneratedColumn<int> feedCount = GeneratedColumn<int>(
      'feed_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastOpenDayMeta =
      const VerificationMeta('lastOpenDay');
  @override
  late final GeneratedColumn<String> lastOpenDay = GeneratedColumn<String>(
      'last_open_day', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastFedDayMeta =
      const VerificationMeta('lastFedDay');
  @override
  late final GeneratedColumn<String> lastFedDay = GeneratedColumn<String>(
      'last_fed_day', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSadPushAtMeta =
      const VerificationMeta('lastSadPushAt');
  @override
  late final GeneratedColumn<int> lastSadPushAt = GeneratedColumn<int>(
      'last_sad_push_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        form,
        mood,
        skin,
        hatchedAt,
        feedCount,
        lastOpenDay,
        lastFedDay,
        lastSadPushAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pets';
  @override
  VerificationContext validateIntegrity(Insertable<Pet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
          _formMeta, form.isAcceptableOrUnknown(data['form']!, _formMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('skin')) {
      context.handle(
          _skinMeta, skin.isAcceptableOrUnknown(data['skin']!, _skinMeta));
    }
    if (data.containsKey('hatched_at')) {
      context.handle(_hatchedAtMeta,
          hatchedAt.isAcceptableOrUnknown(data['hatched_at']!, _hatchedAtMeta));
    }
    if (data.containsKey('feed_count')) {
      context.handle(_feedCountMeta,
          feedCount.isAcceptableOrUnknown(data['feed_count']!, _feedCountMeta));
    }
    if (data.containsKey('last_open_day')) {
      context.handle(
          _lastOpenDayMeta,
          lastOpenDay.isAcceptableOrUnknown(
              data['last_open_day']!, _lastOpenDayMeta));
    }
    if (data.containsKey('last_fed_day')) {
      context.handle(
          _lastFedDayMeta,
          lastFedDay.isAcceptableOrUnknown(
              data['last_fed_day']!, _lastFedDayMeta));
    }
    if (data.containsKey('last_sad_push_at')) {
      context.handle(
          _lastSadPushAtMeta,
          lastSadPushAt.isAcceptableOrUnknown(
              data['last_sad_push_at']!, _lastSadPushAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      form: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood'])!,
      skin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skin'])!,
      hatchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hatched_at']),
      feedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}feed_count'])!,
      lastOpenDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_open_day']),
      lastFedDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_fed_day']),
      lastSadPushAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_sad_push_at']),
    );
  }

  @override
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }
}

class Pet extends DataClass implements Insertable<Pet> {
  final String id;
  final String form;
  final String mood;
  final String skin;
  final int? hatchedAt;
  final int feedCount;
  final String? lastOpenDay;
  final String? lastFedDay;
  final int? lastSadPushAt;
  const Pet(
      {required this.id,
      required this.form,
      required this.mood,
      required this.skin,
      this.hatchedAt,
      required this.feedCount,
      this.lastOpenDay,
      this.lastFedDay,
      this.lastSadPushAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['form'] = Variable<String>(form);
    map['mood'] = Variable<String>(mood);
    map['skin'] = Variable<String>(skin);
    if (!nullToAbsent || hatchedAt != null) {
      map['hatched_at'] = Variable<int>(hatchedAt);
    }
    map['feed_count'] = Variable<int>(feedCount);
    if (!nullToAbsent || lastOpenDay != null) {
      map['last_open_day'] = Variable<String>(lastOpenDay);
    }
    if (!nullToAbsent || lastFedDay != null) {
      map['last_fed_day'] = Variable<String>(lastFedDay);
    }
    if (!nullToAbsent || lastSadPushAt != null) {
      map['last_sad_push_at'] = Variable<int>(lastSadPushAt);
    }
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      form: Value(form),
      mood: Value(mood),
      skin: Value(skin),
      hatchedAt: hatchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(hatchedAt),
      feedCount: Value(feedCount),
      lastOpenDay: lastOpenDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenDay),
      lastFedDay: lastFedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFedDay),
      lastSadPushAt: lastSadPushAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSadPushAt),
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pet(
      id: serializer.fromJson<String>(json['id']),
      form: serializer.fromJson<String>(json['form']),
      mood: serializer.fromJson<String>(json['mood']),
      skin: serializer.fromJson<String>(json['skin']),
      hatchedAt: serializer.fromJson<int?>(json['hatchedAt']),
      feedCount: serializer.fromJson<int>(json['feedCount']),
      lastOpenDay: serializer.fromJson<String?>(json['lastOpenDay']),
      lastFedDay: serializer.fromJson<String?>(json['lastFedDay']),
      lastSadPushAt: serializer.fromJson<int?>(json['lastSadPushAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'form': serializer.toJson<String>(form),
      'mood': serializer.toJson<String>(mood),
      'skin': serializer.toJson<String>(skin),
      'hatchedAt': serializer.toJson<int?>(hatchedAt),
      'feedCount': serializer.toJson<int>(feedCount),
      'lastOpenDay': serializer.toJson<String?>(lastOpenDay),
      'lastFedDay': serializer.toJson<String?>(lastFedDay),
      'lastSadPushAt': serializer.toJson<int?>(lastSadPushAt),
    };
  }

  Pet copyWith(
          {String? id,
          String? form,
          String? mood,
          String? skin,
          Value<int?> hatchedAt = const Value.absent(),
          int? feedCount,
          Value<String?> lastOpenDay = const Value.absent(),
          Value<String?> lastFedDay = const Value.absent(),
          Value<int?> lastSadPushAt = const Value.absent()}) =>
      Pet(
        id: id ?? this.id,
        form: form ?? this.form,
        mood: mood ?? this.mood,
        skin: skin ?? this.skin,
        hatchedAt: hatchedAt.present ? hatchedAt.value : this.hatchedAt,
        feedCount: feedCount ?? this.feedCount,
        lastOpenDay: lastOpenDay.present ? lastOpenDay.value : this.lastOpenDay,
        lastFedDay: lastFedDay.present ? lastFedDay.value : this.lastFedDay,
        lastSadPushAt:
            lastSadPushAt.present ? lastSadPushAt.value : this.lastSadPushAt,
      );
  Pet copyWithCompanion(PetsCompanion data) {
    return Pet(
      id: data.id.present ? data.id.value : this.id,
      form: data.form.present ? data.form.value : this.form,
      mood: data.mood.present ? data.mood.value : this.mood,
      skin: data.skin.present ? data.skin.value : this.skin,
      hatchedAt: data.hatchedAt.present ? data.hatchedAt.value : this.hatchedAt,
      feedCount: data.feedCount.present ? data.feedCount.value : this.feedCount,
      lastOpenDay:
          data.lastOpenDay.present ? data.lastOpenDay.value : this.lastOpenDay,
      lastFedDay:
          data.lastFedDay.present ? data.lastFedDay.value : this.lastFedDay,
      lastSadPushAt: data.lastSadPushAt.present
          ? data.lastSadPushAt.value
          : this.lastSadPushAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pet(')
          ..write('id: $id, ')
          ..write('form: $form, ')
          ..write('mood: $mood, ')
          ..write('skin: $skin, ')
          ..write('hatchedAt: $hatchedAt, ')
          ..write('feedCount: $feedCount, ')
          ..write('lastOpenDay: $lastOpenDay, ')
          ..write('lastFedDay: $lastFedDay, ')
          ..write('lastSadPushAt: $lastSadPushAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, form, mood, skin, hatchedAt, feedCount,
      lastOpenDay, lastFedDay, lastSadPushAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          other.id == this.id &&
          other.form == this.form &&
          other.mood == this.mood &&
          other.skin == this.skin &&
          other.hatchedAt == this.hatchedAt &&
          other.feedCount == this.feedCount &&
          other.lastOpenDay == this.lastOpenDay &&
          other.lastFedDay == this.lastFedDay &&
          other.lastSadPushAt == this.lastSadPushAt);
}

class PetsCompanion extends UpdateCompanion<Pet> {
  final Value<String> id;
  final Value<String> form;
  final Value<String> mood;
  final Value<String> skin;
  final Value<int?> hatchedAt;
  final Value<int> feedCount;
  final Value<String?> lastOpenDay;
  final Value<String?> lastFedDay;
  final Value<int?> lastSadPushAt;
  final Value<int> rowid;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.form = const Value.absent(),
    this.mood = const Value.absent(),
    this.skin = const Value.absent(),
    this.hatchedAt = const Value.absent(),
    this.feedCount = const Value.absent(),
    this.lastOpenDay = const Value.absent(),
    this.lastFedDay = const Value.absent(),
    this.lastSadPushAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetsCompanion.insert({
    required String id,
    this.form = const Value.absent(),
    this.mood = const Value.absent(),
    this.skin = const Value.absent(),
    this.hatchedAt = const Value.absent(),
    this.feedCount = const Value.absent(),
    this.lastOpenDay = const Value.absent(),
    this.lastFedDay = const Value.absent(),
    this.lastSadPushAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Pet> custom({
    Expression<String>? id,
    Expression<String>? form,
    Expression<String>? mood,
    Expression<String>? skin,
    Expression<int>? hatchedAt,
    Expression<int>? feedCount,
    Expression<String>? lastOpenDay,
    Expression<String>? lastFedDay,
    Expression<int>? lastSadPushAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (form != null) 'form': form,
      if (mood != null) 'mood': mood,
      if (skin != null) 'skin': skin,
      if (hatchedAt != null) 'hatched_at': hatchedAt,
      if (feedCount != null) 'feed_count': feedCount,
      if (lastOpenDay != null) 'last_open_day': lastOpenDay,
      if (lastFedDay != null) 'last_fed_day': lastFedDay,
      if (lastSadPushAt != null) 'last_sad_push_at': lastSadPushAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? form,
      Value<String>? mood,
      Value<String>? skin,
      Value<int?>? hatchedAt,
      Value<int>? feedCount,
      Value<String?>? lastOpenDay,
      Value<String?>? lastFedDay,
      Value<int?>? lastSadPushAt,
      Value<int>? rowid}) {
    return PetsCompanion(
      id: id ?? this.id,
      form: form ?? this.form,
      mood: mood ?? this.mood,
      skin: skin ?? this.skin,
      hatchedAt: hatchedAt ?? this.hatchedAt,
      feedCount: feedCount ?? this.feedCount,
      lastOpenDay: lastOpenDay ?? this.lastOpenDay,
      lastFedDay: lastFedDay ?? this.lastFedDay,
      lastSadPushAt: lastSadPushAt ?? this.lastSadPushAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (skin.present) {
      map['skin'] = Variable<String>(skin.value);
    }
    if (hatchedAt.present) {
      map['hatched_at'] = Variable<int>(hatchedAt.value);
    }
    if (feedCount.present) {
      map['feed_count'] = Variable<int>(feedCount.value);
    }
    if (lastOpenDay.present) {
      map['last_open_day'] = Variable<String>(lastOpenDay.value);
    }
    if (lastFedDay.present) {
      map['last_fed_day'] = Variable<String>(lastFedDay.value);
    }
    if (lastSadPushAt.present) {
      map['last_sad_push_at'] = Variable<int>(lastSadPushAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetsCompanion(')
          ..write('id: $id, ')
          ..write('form: $form, ')
          ..write('mood: $mood, ')
          ..write('skin: $skin, ')
          ..write('hatchedAt: $hatchedAt, ')
          ..write('feedCount: $feedCount, ')
          ..write('lastOpenDay: $lastOpenDay, ')
          ..write('lastFedDay: $lastFedDay, ')
          ..write('lastSadPushAt: $lastSadPushAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetSkinsTable extends PetSkins with TableInfo<$PetSkinsTable, PetSkin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetSkinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownedMeta = const VerificationMeta('owned');
  @override
  late final GeneratedColumn<bool> owned = GeneratedColumn<bool>(
      'owned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("owned" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, owned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_skins';
  @override
  VerificationContext validateIntegrity(Insertable<PetSkin> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owned')) {
      context.handle(
          _ownedMeta, owned.isAcceptableOrUnknown(data['owned']!, _ownedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PetSkin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetSkin(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      owned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}owned'])!,
    );
  }

  @override
  $PetSkinsTable createAlias(String alias) {
    return $PetSkinsTable(attachedDatabase, alias);
  }
}

class PetSkin extends DataClass implements Insertable<PetSkin> {
  final String id;
  final bool owned;
  const PetSkin({required this.id, required this.owned});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owned'] = Variable<bool>(owned);
    return map;
  }

  PetSkinsCompanion toCompanion(bool nullToAbsent) {
    return PetSkinsCompanion(
      id: Value(id),
      owned: Value(owned),
    );
  }

  factory PetSkin.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetSkin(
      id: serializer.fromJson<String>(json['id']),
      owned: serializer.fromJson<bool>(json['owned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'owned': serializer.toJson<bool>(owned),
    };
  }

  PetSkin copyWith({String? id, bool? owned}) => PetSkin(
        id: id ?? this.id,
        owned: owned ?? this.owned,
      );
  PetSkin copyWithCompanion(PetSkinsCompanion data) {
    return PetSkin(
      id: data.id.present ? data.id.value : this.id,
      owned: data.owned.present ? data.owned.value : this.owned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetSkin(')
          ..write('id: $id, ')
          ..write('owned: $owned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, owned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetSkin && other.id == this.id && other.owned == this.owned);
}

class PetSkinsCompanion extends UpdateCompanion<PetSkin> {
  final Value<String> id;
  final Value<bool> owned;
  final Value<int> rowid;
  const PetSkinsCompanion({
    this.id = const Value.absent(),
    this.owned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetSkinsCompanion.insert({
    required String id,
    this.owned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PetSkin> custom({
    Expression<String>? id,
    Expression<bool>? owned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owned != null) 'owned': owned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetSkinsCompanion copyWith(
      {Value<String>? id, Value<bool>? owned, Value<int>? rowid}) {
    return PetSkinsCompanion(
      id: id ?? this.id,
      owned: owned ?? this.owned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (owned.present) {
      map['owned'] = Variable<bool>(owned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetSkinsCompanion(')
          ..write('id: $id, ')
          ..write('owned: $owned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestsDailyTable extends QuestsDaily
    with TableInfo<$QuestsDailyTable, QuestsDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questIdMeta =
      const VerificationMeta('questId');
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
      'quest_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
      'day_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _claimedMeta =
      const VerificationMeta('claimed');
  @override
  late final GeneratedColumn<bool> claimed = GeneratedColumn<bool>(
      'claimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("claimed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, questId, dayKey, progress, claimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests_daily';
  @override
  VerificationContext validateIntegrity(Insertable<QuestsDailyData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quest_id')) {
      context.handle(_questIdMeta,
          questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta));
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('day_key')) {
      context.handle(_dayKeyMeta,
          dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta));
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('claimed')) {
      context.handle(_claimedMeta,
          claimed.isAcceptableOrUnknown(data['claimed']!, _claimedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestsDailyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestsDailyData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      questId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quest_id'])!,
      dayKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day_key'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      claimed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}claimed'])!,
    );
  }

  @override
  $QuestsDailyTable createAlias(String alias) {
    return $QuestsDailyTable(attachedDatabase, alias);
  }
}

class QuestsDailyData extends DataClass implements Insertable<QuestsDailyData> {
  final String id;
  final String questId;
  final String dayKey;
  final int progress;
  final bool claimed;
  const QuestsDailyData(
      {required this.id,
      required this.questId,
      required this.dayKey,
      required this.progress,
      required this.claimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quest_id'] = Variable<String>(questId);
    map['day_key'] = Variable<String>(dayKey);
    map['progress'] = Variable<int>(progress);
    map['claimed'] = Variable<bool>(claimed);
    return map;
  }

  QuestsDailyCompanion toCompanion(bool nullToAbsent) {
    return QuestsDailyCompanion(
      id: Value(id),
      questId: Value(questId),
      dayKey: Value(dayKey),
      progress: Value(progress),
      claimed: Value(claimed),
    );
  }

  factory QuestsDailyData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestsDailyData(
      id: serializer.fromJson<String>(json['id']),
      questId: serializer.fromJson<String>(json['questId']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      progress: serializer.fromJson<int>(json['progress']),
      claimed: serializer.fromJson<bool>(json['claimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questId': serializer.toJson<String>(questId),
      'dayKey': serializer.toJson<String>(dayKey),
      'progress': serializer.toJson<int>(progress),
      'claimed': serializer.toJson<bool>(claimed),
    };
  }

  QuestsDailyData copyWith(
          {String? id,
          String? questId,
          String? dayKey,
          int? progress,
          bool? claimed}) =>
      QuestsDailyData(
        id: id ?? this.id,
        questId: questId ?? this.questId,
        dayKey: dayKey ?? this.dayKey,
        progress: progress ?? this.progress,
        claimed: claimed ?? this.claimed,
      );
  QuestsDailyData copyWithCompanion(QuestsDailyCompanion data) {
    return QuestsDailyData(
      id: data.id.present ? data.id.value : this.id,
      questId: data.questId.present ? data.questId.value : this.questId,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      progress: data.progress.present ? data.progress.value : this.progress,
      claimed: data.claimed.present ? data.claimed.value : this.claimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestsDailyData(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('dayKey: $dayKey, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questId, dayKey, progress, claimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestsDailyData &&
          other.id == this.id &&
          other.questId == this.questId &&
          other.dayKey == this.dayKey &&
          other.progress == this.progress &&
          other.claimed == this.claimed);
}

class QuestsDailyCompanion extends UpdateCompanion<QuestsDailyData> {
  final Value<String> id;
  final Value<String> questId;
  final Value<String> dayKey;
  final Value<int> progress;
  final Value<bool> claimed;
  final Value<int> rowid;
  const QuestsDailyCompanion({
    this.id = const Value.absent(),
    this.questId = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestsDailyCompanion.insert({
    required String id,
    required String questId,
    required String dayKey,
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        questId = Value(questId),
        dayKey = Value(dayKey);
  static Insertable<QuestsDailyData> custom({
    Expression<String>? id,
    Expression<String>? questId,
    Expression<String>? dayKey,
    Expression<int>? progress,
    Expression<bool>? claimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questId != null) 'quest_id': questId,
      if (dayKey != null) 'day_key': dayKey,
      if (progress != null) 'progress': progress,
      if (claimed != null) 'claimed': claimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestsDailyCompanion copyWith(
      {Value<String>? id,
      Value<String>? questId,
      Value<String>? dayKey,
      Value<int>? progress,
      Value<bool>? claimed,
      Value<int>? rowid}) {
    return QuestsDailyCompanion(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      dayKey: dayKey ?? this.dayKey,
      progress: progress ?? this.progress,
      claimed: claimed ?? this.claimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (claimed.present) {
      map['claimed'] = Variable<bool>(claimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsDailyCompanion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('dayKey: $dayKey, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestsWeeklyTable extends QuestsWeekly
    with TableInfo<$QuestsWeeklyTable, QuestsWeeklyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsWeeklyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questIdMeta =
      const VerificationMeta('questId');
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
      'quest_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekKeyMeta =
      const VerificationMeta('weekKey');
  @override
  late final GeneratedColumn<String> weekKey = GeneratedColumn<String>(
      'week_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _claimedMeta =
      const VerificationMeta('claimed');
  @override
  late final GeneratedColumn<bool> claimed = GeneratedColumn<bool>(
      'claimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("claimed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, questId, weekKey, progress, claimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests_weekly';
  @override
  VerificationContext validateIntegrity(Insertable<QuestsWeeklyData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quest_id')) {
      context.handle(_questIdMeta,
          questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta));
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('week_key')) {
      context.handle(_weekKeyMeta,
          weekKey.isAcceptableOrUnknown(data['week_key']!, _weekKeyMeta));
    } else if (isInserting) {
      context.missing(_weekKeyMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('claimed')) {
      context.handle(_claimedMeta,
          claimed.isAcceptableOrUnknown(data['claimed']!, _claimedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestsWeeklyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestsWeeklyData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      questId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quest_id'])!,
      weekKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}week_key'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      claimed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}claimed'])!,
    );
  }

  @override
  $QuestsWeeklyTable createAlias(String alias) {
    return $QuestsWeeklyTable(attachedDatabase, alias);
  }
}

class QuestsWeeklyData extends DataClass
    implements Insertable<QuestsWeeklyData> {
  final String id;
  final String questId;
  final String weekKey;
  final int progress;
  final bool claimed;
  const QuestsWeeklyData(
      {required this.id,
      required this.questId,
      required this.weekKey,
      required this.progress,
      required this.claimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quest_id'] = Variable<String>(questId);
    map['week_key'] = Variable<String>(weekKey);
    map['progress'] = Variable<int>(progress);
    map['claimed'] = Variable<bool>(claimed);
    return map;
  }

  QuestsWeeklyCompanion toCompanion(bool nullToAbsent) {
    return QuestsWeeklyCompanion(
      id: Value(id),
      questId: Value(questId),
      weekKey: Value(weekKey),
      progress: Value(progress),
      claimed: Value(claimed),
    );
  }

  factory QuestsWeeklyData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestsWeeklyData(
      id: serializer.fromJson<String>(json['id']),
      questId: serializer.fromJson<String>(json['questId']),
      weekKey: serializer.fromJson<String>(json['weekKey']),
      progress: serializer.fromJson<int>(json['progress']),
      claimed: serializer.fromJson<bool>(json['claimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questId': serializer.toJson<String>(questId),
      'weekKey': serializer.toJson<String>(weekKey),
      'progress': serializer.toJson<int>(progress),
      'claimed': serializer.toJson<bool>(claimed),
    };
  }

  QuestsWeeklyData copyWith(
          {String? id,
          String? questId,
          String? weekKey,
          int? progress,
          bool? claimed}) =>
      QuestsWeeklyData(
        id: id ?? this.id,
        questId: questId ?? this.questId,
        weekKey: weekKey ?? this.weekKey,
        progress: progress ?? this.progress,
        claimed: claimed ?? this.claimed,
      );
  QuestsWeeklyData copyWithCompanion(QuestsWeeklyCompanion data) {
    return QuestsWeeklyData(
      id: data.id.present ? data.id.value : this.id,
      questId: data.questId.present ? data.questId.value : this.questId,
      weekKey: data.weekKey.present ? data.weekKey.value : this.weekKey,
      progress: data.progress.present ? data.progress.value : this.progress,
      claimed: data.claimed.present ? data.claimed.value : this.claimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestsWeeklyData(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('weekKey: $weekKey, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questId, weekKey, progress, claimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestsWeeklyData &&
          other.id == this.id &&
          other.questId == this.questId &&
          other.weekKey == this.weekKey &&
          other.progress == this.progress &&
          other.claimed == this.claimed);
}

class QuestsWeeklyCompanion extends UpdateCompanion<QuestsWeeklyData> {
  final Value<String> id;
  final Value<String> questId;
  final Value<String> weekKey;
  final Value<int> progress;
  final Value<bool> claimed;
  final Value<int> rowid;
  const QuestsWeeklyCompanion({
    this.id = const Value.absent(),
    this.questId = const Value.absent(),
    this.weekKey = const Value.absent(),
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestsWeeklyCompanion.insert({
    required String id,
    required String questId,
    required String weekKey,
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        questId = Value(questId),
        weekKey = Value(weekKey);
  static Insertable<QuestsWeeklyData> custom({
    Expression<String>? id,
    Expression<String>? questId,
    Expression<String>? weekKey,
    Expression<int>? progress,
    Expression<bool>? claimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questId != null) 'quest_id': questId,
      if (weekKey != null) 'week_key': weekKey,
      if (progress != null) 'progress': progress,
      if (claimed != null) 'claimed': claimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestsWeeklyCompanion copyWith(
      {Value<String>? id,
      Value<String>? questId,
      Value<String>? weekKey,
      Value<int>? progress,
      Value<bool>? claimed,
      Value<int>? rowid}) {
    return QuestsWeeklyCompanion(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      weekKey: weekKey ?? this.weekKey,
      progress: progress ?? this.progress,
      claimed: claimed ?? this.claimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (weekKey.present) {
      map['week_key'] = Variable<String>(weekKey.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (claimed.present) {
      map['claimed'] = Variable<bool>(claimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsWeeklyCompanion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('weekKey: $weekKey, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChestsTable extends Chests with TableInfo<$ChestsTable, Chest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastOpenedDayMeta =
      const VerificationMeta('lastOpenedDay');
  @override
  late final GeneratedColumn<String> lastOpenedDay = GeneratedColumn<String>(
      'last_opened_day', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chainMeta = const VerificationMeta('chain');
  @override
  late final GeneratedColumn<int> chain = GeneratedColumn<int>(
      'chain', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalOpenedMeta =
      const VerificationMeta('totalOpened');
  @override
  late final GeneratedColumn<int> totalOpened = GeneratedColumn<int>(
      'total_opened', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, lastOpenedDay, chain, totalOpened];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chests';
  @override
  VerificationContext validateIntegrity(Insertable<Chest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('last_opened_day')) {
      context.handle(
          _lastOpenedDayMeta,
          lastOpenedDay.isAcceptableOrUnknown(
              data['last_opened_day']!, _lastOpenedDayMeta));
    }
    if (data.containsKey('chain')) {
      context.handle(
          _chainMeta, chain.isAcceptableOrUnknown(data['chain']!, _chainMeta));
    }
    if (data.containsKey('total_opened')) {
      context.handle(
          _totalOpenedMeta,
          totalOpened.isAcceptableOrUnknown(
              data['total_opened']!, _totalOpenedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lastOpenedDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_opened_day']),
      chain: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chain'])!,
      totalOpened: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_opened'])!,
    );
  }

  @override
  $ChestsTable createAlias(String alias) {
    return $ChestsTable(attachedDatabase, alias);
  }
}

class Chest extends DataClass implements Insertable<Chest> {
  final String id;
  final String? lastOpenedDay;
  final int chain;
  final int totalOpened;
  const Chest(
      {required this.id,
      this.lastOpenedDay,
      required this.chain,
      required this.totalOpened});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || lastOpenedDay != null) {
      map['last_opened_day'] = Variable<String>(lastOpenedDay);
    }
    map['chain'] = Variable<int>(chain);
    map['total_opened'] = Variable<int>(totalOpened);
    return map;
  }

  ChestsCompanion toCompanion(bool nullToAbsent) {
    return ChestsCompanion(
      id: Value(id),
      lastOpenedDay: lastOpenedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedDay),
      chain: Value(chain),
      totalOpened: Value(totalOpened),
    );
  }

  factory Chest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chest(
      id: serializer.fromJson<String>(json['id']),
      lastOpenedDay: serializer.fromJson<String?>(json['lastOpenedDay']),
      chain: serializer.fromJson<int>(json['chain']),
      totalOpened: serializer.fromJson<int>(json['totalOpened']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lastOpenedDay': serializer.toJson<String?>(lastOpenedDay),
      'chain': serializer.toJson<int>(chain),
      'totalOpened': serializer.toJson<int>(totalOpened),
    };
  }

  Chest copyWith(
          {String? id,
          Value<String?> lastOpenedDay = const Value.absent(),
          int? chain,
          int? totalOpened}) =>
      Chest(
        id: id ?? this.id,
        lastOpenedDay:
            lastOpenedDay.present ? lastOpenedDay.value : this.lastOpenedDay,
        chain: chain ?? this.chain,
        totalOpened: totalOpened ?? this.totalOpened,
      );
  Chest copyWithCompanion(ChestsCompanion data) {
    return Chest(
      id: data.id.present ? data.id.value : this.id,
      lastOpenedDay: data.lastOpenedDay.present
          ? data.lastOpenedDay.value
          : this.lastOpenedDay,
      chain: data.chain.present ? data.chain.value : this.chain,
      totalOpened:
          data.totalOpened.present ? data.totalOpened.value : this.totalOpened,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chest(')
          ..write('id: $id, ')
          ..write('lastOpenedDay: $lastOpenedDay, ')
          ..write('chain: $chain, ')
          ..write('totalOpened: $totalOpened')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastOpenedDay, chain, totalOpened);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chest &&
          other.id == this.id &&
          other.lastOpenedDay == this.lastOpenedDay &&
          other.chain == this.chain &&
          other.totalOpened == this.totalOpened);
}

class ChestsCompanion extends UpdateCompanion<Chest> {
  final Value<String> id;
  final Value<String?> lastOpenedDay;
  final Value<int> chain;
  final Value<int> totalOpened;
  final Value<int> rowid;
  const ChestsCompanion({
    this.id = const Value.absent(),
    this.lastOpenedDay = const Value.absent(),
    this.chain = const Value.absent(),
    this.totalOpened = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChestsCompanion.insert({
    required String id,
    this.lastOpenedDay = const Value.absent(),
    this.chain = const Value.absent(),
    this.totalOpened = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Chest> custom({
    Expression<String>? id,
    Expression<String>? lastOpenedDay,
    Expression<int>? chain,
    Expression<int>? totalOpened,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastOpenedDay != null) 'last_opened_day': lastOpenedDay,
      if (chain != null) 'chain': chain,
      if (totalOpened != null) 'total_opened': totalOpened,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChestsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? lastOpenedDay,
      Value<int>? chain,
      Value<int>? totalOpened,
      Value<int>? rowid}) {
    return ChestsCompanion(
      id: id ?? this.id,
      lastOpenedDay: lastOpenedDay ?? this.lastOpenedDay,
      chain: chain ?? this.chain,
      totalOpened: totalOpened ?? this.totalOpened,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lastOpenedDay.present) {
      map['last_opened_day'] = Variable<String>(lastOpenedDay.value);
    }
    if (chain.present) {
      map['chain'] = Variable<int>(chain.value);
    }
    if (totalOpened.present) {
      map['total_opened'] = Variable<int>(totalOpened.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChestsCompanion(')
          ..write('id: $id, ')
          ..write('lastOpenedDay: $lastOpenedDay, ')
          ..write('chain: $chain, ')
          ..write('totalOpened: $totalOpened, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoloSetsTable extends HoloSets with TableInfo<$HoloSetsTable, HoloSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoloSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameKeyMeta =
      const VerificationMeta('nameKey');
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
      'name_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nameKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holo_sets';
  @override
  VerificationContext validateIntegrity(Insertable<HoloSet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(_nameKeyMeta,
          nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta));
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HoloSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HoloSet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nameKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_key'])!,
    );
  }

  @override
  $HoloSetsTable createAlias(String alias) {
    return $HoloSetsTable(attachedDatabase, alias);
  }
}

class HoloSet extends DataClass implements Insertable<HoloSet> {
  final String id;
  final String nameKey;
  const HoloSet({required this.id, required this.nameKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_key'] = Variable<String>(nameKey);
    return map;
  }

  HoloSetsCompanion toCompanion(bool nullToAbsent) {
    return HoloSetsCompanion(
      id: Value(id),
      nameKey: Value(nameKey),
    );
  }

  factory HoloSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HoloSet(
      id: serializer.fromJson<String>(json['id']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameKey': serializer.toJson<String>(nameKey),
    };
  }

  HoloSet copyWith({String? id, String? nameKey}) => HoloSet(
        id: id ?? this.id,
        nameKey: nameKey ?? this.nameKey,
      );
  HoloSet copyWithCompanion(HoloSetsCompanion data) {
    return HoloSet(
      id: data.id.present ? data.id.value : this.id,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HoloSet(')
          ..write('id: $id, ')
          ..write('nameKey: $nameKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HoloSet &&
          other.id == this.id &&
          other.nameKey == this.nameKey);
}

class HoloSetsCompanion extends UpdateCompanion<HoloSet> {
  final Value<String> id;
  final Value<String> nameKey;
  final Value<int> rowid;
  const HoloSetsCompanion({
    this.id = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HoloSetsCompanion.insert({
    required String id,
    required String nameKey,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nameKey = Value(nameKey);
  static Insertable<HoloSet> custom({
    Expression<String>? id,
    Expression<String>? nameKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameKey != null) 'name_key': nameKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HoloSetsCompanion copyWith(
      {Value<String>? id, Value<String>? nameKey, Value<int>? rowid}) {
    return HoloSetsCompanion(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoloSetsCompanion(')
          ..write('id: $id, ')
          ..write('nameKey: $nameKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoloCardsTable extends HoloCards
    with TableInfo<$HoloCardsTable, HoloCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoloCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<String> setId = GeneratedColumn<String>(
      'set_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
      'rarity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameKeyMeta =
      const VerificationMeta('nameKey');
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
      'name_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _condKeyMeta =
      const VerificationMeta('condKey');
  @override
  late final GeneratedColumn<String> condKey = GeneratedColumn<String>(
      'cond_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loreKeyMeta =
      const VerificationMeta('loreKey');
  @override
  late final GeneratedColumn<String> loreKey = GeneratedColumn<String>(
      'lore_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, setId, rarity, nameKey, condKey, loreKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holo_cards';
  @override
  VerificationContext validateIntegrity(Insertable<HoloCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('set_id')) {
      context.handle(
          _setIdMeta, setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta));
    } else if (isInserting) {
      context.missing(_setIdMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(_nameKeyMeta,
          nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta));
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('cond_key')) {
      context.handle(_condKeyMeta,
          condKey.isAcceptableOrUnknown(data['cond_key']!, _condKeyMeta));
    } else if (isInserting) {
      context.missing(_condKeyMeta);
    }
    if (data.containsKey('lore_key')) {
      context.handle(_loreKeyMeta,
          loreKey.isAcceptableOrUnknown(data['lore_key']!, _loreKeyMeta));
    } else if (isInserting) {
      context.missing(_loreKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HoloCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HoloCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      setId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_id'])!,
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity'])!,
      nameKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_key'])!,
      condKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cond_key'])!,
      loreKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lore_key'])!,
    );
  }

  @override
  $HoloCardsTable createAlias(String alias) {
    return $HoloCardsTable(attachedDatabase, alias);
  }
}

class HoloCard extends DataClass implements Insertable<HoloCard> {
  final String id;
  final String setId;
  final String rarity;
  final String nameKey;
  final String condKey;
  final String loreKey;
  const HoloCard(
      {required this.id,
      required this.setId,
      required this.rarity,
      required this.nameKey,
      required this.condKey,
      required this.loreKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['set_id'] = Variable<String>(setId);
    map['rarity'] = Variable<String>(rarity);
    map['name_key'] = Variable<String>(nameKey);
    map['cond_key'] = Variable<String>(condKey);
    map['lore_key'] = Variable<String>(loreKey);
    return map;
  }

  HoloCardsCompanion toCompanion(bool nullToAbsent) {
    return HoloCardsCompanion(
      id: Value(id),
      setId: Value(setId),
      rarity: Value(rarity),
      nameKey: Value(nameKey),
      condKey: Value(condKey),
      loreKey: Value(loreKey),
    );
  }

  factory HoloCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HoloCard(
      id: serializer.fromJson<String>(json['id']),
      setId: serializer.fromJson<String>(json['setId']),
      rarity: serializer.fromJson<String>(json['rarity']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      condKey: serializer.fromJson<String>(json['condKey']),
      loreKey: serializer.fromJson<String>(json['loreKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'setId': serializer.toJson<String>(setId),
      'rarity': serializer.toJson<String>(rarity),
      'nameKey': serializer.toJson<String>(nameKey),
      'condKey': serializer.toJson<String>(condKey),
      'loreKey': serializer.toJson<String>(loreKey),
    };
  }

  HoloCard copyWith(
          {String? id,
          String? setId,
          String? rarity,
          String? nameKey,
          String? condKey,
          String? loreKey}) =>
      HoloCard(
        id: id ?? this.id,
        setId: setId ?? this.setId,
        rarity: rarity ?? this.rarity,
        nameKey: nameKey ?? this.nameKey,
        condKey: condKey ?? this.condKey,
        loreKey: loreKey ?? this.loreKey,
      );
  HoloCard copyWithCompanion(HoloCardsCompanion data) {
    return HoloCard(
      id: data.id.present ? data.id.value : this.id,
      setId: data.setId.present ? data.setId.value : this.setId,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      condKey: data.condKey.present ? data.condKey.value : this.condKey,
      loreKey: data.loreKey.present ? data.loreKey.value : this.loreKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HoloCard(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('rarity: $rarity, ')
          ..write('nameKey: $nameKey, ')
          ..write('condKey: $condKey, ')
          ..write('loreKey: $loreKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, setId, rarity, nameKey, condKey, loreKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HoloCard &&
          other.id == this.id &&
          other.setId == this.setId &&
          other.rarity == this.rarity &&
          other.nameKey == this.nameKey &&
          other.condKey == this.condKey &&
          other.loreKey == this.loreKey);
}

class HoloCardsCompanion extends UpdateCompanion<HoloCard> {
  final Value<String> id;
  final Value<String> setId;
  final Value<String> rarity;
  final Value<String> nameKey;
  final Value<String> condKey;
  final Value<String> loreKey;
  final Value<int> rowid;
  const HoloCardsCompanion({
    this.id = const Value.absent(),
    this.setId = const Value.absent(),
    this.rarity = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.condKey = const Value.absent(),
    this.loreKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HoloCardsCompanion.insert({
    required String id,
    required String setId,
    required String rarity,
    required String nameKey,
    required String condKey,
    required String loreKey,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        setId = Value(setId),
        rarity = Value(rarity),
        nameKey = Value(nameKey),
        condKey = Value(condKey),
        loreKey = Value(loreKey);
  static Insertable<HoloCard> custom({
    Expression<String>? id,
    Expression<String>? setId,
    Expression<String>? rarity,
    Expression<String>? nameKey,
    Expression<String>? condKey,
    Expression<String>? loreKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setId != null) 'set_id': setId,
      if (rarity != null) 'rarity': rarity,
      if (nameKey != null) 'name_key': nameKey,
      if (condKey != null) 'cond_key': condKey,
      if (loreKey != null) 'lore_key': loreKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HoloCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? setId,
      Value<String>? rarity,
      Value<String>? nameKey,
      Value<String>? condKey,
      Value<String>? loreKey,
      Value<int>? rowid}) {
    return HoloCardsCompanion(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      rarity: rarity ?? this.rarity,
      nameKey: nameKey ?? this.nameKey,
      condKey: condKey ?? this.condKey,
      loreKey: loreKey ?? this.loreKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (setId.present) {
      map['set_id'] = Variable<String>(setId.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (condKey.present) {
      map['cond_key'] = Variable<String>(condKey.value);
    }
    if (loreKey.present) {
      map['lore_key'] = Variable<String>(loreKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoloCardsCompanion(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('rarity: $rarity, ')
          ..write('nameKey: $nameKey, ')
          ..write('condKey: $condKey, ')
          ..write('loreKey: $loreKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoloOwnedTable extends HoloOwned
    with TableInfo<$HoloOwnedTable, HoloOwnedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoloOwnedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _copiesMeta = const VerificationMeta('copies');
  @override
  late final GeneratedColumn<int> copies = GeneratedColumn<int>(
      'copies', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _firstOwnedAtMeta =
      const VerificationMeta('firstOwnedAt');
  @override
  late final GeneratedColumn<int> firstOwnedAt = GeneratedColumn<int>(
      'first_owned_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [cardId, copies, firstOwnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holo_owned';
  @override
  VerificationContext validateIntegrity(Insertable<HoloOwnedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('copies')) {
      context.handle(_copiesMeta,
          copies.isAcceptableOrUnknown(data['copies']!, _copiesMeta));
    }
    if (data.containsKey('first_owned_at')) {
      context.handle(
          _firstOwnedAtMeta,
          firstOwnedAt.isAcceptableOrUnknown(
              data['first_owned_at']!, _firstOwnedAtMeta));
    } else if (isInserting) {
      context.missing(_firstOwnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  HoloOwnedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HoloOwnedData(
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      copies: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}copies'])!,
      firstOwnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}first_owned_at'])!,
    );
  }

  @override
  $HoloOwnedTable createAlias(String alias) {
    return $HoloOwnedTable(attachedDatabase, alias);
  }
}

class HoloOwnedData extends DataClass implements Insertable<HoloOwnedData> {
  final String cardId;
  final int copies;
  final int firstOwnedAt;
  const HoloOwnedData(
      {required this.cardId, required this.copies, required this.firstOwnedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['copies'] = Variable<int>(copies);
    map['first_owned_at'] = Variable<int>(firstOwnedAt);
    return map;
  }

  HoloOwnedCompanion toCompanion(bool nullToAbsent) {
    return HoloOwnedCompanion(
      cardId: Value(cardId),
      copies: Value(copies),
      firstOwnedAt: Value(firstOwnedAt),
    );
  }

  factory HoloOwnedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HoloOwnedData(
      cardId: serializer.fromJson<String>(json['cardId']),
      copies: serializer.fromJson<int>(json['copies']),
      firstOwnedAt: serializer.fromJson<int>(json['firstOwnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'copies': serializer.toJson<int>(copies),
      'firstOwnedAt': serializer.toJson<int>(firstOwnedAt),
    };
  }

  HoloOwnedData copyWith({String? cardId, int? copies, int? firstOwnedAt}) =>
      HoloOwnedData(
        cardId: cardId ?? this.cardId,
        copies: copies ?? this.copies,
        firstOwnedAt: firstOwnedAt ?? this.firstOwnedAt,
      );
  HoloOwnedData copyWithCompanion(HoloOwnedCompanion data) {
    return HoloOwnedData(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      copies: data.copies.present ? data.copies.value : this.copies,
      firstOwnedAt: data.firstOwnedAt.present
          ? data.firstOwnedAt.value
          : this.firstOwnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HoloOwnedData(')
          ..write('cardId: $cardId, ')
          ..write('copies: $copies, ')
          ..write('firstOwnedAt: $firstOwnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, copies, firstOwnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HoloOwnedData &&
          other.cardId == this.cardId &&
          other.copies == this.copies &&
          other.firstOwnedAt == this.firstOwnedAt);
}

class HoloOwnedCompanion extends UpdateCompanion<HoloOwnedData> {
  final Value<String> cardId;
  final Value<int> copies;
  final Value<int> firstOwnedAt;
  final Value<int> rowid;
  const HoloOwnedCompanion({
    this.cardId = const Value.absent(),
    this.copies = const Value.absent(),
    this.firstOwnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HoloOwnedCompanion.insert({
    required String cardId,
    this.copies = const Value.absent(),
    required int firstOwnedAt,
    this.rowid = const Value.absent(),
  })  : cardId = Value(cardId),
        firstOwnedAt = Value(firstOwnedAt);
  static Insertable<HoloOwnedData> custom({
    Expression<String>? cardId,
    Expression<int>? copies,
    Expression<int>? firstOwnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (copies != null) 'copies': copies,
      if (firstOwnedAt != null) 'first_owned_at': firstOwnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HoloOwnedCompanion copyWith(
      {Value<String>? cardId,
      Value<int>? copies,
      Value<int>? firstOwnedAt,
      Value<int>? rowid}) {
    return HoloOwnedCompanion(
      cardId: cardId ?? this.cardId,
      copies: copies ?? this.copies,
      firstOwnedAt: firstOwnedAt ?? this.firstOwnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (copies.present) {
      map['copies'] = Variable<int>(copies.value);
    }
    if (firstOwnedAt.present) {
      map['first_owned_at'] = Variable<int>(firstOwnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoloOwnedCompanion(')
          ..write('cardId: $cardId, ')
          ..write('copies: $copies, ')
          ..write('firstOwnedAt: $firstOwnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsCacheTable extends EventsCache
    with TableInfo<$EventsCacheTable, EventsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleKeyMeta =
      const VerificationMeta('titleKey');
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
      'title_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bannerKeyMeta =
      const VerificationMeta('bannerKey');
  @override
  late final GeneratedColumn<String> bannerKey = GeneratedColumn<String>(
      'banner_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startsAtMeta =
      const VerificationMeta('startsAt');
  @override
  late final GeneratedColumn<int> startsAt = GeneratedColumn<int>(
      'starts_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<int> endsAt = GeneratedColumn<int>(
      'ends_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _questsJsonMeta =
      const VerificationMeta('questsJson');
  @override
  late final GeneratedColumn<String> questsJson = GeneratedColumn<String>(
      'quests_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rewardsJsonMeta =
      const VerificationMeta('rewardsJson');
  @override
  late final GeneratedColumn<String> rewardsJson = GeneratedColumn<String>(
      'rewards_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rulesKeyMeta =
      const VerificationMeta('rulesKey');
  @override
  late final GeneratedColumn<String> rulesKey = GeneratedColumn<String>(
      'rules_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        titleKey,
        bannerKey,
        startsAt,
        endsAt,
        questsJson,
        rewardsJson,
        rulesKey,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events_cache';
  @override
  VerificationContext validateIntegrity(Insertable<EventsCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(_titleKeyMeta,
          titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta));
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('banner_key')) {
      context.handle(_bannerKeyMeta,
          bannerKey.isAcceptableOrUnknown(data['banner_key']!, _bannerKeyMeta));
    } else if (isInserting) {
      context.missing(_bannerKeyMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(_startsAtMeta,
          startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta));
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(_endsAtMeta,
          endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta));
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    if (data.containsKey('quests_json')) {
      context.handle(
          _questsJsonMeta,
          questsJson.isAcceptableOrUnknown(
              data['quests_json']!, _questsJsonMeta));
    } else if (isInserting) {
      context.missing(_questsJsonMeta);
    }
    if (data.containsKey('rewards_json')) {
      context.handle(
          _rewardsJsonMeta,
          rewardsJson.isAcceptableOrUnknown(
              data['rewards_json']!, _rewardsJsonMeta));
    } else if (isInserting) {
      context.missing(_rewardsJsonMeta);
    }
    if (data.containsKey('rules_key')) {
      context.handle(_rulesKeyMeta,
          rulesKey.isAcceptableOrUnknown(data['rules_key']!, _rulesKeyMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventsCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      titleKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_key'])!,
      bannerKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}banner_key'])!,
      startsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}starts_at'])!,
      endsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ends_at'])!,
      questsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quests_json'])!,
      rewardsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rewards_json'])!,
      rulesKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rules_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $EventsCacheTable createAlias(String alias) {
    return $EventsCacheTable(attachedDatabase, alias);
  }
}

class EventsCacheData extends DataClass implements Insertable<EventsCacheData> {
  final String id;
  final String titleKey;
  final String bannerKey;
  final int startsAt;
  final int endsAt;
  final String questsJson;
  final String rewardsJson;
  final String rulesKey;
  final String status;
  const EventsCacheData(
      {required this.id,
      required this.titleKey,
      required this.bannerKey,
      required this.startsAt,
      required this.endsAt,
      required this.questsJson,
      required this.rewardsJson,
      required this.rulesKey,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_key'] = Variable<String>(titleKey);
    map['banner_key'] = Variable<String>(bannerKey);
    map['starts_at'] = Variable<int>(startsAt);
    map['ends_at'] = Variable<int>(endsAt);
    map['quests_json'] = Variable<String>(questsJson);
    map['rewards_json'] = Variable<String>(rewardsJson);
    map['rules_key'] = Variable<String>(rulesKey);
    map['status'] = Variable<String>(status);
    return map;
  }

  EventsCacheCompanion toCompanion(bool nullToAbsent) {
    return EventsCacheCompanion(
      id: Value(id),
      titleKey: Value(titleKey),
      bannerKey: Value(bannerKey),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
      questsJson: Value(questsJson),
      rewardsJson: Value(rewardsJson),
      rulesKey: Value(rulesKey),
      status: Value(status),
    );
  }

  factory EventsCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventsCacheData(
      id: serializer.fromJson<String>(json['id']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      bannerKey: serializer.fromJson<String>(json['bannerKey']),
      startsAt: serializer.fromJson<int>(json['startsAt']),
      endsAt: serializer.fromJson<int>(json['endsAt']),
      questsJson: serializer.fromJson<String>(json['questsJson']),
      rewardsJson: serializer.fromJson<String>(json['rewardsJson']),
      rulesKey: serializer.fromJson<String>(json['rulesKey']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleKey': serializer.toJson<String>(titleKey),
      'bannerKey': serializer.toJson<String>(bannerKey),
      'startsAt': serializer.toJson<int>(startsAt),
      'endsAt': serializer.toJson<int>(endsAt),
      'questsJson': serializer.toJson<String>(questsJson),
      'rewardsJson': serializer.toJson<String>(rewardsJson),
      'rulesKey': serializer.toJson<String>(rulesKey),
      'status': serializer.toJson<String>(status),
    };
  }

  EventsCacheData copyWith(
          {String? id,
          String? titleKey,
          String? bannerKey,
          int? startsAt,
          int? endsAt,
          String? questsJson,
          String? rewardsJson,
          String? rulesKey,
          String? status}) =>
      EventsCacheData(
        id: id ?? this.id,
        titleKey: titleKey ?? this.titleKey,
        bannerKey: bannerKey ?? this.bannerKey,
        startsAt: startsAt ?? this.startsAt,
        endsAt: endsAt ?? this.endsAt,
        questsJson: questsJson ?? this.questsJson,
        rewardsJson: rewardsJson ?? this.rewardsJson,
        rulesKey: rulesKey ?? this.rulesKey,
        status: status ?? this.status,
      );
  EventsCacheData copyWithCompanion(EventsCacheCompanion data) {
    return EventsCacheData(
      id: data.id.present ? data.id.value : this.id,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      bannerKey: data.bannerKey.present ? data.bannerKey.value : this.bannerKey,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      questsJson:
          data.questsJson.present ? data.questsJson.value : this.questsJson,
      rewardsJson:
          data.rewardsJson.present ? data.rewardsJson.value : this.rewardsJson,
      rulesKey: data.rulesKey.present ? data.rulesKey.value : this.rulesKey,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventsCacheData(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('bannerKey: $bannerKey, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('questsJson: $questsJson, ')
          ..write('rewardsJson: $rewardsJson, ')
          ..write('rulesKey: $rulesKey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titleKey, bannerKey, startsAt, endsAt,
      questsJson, rewardsJson, rulesKey, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventsCacheData &&
          other.id == this.id &&
          other.titleKey == this.titleKey &&
          other.bannerKey == this.bannerKey &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.questsJson == this.questsJson &&
          other.rewardsJson == this.rewardsJson &&
          other.rulesKey == this.rulesKey &&
          other.status == this.status);
}

class EventsCacheCompanion extends UpdateCompanion<EventsCacheData> {
  final Value<String> id;
  final Value<String> titleKey;
  final Value<String> bannerKey;
  final Value<int> startsAt;
  final Value<int> endsAt;
  final Value<String> questsJson;
  final Value<String> rewardsJson;
  final Value<String> rulesKey;
  final Value<String> status;
  final Value<int> rowid;
  const EventsCacheCompanion({
    this.id = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.bannerKey = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.questsJson = const Value.absent(),
    this.rewardsJson = const Value.absent(),
    this.rulesKey = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCacheCompanion.insert({
    required String id,
    required String titleKey,
    required String bannerKey,
    required int startsAt,
    required int endsAt,
    required String questsJson,
    required String rewardsJson,
    this.rulesKey = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        titleKey = Value(titleKey),
        bannerKey = Value(bannerKey),
        startsAt = Value(startsAt),
        endsAt = Value(endsAt),
        questsJson = Value(questsJson),
        rewardsJson = Value(rewardsJson);
  static Insertable<EventsCacheData> custom({
    Expression<String>? id,
    Expression<String>? titleKey,
    Expression<String>? bannerKey,
    Expression<int>? startsAt,
    Expression<int>? endsAt,
    Expression<String>? questsJson,
    Expression<String>? rewardsJson,
    Expression<String>? rulesKey,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleKey != null) 'title_key': titleKey,
      if (bannerKey != null) 'banner_key': bannerKey,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (questsJson != null) 'quests_json': questsJson,
      if (rewardsJson != null) 'rewards_json': rewardsJson,
      if (rulesKey != null) 'rules_key': rulesKey,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCacheCompanion copyWith(
      {Value<String>? id,
      Value<String>? titleKey,
      Value<String>? bannerKey,
      Value<int>? startsAt,
      Value<int>? endsAt,
      Value<String>? questsJson,
      Value<String>? rewardsJson,
      Value<String>? rulesKey,
      Value<String>? status,
      Value<int>? rowid}) {
    return EventsCacheCompanion(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      bannerKey: bannerKey ?? this.bannerKey,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      questsJson: questsJson ?? this.questsJson,
      rewardsJson: rewardsJson ?? this.rewardsJson,
      rulesKey: rulesKey ?? this.rulesKey,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (bannerKey.present) {
      map['banner_key'] = Variable<String>(bannerKey.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<int>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<int>(endsAt.value);
    }
    if (questsJson.present) {
      map['quests_json'] = Variable<String>(questsJson.value);
    }
    if (rewardsJson.present) {
      map['rewards_json'] = Variable<String>(rewardsJson.value);
    }
    if (rulesKey.present) {
      map['rules_key'] = Variable<String>(rulesKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCacheCompanion(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('bannerKey: $bannerKey, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('questsJson: $questsJson, ')
          ..write('rewardsJson: $rewardsJson, ')
          ..write('rulesKey: $rulesKey, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventQuestsTable extends EventQuests
    with TableInfo<$EventQuestsTable, EventQuest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventQuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
      'event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleKeyMeta =
      const VerificationMeta('titleKey');
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
      'title_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
      'target', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _claimedMeta =
      const VerificationMeta('claimed');
  @override
  late final GeneratedColumn<bool> claimed = GeneratedColumn<bool>(
      'claimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("claimed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, eventId, titleKey, target, progress, claimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_quests';
  @override
  VerificationContext validateIntegrity(Insertable<EventQuest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(_titleKeyMeta,
          titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta));
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta,
          target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('claimed')) {
      context.handle(_claimedMeta,
          claimed.isAcceptableOrUnknown(data['claimed']!, _claimedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventQuest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventQuest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_id'])!,
      titleKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_key'])!,
      target: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      claimed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}claimed'])!,
    );
  }

  @override
  $EventQuestsTable createAlias(String alias) {
    return $EventQuestsTable(attachedDatabase, alias);
  }
}

class EventQuest extends DataClass implements Insertable<EventQuest> {
  final String id;
  final String eventId;
  final String titleKey;
  final int target;
  final int progress;
  final bool claimed;
  const EventQuest(
      {required this.id,
      required this.eventId,
      required this.titleKey,
      required this.target,
      required this.progress,
      required this.claimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['title_key'] = Variable<String>(titleKey);
    map['target'] = Variable<int>(target);
    map['progress'] = Variable<int>(progress);
    map['claimed'] = Variable<bool>(claimed);
    return map;
  }

  EventQuestsCompanion toCompanion(bool nullToAbsent) {
    return EventQuestsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      titleKey: Value(titleKey),
      target: Value(target),
      progress: Value(progress),
      claimed: Value(claimed),
    );
  }

  factory EventQuest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventQuest(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      target: serializer.fromJson<int>(json['target']),
      progress: serializer.fromJson<int>(json['progress']),
      claimed: serializer.fromJson<bool>(json['claimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'titleKey': serializer.toJson<String>(titleKey),
      'target': serializer.toJson<int>(target),
      'progress': serializer.toJson<int>(progress),
      'claimed': serializer.toJson<bool>(claimed),
    };
  }

  EventQuest copyWith(
          {String? id,
          String? eventId,
          String? titleKey,
          int? target,
          int? progress,
          bool? claimed}) =>
      EventQuest(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        titleKey: titleKey ?? this.titleKey,
        target: target ?? this.target,
        progress: progress ?? this.progress,
        claimed: claimed ?? this.claimed,
      );
  EventQuest copyWithCompanion(EventQuestsCompanion data) {
    return EventQuest(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      target: data.target.present ? data.target.value : this.target,
      progress: data.progress.present ? data.progress.value : this.progress,
      claimed: data.claimed.present ? data.claimed.value : this.claimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventQuest(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('titleKey: $titleKey, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventId, titleKey, target, progress, claimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventQuest &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.titleKey == this.titleKey &&
          other.target == this.target &&
          other.progress == this.progress &&
          other.claimed == this.claimed);
}

class EventQuestsCompanion extends UpdateCompanion<EventQuest> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> titleKey;
  final Value<int> target;
  final Value<int> progress;
  final Value<bool> claimed;
  final Value<int> rowid;
  const EventQuestsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.target = const Value.absent(),
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventQuestsCompanion.insert({
    required String id,
    required String eventId,
    required String titleKey,
    required int target,
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eventId = Value(eventId),
        titleKey = Value(titleKey),
        target = Value(target);
  static Insertable<EventQuest> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? titleKey,
    Expression<int>? target,
    Expression<int>? progress,
    Expression<bool>? claimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (titleKey != null) 'title_key': titleKey,
      if (target != null) 'target': target,
      if (progress != null) 'progress': progress,
      if (claimed != null) 'claimed': claimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventQuestsCompanion copyWith(
      {Value<String>? id,
      Value<String>? eventId,
      Value<String>? titleKey,
      Value<int>? target,
      Value<int>? progress,
      Value<bool>? claimed,
      Value<int>? rowid}) {
    return EventQuestsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      titleKey: titleKey ?? this.titleKey,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      claimed: claimed ?? this.claimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (claimed.present) {
      map['claimed'] = Variable<bool>(claimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventQuestsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('titleKey: $titleKey, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BuddyCacheTable extends BuddyCache
    with TableInfo<$BuddyCacheTable, BuddyCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuddyCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inviteCodeMeta =
      const VerificationMeta('inviteCode');
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
      'invite_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buddyIdMeta =
      const VerificationMeta('buddyId');
  @override
  late final GeneratedColumn<String> buddyId = GeneratedColumn<String>(
      'buddy_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buddyNickMeta =
      const VerificationMeta('buddyNick');
  @override
  late final GeneratedColumn<String> buddyNick = GeneratedColumn<String>(
      'buddy_nick', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buddyGoalPercentMeta =
      const VerificationMeta('buddyGoalPercent');
  @override
  late final GeneratedColumn<double> buddyGoalPercent = GeneratedColumn<double>(
      'buddy_goal_percent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _buddyWeeklyPercentMeta =
      const VerificationMeta('buddyWeeklyPercent');
  @override
  late final GeneratedColumn<double> buddyWeeklyPercent =
      GeneratedColumn<double>('buddy_weekly_percent', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _buddyStreakMeta =
      const VerificationMeta('buddyStreak');
  @override
  late final GeneratedColumn<int> buddyStreak = GeneratedColumn<int>(
      'buddy_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _buddyRankMeta =
      const VerificationMeta('buddyRank');
  @override
  late final GeneratedColumn<String> buddyRank = GeneratedColumn<String>(
      'buddy_rank', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Bronze'));
  static const VerificationMeta _buddyWeeklyContribsMeta =
      const VerificationMeta('buddyWeeklyContribs');
  @override
  late final GeneratedColumn<int> buddyWeeklyContribs = GeneratedColumn<int>(
      'buddy_weekly_contribs', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pingsTodayMeta =
      const VerificationMeta('pingsToday');
  @override
  late final GeneratedColumn<int> pingsToday = GeneratedColumn<int>(
      'pings_today', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pingsDayMeta =
      const VerificationMeta('pingsDay');
  @override
  late final GeneratedColumn<String> pingsDay = GeneratedColumn<String>(
      'pings_day', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weekRewardClaimedMeta =
      const VerificationMeta('weekRewardClaimed');
  @override
  late final GeneratedColumn<bool> weekRewardClaimed = GeneratedColumn<bool>(
      'week_reward_claimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("week_reward_claimed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        inviteCode,
        buddyId,
        buddyNick,
        buddyGoalPercent,
        buddyWeeklyPercent,
        buddyStreak,
        buddyRank,
        buddyWeeklyContribs,
        pingsToday,
        pingsDay,
        weekRewardClaimed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buddy_cache';
  @override
  VerificationContext validateIntegrity(Insertable<BuddyCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invite_code')) {
      context.handle(
          _inviteCodeMeta,
          inviteCode.isAcceptableOrUnknown(
              data['invite_code']!, _inviteCodeMeta));
    }
    if (data.containsKey('buddy_id')) {
      context.handle(_buddyIdMeta,
          buddyId.isAcceptableOrUnknown(data['buddy_id']!, _buddyIdMeta));
    }
    if (data.containsKey('buddy_nick')) {
      context.handle(_buddyNickMeta,
          buddyNick.isAcceptableOrUnknown(data['buddy_nick']!, _buddyNickMeta));
    }
    if (data.containsKey('buddy_goal_percent')) {
      context.handle(
          _buddyGoalPercentMeta,
          buddyGoalPercent.isAcceptableOrUnknown(
              data['buddy_goal_percent']!, _buddyGoalPercentMeta));
    }
    if (data.containsKey('buddy_weekly_percent')) {
      context.handle(
          _buddyWeeklyPercentMeta,
          buddyWeeklyPercent.isAcceptableOrUnknown(
              data['buddy_weekly_percent']!, _buddyWeeklyPercentMeta));
    }
    if (data.containsKey('buddy_streak')) {
      context.handle(
          _buddyStreakMeta,
          buddyStreak.isAcceptableOrUnknown(
              data['buddy_streak']!, _buddyStreakMeta));
    }
    if (data.containsKey('buddy_rank')) {
      context.handle(_buddyRankMeta,
          buddyRank.isAcceptableOrUnknown(data['buddy_rank']!, _buddyRankMeta));
    }
    if (data.containsKey('buddy_weekly_contribs')) {
      context.handle(
          _buddyWeeklyContribsMeta,
          buddyWeeklyContribs.isAcceptableOrUnknown(
              data['buddy_weekly_contribs']!, _buddyWeeklyContribsMeta));
    }
    if (data.containsKey('pings_today')) {
      context.handle(
          _pingsTodayMeta,
          pingsToday.isAcceptableOrUnknown(
              data['pings_today']!, _pingsTodayMeta));
    }
    if (data.containsKey('pings_day')) {
      context.handle(_pingsDayMeta,
          pingsDay.isAcceptableOrUnknown(data['pings_day']!, _pingsDayMeta));
    }
    if (data.containsKey('week_reward_claimed')) {
      context.handle(
          _weekRewardClaimedMeta,
          weekRewardClaimed.isAcceptableOrUnknown(
              data['week_reward_claimed']!, _weekRewardClaimedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BuddyCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuddyCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inviteCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invite_code']),
      buddyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buddy_id']),
      buddyNick: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buddy_nick']),
      buddyGoalPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}buddy_goal_percent'])!,
      buddyWeeklyPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}buddy_weekly_percent'])!,
      buddyStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buddy_streak'])!,
      buddyRank: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buddy_rank'])!,
      buddyWeeklyContribs: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}buddy_weekly_contribs'])!,
      pingsToday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pings_today'])!,
      pingsDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pings_day']),
      weekRewardClaimed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}week_reward_claimed'])!,
    );
  }

  @override
  $BuddyCacheTable createAlias(String alias) {
    return $BuddyCacheTable(attachedDatabase, alias);
  }
}

class BuddyCacheData extends DataClass implements Insertable<BuddyCacheData> {
  final String id;
  final String? inviteCode;
  final String? buddyId;
  final String? buddyNick;
  final double buddyGoalPercent;
  final double buddyWeeklyPercent;
  final int buddyStreak;
  final String buddyRank;
  final int buddyWeeklyContribs;
  final int pingsToday;
  final String? pingsDay;
  final bool weekRewardClaimed;
  const BuddyCacheData(
      {required this.id,
      this.inviteCode,
      this.buddyId,
      this.buddyNick,
      required this.buddyGoalPercent,
      required this.buddyWeeklyPercent,
      required this.buddyStreak,
      required this.buddyRank,
      required this.buddyWeeklyContribs,
      required this.pingsToday,
      this.pingsDay,
      required this.weekRewardClaimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || inviteCode != null) {
      map['invite_code'] = Variable<String>(inviteCode);
    }
    if (!nullToAbsent || buddyId != null) {
      map['buddy_id'] = Variable<String>(buddyId);
    }
    if (!nullToAbsent || buddyNick != null) {
      map['buddy_nick'] = Variable<String>(buddyNick);
    }
    map['buddy_goal_percent'] = Variable<double>(buddyGoalPercent);
    map['buddy_weekly_percent'] = Variable<double>(buddyWeeklyPercent);
    map['buddy_streak'] = Variable<int>(buddyStreak);
    map['buddy_rank'] = Variable<String>(buddyRank);
    map['buddy_weekly_contribs'] = Variable<int>(buddyWeeklyContribs);
    map['pings_today'] = Variable<int>(pingsToday);
    if (!nullToAbsent || pingsDay != null) {
      map['pings_day'] = Variable<String>(pingsDay);
    }
    map['week_reward_claimed'] = Variable<bool>(weekRewardClaimed);
    return map;
  }

  BuddyCacheCompanion toCompanion(bool nullToAbsent) {
    return BuddyCacheCompanion(
      id: Value(id),
      inviteCode: inviteCode == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteCode),
      buddyId: buddyId == null && nullToAbsent
          ? const Value.absent()
          : Value(buddyId),
      buddyNick: buddyNick == null && nullToAbsent
          ? const Value.absent()
          : Value(buddyNick),
      buddyGoalPercent: Value(buddyGoalPercent),
      buddyWeeklyPercent: Value(buddyWeeklyPercent),
      buddyStreak: Value(buddyStreak),
      buddyRank: Value(buddyRank),
      buddyWeeklyContribs: Value(buddyWeeklyContribs),
      pingsToday: Value(pingsToday),
      pingsDay: pingsDay == null && nullToAbsent
          ? const Value.absent()
          : Value(pingsDay),
      weekRewardClaimed: Value(weekRewardClaimed),
    );
  }

  factory BuddyCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuddyCacheData(
      id: serializer.fromJson<String>(json['id']),
      inviteCode: serializer.fromJson<String?>(json['inviteCode']),
      buddyId: serializer.fromJson<String?>(json['buddyId']),
      buddyNick: serializer.fromJson<String?>(json['buddyNick']),
      buddyGoalPercent: serializer.fromJson<double>(json['buddyGoalPercent']),
      buddyWeeklyPercent:
          serializer.fromJson<double>(json['buddyWeeklyPercent']),
      buddyStreak: serializer.fromJson<int>(json['buddyStreak']),
      buddyRank: serializer.fromJson<String>(json['buddyRank']),
      buddyWeeklyContribs:
          serializer.fromJson<int>(json['buddyWeeklyContribs']),
      pingsToday: serializer.fromJson<int>(json['pingsToday']),
      pingsDay: serializer.fromJson<String?>(json['pingsDay']),
      weekRewardClaimed: serializer.fromJson<bool>(json['weekRewardClaimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inviteCode': serializer.toJson<String?>(inviteCode),
      'buddyId': serializer.toJson<String?>(buddyId),
      'buddyNick': serializer.toJson<String?>(buddyNick),
      'buddyGoalPercent': serializer.toJson<double>(buddyGoalPercent),
      'buddyWeeklyPercent': serializer.toJson<double>(buddyWeeklyPercent),
      'buddyStreak': serializer.toJson<int>(buddyStreak),
      'buddyRank': serializer.toJson<String>(buddyRank),
      'buddyWeeklyContribs': serializer.toJson<int>(buddyWeeklyContribs),
      'pingsToday': serializer.toJson<int>(pingsToday),
      'pingsDay': serializer.toJson<String?>(pingsDay),
      'weekRewardClaimed': serializer.toJson<bool>(weekRewardClaimed),
    };
  }

  BuddyCacheData copyWith(
          {String? id,
          Value<String?> inviteCode = const Value.absent(),
          Value<String?> buddyId = const Value.absent(),
          Value<String?> buddyNick = const Value.absent(),
          double? buddyGoalPercent,
          double? buddyWeeklyPercent,
          int? buddyStreak,
          String? buddyRank,
          int? buddyWeeklyContribs,
          int? pingsToday,
          Value<String?> pingsDay = const Value.absent(),
          bool? weekRewardClaimed}) =>
      BuddyCacheData(
        id: id ?? this.id,
        inviteCode: inviteCode.present ? inviteCode.value : this.inviteCode,
        buddyId: buddyId.present ? buddyId.value : this.buddyId,
        buddyNick: buddyNick.present ? buddyNick.value : this.buddyNick,
        buddyGoalPercent: buddyGoalPercent ?? this.buddyGoalPercent,
        buddyWeeklyPercent: buddyWeeklyPercent ?? this.buddyWeeklyPercent,
        buddyStreak: buddyStreak ?? this.buddyStreak,
        buddyRank: buddyRank ?? this.buddyRank,
        buddyWeeklyContribs: buddyWeeklyContribs ?? this.buddyWeeklyContribs,
        pingsToday: pingsToday ?? this.pingsToday,
        pingsDay: pingsDay.present ? pingsDay.value : this.pingsDay,
        weekRewardClaimed: weekRewardClaimed ?? this.weekRewardClaimed,
      );
  BuddyCacheData copyWithCompanion(BuddyCacheCompanion data) {
    return BuddyCacheData(
      id: data.id.present ? data.id.value : this.id,
      inviteCode:
          data.inviteCode.present ? data.inviteCode.value : this.inviteCode,
      buddyId: data.buddyId.present ? data.buddyId.value : this.buddyId,
      buddyNick: data.buddyNick.present ? data.buddyNick.value : this.buddyNick,
      buddyGoalPercent: data.buddyGoalPercent.present
          ? data.buddyGoalPercent.value
          : this.buddyGoalPercent,
      buddyWeeklyPercent: data.buddyWeeklyPercent.present
          ? data.buddyWeeklyPercent.value
          : this.buddyWeeklyPercent,
      buddyStreak:
          data.buddyStreak.present ? data.buddyStreak.value : this.buddyStreak,
      buddyRank: data.buddyRank.present ? data.buddyRank.value : this.buddyRank,
      buddyWeeklyContribs: data.buddyWeeklyContribs.present
          ? data.buddyWeeklyContribs.value
          : this.buddyWeeklyContribs,
      pingsToday:
          data.pingsToday.present ? data.pingsToday.value : this.pingsToday,
      pingsDay: data.pingsDay.present ? data.pingsDay.value : this.pingsDay,
      weekRewardClaimed: data.weekRewardClaimed.present
          ? data.weekRewardClaimed.value
          : this.weekRewardClaimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BuddyCacheData(')
          ..write('id: $id, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('buddyId: $buddyId, ')
          ..write('buddyNick: $buddyNick, ')
          ..write('buddyGoalPercent: $buddyGoalPercent, ')
          ..write('buddyWeeklyPercent: $buddyWeeklyPercent, ')
          ..write('buddyStreak: $buddyStreak, ')
          ..write('buddyRank: $buddyRank, ')
          ..write('buddyWeeklyContribs: $buddyWeeklyContribs, ')
          ..write('pingsToday: $pingsToday, ')
          ..write('pingsDay: $pingsDay, ')
          ..write('weekRewardClaimed: $weekRewardClaimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      inviteCode,
      buddyId,
      buddyNick,
      buddyGoalPercent,
      buddyWeeklyPercent,
      buddyStreak,
      buddyRank,
      buddyWeeklyContribs,
      pingsToday,
      pingsDay,
      weekRewardClaimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuddyCacheData &&
          other.id == this.id &&
          other.inviteCode == this.inviteCode &&
          other.buddyId == this.buddyId &&
          other.buddyNick == this.buddyNick &&
          other.buddyGoalPercent == this.buddyGoalPercent &&
          other.buddyWeeklyPercent == this.buddyWeeklyPercent &&
          other.buddyStreak == this.buddyStreak &&
          other.buddyRank == this.buddyRank &&
          other.buddyWeeklyContribs == this.buddyWeeklyContribs &&
          other.pingsToday == this.pingsToday &&
          other.pingsDay == this.pingsDay &&
          other.weekRewardClaimed == this.weekRewardClaimed);
}

class BuddyCacheCompanion extends UpdateCompanion<BuddyCacheData> {
  final Value<String> id;
  final Value<String?> inviteCode;
  final Value<String?> buddyId;
  final Value<String?> buddyNick;
  final Value<double> buddyGoalPercent;
  final Value<double> buddyWeeklyPercent;
  final Value<int> buddyStreak;
  final Value<String> buddyRank;
  final Value<int> buddyWeeklyContribs;
  final Value<int> pingsToday;
  final Value<String?> pingsDay;
  final Value<bool> weekRewardClaimed;
  final Value<int> rowid;
  const BuddyCacheCompanion({
    this.id = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.buddyId = const Value.absent(),
    this.buddyNick = const Value.absent(),
    this.buddyGoalPercent = const Value.absent(),
    this.buddyWeeklyPercent = const Value.absent(),
    this.buddyStreak = const Value.absent(),
    this.buddyRank = const Value.absent(),
    this.buddyWeeklyContribs = const Value.absent(),
    this.pingsToday = const Value.absent(),
    this.pingsDay = const Value.absent(),
    this.weekRewardClaimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BuddyCacheCompanion.insert({
    required String id,
    this.inviteCode = const Value.absent(),
    this.buddyId = const Value.absent(),
    this.buddyNick = const Value.absent(),
    this.buddyGoalPercent = const Value.absent(),
    this.buddyWeeklyPercent = const Value.absent(),
    this.buddyStreak = const Value.absent(),
    this.buddyRank = const Value.absent(),
    this.buddyWeeklyContribs = const Value.absent(),
    this.pingsToday = const Value.absent(),
    this.pingsDay = const Value.absent(),
    this.weekRewardClaimed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<BuddyCacheData> custom({
    Expression<String>? id,
    Expression<String>? inviteCode,
    Expression<String>? buddyId,
    Expression<String>? buddyNick,
    Expression<double>? buddyGoalPercent,
    Expression<double>? buddyWeeklyPercent,
    Expression<int>? buddyStreak,
    Expression<String>? buddyRank,
    Expression<int>? buddyWeeklyContribs,
    Expression<int>? pingsToday,
    Expression<String>? pingsDay,
    Expression<bool>? weekRewardClaimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (buddyId != null) 'buddy_id': buddyId,
      if (buddyNick != null) 'buddy_nick': buddyNick,
      if (buddyGoalPercent != null) 'buddy_goal_percent': buddyGoalPercent,
      if (buddyWeeklyPercent != null)
        'buddy_weekly_percent': buddyWeeklyPercent,
      if (buddyStreak != null) 'buddy_streak': buddyStreak,
      if (buddyRank != null) 'buddy_rank': buddyRank,
      if (buddyWeeklyContribs != null)
        'buddy_weekly_contribs': buddyWeeklyContribs,
      if (pingsToday != null) 'pings_today': pingsToday,
      if (pingsDay != null) 'pings_day': pingsDay,
      if (weekRewardClaimed != null) 'week_reward_claimed': weekRewardClaimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BuddyCacheCompanion copyWith(
      {Value<String>? id,
      Value<String?>? inviteCode,
      Value<String?>? buddyId,
      Value<String?>? buddyNick,
      Value<double>? buddyGoalPercent,
      Value<double>? buddyWeeklyPercent,
      Value<int>? buddyStreak,
      Value<String>? buddyRank,
      Value<int>? buddyWeeklyContribs,
      Value<int>? pingsToday,
      Value<String?>? pingsDay,
      Value<bool>? weekRewardClaimed,
      Value<int>? rowid}) {
    return BuddyCacheCompanion(
      id: id ?? this.id,
      inviteCode: inviteCode ?? this.inviteCode,
      buddyId: buddyId ?? this.buddyId,
      buddyNick: buddyNick ?? this.buddyNick,
      buddyGoalPercent: buddyGoalPercent ?? this.buddyGoalPercent,
      buddyWeeklyPercent: buddyWeeklyPercent ?? this.buddyWeeklyPercent,
      buddyStreak: buddyStreak ?? this.buddyStreak,
      buddyRank: buddyRank ?? this.buddyRank,
      buddyWeeklyContribs: buddyWeeklyContribs ?? this.buddyWeeklyContribs,
      pingsToday: pingsToday ?? this.pingsToday,
      pingsDay: pingsDay ?? this.pingsDay,
      weekRewardClaimed: weekRewardClaimed ?? this.weekRewardClaimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (buddyId.present) {
      map['buddy_id'] = Variable<String>(buddyId.value);
    }
    if (buddyNick.present) {
      map['buddy_nick'] = Variable<String>(buddyNick.value);
    }
    if (buddyGoalPercent.present) {
      map['buddy_goal_percent'] = Variable<double>(buddyGoalPercent.value);
    }
    if (buddyWeeklyPercent.present) {
      map['buddy_weekly_percent'] = Variable<double>(buddyWeeklyPercent.value);
    }
    if (buddyStreak.present) {
      map['buddy_streak'] = Variable<int>(buddyStreak.value);
    }
    if (buddyRank.present) {
      map['buddy_rank'] = Variable<String>(buddyRank.value);
    }
    if (buddyWeeklyContribs.present) {
      map['buddy_weekly_contribs'] = Variable<int>(buddyWeeklyContribs.value);
    }
    if (pingsToday.present) {
      map['pings_today'] = Variable<int>(pingsToday.value);
    }
    if (pingsDay.present) {
      map['pings_day'] = Variable<String>(pingsDay.value);
    }
    if (weekRewardClaimed.present) {
      map['week_reward_claimed'] = Variable<bool>(weekRewardClaimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuddyCacheCompanion(')
          ..write('id: $id, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('buddyId: $buddyId, ')
          ..write('buddyNick: $buddyNick, ')
          ..write('buddyGoalPercent: $buddyGoalPercent, ')
          ..write('buddyWeeklyPercent: $buddyWeeklyPercent, ')
          ..write('buddyStreak: $buddyStreak, ')
          ..write('buddyRank: $buddyRank, ')
          ..write('buddyWeeklyContribs: $buddyWeeklyContribs, ')
          ..write('pingsToday: $pingsToday, ')
          ..write('pingsDay: $pingsDay, ')
          ..write('weekRewardClaimed: $weekRewardClaimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GhostCacheTable extends GhostCache
    with TableInfo<$GhostCacheTable, GhostCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GhostCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nickMeta = const VerificationMeta('nick');
  @override
  late final GeneratedColumn<String> nick = GeneratedColumn<String>(
      'nick', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _percentMeta =
      const VerificationMeta('percent');
  @override
  late final GeneratedColumn<double> percent = GeneratedColumn<double>(
      'percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _weeklyXpMeta =
      const VerificationMeta('weeklyXp');
  @override
  late final GeneratedColumn<int> weeklyXp = GeneratedColumn<int>(
      'weekly_xp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rankLabelMeta =
      const VerificationMeta('rankLabel');
  @override
  late final GeneratedColumn<String> rankLabel = GeneratedColumn<String>(
      'rank_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _streakDaysMeta =
      const VerificationMeta('streakDays');
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
      'streak_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weekKeyMeta =
      const VerificationMeta('weekKey');
  @override
  late final GeneratedColumn<String> weekKey = GeneratedColumn<String>(
      'week_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nick, percent, weeklyXp, rankLabel, streakDays, weekKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ghost_cache';
  @override
  VerificationContext validateIntegrity(Insertable<GhostCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nick')) {
      context.handle(
          _nickMeta, nick.isAcceptableOrUnknown(data['nick']!, _nickMeta));
    } else if (isInserting) {
      context.missing(_nickMeta);
    }
    if (data.containsKey('percent')) {
      context.handle(_percentMeta,
          percent.isAcceptableOrUnknown(data['percent']!, _percentMeta));
    } else if (isInserting) {
      context.missing(_percentMeta);
    }
    if (data.containsKey('weekly_xp')) {
      context.handle(_weeklyXpMeta,
          weeklyXp.isAcceptableOrUnknown(data['weekly_xp']!, _weeklyXpMeta));
    } else if (isInserting) {
      context.missing(_weeklyXpMeta);
    }
    if (data.containsKey('rank_label')) {
      context.handle(_rankLabelMeta,
          rankLabel.isAcceptableOrUnknown(data['rank_label']!, _rankLabelMeta));
    } else if (isInserting) {
      context.missing(_rankLabelMeta);
    }
    if (data.containsKey('streak_days')) {
      context.handle(
          _streakDaysMeta,
          streakDays.isAcceptableOrUnknown(
              data['streak_days']!, _streakDaysMeta));
    } else if (isInserting) {
      context.missing(_streakDaysMeta);
    }
    if (data.containsKey('week_key')) {
      context.handle(_weekKeyMeta,
          weekKey.isAcceptableOrUnknown(data['week_key']!, _weekKeyMeta));
    } else if (isInserting) {
      context.missing(_weekKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GhostCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GhostCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nick: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nick'])!,
      percent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percent'])!,
      weeklyXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_xp'])!,
      rankLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rank_label'])!,
      streakDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_days'])!,
      weekKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}week_key'])!,
    );
  }

  @override
  $GhostCacheTable createAlias(String alias) {
    return $GhostCacheTable(attachedDatabase, alias);
  }
}

class GhostCacheData extends DataClass implements Insertable<GhostCacheData> {
  final String id;
  final String nick;
  final double percent;
  final int weeklyXp;
  final String rankLabel;
  final int streakDays;
  final String weekKey;
  const GhostCacheData(
      {required this.id,
      required this.nick,
      required this.percent,
      required this.weeklyXp,
      required this.rankLabel,
      required this.streakDays,
      required this.weekKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nick'] = Variable<String>(nick);
    map['percent'] = Variable<double>(percent);
    map['weekly_xp'] = Variable<int>(weeklyXp);
    map['rank_label'] = Variable<String>(rankLabel);
    map['streak_days'] = Variable<int>(streakDays);
    map['week_key'] = Variable<String>(weekKey);
    return map;
  }

  GhostCacheCompanion toCompanion(bool nullToAbsent) {
    return GhostCacheCompanion(
      id: Value(id),
      nick: Value(nick),
      percent: Value(percent),
      weeklyXp: Value(weeklyXp),
      rankLabel: Value(rankLabel),
      streakDays: Value(streakDays),
      weekKey: Value(weekKey),
    );
  }

  factory GhostCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GhostCacheData(
      id: serializer.fromJson<String>(json['id']),
      nick: serializer.fromJson<String>(json['nick']),
      percent: serializer.fromJson<double>(json['percent']),
      weeklyXp: serializer.fromJson<int>(json['weeklyXp']),
      rankLabel: serializer.fromJson<String>(json['rankLabel']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      weekKey: serializer.fromJson<String>(json['weekKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nick': serializer.toJson<String>(nick),
      'percent': serializer.toJson<double>(percent),
      'weeklyXp': serializer.toJson<int>(weeklyXp),
      'rankLabel': serializer.toJson<String>(rankLabel),
      'streakDays': serializer.toJson<int>(streakDays),
      'weekKey': serializer.toJson<String>(weekKey),
    };
  }

  GhostCacheData copyWith(
          {String? id,
          String? nick,
          double? percent,
          int? weeklyXp,
          String? rankLabel,
          int? streakDays,
          String? weekKey}) =>
      GhostCacheData(
        id: id ?? this.id,
        nick: nick ?? this.nick,
        percent: percent ?? this.percent,
        weeklyXp: weeklyXp ?? this.weeklyXp,
        rankLabel: rankLabel ?? this.rankLabel,
        streakDays: streakDays ?? this.streakDays,
        weekKey: weekKey ?? this.weekKey,
      );
  GhostCacheData copyWithCompanion(GhostCacheCompanion data) {
    return GhostCacheData(
      id: data.id.present ? data.id.value : this.id,
      nick: data.nick.present ? data.nick.value : this.nick,
      percent: data.percent.present ? data.percent.value : this.percent,
      weeklyXp: data.weeklyXp.present ? data.weeklyXp.value : this.weeklyXp,
      rankLabel: data.rankLabel.present ? data.rankLabel.value : this.rankLabel,
      streakDays:
          data.streakDays.present ? data.streakDays.value : this.streakDays,
      weekKey: data.weekKey.present ? data.weekKey.value : this.weekKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GhostCacheData(')
          ..write('id: $id, ')
          ..write('nick: $nick, ')
          ..write('percent: $percent, ')
          ..write('weeklyXp: $weeklyXp, ')
          ..write('rankLabel: $rankLabel, ')
          ..write('streakDays: $streakDays, ')
          ..write('weekKey: $weekKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nick, percent, weeklyXp, rankLabel, streakDays, weekKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GhostCacheData &&
          other.id == this.id &&
          other.nick == this.nick &&
          other.percent == this.percent &&
          other.weeklyXp == this.weeklyXp &&
          other.rankLabel == this.rankLabel &&
          other.streakDays == this.streakDays &&
          other.weekKey == this.weekKey);
}

class GhostCacheCompanion extends UpdateCompanion<GhostCacheData> {
  final Value<String> id;
  final Value<String> nick;
  final Value<double> percent;
  final Value<int> weeklyXp;
  final Value<String> rankLabel;
  final Value<int> streakDays;
  final Value<String> weekKey;
  final Value<int> rowid;
  const GhostCacheCompanion({
    this.id = const Value.absent(),
    this.nick = const Value.absent(),
    this.percent = const Value.absent(),
    this.weeklyXp = const Value.absent(),
    this.rankLabel = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.weekKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GhostCacheCompanion.insert({
    required String id,
    required String nick,
    required double percent,
    required int weeklyXp,
    required String rankLabel,
    required int streakDays,
    required String weekKey,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nick = Value(nick),
        percent = Value(percent),
        weeklyXp = Value(weeklyXp),
        rankLabel = Value(rankLabel),
        streakDays = Value(streakDays),
        weekKey = Value(weekKey);
  static Insertable<GhostCacheData> custom({
    Expression<String>? id,
    Expression<String>? nick,
    Expression<double>? percent,
    Expression<int>? weeklyXp,
    Expression<String>? rankLabel,
    Expression<int>? streakDays,
    Expression<String>? weekKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nick != null) 'nick': nick,
      if (percent != null) 'percent': percent,
      if (weeklyXp != null) 'weekly_xp': weeklyXp,
      if (rankLabel != null) 'rank_label': rankLabel,
      if (streakDays != null) 'streak_days': streakDays,
      if (weekKey != null) 'week_key': weekKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GhostCacheCompanion copyWith(
      {Value<String>? id,
      Value<String>? nick,
      Value<double>? percent,
      Value<int>? weeklyXp,
      Value<String>? rankLabel,
      Value<int>? streakDays,
      Value<String>? weekKey,
      Value<int>? rowid}) {
    return GhostCacheCompanion(
      id: id ?? this.id,
      nick: nick ?? this.nick,
      percent: percent ?? this.percent,
      weeklyXp: weeklyXp ?? this.weeklyXp,
      rankLabel: rankLabel ?? this.rankLabel,
      streakDays: streakDays ?? this.streakDays,
      weekKey: weekKey ?? this.weekKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nick.present) {
      map['nick'] = Variable<String>(nick.value);
    }
    if (percent.present) {
      map['percent'] = Variable<double>(percent.value);
    }
    if (weeklyXp.present) {
      map['weekly_xp'] = Variable<int>(weeklyXp.value);
    }
    if (rankLabel.present) {
      map['rank_label'] = Variable<String>(rankLabel.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (weekKey.present) {
      map['week_key'] = Variable<String>(weekKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GhostCacheCompanion(')
          ..write('id: $id, ')
          ..write('nick: $nick, ')
          ..write('percent: $percent, ')
          ..write('weeklyXp: $weeklyXp, ')
          ..write('rankLabel: $rankLabel, ')
          ..write('streakDays: $streakDays, ')
          ..write('weekKey: $weekKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaderboardOptInTable extends LeaderboardOptIn
    with TableInfo<$LeaderboardOptInTable, LeaderboardOptInData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaderboardOptInTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optedInMeta =
      const VerificationMeta('optedIn');
  @override
  late final GeneratedColumn<bool> optedIn = GeneratedColumn<bool>(
      'opted_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("opted_in" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ghostRewardClaimedThisWeekMeta =
      const VerificationMeta('ghostRewardClaimedThisWeek');
  @override
  late final GeneratedColumn<bool> ghostRewardClaimedThisWeek =
      GeneratedColumn<bool>(
          'ghost_reward_claimed_this_week', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("ghost_reward_claimed_this_week" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _ghostRewardWeekMeta =
      const VerificationMeta('ghostRewardWeek');
  @override
  late final GeneratedColumn<String> ghostRewardWeek = GeneratedColumn<String>(
      'ghost_reward_week', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, optedIn, ghostRewardClaimedThisWeek, ghostRewardWeek];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leaderboard_opt_in';
  @override
  VerificationContext validateIntegrity(
      Insertable<LeaderboardOptInData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('opted_in')) {
      context.handle(_optedInMeta,
          optedIn.isAcceptableOrUnknown(data['opted_in']!, _optedInMeta));
    }
    if (data.containsKey('ghost_reward_claimed_this_week')) {
      context.handle(
          _ghostRewardClaimedThisWeekMeta,
          ghostRewardClaimedThisWeek.isAcceptableOrUnknown(
              data['ghost_reward_claimed_this_week']!,
              _ghostRewardClaimedThisWeekMeta));
    }
    if (data.containsKey('ghost_reward_week')) {
      context.handle(
          _ghostRewardWeekMeta,
          ghostRewardWeek.isAcceptableOrUnknown(
              data['ghost_reward_week']!, _ghostRewardWeekMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaderboardOptInData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaderboardOptInData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      optedIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}opted_in'])!,
      ghostRewardClaimedThisWeek: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}ghost_reward_claimed_this_week'])!,
      ghostRewardWeek: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ghost_reward_week']),
    );
  }

  @override
  $LeaderboardOptInTable createAlias(String alias) {
    return $LeaderboardOptInTable(attachedDatabase, alias);
  }
}

class LeaderboardOptInData extends DataClass
    implements Insertable<LeaderboardOptInData> {
  final String id;
  final bool optedIn;
  final bool ghostRewardClaimedThisWeek;
  final String? ghostRewardWeek;
  const LeaderboardOptInData(
      {required this.id,
      required this.optedIn,
      required this.ghostRewardClaimedThisWeek,
      this.ghostRewardWeek});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['opted_in'] = Variable<bool>(optedIn);
    map['ghost_reward_claimed_this_week'] =
        Variable<bool>(ghostRewardClaimedThisWeek);
    if (!nullToAbsent || ghostRewardWeek != null) {
      map['ghost_reward_week'] = Variable<String>(ghostRewardWeek);
    }
    return map;
  }

  LeaderboardOptInCompanion toCompanion(bool nullToAbsent) {
    return LeaderboardOptInCompanion(
      id: Value(id),
      optedIn: Value(optedIn),
      ghostRewardClaimedThisWeek: Value(ghostRewardClaimedThisWeek),
      ghostRewardWeek: ghostRewardWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(ghostRewardWeek),
    );
  }

  factory LeaderboardOptInData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaderboardOptInData(
      id: serializer.fromJson<String>(json['id']),
      optedIn: serializer.fromJson<bool>(json['optedIn']),
      ghostRewardClaimedThisWeek:
          serializer.fromJson<bool>(json['ghostRewardClaimedThisWeek']),
      ghostRewardWeek: serializer.fromJson<String?>(json['ghostRewardWeek']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'optedIn': serializer.toJson<bool>(optedIn),
      'ghostRewardClaimedThisWeek':
          serializer.toJson<bool>(ghostRewardClaimedThisWeek),
      'ghostRewardWeek': serializer.toJson<String?>(ghostRewardWeek),
    };
  }

  LeaderboardOptInData copyWith(
          {String? id,
          bool? optedIn,
          bool? ghostRewardClaimedThisWeek,
          Value<String?> ghostRewardWeek = const Value.absent()}) =>
      LeaderboardOptInData(
        id: id ?? this.id,
        optedIn: optedIn ?? this.optedIn,
        ghostRewardClaimedThisWeek:
            ghostRewardClaimedThisWeek ?? this.ghostRewardClaimedThisWeek,
        ghostRewardWeek: ghostRewardWeek.present
            ? ghostRewardWeek.value
            : this.ghostRewardWeek,
      );
  LeaderboardOptInData copyWithCompanion(LeaderboardOptInCompanion data) {
    return LeaderboardOptInData(
      id: data.id.present ? data.id.value : this.id,
      optedIn: data.optedIn.present ? data.optedIn.value : this.optedIn,
      ghostRewardClaimedThisWeek: data.ghostRewardClaimedThisWeek.present
          ? data.ghostRewardClaimedThisWeek.value
          : this.ghostRewardClaimedThisWeek,
      ghostRewardWeek: data.ghostRewardWeek.present
          ? data.ghostRewardWeek.value
          : this.ghostRewardWeek,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaderboardOptInData(')
          ..write('id: $id, ')
          ..write('optedIn: $optedIn, ')
          ..write('ghostRewardClaimedThisWeek: $ghostRewardClaimedThisWeek, ')
          ..write('ghostRewardWeek: $ghostRewardWeek')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, optedIn, ghostRewardClaimedThisWeek, ghostRewardWeek);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaderboardOptInData &&
          other.id == this.id &&
          other.optedIn == this.optedIn &&
          other.ghostRewardClaimedThisWeek == this.ghostRewardClaimedThisWeek &&
          other.ghostRewardWeek == this.ghostRewardWeek);
}

class LeaderboardOptInCompanion extends UpdateCompanion<LeaderboardOptInData> {
  final Value<String> id;
  final Value<bool> optedIn;
  final Value<bool> ghostRewardClaimedThisWeek;
  final Value<String?> ghostRewardWeek;
  final Value<int> rowid;
  const LeaderboardOptInCompanion({
    this.id = const Value.absent(),
    this.optedIn = const Value.absent(),
    this.ghostRewardClaimedThisWeek = const Value.absent(),
    this.ghostRewardWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaderboardOptInCompanion.insert({
    required String id,
    this.optedIn = const Value.absent(),
    this.ghostRewardClaimedThisWeek = const Value.absent(),
    this.ghostRewardWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<LeaderboardOptInData> custom({
    Expression<String>? id,
    Expression<bool>? optedIn,
    Expression<bool>? ghostRewardClaimedThisWeek,
    Expression<String>? ghostRewardWeek,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (optedIn != null) 'opted_in': optedIn,
      if (ghostRewardClaimedThisWeek != null)
        'ghost_reward_claimed_this_week': ghostRewardClaimedThisWeek,
      if (ghostRewardWeek != null) 'ghost_reward_week': ghostRewardWeek,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaderboardOptInCompanion copyWith(
      {Value<String>? id,
      Value<bool>? optedIn,
      Value<bool>? ghostRewardClaimedThisWeek,
      Value<String?>? ghostRewardWeek,
      Value<int>? rowid}) {
    return LeaderboardOptInCompanion(
      id: id ?? this.id,
      optedIn: optedIn ?? this.optedIn,
      ghostRewardClaimedThisWeek:
          ghostRewardClaimedThisWeek ?? this.ghostRewardClaimedThisWeek,
      ghostRewardWeek: ghostRewardWeek ?? this.ghostRewardWeek,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (optedIn.present) {
      map['opted_in'] = Variable<bool>(optedIn.value);
    }
    if (ghostRewardClaimedThisWeek.present) {
      map['ghost_reward_claimed_this_week'] =
          Variable<bool>(ghostRewardClaimedThisWeek.value);
    }
    if (ghostRewardWeek.present) {
      map['ghost_reward_week'] = Variable<String>(ghostRewardWeek.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaderboardOptInCompanion(')
          ..write('id: $id, ')
          ..write('optedIn: $optedIn, ')
          ..write('ghostRewardClaimedThisWeek: $ghostRewardClaimedThisWeek, ')
          ..write('ghostRewardWeek: $ghostRewardWeek, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ApiKeysTable extends ApiKeys with TableInfo<$ApiKeysTable, ApiKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storeIdMeta =
      const VerificationMeta('storeId');
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
      'store_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyHashMeta =
      const VerificationMeta('keyHash');
  @override
  late final GeneratedColumn<String> keyHash = GeneratedColumn<String>(
      'key_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyPreviewMeta =
      const VerificationMeta('keyPreview');
  @override
  late final GeneratedColumn<String> keyPreview = GeneratedColumn<String>(
      'key_preview', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
      'salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unset'));
  static const VerificationMeta _lastOkAtMeta =
      const VerificationMeta('lastOkAt');
  @override
  late final GeneratedColumn<int> lastOkAt = GeneratedColumn<int>(
      'last_ok_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rateLimitPerHourMeta =
      const VerificationMeta('rateLimitPerHour');
  @override
  late final GeneratedColumn<int> rateLimitPerHour = GeneratedColumn<int>(
      'rate_limit_per_hour', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        storeId,
        keyHash,
        keyPreview,
        salt,
        notes,
        status,
        lastOkAt,
        lastError,
        rateLimitPerHour,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_keys';
  @override
  VerificationContext validateIntegrity(Insertable<ApiKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(_storeIdMeta,
          storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta));
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('key_hash')) {
      context.handle(_keyHashMeta,
          keyHash.isAcceptableOrUnknown(data['key_hash']!, _keyHashMeta));
    } else if (isInserting) {
      context.missing(_keyHashMeta);
    }
    if (data.containsKey('key_preview')) {
      context.handle(
          _keyPreviewMeta,
          keyPreview.isAcceptableOrUnknown(
              data['key_preview']!, _keyPreviewMeta));
    } else if (isInserting) {
      context.missing(_keyPreviewMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_ok_at')) {
      context.handle(_lastOkAtMeta,
          lastOkAt.isAcceptableOrUnknown(data['last_ok_at']!, _lastOkAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('rate_limit_per_hour')) {
      context.handle(
          _rateLimitPerHourMeta,
          rateLimitPerHour.isAcceptableOrUnknown(
              data['rate_limit_per_hour']!, _rateLimitPerHourMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApiKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiKey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      storeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_id'])!,
      keyHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_hash'])!,
      keyPreview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_preview'])!,
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salt'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastOkAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_ok_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      rateLimitPerHour: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}rate_limit_per_hour']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ApiKeysTable createAlias(String alias) {
    return $ApiKeysTable(attachedDatabase, alias);
  }
}

class ApiKey extends DataClass implements Insertable<ApiKey> {
  final String id;
  final String name;
  final String storeId;
  final String keyHash;
  final String keyPreview;
  final String salt;
  final String? notes;
  final String status;
  final int? lastOkAt;
  final String? lastError;
  final int? rateLimitPerHour;
  final int createdAt;
  const ApiKey(
      {required this.id,
      required this.name,
      required this.storeId,
      required this.keyHash,
      required this.keyPreview,
      required this.salt,
      this.notes,
      required this.status,
      this.lastOkAt,
      this.lastError,
      this.rateLimitPerHour,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['store_id'] = Variable<String>(storeId);
    map['key_hash'] = Variable<String>(keyHash);
    map['key_preview'] = Variable<String>(keyPreview);
    map['salt'] = Variable<String>(salt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastOkAt != null) {
      map['last_ok_at'] = Variable<int>(lastOkAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || rateLimitPerHour != null) {
      map['rate_limit_per_hour'] = Variable<int>(rateLimitPerHour);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ApiKeysCompanion toCompanion(bool nullToAbsent) {
    return ApiKeysCompanion(
      id: Value(id),
      name: Value(name),
      storeId: Value(storeId),
      keyHash: Value(keyHash),
      keyPreview: Value(keyPreview),
      salt: Value(salt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
      lastOkAt: lastOkAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOkAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      rateLimitPerHour: rateLimitPerHour == null && nullToAbsent
          ? const Value.absent()
          : Value(rateLimitPerHour),
      createdAt: Value(createdAt),
    );
  }

  factory ApiKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiKey(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      storeId: serializer.fromJson<String>(json['storeId']),
      keyHash: serializer.fromJson<String>(json['keyHash']),
      keyPreview: serializer.fromJson<String>(json['keyPreview']),
      salt: serializer.fromJson<String>(json['salt']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      lastOkAt: serializer.fromJson<int?>(json['lastOkAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      rateLimitPerHour: serializer.fromJson<int?>(json['rateLimitPerHour']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'storeId': serializer.toJson<String>(storeId),
      'keyHash': serializer.toJson<String>(keyHash),
      'keyPreview': serializer.toJson<String>(keyPreview),
      'salt': serializer.toJson<String>(salt),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'lastOkAt': serializer.toJson<int?>(lastOkAt),
      'lastError': serializer.toJson<String?>(lastError),
      'rateLimitPerHour': serializer.toJson<int?>(rateLimitPerHour),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ApiKey copyWith(
          {String? id,
          String? name,
          String? storeId,
          String? keyHash,
          String? keyPreview,
          String? salt,
          Value<String?> notes = const Value.absent(),
          String? status,
          Value<int?> lastOkAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          Value<int?> rateLimitPerHour = const Value.absent(),
          int? createdAt}) =>
      ApiKey(
        id: id ?? this.id,
        name: name ?? this.name,
        storeId: storeId ?? this.storeId,
        keyHash: keyHash ?? this.keyHash,
        keyPreview: keyPreview ?? this.keyPreview,
        salt: salt ?? this.salt,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        lastOkAt: lastOkAt.present ? lastOkAt.value : this.lastOkAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        rateLimitPerHour: rateLimitPerHour.present
            ? rateLimitPerHour.value
            : this.rateLimitPerHour,
        createdAt: createdAt ?? this.createdAt,
      );
  ApiKey copyWithCompanion(ApiKeysCompanion data) {
    return ApiKey(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      keyHash: data.keyHash.present ? data.keyHash.value : this.keyHash,
      keyPreview:
          data.keyPreview.present ? data.keyPreview.value : this.keyPreview,
      salt: data.salt.present ? data.salt.value : this.salt,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      lastOkAt: data.lastOkAt.present ? data.lastOkAt.value : this.lastOkAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      rateLimitPerHour: data.rateLimitPerHour.present
          ? data.rateLimitPerHour.value
          : this.rateLimitPerHour,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiKey(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('storeId: $storeId, ')
          ..write('keyHash: $keyHash, ')
          ..write('keyPreview: $keyPreview, ')
          ..write('salt: $salt, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('lastOkAt: $lastOkAt, ')
          ..write('lastError: $lastError, ')
          ..write('rateLimitPerHour: $rateLimitPerHour, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, storeId, keyHash, keyPreview, salt,
      notes, status, lastOkAt, lastError, rateLimitPerHour, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiKey &&
          other.id == this.id &&
          other.name == this.name &&
          other.storeId == this.storeId &&
          other.keyHash == this.keyHash &&
          other.keyPreview == this.keyPreview &&
          other.salt == this.salt &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.lastOkAt == this.lastOkAt &&
          other.lastError == this.lastError &&
          other.rateLimitPerHour == this.rateLimitPerHour &&
          other.createdAt == this.createdAt);
}

class ApiKeysCompanion extends UpdateCompanion<ApiKey> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> storeId;
  final Value<String> keyHash;
  final Value<String> keyPreview;
  final Value<String> salt;
  final Value<String?> notes;
  final Value<String> status;
  final Value<int?> lastOkAt;
  final Value<String?> lastError;
  final Value<int?> rateLimitPerHour;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ApiKeysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.storeId = const Value.absent(),
    this.keyHash = const Value.absent(),
    this.keyPreview = const Value.absent(),
    this.salt = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.lastOkAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rateLimitPerHour = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ApiKeysCompanion.insert({
    required String id,
    required String name,
    required String storeId,
    required String keyHash,
    required String keyPreview,
    required String salt,
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.lastOkAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rateLimitPerHour = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        storeId = Value(storeId),
        keyHash = Value(keyHash),
        keyPreview = Value(keyPreview),
        salt = Value(salt),
        createdAt = Value(createdAt);
  static Insertable<ApiKey> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? storeId,
    Expression<String>? keyHash,
    Expression<String>? keyPreview,
    Expression<String>? salt,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? lastOkAt,
    Expression<String>? lastError,
    Expression<int>? rateLimitPerHour,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (storeId != null) 'store_id': storeId,
      if (keyHash != null) 'key_hash': keyHash,
      if (keyPreview != null) 'key_preview': keyPreview,
      if (salt != null) 'salt': salt,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (lastOkAt != null) 'last_ok_at': lastOkAt,
      if (lastError != null) 'last_error': lastError,
      if (rateLimitPerHour != null) 'rate_limit_per_hour': rateLimitPerHour,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ApiKeysCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? storeId,
      Value<String>? keyHash,
      Value<String>? keyPreview,
      Value<String>? salt,
      Value<String?>? notes,
      Value<String>? status,
      Value<int?>? lastOkAt,
      Value<String?>? lastError,
      Value<int?>? rateLimitPerHour,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return ApiKeysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      storeId: storeId ?? this.storeId,
      keyHash: keyHash ?? this.keyHash,
      keyPreview: keyPreview ?? this.keyPreview,
      salt: salt ?? this.salt,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      lastOkAt: lastOkAt ?? this.lastOkAt,
      lastError: lastError ?? this.lastError,
      rateLimitPerHour: rateLimitPerHour ?? this.rateLimitPerHour,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (keyHash.present) {
      map['key_hash'] = Variable<String>(keyHash.value);
    }
    if (keyPreview.present) {
      map['key_preview'] = Variable<String>(keyPreview.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastOkAt.present) {
      map['last_ok_at'] = Variable<int>(lastOkAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rateLimitPerHour.present) {
      map['rate_limit_per_hour'] = Variable<int>(rateLimitPerHour.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiKeysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('storeId: $storeId, ')
          ..write('keyHash: $keyHash, ')
          ..write('keyPreview: $keyPreview, ')
          ..write('salt: $salt, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('lastOkAt: $lastOkAt, ')
          ..write('lastError: $lastError, ')
          ..write('rateLimitPerHour: $rateLimitPerHour, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressCardsTable extends ProgressCards
    with TableInfo<$ProgressCardsTable, ProgressCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _showRankMeta =
      const VerificationMeta('showRank');
  @override
  late final GeneratedColumn<bool> showRank = GeneratedColumn<bool>(
      'show_rank', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_rank" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showStreakMeta =
      const VerificationMeta('showStreak');
  @override
  late final GeneratedColumn<bool> showStreak = GeneratedColumn<bool>(
      'show_streak', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_streak" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showPercentMeta =
      const VerificationMeta('showPercent');
  @override
  late final GeneratedColumn<bool> showPercent = GeneratedColumn<bool>(
      'show_percent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_percent" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showAmountMeta =
      const VerificationMeta('showAmount');
  @override
  late final GeneratedColumn<bool> showAmount = GeneratedColumn<bool>(
      'show_amount', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_amount" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _viewsMeta = const VerificationMeta('views');
  @override
  late final GeneratedColumn<int> views = GeneratedColumn<int>(
      'views', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        enabled,
        token,
        showRank,
        showStreak,
        showPercent,
        showAmount,
        views,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_cards';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    }
    if (data.containsKey('show_rank')) {
      context.handle(_showRankMeta,
          showRank.isAcceptableOrUnknown(data['show_rank']!, _showRankMeta));
    }
    if (data.containsKey('show_streak')) {
      context.handle(
          _showStreakMeta,
          showStreak.isAcceptableOrUnknown(
              data['show_streak']!, _showStreakMeta));
    }
    if (data.containsKey('show_percent')) {
      context.handle(
          _showPercentMeta,
          showPercent.isAcceptableOrUnknown(
              data['show_percent']!, _showPercentMeta));
    }
    if (data.containsKey('show_amount')) {
      context.handle(
          _showAmountMeta,
          showAmount.isAcceptableOrUnknown(
              data['show_amount']!, _showAmountMeta));
    }
    if (data.containsKey('views')) {
      context.handle(
          _viewsMeta, views.isAcceptableOrUnknown(data['views']!, _viewsMeta));
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
  ProgressCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token']),
      showRank: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_rank'])!,
      showStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_streak'])!,
      showPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_percent'])!,
      showAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_amount'])!,
      views: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}views'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ProgressCardsTable createAlias(String alias) {
    return $ProgressCardsTable(attachedDatabase, alias);
  }
}

class ProgressCard extends DataClass implements Insertable<ProgressCard> {
  final String id;
  final bool enabled;
  final String? token;
  final bool showRank;
  final bool showStreak;
  final bool showPercent;
  final bool showAmount;
  final int views;
  final int? createdAt;
  const ProgressCard(
      {required this.id,
      required this.enabled,
      this.token,
      required this.showRank,
      required this.showStreak,
      required this.showPercent,
      required this.showAmount,
      required this.views,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    map['show_rank'] = Variable<bool>(showRank);
    map['show_streak'] = Variable<bool>(showStreak);
    map['show_percent'] = Variable<bool>(showPercent);
    map['show_amount'] = Variable<bool>(showAmount);
    map['views'] = Variable<int>(views);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    return map;
  }

  ProgressCardsCompanion toCompanion(bool nullToAbsent) {
    return ProgressCardsCompanion(
      id: Value(id),
      enabled: Value(enabled),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      showRank: Value(showRank),
      showStreak: Value(showStreak),
      showPercent: Value(showPercent),
      showAmount: Value(showAmount),
      views: Value(views),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ProgressCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressCard(
      id: serializer.fromJson<String>(json['id']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      token: serializer.fromJson<String?>(json['token']),
      showRank: serializer.fromJson<bool>(json['showRank']),
      showStreak: serializer.fromJson<bool>(json['showStreak']),
      showPercent: serializer.fromJson<bool>(json['showPercent']),
      showAmount: serializer.fromJson<bool>(json['showAmount']),
      views: serializer.fromJson<int>(json['views']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'enabled': serializer.toJson<bool>(enabled),
      'token': serializer.toJson<String?>(token),
      'showRank': serializer.toJson<bool>(showRank),
      'showStreak': serializer.toJson<bool>(showStreak),
      'showPercent': serializer.toJson<bool>(showPercent),
      'showAmount': serializer.toJson<bool>(showAmount),
      'views': serializer.toJson<int>(views),
      'createdAt': serializer.toJson<int?>(createdAt),
    };
  }

  ProgressCard copyWith(
          {String? id,
          bool? enabled,
          Value<String?> token = const Value.absent(),
          bool? showRank,
          bool? showStreak,
          bool? showPercent,
          bool? showAmount,
          int? views,
          Value<int?> createdAt = const Value.absent()}) =>
      ProgressCard(
        id: id ?? this.id,
        enabled: enabled ?? this.enabled,
        token: token.present ? token.value : this.token,
        showRank: showRank ?? this.showRank,
        showStreak: showStreak ?? this.showStreak,
        showPercent: showPercent ?? this.showPercent,
        showAmount: showAmount ?? this.showAmount,
        views: views ?? this.views,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  ProgressCard copyWithCompanion(ProgressCardsCompanion data) {
    return ProgressCard(
      id: data.id.present ? data.id.value : this.id,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      token: data.token.present ? data.token.value : this.token,
      showRank: data.showRank.present ? data.showRank.value : this.showRank,
      showStreak:
          data.showStreak.present ? data.showStreak.value : this.showStreak,
      showPercent:
          data.showPercent.present ? data.showPercent.value : this.showPercent,
      showAmount:
          data.showAmount.present ? data.showAmount.value : this.showAmount,
      views: data.views.present ? data.views.value : this.views,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressCard(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('token: $token, ')
          ..write('showRank: $showRank, ')
          ..write('showStreak: $showStreak, ')
          ..write('showPercent: $showPercent, ')
          ..write('showAmount: $showAmount, ')
          ..write('views: $views, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enabled, token, showRank, showStreak,
      showPercent, showAmount, views, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressCard &&
          other.id == this.id &&
          other.enabled == this.enabled &&
          other.token == this.token &&
          other.showRank == this.showRank &&
          other.showStreak == this.showStreak &&
          other.showPercent == this.showPercent &&
          other.showAmount == this.showAmount &&
          other.views == this.views &&
          other.createdAt == this.createdAt);
}

class ProgressCardsCompanion extends UpdateCompanion<ProgressCard> {
  final Value<String> id;
  final Value<bool> enabled;
  final Value<String?> token;
  final Value<bool> showRank;
  final Value<bool> showStreak;
  final Value<bool> showPercent;
  final Value<bool> showAmount;
  final Value<int> views;
  final Value<int?> createdAt;
  final Value<int> rowid;
  const ProgressCardsCompanion({
    this.id = const Value.absent(),
    this.enabled = const Value.absent(),
    this.token = const Value.absent(),
    this.showRank = const Value.absent(),
    this.showStreak = const Value.absent(),
    this.showPercent = const Value.absent(),
    this.showAmount = const Value.absent(),
    this.views = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressCardsCompanion.insert({
    required String id,
    this.enabled = const Value.absent(),
    this.token = const Value.absent(),
    this.showRank = const Value.absent(),
    this.showStreak = const Value.absent(),
    this.showPercent = const Value.absent(),
    this.showAmount = const Value.absent(),
    this.views = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ProgressCard> custom({
    Expression<String>? id,
    Expression<bool>? enabled,
    Expression<String>? token,
    Expression<bool>? showRank,
    Expression<bool>? showStreak,
    Expression<bool>? showPercent,
    Expression<bool>? showAmount,
    Expression<int>? views,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enabled != null) 'enabled': enabled,
      if (token != null) 'token': token,
      if (showRank != null) 'show_rank': showRank,
      if (showStreak != null) 'show_streak': showStreak,
      if (showPercent != null) 'show_percent': showPercent,
      if (showAmount != null) 'show_amount': showAmount,
      if (views != null) 'views': views,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressCardsCompanion copyWith(
      {Value<String>? id,
      Value<bool>? enabled,
      Value<String?>? token,
      Value<bool>? showRank,
      Value<bool>? showStreak,
      Value<bool>? showPercent,
      Value<bool>? showAmount,
      Value<int>? views,
      Value<int?>? createdAt,
      Value<int>? rowid}) {
    return ProgressCardsCompanion(
      id: id ?? this.id,
      enabled: enabled ?? this.enabled,
      token: token ?? this.token,
      showRank: showRank ?? this.showRank,
      showStreak: showStreak ?? this.showStreak,
      showPercent: showPercent ?? this.showPercent,
      showAmount: showAmount ?? this.showAmount,
      views: views ?? this.views,
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
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (showRank.present) {
      map['show_rank'] = Variable<bool>(showRank.value);
    }
    if (showStreak.present) {
      map['show_streak'] = Variable<bool>(showStreak.value);
    }
    if (showPercent.present) {
      map['show_percent'] = Variable<bool>(showPercent.value);
    }
    if (showAmount.present) {
      map['show_amount'] = Variable<bool>(showAmount.value);
    }
    if (views.present) {
      map['views'] = Variable<int>(views.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressCardsCompanion(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('token: $token, ')
          ..write('showRank: $showRank, ')
          ..write('showStreak: $showStreak, ')
          ..write('showPercent: $showPercent, ')
          ..write('showAmount: $showAmount, ')
          ..write('views: $views, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory
    with TableInfo<$SearchHistoryTable, SearchHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bundleNameMeta =
      const VerificationMeta('bundleName');
  @override
  late final GeneratedColumn<String> bundleName = GeneratedColumn<String>(
      'bundle_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<int> totalPrice = GeneratedColumn<int>(
      'total_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCurrentMeta =
      const VerificationMeta('isCurrent');
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
      'is_current', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_current" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _searchedAtMeta =
      const VerificationMeta('searchedAt');
  @override
  late final GeneratedColumn<int> searchedAt = GeneratedColumn<int>(
      'searched_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bundleName, totalPrice, score, status, isCurrent, searchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(Insertable<SearchHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bundle_name')) {
      context.handle(
          _bundleNameMeta,
          bundleName.isAcceptableOrUnknown(
              data['bundle_name']!, _bundleNameMeta));
    } else if (isInserting) {
      context.missing(_bundleNameMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_current')) {
      context.handle(_isCurrentMeta,
          isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta));
    }
    if (data.containsKey('searched_at')) {
      context.handle(
          _searchedAtMeta,
          searchedAt.isAcceptableOrUnknown(
              data['searched_at']!, _searchedAtMeta));
    } else if (isInserting) {
      context.missing(_searchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bundleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bundle_name'])!,
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_price'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isCurrent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_current'])!,
      searchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}searched_at'])!,
    );
  }

  @override
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(attachedDatabase, alias);
  }
}

class SearchHistoryData extends DataClass
    implements Insertable<SearchHistoryData> {
  final int id;
  final String bundleName;
  final int totalPrice;
  final int score;
  final String status;
  final bool isCurrent;
  final int searchedAt;
  const SearchHistoryData(
      {required this.id,
      required this.bundleName,
      required this.totalPrice,
      required this.score,
      required this.status,
      required this.isCurrent,
      required this.searchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bundle_name'] = Variable<String>(bundleName);
    map['total_price'] = Variable<int>(totalPrice);
    map['score'] = Variable<int>(score);
    map['status'] = Variable<String>(status);
    map['is_current'] = Variable<bool>(isCurrent);
    map['searched_at'] = Variable<int>(searchedAt);
    return map;
  }

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(
      id: Value(id),
      bundleName: Value(bundleName),
      totalPrice: Value(totalPrice),
      score: Value(score),
      status: Value(status),
      isCurrent: Value(isCurrent),
      searchedAt: Value(searchedAt),
    );
  }

  factory SearchHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryData(
      id: serializer.fromJson<int>(json['id']),
      bundleName: serializer.fromJson<String>(json['bundleName']),
      totalPrice: serializer.fromJson<int>(json['totalPrice']),
      score: serializer.fromJson<int>(json['score']),
      status: serializer.fromJson<String>(json['status']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      searchedAt: serializer.fromJson<int>(json['searchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bundleName': serializer.toJson<String>(bundleName),
      'totalPrice': serializer.toJson<int>(totalPrice),
      'score': serializer.toJson<int>(score),
      'status': serializer.toJson<String>(status),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'searchedAt': serializer.toJson<int>(searchedAt),
    };
  }

  SearchHistoryData copyWith(
          {int? id,
          String? bundleName,
          int? totalPrice,
          int? score,
          String? status,
          bool? isCurrent,
          int? searchedAt}) =>
      SearchHistoryData(
        id: id ?? this.id,
        bundleName: bundleName ?? this.bundleName,
        totalPrice: totalPrice ?? this.totalPrice,
        score: score ?? this.score,
        status: status ?? this.status,
        isCurrent: isCurrent ?? this.isCurrent,
        searchedAt: searchedAt ?? this.searchedAt,
      );
  SearchHistoryData copyWithCompanion(SearchHistoryCompanion data) {
    return SearchHistoryData(
      id: data.id.present ? data.id.value : this.id,
      bundleName:
          data.bundleName.present ? data.bundleName.value : this.bundleName,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      score: data.score.present ? data.score.value : this.score,
      status: data.status.present ? data.status.value : this.status,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      searchedAt:
          data.searchedAt.present ? data.searchedAt.value : this.searchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryData(')
          ..write('id: $id, ')
          ..write('bundleName: $bundleName, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bundleName, totalPrice, score, status, isCurrent, searchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryData &&
          other.id == this.id &&
          other.bundleName == this.bundleName &&
          other.totalPrice == this.totalPrice &&
          other.score == this.score &&
          other.status == this.status &&
          other.isCurrent == this.isCurrent &&
          other.searchedAt == this.searchedAt);
}

class SearchHistoryCompanion extends UpdateCompanion<SearchHistoryData> {
  final Value<int> id;
  final Value<String> bundleName;
  final Value<int> totalPrice;
  final Value<int> score;
  final Value<String> status;
  final Value<bool> isCurrent;
  final Value<int> searchedAt;
  const SearchHistoryCompanion({
    this.id = const Value.absent(),
    this.bundleName = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.score = const Value.absent(),
    this.status = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.searchedAt = const Value.absent(),
  });
  SearchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String bundleName,
    required int totalPrice,
    required int score,
    required String status,
    this.isCurrent = const Value.absent(),
    required int searchedAt,
  })  : bundleName = Value(bundleName),
        totalPrice = Value(totalPrice),
        score = Value(score),
        status = Value(status),
        searchedAt = Value(searchedAt);
  static Insertable<SearchHistoryData> custom({
    Expression<int>? id,
    Expression<String>? bundleName,
    Expression<int>? totalPrice,
    Expression<int>? score,
    Expression<String>? status,
    Expression<bool>? isCurrent,
    Expression<int>? searchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bundleName != null) 'bundle_name': bundleName,
      if (totalPrice != null) 'total_price': totalPrice,
      if (score != null) 'score': score,
      if (status != null) 'status': status,
      if (isCurrent != null) 'is_current': isCurrent,
      if (searchedAt != null) 'searched_at': searchedAt,
    });
  }

  SearchHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? bundleName,
      Value<int>? totalPrice,
      Value<int>? score,
      Value<String>? status,
      Value<bool>? isCurrent,
      Value<int>? searchedAt}) {
    return SearchHistoryCompanion(
      id: id ?? this.id,
      bundleName: bundleName ?? this.bundleName,
      totalPrice: totalPrice ?? this.totalPrice,
      score: score ?? this.score,
      status: status ?? this.status,
      isCurrent: isCurrent ?? this.isCurrent,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bundleName.present) {
      map['bundle_name'] = Variable<String>(bundleName.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<int>(totalPrice.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<int>(searchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('bundleName: $bundleName, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }
}

class $AppConfigTableTable extends AppConfigTable
    with TableInfo<$AppConfigTableTable, AppConfigTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueJsonMeta =
      const VerificationMeta('valueJson');
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
      'value_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_config_table';
  @override
  VerificationContext validateIntegrity(Insertable<AppConfigTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(_valueJsonMeta,
          valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta));
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppConfigTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppConfigTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      valueJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppConfigTableTable createAlias(String alias) {
    return $AppConfigTableTable(attachedDatabase, alias);
  }
}

class AppConfigTableData extends DataClass
    implements Insertable<AppConfigTableData> {
  final String key;
  final String valueJson;
  final int updatedAt;
  const AppConfigTableData(
      {required this.key, required this.valueJson, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppConfigTableCompanion toCompanion(bool nullToAbsent) {
    return AppConfigTableCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppConfigTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppConfigTableData(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppConfigTableData copyWith(
          {String? key, String? valueJson, int? updatedAt}) =>
      AppConfigTableData(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppConfigTableData copyWithCompanion(AppConfigTableCompanion data) {
    return AppConfigTableData(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigTableData(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppConfigTableData &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt);
}

class AppConfigTableCompanion extends UpdateCompanion<AppConfigTableData> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppConfigTableCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppConfigTableCompanion.insert({
    required String key,
    required String valueJson,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        valueJson = Value(valueJson),
        updatedAt = Value(updatedAt);
  static Insertable<AppConfigTableData> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppConfigTableCompanion copyWith(
      {Value<String>? key,
      Value<String>? valueJson,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return AppConfigTableCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigTableCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PinMetaTable extends PinMeta with TableInfo<$PinMetaTable, PinMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
      'salt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _failedAttemptsMeta =
      const VerificationMeta('failedAttempts');
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
      'failed_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockedUntilMeta =
      const VerificationMeta('lockedUntil');
  @override
  late final GeneratedColumn<int> lockedUntil = GeneratedColumn<int>(
      'locked_until', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _biometricEnabledMeta =
      const VerificationMeta('biometricEnabled');
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
      'biometric_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("biometric_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _autolockMinutesMeta =
      const VerificationMeta('autolockMinutes');
  @override
  late final GeneratedColumn<int> autolockMinutes = GeneratedColumn<int>(
      'autolock_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pinHash,
        salt,
        failedAttempts,
        lockedUntil,
        biometricEnabled,
        autolockMinutes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pin_meta';
  @override
  VerificationContext validateIntegrity(Insertable<PinMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
          _failedAttemptsMeta,
          failedAttempts.isAcceptableOrUnknown(
              data['failed_attempts']!, _failedAttemptsMeta));
    }
    if (data.containsKey('locked_until')) {
      context.handle(
          _lockedUntilMeta,
          lockedUntil.isAcceptableOrUnknown(
              data['locked_until']!, _lockedUntilMeta));
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
          _biometricEnabledMeta,
          biometricEnabled.isAcceptableOrUnknown(
              data['biometric_enabled']!, _biometricEnabledMeta));
    }
    if (data.containsKey('autolock_minutes')) {
      context.handle(
          _autolockMinutesMeta,
          autolockMinutes.isAcceptableOrUnknown(
              data['autolock_minutes']!, _autolockMinutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinMetaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salt']),
      failedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_attempts'])!,
      lockedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}locked_until']),
      biometricEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}biometric_enabled'])!,
      autolockMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}autolock_minutes'])!,
    );
  }

  @override
  $PinMetaTable createAlias(String alias) {
    return $PinMetaTable(attachedDatabase, alias);
  }
}

class PinMetaData extends DataClass implements Insertable<PinMetaData> {
  final String id;
  final String? pinHash;
  final String? salt;
  final int failedAttempts;
  final int? lockedUntil;
  final bool biometricEnabled;
  final int autolockMinutes;
  const PinMetaData(
      {required this.id,
      this.pinHash,
      this.salt,
      required this.failedAttempts,
      this.lockedUntil,
      required this.biometricEnabled,
      required this.autolockMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    if (!nullToAbsent || salt != null) {
      map['salt'] = Variable<String>(salt);
    }
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<int>(lockedUntil);
    }
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['autolock_minutes'] = Variable<int>(autolockMinutes);
    return map;
  }

  PinMetaCompanion toCompanion(bool nullToAbsent) {
    return PinMetaCompanion(
      id: Value(id),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      salt: salt == null && nullToAbsent ? const Value.absent() : Value(salt),
      failedAttempts: Value(failedAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      biometricEnabled: Value(biometricEnabled),
      autolockMinutes: Value(autolockMinutes),
    );
  }

  factory PinMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinMetaData(
      id: serializer.fromJson<String>(json['id']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      salt: serializer.fromJson<String?>(json['salt']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockedUntil: serializer.fromJson<int?>(json['lockedUntil']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      autolockMinutes: serializer.fromJson<int>(json['autolockMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pinHash': serializer.toJson<String?>(pinHash),
      'salt': serializer.toJson<String?>(salt),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockedUntil': serializer.toJson<int?>(lockedUntil),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'autolockMinutes': serializer.toJson<int>(autolockMinutes),
    };
  }

  PinMetaData copyWith(
          {String? id,
          Value<String?> pinHash = const Value.absent(),
          Value<String?> salt = const Value.absent(),
          int? failedAttempts,
          Value<int?> lockedUntil = const Value.absent(),
          bool? biometricEnabled,
          int? autolockMinutes}) =>
      PinMetaData(
        id: id ?? this.id,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
        salt: salt.present ? salt.value : this.salt,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        autolockMinutes: autolockMinutes ?? this.autolockMinutes,
      );
  PinMetaData copyWithCompanion(PinMetaCompanion data) {
    return PinMetaData(
      id: data.id.present ? data.id.value : this.id,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      salt: data.salt.present ? data.salt.value : this.salt,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockedUntil:
          data.lockedUntil.present ? data.lockedUntil.value : this.lockedUntil,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      autolockMinutes: data.autolockMinutes.present
          ? data.autolockMinutes.value
          : this.autolockMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinMetaData(')
          ..write('id: $id, ')
          ..write('pinHash: $pinHash, ')
          ..write('salt: $salt, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('autolockMinutes: $autolockMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pinHash, salt, failedAttempts,
      lockedUntil, biometricEnabled, autolockMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinMetaData &&
          other.id == this.id &&
          other.pinHash == this.pinHash &&
          other.salt == this.salt &&
          other.failedAttempts == this.failedAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.biometricEnabled == this.biometricEnabled &&
          other.autolockMinutes == this.autolockMinutes);
}

class PinMetaCompanion extends UpdateCompanion<PinMetaData> {
  final Value<String> id;
  final Value<String?> pinHash;
  final Value<String?> salt;
  final Value<int> failedAttempts;
  final Value<int?> lockedUntil;
  final Value<bool> biometricEnabled;
  final Value<int> autolockMinutes;
  final Value<int> rowid;
  const PinMetaCompanion({
    this.id = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.autolockMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinMetaCompanion.insert({
    required String id,
    this.pinHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.autolockMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PinMetaData> custom({
    Expression<String>? id,
    Expression<String>? pinHash,
    Expression<String>? salt,
    Expression<int>? failedAttempts,
    Expression<int>? lockedUntil,
    Expression<bool>? biometricEnabled,
    Expression<int>? autolockMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pinHash != null) 'pin_hash': pinHash,
      if (salt != null) 'salt': salt,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (autolockMinutes != null) 'autolock_minutes': autolockMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinMetaCompanion copyWith(
      {Value<String>? id,
      Value<String?>? pinHash,
      Value<String?>? salt,
      Value<int>? failedAttempts,
      Value<int?>? lockedUntil,
      Value<bool>? biometricEnabled,
      Value<int>? autolockMinutes,
      Value<int>? rowid}) {
    return PinMetaCompanion(
      id: id ?? this.id,
      pinHash: pinHash ?? this.pinHash,
      salt: salt ?? this.salt,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autolockMinutes: autolockMinutes ?? this.autolockMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<int>(lockedUntil.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (autolockMinutes.present) {
      map['autolock_minutes'] = Variable<int>(autolockMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinMetaCompanion(')
          ..write('id: $id, ')
          ..write('pinHash: $pinHash, ')
          ..write('salt: $salt, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('autolockMinutes: $autolockMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiUsageTableTable extends AiUsageTable
    with TableInfo<$AiUsageTableTable, AiUsageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiUsageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usedMeta = const VerificationMeta('used');
  @override
  late final GeneratedColumn<int> used = GeneratedColumn<int>(
      'used', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, used];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_usage_table';
  @override
  VerificationContext validateIntegrity(Insertable<AiUsageTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('used')) {
      context.handle(
          _usedMeta, used.isAcceptableOrUnknown(data['used']!, _usedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiUsageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiUsageTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      used: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}used'])!,
    );
  }

  @override
  $AiUsageTableTable createAlias(String alias) {
    return $AiUsageTableTable(attachedDatabase, alias);
  }
}

class AiUsageTableData extends DataClass
    implements Insertable<AiUsageTableData> {
  final String id;
  final int used;
  const AiUsageTableData({required this.id, required this.used});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['used'] = Variable<int>(used);
    return map;
  }

  AiUsageTableCompanion toCompanion(bool nullToAbsent) {
    return AiUsageTableCompanion(
      id: Value(id),
      used: Value(used),
    );
  }

  factory AiUsageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiUsageTableData(
      id: serializer.fromJson<String>(json['id']),
      used: serializer.fromJson<int>(json['used']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'used': serializer.toJson<int>(used),
    };
  }

  AiUsageTableData copyWith({String? id, int? used}) => AiUsageTableData(
        id: id ?? this.id,
        used: used ?? this.used,
      );
  AiUsageTableData copyWithCompanion(AiUsageTableCompanion data) {
    return AiUsageTableData(
      id: data.id.present ? data.id.value : this.id,
      used: data.used.present ? data.used.value : this.used,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageTableData(')
          ..write('id: $id, ')
          ..write('used: $used')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, used);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiUsageTableData &&
          other.id == this.id &&
          other.used == this.used);
}

class AiUsageTableCompanion extends UpdateCompanion<AiUsageTableData> {
  final Value<String> id;
  final Value<int> used;
  final Value<int> rowid;
  const AiUsageTableCompanion({
    this.id = const Value.absent(),
    this.used = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiUsageTableCompanion.insert({
    required String id,
    this.used = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<AiUsageTableData> custom({
    Expression<String>? id,
    Expression<int>? used,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (used != null) 'used': used,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiUsageTableCompanion copyWith(
      {Value<String>? id, Value<int>? used, Value<int>? rowid}) {
    return AiUsageTableCompanion(
      id: id ?? this.id,
      used: used ?? this.used,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (used.present) {
      map['used'] = Variable<int>(used.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageTableCompanion(')
          ..write('id: $id, ')
          ..write('used: $used, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RateAppStateTable extends RateAppState
    with TableInfo<$RateAppStateTable, RateAppStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RateAppStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contribsAtLastPromptMeta =
      const VerificationMeta('contribsAtLastPrompt');
  @override
  late final GeneratedColumn<int> contribsAtLastPrompt = GeneratedColumn<int>(
      'contribs_at_last_prompt', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastPromptAtMeta =
      const VerificationMeta('lastPromptAt');
  @override
  late final GeneratedColumn<int> lastPromptAt = GeneratedColumn<int>(
      'last_prompt_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _neverAskMeta =
      const VerificationMeta('neverAsk');
  @override
  late final GeneratedColumn<bool> neverAsk = GeneratedColumn<bool>(
      'never_ask', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("never_ask" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, contribsAtLastPrompt, lastPromptAt, neverAsk];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rate_app_state';
  @override
  VerificationContext validateIntegrity(Insertable<RateAppStateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('contribs_at_last_prompt')) {
      context.handle(
          _contribsAtLastPromptMeta,
          contribsAtLastPrompt.isAcceptableOrUnknown(
              data['contribs_at_last_prompt']!, _contribsAtLastPromptMeta));
    }
    if (data.containsKey('last_prompt_at')) {
      context.handle(
          _lastPromptAtMeta,
          lastPromptAt.isAcceptableOrUnknown(
              data['last_prompt_at']!, _lastPromptAtMeta));
    }
    if (data.containsKey('never_ask')) {
      context.handle(_neverAskMeta,
          neverAsk.isAcceptableOrUnknown(data['never_ask']!, _neverAskMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RateAppStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateAppStateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      contribsAtLastPrompt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}contribs_at_last_prompt'])!,
      lastPromptAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_prompt_at']),
      neverAsk: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}never_ask'])!,
    );
  }

  @override
  $RateAppStateTable createAlias(String alias) {
    return $RateAppStateTable(attachedDatabase, alias);
  }
}

class RateAppStateData extends DataClass
    implements Insertable<RateAppStateData> {
  final String id;
  final int contribsAtLastPrompt;
  final int? lastPromptAt;
  final bool neverAsk;
  const RateAppStateData(
      {required this.id,
      required this.contribsAtLastPrompt,
      this.lastPromptAt,
      required this.neverAsk});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['contribs_at_last_prompt'] = Variable<int>(contribsAtLastPrompt);
    if (!nullToAbsent || lastPromptAt != null) {
      map['last_prompt_at'] = Variable<int>(lastPromptAt);
    }
    map['never_ask'] = Variable<bool>(neverAsk);
    return map;
  }

  RateAppStateCompanion toCompanion(bool nullToAbsent) {
    return RateAppStateCompanion(
      id: Value(id),
      contribsAtLastPrompt: Value(contribsAtLastPrompt),
      lastPromptAt: lastPromptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPromptAt),
      neverAsk: Value(neverAsk),
    );
  }

  factory RateAppStateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateAppStateData(
      id: serializer.fromJson<String>(json['id']),
      contribsAtLastPrompt:
          serializer.fromJson<int>(json['contribsAtLastPrompt']),
      lastPromptAt: serializer.fromJson<int?>(json['lastPromptAt']),
      neverAsk: serializer.fromJson<bool>(json['neverAsk']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contribsAtLastPrompt': serializer.toJson<int>(contribsAtLastPrompt),
      'lastPromptAt': serializer.toJson<int?>(lastPromptAt),
      'neverAsk': serializer.toJson<bool>(neverAsk),
    };
  }

  RateAppStateData copyWith(
          {String? id,
          int? contribsAtLastPrompt,
          Value<int?> lastPromptAt = const Value.absent(),
          bool? neverAsk}) =>
      RateAppStateData(
        id: id ?? this.id,
        contribsAtLastPrompt: contribsAtLastPrompt ?? this.contribsAtLastPrompt,
        lastPromptAt:
            lastPromptAt.present ? lastPromptAt.value : this.lastPromptAt,
        neverAsk: neverAsk ?? this.neverAsk,
      );
  RateAppStateData copyWithCompanion(RateAppStateCompanion data) {
    return RateAppStateData(
      id: data.id.present ? data.id.value : this.id,
      contribsAtLastPrompt: data.contribsAtLastPrompt.present
          ? data.contribsAtLastPrompt.value
          : this.contribsAtLastPrompt,
      lastPromptAt: data.lastPromptAt.present
          ? data.lastPromptAt.value
          : this.lastPromptAt,
      neverAsk: data.neverAsk.present ? data.neverAsk.value : this.neverAsk,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateAppStateData(')
          ..write('id: $id, ')
          ..write('contribsAtLastPrompt: $contribsAtLastPrompt, ')
          ..write('lastPromptAt: $lastPromptAt, ')
          ..write('neverAsk: $neverAsk')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, contribsAtLastPrompt, lastPromptAt, neverAsk);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateAppStateData &&
          other.id == this.id &&
          other.contribsAtLastPrompt == this.contribsAtLastPrompt &&
          other.lastPromptAt == this.lastPromptAt &&
          other.neverAsk == this.neverAsk);
}

class RateAppStateCompanion extends UpdateCompanion<RateAppStateData> {
  final Value<String> id;
  final Value<int> contribsAtLastPrompt;
  final Value<int?> lastPromptAt;
  final Value<bool> neverAsk;
  final Value<int> rowid;
  const RateAppStateCompanion({
    this.id = const Value.absent(),
    this.contribsAtLastPrompt = const Value.absent(),
    this.lastPromptAt = const Value.absent(),
    this.neverAsk = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RateAppStateCompanion.insert({
    required String id,
    this.contribsAtLastPrompt = const Value.absent(),
    this.lastPromptAt = const Value.absent(),
    this.neverAsk = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<RateAppStateData> custom({
    Expression<String>? id,
    Expression<int>? contribsAtLastPrompt,
    Expression<int>? lastPromptAt,
    Expression<bool>? neverAsk,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contribsAtLastPrompt != null)
        'contribs_at_last_prompt': contribsAtLastPrompt,
      if (lastPromptAt != null) 'last_prompt_at': lastPromptAt,
      if (neverAsk != null) 'never_ask': neverAsk,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RateAppStateCompanion copyWith(
      {Value<String>? id,
      Value<int>? contribsAtLastPrompt,
      Value<int?>? lastPromptAt,
      Value<bool>? neverAsk,
      Value<int>? rowid}) {
    return RateAppStateCompanion(
      id: id ?? this.id,
      contribsAtLastPrompt: contribsAtLastPrompt ?? this.contribsAtLastPrompt,
      lastPromptAt: lastPromptAt ?? this.lastPromptAt,
      neverAsk: neverAsk ?? this.neverAsk,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contribsAtLastPrompt.present) {
      map['contribs_at_last_prompt'] =
          Variable<int>(contribsAtLastPrompt.value);
    }
    if (lastPromptAt.present) {
      map['last_prompt_at'] = Variable<int>(lastPromptAt.value);
    }
    if (neverAsk.present) {
      map['never_ask'] = Variable<bool>(neverAsk.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RateAppStateCompanion(')
          ..write('id: $id, ')
          ..write('contribsAtLastPrompt: $contribsAtLastPrompt, ')
          ..write('lastPromptAt: $lastPromptAt, ')
          ..write('neverAsk: $neverAsk, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(Insertable<MetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaData extends DataClass implements Insertable<MetaData> {
  final String key;
  final int value;
  const MetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<int>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory MetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<int>(value),
    };
  }

  MetaData copyWith({String? key, int? value}) => MetaData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  MetaData copyWithCompanion(MetaCompanion data) {
    return MetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaData && other.key == this.key && other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaData> {
  final Value<String> key;
  final Value<int> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<MetaData> custom({
    Expression<String>? key,
    Expression<int>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith(
      {Value<String>? key, Value<int>? value, Value<int>? rowid}) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $GoalItemsTable goalItems = $GoalItemsTable(this);
  late final $ContributionsTable contributions = $ContributionsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $AchievementsUnlockedTable achievementsUnlocked =
      $AchievementsUnlockedTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $UserStatsTableTable userStatsTable = $UserStatsTableTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $PriceHistoryTable priceHistory = $PriceHistoryTable(this);
  late final $ScanRunsTable scanRuns = $ScanRunsTable(this);
  late final $MonitorSpecsTable monitorSpecs = $MonitorSpecsTable(this);
  late final $Ps5SpecsTable ps5Specs = $Ps5SpecsTable(this);
  late final $NotificationsCacheTable notificationsCache =
      $NotificationsCacheTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $ChipsWalletTableTable chipsWalletTable =
      $ChipsWalletTableTable(this);
  late final $ChipsLedgerTable chipsLedger = $ChipsLedgerTable(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $PetSkinsTable petSkins = $PetSkinsTable(this);
  late final $QuestsDailyTable questsDaily = $QuestsDailyTable(this);
  late final $QuestsWeeklyTable questsWeekly = $QuestsWeeklyTable(this);
  late final $ChestsTable chests = $ChestsTable(this);
  late final $HoloSetsTable holoSets = $HoloSetsTable(this);
  late final $HoloCardsTable holoCards = $HoloCardsTable(this);
  late final $HoloOwnedTable holoOwned = $HoloOwnedTable(this);
  late final $EventsCacheTable eventsCache = $EventsCacheTable(this);
  late final $EventQuestsTable eventQuests = $EventQuestsTable(this);
  late final $BuddyCacheTable buddyCache = $BuddyCacheTable(this);
  late final $GhostCacheTable ghostCache = $GhostCacheTable(this);
  late final $LeaderboardOptInTable leaderboardOptIn =
      $LeaderboardOptInTable(this);
  late final $ApiKeysTable apiKeys = $ApiKeysTable(this);
  late final $ProgressCardsTable progressCards = $ProgressCardsTable(this);
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final $AppConfigTableTable appConfigTable = $AppConfigTableTable(this);
  late final $PinMetaTable pinMeta = $PinMetaTable(this);
  late final $AiUsageTableTable aiUsageTable = $AiUsageTableTable(this);
  late final $RateAppStateTable rateAppState = $RateAppStateTable(this);
  late final $MetaTable meta = $MetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        goals,
        goalItems,
        contributions,
        achievements,
        achievementsUnlocked,
        settings,
        userStatsTable,
        chatMessages,
        priceHistory,
        scanRuns,
        monitorSpecs,
        ps5Specs,
        notificationsCache,
        syncQueue,
        chipsWalletTable,
        chipsLedger,
        pets,
        petSkins,
        questsDaily,
        questsWeekly,
        chests,
        holoSets,
        holoCards,
        holoOwned,
        eventsCache,
        eventQuests,
        buddyCache,
        ghostCache,
        leaderboardOptIn,
        apiKeys,
        progressCards,
        searchHistory,
        appConfigTable,
        pinMeta,
        aiUsageTable,
        rateAppState,
        meta
      ];
}

typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String title,
  required int ps5Price,
  required int monitorPrice,
  required int createdAt,
  Value<bool> completed,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<int> ps5Price,
  Value<int> monitorPrice,
  Value<int> createdAt,
  Value<bool> completed,
  Value<bool> synced,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
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

  ColumnFilters<int> get ps5Price => $composableBuilder(
      column: $table.ps5Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monitorPrice => $composableBuilder(
      column: $table.monitorPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
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

  ColumnOrderings<int> get ps5Price => $composableBuilder(
      column: $table.ps5Price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monitorPrice => $composableBuilder(
      column: $table.monitorPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
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

  GeneratedColumn<int> get ps5Price =>
      $composableBuilder(column: $table.ps5Price, builder: (column) => column);

  GeneratedColumn<int> get monitorPrice => $composableBuilder(
      column: $table.monitorPrice, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
    Goal,
    PrefetchHooks Function()> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> ps5Price = const Value.absent(),
            Value<int> monitorPrice = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            title: title,
            ps5Price: ps5Price,
            monitorPrice: monitorPrice,
            createdAt: createdAt,
            completed: completed,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required int ps5Price,
            required int monitorPrice,
            required int createdAt,
            Value<bool> completed = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            id: id,
            title: title,
            ps5Price: ps5Price,
            monitorPrice: monitorPrice,
            createdAt: createdAt,
            completed: completed,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
    Goal,
    PrefetchHooks Function()>;
typedef $$GoalItemsTableCreateCompanionBuilder = GoalItemsCompanion Function({
  required String id,
  required String goalId,
  required String kind,
  required String title,
  required int targetPrice,
  Value<int> rowid,
});
typedef $$GoalItemsTableUpdateCompanionBuilder = GoalItemsCompanion Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> kind,
  Value<String> title,
  Value<int> targetPrice,
  Value<int> rowid,
});

class $$GoalItemsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalItemsTable> {
  $$GoalItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => ColumnFilters(column));
}

class $$GoalItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalItemsTable> {
  $$GoalItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => ColumnOrderings(column));
}

class $$GoalItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalItemsTable> {
  $$GoalItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => column);
}

class $$GoalItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalItemsTable,
    GoalItem,
    $$GoalItemsTableFilterComposer,
    $$GoalItemsTableOrderingComposer,
    $$GoalItemsTableAnnotationComposer,
    $$GoalItemsTableCreateCompanionBuilder,
    $$GoalItemsTableUpdateCompanionBuilder,
    (GoalItem, BaseReferences<_$AppDatabase, $GoalItemsTable, GoalItem>),
    GoalItem,
    PrefetchHooks Function()> {
  $$GoalItemsTableTableManager(_$AppDatabase db, $GoalItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> targetPrice = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalItemsCompanion(
            id: id,
            goalId: goalId,
            kind: kind,
            title: title,
            targetPrice: targetPrice,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String goalId,
            required String kind,
            required String title,
            required int targetPrice,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalItemsCompanion.insert(
            id: id,
            goalId: goalId,
            kind: kind,
            title: title,
            targetPrice: targetPrice,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalItemsTable,
    GoalItem,
    $$GoalItemsTableFilterComposer,
    $$GoalItemsTableOrderingComposer,
    $$GoalItemsTableAnnotationComposer,
    $$GoalItemsTableCreateCompanionBuilder,
    $$GoalItemsTableUpdateCompanionBuilder,
    (GoalItem, BaseReferences<_$AppDatabase, $GoalItemsTable, GoalItem>),
    GoalItem,
    PrefetchHooks Function()>;
typedef $$ContributionsTableCreateCompanionBuilder = ContributionsCompanion
    Function({
  required String id,
  required String goalId,
  required int amount,
  Value<String?> comment,
  Value<String?> receiptPath,
  Value<int> xpEarned,
  Value<int> streakBonus,
  required int occurredAt,
  required int createdAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$ContributionsTableUpdateCompanionBuilder = ContributionsCompanion
    Function({
  Value<String> id,
  Value<String> goalId,
  Value<int> amount,
  Value<String?> comment,
  Value<String?> receiptPath,
  Value<int> xpEarned,
  Value<int> streakBonus,
  Value<int> occurredAt,
  Value<int> createdAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$ContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $ContributionsTable> {
  $$ContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptPath => $composableBuilder(
      column: $table.receiptPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakBonus => $composableBuilder(
      column: $table.streakBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$ContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContributionsTable> {
  $$ContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptPath => $composableBuilder(
      column: $table.receiptPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakBonus => $composableBuilder(
      column: $table.streakBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$ContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContributionsTable> {
  $$ContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
      column: $table.receiptPath, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<int> get streakBonus => $composableBuilder(
      column: $table.streakBonus, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$ContributionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContributionsTable,
    Contribution,
    $$ContributionsTableFilterComposer,
    $$ContributionsTableOrderingComposer,
    $$ContributionsTableAnnotationComposer,
    $$ContributionsTableCreateCompanionBuilder,
    $$ContributionsTableUpdateCompanionBuilder,
    (
      Contribution,
      BaseReferences<_$AppDatabase, $ContributionsTable, Contribution>
    ),
    Contribution,
    PrefetchHooks Function()> {
  $$ContributionsTableTableManager(_$AppDatabase db, $ContributionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContributionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> receiptPath = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<int> streakBonus = const Value.absent(),
            Value<int> occurredAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContributionsCompanion(
            id: id,
            goalId: goalId,
            amount: amount,
            comment: comment,
            receiptPath: receiptPath,
            xpEarned: xpEarned,
            streakBonus: streakBonus,
            occurredAt: occurredAt,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String goalId,
            required int amount,
            Value<String?> comment = const Value.absent(),
            Value<String?> receiptPath = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<int> streakBonus = const Value.absent(),
            required int occurredAt,
            required int createdAt,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContributionsCompanion.insert(
            id: id,
            goalId: goalId,
            amount: amount,
            comment: comment,
            receiptPath: receiptPath,
            xpEarned: xpEarned,
            streakBonus: streakBonus,
            occurredAt: occurredAt,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContributionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContributionsTable,
    Contribution,
    $$ContributionsTableFilterComposer,
    $$ContributionsTableOrderingComposer,
    $$ContributionsTableAnnotationComposer,
    $$ContributionsTableCreateCompanionBuilder,
    $$ContributionsTableUpdateCompanionBuilder,
    (
      Contribution,
      BaseReferences<_$AppDatabase, $ContributionsTable, Contribution>
    ),
    Contribution,
    PrefetchHooks Function()>;
typedef $$AchievementsTableCreateCompanionBuilder = AchievementsCompanion
    Function({
  required String id,
  required String category,
  required int bonusXp,
  Value<bool> secret,
  Value<int> rowid,
});
typedef $$AchievementsTableUpdateCompanionBuilder = AchievementsCompanion
    Function({
  Value<String> id,
  Value<String> category,
  Value<int> bonusXp,
  Value<bool> secret,
  Value<int> rowid,
});

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bonusXp => $composableBuilder(
      column: $table.bonusXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get secret => $composableBuilder(
      column: $table.secret, builder: (column) => ColumnFilters(column));
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bonusXp => $composableBuilder(
      column: $table.bonusXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get secret => $composableBuilder(
      column: $table.secret, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get bonusXp =>
      $composableBuilder(column: $table.bonusXp, builder: (column) => column);

  GeneratedColumn<bool> get secret =>
      $composableBuilder(column: $table.secret, builder: (column) => column);
}

class $$AchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      Achievement,
      BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>
    ),
    Achievement,
    PrefetchHooks Function()> {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> bonusXp = const Value.absent(),
            Value<bool> secret = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsCompanion(
            id: id,
            category: category,
            bonusXp: bonusXp,
            secret: secret,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String category,
            required int bonusXp,
            Value<bool> secret = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsCompanion.insert(
            id: id,
            category: category,
            bonusXp: bonusXp,
            secret: secret,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      Achievement,
      BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>
    ),
    Achievement,
    PrefetchHooks Function()>;
typedef $$AchievementsUnlockedTableCreateCompanionBuilder
    = AchievementsUnlockedCompanion Function({
  required String achievementId,
  required int unlockedAt,
  Value<int> rowid,
});
typedef $$AchievementsUnlockedTableUpdateCompanionBuilder
    = AchievementsUnlockedCompanion Function({
  Value<String> achievementId,
  Value<int> unlockedAt,
  Value<int> rowid,
});

class $$AchievementsUnlockedTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsUnlockedTable> {
  $$AchievementsUnlockedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
      column: $table.achievementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementsUnlockedTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsUnlockedTable> {
  $$AchievementsUnlockedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
      column: $table.achievementId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsUnlockedTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsUnlockedTable> {
  $$AchievementsUnlockedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
      column: $table.achievementId, builder: (column) => column);

  GeneratedColumn<int> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$AchievementsUnlockedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsUnlockedTable,
    AchievementsUnlockedData,
    $$AchievementsUnlockedTableFilterComposer,
    $$AchievementsUnlockedTableOrderingComposer,
    $$AchievementsUnlockedTableAnnotationComposer,
    $$AchievementsUnlockedTableCreateCompanionBuilder,
    $$AchievementsUnlockedTableUpdateCompanionBuilder,
    (
      AchievementsUnlockedData,
      BaseReferences<_$AppDatabase, $AchievementsUnlockedTable,
          AchievementsUnlockedData>
    ),
    AchievementsUnlockedData,
    PrefetchHooks Function()> {
  $$AchievementsUnlockedTableTableManager(
      _$AppDatabase db, $AchievementsUnlockedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsUnlockedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsUnlockedTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsUnlockedTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> achievementId = const Value.absent(),
            Value<int> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsUnlockedCompanion(
            achievementId: achievementId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String achievementId,
            required int unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsUnlockedCompanion.insert(
            achievementId: achievementId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsUnlockedTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $AchievementsUnlockedTable,
        AchievementsUnlockedData,
        $$AchievementsUnlockedTableFilterComposer,
        $$AchievementsUnlockedTableOrderingComposer,
        $$AchievementsUnlockedTableAnnotationComposer,
        $$AchievementsUnlockedTableCreateCompanionBuilder,
        $$AchievementsUnlockedTableUpdateCompanionBuilder,
        (
          AchievementsUnlockedData,
          BaseReferences<_$AppDatabase, $AchievementsUnlockedTable,
              AchievementsUnlockedData>
        ),
        AchievementsUnlockedData,
        PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$UserStatsTableTableCreateCompanionBuilder = UserStatsTableCompanion
    Function({
  required String id,
  Value<int> totalXp,
  Value<int> level,
  Value<int> streakDays,
  Value<String?> lastContributionDay,
  Value<int> contributionsCount,
  Value<int> maxSingleContribution,
  Value<int> scannerChecks,
  Value<int> priceDropsSeen,
  Value<bool> goodDealSeen,
  Value<String> visitedScreens,
  Value<int> themeChanges,
  Value<int> aiQuestions,
  Value<bool> historyViewed30d,
  required int installDate,
  Value<String> nickname,
  Value<String> avatarSeed,
  required String userId,
  Value<String?> email,
  Value<bool> authed,
  Value<int?> registeredAt,
  Value<int> rowid,
});
typedef $$UserStatsTableTableUpdateCompanionBuilder = UserStatsTableCompanion
    Function({
  Value<String> id,
  Value<int> totalXp,
  Value<int> level,
  Value<int> streakDays,
  Value<String?> lastContributionDay,
  Value<int> contributionsCount,
  Value<int> maxSingleContribution,
  Value<int> scannerChecks,
  Value<int> priceDropsSeen,
  Value<bool> goodDealSeen,
  Value<String> visitedScreens,
  Value<int> themeChanges,
  Value<int> aiQuestions,
  Value<bool> historyViewed30d,
  Value<int> installDate,
  Value<String> nickname,
  Value<String> avatarSeed,
  Value<String> userId,
  Value<String?> email,
  Value<bool> authed,
  Value<int?> registeredAt,
  Value<int> rowid,
});

class $$UserStatsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastContributionDay => $composableBuilder(
      column: $table.lastContributionDay,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get contributionsCount => $composableBuilder(
      column: $table.contributionsCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxSingleContribution => $composableBuilder(
      column: $table.maxSingleContribution,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scannerChecks => $composableBuilder(
      column: $table.scannerChecks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceDropsSeen => $composableBuilder(
      column: $table.priceDropsSeen,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get goodDealSeen => $composableBuilder(
      column: $table.goodDealSeen, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visitedScreens => $composableBuilder(
      column: $table.visitedScreens,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get themeChanges => $composableBuilder(
      column: $table.themeChanges, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aiQuestions => $composableBuilder(
      column: $table.aiQuestions, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get historyViewed30d => $composableBuilder(
      column: $table.historyViewed30d,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installDate => $composableBuilder(
      column: $table.installDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarSeed => $composableBuilder(
      column: $table.avatarSeed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get authed => $composableBuilder(
      column: $table.authed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get registeredAt => $composableBuilder(
      column: $table.registeredAt, builder: (column) => ColumnFilters(column));
}

class $$UserStatsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastContributionDay => $composableBuilder(
      column: $table.lastContributionDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contributionsCount => $composableBuilder(
      column: $table.contributionsCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxSingleContribution => $composableBuilder(
      column: $table.maxSingleContribution,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scannerChecks => $composableBuilder(
      column: $table.scannerChecks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceDropsSeen => $composableBuilder(
      column: $table.priceDropsSeen,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get goodDealSeen => $composableBuilder(
      column: $table.goodDealSeen,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visitedScreens => $composableBuilder(
      column: $table.visitedScreens,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get themeChanges => $composableBuilder(
      column: $table.themeChanges,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aiQuestions => $composableBuilder(
      column: $table.aiQuestions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get historyViewed30d => $composableBuilder(
      column: $table.historyViewed30d,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installDate => $composableBuilder(
      column: $table.installDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarSeed => $composableBuilder(
      column: $table.avatarSeed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get authed => $composableBuilder(
      column: $table.authed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get registeredAt => $composableBuilder(
      column: $table.registeredAt,
      builder: (column) => ColumnOrderings(column));
}

class $$UserStatsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => column);

  GeneratedColumn<String> get lastContributionDay => $composableBuilder(
      column: $table.lastContributionDay, builder: (column) => column);

  GeneratedColumn<int> get contributionsCount => $composableBuilder(
      column: $table.contributionsCount, builder: (column) => column);

  GeneratedColumn<int> get maxSingleContribution => $composableBuilder(
      column: $table.maxSingleContribution, builder: (column) => column);

  GeneratedColumn<int> get scannerChecks => $composableBuilder(
      column: $table.scannerChecks, builder: (column) => column);

  GeneratedColumn<int> get priceDropsSeen => $composableBuilder(
      column: $table.priceDropsSeen, builder: (column) => column);

  GeneratedColumn<bool> get goodDealSeen => $composableBuilder(
      column: $table.goodDealSeen, builder: (column) => column);

  GeneratedColumn<String> get visitedScreens => $composableBuilder(
      column: $table.visitedScreens, builder: (column) => column);

  GeneratedColumn<int> get themeChanges => $composableBuilder(
      column: $table.themeChanges, builder: (column) => column);

  GeneratedColumn<int> get aiQuestions => $composableBuilder(
      column: $table.aiQuestions, builder: (column) => column);

  GeneratedColumn<bool> get historyViewed30d => $composableBuilder(
      column: $table.historyViewed30d, builder: (column) => column);

  GeneratedColumn<int> get installDate => $composableBuilder(
      column: $table.installDate, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatarSeed => $composableBuilder(
      column: $table.avatarSeed, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get authed =>
      $composableBuilder(column: $table.authed, builder: (column) => column);

  GeneratedColumn<int> get registeredAt => $composableBuilder(
      column: $table.registeredAt, builder: (column) => column);
}

class $$UserStatsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserStatsTableTable,
    UserStatsTableData,
    $$UserStatsTableTableFilterComposer,
    $$UserStatsTableTableOrderingComposer,
    $$UserStatsTableTableAnnotationComposer,
    $$UserStatsTableTableCreateCompanionBuilder,
    $$UserStatsTableTableUpdateCompanionBuilder,
    (
      UserStatsTableData,
      BaseReferences<_$AppDatabase, $UserStatsTableTable, UserStatsTableData>
    ),
    UserStatsTableData,
    PrefetchHooks Function()> {
  $$UserStatsTableTableTableManager(
      _$AppDatabase db, $UserStatsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> totalXp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<String?> lastContributionDay = const Value.absent(),
            Value<int> contributionsCount = const Value.absent(),
            Value<int> maxSingleContribution = const Value.absent(),
            Value<int> scannerChecks = const Value.absent(),
            Value<int> priceDropsSeen = const Value.absent(),
            Value<bool> goodDealSeen = const Value.absent(),
            Value<String> visitedScreens = const Value.absent(),
            Value<int> themeChanges = const Value.absent(),
            Value<int> aiQuestions = const Value.absent(),
            Value<bool> historyViewed30d = const Value.absent(),
            Value<int> installDate = const Value.absent(),
            Value<String> nickname = const Value.absent(),
            Value<String> avatarSeed = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<bool> authed = const Value.absent(),
            Value<int?> registeredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserStatsTableCompanion(
            id: id,
            totalXp: totalXp,
            level: level,
            streakDays: streakDays,
            lastContributionDay: lastContributionDay,
            contributionsCount: contributionsCount,
            maxSingleContribution: maxSingleContribution,
            scannerChecks: scannerChecks,
            priceDropsSeen: priceDropsSeen,
            goodDealSeen: goodDealSeen,
            visitedScreens: visitedScreens,
            themeChanges: themeChanges,
            aiQuestions: aiQuestions,
            historyViewed30d: historyViewed30d,
            installDate: installDate,
            nickname: nickname,
            avatarSeed: avatarSeed,
            userId: userId,
            email: email,
            authed: authed,
            registeredAt: registeredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> totalXp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<String?> lastContributionDay = const Value.absent(),
            Value<int> contributionsCount = const Value.absent(),
            Value<int> maxSingleContribution = const Value.absent(),
            Value<int> scannerChecks = const Value.absent(),
            Value<int> priceDropsSeen = const Value.absent(),
            Value<bool> goodDealSeen = const Value.absent(),
            Value<String> visitedScreens = const Value.absent(),
            Value<int> themeChanges = const Value.absent(),
            Value<int> aiQuestions = const Value.absent(),
            Value<bool> historyViewed30d = const Value.absent(),
            required int installDate,
            Value<String> nickname = const Value.absent(),
            Value<String> avatarSeed = const Value.absent(),
            required String userId,
            Value<String?> email = const Value.absent(),
            Value<bool> authed = const Value.absent(),
            Value<int?> registeredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserStatsTableCompanion.insert(
            id: id,
            totalXp: totalXp,
            level: level,
            streakDays: streakDays,
            lastContributionDay: lastContributionDay,
            contributionsCount: contributionsCount,
            maxSingleContribution: maxSingleContribution,
            scannerChecks: scannerChecks,
            priceDropsSeen: priceDropsSeen,
            goodDealSeen: goodDealSeen,
            visitedScreens: visitedScreens,
            themeChanges: themeChanges,
            aiQuestions: aiQuestions,
            historyViewed30d: historyViewed30d,
            installDate: installDate,
            nickname: nickname,
            avatarSeed: avatarSeed,
            userId: userId,
            email: email,
            authed: authed,
            registeredAt: registeredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserStatsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserStatsTableTable,
    UserStatsTableData,
    $$UserStatsTableTableFilterComposer,
    $$UserStatsTableTableOrderingComposer,
    $$UserStatsTableTableAnnotationComposer,
    $$UserStatsTableTableCreateCompanionBuilder,
    $$UserStatsTableTableUpdateCompanionBuilder,
    (
      UserStatsTableData,
      BaseReferences<_$AppDatabase, $UserStatsTableTable, UserStatsTableData>
    ),
    UserStatsTableData,
    PrefetchHooks Function()>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  required String id,
  required String role,
  required String mode,
  required String content,
  required int createdAt,
  Value<bool> fromFallback,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<String> id,
  Value<String> role,
  Value<String> mode,
  Value<String> content,
  Value<int> createdAt,
  Value<bool> fromFallback,
  Value<bool> synced,
  Value<int> rowid,
});

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fromFallback => $composableBuilder(
      column: $table.fromFallback, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fromFallback => $composableBuilder(
      column: $table.fromFallback,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get fromFallback => $composableBuilder(
      column: $table.fromFallback, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessage,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>
    ),
    ChatMessage,
    PrefetchHooks Function()> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<bool> fromFallback = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            role: role,
            mode: mode,
            content: content,
            createdAt: createdAt,
            fromFallback: fromFallback,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String role,
            required String mode,
            required String content,
            required int createdAt,
            Value<bool> fromFallback = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            role: role,
            mode: mode,
            content: content,
            createdAt: createdAt,
            fromFallback: fromFallback,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessage,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>
    ),
    ChatMessage,
    PrefetchHooks Function()>;
typedef $$PriceHistoryTableCreateCompanionBuilder = PriceHistoryCompanion
    Function({
  required String id,
  required String storeId,
  required String product,
  required int price,
  Value<String> url,
  Value<bool> urlVerified,
  required int checkedAt,
  required String availability,
  Value<int> warrantyMonths,
  Value<int> returnDays,
  Value<String> kit,
  Value<String> state,
  Value<String> source,
  Value<String?> city,
  Value<int> deliveryCost,
  Value<int> otherCosts,
  Value<bool> isSeed,
  Value<int> rowid,
});
typedef $$PriceHistoryTableUpdateCompanionBuilder = PriceHistoryCompanion
    Function({
  Value<String> id,
  Value<String> storeId,
  Value<String> product,
  Value<int> price,
  Value<String> url,
  Value<bool> urlVerified,
  Value<int> checkedAt,
  Value<String> availability,
  Value<int> warrantyMonths,
  Value<int> returnDays,
  Value<String> kit,
  Value<String> state,
  Value<String> source,
  Value<String?> city,
  Value<int> deliveryCost,
  Value<int> otherCosts,
  Value<bool> isSeed,
  Value<int> rowid,
});

class $$PriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storeId => $composableBuilder(
      column: $table.storeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get product => $composableBuilder(
      column: $table.product, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get urlVerified => $composableBuilder(
      column: $table.urlVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkedAt => $composableBuilder(
      column: $table.checkedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get availability => $composableBuilder(
      column: $table.availability, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warrantyMonths => $composableBuilder(
      column: $table.warrantyMonths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get returnDays => $composableBuilder(
      column: $table.returnDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kit => $composableBuilder(
      column: $table.kit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deliveryCost => $composableBuilder(
      column: $table.deliveryCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get otherCosts => $composableBuilder(
      column: $table.otherCosts, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSeed => $composableBuilder(
      column: $table.isSeed, builder: (column) => ColumnFilters(column));
}

class $$PriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storeId => $composableBuilder(
      column: $table.storeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get product => $composableBuilder(
      column: $table.product, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get urlVerified => $composableBuilder(
      column: $table.urlVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkedAt => $composableBuilder(
      column: $table.checkedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get availability => $composableBuilder(
      column: $table.availability,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warrantyMonths => $composableBuilder(
      column: $table.warrantyMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get returnDays => $composableBuilder(
      column: $table.returnDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kit => $composableBuilder(
      column: $table.kit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deliveryCost => $composableBuilder(
      column: $table.deliveryCost,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get otherCosts => $composableBuilder(
      column: $table.otherCosts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSeed => $composableBuilder(
      column: $table.isSeed, builder: (column) => ColumnOrderings(column));
}

class $$PriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<bool> get urlVerified => $composableBuilder(
      column: $table.urlVerified, builder: (column) => column);

  GeneratedColumn<int> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
      column: $table.availability, builder: (column) => column);

  GeneratedColumn<int> get warrantyMonths => $composableBuilder(
      column: $table.warrantyMonths, builder: (column) => column);

  GeneratedColumn<int> get returnDays => $composableBuilder(
      column: $table.returnDays, builder: (column) => column);

  GeneratedColumn<String> get kit =>
      $composableBuilder(column: $table.kit, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<int> get deliveryCost => $composableBuilder(
      column: $table.deliveryCost, builder: (column) => column);

  GeneratedColumn<int> get otherCosts => $composableBuilder(
      column: $table.otherCosts, builder: (column) => column);

  GeneratedColumn<bool> get isSeed =>
      $composableBuilder(column: $table.isSeed, builder: (column) => column);
}

class $$PriceHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PriceHistoryTable,
    PriceHistoryData,
    $$PriceHistoryTableFilterComposer,
    $$PriceHistoryTableOrderingComposer,
    $$PriceHistoryTableAnnotationComposer,
    $$PriceHistoryTableCreateCompanionBuilder,
    $$PriceHistoryTableUpdateCompanionBuilder,
    (
      PriceHistoryData,
      BaseReferences<_$AppDatabase, $PriceHistoryTable, PriceHistoryData>
    ),
    PriceHistoryData,
    PrefetchHooks Function()> {
  $$PriceHistoryTableTableManager(_$AppDatabase db, $PriceHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storeId = const Value.absent(),
            Value<String> product = const Value.absent(),
            Value<int> price = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<bool> urlVerified = const Value.absent(),
            Value<int> checkedAt = const Value.absent(),
            Value<String> availability = const Value.absent(),
            Value<int> warrantyMonths = const Value.absent(),
            Value<int> returnDays = const Value.absent(),
            Value<String> kit = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<int> deliveryCost = const Value.absent(),
            Value<int> otherCosts = const Value.absent(),
            Value<bool> isSeed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PriceHistoryCompanion(
            id: id,
            storeId: storeId,
            product: product,
            price: price,
            url: url,
            urlVerified: urlVerified,
            checkedAt: checkedAt,
            availability: availability,
            warrantyMonths: warrantyMonths,
            returnDays: returnDays,
            kit: kit,
            state: state,
            source: source,
            city: city,
            deliveryCost: deliveryCost,
            otherCosts: otherCosts,
            isSeed: isSeed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storeId,
            required String product,
            required int price,
            Value<String> url = const Value.absent(),
            Value<bool> urlVerified = const Value.absent(),
            required int checkedAt,
            required String availability,
            Value<int> warrantyMonths = const Value.absent(),
            Value<int> returnDays = const Value.absent(),
            Value<String> kit = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<int> deliveryCost = const Value.absent(),
            Value<int> otherCosts = const Value.absent(),
            Value<bool> isSeed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PriceHistoryCompanion.insert(
            id: id,
            storeId: storeId,
            product: product,
            price: price,
            url: url,
            urlVerified: urlVerified,
            checkedAt: checkedAt,
            availability: availability,
            warrantyMonths: warrantyMonths,
            returnDays: returnDays,
            kit: kit,
            state: state,
            source: source,
            city: city,
            deliveryCost: deliveryCost,
            otherCosts: otherCosts,
            isSeed: isSeed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PriceHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PriceHistoryTable,
    PriceHistoryData,
    $$PriceHistoryTableFilterComposer,
    $$PriceHistoryTableOrderingComposer,
    $$PriceHistoryTableAnnotationComposer,
    $$PriceHistoryTableCreateCompanionBuilder,
    $$PriceHistoryTableUpdateCompanionBuilder,
    (
      PriceHistoryData,
      BaseReferences<_$AppDatabase, $PriceHistoryTable, PriceHistoryData>
    ),
    PriceHistoryData,
    PrefetchHooks Function()>;
typedef $$ScanRunsTableCreateCompanionBuilder = ScanRunsCompanion Function({
  Value<int> id,
  required String product,
  required int scannedAt,
  required int lowestPrice,
  required int averagePrice,
  required int avg30dPrice,
  Value<double> changePercent,
  Value<String> changeDir,
});
typedef $$ScanRunsTableUpdateCompanionBuilder = ScanRunsCompanion Function({
  Value<int> id,
  Value<String> product,
  Value<int> scannedAt,
  Value<int> lowestPrice,
  Value<int> averagePrice,
  Value<int> avg30dPrice,
  Value<double> changePercent,
  Value<String> changeDir,
});

class $$ScanRunsTableFilterComposer
    extends Composer<_$AppDatabase, $ScanRunsTable> {
  $$ScanRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get product => $composableBuilder(
      column: $table.product, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scannedAt => $composableBuilder(
      column: $table.scannedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lowestPrice => $composableBuilder(
      column: $table.lowestPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get averagePrice => $composableBuilder(
      column: $table.averagePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avg30dPrice => $composableBuilder(
      column: $table.avg30dPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get changePercent => $composableBuilder(
      column: $table.changePercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeDir => $composableBuilder(
      column: $table.changeDir, builder: (column) => ColumnFilters(column));
}

class $$ScanRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanRunsTable> {
  $$ScanRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get product => $composableBuilder(
      column: $table.product, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scannedAt => $composableBuilder(
      column: $table.scannedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lowestPrice => $composableBuilder(
      column: $table.lowestPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get averagePrice => $composableBuilder(
      column: $table.averagePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avg30dPrice => $composableBuilder(
      column: $table.avg30dPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get changePercent => $composableBuilder(
      column: $table.changePercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeDir => $composableBuilder(
      column: $table.changeDir, builder: (column) => ColumnOrderings(column));
}

class $$ScanRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanRunsTable> {
  $$ScanRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<int> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);

  GeneratedColumn<int> get lowestPrice => $composableBuilder(
      column: $table.lowestPrice, builder: (column) => column);

  GeneratedColumn<int> get averagePrice => $composableBuilder(
      column: $table.averagePrice, builder: (column) => column);

  GeneratedColumn<int> get avg30dPrice => $composableBuilder(
      column: $table.avg30dPrice, builder: (column) => column);

  GeneratedColumn<double> get changePercent => $composableBuilder(
      column: $table.changePercent, builder: (column) => column);

  GeneratedColumn<String> get changeDir =>
      $composableBuilder(column: $table.changeDir, builder: (column) => column);
}

class $$ScanRunsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScanRunsTable,
    ScanRun,
    $$ScanRunsTableFilterComposer,
    $$ScanRunsTableOrderingComposer,
    $$ScanRunsTableAnnotationComposer,
    $$ScanRunsTableCreateCompanionBuilder,
    $$ScanRunsTableUpdateCompanionBuilder,
    (ScanRun, BaseReferences<_$AppDatabase, $ScanRunsTable, ScanRun>),
    ScanRun,
    PrefetchHooks Function()> {
  $$ScanRunsTableTableManager(_$AppDatabase db, $ScanRunsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> product = const Value.absent(),
            Value<int> scannedAt = const Value.absent(),
            Value<int> lowestPrice = const Value.absent(),
            Value<int> averagePrice = const Value.absent(),
            Value<int> avg30dPrice = const Value.absent(),
            Value<double> changePercent = const Value.absent(),
            Value<String> changeDir = const Value.absent(),
          }) =>
              ScanRunsCompanion(
            id: id,
            product: product,
            scannedAt: scannedAt,
            lowestPrice: lowestPrice,
            averagePrice: averagePrice,
            avg30dPrice: avg30dPrice,
            changePercent: changePercent,
            changeDir: changeDir,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String product,
            required int scannedAt,
            required int lowestPrice,
            required int averagePrice,
            required int avg30dPrice,
            Value<double> changePercent = const Value.absent(),
            Value<String> changeDir = const Value.absent(),
          }) =>
              ScanRunsCompanion.insert(
            id: id,
            product: product,
            scannedAt: scannedAt,
            lowestPrice: lowestPrice,
            averagePrice: averagePrice,
            avg30dPrice: avg30dPrice,
            changePercent: changePercent,
            changeDir: changeDir,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScanRunsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScanRunsTable,
    ScanRun,
    $$ScanRunsTableFilterComposer,
    $$ScanRunsTableOrderingComposer,
    $$ScanRunsTableAnnotationComposer,
    $$ScanRunsTableCreateCompanionBuilder,
    $$ScanRunsTableUpdateCompanionBuilder,
    (ScanRun, BaseReferences<_$AppDatabase, $ScanRunsTable, ScanRun>),
    ScanRun,
    PrefetchHooks Function()>;
typedef $$MonitorSpecsTableCreateCompanionBuilder = MonitorSpecsCompanion
    Function({
  required String priceId,
  required String model,
  required double diagonal,
  required String resolution,
  required int refreshHz,
  required int hdmiVersion,
  Value<bool> vrr,
  Value<String> hdr,
  Value<bool> allm,
  Value<String> vesa,
  Value<int> rowid,
});
typedef $$MonitorSpecsTableUpdateCompanionBuilder = MonitorSpecsCompanion
    Function({
  Value<String> priceId,
  Value<String> model,
  Value<double> diagonal,
  Value<String> resolution,
  Value<int> refreshHz,
  Value<int> hdmiVersion,
  Value<bool> vrr,
  Value<String> hdr,
  Value<bool> allm,
  Value<String> vesa,
  Value<int> rowid,
});

class $$MonitorSpecsTableFilterComposer
    extends Composer<_$AppDatabase, $MonitorSpecsTable> {
  $$MonitorSpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get priceId => $composableBuilder(
      column: $table.priceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get diagonal => $composableBuilder(
      column: $table.diagonal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get refreshHz => $composableBuilder(
      column: $table.refreshHz, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hdmiVersion => $composableBuilder(
      column: $table.hdmiVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get vrr => $composableBuilder(
      column: $table.vrr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hdr => $composableBuilder(
      column: $table.hdr, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allm => $composableBuilder(
      column: $table.allm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vesa => $composableBuilder(
      column: $table.vesa, builder: (column) => ColumnFilters(column));
}

class $$MonitorSpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonitorSpecsTable> {
  $$MonitorSpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get priceId => $composableBuilder(
      column: $table.priceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get diagonal => $composableBuilder(
      column: $table.diagonal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get refreshHz => $composableBuilder(
      column: $table.refreshHz, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hdmiVersion => $composableBuilder(
      column: $table.hdmiVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get vrr => $composableBuilder(
      column: $table.vrr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hdr => $composableBuilder(
      column: $table.hdr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allm => $composableBuilder(
      column: $table.allm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vesa => $composableBuilder(
      column: $table.vesa, builder: (column) => ColumnOrderings(column));
}

class $$MonitorSpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonitorSpecsTable> {
  $$MonitorSpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get priceId =>
      $composableBuilder(column: $table.priceId, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<double> get diagonal =>
      $composableBuilder(column: $table.diagonal, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<int> get refreshHz =>
      $composableBuilder(column: $table.refreshHz, builder: (column) => column);

  GeneratedColumn<int> get hdmiVersion => $composableBuilder(
      column: $table.hdmiVersion, builder: (column) => column);

  GeneratedColumn<bool> get vrr =>
      $composableBuilder(column: $table.vrr, builder: (column) => column);

  GeneratedColumn<String> get hdr =>
      $composableBuilder(column: $table.hdr, builder: (column) => column);

  GeneratedColumn<bool> get allm =>
      $composableBuilder(column: $table.allm, builder: (column) => column);

  GeneratedColumn<String> get vesa =>
      $composableBuilder(column: $table.vesa, builder: (column) => column);
}

class $$MonitorSpecsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonitorSpecsTable,
    MonitorSpec,
    $$MonitorSpecsTableFilterComposer,
    $$MonitorSpecsTableOrderingComposer,
    $$MonitorSpecsTableAnnotationComposer,
    $$MonitorSpecsTableCreateCompanionBuilder,
    $$MonitorSpecsTableUpdateCompanionBuilder,
    (
      MonitorSpec,
      BaseReferences<_$AppDatabase, $MonitorSpecsTable, MonitorSpec>
    ),
    MonitorSpec,
    PrefetchHooks Function()> {
  $$MonitorSpecsTableTableManager(_$AppDatabase db, $MonitorSpecsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonitorSpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonitorSpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonitorSpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> priceId = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<double> diagonal = const Value.absent(),
            Value<String> resolution = const Value.absent(),
            Value<int> refreshHz = const Value.absent(),
            Value<int> hdmiVersion = const Value.absent(),
            Value<bool> vrr = const Value.absent(),
            Value<String> hdr = const Value.absent(),
            Value<bool> allm = const Value.absent(),
            Value<String> vesa = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitorSpecsCompanion(
            priceId: priceId,
            model: model,
            diagonal: diagonal,
            resolution: resolution,
            refreshHz: refreshHz,
            hdmiVersion: hdmiVersion,
            vrr: vrr,
            hdr: hdr,
            allm: allm,
            vesa: vesa,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String priceId,
            required String model,
            required double diagonal,
            required String resolution,
            required int refreshHz,
            required int hdmiVersion,
            Value<bool> vrr = const Value.absent(),
            Value<String> hdr = const Value.absent(),
            Value<bool> allm = const Value.absent(),
            Value<String> vesa = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitorSpecsCompanion.insert(
            priceId: priceId,
            model: model,
            diagonal: diagonal,
            resolution: resolution,
            refreshHz: refreshHz,
            hdmiVersion: hdmiVersion,
            vrr: vrr,
            hdr: hdr,
            allm: allm,
            vesa: vesa,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MonitorSpecsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonitorSpecsTable,
    MonitorSpec,
    $$MonitorSpecsTableFilterComposer,
    $$MonitorSpecsTableOrderingComposer,
    $$MonitorSpecsTableAnnotationComposer,
    $$MonitorSpecsTableCreateCompanionBuilder,
    $$MonitorSpecsTableUpdateCompanionBuilder,
    (
      MonitorSpec,
      BaseReferences<_$AppDatabase, $MonitorSpecsTable, MonitorSpec>
    ),
    MonitorSpec,
    PrefetchHooks Function()>;
typedef $$Ps5SpecsTableCreateCompanionBuilder = Ps5SpecsCompanion Function({
  required String priceId,
  required String consoleType,
  required int memoryGb,
  Value<bool> isSlim,
  Value<int> rowid,
});
typedef $$Ps5SpecsTableUpdateCompanionBuilder = Ps5SpecsCompanion Function({
  Value<String> priceId,
  Value<String> consoleType,
  Value<int> memoryGb,
  Value<bool> isSlim,
  Value<int> rowid,
});

class $$Ps5SpecsTableFilterComposer
    extends Composer<_$AppDatabase, $Ps5SpecsTable> {
  $$Ps5SpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get priceId => $composableBuilder(
      column: $table.priceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get consoleType => $composableBuilder(
      column: $table.consoleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memoryGb => $composableBuilder(
      column: $table.memoryGb, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSlim => $composableBuilder(
      column: $table.isSlim, builder: (column) => ColumnFilters(column));
}

class $$Ps5SpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $Ps5SpecsTable> {
  $$Ps5SpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get priceId => $composableBuilder(
      column: $table.priceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get consoleType => $composableBuilder(
      column: $table.consoleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memoryGb => $composableBuilder(
      column: $table.memoryGb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSlim => $composableBuilder(
      column: $table.isSlim, builder: (column) => ColumnOrderings(column));
}

class $$Ps5SpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $Ps5SpecsTable> {
  $$Ps5SpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get priceId =>
      $composableBuilder(column: $table.priceId, builder: (column) => column);

  GeneratedColumn<String> get consoleType => $composableBuilder(
      column: $table.consoleType, builder: (column) => column);

  GeneratedColumn<int> get memoryGb =>
      $composableBuilder(column: $table.memoryGb, builder: (column) => column);

  GeneratedColumn<bool> get isSlim =>
      $composableBuilder(column: $table.isSlim, builder: (column) => column);
}

class $$Ps5SpecsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $Ps5SpecsTable,
    Ps5Spec,
    $$Ps5SpecsTableFilterComposer,
    $$Ps5SpecsTableOrderingComposer,
    $$Ps5SpecsTableAnnotationComposer,
    $$Ps5SpecsTableCreateCompanionBuilder,
    $$Ps5SpecsTableUpdateCompanionBuilder,
    (Ps5Spec, BaseReferences<_$AppDatabase, $Ps5SpecsTable, Ps5Spec>),
    Ps5Spec,
    PrefetchHooks Function()> {
  $$Ps5SpecsTableTableManager(_$AppDatabase db, $Ps5SpecsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$Ps5SpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$Ps5SpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$Ps5SpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> priceId = const Value.absent(),
            Value<String> consoleType = const Value.absent(),
            Value<int> memoryGb = const Value.absent(),
            Value<bool> isSlim = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              Ps5SpecsCompanion(
            priceId: priceId,
            consoleType: consoleType,
            memoryGb: memoryGb,
            isSlim: isSlim,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String priceId,
            required String consoleType,
            required int memoryGb,
            Value<bool> isSlim = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              Ps5SpecsCompanion.insert(
            priceId: priceId,
            consoleType: consoleType,
            memoryGb: memoryGb,
            isSlim: isSlim,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$Ps5SpecsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $Ps5SpecsTable,
    Ps5Spec,
    $$Ps5SpecsTableFilterComposer,
    $$Ps5SpecsTableOrderingComposer,
    $$Ps5SpecsTableAnnotationComposer,
    $$Ps5SpecsTableCreateCompanionBuilder,
    $$Ps5SpecsTableUpdateCompanionBuilder,
    (Ps5Spec, BaseReferences<_$AppDatabase, $Ps5SpecsTable, Ps5Spec>),
    Ps5Spec,
    PrefetchHooks Function()>;
typedef $$NotificationsCacheTableCreateCompanionBuilder
    = NotificationsCacheCompanion Function({
  required String id,
  required String type,
  required String titleKey,
  required String bodyKey,
  Value<String> bodyParamsJson,
  Value<String?> deepLink,
  required int createdAt,
  Value<bool> read,
  Value<bool> isPush,
  Value<int> rowid,
});
typedef $$NotificationsCacheTableUpdateCompanionBuilder
    = NotificationsCacheCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> titleKey,
  Value<String> bodyKey,
  Value<String> bodyParamsJson,
  Value<String?> deepLink,
  Value<int> createdAt,
  Value<bool> read,
  Value<bool> isPush,
  Value<int> rowid,
});

class $$NotificationsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsCacheTable> {
  $$NotificationsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bodyKey => $composableBuilder(
      column: $table.bodyKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bodyParamsJson => $composableBuilder(
      column: $table.bodyParamsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deepLink => $composableBuilder(
      column: $table.deepLink, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPush => $composableBuilder(
      column: $table.isPush, builder: (column) => ColumnFilters(column));
}

class $$NotificationsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsCacheTable> {
  $$NotificationsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bodyKey => $composableBuilder(
      column: $table.bodyKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bodyParamsJson => $composableBuilder(
      column: $table.bodyParamsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deepLink => $composableBuilder(
      column: $table.deepLink, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPush => $composableBuilder(
      column: $table.isPush, builder: (column) => ColumnOrderings(column));
}

class $$NotificationsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsCacheTable> {
  $$NotificationsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<String> get bodyKey =>
      $composableBuilder(column: $table.bodyKey, builder: (column) => column);

  GeneratedColumn<String> get bodyParamsJson => $composableBuilder(
      column: $table.bodyParamsJson, builder: (column) => column);

  GeneratedColumn<String> get deepLink =>
      $composableBuilder(column: $table.deepLink, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<bool> get isPush =>
      $composableBuilder(column: $table.isPush, builder: (column) => column);
}

class $$NotificationsCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationsCacheTable,
    NotificationsCacheData,
    $$NotificationsCacheTableFilterComposer,
    $$NotificationsCacheTableOrderingComposer,
    $$NotificationsCacheTableAnnotationComposer,
    $$NotificationsCacheTableCreateCompanionBuilder,
    $$NotificationsCacheTableUpdateCompanionBuilder,
    (
      NotificationsCacheData,
      BaseReferences<_$AppDatabase, $NotificationsCacheTable,
          NotificationsCacheData>
    ),
    NotificationsCacheData,
    PrefetchHooks Function()> {
  $$NotificationsCacheTableTableManager(
      _$AppDatabase db, $NotificationsCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsCacheTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> titleKey = const Value.absent(),
            Value<String> bodyKey = const Value.absent(),
            Value<String> bodyParamsJson = const Value.absent(),
            Value<String?> deepLink = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<bool> read = const Value.absent(),
            Value<bool> isPush = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCacheCompanion(
            id: id,
            type: type,
            titleKey: titleKey,
            bodyKey: bodyKey,
            bodyParamsJson: bodyParamsJson,
            deepLink: deepLink,
            createdAt: createdAt,
            read: read,
            isPush: isPush,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String titleKey,
            required String bodyKey,
            Value<String> bodyParamsJson = const Value.absent(),
            Value<String?> deepLink = const Value.absent(),
            required int createdAt,
            Value<bool> read = const Value.absent(),
            Value<bool> isPush = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCacheCompanion.insert(
            id: id,
            type: type,
            titleKey: titleKey,
            bodyKey: bodyKey,
            bodyParamsJson: bodyParamsJson,
            deepLink: deepLink,
            createdAt: createdAt,
            read: read,
            isPush: isPush,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationsCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationsCacheTable,
    NotificationsCacheData,
    $$NotificationsCacheTableFilterComposer,
    $$NotificationsCacheTableOrderingComposer,
    $$NotificationsCacheTableAnnotationComposer,
    $$NotificationsCacheTableCreateCompanionBuilder,
    $$NotificationsCacheTableUpdateCompanionBuilder,
    (
      NotificationsCacheData,
      BaseReferences<_$AppDatabase, $NotificationsCacheTable,
          NotificationsCacheData>
    ),
    NotificationsCacheData,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String entityId,
  required String entityType,
  required String payloadJson,
  Value<int> attempts,
  required int nextAttemptAt,
  Value<String?> lastError,
  required int createdAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> entityId,
  Value<String> entityType,
  Value<String> payloadJson,
  Value<int> attempts,
  Value<int> nextAttemptAt,
  Value<String?> lastError,
  Value<int> createdAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            entityId: entityId,
            entityType: entityType,
            payloadJson: payloadJson,
            attempts: attempts,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityId,
            required String entityType,
            required String payloadJson,
            Value<int> attempts = const Value.absent(),
            required int nextAttemptAt,
            Value<String?> lastError = const Value.absent(),
            required int createdAt,
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            entityId: entityId,
            entityType: entityType,
            payloadJson: payloadJson,
            attempts: attempts,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$ChipsWalletTableTableCreateCompanionBuilder
    = ChipsWalletTableCompanion Function({
  required String id,
  Value<int> balance,
  Value<int> dust,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$ChipsWalletTableTableUpdateCompanionBuilder
    = ChipsWalletTableCompanion Function({
  Value<String> id,
  Value<int> balance,
  Value<int> dust,
  Value<bool> synced,
  Value<int> rowid,
});

class $$ChipsWalletTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChipsWalletTableTable> {
  $$ChipsWalletTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dust => $composableBuilder(
      column: $table.dust, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$ChipsWalletTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChipsWalletTableTable> {
  $$ChipsWalletTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dust => $composableBuilder(
      column: $table.dust, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$ChipsWalletTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChipsWalletTableTable> {
  $$ChipsWalletTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<int> get dust =>
      $composableBuilder(column: $table.dust, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$ChipsWalletTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChipsWalletTableTable,
    ChipsWalletTableData,
    $$ChipsWalletTableTableFilterComposer,
    $$ChipsWalletTableTableOrderingComposer,
    $$ChipsWalletTableTableAnnotationComposer,
    $$ChipsWalletTableTableCreateCompanionBuilder,
    $$ChipsWalletTableTableUpdateCompanionBuilder,
    (
      ChipsWalletTableData,
      BaseReferences<_$AppDatabase, $ChipsWalletTableTable,
          ChipsWalletTableData>
    ),
    ChipsWalletTableData,
    PrefetchHooks Function()> {
  $$ChipsWalletTableTableTableManager(
      _$AppDatabase db, $ChipsWalletTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChipsWalletTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChipsWalletTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChipsWalletTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> balance = const Value.absent(),
            Value<int> dust = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChipsWalletTableCompanion(
            id: id,
            balance: balance,
            dust: dust,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> balance = const Value.absent(),
            Value<int> dust = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChipsWalletTableCompanion.insert(
            id: id,
            balance: balance,
            dust: dust,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChipsWalletTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChipsWalletTableTable,
    ChipsWalletTableData,
    $$ChipsWalletTableTableFilterComposer,
    $$ChipsWalletTableTableOrderingComposer,
    $$ChipsWalletTableTableAnnotationComposer,
    $$ChipsWalletTableTableCreateCompanionBuilder,
    $$ChipsWalletTableTableUpdateCompanionBuilder,
    (
      ChipsWalletTableData,
      BaseReferences<_$AppDatabase, $ChipsWalletTableTable,
          ChipsWalletTableData>
    ),
    ChipsWalletTableData,
    PrefetchHooks Function()>;
typedef $$ChipsLedgerTableCreateCompanionBuilder = ChipsLedgerCompanion
    Function({
  Value<int> id,
  required String reason,
  required int delta,
  Value<String?> refId,
  required int createdAt,
  Value<bool> synced,
});
typedef $$ChipsLedgerTableUpdateCompanionBuilder = ChipsLedgerCompanion
    Function({
  Value<int> id,
  Value<String> reason,
  Value<int> delta,
  Value<String?> refId,
  Value<int> createdAt,
  Value<bool> synced,
});

class $$ChipsLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $ChipsLedgerTable> {
  $$ChipsLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get delta => $composableBuilder(
      column: $table.delta, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$ChipsLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $ChipsLedgerTable> {
  $$ChipsLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get delta => $composableBuilder(
      column: $table.delta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$ChipsLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChipsLedgerTable> {
  $$ChipsLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$ChipsLedgerTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChipsLedgerTable,
    ChipsLedgerData,
    $$ChipsLedgerTableFilterComposer,
    $$ChipsLedgerTableOrderingComposer,
    $$ChipsLedgerTableAnnotationComposer,
    $$ChipsLedgerTableCreateCompanionBuilder,
    $$ChipsLedgerTableUpdateCompanionBuilder,
    (
      ChipsLedgerData,
      BaseReferences<_$AppDatabase, $ChipsLedgerTable, ChipsLedgerData>
    ),
    ChipsLedgerData,
    PrefetchHooks Function()> {
  $$ChipsLedgerTableTableManager(_$AppDatabase db, $ChipsLedgerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChipsLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChipsLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChipsLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<int> delta = const Value.absent(),
            Value<String?> refId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
          }) =>
              ChipsLedgerCompanion(
            id: id,
            reason: reason,
            delta: delta,
            refId: refId,
            createdAt: createdAt,
            synced: synced,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String reason,
            required int delta,
            Value<String?> refId = const Value.absent(),
            required int createdAt,
            Value<bool> synced = const Value.absent(),
          }) =>
              ChipsLedgerCompanion.insert(
            id: id,
            reason: reason,
            delta: delta,
            refId: refId,
            createdAt: createdAt,
            synced: synced,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChipsLedgerTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChipsLedgerTable,
    ChipsLedgerData,
    $$ChipsLedgerTableFilterComposer,
    $$ChipsLedgerTableOrderingComposer,
    $$ChipsLedgerTableAnnotationComposer,
    $$ChipsLedgerTableCreateCompanionBuilder,
    $$ChipsLedgerTableUpdateCompanionBuilder,
    (
      ChipsLedgerData,
      BaseReferences<_$AppDatabase, $ChipsLedgerTable, ChipsLedgerData>
    ),
    ChipsLedgerData,
    PrefetchHooks Function()>;
typedef $$PetsTableCreateCompanionBuilder = PetsCompanion Function({
  required String id,
  Value<String> form,
  Value<String> mood,
  Value<String> skin,
  Value<int?> hatchedAt,
  Value<int> feedCount,
  Value<String?> lastOpenDay,
  Value<String?> lastFedDay,
  Value<int?> lastSadPushAt,
  Value<int> rowid,
});
typedef $$PetsTableUpdateCompanionBuilder = PetsCompanion Function({
  Value<String> id,
  Value<String> form,
  Value<String> mood,
  Value<String> skin,
  Value<int?> hatchedAt,
  Value<int> feedCount,
  Value<String?> lastOpenDay,
  Value<String?> lastFedDay,
  Value<int?> lastSadPushAt,
  Value<int> rowid,
});

class $$PetsTableFilterComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skin => $composableBuilder(
      column: $table.skin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hatchedAt => $composableBuilder(
      column: $table.hatchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get feedCount => $composableBuilder(
      column: $table.feedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastOpenDay => $composableBuilder(
      column: $table.lastOpenDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastFedDay => $composableBuilder(
      column: $table.lastFedDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSadPushAt => $composableBuilder(
      column: $table.lastSadPushAt, builder: (column) => ColumnFilters(column));
}

class $$PetsTableOrderingComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skin => $composableBuilder(
      column: $table.skin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hatchedAt => $composableBuilder(
      column: $table.hatchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get feedCount => $composableBuilder(
      column: $table.feedCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastOpenDay => $composableBuilder(
      column: $table.lastOpenDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastFedDay => $composableBuilder(
      column: $table.lastFedDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSadPushAt => $composableBuilder(
      column: $table.lastSadPushAt,
      builder: (column) => ColumnOrderings(column));
}

class $$PetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get skin =>
      $composableBuilder(column: $table.skin, builder: (column) => column);

  GeneratedColumn<int> get hatchedAt =>
      $composableBuilder(column: $table.hatchedAt, builder: (column) => column);

  GeneratedColumn<int> get feedCount =>
      $composableBuilder(column: $table.feedCount, builder: (column) => column);

  GeneratedColumn<String> get lastOpenDay => $composableBuilder(
      column: $table.lastOpenDay, builder: (column) => column);

  GeneratedColumn<String> get lastFedDay => $composableBuilder(
      column: $table.lastFedDay, builder: (column) => column);

  GeneratedColumn<int> get lastSadPushAt => $composableBuilder(
      column: $table.lastSadPushAt, builder: (column) => column);
}

class $$PetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PetsTable,
    Pet,
    $$PetsTableFilterComposer,
    $$PetsTableOrderingComposer,
    $$PetsTableAnnotationComposer,
    $$PetsTableCreateCompanionBuilder,
    $$PetsTableUpdateCompanionBuilder,
    (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
    Pet,
    PrefetchHooks Function()> {
  $$PetsTableTableManager(_$AppDatabase db, $PetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> form = const Value.absent(),
            Value<String> mood = const Value.absent(),
            Value<String> skin = const Value.absent(),
            Value<int?> hatchedAt = const Value.absent(),
            Value<int> feedCount = const Value.absent(),
            Value<String?> lastOpenDay = const Value.absent(),
            Value<String?> lastFedDay = const Value.absent(),
            Value<int?> lastSadPushAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PetsCompanion(
            id: id,
            form: form,
            mood: mood,
            skin: skin,
            hatchedAt: hatchedAt,
            feedCount: feedCount,
            lastOpenDay: lastOpenDay,
            lastFedDay: lastFedDay,
            lastSadPushAt: lastSadPushAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> form = const Value.absent(),
            Value<String> mood = const Value.absent(),
            Value<String> skin = const Value.absent(),
            Value<int?> hatchedAt = const Value.absent(),
            Value<int> feedCount = const Value.absent(),
            Value<String?> lastOpenDay = const Value.absent(),
            Value<String?> lastFedDay = const Value.absent(),
            Value<int?> lastSadPushAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PetsCompanion.insert(
            id: id,
            form: form,
            mood: mood,
            skin: skin,
            hatchedAt: hatchedAt,
            feedCount: feedCount,
            lastOpenDay: lastOpenDay,
            lastFedDay: lastFedDay,
            lastSadPushAt: lastSadPushAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PetsTable,
    Pet,
    $$PetsTableFilterComposer,
    $$PetsTableOrderingComposer,
    $$PetsTableAnnotationComposer,
    $$PetsTableCreateCompanionBuilder,
    $$PetsTableUpdateCompanionBuilder,
    (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
    Pet,
    PrefetchHooks Function()>;
typedef $$PetSkinsTableCreateCompanionBuilder = PetSkinsCompanion Function({
  required String id,
  Value<bool> owned,
  Value<int> rowid,
});
typedef $$PetSkinsTableUpdateCompanionBuilder = PetSkinsCompanion Function({
  Value<String> id,
  Value<bool> owned,
  Value<int> rowid,
});

class $$PetSkinsTableFilterComposer
    extends Composer<_$AppDatabase, $PetSkinsTable> {
  $$PetSkinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get owned => $composableBuilder(
      column: $table.owned, builder: (column) => ColumnFilters(column));
}

class $$PetSkinsTableOrderingComposer
    extends Composer<_$AppDatabase, $PetSkinsTable> {
  $$PetSkinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get owned => $composableBuilder(
      column: $table.owned, builder: (column) => ColumnOrderings(column));
}

class $$PetSkinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetSkinsTable> {
  $$PetSkinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get owned =>
      $composableBuilder(column: $table.owned, builder: (column) => column);
}

class $$PetSkinsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PetSkinsTable,
    PetSkin,
    $$PetSkinsTableFilterComposer,
    $$PetSkinsTableOrderingComposer,
    $$PetSkinsTableAnnotationComposer,
    $$PetSkinsTableCreateCompanionBuilder,
    $$PetSkinsTableUpdateCompanionBuilder,
    (PetSkin, BaseReferences<_$AppDatabase, $PetSkinsTable, PetSkin>),
    PetSkin,
    PrefetchHooks Function()> {
  $$PetSkinsTableTableManager(_$AppDatabase db, $PetSkinsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetSkinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetSkinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetSkinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> owned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PetSkinsCompanion(
            id: id,
            owned: owned,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<bool> owned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PetSkinsCompanion.insert(
            id: id,
            owned: owned,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PetSkinsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PetSkinsTable,
    PetSkin,
    $$PetSkinsTableFilterComposer,
    $$PetSkinsTableOrderingComposer,
    $$PetSkinsTableAnnotationComposer,
    $$PetSkinsTableCreateCompanionBuilder,
    $$PetSkinsTableUpdateCompanionBuilder,
    (PetSkin, BaseReferences<_$AppDatabase, $PetSkinsTable, PetSkin>),
    PetSkin,
    PrefetchHooks Function()>;
typedef $$QuestsDailyTableCreateCompanionBuilder = QuestsDailyCompanion
    Function({
  required String id,
  required String questId,
  required String dayKey,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});
typedef $$QuestsDailyTableUpdateCompanionBuilder = QuestsDailyCompanion
    Function({
  Value<String> id,
  Value<String> questId,
  Value<String> dayKey,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});

class $$QuestsDailyTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsDailyTable> {
  $$QuestsDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questId => $composableBuilder(
      column: $table.questId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayKey => $composableBuilder(
      column: $table.dayKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnFilters(column));
}

class $$QuestsDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsDailyTable> {
  $$QuestsDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questId => $composableBuilder(
      column: $table.questId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayKey => $composableBuilder(
      column: $table.dayKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnOrderings(column));
}

class $$QuestsDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsDailyTable> {
  $$QuestsDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get claimed =>
      $composableBuilder(column: $table.claimed, builder: (column) => column);
}

class $$QuestsDailyTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestsDailyTable,
    QuestsDailyData,
    $$QuestsDailyTableFilterComposer,
    $$QuestsDailyTableOrderingComposer,
    $$QuestsDailyTableAnnotationComposer,
    $$QuestsDailyTableCreateCompanionBuilder,
    $$QuestsDailyTableUpdateCompanionBuilder,
    (
      QuestsDailyData,
      BaseReferences<_$AppDatabase, $QuestsDailyTable, QuestsDailyData>
    ),
    QuestsDailyData,
    PrefetchHooks Function()> {
  $$QuestsDailyTableTableManager(_$AppDatabase db, $QuestsDailyTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> questId = const Value.absent(),
            Value<String> dayKey = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestsDailyCompanion(
            id: id,
            questId: questId,
            dayKey: dayKey,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String questId,
            required String dayKey,
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestsDailyCompanion.insert(
            id: id,
            questId: questId,
            dayKey: dayKey,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestsDailyTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestsDailyTable,
    QuestsDailyData,
    $$QuestsDailyTableFilterComposer,
    $$QuestsDailyTableOrderingComposer,
    $$QuestsDailyTableAnnotationComposer,
    $$QuestsDailyTableCreateCompanionBuilder,
    $$QuestsDailyTableUpdateCompanionBuilder,
    (
      QuestsDailyData,
      BaseReferences<_$AppDatabase, $QuestsDailyTable, QuestsDailyData>
    ),
    QuestsDailyData,
    PrefetchHooks Function()>;
typedef $$QuestsWeeklyTableCreateCompanionBuilder = QuestsWeeklyCompanion
    Function({
  required String id,
  required String questId,
  required String weekKey,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});
typedef $$QuestsWeeklyTableUpdateCompanionBuilder = QuestsWeeklyCompanion
    Function({
  Value<String> id,
  Value<String> questId,
  Value<String> weekKey,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});

class $$QuestsWeeklyTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsWeeklyTable> {
  $$QuestsWeeklyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questId => $composableBuilder(
      column: $table.questId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekKey => $composableBuilder(
      column: $table.weekKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnFilters(column));
}

class $$QuestsWeeklyTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsWeeklyTable> {
  $$QuestsWeeklyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questId => $composableBuilder(
      column: $table.questId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekKey => $composableBuilder(
      column: $table.weekKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnOrderings(column));
}

class $$QuestsWeeklyTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsWeeklyTable> {
  $$QuestsWeeklyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<String> get weekKey =>
      $composableBuilder(column: $table.weekKey, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get claimed =>
      $composableBuilder(column: $table.claimed, builder: (column) => column);
}

class $$QuestsWeeklyTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestsWeeklyTable,
    QuestsWeeklyData,
    $$QuestsWeeklyTableFilterComposer,
    $$QuestsWeeklyTableOrderingComposer,
    $$QuestsWeeklyTableAnnotationComposer,
    $$QuestsWeeklyTableCreateCompanionBuilder,
    $$QuestsWeeklyTableUpdateCompanionBuilder,
    (
      QuestsWeeklyData,
      BaseReferences<_$AppDatabase, $QuestsWeeklyTable, QuestsWeeklyData>
    ),
    QuestsWeeklyData,
    PrefetchHooks Function()> {
  $$QuestsWeeklyTableTableManager(_$AppDatabase db, $QuestsWeeklyTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsWeeklyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsWeeklyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsWeeklyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> questId = const Value.absent(),
            Value<String> weekKey = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestsWeeklyCompanion(
            id: id,
            questId: questId,
            weekKey: weekKey,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String questId,
            required String weekKey,
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestsWeeklyCompanion.insert(
            id: id,
            questId: questId,
            weekKey: weekKey,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestsWeeklyTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestsWeeklyTable,
    QuestsWeeklyData,
    $$QuestsWeeklyTableFilterComposer,
    $$QuestsWeeklyTableOrderingComposer,
    $$QuestsWeeklyTableAnnotationComposer,
    $$QuestsWeeklyTableCreateCompanionBuilder,
    $$QuestsWeeklyTableUpdateCompanionBuilder,
    (
      QuestsWeeklyData,
      BaseReferences<_$AppDatabase, $QuestsWeeklyTable, QuestsWeeklyData>
    ),
    QuestsWeeklyData,
    PrefetchHooks Function()>;
typedef $$ChestsTableCreateCompanionBuilder = ChestsCompanion Function({
  required String id,
  Value<String?> lastOpenedDay,
  Value<int> chain,
  Value<int> totalOpened,
  Value<int> rowid,
});
typedef $$ChestsTableUpdateCompanionBuilder = ChestsCompanion Function({
  Value<String> id,
  Value<String?> lastOpenedDay,
  Value<int> chain,
  Value<int> totalOpened,
  Value<int> rowid,
});

class $$ChestsTableFilterComposer
    extends Composer<_$AppDatabase, $ChestsTable> {
  $$ChestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastOpenedDay => $composableBuilder(
      column: $table.lastOpenedDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chain => $composableBuilder(
      column: $table.chain, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalOpened => $composableBuilder(
      column: $table.totalOpened, builder: (column) => ColumnFilters(column));
}

class $$ChestsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChestsTable> {
  $$ChestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastOpenedDay => $composableBuilder(
      column: $table.lastOpenedDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chain => $composableBuilder(
      column: $table.chain, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalOpened => $composableBuilder(
      column: $table.totalOpened, builder: (column) => ColumnOrderings(column));
}

class $$ChestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChestsTable> {
  $$ChestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastOpenedDay => $composableBuilder(
      column: $table.lastOpenedDay, builder: (column) => column);

  GeneratedColumn<int> get chain =>
      $composableBuilder(column: $table.chain, builder: (column) => column);

  GeneratedColumn<int> get totalOpened => $composableBuilder(
      column: $table.totalOpened, builder: (column) => column);
}

class $$ChestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChestsTable,
    Chest,
    $$ChestsTableFilterComposer,
    $$ChestsTableOrderingComposer,
    $$ChestsTableAnnotationComposer,
    $$ChestsTableCreateCompanionBuilder,
    $$ChestsTableUpdateCompanionBuilder,
    (Chest, BaseReferences<_$AppDatabase, $ChestsTable, Chest>),
    Chest,
    PrefetchHooks Function()> {
  $$ChestsTableTableManager(_$AppDatabase db, $ChestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> lastOpenedDay = const Value.absent(),
            Value<int> chain = const Value.absent(),
            Value<int> totalOpened = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChestsCompanion(
            id: id,
            lastOpenedDay: lastOpenedDay,
            chain: chain,
            totalOpened: totalOpened,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> lastOpenedDay = const Value.absent(),
            Value<int> chain = const Value.absent(),
            Value<int> totalOpened = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChestsCompanion.insert(
            id: id,
            lastOpenedDay: lastOpenedDay,
            chain: chain,
            totalOpened: totalOpened,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChestsTable,
    Chest,
    $$ChestsTableFilterComposer,
    $$ChestsTableOrderingComposer,
    $$ChestsTableAnnotationComposer,
    $$ChestsTableCreateCompanionBuilder,
    $$ChestsTableUpdateCompanionBuilder,
    (Chest, BaseReferences<_$AppDatabase, $ChestsTable, Chest>),
    Chest,
    PrefetchHooks Function()>;
typedef $$HoloSetsTableCreateCompanionBuilder = HoloSetsCompanion Function({
  required String id,
  required String nameKey,
  Value<int> rowid,
});
typedef $$HoloSetsTableUpdateCompanionBuilder = HoloSetsCompanion Function({
  Value<String> id,
  Value<String> nameKey,
  Value<int> rowid,
});

class $$HoloSetsTableFilterComposer
    extends Composer<_$AppDatabase, $HoloSetsTable> {
  $$HoloSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKey => $composableBuilder(
      column: $table.nameKey, builder: (column) => ColumnFilters(column));
}

class $$HoloSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $HoloSetsTable> {
  $$HoloSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKey => $composableBuilder(
      column: $table.nameKey, builder: (column) => ColumnOrderings(column));
}

class $$HoloSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoloSetsTable> {
  $$HoloSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);
}

class $$HoloSetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HoloSetsTable,
    HoloSet,
    $$HoloSetsTableFilterComposer,
    $$HoloSetsTableOrderingComposer,
    $$HoloSetsTableAnnotationComposer,
    $$HoloSetsTableCreateCompanionBuilder,
    $$HoloSetsTableUpdateCompanionBuilder,
    (HoloSet, BaseReferences<_$AppDatabase, $HoloSetsTable, HoloSet>),
    HoloSet,
    PrefetchHooks Function()> {
  $$HoloSetsTableTableManager(_$AppDatabase db, $HoloSetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoloSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoloSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoloSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nameKey = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HoloSetsCompanion(
            id: id,
            nameKey: nameKey,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nameKey,
            Value<int> rowid = const Value.absent(),
          }) =>
              HoloSetsCompanion.insert(
            id: id,
            nameKey: nameKey,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HoloSetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HoloSetsTable,
    HoloSet,
    $$HoloSetsTableFilterComposer,
    $$HoloSetsTableOrderingComposer,
    $$HoloSetsTableAnnotationComposer,
    $$HoloSetsTableCreateCompanionBuilder,
    $$HoloSetsTableUpdateCompanionBuilder,
    (HoloSet, BaseReferences<_$AppDatabase, $HoloSetsTable, HoloSet>),
    HoloSet,
    PrefetchHooks Function()>;
typedef $$HoloCardsTableCreateCompanionBuilder = HoloCardsCompanion Function({
  required String id,
  required String setId,
  required String rarity,
  required String nameKey,
  required String condKey,
  required String loreKey,
  Value<int> rowid,
});
typedef $$HoloCardsTableUpdateCompanionBuilder = HoloCardsCompanion Function({
  Value<String> id,
  Value<String> setId,
  Value<String> rarity,
  Value<String> nameKey,
  Value<String> condKey,
  Value<String> loreKey,
  Value<int> rowid,
});

class $$HoloCardsTableFilterComposer
    extends Composer<_$AppDatabase, $HoloCardsTable> {
  $$HoloCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setId => $composableBuilder(
      column: $table.setId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKey => $composableBuilder(
      column: $table.nameKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condKey => $composableBuilder(
      column: $table.condKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loreKey => $composableBuilder(
      column: $table.loreKey, builder: (column) => ColumnFilters(column));
}

class $$HoloCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $HoloCardsTable> {
  $$HoloCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setId => $composableBuilder(
      column: $table.setId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKey => $composableBuilder(
      column: $table.nameKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condKey => $composableBuilder(
      column: $table.condKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loreKey => $composableBuilder(
      column: $table.loreKey, builder: (column) => ColumnOrderings(column));
}

class $$HoloCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoloCardsTable> {
  $$HoloCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get setId =>
      $composableBuilder(column: $table.setId, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get condKey =>
      $composableBuilder(column: $table.condKey, builder: (column) => column);

  GeneratedColumn<String> get loreKey =>
      $composableBuilder(column: $table.loreKey, builder: (column) => column);
}

class $$HoloCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HoloCardsTable,
    HoloCard,
    $$HoloCardsTableFilterComposer,
    $$HoloCardsTableOrderingComposer,
    $$HoloCardsTableAnnotationComposer,
    $$HoloCardsTableCreateCompanionBuilder,
    $$HoloCardsTableUpdateCompanionBuilder,
    (HoloCard, BaseReferences<_$AppDatabase, $HoloCardsTable, HoloCard>),
    HoloCard,
    PrefetchHooks Function()> {
  $$HoloCardsTableTableManager(_$AppDatabase db, $HoloCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoloCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoloCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoloCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> setId = const Value.absent(),
            Value<String> rarity = const Value.absent(),
            Value<String> nameKey = const Value.absent(),
            Value<String> condKey = const Value.absent(),
            Value<String> loreKey = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HoloCardsCompanion(
            id: id,
            setId: setId,
            rarity: rarity,
            nameKey: nameKey,
            condKey: condKey,
            loreKey: loreKey,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String setId,
            required String rarity,
            required String nameKey,
            required String condKey,
            required String loreKey,
            Value<int> rowid = const Value.absent(),
          }) =>
              HoloCardsCompanion.insert(
            id: id,
            setId: setId,
            rarity: rarity,
            nameKey: nameKey,
            condKey: condKey,
            loreKey: loreKey,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HoloCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HoloCardsTable,
    HoloCard,
    $$HoloCardsTableFilterComposer,
    $$HoloCardsTableOrderingComposer,
    $$HoloCardsTableAnnotationComposer,
    $$HoloCardsTableCreateCompanionBuilder,
    $$HoloCardsTableUpdateCompanionBuilder,
    (HoloCard, BaseReferences<_$AppDatabase, $HoloCardsTable, HoloCard>),
    HoloCard,
    PrefetchHooks Function()>;
typedef $$HoloOwnedTableCreateCompanionBuilder = HoloOwnedCompanion Function({
  required String cardId,
  Value<int> copies,
  required int firstOwnedAt,
  Value<int> rowid,
});
typedef $$HoloOwnedTableUpdateCompanionBuilder = HoloOwnedCompanion Function({
  Value<String> cardId,
  Value<int> copies,
  Value<int> firstOwnedAt,
  Value<int> rowid,
});

class $$HoloOwnedTableFilterComposer
    extends Composer<_$AppDatabase, $HoloOwnedTable> {
  $$HoloOwnedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get copies => $composableBuilder(
      column: $table.copies, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get firstOwnedAt => $composableBuilder(
      column: $table.firstOwnedAt, builder: (column) => ColumnFilters(column));
}

class $$HoloOwnedTableOrderingComposer
    extends Composer<_$AppDatabase, $HoloOwnedTable> {
  $$HoloOwnedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get copies => $composableBuilder(
      column: $table.copies, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firstOwnedAt => $composableBuilder(
      column: $table.firstOwnedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$HoloOwnedTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoloOwnedTable> {
  $$HoloOwnedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get copies =>
      $composableBuilder(column: $table.copies, builder: (column) => column);

  GeneratedColumn<int> get firstOwnedAt => $composableBuilder(
      column: $table.firstOwnedAt, builder: (column) => column);
}

class $$HoloOwnedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HoloOwnedTable,
    HoloOwnedData,
    $$HoloOwnedTableFilterComposer,
    $$HoloOwnedTableOrderingComposer,
    $$HoloOwnedTableAnnotationComposer,
    $$HoloOwnedTableCreateCompanionBuilder,
    $$HoloOwnedTableUpdateCompanionBuilder,
    (
      HoloOwnedData,
      BaseReferences<_$AppDatabase, $HoloOwnedTable, HoloOwnedData>
    ),
    HoloOwnedData,
    PrefetchHooks Function()> {
  $$HoloOwnedTableTableManager(_$AppDatabase db, $HoloOwnedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoloOwnedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoloOwnedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoloOwnedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cardId = const Value.absent(),
            Value<int> copies = const Value.absent(),
            Value<int> firstOwnedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HoloOwnedCompanion(
            cardId: cardId,
            copies: copies,
            firstOwnedAt: firstOwnedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cardId,
            Value<int> copies = const Value.absent(),
            required int firstOwnedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HoloOwnedCompanion.insert(
            cardId: cardId,
            copies: copies,
            firstOwnedAt: firstOwnedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HoloOwnedTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HoloOwnedTable,
    HoloOwnedData,
    $$HoloOwnedTableFilterComposer,
    $$HoloOwnedTableOrderingComposer,
    $$HoloOwnedTableAnnotationComposer,
    $$HoloOwnedTableCreateCompanionBuilder,
    $$HoloOwnedTableUpdateCompanionBuilder,
    (
      HoloOwnedData,
      BaseReferences<_$AppDatabase, $HoloOwnedTable, HoloOwnedData>
    ),
    HoloOwnedData,
    PrefetchHooks Function()>;
typedef $$EventsCacheTableCreateCompanionBuilder = EventsCacheCompanion
    Function({
  required String id,
  required String titleKey,
  required String bannerKey,
  required int startsAt,
  required int endsAt,
  required String questsJson,
  required String rewardsJson,
  Value<String> rulesKey,
  Value<String> status,
  Value<int> rowid,
});
typedef $$EventsCacheTableUpdateCompanionBuilder = EventsCacheCompanion
    Function({
  Value<String> id,
  Value<String> titleKey,
  Value<String> bannerKey,
  Value<int> startsAt,
  Value<int> endsAt,
  Value<String> questsJson,
  Value<String> rewardsJson,
  Value<String> rulesKey,
  Value<String> status,
  Value<int> rowid,
});

class $$EventsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $EventsCacheTable> {
  $$EventsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bannerKey => $composableBuilder(
      column: $table.bannerKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startsAt => $composableBuilder(
      column: $table.startsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endsAt => $composableBuilder(
      column: $table.endsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questsJson => $composableBuilder(
      column: $table.questsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rewardsJson => $composableBuilder(
      column: $table.rewardsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulesKey => $composableBuilder(
      column: $table.rulesKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$EventsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsCacheTable> {
  $$EventsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bannerKey => $composableBuilder(
      column: $table.bannerKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startsAt => $composableBuilder(
      column: $table.startsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endsAt => $composableBuilder(
      column: $table.endsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questsJson => $composableBuilder(
      column: $table.questsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rewardsJson => $composableBuilder(
      column: $table.rewardsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulesKey => $composableBuilder(
      column: $table.rulesKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$EventsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsCacheTable> {
  $$EventsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<String> get bannerKey =>
      $composableBuilder(column: $table.bannerKey, builder: (column) => column);

  GeneratedColumn<int> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<int> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<String> get questsJson => $composableBuilder(
      column: $table.questsJson, builder: (column) => column);

  GeneratedColumn<String> get rewardsJson => $composableBuilder(
      column: $table.rewardsJson, builder: (column) => column);

  GeneratedColumn<String> get rulesKey =>
      $composableBuilder(column: $table.rulesKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$EventsCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsCacheTable,
    EventsCacheData,
    $$EventsCacheTableFilterComposer,
    $$EventsCacheTableOrderingComposer,
    $$EventsCacheTableAnnotationComposer,
    $$EventsCacheTableCreateCompanionBuilder,
    $$EventsCacheTableUpdateCompanionBuilder,
    (
      EventsCacheData,
      BaseReferences<_$AppDatabase, $EventsCacheTable, EventsCacheData>
    ),
    EventsCacheData,
    PrefetchHooks Function()> {
  $$EventsCacheTableTableManager(_$AppDatabase db, $EventsCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> titleKey = const Value.absent(),
            Value<String> bannerKey = const Value.absent(),
            Value<int> startsAt = const Value.absent(),
            Value<int> endsAt = const Value.absent(),
            Value<String> questsJson = const Value.absent(),
            Value<String> rewardsJson = const Value.absent(),
            Value<String> rulesKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCacheCompanion(
            id: id,
            titleKey: titleKey,
            bannerKey: bannerKey,
            startsAt: startsAt,
            endsAt: endsAt,
            questsJson: questsJson,
            rewardsJson: rewardsJson,
            rulesKey: rulesKey,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String titleKey,
            required String bannerKey,
            required int startsAt,
            required int endsAt,
            required String questsJson,
            required String rewardsJson,
            Value<String> rulesKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCacheCompanion.insert(
            id: id,
            titleKey: titleKey,
            bannerKey: bannerKey,
            startsAt: startsAt,
            endsAt: endsAt,
            questsJson: questsJson,
            rewardsJson: rewardsJson,
            rulesKey: rulesKey,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EventsCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsCacheTable,
    EventsCacheData,
    $$EventsCacheTableFilterComposer,
    $$EventsCacheTableOrderingComposer,
    $$EventsCacheTableAnnotationComposer,
    $$EventsCacheTableCreateCompanionBuilder,
    $$EventsCacheTableUpdateCompanionBuilder,
    (
      EventsCacheData,
      BaseReferences<_$AppDatabase, $EventsCacheTable, EventsCacheData>
    ),
    EventsCacheData,
    PrefetchHooks Function()>;
typedef $$EventQuestsTableCreateCompanionBuilder = EventQuestsCompanion
    Function({
  required String id,
  required String eventId,
  required String titleKey,
  required int target,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});
typedef $$EventQuestsTableUpdateCompanionBuilder = EventQuestsCompanion
    Function({
  Value<String> id,
  Value<String> eventId,
  Value<String> titleKey,
  Value<int> target,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});

class $$EventQuestsTableFilterComposer
    extends Composer<_$AppDatabase, $EventQuestsTable> {
  $$EventQuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventId => $composableBuilder(
      column: $table.eventId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnFilters(column));
}

class $$EventQuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventQuestsTable> {
  $$EventQuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventId => $composableBuilder(
      column: $table.eventId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnOrderings(column));
}

class $$EventQuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventQuestsTable> {
  $$EventQuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get claimed =>
      $composableBuilder(column: $table.claimed, builder: (column) => column);
}

class $$EventQuestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventQuestsTable,
    EventQuest,
    $$EventQuestsTableFilterComposer,
    $$EventQuestsTableOrderingComposer,
    $$EventQuestsTableAnnotationComposer,
    $$EventQuestsTableCreateCompanionBuilder,
    $$EventQuestsTableUpdateCompanionBuilder,
    (EventQuest, BaseReferences<_$AppDatabase, $EventQuestsTable, EventQuest>),
    EventQuest,
    PrefetchHooks Function()> {
  $$EventQuestsTableTableManager(_$AppDatabase db, $EventQuestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventQuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventQuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventQuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> eventId = const Value.absent(),
            Value<String> titleKey = const Value.absent(),
            Value<int> target = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventQuestsCompanion(
            id: id,
            eventId: eventId,
            titleKey: titleKey,
            target: target,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String eventId,
            required String titleKey,
            required int target,
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventQuestsCompanion.insert(
            id: id,
            eventId: eventId,
            titleKey: titleKey,
            target: target,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EventQuestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventQuestsTable,
    EventQuest,
    $$EventQuestsTableFilterComposer,
    $$EventQuestsTableOrderingComposer,
    $$EventQuestsTableAnnotationComposer,
    $$EventQuestsTableCreateCompanionBuilder,
    $$EventQuestsTableUpdateCompanionBuilder,
    (EventQuest, BaseReferences<_$AppDatabase, $EventQuestsTable, EventQuest>),
    EventQuest,
    PrefetchHooks Function()>;
typedef $$BuddyCacheTableCreateCompanionBuilder = BuddyCacheCompanion Function({
  required String id,
  Value<String?> inviteCode,
  Value<String?> buddyId,
  Value<String?> buddyNick,
  Value<double> buddyGoalPercent,
  Value<double> buddyWeeklyPercent,
  Value<int> buddyStreak,
  Value<String> buddyRank,
  Value<int> buddyWeeklyContribs,
  Value<int> pingsToday,
  Value<String?> pingsDay,
  Value<bool> weekRewardClaimed,
  Value<int> rowid,
});
typedef $$BuddyCacheTableUpdateCompanionBuilder = BuddyCacheCompanion Function({
  Value<String> id,
  Value<String?> inviteCode,
  Value<String?> buddyId,
  Value<String?> buddyNick,
  Value<double> buddyGoalPercent,
  Value<double> buddyWeeklyPercent,
  Value<int> buddyStreak,
  Value<String> buddyRank,
  Value<int> buddyWeeklyContribs,
  Value<int> pingsToday,
  Value<String?> pingsDay,
  Value<bool> weekRewardClaimed,
  Value<int> rowid,
});

class $$BuddyCacheTableFilterComposer
    extends Composer<_$AppDatabase, $BuddyCacheTable> {
  $$BuddyCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inviteCode => $composableBuilder(
      column: $table.inviteCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buddyId => $composableBuilder(
      column: $table.buddyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buddyNick => $composableBuilder(
      column: $table.buddyNick, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get buddyGoalPercent => $composableBuilder(
      column: $table.buddyGoalPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get buddyWeeklyPercent => $composableBuilder(
      column: $table.buddyWeeklyPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get buddyStreak => $composableBuilder(
      column: $table.buddyStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buddyRank => $composableBuilder(
      column: $table.buddyRank, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get buddyWeeklyContribs => $composableBuilder(
      column: $table.buddyWeeklyContribs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pingsToday => $composableBuilder(
      column: $table.pingsToday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pingsDay => $composableBuilder(
      column: $table.pingsDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get weekRewardClaimed => $composableBuilder(
      column: $table.weekRewardClaimed,
      builder: (column) => ColumnFilters(column));
}

class $$BuddyCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $BuddyCacheTable> {
  $$BuddyCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inviteCode => $composableBuilder(
      column: $table.inviteCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buddyId => $composableBuilder(
      column: $table.buddyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buddyNick => $composableBuilder(
      column: $table.buddyNick, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get buddyGoalPercent => $composableBuilder(
      column: $table.buddyGoalPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get buddyWeeklyPercent => $composableBuilder(
      column: $table.buddyWeeklyPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get buddyStreak => $composableBuilder(
      column: $table.buddyStreak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buddyRank => $composableBuilder(
      column: $table.buddyRank, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get buddyWeeklyContribs => $composableBuilder(
      column: $table.buddyWeeklyContribs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pingsToday => $composableBuilder(
      column: $table.pingsToday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pingsDay => $composableBuilder(
      column: $table.pingsDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get weekRewardClaimed => $composableBuilder(
      column: $table.weekRewardClaimed,
      builder: (column) => ColumnOrderings(column));
}

class $$BuddyCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuddyCacheTable> {
  $$BuddyCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inviteCode => $composableBuilder(
      column: $table.inviteCode, builder: (column) => column);

  GeneratedColumn<String> get buddyId =>
      $composableBuilder(column: $table.buddyId, builder: (column) => column);

  GeneratedColumn<String> get buddyNick =>
      $composableBuilder(column: $table.buddyNick, builder: (column) => column);

  GeneratedColumn<double> get buddyGoalPercent => $composableBuilder(
      column: $table.buddyGoalPercent, builder: (column) => column);

  GeneratedColumn<double> get buddyWeeklyPercent => $composableBuilder(
      column: $table.buddyWeeklyPercent, builder: (column) => column);

  GeneratedColumn<int> get buddyStreak => $composableBuilder(
      column: $table.buddyStreak, builder: (column) => column);

  GeneratedColumn<String> get buddyRank =>
      $composableBuilder(column: $table.buddyRank, builder: (column) => column);

  GeneratedColumn<int> get buddyWeeklyContribs => $composableBuilder(
      column: $table.buddyWeeklyContribs, builder: (column) => column);

  GeneratedColumn<int> get pingsToday => $composableBuilder(
      column: $table.pingsToday, builder: (column) => column);

  GeneratedColumn<String> get pingsDay =>
      $composableBuilder(column: $table.pingsDay, builder: (column) => column);

  GeneratedColumn<bool> get weekRewardClaimed => $composableBuilder(
      column: $table.weekRewardClaimed, builder: (column) => column);
}

class $$BuddyCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BuddyCacheTable,
    BuddyCacheData,
    $$BuddyCacheTableFilterComposer,
    $$BuddyCacheTableOrderingComposer,
    $$BuddyCacheTableAnnotationComposer,
    $$BuddyCacheTableCreateCompanionBuilder,
    $$BuddyCacheTableUpdateCompanionBuilder,
    (
      BuddyCacheData,
      BaseReferences<_$AppDatabase, $BuddyCacheTable, BuddyCacheData>
    ),
    BuddyCacheData,
    PrefetchHooks Function()> {
  $$BuddyCacheTableTableManager(_$AppDatabase db, $BuddyCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BuddyCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BuddyCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BuddyCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> inviteCode = const Value.absent(),
            Value<String?> buddyId = const Value.absent(),
            Value<String?> buddyNick = const Value.absent(),
            Value<double> buddyGoalPercent = const Value.absent(),
            Value<double> buddyWeeklyPercent = const Value.absent(),
            Value<int> buddyStreak = const Value.absent(),
            Value<String> buddyRank = const Value.absent(),
            Value<int> buddyWeeklyContribs = const Value.absent(),
            Value<int> pingsToday = const Value.absent(),
            Value<String?> pingsDay = const Value.absent(),
            Value<bool> weekRewardClaimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BuddyCacheCompanion(
            id: id,
            inviteCode: inviteCode,
            buddyId: buddyId,
            buddyNick: buddyNick,
            buddyGoalPercent: buddyGoalPercent,
            buddyWeeklyPercent: buddyWeeklyPercent,
            buddyStreak: buddyStreak,
            buddyRank: buddyRank,
            buddyWeeklyContribs: buddyWeeklyContribs,
            pingsToday: pingsToday,
            pingsDay: pingsDay,
            weekRewardClaimed: weekRewardClaimed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> inviteCode = const Value.absent(),
            Value<String?> buddyId = const Value.absent(),
            Value<String?> buddyNick = const Value.absent(),
            Value<double> buddyGoalPercent = const Value.absent(),
            Value<double> buddyWeeklyPercent = const Value.absent(),
            Value<int> buddyStreak = const Value.absent(),
            Value<String> buddyRank = const Value.absent(),
            Value<int> buddyWeeklyContribs = const Value.absent(),
            Value<int> pingsToday = const Value.absent(),
            Value<String?> pingsDay = const Value.absent(),
            Value<bool> weekRewardClaimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BuddyCacheCompanion.insert(
            id: id,
            inviteCode: inviteCode,
            buddyId: buddyId,
            buddyNick: buddyNick,
            buddyGoalPercent: buddyGoalPercent,
            buddyWeeklyPercent: buddyWeeklyPercent,
            buddyStreak: buddyStreak,
            buddyRank: buddyRank,
            buddyWeeklyContribs: buddyWeeklyContribs,
            pingsToday: pingsToday,
            pingsDay: pingsDay,
            weekRewardClaimed: weekRewardClaimed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BuddyCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BuddyCacheTable,
    BuddyCacheData,
    $$BuddyCacheTableFilterComposer,
    $$BuddyCacheTableOrderingComposer,
    $$BuddyCacheTableAnnotationComposer,
    $$BuddyCacheTableCreateCompanionBuilder,
    $$BuddyCacheTableUpdateCompanionBuilder,
    (
      BuddyCacheData,
      BaseReferences<_$AppDatabase, $BuddyCacheTable, BuddyCacheData>
    ),
    BuddyCacheData,
    PrefetchHooks Function()>;
typedef $$GhostCacheTableCreateCompanionBuilder = GhostCacheCompanion Function({
  required String id,
  required String nick,
  required double percent,
  required int weeklyXp,
  required String rankLabel,
  required int streakDays,
  required String weekKey,
  Value<int> rowid,
});
typedef $$GhostCacheTableUpdateCompanionBuilder = GhostCacheCompanion Function({
  Value<String> id,
  Value<String> nick,
  Value<double> percent,
  Value<int> weeklyXp,
  Value<String> rankLabel,
  Value<int> streakDays,
  Value<String> weekKey,
  Value<int> rowid,
});

class $$GhostCacheTableFilterComposer
    extends Composer<_$AppDatabase, $GhostCacheTable> {
  $$GhostCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nick => $composableBuilder(
      column: $table.nick, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeklyXp => $composableBuilder(
      column: $table.weeklyXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rankLabel => $composableBuilder(
      column: $table.rankLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekKey => $composableBuilder(
      column: $table.weekKey, builder: (column) => ColumnFilters(column));
}

class $$GhostCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $GhostCacheTable> {
  $$GhostCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nick => $composableBuilder(
      column: $table.nick, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyXp => $composableBuilder(
      column: $table.weeklyXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rankLabel => $composableBuilder(
      column: $table.rankLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekKey => $composableBuilder(
      column: $table.weekKey, builder: (column) => ColumnOrderings(column));
}

class $$GhostCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $GhostCacheTable> {
  $$GhostCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nick =>
      $composableBuilder(column: $table.nick, builder: (column) => column);

  GeneratedColumn<double> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);

  GeneratedColumn<int> get weeklyXp =>
      $composableBuilder(column: $table.weeklyXp, builder: (column) => column);

  GeneratedColumn<String> get rankLabel =>
      $composableBuilder(column: $table.rankLabel, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => column);

  GeneratedColumn<String> get weekKey =>
      $composableBuilder(column: $table.weekKey, builder: (column) => column);
}

class $$GhostCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GhostCacheTable,
    GhostCacheData,
    $$GhostCacheTableFilterComposer,
    $$GhostCacheTableOrderingComposer,
    $$GhostCacheTableAnnotationComposer,
    $$GhostCacheTableCreateCompanionBuilder,
    $$GhostCacheTableUpdateCompanionBuilder,
    (
      GhostCacheData,
      BaseReferences<_$AppDatabase, $GhostCacheTable, GhostCacheData>
    ),
    GhostCacheData,
    PrefetchHooks Function()> {
  $$GhostCacheTableTableManager(_$AppDatabase db, $GhostCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GhostCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GhostCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GhostCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nick = const Value.absent(),
            Value<double> percent = const Value.absent(),
            Value<int> weeklyXp = const Value.absent(),
            Value<String> rankLabel = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<String> weekKey = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GhostCacheCompanion(
            id: id,
            nick: nick,
            percent: percent,
            weeklyXp: weeklyXp,
            rankLabel: rankLabel,
            streakDays: streakDays,
            weekKey: weekKey,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nick,
            required double percent,
            required int weeklyXp,
            required String rankLabel,
            required int streakDays,
            required String weekKey,
            Value<int> rowid = const Value.absent(),
          }) =>
              GhostCacheCompanion.insert(
            id: id,
            nick: nick,
            percent: percent,
            weeklyXp: weeklyXp,
            rankLabel: rankLabel,
            streakDays: streakDays,
            weekKey: weekKey,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GhostCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GhostCacheTable,
    GhostCacheData,
    $$GhostCacheTableFilterComposer,
    $$GhostCacheTableOrderingComposer,
    $$GhostCacheTableAnnotationComposer,
    $$GhostCacheTableCreateCompanionBuilder,
    $$GhostCacheTableUpdateCompanionBuilder,
    (
      GhostCacheData,
      BaseReferences<_$AppDatabase, $GhostCacheTable, GhostCacheData>
    ),
    GhostCacheData,
    PrefetchHooks Function()>;
typedef $$LeaderboardOptInTableCreateCompanionBuilder
    = LeaderboardOptInCompanion Function({
  required String id,
  Value<bool> optedIn,
  Value<bool> ghostRewardClaimedThisWeek,
  Value<String?> ghostRewardWeek,
  Value<int> rowid,
});
typedef $$LeaderboardOptInTableUpdateCompanionBuilder
    = LeaderboardOptInCompanion Function({
  Value<String> id,
  Value<bool> optedIn,
  Value<bool> ghostRewardClaimedThisWeek,
  Value<String?> ghostRewardWeek,
  Value<int> rowid,
});

class $$LeaderboardOptInTableFilterComposer
    extends Composer<_$AppDatabase, $LeaderboardOptInTable> {
  $$LeaderboardOptInTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get optedIn => $composableBuilder(
      column: $table.optedIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ghostRewardClaimedThisWeek => $composableBuilder(
      column: $table.ghostRewardClaimedThisWeek,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ghostRewardWeek => $composableBuilder(
      column: $table.ghostRewardWeek,
      builder: (column) => ColumnFilters(column));
}

class $$LeaderboardOptInTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaderboardOptInTable> {
  $$LeaderboardOptInTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get optedIn => $composableBuilder(
      column: $table.optedIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ghostRewardClaimedThisWeek => $composableBuilder(
      column: $table.ghostRewardClaimedThisWeek,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ghostRewardWeek => $composableBuilder(
      column: $table.ghostRewardWeek,
      builder: (column) => ColumnOrderings(column));
}

class $$LeaderboardOptInTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaderboardOptInTable> {
  $$LeaderboardOptInTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get optedIn =>
      $composableBuilder(column: $table.optedIn, builder: (column) => column);

  GeneratedColumn<bool> get ghostRewardClaimedThisWeek => $composableBuilder(
      column: $table.ghostRewardClaimedThisWeek, builder: (column) => column);

  GeneratedColumn<String> get ghostRewardWeek => $composableBuilder(
      column: $table.ghostRewardWeek, builder: (column) => column);
}

class $$LeaderboardOptInTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LeaderboardOptInTable,
    LeaderboardOptInData,
    $$LeaderboardOptInTableFilterComposer,
    $$LeaderboardOptInTableOrderingComposer,
    $$LeaderboardOptInTableAnnotationComposer,
    $$LeaderboardOptInTableCreateCompanionBuilder,
    $$LeaderboardOptInTableUpdateCompanionBuilder,
    (
      LeaderboardOptInData,
      BaseReferences<_$AppDatabase, $LeaderboardOptInTable,
          LeaderboardOptInData>
    ),
    LeaderboardOptInData,
    PrefetchHooks Function()> {
  $$LeaderboardOptInTableTableManager(
      _$AppDatabase db, $LeaderboardOptInTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaderboardOptInTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaderboardOptInTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaderboardOptInTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> optedIn = const Value.absent(),
            Value<bool> ghostRewardClaimedThisWeek = const Value.absent(),
            Value<String?> ghostRewardWeek = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LeaderboardOptInCompanion(
            id: id,
            optedIn: optedIn,
            ghostRewardClaimedThisWeek: ghostRewardClaimedThisWeek,
            ghostRewardWeek: ghostRewardWeek,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<bool> optedIn = const Value.absent(),
            Value<bool> ghostRewardClaimedThisWeek = const Value.absent(),
            Value<String?> ghostRewardWeek = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LeaderboardOptInCompanion.insert(
            id: id,
            optedIn: optedIn,
            ghostRewardClaimedThisWeek: ghostRewardClaimedThisWeek,
            ghostRewardWeek: ghostRewardWeek,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LeaderboardOptInTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LeaderboardOptInTable,
    LeaderboardOptInData,
    $$LeaderboardOptInTableFilterComposer,
    $$LeaderboardOptInTableOrderingComposer,
    $$LeaderboardOptInTableAnnotationComposer,
    $$LeaderboardOptInTableCreateCompanionBuilder,
    $$LeaderboardOptInTableUpdateCompanionBuilder,
    (
      LeaderboardOptInData,
      BaseReferences<_$AppDatabase, $LeaderboardOptInTable,
          LeaderboardOptInData>
    ),
    LeaderboardOptInData,
    PrefetchHooks Function()>;
typedef $$ApiKeysTableCreateCompanionBuilder = ApiKeysCompanion Function({
  required String id,
  required String name,
  required String storeId,
  required String keyHash,
  required String keyPreview,
  required String salt,
  Value<String?> notes,
  Value<String> status,
  Value<int?> lastOkAt,
  Value<String?> lastError,
  Value<int?> rateLimitPerHour,
  required int createdAt,
  Value<int> rowid,
});
typedef $$ApiKeysTableUpdateCompanionBuilder = ApiKeysCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> storeId,
  Value<String> keyHash,
  Value<String> keyPreview,
  Value<String> salt,
  Value<String?> notes,
  Value<String> status,
  Value<int?> lastOkAt,
  Value<String?> lastError,
  Value<int?> rateLimitPerHour,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$ApiKeysTableFilterComposer
    extends Composer<_$AppDatabase, $ApiKeysTable> {
  $$ApiKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storeId => $composableBuilder(
      column: $table.storeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyHash => $composableBuilder(
      column: $table.keyHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyPreview => $composableBuilder(
      column: $table.keyPreview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastOkAt => $composableBuilder(
      column: $table.lastOkAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rateLimitPerHour => $composableBuilder(
      column: $table.rateLimitPerHour,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ApiKeysTableOrderingComposer
    extends Composer<_$AppDatabase, $ApiKeysTable> {
  $$ApiKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storeId => $composableBuilder(
      column: $table.storeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyHash => $composableBuilder(
      column: $table.keyHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyPreview => $composableBuilder(
      column: $table.keyPreview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastOkAt => $composableBuilder(
      column: $table.lastOkAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rateLimitPerHour => $composableBuilder(
      column: $table.rateLimitPerHour,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ApiKeysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApiKeysTable> {
  $$ApiKeysTableAnnotationComposer({
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

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get keyHash =>
      $composableBuilder(column: $table.keyHash, builder: (column) => column);

  GeneratedColumn<String> get keyPreview => $composableBuilder(
      column: $table.keyPreview, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get lastOkAt =>
      $composableBuilder(column: $table.lastOkAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get rateLimitPerHour => $composableBuilder(
      column: $table.rateLimitPerHour, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ApiKeysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ApiKeysTable,
    ApiKey,
    $$ApiKeysTableFilterComposer,
    $$ApiKeysTableOrderingComposer,
    $$ApiKeysTableAnnotationComposer,
    $$ApiKeysTableCreateCompanionBuilder,
    $$ApiKeysTableUpdateCompanionBuilder,
    (ApiKey, BaseReferences<_$AppDatabase, $ApiKeysTable, ApiKey>),
    ApiKey,
    PrefetchHooks Function()> {
  $$ApiKeysTableTableManager(_$AppDatabase db, $ApiKeysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> storeId = const Value.absent(),
            Value<String> keyHash = const Value.absent(),
            Value<String> keyPreview = const Value.absent(),
            Value<String> salt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> lastOkAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int?> rateLimitPerHour = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ApiKeysCompanion(
            id: id,
            name: name,
            storeId: storeId,
            keyHash: keyHash,
            keyPreview: keyPreview,
            salt: salt,
            notes: notes,
            status: status,
            lastOkAt: lastOkAt,
            lastError: lastError,
            rateLimitPerHour: rateLimitPerHour,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String storeId,
            required String keyHash,
            required String keyPreview,
            required String salt,
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> lastOkAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int?> rateLimitPerHour = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ApiKeysCompanion.insert(
            id: id,
            name: name,
            storeId: storeId,
            keyHash: keyHash,
            keyPreview: keyPreview,
            salt: salt,
            notes: notes,
            status: status,
            lastOkAt: lastOkAt,
            lastError: lastError,
            rateLimitPerHour: rateLimitPerHour,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ApiKeysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ApiKeysTable,
    ApiKey,
    $$ApiKeysTableFilterComposer,
    $$ApiKeysTableOrderingComposer,
    $$ApiKeysTableAnnotationComposer,
    $$ApiKeysTableCreateCompanionBuilder,
    $$ApiKeysTableUpdateCompanionBuilder,
    (ApiKey, BaseReferences<_$AppDatabase, $ApiKeysTable, ApiKey>),
    ApiKey,
    PrefetchHooks Function()>;
typedef $$ProgressCardsTableCreateCompanionBuilder = ProgressCardsCompanion
    Function({
  required String id,
  Value<bool> enabled,
  Value<String?> token,
  Value<bool> showRank,
  Value<bool> showStreak,
  Value<bool> showPercent,
  Value<bool> showAmount,
  Value<int> views,
  Value<int?> createdAt,
  Value<int> rowid,
});
typedef $$ProgressCardsTableUpdateCompanionBuilder = ProgressCardsCompanion
    Function({
  Value<String> id,
  Value<bool> enabled,
  Value<String?> token,
  Value<bool> showRank,
  Value<bool> showStreak,
  Value<bool> showPercent,
  Value<bool> showAmount,
  Value<int> views,
  Value<int?> createdAt,
  Value<int> rowid,
});

class $$ProgressCardsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressCardsTable> {
  $$ProgressCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showRank => $composableBuilder(
      column: $table.showRank, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showStreak => $composableBuilder(
      column: $table.showStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showPercent => $composableBuilder(
      column: $table.showPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showAmount => $composableBuilder(
      column: $table.showAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get views => $composableBuilder(
      column: $table.views, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProgressCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressCardsTable> {
  $$ProgressCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showRank => $composableBuilder(
      column: $table.showRank, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showStreak => $composableBuilder(
      column: $table.showStreak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showPercent => $composableBuilder(
      column: $table.showPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showAmount => $composableBuilder(
      column: $table.showAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get views => $composableBuilder(
      column: $table.views, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProgressCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressCardsTable> {
  $$ProgressCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<bool> get showRank =>
      $composableBuilder(column: $table.showRank, builder: (column) => column);

  GeneratedColumn<bool> get showStreak => $composableBuilder(
      column: $table.showStreak, builder: (column) => column);

  GeneratedColumn<bool> get showPercent => $composableBuilder(
      column: $table.showPercent, builder: (column) => column);

  GeneratedColumn<bool> get showAmount => $composableBuilder(
      column: $table.showAmount, builder: (column) => column);

  GeneratedColumn<int> get views =>
      $composableBuilder(column: $table.views, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProgressCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressCardsTable,
    ProgressCard,
    $$ProgressCardsTableFilterComposer,
    $$ProgressCardsTableOrderingComposer,
    $$ProgressCardsTableAnnotationComposer,
    $$ProgressCardsTableCreateCompanionBuilder,
    $$ProgressCardsTableUpdateCompanionBuilder,
    (
      ProgressCard,
      BaseReferences<_$AppDatabase, $ProgressCardsTable, ProgressCard>
    ),
    ProgressCard,
    PrefetchHooks Function()> {
  $$ProgressCardsTableTableManager(_$AppDatabase db, $ProgressCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<bool> showRank = const Value.absent(),
            Value<bool> showStreak = const Value.absent(),
            Value<bool> showPercent = const Value.absent(),
            Value<bool> showAmount = const Value.absent(),
            Value<int> views = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressCardsCompanion(
            id: id,
            enabled: enabled,
            token: token,
            showRank: showRank,
            showStreak: showStreak,
            showPercent: showPercent,
            showAmount: showAmount,
            views: views,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<bool> enabled = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<bool> showRank = const Value.absent(),
            Value<bool> showStreak = const Value.absent(),
            Value<bool> showPercent = const Value.absent(),
            Value<bool> showAmount = const Value.absent(),
            Value<int> views = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressCardsCompanion.insert(
            id: id,
            enabled: enabled,
            token: token,
            showRank: showRank,
            showStreak: showStreak,
            showPercent: showPercent,
            showAmount: showAmount,
            views: views,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgressCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgressCardsTable,
    ProgressCard,
    $$ProgressCardsTableFilterComposer,
    $$ProgressCardsTableOrderingComposer,
    $$ProgressCardsTableAnnotationComposer,
    $$ProgressCardsTableCreateCompanionBuilder,
    $$ProgressCardsTableUpdateCompanionBuilder,
    (
      ProgressCard,
      BaseReferences<_$AppDatabase, $ProgressCardsTable, ProgressCard>
    ),
    ProgressCard,
    PrefetchHooks Function()>;
typedef $$SearchHistoryTableCreateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  required String bundleName,
  required int totalPrice,
  required int score,
  required String status,
  Value<bool> isCurrent,
  required int searchedAt,
});
typedef $$SearchHistoryTableUpdateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  Value<String> bundleName,
  Value<int> totalPrice,
  Value<int> score,
  Value<String> status,
  Value<bool> isCurrent,
  Value<int> searchedAt,
});

class $$SearchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bundleName => $composableBuilder(
      column: $table.bundleName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCurrent => $composableBuilder(
      column: $table.isCurrent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bundleName => $composableBuilder(
      column: $table.bundleName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
      column: $table.isCurrent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bundleName => $composableBuilder(
      column: $table.bundleName, builder: (column) => column);

  GeneratedColumn<int> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<int> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => column);
}

class $$SearchHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()> {
  $$SearchHistoryTableTableManager(_$AppDatabase db, $SearchHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bundleName = const Value.absent(),
            Value<int> totalPrice = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isCurrent = const Value.absent(),
            Value<int> searchedAt = const Value.absent(),
          }) =>
              SearchHistoryCompanion(
            id: id,
            bundleName: bundleName,
            totalPrice: totalPrice,
            score: score,
            status: status,
            isCurrent: isCurrent,
            searchedAt: searchedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bundleName,
            required int totalPrice,
            required int score,
            required String status,
            Value<bool> isCurrent = const Value.absent(),
            required int searchedAt,
          }) =>
              SearchHistoryCompanion.insert(
            id: id,
            bundleName: bundleName,
            totalPrice: totalPrice,
            score: score,
            status: status,
            isCurrent: isCurrent,
            searchedAt: searchedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()>;
typedef $$AppConfigTableTableCreateCompanionBuilder = AppConfigTableCompanion
    Function({
  required String key,
  required String valueJson,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$AppConfigTableTableUpdateCompanionBuilder = AppConfigTableCompanion
    Function({
  Value<String> key,
  Value<String> valueJson,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$AppConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppConfigTableTable> {
  $$AppConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valueJson => $composableBuilder(
      column: $table.valueJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppConfigTableTable> {
  $$AppConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valueJson => $composableBuilder(
      column: $table.valueJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppConfigTableTable> {
  $$AppConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppConfigTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppConfigTableTable,
    AppConfigTableData,
    $$AppConfigTableTableFilterComposer,
    $$AppConfigTableTableOrderingComposer,
    $$AppConfigTableTableAnnotationComposer,
    $$AppConfigTableTableCreateCompanionBuilder,
    $$AppConfigTableTableUpdateCompanionBuilder,
    (
      AppConfigTableData,
      BaseReferences<_$AppDatabase, $AppConfigTableTable, AppConfigTableData>
    ),
    AppConfigTableData,
    PrefetchHooks Function()> {
  $$AppConfigTableTableTableManager(
      _$AppDatabase db, $AppConfigTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppConfigTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppConfigTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> valueJson = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppConfigTableCompanion(
            key: key,
            valueJson: valueJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String valueJson,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppConfigTableCompanion.insert(
            key: key,
            valueJson: valueJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppConfigTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppConfigTableTable,
    AppConfigTableData,
    $$AppConfigTableTableFilterComposer,
    $$AppConfigTableTableOrderingComposer,
    $$AppConfigTableTableAnnotationComposer,
    $$AppConfigTableTableCreateCompanionBuilder,
    $$AppConfigTableTableUpdateCompanionBuilder,
    (
      AppConfigTableData,
      BaseReferences<_$AppDatabase, $AppConfigTableTable, AppConfigTableData>
    ),
    AppConfigTableData,
    PrefetchHooks Function()>;
typedef $$PinMetaTableCreateCompanionBuilder = PinMetaCompanion Function({
  required String id,
  Value<String?> pinHash,
  Value<String?> salt,
  Value<int> failedAttempts,
  Value<int?> lockedUntil,
  Value<bool> biometricEnabled,
  Value<int> autolockMinutes,
  Value<int> rowid,
});
typedef $$PinMetaTableUpdateCompanionBuilder = PinMetaCompanion Function({
  Value<String> id,
  Value<String?> pinHash,
  Value<String?> salt,
  Value<int> failedAttempts,
  Value<int?> lockedUntil,
  Value<bool> biometricEnabled,
  Value<int> autolockMinutes,
  Value<int> rowid,
});

class $$PinMetaTableFilterComposer
    extends Composer<_$AppDatabase, $PinMetaTable> {
  $$PinMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get autolockMinutes => $composableBuilder(
      column: $table.autolockMinutes,
      builder: (column) => ColumnFilters(column));
}

class $$PinMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $PinMetaTable> {
  $$PinMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get autolockMinutes => $composableBuilder(
      column: $table.autolockMinutes,
      builder: (column) => ColumnOrderings(column));
}

class $$PinMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $PinMetaTable> {
  $$PinMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts, builder: (column) => column);

  GeneratedColumn<int> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled, builder: (column) => column);

  GeneratedColumn<int> get autolockMinutes => $composableBuilder(
      column: $table.autolockMinutes, builder: (column) => column);
}

class $$PinMetaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PinMetaTable,
    PinMetaData,
    $$PinMetaTableFilterComposer,
    $$PinMetaTableOrderingComposer,
    $$PinMetaTableAnnotationComposer,
    $$PinMetaTableCreateCompanionBuilder,
    $$PinMetaTableUpdateCompanionBuilder,
    (PinMetaData, BaseReferences<_$AppDatabase, $PinMetaTable, PinMetaData>),
    PinMetaData,
    PrefetchHooks Function()> {
  $$PinMetaTableTableManager(_$AppDatabase db, $PinMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<String?> salt = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<int?> lockedUntil = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<int> autolockMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinMetaCompanion(
            id: id,
            pinHash: pinHash,
            salt: salt,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            biometricEnabled: biometricEnabled,
            autolockMinutes: autolockMinutes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> pinHash = const Value.absent(),
            Value<String?> salt = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<int?> lockedUntil = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<int> autolockMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinMetaCompanion.insert(
            id: id,
            pinHash: pinHash,
            salt: salt,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            biometricEnabled: biometricEnabled,
            autolockMinutes: autolockMinutes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PinMetaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PinMetaTable,
    PinMetaData,
    $$PinMetaTableFilterComposer,
    $$PinMetaTableOrderingComposer,
    $$PinMetaTableAnnotationComposer,
    $$PinMetaTableCreateCompanionBuilder,
    $$PinMetaTableUpdateCompanionBuilder,
    (PinMetaData, BaseReferences<_$AppDatabase, $PinMetaTable, PinMetaData>),
    PinMetaData,
    PrefetchHooks Function()>;
typedef $$AiUsageTableTableCreateCompanionBuilder = AiUsageTableCompanion
    Function({
  required String id,
  Value<int> used,
  Value<int> rowid,
});
typedef $$AiUsageTableTableUpdateCompanionBuilder = AiUsageTableCompanion
    Function({
  Value<String> id,
  Value<int> used,
  Value<int> rowid,
});

class $$AiUsageTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiUsageTableTable> {
  $$AiUsageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get used => $composableBuilder(
      column: $table.used, builder: (column) => ColumnFilters(column));
}

class $$AiUsageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiUsageTableTable> {
  $$AiUsageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get used => $composableBuilder(
      column: $table.used, builder: (column) => ColumnOrderings(column));
}

class $$AiUsageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiUsageTableTable> {
  $$AiUsageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get used =>
      $composableBuilder(column: $table.used, builder: (column) => column);
}

class $$AiUsageTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiUsageTableTable,
    AiUsageTableData,
    $$AiUsageTableTableFilterComposer,
    $$AiUsageTableTableOrderingComposer,
    $$AiUsageTableTableAnnotationComposer,
    $$AiUsageTableTableCreateCompanionBuilder,
    $$AiUsageTableTableUpdateCompanionBuilder,
    (
      AiUsageTableData,
      BaseReferences<_$AppDatabase, $AiUsageTableTable, AiUsageTableData>
    ),
    AiUsageTableData,
    PrefetchHooks Function()> {
  $$AiUsageTableTableTableManager(_$AppDatabase db, $AiUsageTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiUsageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiUsageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiUsageTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> used = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AiUsageTableCompanion(
            id: id,
            used: used,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> used = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AiUsageTableCompanion.insert(
            id: id,
            used: used,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AiUsageTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AiUsageTableTable,
    AiUsageTableData,
    $$AiUsageTableTableFilterComposer,
    $$AiUsageTableTableOrderingComposer,
    $$AiUsageTableTableAnnotationComposer,
    $$AiUsageTableTableCreateCompanionBuilder,
    $$AiUsageTableTableUpdateCompanionBuilder,
    (
      AiUsageTableData,
      BaseReferences<_$AppDatabase, $AiUsageTableTable, AiUsageTableData>
    ),
    AiUsageTableData,
    PrefetchHooks Function()>;
typedef $$RateAppStateTableCreateCompanionBuilder = RateAppStateCompanion
    Function({
  required String id,
  Value<int> contribsAtLastPrompt,
  Value<int?> lastPromptAt,
  Value<bool> neverAsk,
  Value<int> rowid,
});
typedef $$RateAppStateTableUpdateCompanionBuilder = RateAppStateCompanion
    Function({
  Value<String> id,
  Value<int> contribsAtLastPrompt,
  Value<int?> lastPromptAt,
  Value<bool> neverAsk,
  Value<int> rowid,
});

class $$RateAppStateTableFilterComposer
    extends Composer<_$AppDatabase, $RateAppStateTable> {
  $$RateAppStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get contribsAtLastPrompt => $composableBuilder(
      column: $table.contribsAtLastPrompt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPromptAt => $composableBuilder(
      column: $table.lastPromptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get neverAsk => $composableBuilder(
      column: $table.neverAsk, builder: (column) => ColumnFilters(column));
}

class $$RateAppStateTableOrderingComposer
    extends Composer<_$AppDatabase, $RateAppStateTable> {
  $$RateAppStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contribsAtLastPrompt => $composableBuilder(
      column: $table.contribsAtLastPrompt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPromptAt => $composableBuilder(
      column: $table.lastPromptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get neverAsk => $composableBuilder(
      column: $table.neverAsk, builder: (column) => ColumnOrderings(column));
}

class $$RateAppStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $RateAppStateTable> {
  $$RateAppStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get contribsAtLastPrompt => $composableBuilder(
      column: $table.contribsAtLastPrompt, builder: (column) => column);

  GeneratedColumn<int> get lastPromptAt => $composableBuilder(
      column: $table.lastPromptAt, builder: (column) => column);

  GeneratedColumn<bool> get neverAsk =>
      $composableBuilder(column: $table.neverAsk, builder: (column) => column);
}

class $$RateAppStateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RateAppStateTable,
    RateAppStateData,
    $$RateAppStateTableFilterComposer,
    $$RateAppStateTableOrderingComposer,
    $$RateAppStateTableAnnotationComposer,
    $$RateAppStateTableCreateCompanionBuilder,
    $$RateAppStateTableUpdateCompanionBuilder,
    (
      RateAppStateData,
      BaseReferences<_$AppDatabase, $RateAppStateTable, RateAppStateData>
    ),
    RateAppStateData,
    PrefetchHooks Function()> {
  $$RateAppStateTableTableManager(_$AppDatabase db, $RateAppStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RateAppStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RateAppStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RateAppStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> contribsAtLastPrompt = const Value.absent(),
            Value<int?> lastPromptAt = const Value.absent(),
            Value<bool> neverAsk = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RateAppStateCompanion(
            id: id,
            contribsAtLastPrompt: contribsAtLastPrompt,
            lastPromptAt: lastPromptAt,
            neverAsk: neverAsk,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> contribsAtLastPrompt = const Value.absent(),
            Value<int?> lastPromptAt = const Value.absent(),
            Value<bool> neverAsk = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RateAppStateCompanion.insert(
            id: id,
            contribsAtLastPrompt: contribsAtLastPrompt,
            lastPromptAt: lastPromptAt,
            neverAsk: neverAsk,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RateAppStateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RateAppStateTable,
    RateAppStateData,
    $$RateAppStateTableFilterComposer,
    $$RateAppStateTableOrderingComposer,
    $$RateAppStateTableAnnotationComposer,
    $$RateAppStateTableCreateCompanionBuilder,
    $$RateAppStateTableUpdateCompanionBuilder,
    (
      RateAppStateData,
      BaseReferences<_$AppDatabase, $RateAppStateTable, RateAppStateData>
    ),
    RateAppStateData,
    PrefetchHooks Function()>;
typedef $$MetaTableCreateCompanionBuilder = MetaCompanion Function({
  required String key,
  Value<int> value,
  Value<int> rowid,
});
typedef $$MetaTableUpdateCompanionBuilder = MetaCompanion Function({
  Value<String> key,
  Value<int> value,
  Value<int> rowid,
});

class $$MetaTableFilterComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$MetaTableOrderingComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$MetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MetaTable,
    MetaData,
    $$MetaTableFilterComposer,
    $$MetaTableOrderingComposer,
    $$MetaTableAnnotationComposer,
    $$MetaTableCreateCompanionBuilder,
    $$MetaTableUpdateCompanionBuilder,
    (MetaData, BaseReferences<_$AppDatabase, $MetaTable, MetaData>),
    MetaData,
    PrefetchHooks Function()> {
  $$MetaTableTableManager(_$AppDatabase db, $MetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MetaCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<int> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MetaCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MetaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MetaTable,
    MetaData,
    $$MetaTableFilterComposer,
    $$MetaTableOrderingComposer,
    $$MetaTableAnnotationComposer,
    $$MetaTableCreateCompanionBuilder,
    $$MetaTableUpdateCompanionBuilder,
    (MetaData, BaseReferences<_$AppDatabase, $MetaTable, MetaData>),
    MetaData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$GoalItemsTableTableManager get goalItems =>
      $$GoalItemsTableTableManager(_db, _db.goalItems);
  $$ContributionsTableTableManager get contributions =>
      $$ContributionsTableTableManager(_db, _db.contributions);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$AchievementsUnlockedTableTableManager get achievementsUnlocked =>
      $$AchievementsUnlockedTableTableManager(_db, _db.achievementsUnlocked);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$UserStatsTableTableTableManager get userStatsTable =>
      $$UserStatsTableTableTableManager(_db, _db.userStatsTable);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$PriceHistoryTableTableManager get priceHistory =>
      $$PriceHistoryTableTableManager(_db, _db.priceHistory);
  $$ScanRunsTableTableManager get scanRuns =>
      $$ScanRunsTableTableManager(_db, _db.scanRuns);
  $$MonitorSpecsTableTableManager get monitorSpecs =>
      $$MonitorSpecsTableTableManager(_db, _db.monitorSpecs);
  $$Ps5SpecsTableTableManager get ps5Specs =>
      $$Ps5SpecsTableTableManager(_db, _db.ps5Specs);
  $$NotificationsCacheTableTableManager get notificationsCache =>
      $$NotificationsCacheTableTableManager(_db, _db.notificationsCache);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$ChipsWalletTableTableTableManager get chipsWalletTable =>
      $$ChipsWalletTableTableTableManager(_db, _db.chipsWalletTable);
  $$ChipsLedgerTableTableManager get chipsLedger =>
      $$ChipsLedgerTableTableManager(_db, _db.chipsLedger);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$PetSkinsTableTableManager get petSkins =>
      $$PetSkinsTableTableManager(_db, _db.petSkins);
  $$QuestsDailyTableTableManager get questsDaily =>
      $$QuestsDailyTableTableManager(_db, _db.questsDaily);
  $$QuestsWeeklyTableTableManager get questsWeekly =>
      $$QuestsWeeklyTableTableManager(_db, _db.questsWeekly);
  $$ChestsTableTableManager get chests =>
      $$ChestsTableTableManager(_db, _db.chests);
  $$HoloSetsTableTableManager get holoSets =>
      $$HoloSetsTableTableManager(_db, _db.holoSets);
  $$HoloCardsTableTableManager get holoCards =>
      $$HoloCardsTableTableManager(_db, _db.holoCards);
  $$HoloOwnedTableTableManager get holoOwned =>
      $$HoloOwnedTableTableManager(_db, _db.holoOwned);
  $$EventsCacheTableTableManager get eventsCache =>
      $$EventsCacheTableTableManager(_db, _db.eventsCache);
  $$EventQuestsTableTableManager get eventQuests =>
      $$EventQuestsTableTableManager(_db, _db.eventQuests);
  $$BuddyCacheTableTableManager get buddyCache =>
      $$BuddyCacheTableTableManager(_db, _db.buddyCache);
  $$GhostCacheTableTableManager get ghostCache =>
      $$GhostCacheTableTableManager(_db, _db.ghostCache);
  $$LeaderboardOptInTableTableManager get leaderboardOptIn =>
      $$LeaderboardOptInTableTableManager(_db, _db.leaderboardOptIn);
  $$ApiKeysTableTableManager get apiKeys =>
      $$ApiKeysTableTableManager(_db, _db.apiKeys);
  $$ProgressCardsTableTableManager get progressCards =>
      $$ProgressCardsTableTableManager(_db, _db.progressCards);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db, _db.searchHistory);
  $$AppConfigTableTableTableManager get appConfigTable =>
      $$AppConfigTableTableTableManager(_db, _db.appConfigTable);
  $$PinMetaTableTableManager get pinMeta =>
      $$PinMetaTableTableManager(_db, _db.pinMeta);
  $$AiUsageTableTableTableManager get aiUsageTable =>
      $$AiUsageTableTableTableManager(_db, _db.aiUsageTable);
  $$RateAppStateTableTableManager get rateAppState =>
      $$RateAppStateTableTableManager(_db, _db.rateAppState);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
}
