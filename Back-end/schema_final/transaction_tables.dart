import 'package:drift/drift.dart';

import 'incident_tables.dart' show LocalSyncStatus, LocalSyncStatusConverter;

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// Epic 5, User Stories 1 & 2 — Continuity Transaction Capture / History.
///
/// This is the primary continuity-mode payment record: "capture
/// continuity-mode payment-related transaction evidence during service
/// disruptions so that operations may continue while preserving records
/// for later reconciliation and review." Everything in incident_tables.dart
/// and manual_operation_tables.dart has a `linkedTransactionId` pointing
/// (softly) at this table; this is the first place that ID actually
/// resolves to a real row.
///
/// SCHEMA STATUS: same caveat as [IncidentCategory] etc. elsewhere in this
/// project — this is our placeholder ahead of the client's schema, not a
/// confirmed design. The backlog task list mentions the app should
/// "consume the provided mock Payment Orchestrator interface for
/// continuity workflow simulation" — if/when that interface's field
/// shapes are available, check the payment-related columns below
/// (amountMinorUnits / currencyCode / paymentMethod) against it before
/// treating this as settled; those three are the least confident part of
/// this table.
///
/// THREE SEPARATE STATUS CONCEPTS — do not collapse these:
/// Epic 5's AC explicitly requires "sync status and backend lifecycle
/// status are displayed separately," and Epic 10 separately requires a
/// reconciliation status (Pending/Reconciled/Rejected/Disputed). That's
/// three distinct things, not two:
///   1. [localSyncStatus]           — ours, local upload queue state.
///   2. [backendLifecycleStatus]    — backend-owned, MoPS lifecycle state.
///   3. [backendReconciliationStatus] — backend-owned, reconciliation
///      outcome.
/// (2) and (3) are kept as separate nullable columns rather than one,
/// because the backlog task explicitly says local record state gets
/// "mapped to backend MoPS lifecycle state" as one step, and reconciliation
/// display is called out as a distinct, later concern in Epic 10. Collapsing
/// them into a single "backend status" column would make it impossible to
/// show both independently, which the AC requires.
@DataClassName('ContinuityTransaction')
class ContinuityTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// App-generated UUID. What the backend keys off of, and what
  /// [Incidents.linkedTransactionId], [ExceptionTags.linkedTransactionId],
  /// [ManualGateLogs.linkedTransactionId], and
  /// [OverrideRequests.linkedTransactionId] softly point to.
  TextColumn get recordId => text().unique()();

  /// Sent to the backend to prevent duplicate submission of the same
  /// transaction on retry (Epic 6, Offline Sync and Retry: "prevent
  /// duplicate resubmission using idempotency key"). Also unique locally
  /// for the same reason as the idempotency keys on ManualGateLogs /
  /// OverrideRequests.
  TextColumn get idempotencyKey => text().unique()();

  TextColumn get operatorId => text()();
  TextColumn get deviceId => text()();
  TextColumn get siteId => text()();
  TextColumn get lane => text()();

  /// When the transaction actually happened, as distinct from
  /// [createdAt] (when the local row was written). The split matters
  /// here specifically because Epic 6 requires offline capture: a
  /// transaction can be performed while offline and only written/synced
  /// later once connectivity returns, so these two timestamps can
  /// legitimately diverge.
  DateTimeColumn get occurredAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// PLACEHOLDER payment fields — see the class-level doc comment above.
  /// Stored as minor units (e.g. cents) rather than a float to avoid
  /// rounding issues; nullable because the mock Payment Orchestrator
  /// interface's actual field shape hasn't been confirmed against this
  /// yet.
  IntColumn get amountMinorUnits => integer().nullable()();
  TextColumn get currencyCode => text().nullable()();

  /// Free-text placeholder, not an enum — same reasoning as the other
  /// placeholder vocab in this project. Confirm against the mock Payment
  /// Orchestrator interface before locking this down.
  TextColumn get paymentMethod => text().nullable()();

  /// Reference/path to captured evidence. Epic 7 (Operational Evidence
  /// Capture) is its own not-yet-modeled epic/table; this column just
  /// reserves the slot the same way [Incidents.evidenceReference] does,
  /// so evidence has somewhere to point once that epic lands.
  TextColumn get evidenceReference => text().nullable()();

  TextColumn get notes => text().nullable()();

  /// Local upload/sync lifecycle. Always set and updated locally. See
  /// the class-level "three separate status concepts" note above.
  TextColumn get localSyncStatus =>
      text().map(const LocalSyncStatusConverter())();

  /// Backend-owned. Plain nullable string, not an enum, because the
  /// backend's MoPS lifecycle-state vocabulary isn't confirmed yet. This
  /// app should map local record state to this field for display only —
  /// never write an authoritative value here locally.
  TextColumn get backendLifecycleStatus => text().nullable()();

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
  TextColumn get backendReconciliationStatus => text().nullable()();

  /// When the local row was created — see [occurredAt] above for why
  /// this is kept separate.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
