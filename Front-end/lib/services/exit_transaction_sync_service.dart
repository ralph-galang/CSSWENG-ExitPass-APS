import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../database/app_database.dart';

/// Per-item outcome the backend reports for a synced exit transaction.
class ExitTransactionSyncOutcome {
  final String idempotencyKey;
  final bool success;
  final String? errorMessage;

  ExitTransactionSyncOutcome({
    required this.idempotencyKey,
    required this.success,
    this.errorMessage,
  });

  factory ExitTransactionSyncOutcome.fromJson(Map<String, dynamic> json) {
    return ExitTransactionSyncOutcome(
      idempotencyKey: json['idempotencyKey'] as String,
      success: json['success'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Pushes locally-recorded exit transactions (`ContinuityTransactions` rows
/// with a non-null `ticketNumber`, still `LocalSyncStatus.pending`) to the
/// backend, which updates the corresponding `projections.parking_sessions`
/// row's `time_out` and `payment_status`.
///
/// Scope note: this only reads/writes `ContinuityTransactions` rows that
/// belong to the exit-checkout flow (i.e. have a `ticketNumber`). Other
/// pending continuity transactions (no ticket number — not a parking-
/// session exit) are left alone; syncing those is a different concern
/// outside this feature's scope.
class ExitTransactionSyncService {
  final AppDatabase db;
  final http.Client httpClient;
  final Uri baseUrl;

  /// Kept small and conservative rather than tuned — batch size isn't a
  /// requirement from the backlog task, just a reasonable default so a
  /// large backlog of offline transactions doesn't go up in one huge
  /// request.
  static const int _batchSize = 25;

  ExitTransactionSyncService({
    required this.db,
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Runs one sync pass: finds pending exit transactions, POSTs them in
  /// batches, and updates each row's `localSyncStatus` based on the
  /// backend's per-item result. Safe to call repeatedly (e.g. on
  /// connectivity-restored, or on a periodic timer) — already-synced rows
  /// are excluded by the query, and idempotency keys prevent the backend
  /// from double-applying a retried row.
  Future<void> syncPendingExitTransactions() async {
    final pendingRows = await (db.select(db.continuityTransactions)
          ..where((t) =>
              t.localSyncStatus.equals(LocalSyncStatus.pending.name) &
              t.ticketNumber.isNotNull()))
        .get();

    if (pendingRows.isEmpty) return;

    for (var i = 0; i < pendingRows.length; i += _batchSize) {
      final batch = pendingRows.sublist(
        i,
        i + _batchSize > pendingRows.length
            ? pendingRows.length
            : i + _batchSize,
      );
      await _syncBatch(batch);
    }
  }

  Future<void> _syncBatch(List<ContinuityTransaction> batch) async {
    final uri = baseUrl.replace(path: '/api/bcp/exit-transactions/sync');

    final payload = batch
        .map((row) => {
              'idempotencyKey': row.idempotencyKey,
              'ticketNumber': row.ticketNumber,
              'qrPayload': row.qrPayload,
              'occurredAt': row.occurredAt.toUtc().toIso8601String(),
              'amountMinorUnits': row.amountMinorUnits,
              'currencyCode': row.currencyCode,
              'paymentMethod': row.paymentMethod,
            })
        .toList();

    http.Response response;
    try {
      response = await httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'transactions': payload}),
      );
    } catch (_) {
      // Network failure (e.g. still offline) — leave rows as pending for
      // the next sync pass. Not marked as failed: failed implies the
      // backend rejected it, which we don't know here.
      return;
    }

    if (response.statusCode != 200) {
      // Backend/server error affecting the whole batch — same reasoning,
      // leave as pending and retry later rather than assuming per-row
      // failure.
      return;
    }

    final results = (jsonDecode(response.body)['results'] as List)
        .map((r) => ExitTransactionSyncOutcome.fromJson(r))
        .toList();

    for (final outcome in results) {
      final newStatus =
          outcome.success ? LocalSyncStatus.synced : LocalSyncStatus.failed;

      await (db.update(db.continuityTransactions)
            ..where((t) => t.idempotencyKey.equals(outcome.idempotencyKey)))
          .write(
        ContinuityTransactionsCompanion(
          localSyncStatus: Value(newStatus),
        ),
      );
    }
  }
}
