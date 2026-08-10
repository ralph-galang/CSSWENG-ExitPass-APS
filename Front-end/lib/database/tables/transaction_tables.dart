import 'package:drift/drift.dart';

import 'incident_tables.dart' show LocalSyncStatusConverter;

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// Epic 5 US1/2 — primary continuity-mode payment record. Everything in
/// incident_tables.dart/manual_operation_tables.dart softly points here
/// via linkedTransactionId.
///
/// THREE separate status concepts -- do not collapse: [localSyncStatus]
/// (ours), [backendLifecycleStatus] and [backendReconciliationStatus]
/// (both backend-owned, but distinct per Epic 5/10 AC) must stay separate columns.
@DataClassName('ContinuityTransaction')
class ContinuityTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// What Incidents/ExceptionTags/ManualGateLogs/OverrideRequests softly
  /// point to via linkedTransactionId.
  TextColumn get recordId => text().unique()();

  /// Prevents duplicate resubmission on retry (Epic 6) -- same reasoning
  /// as the other tables' idempotency keys.
  TextColumn get idempotencyKey => text().unique()();

  TextColumn get operatorId => text()();
  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();
  TextColumn get lane => text()();

  /// Distinct from [createdAt]: Epic 6 allows offline capture, so "when it
  /// happened" and "when it was written" can legitimately diverge.
  DateTimeColumn get occurredAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// v2 addition for BCP exit-checkout sync -- soft pointer to
  /// projections.parking_sessions (cross-DB, can't be a real FK).
  /// ticketNumber/qrPayload both nullable since not every transaction is a session lookup.
  TextColumn get ticketNumber => text().nullable()();

  TextColumn get qrPayload => text().nullable()();

  /// PLACEHOLDER payment fields, minor units to avoid float rounding. For
  /// BCP exit-checkout this is always a dummy fixed value.
  IntColumn get amountMinorUnits => integer().nullable()();
  TextColumn get currencyCode => text().nullable()();

  /// Free-text placeholder, not an enum — same reasoning as the other
  /// placeholder vocab in this project. Confirm against the mock Payment
  /// Orchestrator interface before locking this down.
  TextColumn get paymentMethod => text().nullable()();

  /// Reserves the slot for the not-yet-built Evidence Capture epic (same
  /// as [Incidents.evidenceReference]).
  TextColumn get evidenceReference => text().nullable()();

  TextColumn get notes => text().nullable()();

  /// Local upload/sync lifecycle. Always set and updated locally. See
  /// the class-level "three separate status concepts" note above.
  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  /// Backend-owned display-only field -- map local state to this, never
  /// write an authoritative value here.
  TextColumn get backendLifecycleStatus => text().nullable()();

  /// Backend-owned, not an enum -- BRD/backlog vocab still disagree (see
  /// [Incidents.backendReconciliationStatus]). Display only.
  TextColumn get backendReconciliationStatus => text().nullable()();

  /// When the local row was created — see [occurredAt] above for why
  /// this is kept separate.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

}
