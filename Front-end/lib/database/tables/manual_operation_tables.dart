import 'package:drift/drift.dart';

import 'incident_tables.dart' show LocalSyncStatusConverter;
import 'transaction_tables.dart' show ContinuityTransactions;

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// PLACEHOLDER, pending client confirmation -- same caveat as
/// IncidentCategory in incident_tables.dart. Reused from the existing
/// Manual Transaction dropdown where possible.
enum ManualActionReasonCode {
  systemDown,
  powerOutage,
  maintenance,
  networkOutage,
  other,
}

class ManualActionReasonCodeConverter
    extends TypeConverter<ManualActionReasonCode, String> {
  const ManualActionReasonCodeConverter();

  @override
  ManualActionReasonCode fromSql(String fromDb) =>
      ManualActionReasonCode.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(ManualActionReasonCode value) => value.name;
}

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// Epic 9 US1 — Manual Gate Action Logging: required reason, operator/device/
/// site/lane recorded, duplicate-safe via idempotencyKey, can link to
/// incidents/parking sessions when known.
@DataClassName('ManualGateLog')
class ManualGateLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordId => text().unique()();

  /// Prevents duplicate submission on retry; unique locally too so a retry
  /// can't even create a second local row.
  TextColumn get idempotencyKey => text().unique()();

  /// Backlog reads as "justification OR reason code" -- this schema always
  /// requires free text and treats reasonCode as optional structure on top.
  /// Make reasonCode required instead if the client wants it mandatory.
  TextColumn get justificationText => text()();
  TextColumn get reasonCode => text()
      .nullable()
      .map(const NullAwareTypeConverter.wrap(ManualActionReasonCodeConverter()))();

  TextColumn get operatorId => text()();
  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();
  TextColumn get lane => text()();

  DateTimeColumn get performedAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// linkedTransactionId is a real FK; the other two stay soft (parking-session
  /// schema unsettled). All nullable -- independent of a transaction, like
  /// [Incidents], unlike [ExceptionTags].
  TextColumn get linkedTransactionId => text()
      .nullable()
      .references(ContinuityTransactions, #recordId)();
  TextColumn get linkedIncidentId => text().nullable()();
  TextColumn get linkedSessionId => text().nullable()();

  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

}

/// Epic 9 US2. No local approve/deny logic by design -- approval is
/// backend-only, read-only here. Do not add an approval column without
/// re-checking this constraint.
@DataClassName('OverrideRequest')
class OverrideRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordId => text().unique()();
  TextColumn get idempotencyKey => text().unique()();

  TextColumn get justificationText => text()();

  TextColumn get operatorId => text()();
  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();

  DateTimeColumn get submittedAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Optional context for whatever prompted the override -- drop whichever
  /// of these end up unused.
  TextColumn get linkedTransactionId => text().nullable()();
  TextColumn get linkedManualLogId => text().nullable()();
  TextColumn get linkedIncidentId => text().nullable()();

  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  /// Backend-owned, read-only outcome -- same reasoning as
  /// Incidents.backendReconciliationStatus, never write here locally.
  TextColumn get backendStatus => text().nullable()();

}
