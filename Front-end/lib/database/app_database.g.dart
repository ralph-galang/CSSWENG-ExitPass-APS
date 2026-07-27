// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContinuityTransactionsTable extends ContinuityTransactions
    with TableInfo<$ContinuityTransactionsTable, ContinuityTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContinuityTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _operatorIdMeta =
      const VerificationMeta('operatorId');
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
      'operator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
      'site_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _laneMeta = const VerificationMeta('lane');
  @override
  late final GeneratedColumn<String> lane = GeneratedColumn<String>(
      'lane', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _amountMinorUnitsMeta =
      const VerificationMeta('amountMinorUnits');
  @override
  late final GeneratedColumn<int> amountMinorUnits = GeneratedColumn<int>(
      'amount_minor_units', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _evidenceReferenceMeta =
      const VerificationMeta('evidenceReference');
  @override
  late final GeneratedColumn<String> evidenceReference =
      GeneratedColumn<String>('evidence_reference', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      localSyncStatus = GeneratedColumn<String>(
              'local_sync_status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<LocalSyncStatus>(
              $ContinuityTransactionsTable.$converterlocalSyncStatus);
  static const VerificationMeta _backendLifecycleStatusMeta =
      const VerificationMeta('backendLifecycleStatus');
  @override
  late final GeneratedColumn<String> backendLifecycleStatus =
      GeneratedColumn<String>('backend_lifecycle_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backendReconciliationStatusMeta =
      const VerificationMeta('backendReconciliationStatus');
  @override
  late final GeneratedColumn<String> backendReconciliationStatus =
      GeneratedColumn<String>(
          'backend_reconciliation_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
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
        recordId,
        idempotencyKey,
        operatorId,
        deviceId,
        siteId,
        lane,
        occurredAt,
        amountMinorUnits,
        currencyCode,
        paymentMethod,
        evidenceReference,
        notes,
        localSyncStatus,
        backendLifecycleStatus,
        backendReconciliationStatus,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'continuity_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContinuityTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
          _operatorIdMeta,
          operatorId.isAcceptableOrUnknown(
              data['operator_id']!, _operatorIdMeta));
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('lane')) {
      context.handle(
          _laneMeta, lane.isAcceptableOrUnknown(data['lane']!, _laneMeta));
    } else if (isInserting) {
      context.missing(_laneMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    }
    if (data.containsKey('amount_minor_units')) {
      context.handle(
          _amountMinorUnitsMeta,
          amountMinorUnits.isAcceptableOrUnknown(
              data['amount_minor_units']!, _amountMinorUnitsMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('evidence_reference')) {
      context.handle(
          _evidenceReferenceMeta,
          evidenceReference.isAcceptableOrUnknown(
              data['evidence_reference']!, _evidenceReferenceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('backend_lifecycle_status')) {
      context.handle(
          _backendLifecycleStatusMeta,
          backendLifecycleStatus.isAcceptableOrUnknown(
              data['backend_lifecycle_status']!, _backendLifecycleStatusMeta));
    }
    if (data.containsKey('backend_reconciliation_status')) {
      context.handle(
          _backendReconciliationStatusMeta,
          backendReconciliationStatus.isAcceptableOrUnknown(
              data['backend_reconciliation_status']!,
              _backendReconciliationStatusMeta));
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
  ContinuityTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContinuityTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      operatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_id'])!,
      lane: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lane'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      amountMinorUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor_units']),
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      evidenceReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}evidence_reference']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      localSyncStatus: $ContinuityTransactionsTable.$converterlocalSyncStatus
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}local_sync_status'])!),
      backendLifecycleStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}backend_lifecycle_status']),
      backendReconciliationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}backend_reconciliation_status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ContinuityTransactionsTable createAlias(String alias) {
    return $ContinuityTransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalSyncStatus, String> $converterlocalSyncStatus =
      const LocalSyncStatusConverter();
}

class ContinuityTransaction extends DataClass
    implements Insertable<ContinuityTransaction> {
  final int id;

  /// App-generated UUID. What the backend keys off of, and what
  /// [Incidents.linkedTransactionId], [ExceptionTags.linkedTransactionId],
  /// [ManualGateLogs.linkedTransactionId], and
  /// [OverrideRequests.linkedTransactionId] softly point to.
  final String recordId;

  /// Sent to the backend to prevent duplicate submission of the same
  /// transaction on retry (Epic 6, Offline Sync and Retry: "prevent
  /// duplicate resubmission using idempotency key"). Also unique locally
  /// for the same reason as the idempotency keys on ManualGateLogs /
  /// OverrideRequests.
  final String idempotencyKey;
  final String operatorId;
  final String deviceId;
  final String siteId;
  final String lane;

  /// When the transaction actually happened, as distinct from
  /// [createdAt] (when the local row was written). The split matters
  /// here specifically because Epic 6 requires offline capture: a
  /// transaction can be performed while offline and only written/synced
  /// later once connectivity returns, so these two timestamps can
  /// legitimately diverge.
  final DateTime occurredAt;

  /// PLACEHOLDER payment fields — see the class-level doc comment above.
  /// Stored as minor units (e.g. cents) rather than a float to avoid
  /// rounding issues; nullable because the mock Payment Orchestrator
  /// interface's actual field shape hasn't been confirmed against this
  /// yet.
  final int? amountMinorUnits;
  final String? currencyCode;

  /// Free-text placeholder, not an enum — same reasoning as the other
  /// placeholder vocab in this project. Confirm against the mock Payment
  /// Orchestrator interface before locking this down.
  final String? paymentMethod;

  /// Reference/path to captured evidence. Epic 7 (Operational Evidence
  /// Capture) is its own not-yet-modeled epic/table; this column just
  /// reserves the slot the same way [Incidents.evidenceReference] does,
  /// so evidence has somewhere to point once that epic lands.
  final String? evidenceReference;
  final String? notes;

  /// Local upload/sync lifecycle. Always set and updated locally. See
  /// the class-level "three separate status concepts" note above.
  final LocalSyncStatus localSyncStatus;

  /// Backend-owned. Plain nullable string, not an enum, because the
  /// backend's MoPS lifecycle-state vocabulary isn't confirmed yet. This
  /// app should map local record state to this field for display only —
  /// never write an authoritative value here locally.
  final String? backendLifecycleStatus;

  /// Backend-owned reconciliation outcome, "displayed when available"
  /// (Epic 10). Deliberately a plain nullable string, NOT an enum, for
  /// the same reason as [Incidents.backendReconciliationStatus]: the BRD
  /// (Matched / Late Confirmation / Duplicate Callback Ignored / MoPS
  /// Exit / Dispute-Exception) and the approved backlog (Pending /
  /// Reconciled / Rejected / Disputed) currently disagree on what this
  /// vocabulary even is. Convert to a TypeConverter-backed enum once the
  /// client confirms which is authoritative — this app should never
  /// write to this column locally, only display whatever the backend
  /// returns.
  final String? backendReconciliationStatus;

  /// When the local row was created — see [occurredAt] above for why
  /// this is kept separate.
  final DateTime createdAt;
  const ContinuityTransaction(
      {required this.id,
      required this.recordId,
      required this.idempotencyKey,
      required this.operatorId,
      required this.deviceId,
      required this.siteId,
      required this.lane,
      required this.occurredAt,
      this.amountMinorUnits,
      this.currencyCode,
      this.paymentMethod,
      this.evidenceReference,
      this.notes,
      required this.localSyncStatus,
      this.backendLifecycleStatus,
      this.backendReconciliationStatus,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<String>(recordId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['operator_id'] = Variable<String>(operatorId);
    map['device_id'] = Variable<String>(deviceId);
    map['site_id'] = Variable<String>(siteId);
    map['lane'] = Variable<String>(lane);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || amountMinorUnits != null) {
      map['amount_minor_units'] = Variable<int>(amountMinorUnits);
    }
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || evidenceReference != null) {
      map['evidence_reference'] = Variable<String>(evidenceReference);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['local_sync_status'] = Variable<String>($ContinuityTransactionsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus));
    }
    if (!nullToAbsent || backendLifecycleStatus != null) {
      map['backend_lifecycle_status'] =
          Variable<String>(backendLifecycleStatus);
    }
    if (!nullToAbsent || backendReconciliationStatus != null) {
      map['backend_reconciliation_status'] =
          Variable<String>(backendReconciliationStatus);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ContinuityTransactionsCompanion toCompanion(bool nullToAbsent) {
    return ContinuityTransactionsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      idempotencyKey: Value(idempotencyKey),
      operatorId: Value(operatorId),
      deviceId: Value(deviceId),
      siteId: Value(siteId),
      lane: Value(lane),
      occurredAt: Value(occurredAt),
      amountMinorUnits: amountMinorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMinorUnits),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      evidenceReference: evidenceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceReference),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      localSyncStatus: Value(localSyncStatus),
      backendLifecycleStatus: backendLifecycleStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(backendLifecycleStatus),
      backendReconciliationStatus:
          backendReconciliationStatus == null && nullToAbsent
              ? const Value.absent()
              : Value(backendReconciliationStatus),
      createdAt: Value(createdAt),
    );
  }

  factory ContinuityTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContinuityTransaction(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      lane: serializer.fromJson<String>(json['lane']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      amountMinorUnits: serializer.fromJson<int?>(json['amountMinorUnits']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      evidenceReference:
          serializer.fromJson<String?>(json['evidenceReference']),
      notes: serializer.fromJson<String?>(json['notes']),
      localSyncStatus:
          serializer.fromJson<LocalSyncStatus>(json['localSyncStatus']),
      backendLifecycleStatus:
          serializer.fromJson<String?>(json['backendLifecycleStatus']),
      backendReconciliationStatus:
          serializer.fromJson<String?>(json['backendReconciliationStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<String>(recordId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'operatorId': serializer.toJson<String>(operatorId),
      'deviceId': serializer.toJson<String>(deviceId),
      'siteId': serializer.toJson<String>(siteId),
      'lane': serializer.toJson<String>(lane),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'amountMinorUnits': serializer.toJson<int?>(amountMinorUnits),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'evidenceReference': serializer.toJson<String?>(evidenceReference),
      'notes': serializer.toJson<String?>(notes),
      'localSyncStatus': serializer.toJson<LocalSyncStatus>(localSyncStatus),
      'backendLifecycleStatus':
          serializer.toJson<String?>(backendLifecycleStatus),
      'backendReconciliationStatus':
          serializer.toJson<String?>(backendReconciliationStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ContinuityTransaction copyWith(
          {int? id,
          String? recordId,
          String? idempotencyKey,
          String? operatorId,
          String? deviceId,
          String? siteId,
          String? lane,
          DateTime? occurredAt,
          Value<int?> amountMinorUnits = const Value.absent(),
          Value<String?> currencyCode = const Value.absent(),
          Value<String?> paymentMethod = const Value.absent(),
          Value<String?> evidenceReference = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          LocalSyncStatus? localSyncStatus,
          Value<String?> backendLifecycleStatus = const Value.absent(),
          Value<String?> backendReconciliationStatus = const Value.absent(),
          DateTime? createdAt}) =>
      ContinuityTransaction(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        operatorId: operatorId ?? this.operatorId,
        deviceId: deviceId ?? this.deviceId,
        siteId: siteId ?? this.siteId,
        lane: lane ?? this.lane,
        occurredAt: occurredAt ?? this.occurredAt,
        amountMinorUnits: amountMinorUnits.present
            ? amountMinorUnits.value
            : this.amountMinorUnits,
        currencyCode:
            currencyCode.present ? currencyCode.value : this.currencyCode,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        evidenceReference: evidenceReference.present
            ? evidenceReference.value
            : this.evidenceReference,
        notes: notes.present ? notes.value : this.notes,
        localSyncStatus: localSyncStatus ?? this.localSyncStatus,
        backendLifecycleStatus: backendLifecycleStatus.present
            ? backendLifecycleStatus.value
            : this.backendLifecycleStatus,
        backendReconciliationStatus: backendReconciliationStatus.present
            ? backendReconciliationStatus.value
            : this.backendReconciliationStatus,
        createdAt: createdAt ?? this.createdAt,
      );
  ContinuityTransaction copyWithCompanion(
      ContinuityTransactionsCompanion data) {
    return ContinuityTransaction(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      operatorId:
          data.operatorId.present ? data.operatorId.value : this.operatorId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      lane: data.lane.present ? data.lane.value : this.lane,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      amountMinorUnits: data.amountMinorUnits.present
          ? data.amountMinorUnits.value
          : this.amountMinorUnits,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      evidenceReference: data.evidenceReference.present
          ? data.evidenceReference.value
          : this.evidenceReference,
      notes: data.notes.present ? data.notes.value : this.notes,
      localSyncStatus: data.localSyncStatus.present
          ? data.localSyncStatus.value
          : this.localSyncStatus,
      backendLifecycleStatus: data.backendLifecycleStatus.present
          ? data.backendLifecycleStatus.value
          : this.backendLifecycleStatus,
      backendReconciliationStatus: data.backendReconciliationStatus.present
          ? data.backendReconciliationStatus.value
          : this.backendReconciliationStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContinuityTransaction(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('operatorId: $operatorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('lane: $lane, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('amountMinorUnits: $amountMinorUnits, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('evidenceReference: $evidenceReference, ')
          ..write('notes: $notes, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('backendLifecycleStatus: $backendLifecycleStatus, ')
          ..write('backendReconciliationStatus: $backendReconciliationStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      recordId,
      idempotencyKey,
      operatorId,
      deviceId,
      siteId,
      lane,
      occurredAt,
      amountMinorUnits,
      currencyCode,
      paymentMethod,
      evidenceReference,
      notes,
      localSyncStatus,
      backendLifecycleStatus,
      backendReconciliationStatus,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContinuityTransaction &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.operatorId == this.operatorId &&
          other.deviceId == this.deviceId &&
          other.siteId == this.siteId &&
          other.lane == this.lane &&
          other.occurredAt == this.occurredAt &&
          other.amountMinorUnits == this.amountMinorUnits &&
          other.currencyCode == this.currencyCode &&
          other.paymentMethod == this.paymentMethod &&
          other.evidenceReference == this.evidenceReference &&
          other.notes == this.notes &&
          other.localSyncStatus == this.localSyncStatus &&
          other.backendLifecycleStatus == this.backendLifecycleStatus &&
          other.backendReconciliationStatus ==
              this.backendReconciliationStatus &&
          other.createdAt == this.createdAt);
}

class ContinuityTransactionsCompanion
    extends UpdateCompanion<ContinuityTransaction> {
  final Value<int> id;
  final Value<String> recordId;
  final Value<String> idempotencyKey;
  final Value<String> operatorId;
  final Value<String> deviceId;
  final Value<String> siteId;
  final Value<String> lane;
  final Value<DateTime> occurredAt;
  final Value<int?> amountMinorUnits;
  final Value<String?> currencyCode;
  final Value<String?> paymentMethod;
  final Value<String?> evidenceReference;
  final Value<String?> notes;
  final Value<LocalSyncStatus> localSyncStatus;
  final Value<String?> backendLifecycleStatus;
  final Value<String?> backendReconciliationStatus;
  final Value<DateTime> createdAt;
  const ContinuityTransactionsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.lane = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.amountMinorUnits = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.evidenceReference = const Value.absent(),
    this.notes = const Value.absent(),
    this.localSyncStatus = const Value.absent(),
    this.backendLifecycleStatus = const Value.absent(),
    this.backendReconciliationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ContinuityTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String recordId,
    required String idempotencyKey,
    required String operatorId,
    required String deviceId,
    required String siteId,
    required String lane,
    this.occurredAt = const Value.absent(),
    this.amountMinorUnits = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.evidenceReference = const Value.absent(),
    this.notes = const Value.absent(),
    required LocalSyncStatus localSyncStatus,
    this.backendLifecycleStatus = const Value.absent(),
    this.backendReconciliationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : recordId = Value(recordId),
        idempotencyKey = Value(idempotencyKey),
        operatorId = Value(operatorId),
        deviceId = Value(deviceId),
        siteId = Value(siteId),
        lane = Value(lane),
        localSyncStatus = Value(localSyncStatus);
  static Insertable<ContinuityTransaction> custom({
    Expression<int>? id,
    Expression<String>? recordId,
    Expression<String>? idempotencyKey,
    Expression<String>? operatorId,
    Expression<String>? deviceId,
    Expression<String>? siteId,
    Expression<String>? lane,
    Expression<DateTime>? occurredAt,
    Expression<int>? amountMinorUnits,
    Expression<String>? currencyCode,
    Expression<String>? paymentMethod,
    Expression<String>? evidenceReference,
    Expression<String>? notes,
    Expression<String>? localSyncStatus,
    Expression<String>? backendLifecycleStatus,
    Expression<String>? backendReconciliationStatus,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (operatorId != null) 'operator_id': operatorId,
      if (deviceId != null) 'device_id': deviceId,
      if (siteId != null) 'site_id': siteId,
      if (lane != null) 'lane': lane,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (amountMinorUnits != null) 'amount_minor_units': amountMinorUnits,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (evidenceReference != null) 'evidence_reference': evidenceReference,
      if (notes != null) 'notes': notes,
      if (localSyncStatus != null) 'local_sync_status': localSyncStatus,
      if (backendLifecycleStatus != null)
        'backend_lifecycle_status': backendLifecycleStatus,
      if (backendReconciliationStatus != null)
        'backend_reconciliation_status': backendReconciliationStatus,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ContinuityTransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordId,
      Value<String>? idempotencyKey,
      Value<String>? operatorId,
      Value<String>? deviceId,
      Value<String>? siteId,
      Value<String>? lane,
      Value<DateTime>? occurredAt,
      Value<int?>? amountMinorUnits,
      Value<String?>? currencyCode,
      Value<String?>? paymentMethod,
      Value<String?>? evidenceReference,
      Value<String?>? notes,
      Value<LocalSyncStatus>? localSyncStatus,
      Value<String?>? backendLifecycleStatus,
      Value<String?>? backendReconciliationStatus,
      Value<DateTime>? createdAt}) {
    return ContinuityTransactionsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      operatorId: operatorId ?? this.operatorId,
      deviceId: deviceId ?? this.deviceId,
      siteId: siteId ?? this.siteId,
      lane: lane ?? this.lane,
      occurredAt: occurredAt ?? this.occurredAt,
      amountMinorUnits: amountMinorUnits ?? this.amountMinorUnits,
      currencyCode: currencyCode ?? this.currencyCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      evidenceReference: evidenceReference ?? this.evidenceReference,
      notes: notes ?? this.notes,
      localSyncStatus: localSyncStatus ?? this.localSyncStatus,
      backendLifecycleStatus:
          backendLifecycleStatus ?? this.backendLifecycleStatus,
      backendReconciliationStatus:
          backendReconciliationStatus ?? this.backendReconciliationStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (lane.present) {
      map['lane'] = Variable<String>(lane.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (amountMinorUnits.present) {
      map['amount_minor_units'] = Variable<int>(amountMinorUnits.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (evidenceReference.present) {
      map['evidence_reference'] = Variable<String>(evidenceReference.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (localSyncStatus.present) {
      map['local_sync_status'] = Variable<String>($ContinuityTransactionsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus.value));
    }
    if (backendLifecycleStatus.present) {
      map['backend_lifecycle_status'] =
          Variable<String>(backendLifecycleStatus.value);
    }
    if (backendReconciliationStatus.present) {
      map['backend_reconciliation_status'] =
          Variable<String>(backendReconciliationStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContinuityTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('operatorId: $operatorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('lane: $lane, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('amountMinorUnits: $amountMinorUnits, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('evidenceReference: $evidenceReference, ')
          ..write('notes: $notes, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('backendLifecycleStatus: $backendLifecycleStatus, ')
          ..write('backendReconciliationStatus: $backendReconciliationStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $IncidentsTable extends Incidents
    with TableInfo<$IncidentsTable, Incident> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumnWithTypeConverter<IncidentCategory, String>
      category = GeneratedColumn<String>('category', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<IncidentCategory>($IncidentsTable.$convertercategory);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
      'site_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operatorIdMeta =
      const VerificationMeta('operatorId');
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
      'operator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>('linked_transaction_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES continuity_transactions (record_id)'));
  static const VerificationMeta _evidenceReferenceMeta =
      const VerificationMeta('evidenceReference');
  @override
  late final GeneratedColumn<String> evidenceReference =
      GeneratedColumn<String>('evidence_reference', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      localSyncStatus = GeneratedColumn<String>(
              'local_sync_status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<LocalSyncStatus>(
              $IncidentsTable.$converterlocalSyncStatus);
  static const VerificationMeta _backendReconciliationStatusMeta =
      const VerificationMeta('backendReconciliationStatus');
  @override
  late final GeneratedColumn<String> backendReconciliationStatus =
      GeneratedColumn<String>(
          'backend_reconciliation_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
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
        recordId,
        category,
        deviceId,
        siteId,
        operatorId,
        occurredAt,
        linkedTransactionId,
        evidenceReference,
        notes,
        localSyncStatus,
        backendReconciliationStatus,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incidents';
  @override
  VerificationContext validateIntegrity(Insertable<Incident> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
          _operatorIdMeta,
          operatorId.isAcceptableOrUnknown(
              data['operator_id']!, _operatorIdMeta));
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
          _linkedTransactionIdMeta,
          linkedTransactionId.isAcceptableOrUnknown(
              data['linked_transaction_id']!, _linkedTransactionIdMeta));
    }
    if (data.containsKey('evidence_reference')) {
      context.handle(
          _evidenceReferenceMeta,
          evidenceReference.isAcceptableOrUnknown(
              data['evidence_reference']!, _evidenceReferenceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('backend_reconciliation_status')) {
      context.handle(
          _backendReconciliationStatusMeta,
          backendReconciliationStatus.isAcceptableOrUnknown(
              data['backend_reconciliation_status']!,
              _backendReconciliationStatusMeta));
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
  Incident map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Incident(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      category: $IncidentsTable.$convertercategory.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_id'])!,
      operatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator_id'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      linkedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_transaction_id']),
      evidenceReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}evidence_reference']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      localSyncStatus: $IncidentsTable.$converterlocalSyncStatus.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}local_sync_status'])!),
      backendReconciliationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}backend_reconciliation_status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $IncidentsTable createAlias(String alias) {
    return $IncidentsTable(attachedDatabase, alias);
  }

  static TypeConverter<IncidentCategory, String> $convertercategory =
      const IncidentCategoryConverter();
  static TypeConverter<LocalSyncStatus, String> $converterlocalSyncStatus =
      const LocalSyncStatusConverter();
}

class Incident extends DataClass implements Insertable<Incident> {
  final int id;

  /// App-generated UUID. This is what's sent to the backend and what
  /// "incident history is viewable after submission" keys off of.
  final String recordId;
  final IncidentCategory category;
  final String deviceId;
  final String siteId;

  /// Not explicitly listed in Epic 8's acceptance criteria text, but kept
  /// for consistency with the rest of the continuity-record audit trail
  /// (every other table here captures operator identity). Drop it if the
  /// client's eventual schema handles operator attribution elsewhere.
  final String operatorId;
  final DateTime occurredAt;

  /// Real FK to [ContinuityTransactions.recordId], now that a placeholder
  /// transactions table exists. Stays nullable: an incident can happen
  /// with no transaction in play (e.g. a network outage logged before
  /// any continuity transaction was ever captured) — independent of a
  /// transaction, per Epic 8's design, unlike [ExceptionTags] below.
  final String? linkedTransactionId;

  /// Reference/path to captured evidence (e.g. a photo). Evidence capture
  /// itself is a separate backlog item (Operational Evidence Capture) —
  /// this column just reserves the slot so "evidence is captured" has
  /// somewhere to point once that item exists.
  final String? evidenceReference;
  final String? notes;

  /// Local upload/sync lifecycle. Always set and updated locally.
  final LocalSyncStatus localSyncStatus;

  /// Backend-owned reconciliation status, "displayed when available."
  ///
  /// Deliberately a plain nullable string, NOT an enum. The BRD (Matched /
  /// Late Confirmation / Duplicate Callback Ignored / MoPS Exit /
  /// Dispute-Exception) and the approved backlog (Pending / Reconciled /
  /// Rejected / Disputed) currently disagree on what this vocabulary even
  /// is. Locking in an enum now means a migration the moment that's
  /// resolved. Convert to a TypeConverter-backed enum once the client
  /// confirms which vocabulary is authoritative — this app should never
  /// write to this column locally, only display whatever the backend
  /// returns.
  final String? backendReconciliationStatus;
  final DateTime createdAt;
  const Incident(
      {required this.id,
      required this.recordId,
      required this.category,
      required this.deviceId,
      required this.siteId,
      required this.operatorId,
      required this.occurredAt,
      this.linkedTransactionId,
      this.evidenceReference,
      this.notes,
      required this.localSyncStatus,
      this.backendReconciliationStatus,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<String>(recordId);
    {
      map['category'] =
          Variable<String>($IncidentsTable.$convertercategory.toSql(category));
    }
    map['device_id'] = Variable<String>(deviceId);
    map['site_id'] = Variable<String>(siteId);
    map['operator_id'] = Variable<String>(operatorId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    }
    if (!nullToAbsent || evidenceReference != null) {
      map['evidence_reference'] = Variable<String>(evidenceReference);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['local_sync_status'] = Variable<String>(
          $IncidentsTable.$converterlocalSyncStatus.toSql(localSyncStatus));
    }
    if (!nullToAbsent || backendReconciliationStatus != null) {
      map['backend_reconciliation_status'] =
          Variable<String>(backendReconciliationStatus);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IncidentsCompanion toCompanion(bool nullToAbsent) {
    return IncidentsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      category: Value(category),
      deviceId: Value(deviceId),
      siteId: Value(siteId),
      operatorId: Value(operatorId),
      occurredAt: Value(occurredAt),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      evidenceReference: evidenceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceReference),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      localSyncStatus: Value(localSyncStatus),
      backendReconciliationStatus:
          backendReconciliationStatus == null && nullToAbsent
              ? const Value.absent()
              : Value(backendReconciliationStatus),
      createdAt: Value(createdAt),
    );
  }

  factory Incident.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Incident(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      category: serializer.fromJson<IncidentCategory>(json['category']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      linkedTransactionId:
          serializer.fromJson<String?>(json['linkedTransactionId']),
      evidenceReference:
          serializer.fromJson<String?>(json['evidenceReference']),
      notes: serializer.fromJson<String?>(json['notes']),
      localSyncStatus:
          serializer.fromJson<LocalSyncStatus>(json['localSyncStatus']),
      backendReconciliationStatus:
          serializer.fromJson<String?>(json['backendReconciliationStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<String>(recordId),
      'category': serializer.toJson<IncidentCategory>(category),
      'deviceId': serializer.toJson<String>(deviceId),
      'siteId': serializer.toJson<String>(siteId),
      'operatorId': serializer.toJson<String>(operatorId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'linkedTransactionId': serializer.toJson<String?>(linkedTransactionId),
      'evidenceReference': serializer.toJson<String?>(evidenceReference),
      'notes': serializer.toJson<String?>(notes),
      'localSyncStatus': serializer.toJson<LocalSyncStatus>(localSyncStatus),
      'backendReconciliationStatus':
          serializer.toJson<String?>(backendReconciliationStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Incident copyWith(
          {int? id,
          String? recordId,
          IncidentCategory? category,
          String? deviceId,
          String? siteId,
          String? operatorId,
          DateTime? occurredAt,
          Value<String?> linkedTransactionId = const Value.absent(),
          Value<String?> evidenceReference = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          LocalSyncStatus? localSyncStatus,
          Value<String?> backendReconciliationStatus = const Value.absent(),
          DateTime? createdAt}) =>
      Incident(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        category: category ?? this.category,
        deviceId: deviceId ?? this.deviceId,
        siteId: siteId ?? this.siteId,
        operatorId: operatorId ?? this.operatorId,
        occurredAt: occurredAt ?? this.occurredAt,
        linkedTransactionId: linkedTransactionId.present
            ? linkedTransactionId.value
            : this.linkedTransactionId,
        evidenceReference: evidenceReference.present
            ? evidenceReference.value
            : this.evidenceReference,
        notes: notes.present ? notes.value : this.notes,
        localSyncStatus: localSyncStatus ?? this.localSyncStatus,
        backendReconciliationStatus: backendReconciliationStatus.present
            ? backendReconciliationStatus.value
            : this.backendReconciliationStatus,
        createdAt: createdAt ?? this.createdAt,
      );
  Incident copyWithCompanion(IncidentsCompanion data) {
    return Incident(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      category: data.category.present ? data.category.value : this.category,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      operatorId:
          data.operatorId.present ? data.operatorId.value : this.operatorId,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      evidenceReference: data.evidenceReference.present
          ? data.evidenceReference.value
          : this.evidenceReference,
      notes: data.notes.present ? data.notes.value : this.notes,
      localSyncStatus: data.localSyncStatus.present
          ? data.localSyncStatus.value
          : this.localSyncStatus,
      backendReconciliationStatus: data.backendReconciliationStatus.present
          ? data.backendReconciliationStatus.value
          : this.backendReconciliationStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Incident(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('category: $category, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('operatorId: $operatorId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('evidenceReference: $evidenceReference, ')
          ..write('notes: $notes, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('backendReconciliationStatus: $backendReconciliationStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      recordId,
      category,
      deviceId,
      siteId,
      operatorId,
      occurredAt,
      linkedTransactionId,
      evidenceReference,
      notes,
      localSyncStatus,
      backendReconciliationStatus,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Incident &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.category == this.category &&
          other.deviceId == this.deviceId &&
          other.siteId == this.siteId &&
          other.operatorId == this.operatorId &&
          other.occurredAt == this.occurredAt &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.evidenceReference == this.evidenceReference &&
          other.notes == this.notes &&
          other.localSyncStatus == this.localSyncStatus &&
          other.backendReconciliationStatus ==
              this.backendReconciliationStatus &&
          other.createdAt == this.createdAt);
}

class IncidentsCompanion extends UpdateCompanion<Incident> {
  final Value<int> id;
  final Value<String> recordId;
  final Value<IncidentCategory> category;
  final Value<String> deviceId;
  final Value<String> siteId;
  final Value<String> operatorId;
  final Value<DateTime> occurredAt;
  final Value<String?> linkedTransactionId;
  final Value<String?> evidenceReference;
  final Value<String?> notes;
  final Value<LocalSyncStatus> localSyncStatus;
  final Value<String?> backendReconciliationStatus;
  final Value<DateTime> createdAt;
  const IncidentsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.category = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.evidenceReference = const Value.absent(),
    this.notes = const Value.absent(),
    this.localSyncStatus = const Value.absent(),
    this.backendReconciliationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IncidentsCompanion.insert({
    this.id = const Value.absent(),
    required String recordId,
    required IncidentCategory category,
    required String deviceId,
    required String siteId,
    required String operatorId,
    this.occurredAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.evidenceReference = const Value.absent(),
    this.notes = const Value.absent(),
    required LocalSyncStatus localSyncStatus,
    this.backendReconciliationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : recordId = Value(recordId),
        category = Value(category),
        deviceId = Value(deviceId),
        siteId = Value(siteId),
        operatorId = Value(operatorId),
        localSyncStatus = Value(localSyncStatus);
  static Insertable<Incident> custom({
    Expression<int>? id,
    Expression<String>? recordId,
    Expression<String>? category,
    Expression<String>? deviceId,
    Expression<String>? siteId,
    Expression<String>? operatorId,
    Expression<DateTime>? occurredAt,
    Expression<String>? linkedTransactionId,
    Expression<String>? evidenceReference,
    Expression<String>? notes,
    Expression<String>? localSyncStatus,
    Expression<String>? backendReconciliationStatus,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (category != null) 'category': category,
      if (deviceId != null) 'device_id': deviceId,
      if (siteId != null) 'site_id': siteId,
      if (operatorId != null) 'operator_id': operatorId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (evidenceReference != null) 'evidence_reference': evidenceReference,
      if (notes != null) 'notes': notes,
      if (localSyncStatus != null) 'local_sync_status': localSyncStatus,
      if (backendReconciliationStatus != null)
        'backend_reconciliation_status': backendReconciliationStatus,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IncidentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordId,
      Value<IncidentCategory>? category,
      Value<String>? deviceId,
      Value<String>? siteId,
      Value<String>? operatorId,
      Value<DateTime>? occurredAt,
      Value<String?>? linkedTransactionId,
      Value<String?>? evidenceReference,
      Value<String?>? notes,
      Value<LocalSyncStatus>? localSyncStatus,
      Value<String?>? backendReconciliationStatus,
      Value<DateTime>? createdAt}) {
    return IncidentsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      category: category ?? this.category,
      deviceId: deviceId ?? this.deviceId,
      siteId: siteId ?? this.siteId,
      operatorId: operatorId ?? this.operatorId,
      occurredAt: occurredAt ?? this.occurredAt,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      evidenceReference: evidenceReference ?? this.evidenceReference,
      notes: notes ?? this.notes,
      localSyncStatus: localSyncStatus ?? this.localSyncStatus,
      backendReconciliationStatus:
          backendReconciliationStatus ?? this.backendReconciliationStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
          $IncidentsTable.$convertercategory.toSql(category.value));
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] =
          Variable<String>(linkedTransactionId.value);
    }
    if (evidenceReference.present) {
      map['evidence_reference'] = Variable<String>(evidenceReference.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (localSyncStatus.present) {
      map['local_sync_status'] = Variable<String>($IncidentsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus.value));
    }
    if (backendReconciliationStatus.present) {
      map['backend_reconciliation_status'] =
          Variable<String>(backendReconciliationStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('category: $category, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('operatorId: $operatorId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('evidenceReference: $evidenceReference, ')
          ..write('notes: $notes, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('backendReconciliationStatus: $backendReconciliationStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExceptionTagsTable extends ExceptionTags
    with TableInfo<$ExceptionTagsTable, ExceptionTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExceptionTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>('linked_transaction_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES continuity_transactions (record_id)'));
  @override
  late final GeneratedColumnWithTypeConverter<ExceptionReasonCode, String>
      reasonCode = GeneratedColumn<String>('reason_code', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ExceptionReasonCode>(
              $ExceptionTagsTable.$converterreasonCode);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
      'site_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operatorIdMeta =
      const VerificationMeta('operatorId');
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
      'operator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taggedAtMeta =
      const VerificationMeta('taggedAt');
  @override
  late final GeneratedColumn<DateTime> taggedAt = GeneratedColumn<DateTime>(
      'tagged_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      localSyncStatus = GeneratedColumn<String>(
              'local_sync_status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<LocalSyncStatus>(
              $ExceptionTagsTable.$converterlocalSyncStatus);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recordId,
        linkedTransactionId,
        reasonCode,
        deviceId,
        siteId,
        operatorId,
        taggedAt,
        localSyncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exception_tags';
  @override
  VerificationContext validateIntegrity(Insertable<ExceptionTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
          _linkedTransactionIdMeta,
          linkedTransactionId.isAcceptableOrUnknown(
              data['linked_transaction_id']!, _linkedTransactionIdMeta));
    } else if (isInserting) {
      context.missing(_linkedTransactionIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
          _operatorIdMeta,
          operatorId.isAcceptableOrUnknown(
              data['operator_id']!, _operatorIdMeta));
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('tagged_at')) {
      context.handle(_taggedAtMeta,
          taggedAt.isAcceptableOrUnknown(data['tagged_at']!, _taggedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExceptionTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExceptionTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      linkedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}linked_transaction_id'])!,
      reasonCode: $ExceptionTagsTable.$converterreasonCode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}reason_code'])!),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_id'])!,
      operatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator_id'])!,
      taggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tagged_at'])!,
      localSyncStatus: $ExceptionTagsTable.$converterlocalSyncStatus.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}local_sync_status'])!),
    );
  }

  @override
  $ExceptionTagsTable createAlias(String alias) {
    return $ExceptionTagsTable(attachedDatabase, alias);
  }

  static TypeConverter<ExceptionReasonCode, String> $converterreasonCode =
      const ExceptionReasonCodeConverter();
  static TypeConverter<LocalSyncStatus, String> $converterlocalSyncStatus =
      const LocalSyncStatusConverter();
}

class ExceptionTag extends DataClass implements Insertable<ExceptionTag> {
  final int id;
  final String recordId;

  /// Real, required FK to [ContinuityTransactions.recordId] — NOT
  /// nullable, unlike [Incidents.linkedTransactionId] and
  /// [ManualGateLogs.linkedTransactionId]. An exception tag only ever
  /// exists to classify a specific transaction; it has no standalone
  /// meaning without one, so (unlike the other two) it cannot be
  /// independent of a transaction.
  final String linkedTransactionId;
  final ExceptionReasonCode reasonCode;
  final String deviceId;
  final String siteId;
  final String operatorId;
  final DateTime taggedAt;
  final LocalSyncStatus localSyncStatus;
  const ExceptionTag(
      {required this.id,
      required this.recordId,
      required this.linkedTransactionId,
      required this.reasonCode,
      required this.deviceId,
      required this.siteId,
      required this.operatorId,
      required this.taggedAt,
      required this.localSyncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<String>(recordId);
    map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    {
      map['reason_code'] = Variable<String>(
          $ExceptionTagsTable.$converterreasonCode.toSql(reasonCode));
    }
    map['device_id'] = Variable<String>(deviceId);
    map['site_id'] = Variable<String>(siteId);
    map['operator_id'] = Variable<String>(operatorId);
    map['tagged_at'] = Variable<DateTime>(taggedAt);
    {
      map['local_sync_status'] = Variable<String>(
          $ExceptionTagsTable.$converterlocalSyncStatus.toSql(localSyncStatus));
    }
    return map;
  }

  ExceptionTagsCompanion toCompanion(bool nullToAbsent) {
    return ExceptionTagsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      linkedTransactionId: Value(linkedTransactionId),
      reasonCode: Value(reasonCode),
      deviceId: Value(deviceId),
      siteId: Value(siteId),
      operatorId: Value(operatorId),
      taggedAt: Value(taggedAt),
      localSyncStatus: Value(localSyncStatus),
    );
  }

  factory ExceptionTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExceptionTag(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      linkedTransactionId:
          serializer.fromJson<String>(json['linkedTransactionId']),
      reasonCode: serializer.fromJson<ExceptionReasonCode>(json['reasonCode']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      taggedAt: serializer.fromJson<DateTime>(json['taggedAt']),
      localSyncStatus:
          serializer.fromJson<LocalSyncStatus>(json['localSyncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<String>(recordId),
      'linkedTransactionId': serializer.toJson<String>(linkedTransactionId),
      'reasonCode': serializer.toJson<ExceptionReasonCode>(reasonCode),
      'deviceId': serializer.toJson<String>(deviceId),
      'siteId': serializer.toJson<String>(siteId),
      'operatorId': serializer.toJson<String>(operatorId),
      'taggedAt': serializer.toJson<DateTime>(taggedAt),
      'localSyncStatus': serializer.toJson<LocalSyncStatus>(localSyncStatus),
    };
  }

  ExceptionTag copyWith(
          {int? id,
          String? recordId,
          String? linkedTransactionId,
          ExceptionReasonCode? reasonCode,
          String? deviceId,
          String? siteId,
          String? operatorId,
          DateTime? taggedAt,
          LocalSyncStatus? localSyncStatus}) =>
      ExceptionTag(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
        reasonCode: reasonCode ?? this.reasonCode,
        deviceId: deviceId ?? this.deviceId,
        siteId: siteId ?? this.siteId,
        operatorId: operatorId ?? this.operatorId,
        taggedAt: taggedAt ?? this.taggedAt,
        localSyncStatus: localSyncStatus ?? this.localSyncStatus,
      );
  ExceptionTag copyWithCompanion(ExceptionTagsCompanion data) {
    return ExceptionTag(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      reasonCode:
          data.reasonCode.present ? data.reasonCode.value : this.reasonCode,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      operatorId:
          data.operatorId.present ? data.operatorId.value : this.operatorId,
      taggedAt: data.taggedAt.present ? data.taggedAt.value : this.taggedAt,
      localSyncStatus: data.localSyncStatus.present
          ? data.localSyncStatus.value
          : this.localSyncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExceptionTag(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('operatorId: $operatorId, ')
          ..write('taggedAt: $taggedAt, ')
          ..write('localSyncStatus: $localSyncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordId, linkedTransactionId, reasonCode,
      deviceId, siteId, operatorId, taggedAt, localSyncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExceptionTag &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.reasonCode == this.reasonCode &&
          other.deviceId == this.deviceId &&
          other.siteId == this.siteId &&
          other.operatorId == this.operatorId &&
          other.taggedAt == this.taggedAt &&
          other.localSyncStatus == this.localSyncStatus);
}

class ExceptionTagsCompanion extends UpdateCompanion<ExceptionTag> {
  final Value<int> id;
  final Value<String> recordId;
  final Value<String> linkedTransactionId;
  final Value<ExceptionReasonCode> reasonCode;
  final Value<String> deviceId;
  final Value<String> siteId;
  final Value<String> operatorId;
  final Value<DateTime> taggedAt;
  final Value<LocalSyncStatus> localSyncStatus;
  const ExceptionTagsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.taggedAt = const Value.absent(),
    this.localSyncStatus = const Value.absent(),
  });
  ExceptionTagsCompanion.insert({
    this.id = const Value.absent(),
    required String recordId,
    required String linkedTransactionId,
    required ExceptionReasonCode reasonCode,
    required String deviceId,
    required String siteId,
    required String operatorId,
    this.taggedAt = const Value.absent(),
    required LocalSyncStatus localSyncStatus,
  })  : recordId = Value(recordId),
        linkedTransactionId = Value(linkedTransactionId),
        reasonCode = Value(reasonCode),
        deviceId = Value(deviceId),
        siteId = Value(siteId),
        operatorId = Value(operatorId),
        localSyncStatus = Value(localSyncStatus);
  static Insertable<ExceptionTag> custom({
    Expression<int>? id,
    Expression<String>? recordId,
    Expression<String>? linkedTransactionId,
    Expression<String>? reasonCode,
    Expression<String>? deviceId,
    Expression<String>? siteId,
    Expression<String>? operatorId,
    Expression<DateTime>? taggedAt,
    Expression<String>? localSyncStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (deviceId != null) 'device_id': deviceId,
      if (siteId != null) 'site_id': siteId,
      if (operatorId != null) 'operator_id': operatorId,
      if (taggedAt != null) 'tagged_at': taggedAt,
      if (localSyncStatus != null) 'local_sync_status': localSyncStatus,
    });
  }

  ExceptionTagsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordId,
      Value<String>? linkedTransactionId,
      Value<ExceptionReasonCode>? reasonCode,
      Value<String>? deviceId,
      Value<String>? siteId,
      Value<String>? operatorId,
      Value<DateTime>? taggedAt,
      Value<LocalSyncStatus>? localSyncStatus}) {
    return ExceptionTagsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      reasonCode: reasonCode ?? this.reasonCode,
      deviceId: deviceId ?? this.deviceId,
      siteId: siteId ?? this.siteId,
      operatorId: operatorId ?? this.operatorId,
      taggedAt: taggedAt ?? this.taggedAt,
      localSyncStatus: localSyncStatus ?? this.localSyncStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] =
          Variable<String>(linkedTransactionId.value);
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(
          $ExceptionTagsTable.$converterreasonCode.toSql(reasonCode.value));
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (taggedAt.present) {
      map['tagged_at'] = Variable<DateTime>(taggedAt.value);
    }
    if (localSyncStatus.present) {
      map['local_sync_status'] = Variable<String>($ExceptionTagsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExceptionTagsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('operatorId: $operatorId, ')
          ..write('taggedAt: $taggedAt, ')
          ..write('localSyncStatus: $localSyncStatus')
          ..write(')'))
        .toString();
  }
}

class $ManualGateLogsTable extends ManualGateLogs
    with TableInfo<$ManualGateLogsTable, ManualGateLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManualGateLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _justificationTextMeta =
      const VerificationMeta('justificationText');
  @override
  late final GeneratedColumn<String> justificationText =
      GeneratedColumn<String>('justification_text', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<ManualActionReasonCode?, String>
      reasonCode = GeneratedColumn<String>('reason_code', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<ManualActionReasonCode?>(
              $ManualGateLogsTable.$converterreasonCode);
  static const VerificationMeta _operatorIdMeta =
      const VerificationMeta('operatorId');
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
      'operator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
      'site_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _laneMeta = const VerificationMeta('lane');
  @override
  late final GeneratedColumn<String> lane = GeneratedColumn<String>(
      'lane', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>('linked_transaction_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES continuity_transactions (record_id)'));
  static const VerificationMeta _linkedIncidentIdMeta =
      const VerificationMeta('linkedIncidentId');
  @override
  late final GeneratedColumn<String> linkedIncidentId = GeneratedColumn<String>(
      'linked_incident_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedSessionIdMeta =
      const VerificationMeta('linkedSessionId');
  @override
  late final GeneratedColumn<String> linkedSessionId = GeneratedColumn<String>(
      'linked_session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      localSyncStatus = GeneratedColumn<String>(
              'local_sync_status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<LocalSyncStatus>(
              $ManualGateLogsTable.$converterlocalSyncStatus);
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
        recordId,
        idempotencyKey,
        justificationText,
        reasonCode,
        operatorId,
        deviceId,
        siteId,
        lane,
        performedAt,
        linkedTransactionId,
        linkedIncidentId,
        linkedSessionId,
        localSyncStatus,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manual_gate_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ManualGateLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('justification_text')) {
      context.handle(
          _justificationTextMeta,
          justificationText.isAcceptableOrUnknown(
              data['justification_text']!, _justificationTextMeta));
    } else if (isInserting) {
      context.missing(_justificationTextMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
          _operatorIdMeta,
          operatorId.isAcceptableOrUnknown(
              data['operator_id']!, _operatorIdMeta));
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('lane')) {
      context.handle(
          _laneMeta, lane.isAcceptableOrUnknown(data['lane']!, _laneMeta));
    } else if (isInserting) {
      context.missing(_laneMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
          _linkedTransactionIdMeta,
          linkedTransactionId.isAcceptableOrUnknown(
              data['linked_transaction_id']!, _linkedTransactionIdMeta));
    }
    if (data.containsKey('linked_incident_id')) {
      context.handle(
          _linkedIncidentIdMeta,
          linkedIncidentId.isAcceptableOrUnknown(
              data['linked_incident_id']!, _linkedIncidentIdMeta));
    }
    if (data.containsKey('linked_session_id')) {
      context.handle(
          _linkedSessionIdMeta,
          linkedSessionId.isAcceptableOrUnknown(
              data['linked_session_id']!, _linkedSessionIdMeta));
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
  ManualGateLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManualGateLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      justificationText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}justification_text'])!,
      reasonCode: $ManualGateLogsTable.$converterreasonCode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}reason_code'])),
      operatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_id'])!,
      lane: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lane'])!,
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
      linkedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_transaction_id']),
      linkedIncidentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_incident_id']),
      linkedSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_session_id']),
      localSyncStatus: $ManualGateLogsTable.$converterlocalSyncStatus.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}local_sync_status'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ManualGateLogsTable createAlias(String alias) {
    return $ManualGateLogsTable(attachedDatabase, alias);
  }

  static TypeConverter<ManualActionReasonCode?, String?> $converterreasonCode =
      const NullAwareTypeConverter.wrap(ManualActionReasonCodeConverter());
  static TypeConverter<LocalSyncStatus, String> $converterlocalSyncStatus =
      const LocalSyncStatusConverter();
}

class ManualGateLog extends DataClass implements Insertable<ManualGateLog> {
  final int id;
  final String recordId;

  /// Sent to the backend to prevent duplicate submission of the same
  /// manual action (e.g. on retry after a dropped connection). Also
  /// enforced as unique locally so a retry can't even create a second
  /// local row in the first place.
  final String idempotencyKey;

  /// The backlog task phrasing is "require justification text OR reason
  /// code" — read as either/or. This schema requires free-text
  /// justification always, since it's guaranteed usable before the
  /// client's controlled vocabulary is confirmed, and treats reasonCode
  /// as an optional structured tag layered on top. Make reasonCode
  /// required instead, if the client wants it mandatory once confirmed.
  final String justificationText;
  final ManualActionReasonCode? reasonCode;
  final String operatorId;
  final String deviceId;
  final String siteId;
  final String lane;
  final DateTime performedAt;

  /// [linkedTransactionId] is now a real FK to
  /// [ContinuityTransactions.recordId], since that table exists.
  /// [linkedIncidentId] and [linkedSessionId] remain soft references:
  /// the parking-session schema still isn't settled, and linkedIncidentId
  /// is left as plain text for now rather than a second real FK added in
  /// the same pass — revisit if that's also wanted. All three stay
  /// nullable: a manual gate action can happen with no transaction yet
  /// in play (e.g. a dispute resolved before payment capture) —
  /// independent of a transaction, same as [Incidents], and unlike
  /// [ExceptionTags].
  final String? linkedTransactionId;
  final String? linkedIncidentId;
  final String? linkedSessionId;
  final LocalSyncStatus localSyncStatus;
  final DateTime createdAt;
  const ManualGateLog(
      {required this.id,
      required this.recordId,
      required this.idempotencyKey,
      required this.justificationText,
      this.reasonCode,
      required this.operatorId,
      required this.deviceId,
      required this.siteId,
      required this.lane,
      required this.performedAt,
      this.linkedTransactionId,
      this.linkedIncidentId,
      this.linkedSessionId,
      required this.localSyncStatus,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<String>(recordId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['justification_text'] = Variable<String>(justificationText);
    if (!nullToAbsent || reasonCode != null) {
      map['reason_code'] = Variable<String>(
          $ManualGateLogsTable.$converterreasonCode.toSql(reasonCode));
    }
    map['operator_id'] = Variable<String>(operatorId);
    map['device_id'] = Variable<String>(deviceId);
    map['site_id'] = Variable<String>(siteId);
    map['lane'] = Variable<String>(lane);
    map['performed_at'] = Variable<DateTime>(performedAt);
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    }
    if (!nullToAbsent || linkedIncidentId != null) {
      map['linked_incident_id'] = Variable<String>(linkedIncidentId);
    }
    if (!nullToAbsent || linkedSessionId != null) {
      map['linked_session_id'] = Variable<String>(linkedSessionId);
    }
    {
      map['local_sync_status'] = Variable<String>($ManualGateLogsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ManualGateLogsCompanion toCompanion(bool nullToAbsent) {
    return ManualGateLogsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      idempotencyKey: Value(idempotencyKey),
      justificationText: Value(justificationText),
      reasonCode: reasonCode == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonCode),
      operatorId: Value(operatorId),
      deviceId: Value(deviceId),
      siteId: Value(siteId),
      lane: Value(lane),
      performedAt: Value(performedAt),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      linkedIncidentId: linkedIncidentId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedIncidentId),
      linkedSessionId: linkedSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedSessionId),
      localSyncStatus: Value(localSyncStatus),
      createdAt: Value(createdAt),
    );
  }

  factory ManualGateLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManualGateLog(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      justificationText: serializer.fromJson<String>(json['justificationText']),
      reasonCode:
          serializer.fromJson<ManualActionReasonCode?>(json['reasonCode']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      lane: serializer.fromJson<String>(json['lane']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      linkedTransactionId:
          serializer.fromJson<String?>(json['linkedTransactionId']),
      linkedIncidentId: serializer.fromJson<String?>(json['linkedIncidentId']),
      linkedSessionId: serializer.fromJson<String?>(json['linkedSessionId']),
      localSyncStatus:
          serializer.fromJson<LocalSyncStatus>(json['localSyncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<String>(recordId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'justificationText': serializer.toJson<String>(justificationText),
      'reasonCode': serializer.toJson<ManualActionReasonCode?>(reasonCode),
      'operatorId': serializer.toJson<String>(operatorId),
      'deviceId': serializer.toJson<String>(deviceId),
      'siteId': serializer.toJson<String>(siteId),
      'lane': serializer.toJson<String>(lane),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'linkedTransactionId': serializer.toJson<String?>(linkedTransactionId),
      'linkedIncidentId': serializer.toJson<String?>(linkedIncidentId),
      'linkedSessionId': serializer.toJson<String?>(linkedSessionId),
      'localSyncStatus': serializer.toJson<LocalSyncStatus>(localSyncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ManualGateLog copyWith(
          {int? id,
          String? recordId,
          String? idempotencyKey,
          String? justificationText,
          Value<ManualActionReasonCode?> reasonCode = const Value.absent(),
          String? operatorId,
          String? deviceId,
          String? siteId,
          String? lane,
          DateTime? performedAt,
          Value<String?> linkedTransactionId = const Value.absent(),
          Value<String?> linkedIncidentId = const Value.absent(),
          Value<String?> linkedSessionId = const Value.absent(),
          LocalSyncStatus? localSyncStatus,
          DateTime? createdAt}) =>
      ManualGateLog(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        justificationText: justificationText ?? this.justificationText,
        reasonCode: reasonCode.present ? reasonCode.value : this.reasonCode,
        operatorId: operatorId ?? this.operatorId,
        deviceId: deviceId ?? this.deviceId,
        siteId: siteId ?? this.siteId,
        lane: lane ?? this.lane,
        performedAt: performedAt ?? this.performedAt,
        linkedTransactionId: linkedTransactionId.present
            ? linkedTransactionId.value
            : this.linkedTransactionId,
        linkedIncidentId: linkedIncidentId.present
            ? linkedIncidentId.value
            : this.linkedIncidentId,
        linkedSessionId: linkedSessionId.present
            ? linkedSessionId.value
            : this.linkedSessionId,
        localSyncStatus: localSyncStatus ?? this.localSyncStatus,
        createdAt: createdAt ?? this.createdAt,
      );
  ManualGateLog copyWithCompanion(ManualGateLogsCompanion data) {
    return ManualGateLog(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      justificationText: data.justificationText.present
          ? data.justificationText.value
          : this.justificationText,
      reasonCode:
          data.reasonCode.present ? data.reasonCode.value : this.reasonCode,
      operatorId:
          data.operatorId.present ? data.operatorId.value : this.operatorId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      lane: data.lane.present ? data.lane.value : this.lane,
      performedAt:
          data.performedAt.present ? data.performedAt.value : this.performedAt,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      linkedIncidentId: data.linkedIncidentId.present
          ? data.linkedIncidentId.value
          : this.linkedIncidentId,
      linkedSessionId: data.linkedSessionId.present
          ? data.linkedSessionId.value
          : this.linkedSessionId,
      localSyncStatus: data.localSyncStatus.present
          ? data.localSyncStatus.value
          : this.localSyncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManualGateLog(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('justificationText: $justificationText, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('operatorId: $operatorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('lane: $lane, ')
          ..write('performedAt: $performedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('linkedIncidentId: $linkedIncidentId, ')
          ..write('linkedSessionId: $linkedSessionId, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      recordId,
      idempotencyKey,
      justificationText,
      reasonCode,
      operatorId,
      deviceId,
      siteId,
      lane,
      performedAt,
      linkedTransactionId,
      linkedIncidentId,
      linkedSessionId,
      localSyncStatus,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManualGateLog &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.justificationText == this.justificationText &&
          other.reasonCode == this.reasonCode &&
          other.operatorId == this.operatorId &&
          other.deviceId == this.deviceId &&
          other.siteId == this.siteId &&
          other.lane == this.lane &&
          other.performedAt == this.performedAt &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.linkedIncidentId == this.linkedIncidentId &&
          other.linkedSessionId == this.linkedSessionId &&
          other.localSyncStatus == this.localSyncStatus &&
          other.createdAt == this.createdAt);
}

class ManualGateLogsCompanion extends UpdateCompanion<ManualGateLog> {
  final Value<int> id;
  final Value<String> recordId;
  final Value<String> idempotencyKey;
  final Value<String> justificationText;
  final Value<ManualActionReasonCode?> reasonCode;
  final Value<String> operatorId;
  final Value<String> deviceId;
  final Value<String> siteId;
  final Value<String> lane;
  final Value<DateTime> performedAt;
  final Value<String?> linkedTransactionId;
  final Value<String?> linkedIncidentId;
  final Value<String?> linkedSessionId;
  final Value<LocalSyncStatus> localSyncStatus;
  final Value<DateTime> createdAt;
  const ManualGateLogsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.justificationText = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.lane = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.linkedIncidentId = const Value.absent(),
    this.linkedSessionId = const Value.absent(),
    this.localSyncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ManualGateLogsCompanion.insert({
    this.id = const Value.absent(),
    required String recordId,
    required String idempotencyKey,
    required String justificationText,
    this.reasonCode = const Value.absent(),
    required String operatorId,
    required String deviceId,
    required String siteId,
    required String lane,
    this.performedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.linkedIncidentId = const Value.absent(),
    this.linkedSessionId = const Value.absent(),
    required LocalSyncStatus localSyncStatus,
    this.createdAt = const Value.absent(),
  })  : recordId = Value(recordId),
        idempotencyKey = Value(idempotencyKey),
        justificationText = Value(justificationText),
        operatorId = Value(operatorId),
        deviceId = Value(deviceId),
        siteId = Value(siteId),
        lane = Value(lane),
        localSyncStatus = Value(localSyncStatus);
  static Insertable<ManualGateLog> custom({
    Expression<int>? id,
    Expression<String>? recordId,
    Expression<String>? idempotencyKey,
    Expression<String>? justificationText,
    Expression<String>? reasonCode,
    Expression<String>? operatorId,
    Expression<String>? deviceId,
    Expression<String>? siteId,
    Expression<String>? lane,
    Expression<DateTime>? performedAt,
    Expression<String>? linkedTransactionId,
    Expression<String>? linkedIncidentId,
    Expression<String>? linkedSessionId,
    Expression<String>? localSyncStatus,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (justificationText != null) 'justification_text': justificationText,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (operatorId != null) 'operator_id': operatorId,
      if (deviceId != null) 'device_id': deviceId,
      if (siteId != null) 'site_id': siteId,
      if (lane != null) 'lane': lane,
      if (performedAt != null) 'performed_at': performedAt,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (linkedIncidentId != null) 'linked_incident_id': linkedIncidentId,
      if (linkedSessionId != null) 'linked_session_id': linkedSessionId,
      if (localSyncStatus != null) 'local_sync_status': localSyncStatus,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ManualGateLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordId,
      Value<String>? idempotencyKey,
      Value<String>? justificationText,
      Value<ManualActionReasonCode?>? reasonCode,
      Value<String>? operatorId,
      Value<String>? deviceId,
      Value<String>? siteId,
      Value<String>? lane,
      Value<DateTime>? performedAt,
      Value<String?>? linkedTransactionId,
      Value<String?>? linkedIncidentId,
      Value<String?>? linkedSessionId,
      Value<LocalSyncStatus>? localSyncStatus,
      Value<DateTime>? createdAt}) {
    return ManualGateLogsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      justificationText: justificationText ?? this.justificationText,
      reasonCode: reasonCode ?? this.reasonCode,
      operatorId: operatorId ?? this.operatorId,
      deviceId: deviceId ?? this.deviceId,
      siteId: siteId ?? this.siteId,
      lane: lane ?? this.lane,
      performedAt: performedAt ?? this.performedAt,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      linkedIncidentId: linkedIncidentId ?? this.linkedIncidentId,
      linkedSessionId: linkedSessionId ?? this.linkedSessionId,
      localSyncStatus: localSyncStatus ?? this.localSyncStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (justificationText.present) {
      map['justification_text'] = Variable<String>(justificationText.value);
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(
          $ManualGateLogsTable.$converterreasonCode.toSql(reasonCode.value));
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (lane.present) {
      map['lane'] = Variable<String>(lane.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] =
          Variable<String>(linkedTransactionId.value);
    }
    if (linkedIncidentId.present) {
      map['linked_incident_id'] = Variable<String>(linkedIncidentId.value);
    }
    if (linkedSessionId.present) {
      map['linked_session_id'] = Variable<String>(linkedSessionId.value);
    }
    if (localSyncStatus.present) {
      map['local_sync_status'] = Variable<String>($ManualGateLogsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManualGateLogsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('justificationText: $justificationText, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('operatorId: $operatorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('lane: $lane, ')
          ..write('performedAt: $performedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('linkedIncidentId: $linkedIncidentId, ')
          ..write('linkedSessionId: $linkedSessionId, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OverrideRequestsTable extends OverrideRequests
    with TableInfo<$OverrideRequestsTable, OverrideRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OverrideRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _justificationTextMeta =
      const VerificationMeta('justificationText');
  @override
  late final GeneratedColumn<String> justificationText =
      GeneratedColumn<String>('justification_text', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operatorIdMeta =
      const VerificationMeta('operatorId');
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
      'operator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
      'site_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _submittedAtMeta =
      const VerificationMeta('submittedAt');
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
      'submitted_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>('linked_transaction_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedManualLogIdMeta =
      const VerificationMeta('linkedManualLogId');
  @override
  late final GeneratedColumn<String> linkedManualLogId =
      GeneratedColumn<String>('linked_manual_log_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedIncidentIdMeta =
      const VerificationMeta('linkedIncidentId');
  @override
  late final GeneratedColumn<String> linkedIncidentId = GeneratedColumn<String>(
      'linked_incident_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      localSyncStatus = GeneratedColumn<String>(
              'local_sync_status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<LocalSyncStatus>(
              $OverrideRequestsTable.$converterlocalSyncStatus);
  static const VerificationMeta _backendStatusMeta =
      const VerificationMeta('backendStatus');
  @override
  late final GeneratedColumn<String> backendStatus = GeneratedColumn<String>(
      'backend_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recordId,
        idempotencyKey,
        justificationText,
        operatorId,
        deviceId,
        siteId,
        submittedAt,
        linkedTransactionId,
        linkedManualLogId,
        linkedIncidentId,
        localSyncStatus,
        backendStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'override_requests';
  @override
  VerificationContext validateIntegrity(Insertable<OverrideRequest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('justification_text')) {
      context.handle(
          _justificationTextMeta,
          justificationText.isAcceptableOrUnknown(
              data['justification_text']!, _justificationTextMeta));
    } else if (isInserting) {
      context.missing(_justificationTextMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
          _operatorIdMeta,
          operatorId.isAcceptableOrUnknown(
              data['operator_id']!, _operatorIdMeta));
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
          _submittedAtMeta,
          submittedAt.isAcceptableOrUnknown(
              data['submitted_at']!, _submittedAtMeta));
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
          _linkedTransactionIdMeta,
          linkedTransactionId.isAcceptableOrUnknown(
              data['linked_transaction_id']!, _linkedTransactionIdMeta));
    }
    if (data.containsKey('linked_manual_log_id')) {
      context.handle(
          _linkedManualLogIdMeta,
          linkedManualLogId.isAcceptableOrUnknown(
              data['linked_manual_log_id']!, _linkedManualLogIdMeta));
    }
    if (data.containsKey('linked_incident_id')) {
      context.handle(
          _linkedIncidentIdMeta,
          linkedIncidentId.isAcceptableOrUnknown(
              data['linked_incident_id']!, _linkedIncidentIdMeta));
    }
    if (data.containsKey('backend_status')) {
      context.handle(
          _backendStatusMeta,
          backendStatus.isAcceptableOrUnknown(
              data['backend_status']!, _backendStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OverrideRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OverrideRequest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      justificationText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}justification_text'])!,
      operatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_id'])!,
      submittedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}submitted_at'])!,
      linkedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_transaction_id']),
      linkedManualLogId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_manual_log_id']),
      linkedIncidentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_incident_id']),
      localSyncStatus: $OverrideRequestsTable.$converterlocalSyncStatus.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}local_sync_status'])!),
      backendStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}backend_status']),
    );
  }

  @override
  $OverrideRequestsTable createAlias(String alias) {
    return $OverrideRequestsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalSyncStatus, String> $converterlocalSyncStatus =
      const LocalSyncStatusConverter();
}

class OverrideRequest extends DataClass implements Insertable<OverrideRequest> {
  final int id;
  final String recordId;
  final String idempotencyKey;
  final String justificationText;
  final String operatorId;
  final String deviceId;
  final String siteId;
  final DateTime submittedAt;

  /// Optional soft link to whatever transaction, manual action, or
  /// incident prompted the override. Not explicitly required by the AC
  /// text ("supporting context" is vague) — drop whichever of these
  /// aren't wanted.
  final String? linkedTransactionId;
  final String? linkedManualLogId;
  final String? linkedIncidentId;
  final LocalSyncStatus localSyncStatus;

  /// Backend-owned, read-only. "Read-only approval outcome is shown if
  /// returned by the backend." Plain nullable string for the same reason
  /// as Incidents.backendReconciliationStatus — vocabulary not yet
  /// confirmed, and this app must never write to it locally.
  final String? backendStatus;
  const OverrideRequest(
      {required this.id,
      required this.recordId,
      required this.idempotencyKey,
      required this.justificationText,
      required this.operatorId,
      required this.deviceId,
      required this.siteId,
      required this.submittedAt,
      this.linkedTransactionId,
      this.linkedManualLogId,
      this.linkedIncidentId,
      required this.localSyncStatus,
      this.backendStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<String>(recordId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['justification_text'] = Variable<String>(justificationText);
    map['operator_id'] = Variable<String>(operatorId);
    map['device_id'] = Variable<String>(deviceId);
    map['site_id'] = Variable<String>(siteId);
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    }
    if (!nullToAbsent || linkedManualLogId != null) {
      map['linked_manual_log_id'] = Variable<String>(linkedManualLogId);
    }
    if (!nullToAbsent || linkedIncidentId != null) {
      map['linked_incident_id'] = Variable<String>(linkedIncidentId);
    }
    {
      map['local_sync_status'] = Variable<String>($OverrideRequestsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus));
    }
    if (!nullToAbsent || backendStatus != null) {
      map['backend_status'] = Variable<String>(backendStatus);
    }
    return map;
  }

  OverrideRequestsCompanion toCompanion(bool nullToAbsent) {
    return OverrideRequestsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      idempotencyKey: Value(idempotencyKey),
      justificationText: Value(justificationText),
      operatorId: Value(operatorId),
      deviceId: Value(deviceId),
      siteId: Value(siteId),
      submittedAt: Value(submittedAt),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      linkedManualLogId: linkedManualLogId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedManualLogId),
      linkedIncidentId: linkedIncidentId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedIncidentId),
      localSyncStatus: Value(localSyncStatus),
      backendStatus: backendStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(backendStatus),
    );
  }

  factory OverrideRequest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OverrideRequest(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      justificationText: serializer.fromJson<String>(json['justificationText']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
      linkedTransactionId:
          serializer.fromJson<String?>(json['linkedTransactionId']),
      linkedManualLogId:
          serializer.fromJson<String?>(json['linkedManualLogId']),
      linkedIncidentId: serializer.fromJson<String?>(json['linkedIncidentId']),
      localSyncStatus:
          serializer.fromJson<LocalSyncStatus>(json['localSyncStatus']),
      backendStatus: serializer.fromJson<String?>(json['backendStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<String>(recordId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'justificationText': serializer.toJson<String>(justificationText),
      'operatorId': serializer.toJson<String>(operatorId),
      'deviceId': serializer.toJson<String>(deviceId),
      'siteId': serializer.toJson<String>(siteId),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
      'linkedTransactionId': serializer.toJson<String?>(linkedTransactionId),
      'linkedManualLogId': serializer.toJson<String?>(linkedManualLogId),
      'linkedIncidentId': serializer.toJson<String?>(linkedIncidentId),
      'localSyncStatus': serializer.toJson<LocalSyncStatus>(localSyncStatus),
      'backendStatus': serializer.toJson<String?>(backendStatus),
    };
  }

  OverrideRequest copyWith(
          {int? id,
          String? recordId,
          String? idempotencyKey,
          String? justificationText,
          String? operatorId,
          String? deviceId,
          String? siteId,
          DateTime? submittedAt,
          Value<String?> linkedTransactionId = const Value.absent(),
          Value<String?> linkedManualLogId = const Value.absent(),
          Value<String?> linkedIncidentId = const Value.absent(),
          LocalSyncStatus? localSyncStatus,
          Value<String?> backendStatus = const Value.absent()}) =>
      OverrideRequest(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        justificationText: justificationText ?? this.justificationText,
        operatorId: operatorId ?? this.operatorId,
        deviceId: deviceId ?? this.deviceId,
        siteId: siteId ?? this.siteId,
        submittedAt: submittedAt ?? this.submittedAt,
        linkedTransactionId: linkedTransactionId.present
            ? linkedTransactionId.value
            : this.linkedTransactionId,
        linkedManualLogId: linkedManualLogId.present
            ? linkedManualLogId.value
            : this.linkedManualLogId,
        linkedIncidentId: linkedIncidentId.present
            ? linkedIncidentId.value
            : this.linkedIncidentId,
        localSyncStatus: localSyncStatus ?? this.localSyncStatus,
        backendStatus:
            backendStatus.present ? backendStatus.value : this.backendStatus,
      );
  OverrideRequest copyWithCompanion(OverrideRequestsCompanion data) {
    return OverrideRequest(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      justificationText: data.justificationText.present
          ? data.justificationText.value
          : this.justificationText,
      operatorId:
          data.operatorId.present ? data.operatorId.value : this.operatorId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      submittedAt:
          data.submittedAt.present ? data.submittedAt.value : this.submittedAt,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      linkedManualLogId: data.linkedManualLogId.present
          ? data.linkedManualLogId.value
          : this.linkedManualLogId,
      linkedIncidentId: data.linkedIncidentId.present
          ? data.linkedIncidentId.value
          : this.linkedIncidentId,
      localSyncStatus: data.localSyncStatus.present
          ? data.localSyncStatus.value
          : this.localSyncStatus,
      backendStatus: data.backendStatus.present
          ? data.backendStatus.value
          : this.backendStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OverrideRequest(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('justificationText: $justificationText, ')
          ..write('operatorId: $operatorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('linkedManualLogId: $linkedManualLogId, ')
          ..write('linkedIncidentId: $linkedIncidentId, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('backendStatus: $backendStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      recordId,
      idempotencyKey,
      justificationText,
      operatorId,
      deviceId,
      siteId,
      submittedAt,
      linkedTransactionId,
      linkedManualLogId,
      linkedIncidentId,
      localSyncStatus,
      backendStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OverrideRequest &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.justificationText == this.justificationText &&
          other.operatorId == this.operatorId &&
          other.deviceId == this.deviceId &&
          other.siteId == this.siteId &&
          other.submittedAt == this.submittedAt &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.linkedManualLogId == this.linkedManualLogId &&
          other.linkedIncidentId == this.linkedIncidentId &&
          other.localSyncStatus == this.localSyncStatus &&
          other.backendStatus == this.backendStatus);
}

class OverrideRequestsCompanion extends UpdateCompanion<OverrideRequest> {
  final Value<int> id;
  final Value<String> recordId;
  final Value<String> idempotencyKey;
  final Value<String> justificationText;
  final Value<String> operatorId;
  final Value<String> deviceId;
  final Value<String> siteId;
  final Value<DateTime> submittedAt;
  final Value<String?> linkedTransactionId;
  final Value<String?> linkedManualLogId;
  final Value<String?> linkedIncidentId;
  final Value<LocalSyncStatus> localSyncStatus;
  final Value<String?> backendStatus;
  const OverrideRequestsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.justificationText = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.linkedManualLogId = const Value.absent(),
    this.linkedIncidentId = const Value.absent(),
    this.localSyncStatus = const Value.absent(),
    this.backendStatus = const Value.absent(),
  });
  OverrideRequestsCompanion.insert({
    this.id = const Value.absent(),
    required String recordId,
    required String idempotencyKey,
    required String justificationText,
    required String operatorId,
    required String deviceId,
    required String siteId,
    this.submittedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.linkedManualLogId = const Value.absent(),
    this.linkedIncidentId = const Value.absent(),
    required LocalSyncStatus localSyncStatus,
    this.backendStatus = const Value.absent(),
  })  : recordId = Value(recordId),
        idempotencyKey = Value(idempotencyKey),
        justificationText = Value(justificationText),
        operatorId = Value(operatorId),
        deviceId = Value(deviceId),
        siteId = Value(siteId),
        localSyncStatus = Value(localSyncStatus);
  static Insertable<OverrideRequest> custom({
    Expression<int>? id,
    Expression<String>? recordId,
    Expression<String>? idempotencyKey,
    Expression<String>? justificationText,
    Expression<String>? operatorId,
    Expression<String>? deviceId,
    Expression<String>? siteId,
    Expression<DateTime>? submittedAt,
    Expression<String>? linkedTransactionId,
    Expression<String>? linkedManualLogId,
    Expression<String>? linkedIncidentId,
    Expression<String>? localSyncStatus,
    Expression<String>? backendStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (justificationText != null) 'justification_text': justificationText,
      if (operatorId != null) 'operator_id': operatorId,
      if (deviceId != null) 'device_id': deviceId,
      if (siteId != null) 'site_id': siteId,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (linkedManualLogId != null) 'linked_manual_log_id': linkedManualLogId,
      if (linkedIncidentId != null) 'linked_incident_id': linkedIncidentId,
      if (localSyncStatus != null) 'local_sync_status': localSyncStatus,
      if (backendStatus != null) 'backend_status': backendStatus,
    });
  }

  OverrideRequestsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordId,
      Value<String>? idempotencyKey,
      Value<String>? justificationText,
      Value<String>? operatorId,
      Value<String>? deviceId,
      Value<String>? siteId,
      Value<DateTime>? submittedAt,
      Value<String?>? linkedTransactionId,
      Value<String?>? linkedManualLogId,
      Value<String?>? linkedIncidentId,
      Value<LocalSyncStatus>? localSyncStatus,
      Value<String?>? backendStatus}) {
    return OverrideRequestsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      justificationText: justificationText ?? this.justificationText,
      operatorId: operatorId ?? this.operatorId,
      deviceId: deviceId ?? this.deviceId,
      siteId: siteId ?? this.siteId,
      submittedAt: submittedAt ?? this.submittedAt,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      linkedManualLogId: linkedManualLogId ?? this.linkedManualLogId,
      linkedIncidentId: linkedIncidentId ?? this.linkedIncidentId,
      localSyncStatus: localSyncStatus ?? this.localSyncStatus,
      backendStatus: backendStatus ?? this.backendStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (justificationText.present) {
      map['justification_text'] = Variable<String>(justificationText.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] =
          Variable<String>(linkedTransactionId.value);
    }
    if (linkedManualLogId.present) {
      map['linked_manual_log_id'] = Variable<String>(linkedManualLogId.value);
    }
    if (linkedIncidentId.present) {
      map['linked_incident_id'] = Variable<String>(linkedIncidentId.value);
    }
    if (localSyncStatus.present) {
      map['local_sync_status'] = Variable<String>($OverrideRequestsTable
          .$converterlocalSyncStatus
          .toSql(localSyncStatus.value));
    }
    if (backendStatus.present) {
      map['backend_status'] = Variable<String>(backendStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OverrideRequestsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('justificationText: $justificationText, ')
          ..write('operatorId: $operatorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('siteId: $siteId, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('linkedManualLogId: $linkedManualLogId, ')
          ..write('linkedIncidentId: $linkedIncidentId, ')
          ..write('localSyncStatus: $localSyncStatus, ')
          ..write('backendStatus: $backendStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContinuityTransactionsTable continuityTransactions =
      $ContinuityTransactionsTable(this);
  late final $IncidentsTable incidents = $IncidentsTable(this);
  late final $ExceptionTagsTable exceptionTags = $ExceptionTagsTable(this);
  late final $ManualGateLogsTable manualGateLogs = $ManualGateLogsTable(this);
  late final $OverrideRequestsTable overrideRequests =
      $OverrideRequestsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        continuityTransactions,
        incidents,
        exceptionTags,
        manualGateLogs,
        overrideRequests
      ];
}

typedef $$ContinuityTransactionsTableCreateCompanionBuilder
    = ContinuityTransactionsCompanion Function({
  Value<int> id,
  required String recordId,
  required String idempotencyKey,
  required String operatorId,
  required String deviceId,
  required String siteId,
  required String lane,
  Value<DateTime> occurredAt,
  Value<int?> amountMinorUnits,
  Value<String?> currencyCode,
  Value<String?> paymentMethod,
  Value<String?> evidenceReference,
  Value<String?> notes,
  required LocalSyncStatus localSyncStatus,
  Value<String?> backendLifecycleStatus,
  Value<String?> backendReconciliationStatus,
  Value<DateTime> createdAt,
});
typedef $$ContinuityTransactionsTableUpdateCompanionBuilder
    = ContinuityTransactionsCompanion Function({
  Value<int> id,
  Value<String> recordId,
  Value<String> idempotencyKey,
  Value<String> operatorId,
  Value<String> deviceId,
  Value<String> siteId,
  Value<String> lane,
  Value<DateTime> occurredAt,
  Value<int?> amountMinorUnits,
  Value<String?> currencyCode,
  Value<String?> paymentMethod,
  Value<String?> evidenceReference,
  Value<String?> notes,
  Value<LocalSyncStatus> localSyncStatus,
  Value<String?> backendLifecycleStatus,
  Value<String?> backendReconciliationStatus,
  Value<DateTime> createdAt,
});

final class $$ContinuityTransactionsTableReferences extends BaseReferences<
    _$AppDatabase, $ContinuityTransactionsTable, ContinuityTransaction> {
  $$ContinuityTransactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IncidentsTable, List<Incident>>
      _incidentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.incidents,
          aliasName:
              'continuity_transactions__record_id__incidents__linked_transaction_id');

  $$IncidentsTableProcessedTableManager get incidentsRefs {
    final manager = $$IncidentsTableTableManager($_db, $_db.incidents).filter(
        (f) => f.linkedTransactionId.recordId
            .sqlEquals($_itemColumn<String>('record_id')!));

    final cache = $_typedResult.readTableOrNull(_incidentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExceptionTagsTable,
      List<ExceptionTag>> _exceptionTagsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.exceptionTags,
          aliasName:
              'continuity_transactions__record_id__exception_tags__linked_transaction_id');

  $$ExceptionTagsTableProcessedTableManager get exceptionTagsRefs {
    final manager = $$ExceptionTagsTableTableManager($_db, $_db.exceptionTags)
        .filter((f) => f.linkedTransactionId.recordId
            .sqlEquals($_itemColumn<String>('record_id')!));

    final cache = $_typedResult.readTableOrNull(_exceptionTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ManualGateLogsTable,
      List<ManualGateLog>> _manualGateLogsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.manualGateLogs,
          aliasName:
              'continuity_transactions__record_id__manual_gate_logs__linked_transaction_id');

  $$ManualGateLogsTableProcessedTableManager get manualGateLogsRefs {
    final manager = $$ManualGateLogsTableTableManager($_db, $_db.manualGateLogs)
        .filter((f) => f.linkedTransactionId.recordId
            .sqlEquals($_itemColumn<String>('record_id')!));

    final cache = $_typedResult.readTableOrNull(_manualGateLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ContinuityTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $ContinuityTransactionsTable> {
  $$ContinuityTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lane => $composableBuilder(
      column: $table.lane, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinorUnits => $composableBuilder(
      column: $table.amountMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidenceReference => $composableBuilder(
      column: $table.evidenceReference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<LocalSyncStatus, LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get backendLifecycleStatus => $composableBuilder(
      column: $table.backendLifecycleStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backendReconciliationStatus => $composableBuilder(
      column: $table.backendReconciliationStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> incidentsRefs(
      Expression<bool> Function($$IncidentsTableFilterComposer f) f) {
    final $$IncidentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.incidents,
        getReferencedColumn: (t) => t.linkedTransactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IncidentsTableFilterComposer(
              $db: $db,
              $table: $db.incidents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> exceptionTagsRefs(
      Expression<bool> Function($$ExceptionTagsTableFilterComposer f) f) {
    final $$ExceptionTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.exceptionTags,
        getReferencedColumn: (t) => t.linkedTransactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExceptionTagsTableFilterComposer(
              $db: $db,
              $table: $db.exceptionTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> manualGateLogsRefs(
      Expression<bool> Function($$ManualGateLogsTableFilterComposer f) f) {
    final $$ManualGateLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.manualGateLogs,
        getReferencedColumn: (t) => t.linkedTransactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ManualGateLogsTableFilterComposer(
              $db: $db,
              $table: $db.manualGateLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ContinuityTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContinuityTransactionsTable> {
  $$ContinuityTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lane => $composableBuilder(
      column: $table.lane, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinorUnits => $composableBuilder(
      column: $table.amountMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidenceReference => $composableBuilder(
      column: $table.evidenceReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localSyncStatus => $composableBuilder(
      column: $table.localSyncStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backendLifecycleStatus => $composableBuilder(
      column: $table.backendLifecycleStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backendReconciliationStatus => $composableBuilder(
      column: $table.backendReconciliationStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ContinuityTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContinuityTransactionsTable> {
  $$ContinuityTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get lane =>
      $composableBuilder(column: $table.lane, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<int> get amountMinorUnits => $composableBuilder(
      column: $table.amountMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get evidenceReference => $composableBuilder(
      column: $table.evidenceReference, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus, builder: (column) => column);

  GeneratedColumn<String> get backendLifecycleStatus => $composableBuilder(
      column: $table.backendLifecycleStatus, builder: (column) => column);

  GeneratedColumn<String> get backendReconciliationStatus => $composableBuilder(
      column: $table.backendReconciliationStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> incidentsRefs<T extends Object>(
      Expression<T> Function($$IncidentsTableAnnotationComposer a) f) {
    final $$IncidentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.incidents,
        getReferencedColumn: (t) => t.linkedTransactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IncidentsTableAnnotationComposer(
              $db: $db,
              $table: $db.incidents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> exceptionTagsRefs<T extends Object>(
      Expression<T> Function($$ExceptionTagsTableAnnotationComposer a) f) {
    final $$ExceptionTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.exceptionTags,
        getReferencedColumn: (t) => t.linkedTransactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExceptionTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.exceptionTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> manualGateLogsRefs<T extends Object>(
      Expression<T> Function($$ManualGateLogsTableAnnotationComposer a) f) {
    final $$ManualGateLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.manualGateLogs,
        getReferencedColumn: (t) => t.linkedTransactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ManualGateLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.manualGateLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ContinuityTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContinuityTransactionsTable,
    ContinuityTransaction,
    $$ContinuityTransactionsTableFilterComposer,
    $$ContinuityTransactionsTableOrderingComposer,
    $$ContinuityTransactionsTableAnnotationComposer,
    $$ContinuityTransactionsTableCreateCompanionBuilder,
    $$ContinuityTransactionsTableUpdateCompanionBuilder,
    (ContinuityTransaction, $$ContinuityTransactionsTableReferences),
    ContinuityTransaction,
    PrefetchHooks Function(
        {bool incidentsRefs,
        bool exceptionTagsRefs,
        bool manualGateLogsRefs})> {
  $$ContinuityTransactionsTableTableManager(
      _$AppDatabase db, $ContinuityTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContinuityTransactionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ContinuityTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContinuityTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> operatorId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> siteId = const Value.absent(),
            Value<String> lane = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int?> amountMinorUnits = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> evidenceReference = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<LocalSyncStatus> localSyncStatus = const Value.absent(),
            Value<String?> backendLifecycleStatus = const Value.absent(),
            Value<String?> backendReconciliationStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ContinuityTransactionsCompanion(
            id: id,
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            lane: lane,
            occurredAt: occurredAt,
            amountMinorUnits: amountMinorUnits,
            currencyCode: currencyCode,
            paymentMethod: paymentMethod,
            evidenceReference: evidenceReference,
            notes: notes,
            localSyncStatus: localSyncStatus,
            backendLifecycleStatus: backendLifecycleStatus,
            backendReconciliationStatus: backendReconciliationStatus,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordId,
            required String idempotencyKey,
            required String operatorId,
            required String deviceId,
            required String siteId,
            required String lane,
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int?> amountMinorUnits = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> evidenceReference = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required LocalSyncStatus localSyncStatus,
            Value<String?> backendLifecycleStatus = const Value.absent(),
            Value<String?> backendReconciliationStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ContinuityTransactionsCompanion.insert(
            id: id,
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            lane: lane,
            occurredAt: occurredAt,
            amountMinorUnits: amountMinorUnits,
            currencyCode: currencyCode,
            paymentMethod: paymentMethod,
            evidenceReference: evidenceReference,
            notes: notes,
            localSyncStatus: localSyncStatus,
            backendLifecycleStatus: backendLifecycleStatus,
            backendReconciliationStatus: backendReconciliationStatus,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ContinuityTransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {incidentsRefs = false,
              exceptionTagsRefs = false,
              manualGateLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (incidentsRefs) db.incidents,
                if (exceptionTagsRefs) db.exceptionTags,
                if (manualGateLogsRefs) db.manualGateLogs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (incidentsRefs)
                    await $_getPrefetchedData<ContinuityTransaction,
                            $ContinuityTransactionsTable, Incident>(
                        currentTable: table,
                        referencedTable: $$ContinuityTransactionsTableReferences
                            ._incidentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContinuityTransactionsTableReferences(
                                    db, table, p0)
                                .incidentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedTransactionId == item.recordId),
                        typedResults: items),
                  if (exceptionTagsRefs)
                    await $_getPrefetchedData<ContinuityTransaction,
                            $ContinuityTransactionsTable, ExceptionTag>(
                        currentTable: table,
                        referencedTable: $$ContinuityTransactionsTableReferences
                            ._exceptionTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContinuityTransactionsTableReferences(
                                    db, table, p0)
                                .exceptionTagsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedTransactionId == item.recordId),
                        typedResults: items),
                  if (manualGateLogsRefs)
                    await $_getPrefetchedData<ContinuityTransaction,
                            $ContinuityTransactionsTable, ManualGateLog>(
                        currentTable: table,
                        referencedTable: $$ContinuityTransactionsTableReferences
                            ._manualGateLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContinuityTransactionsTableReferences(
                                    db, table, p0)
                                .manualGateLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedTransactionId == item.recordId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ContinuityTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ContinuityTransactionsTable,
        ContinuityTransaction,
        $$ContinuityTransactionsTableFilterComposer,
        $$ContinuityTransactionsTableOrderingComposer,
        $$ContinuityTransactionsTableAnnotationComposer,
        $$ContinuityTransactionsTableCreateCompanionBuilder,
        $$ContinuityTransactionsTableUpdateCompanionBuilder,
        (ContinuityTransaction, $$ContinuityTransactionsTableReferences),
        ContinuityTransaction,
        PrefetchHooks Function(
            {bool incidentsRefs,
            bool exceptionTagsRefs,
            bool manualGateLogsRefs})>;
typedef $$IncidentsTableCreateCompanionBuilder = IncidentsCompanion Function({
  Value<int> id,
  required String recordId,
  required IncidentCategory category,
  required String deviceId,
  required String siteId,
  required String operatorId,
  Value<DateTime> occurredAt,
  Value<String?> linkedTransactionId,
  Value<String?> evidenceReference,
  Value<String?> notes,
  required LocalSyncStatus localSyncStatus,
  Value<String?> backendReconciliationStatus,
  Value<DateTime> createdAt,
});
typedef $$IncidentsTableUpdateCompanionBuilder = IncidentsCompanion Function({
  Value<int> id,
  Value<String> recordId,
  Value<IncidentCategory> category,
  Value<String> deviceId,
  Value<String> siteId,
  Value<String> operatorId,
  Value<DateTime> occurredAt,
  Value<String?> linkedTransactionId,
  Value<String?> evidenceReference,
  Value<String?> notes,
  Value<LocalSyncStatus> localSyncStatus,
  Value<String?> backendReconciliationStatus,
  Value<DateTime> createdAt,
});

final class $$IncidentsTableReferences
    extends BaseReferences<_$AppDatabase, $IncidentsTable, Incident> {
  $$IncidentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContinuityTransactionsTable _linkedTransactionIdTable(
          _$AppDatabase db) =>
      db.continuityTransactions.createAlias(
          'incidents__linked_transaction_id__continuity_transactions__record_id');

  $$ContinuityTransactionsTableProcessedTableManager? get linkedTransactionId {
    final $_column = $_itemColumn<String>('linked_transaction_id');
    if ($_column == null) return null;
    final manager = $$ContinuityTransactionsTableTableManager(
            $_db, $_db.continuityTransactions)
        .filter((f) => f.recordId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IncidentsTableFilterComposer
    extends Composer<_$AppDatabase, $IncidentsTable> {
  $$IncidentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<IncidentCategory, IncidentCategory, String>
      get category => $composableBuilder(
          column: $table.category,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidenceReference => $composableBuilder(
      column: $table.evidenceReference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<LocalSyncStatus, LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get backendReconciliationStatus => $composableBuilder(
      column: $table.backendReconciliationStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ContinuityTransactionsTableFilterComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableFilterComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$IncidentsTableOrderingComposer
    extends Composer<_$AppDatabase, $IncidentsTable> {
  $$IncidentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidenceReference => $composableBuilder(
      column: $table.evidenceReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localSyncStatus => $composableBuilder(
      column: $table.localSyncStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backendReconciliationStatus => $composableBuilder(
      column: $table.backendReconciliationStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ContinuityTransactionsTableOrderingComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableOrderingComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$IncidentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidentsTable> {
  $$IncidentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IncidentCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get evidenceReference => $composableBuilder(
      column: $table.evidenceReference, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus, builder: (column) => column);

  GeneratedColumn<String> get backendReconciliationStatus => $composableBuilder(
      column: $table.backendReconciliationStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ContinuityTransactionsTableAnnotationComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$IncidentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IncidentsTable,
    Incident,
    $$IncidentsTableFilterComposer,
    $$IncidentsTableOrderingComposer,
    $$IncidentsTableAnnotationComposer,
    $$IncidentsTableCreateCompanionBuilder,
    $$IncidentsTableUpdateCompanionBuilder,
    (Incident, $$IncidentsTableReferences),
    Incident,
    PrefetchHooks Function({bool linkedTransactionId})> {
  $$IncidentsTableTableManager(_$AppDatabase db, $IncidentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncidentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncidentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<IncidentCategory> category = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> siteId = const Value.absent(),
            Value<String> operatorId = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<String?> evidenceReference = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<LocalSyncStatus> localSyncStatus = const Value.absent(),
            Value<String?> backendReconciliationStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              IncidentsCompanion(
            id: id,
            recordId: recordId,
            category: category,
            deviceId: deviceId,
            siteId: siteId,
            operatorId: operatorId,
            occurredAt: occurredAt,
            linkedTransactionId: linkedTransactionId,
            evidenceReference: evidenceReference,
            notes: notes,
            localSyncStatus: localSyncStatus,
            backendReconciliationStatus: backendReconciliationStatus,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordId,
            required IncidentCategory category,
            required String deviceId,
            required String siteId,
            required String operatorId,
            Value<DateTime> occurredAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<String?> evidenceReference = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required LocalSyncStatus localSyncStatus,
            Value<String?> backendReconciliationStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              IncidentsCompanion.insert(
            id: id,
            recordId: recordId,
            category: category,
            deviceId: deviceId,
            siteId: siteId,
            operatorId: operatorId,
            occurredAt: occurredAt,
            linkedTransactionId: linkedTransactionId,
            evidenceReference: evidenceReference,
            notes: notes,
            localSyncStatus: localSyncStatus,
            backendReconciliationStatus: backendReconciliationStatus,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IncidentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({linkedTransactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (linkedTransactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.linkedTransactionId,
                    referencedTable: $$IncidentsTableReferences
                        ._linkedTransactionIdTable(db),
                    referencedColumn: $$IncidentsTableReferences
                        ._linkedTransactionIdTable(db)
                        .recordId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$IncidentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IncidentsTable,
    Incident,
    $$IncidentsTableFilterComposer,
    $$IncidentsTableOrderingComposer,
    $$IncidentsTableAnnotationComposer,
    $$IncidentsTableCreateCompanionBuilder,
    $$IncidentsTableUpdateCompanionBuilder,
    (Incident, $$IncidentsTableReferences),
    Incident,
    PrefetchHooks Function({bool linkedTransactionId})>;
typedef $$ExceptionTagsTableCreateCompanionBuilder = ExceptionTagsCompanion
    Function({
  Value<int> id,
  required String recordId,
  required String linkedTransactionId,
  required ExceptionReasonCode reasonCode,
  required String deviceId,
  required String siteId,
  required String operatorId,
  Value<DateTime> taggedAt,
  required LocalSyncStatus localSyncStatus,
});
typedef $$ExceptionTagsTableUpdateCompanionBuilder = ExceptionTagsCompanion
    Function({
  Value<int> id,
  Value<String> recordId,
  Value<String> linkedTransactionId,
  Value<ExceptionReasonCode> reasonCode,
  Value<String> deviceId,
  Value<String> siteId,
  Value<String> operatorId,
  Value<DateTime> taggedAt,
  Value<LocalSyncStatus> localSyncStatus,
});

final class $$ExceptionTagsTableReferences
    extends BaseReferences<_$AppDatabase, $ExceptionTagsTable, ExceptionTag> {
  $$ExceptionTagsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ContinuityTransactionsTable _linkedTransactionIdTable(
          _$AppDatabase db) =>
      db.continuityTransactions.createAlias(
          'exception_tags__linked_transaction_id__continuity_transactions__record_id');

  $$ContinuityTransactionsTableProcessedTableManager get linkedTransactionId {
    final $_column = $_itemColumn<String>('linked_transaction_id')!;

    final manager = $$ContinuityTransactionsTableTableManager(
            $_db, $_db.continuityTransactions)
        .filter((f) => f.recordId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExceptionTagsTableFilterComposer
    extends Composer<_$AppDatabase, $ExceptionTagsTable> {
  $$ExceptionTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ExceptionReasonCode, ExceptionReasonCode,
          String>
      get reasonCode => $composableBuilder(
          column: $table.reasonCode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get taggedAt => $composableBuilder(
      column: $table.taggedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<LocalSyncStatus, LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$ContinuityTransactionsTableFilterComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableFilterComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ExceptionTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExceptionTagsTable> {
  $$ExceptionTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reasonCode => $composableBuilder(
      column: $table.reasonCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get taggedAt => $composableBuilder(
      column: $table.taggedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localSyncStatus => $composableBuilder(
      column: $table.localSyncStatus,
      builder: (column) => ColumnOrderings(column));

  $$ContinuityTransactionsTableOrderingComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableOrderingComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ExceptionTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExceptionTagsTable> {
  $$ExceptionTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExceptionReasonCode, String>
      get reasonCode => $composableBuilder(
          column: $table.reasonCode, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => column);

  GeneratedColumn<DateTime> get taggedAt =>
      $composableBuilder(column: $table.taggedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus, builder: (column) => column);

  $$ContinuityTransactionsTableAnnotationComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ExceptionTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExceptionTagsTable,
    ExceptionTag,
    $$ExceptionTagsTableFilterComposer,
    $$ExceptionTagsTableOrderingComposer,
    $$ExceptionTagsTableAnnotationComposer,
    $$ExceptionTagsTableCreateCompanionBuilder,
    $$ExceptionTagsTableUpdateCompanionBuilder,
    (ExceptionTag, $$ExceptionTagsTableReferences),
    ExceptionTag,
    PrefetchHooks Function({bool linkedTransactionId})> {
  $$ExceptionTagsTableTableManager(_$AppDatabase db, $ExceptionTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExceptionTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExceptionTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExceptionTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> linkedTransactionId = const Value.absent(),
            Value<ExceptionReasonCode> reasonCode = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> siteId = const Value.absent(),
            Value<String> operatorId = const Value.absent(),
            Value<DateTime> taggedAt = const Value.absent(),
            Value<LocalSyncStatus> localSyncStatus = const Value.absent(),
          }) =>
              ExceptionTagsCompanion(
            id: id,
            recordId: recordId,
            linkedTransactionId: linkedTransactionId,
            reasonCode: reasonCode,
            deviceId: deviceId,
            siteId: siteId,
            operatorId: operatorId,
            taggedAt: taggedAt,
            localSyncStatus: localSyncStatus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordId,
            required String linkedTransactionId,
            required ExceptionReasonCode reasonCode,
            required String deviceId,
            required String siteId,
            required String operatorId,
            Value<DateTime> taggedAt = const Value.absent(),
            required LocalSyncStatus localSyncStatus,
          }) =>
              ExceptionTagsCompanion.insert(
            id: id,
            recordId: recordId,
            linkedTransactionId: linkedTransactionId,
            reasonCode: reasonCode,
            deviceId: deviceId,
            siteId: siteId,
            operatorId: operatorId,
            taggedAt: taggedAt,
            localSyncStatus: localSyncStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExceptionTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({linkedTransactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (linkedTransactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.linkedTransactionId,
                    referencedTable: $$ExceptionTagsTableReferences
                        ._linkedTransactionIdTable(db),
                    referencedColumn: $$ExceptionTagsTableReferences
                        ._linkedTransactionIdTable(db)
                        .recordId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExceptionTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExceptionTagsTable,
    ExceptionTag,
    $$ExceptionTagsTableFilterComposer,
    $$ExceptionTagsTableOrderingComposer,
    $$ExceptionTagsTableAnnotationComposer,
    $$ExceptionTagsTableCreateCompanionBuilder,
    $$ExceptionTagsTableUpdateCompanionBuilder,
    (ExceptionTag, $$ExceptionTagsTableReferences),
    ExceptionTag,
    PrefetchHooks Function({bool linkedTransactionId})>;
typedef $$ManualGateLogsTableCreateCompanionBuilder = ManualGateLogsCompanion
    Function({
  Value<int> id,
  required String recordId,
  required String idempotencyKey,
  required String justificationText,
  Value<ManualActionReasonCode?> reasonCode,
  required String operatorId,
  required String deviceId,
  required String siteId,
  required String lane,
  Value<DateTime> performedAt,
  Value<String?> linkedTransactionId,
  Value<String?> linkedIncidentId,
  Value<String?> linkedSessionId,
  required LocalSyncStatus localSyncStatus,
  Value<DateTime> createdAt,
});
typedef $$ManualGateLogsTableUpdateCompanionBuilder = ManualGateLogsCompanion
    Function({
  Value<int> id,
  Value<String> recordId,
  Value<String> idempotencyKey,
  Value<String> justificationText,
  Value<ManualActionReasonCode?> reasonCode,
  Value<String> operatorId,
  Value<String> deviceId,
  Value<String> siteId,
  Value<String> lane,
  Value<DateTime> performedAt,
  Value<String?> linkedTransactionId,
  Value<String?> linkedIncidentId,
  Value<String?> linkedSessionId,
  Value<LocalSyncStatus> localSyncStatus,
  Value<DateTime> createdAt,
});

final class $$ManualGateLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ManualGateLogsTable, ManualGateLog> {
  $$ManualGateLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ContinuityTransactionsTable _linkedTransactionIdTable(
          _$AppDatabase db) =>
      db.continuityTransactions.createAlias(
          'manual_gate_logs__linked_transaction_id__continuity_transactions__record_id');

  $$ContinuityTransactionsTableProcessedTableManager? get linkedTransactionId {
    final $_column = $_itemColumn<String>('linked_transaction_id');
    if ($_column == null) return null;
    final manager = $$ContinuityTransactionsTableTableManager(
            $_db, $_db.continuityTransactions)
        .filter((f) => f.recordId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ManualGateLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ManualGateLogsTable> {
  $$ManualGateLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get justificationText => $composableBuilder(
      column: $table.justificationText,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ManualActionReasonCode?,
          ManualActionReasonCode, String>
      get reasonCode => $composableBuilder(
          column: $table.reasonCode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lane => $composableBuilder(
      column: $table.lane, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedIncidentId => $composableBuilder(
      column: $table.linkedIncidentId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedSessionId => $composableBuilder(
      column: $table.linkedSessionId,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<LocalSyncStatus, LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ContinuityTransactionsTableFilterComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableFilterComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ManualGateLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ManualGateLogsTable> {
  $$ManualGateLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get justificationText => $composableBuilder(
      column: $table.justificationText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reasonCode => $composableBuilder(
      column: $table.reasonCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lane => $composableBuilder(
      column: $table.lane, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedIncidentId => $composableBuilder(
      column: $table.linkedIncidentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedSessionId => $composableBuilder(
      column: $table.linkedSessionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localSyncStatus => $composableBuilder(
      column: $table.localSyncStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ContinuityTransactionsTableOrderingComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableOrderingComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ManualGateLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManualGateLogsTable> {
  $$ManualGateLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<String> get justificationText => $composableBuilder(
      column: $table.justificationText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ManualActionReasonCode?, String>
      get reasonCode => $composableBuilder(
          column: $table.reasonCode, builder: (column) => column);

  GeneratedColumn<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get lane =>
      $composableBuilder(column: $table.lane, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => column);

  GeneratedColumn<String> get linkedIncidentId => $composableBuilder(
      column: $table.linkedIncidentId, builder: (column) => column);

  GeneratedColumn<String> get linkedSessionId => $composableBuilder(
      column: $table.linkedSessionId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ContinuityTransactionsTableAnnotationComposer get linkedTransactionId {
    final $$ContinuityTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedTransactionId,
            referencedTable: $db.continuityTransactions,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContinuityTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.continuityTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ManualGateLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ManualGateLogsTable,
    ManualGateLog,
    $$ManualGateLogsTableFilterComposer,
    $$ManualGateLogsTableOrderingComposer,
    $$ManualGateLogsTableAnnotationComposer,
    $$ManualGateLogsTableCreateCompanionBuilder,
    $$ManualGateLogsTableUpdateCompanionBuilder,
    (ManualGateLog, $$ManualGateLogsTableReferences),
    ManualGateLog,
    PrefetchHooks Function({bool linkedTransactionId})> {
  $$ManualGateLogsTableTableManager(
      _$AppDatabase db, $ManualGateLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManualGateLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManualGateLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManualGateLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> justificationText = const Value.absent(),
            Value<ManualActionReasonCode?> reasonCode = const Value.absent(),
            Value<String> operatorId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> siteId = const Value.absent(),
            Value<String> lane = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<String?> linkedIncidentId = const Value.absent(),
            Value<String?> linkedSessionId = const Value.absent(),
            Value<LocalSyncStatus> localSyncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ManualGateLogsCompanion(
            id: id,
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            justificationText: justificationText,
            reasonCode: reasonCode,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            lane: lane,
            performedAt: performedAt,
            linkedTransactionId: linkedTransactionId,
            linkedIncidentId: linkedIncidentId,
            linkedSessionId: linkedSessionId,
            localSyncStatus: localSyncStatus,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordId,
            required String idempotencyKey,
            required String justificationText,
            Value<ManualActionReasonCode?> reasonCode = const Value.absent(),
            required String operatorId,
            required String deviceId,
            required String siteId,
            required String lane,
            Value<DateTime> performedAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<String?> linkedIncidentId = const Value.absent(),
            Value<String?> linkedSessionId = const Value.absent(),
            required LocalSyncStatus localSyncStatus,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ManualGateLogsCompanion.insert(
            id: id,
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            justificationText: justificationText,
            reasonCode: reasonCode,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            lane: lane,
            performedAt: performedAt,
            linkedTransactionId: linkedTransactionId,
            linkedIncidentId: linkedIncidentId,
            linkedSessionId: linkedSessionId,
            localSyncStatus: localSyncStatus,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ManualGateLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({linkedTransactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (linkedTransactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.linkedTransactionId,
                    referencedTable: $$ManualGateLogsTableReferences
                        ._linkedTransactionIdTable(db),
                    referencedColumn: $$ManualGateLogsTableReferences
                        ._linkedTransactionIdTable(db)
                        .recordId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ManualGateLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ManualGateLogsTable,
    ManualGateLog,
    $$ManualGateLogsTableFilterComposer,
    $$ManualGateLogsTableOrderingComposer,
    $$ManualGateLogsTableAnnotationComposer,
    $$ManualGateLogsTableCreateCompanionBuilder,
    $$ManualGateLogsTableUpdateCompanionBuilder,
    (ManualGateLog, $$ManualGateLogsTableReferences),
    ManualGateLog,
    PrefetchHooks Function({bool linkedTransactionId})>;
typedef $$OverrideRequestsTableCreateCompanionBuilder
    = OverrideRequestsCompanion Function({
  Value<int> id,
  required String recordId,
  required String idempotencyKey,
  required String justificationText,
  required String operatorId,
  required String deviceId,
  required String siteId,
  Value<DateTime> submittedAt,
  Value<String?> linkedTransactionId,
  Value<String?> linkedManualLogId,
  Value<String?> linkedIncidentId,
  required LocalSyncStatus localSyncStatus,
  Value<String?> backendStatus,
});
typedef $$OverrideRequestsTableUpdateCompanionBuilder
    = OverrideRequestsCompanion Function({
  Value<int> id,
  Value<String> recordId,
  Value<String> idempotencyKey,
  Value<String> justificationText,
  Value<String> operatorId,
  Value<String> deviceId,
  Value<String> siteId,
  Value<DateTime> submittedAt,
  Value<String?> linkedTransactionId,
  Value<String?> linkedManualLogId,
  Value<String?> linkedIncidentId,
  Value<LocalSyncStatus> localSyncStatus,
  Value<String?> backendStatus,
});

class $$OverrideRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $OverrideRequestsTable> {
  $$OverrideRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get justificationText => $composableBuilder(
      column: $table.justificationText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedManualLogId => $composableBuilder(
      column: $table.linkedManualLogId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedIncidentId => $composableBuilder(
      column: $table.linkedIncidentId,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<LocalSyncStatus, LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get backendStatus => $composableBuilder(
      column: $table.backendStatus, builder: (column) => ColumnFilters(column));
}

class $$OverrideRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $OverrideRequestsTable> {
  $$OverrideRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get justificationText => $composableBuilder(
      column: $table.justificationText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedManualLogId => $composableBuilder(
      column: $table.linkedManualLogId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedIncidentId => $composableBuilder(
      column: $table.linkedIncidentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localSyncStatus => $composableBuilder(
      column: $table.localSyncStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backendStatus => $composableBuilder(
      column: $table.backendStatus,
      builder: (column) => ColumnOrderings(column));
}

class $$OverrideRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OverrideRequestsTable> {
  $$OverrideRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<String> get justificationText => $composableBuilder(
      column: $table.justificationText, builder: (column) => column);

  GeneratedColumn<String> get operatorId => $composableBuilder(
      column: $table.operatorId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => column);

  GeneratedColumn<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId, builder: (column) => column);

  GeneratedColumn<String> get linkedManualLogId => $composableBuilder(
      column: $table.linkedManualLogId, builder: (column) => column);

  GeneratedColumn<String> get linkedIncidentId => $composableBuilder(
      column: $table.linkedIncidentId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalSyncStatus, String>
      get localSyncStatus => $composableBuilder(
          column: $table.localSyncStatus, builder: (column) => column);

  GeneratedColumn<String> get backendStatus => $composableBuilder(
      column: $table.backendStatus, builder: (column) => column);
}

class $$OverrideRequestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OverrideRequestsTable,
    OverrideRequest,
    $$OverrideRequestsTableFilterComposer,
    $$OverrideRequestsTableOrderingComposer,
    $$OverrideRequestsTableAnnotationComposer,
    $$OverrideRequestsTableCreateCompanionBuilder,
    $$OverrideRequestsTableUpdateCompanionBuilder,
    (
      OverrideRequest,
      BaseReferences<_$AppDatabase, $OverrideRequestsTable, OverrideRequest>
    ),
    OverrideRequest,
    PrefetchHooks Function()> {
  $$OverrideRequestsTableTableManager(
      _$AppDatabase db, $OverrideRequestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OverrideRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OverrideRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OverrideRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> justificationText = const Value.absent(),
            Value<String> operatorId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> siteId = const Value.absent(),
            Value<DateTime> submittedAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<String?> linkedManualLogId = const Value.absent(),
            Value<String?> linkedIncidentId = const Value.absent(),
            Value<LocalSyncStatus> localSyncStatus = const Value.absent(),
            Value<String?> backendStatus = const Value.absent(),
          }) =>
              OverrideRequestsCompanion(
            id: id,
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            justificationText: justificationText,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            submittedAt: submittedAt,
            linkedTransactionId: linkedTransactionId,
            linkedManualLogId: linkedManualLogId,
            linkedIncidentId: linkedIncidentId,
            localSyncStatus: localSyncStatus,
            backendStatus: backendStatus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordId,
            required String idempotencyKey,
            required String justificationText,
            required String operatorId,
            required String deviceId,
            required String siteId,
            Value<DateTime> submittedAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<String?> linkedManualLogId = const Value.absent(),
            Value<String?> linkedIncidentId = const Value.absent(),
            required LocalSyncStatus localSyncStatus,
            Value<String?> backendStatus = const Value.absent(),
          }) =>
              OverrideRequestsCompanion.insert(
            id: id,
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            justificationText: justificationText,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            submittedAt: submittedAt,
            linkedTransactionId: linkedTransactionId,
            linkedManualLogId: linkedManualLogId,
            linkedIncidentId: linkedIncidentId,
            localSyncStatus: localSyncStatus,
            backendStatus: backendStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OverrideRequestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OverrideRequestsTable,
    OverrideRequest,
    $$OverrideRequestsTableFilterComposer,
    $$OverrideRequestsTableOrderingComposer,
    $$OverrideRequestsTableAnnotationComposer,
    $$OverrideRequestsTableCreateCompanionBuilder,
    $$OverrideRequestsTableUpdateCompanionBuilder,
    (
      OverrideRequest,
      BaseReferences<_$AppDatabase, $OverrideRequestsTable, OverrideRequest>
    ),
    OverrideRequest,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContinuityTransactionsTableTableManager get continuityTransactions =>
      $$ContinuityTransactionsTableTableManager(
          _db, _db.continuityTransactions);
  $$IncidentsTableTableManager get incidents =>
      $$IncidentsTableTableManager(_db, _db.incidents);
  $$ExceptionTagsTableTableManager get exceptionTags =>
      $$ExceptionTagsTableTableManager(_db, _db.exceptionTags);
  $$ManualGateLogsTableTableManager get manualGateLogs =>
      $$ManualGateLogsTableTableManager(_db, _db.manualGateLogs);
  $$OverrideRequestsTableTableManager get overrideRequests =>
      $$OverrideRequestsTableTableManager(_db, _db.overrideRequests);
}
