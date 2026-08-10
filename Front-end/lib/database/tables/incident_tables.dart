import 'package:drift/drift.dart';

import 'transaction_tables.dart' show ContinuityTransactions;

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// PLACEHOLDER — client hasn't confirmed the real incident category vocabulary
/// (reused from the shipped prototype's dropdown). Confirm before production
/// sign-off; changing values means a migration for any existing rows.
enum IncidentCategory {
  systemDown,
  powerOutage,
  hardwareFailure,
  networkFailure,
  maintenance,
  other,
}

/// PLACEHOLDER — same caveat as [IncidentCategory], not yet confirmed
/// against the client's actual vocabulary.
enum ExceptionReasonCode {
  paymentMismatch,
  duplicateSubmission,
  sessionAmbiguous,
  tariffDiscrepancy,
  other,
}

/// Local-only queue state -- distinct from `backendReconciliationStatus` on
/// [Incidents] below, which is a separate, still-unresolved backend
/// vocabulary. Must not be conflated with this one.
enum LocalSyncStatus {
  pending,
  synced,
  failed,
}

// ---------------------------------------------------------------------------
// TypeConverters
// ---------------------------------------------------------------------------
//
// Explicit TypeConverters, not Drift's newer enum-column helper -- stable
// across Drift versions, avoids a version-mismatch risk.

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

/// Epic 8 US1 — Incident Logging: predefined categories, device/site/operator/
/// timestamp captured, optional transaction link, reconciliation status
/// displayed when available.
@DataClassName('Incident')
class Incidents extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// App-generated UUID. This is what's sent to the backend and what
  /// "incident history is viewable after submission" keys off of.
  TextColumn get recordId => text().unique()();

  TextColumn get category => text().map(const IncidentCategoryConverter())();

  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();

  /// Not in Epic 8's AC text, kept for audit-trail consistency with the
  /// other tables here.
  TextColumn get operatorId => text()();

  DateTimeColumn get occurredAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Real FK to [ContinuityTransactions.recordId]. Nullable -- an incident
  /// can exist independent of any transaction (Epic 8 design), unlike
  /// [ExceptionTags] below.
  TextColumn get linkedTransactionId => text()
      .nullable()
      .references(ContinuityTransactions, #recordId)();

  /// Reserves the slot for the not-yet-built Evidence Capture backlog item.
  TextColumn get evidenceReference => text().nullable()();

  TextColumn get notes => text().nullable()();

  /// Local upload/sync lifecycle. Always set and updated locally.
  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  /// Backend-owned, "displayed when available." Deliberately not an enum --
  /// the BRD and the approved backlog disagree on the vocabulary. This app
  /// only displays whatever the backend returns, never writes here locally.
  TextColumn get backendReconciliationStatus => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

}

/// Epic 8 US2 — Exception Tagging. Unlike [Incidents], has no standalone use:
/// linkedTransactionId is required, not nullable. Its own table (not a column
/// on the transaction table) so it can hold more than one tag per transaction.
@DataClassName('ExceptionTag')
class ExceptionTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordId => text().unique()();

  /// Required, unlike [Incidents.linkedTransactionId] and
  /// [ManualGateLogs.linkedTransactionId] -- an exception tag only ever
  /// exists to classify a specific transaction, so it can't be independent of one.
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

}
