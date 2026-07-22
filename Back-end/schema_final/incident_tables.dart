import 'package:drift/drift.dart';

import 'transaction_tables.dart' show ContinuityTransactions;

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Controlled incident categories.
///
/// PLACEHOLDER VALUES. The client has not yet supplied the authoritative
/// controlled vocabulary for incident categories (backlog AC: "Users can
/// log incidents using predefined categories" / "do not invent ad hoc
/// statuses"). The values below reuse what already appears in the shipped
/// prototype's Manual Transaction reason dropdown (System Down, Power
/// Outage, Maintenance) plus a couple of generic additions so the schema
/// is usable now. Confirm the real list with the client before production
/// sign-off — changing these only means editing this enum and writing a
/// migration for any rows already stored under the old values.
enum IncidentCategory {
  systemDown,
  powerOutage,
  hardwareFailure,
  networkFailure,
  maintenance,
  other,
}

/// Controlled exception/reason codes used to tag a continuity record.
///
/// PLACEHOLDER VALUES — see [IncidentCategory] note above. Not yet
/// confirmed against the client's actual vocabulary.
enum ExceptionReasonCode {
  paymentMismatch,
  duplicateSubmission,
  sessionAmbiguous,
  tariffDiscrepancy,
  other,
}

/// Local (device-side) upload lifecycle for a record queued for sync.
///
/// This is intentionally separate from `backendReconciliationStatus` on
/// [Incidents] below. This enum is ours to define because it only
/// describes local queue state. The backend's reconciliation vocabulary
/// is a different, still-unresolved question (see that column's doc
/// comment) and must not be conflated with this one.
enum LocalSyncStatus {
  pending,
  synced,
  failed,
}

// ---------------------------------------------------------------------------
// TypeConverters
// ---------------------------------------------------------------------------
//
// Using explicit TypeConverters (rather than a newer Drift enum-column
// helper) deliberately, since it's been stable across Drift versions for a
// long time and doesn't risk a mismatch with whatever Drift version ends
// up resolved in this project.

class IncidentCategoryConverter
    extends TypeConverter<IncidentCategory, String> {
  const IncidentCategoryConverter();

  @override
  IncidentCategory fromSql(String fromDb) =>
      IncidentCategory.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(IncidentCategory value) => value.name;
}

class ExceptionReasonCodeConverter
    extends TypeConverter<ExceptionReasonCode, String> {
  const ExceptionReasonCodeConverter();

  @override
  ExceptionReasonCode fromSql(String fromDb) =>
      ExceptionReasonCode.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(ExceptionReasonCode value) => value.name;
}

class LocalSyncStatusConverter extends TypeConverter<LocalSyncStatus, String> {
  const LocalSyncStatusConverter();

  @override
  LocalSyncStatus fromSql(String fromDb) =>
      LocalSyncStatus.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(LocalSyncStatus value) => value.name;
}

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// Epic 8, User Story 1 — Incident Logging.
///
/// Acceptance criteria covered here:
///  - predefined categories only (IncidentCategory; no free text status)
///  - device ID, site ID, timestamp, evidence captured
///  - can be linked to an existing transaction
///  - incident history viewable after submission (query by recordId/time)
///  - backend reconciliation status displayed when available
@DataClassName('Incident')
class Incidents extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// App-generated UUID. This is what's sent to the backend and what
  /// "incident history is viewable after submission" keys off of.
  TextColumn get recordId => text().unique()();

  TextColumn get category => text().map(const IncidentCategoryConverter())();

  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();

  /// Not explicitly listed in Epic 8's acceptance criteria text, but kept
  /// for consistency with the rest of the continuity-record audit trail
  /// (every other table here captures operator identity). Drop it if the
  /// client's eventual schema handles operator attribution elsewhere.
  TextColumn get operatorId => text()();

  DateTimeColumn get occurredAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Real FK to [ContinuityTransactions.recordId], now that a placeholder
  /// transactions table exists. Stays nullable: an incident can happen
  /// with no transaction in play (e.g. a network outage logged before
  /// any continuity transaction was ever captured) — independent of a
  /// transaction, per Epic 8's design, unlike [ExceptionTags] below.
  TextColumn get linkedTransactionId => text()
      .nullable()
      .references(ContinuityTransactions, #recordId)();

  /// Reference/path to captured evidence (e.g. a photo). Evidence capture
  /// itself is a separate backlog item (Operational Evidence Capture) —
  /// this column just reserves the slot so "evidence is captured" has
  /// somewhere to point once that item exists.
  TextColumn get evidenceReference => text().nullable()();

  TextColumn get notes => text().nullable()();

  /// Local upload/sync lifecycle. Always set and updated locally.
  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

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
  TextColumn get backendReconciliationStatus => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Epic 8, User Story 2 — Exception Tagging.
///
/// "Exception information is submitted with the continuity record." Unlike
/// [Incidents], this table has no standalone use case — an exception tag
/// with nothing to tag isn't meaningful, so linkedTransactionId is
/// required, not nullable. Modeled as its own table (rather than a column
/// bolted onto the transaction table) so it stays independent of that
/// table's still-unknown shape and can hold more than one tag per
/// transaction if needed.
@DataClassName('ExceptionTag')
class ExceptionTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordId => text().unique()();

  /// Real, required FK to [ContinuityTransactions.recordId] — NOT
  /// nullable, unlike [Incidents.linkedTransactionId] and
  /// [ManualGateLogs.linkedTransactionId]. An exception tag only ever
  /// exists to classify a specific transaction; it has no standalone
  /// meaning without one, so (unlike the other two) it cannot be
  /// independent of a transaction.
  TextColumn get linkedTransactionId =>
      text().references(ContinuityTransactions, #recordId)();

  TextColumn get reasonCode =>
      text().map(const ExceptionReasonCodeConverter())();

  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();
  TextColumn get operatorId => text()();

  DateTimeColumn get taggedAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
