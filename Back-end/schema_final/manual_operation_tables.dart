import 'package:drift/drift.dart';

import 'incident_tables.dart' show LocalSyncStatus, LocalSyncStatusConverter;
import 'transaction_tables.dart' show ContinuityTransactions;

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Controlled reason codes for a manual gate action / override.
///
/// PLACEHOLDER VALUES pending client confirmation — same caveat as
/// [IncidentCategory] in incident_tables.dart. Reused from the existing
/// Manual Transaction screen's reason dropdown where possible.
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

/// Epic 9, User Story 1 — Manual Gate Action Logging.
///
/// Acceptance criteria covered:
///  - required reason (see justificationText/reasonCode note below)
///  - operator identity, timestamp, device ID, site ID, lane recorded
///  - duplicate logs prevented (unique index on idempotencyKey)
///  - can be linked to incidents or parking sessions when known
///  - submission success/failure clearly displayed (localSyncStatus)
@DataClassName('ManualGateLog')
class ManualGateLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordId => text().unique()();

  /// Sent to the backend to prevent duplicate submission of the same
  /// manual action (e.g. on retry after a dropped connection). Also
  /// enforced as unique locally so a retry can't even create a second
  /// local row in the first place.
  TextColumn get idempotencyKey => text().unique()();

  /// The backlog task phrasing is "require justification text OR reason
  /// code" — read as either/or. This schema requires free-text
  /// justification always, since it's guaranteed usable before the
  /// client's controlled vocabulary is confirmed, and treats reasonCode
  /// as an optional structured tag layered on top. Make reasonCode
  /// required instead, if the client wants it mandatory once confirmed.
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
  TextColumn get linkedTransactionId => text()
      .nullable()
      .references(ContinuityTransactions, #recordId)();
  TextColumn get linkedIncidentId => text().nullable()();
  TextColumn get linkedSessionId => text().nullable()();

  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Epic 9, User Story 2 — Override Request Workflow.
///
/// Important constraint from the acceptance criteria: "No supervisor
/// approval interface exists within the app." This table intentionally
/// has NO local approve/deny fields or workflow state beyond what the
/// backend reports back, read-only. Do not add an approval column here
/// without checking that requirement again first.
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

  /// Optional soft link to whatever transaction, manual action, or
  /// incident prompted the override. Not explicitly required by the AC
  /// text ("supporting context" is vague) — drop whichever of these
  /// aren't wanted.
  TextColumn get linkedTransactionId => text().nullable()();
  TextColumn get linkedManualLogId => text().nullable()();
  TextColumn get linkedIncidentId => text().nullable()();

  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  /// Backend-owned, read-only. "Read-only approval outcome is shown if
  /// returned by the backend." Plain nullable string for the same reason
  /// as Incidents.backendReconciliationStatus — vocabulary not yet
  /// confirmed, and this app must never write to it locally.
  TextColumn get backendStatus => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
