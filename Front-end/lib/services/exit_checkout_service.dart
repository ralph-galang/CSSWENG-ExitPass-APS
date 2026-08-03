import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

/// Result of looking up a parking session in the backend's Projections DB.
///
/// Deliberately thin — the exit-checkout flow does NOT do any rate or
/// elapsed-time calculation on device (out of scope per the current
/// backlog task), so this only carries what's needed to confirm "yes,
/// this ticket resolves to a real, unpaid session" before taking a dummy
/// payment.
class ParkingSessionLookupResult {
  final String ticketNumber;
  final String? qrPayload;
  final String? plateNumber;
  final String paymentStatus; // 'UNPAID' | 'PAID', as returned by backend.

  ParkingSessionLookupResult({
    required this.ticketNumber,
    this.qrPayload,
    this.plateNumber,
    required this.paymentStatus,
  });

  factory ParkingSessionLookupResult.fromJson(Map<String, dynamic> json) {
    return ParkingSessionLookupResult(
      ticketNumber: json['ticketNumber'] as String,
      qrPayload: json['qrPayload'] as String?,
      plateNumber: json['plateNumber'] as String?,
      paymentStatus: json['paymentStatus'] as String,
    );
  }
}

/// Thrown when the backend has no matching session, or the session is
/// already PAID. The UI should surface this distinctly from a network
/// failure — a "not found" is a real business outcome, not an offline
/// condition to retry later.
class ParkingSessionNotFoundException implements Exception {
  final String message;
  ParkingSessionNotFoundException(this.message);
}

/// Handles the two halves of the "Exit Transactions and Sync" feature's
/// offline checkout step:
///   1. Look up the session in the backend's Projections DB (this is a
///      network call even in BCP mode — see the architecture note in
///      V3__add_projections_schema_simulation.sql; the Projections DB is
///      never mirrored on-device).
///   2. Record the (dummy) payment strictly to the local Drift DB, so the
///      operator can complete the exit even if the network drops between
///      steps 1 and 2.
///
/// Scope note: this class only touches `ContinuityTransactions`. It does
/// not read or write Incidents / ExceptionTags / ManualGateLogs /
/// OverrideRequests.
class ExitCheckoutService {
  final AppDatabase db;
  final http.Client httpClient;
  final Uri baseUrl;
  final Uuid _uuid = const Uuid();

  ExitCheckoutService({
    required this.db,
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Looks up a parking session by ticket number or QR payload.
  /// Exactly one of [ticketNumber] / [qrPayload] should normally be
  /// supplied (manual entry vs. scan), but both are accepted so a scanned
  /// QR that also encodes a human-readable ticket number can be checked
  /// either way.
  Future<ParkingSessionLookupResult> lookupSession({
    String? ticketNumber,
    String? qrPayload,
  }) async {
    assert(ticketNumber != null || qrPayload != null,
        'Must supply a ticket number or QR payload to look up a session.');

    final uri = baseUrl.replace(
      path: '/api/bcp/parking-sessions/lookup',
      queryParameters: {
        if (ticketNumber != null) 'ticketNumber': ticketNumber,
        if (qrPayload != null) 'qrPayload': qrPayload,
      },
    );

    final response = await httpClient.get(uri);

    if (response.statusCode == 404) {
      throw ParkingSessionNotFoundException(
          'No parking session found for the given ticket/QR.');
    }
    if (response.statusCode != 200) {
      throw Exception(
          'Session lookup failed (${response.statusCode}): ${response.body}');
    }

    final result =
        ParkingSessionLookupResult.fromJson(jsonDecode(response.body));

    if (result.paymentStatus == 'PAID') {
      throw ParkingSessionNotFoundException(
          'This session is already marked PAID.');
    }

    return result;
  }

  /// Records the exit transaction locally. This is intentionally a dummy
  /// payment — no rate or elapsed-time calculation happens here, per the
  /// current scope of this feature. [amountMinorUnits] and
  /// [paymentMethod] can be hardcoded/fixed values from the caller (e.g.
  /// a flat "dummy payment" constant) rather than computed.
  ///
  /// Saving succeeds even with no network connectivity — sync back to the
  /// Projections DB happens separately, later, via
  /// [ExitTransactionSyncService].
  Future<void> recordExitCheckout({
    required String operatorId,
    required String deviceId,
    required String siteId,
    required String lane,
    required String ticketNumber,
    String? qrPayload,
    required int amountMinorUnits,
    required String currencyCode,
    required String paymentMethod,
  }) async {
    final recordId = _uuid.v4();
    final idempotencyKey = _uuid.v4();

    await db.into(db.continuityTransactions).insert(
          ContinuityTransactionsCompanion.insert(
            recordId: recordId,
            idempotencyKey: idempotencyKey,
            operatorId: operatorId,
            deviceId: deviceId,
            siteId: siteId,
            lane: lane,
            ticketNumber: Value(ticketNumber),
            qrPayload: Value(qrPayload),
            amountMinorUnits: Value(amountMinorUnits),
            currencyCode: Value(currencyCode),
            paymentMethod: Value(paymentMethod),
            localSyncStatus: LocalSyncStatus.pending,
          ),
        );
  }
}
