import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../database/app_database.dart';
import 'session_store.dart';

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

/// Pushes pending `ContinuityTransactions` (with a `ticketNumber`) to the
/// backend, updating `parking_sessions.time_out`/`payment_status`. Ignores
/// non-exit-checkout pending rows (no ticketNumber).
class ExitTransactionSyncService {
  final AppDatabase db;
  final http.Client httpClient;
  final Uri baseUrl;

  /// Conservative default, not a backlog requirement -- avoids one huge
  /// request for a large offline backlog.
  static const int _batchSize = 25;

  ExitTransactionSyncService({
    required this.db,
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// One sync pass: finds pending rows, POSTs in batches, updates
  /// `localSyncStatus` per backend result. Safe to call repeatedly.
  Future<void> syncPendingExitTransactions() async {
    final pendingRows = await (db.select(db.continuityTransactions)
          ..where((_) => db.pendingExitCheckoutFilter))
        .get();

    if (pendingRows.isEmpty) return;

    // No active session -- leave everything as `pending` rather than
    // firing requests we already know will 403. The next sync pass
    // (e.g. after the operator logs back in) will pick these back up.
    if (!SessionStore().isLoggedIn) {
      return;
    }

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
        headers: {
          'Content-Type': 'application/json',
          ...?SessionStore().authHeader,
        },
        body: jsonEncode({'transactions': payload}),
      );
    } catch (_) {
      // Still offline -- leave as pending for next pass, not "failed"
      // (that would imply the backend rejected it).
      return;
    }

    if (response.statusCode != 200) {
      // Server/batch error -- leave whole batch pending rather than assume
      // per-row failure.
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
