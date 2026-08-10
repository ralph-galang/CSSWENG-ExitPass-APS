import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import 'session_store.dart';

/// Thrown when this service is called with no active (or an expired)
/// session -- distinct from [ParkingSessionNotFoundException] since this
/// is "you're not logged in," not "that ticket doesn't exist."
class NoActiveSessionException implements Exception {
  final String message;
  NoActiveSessionException(this.message);
}

/// Deliberately thin -- no rate/elapsed-time calc happens on-device for
/// this BCP flow; just enough to confirm a real, unpaid session.
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

/// Thrown when the backend has no matching session. The UI should
/// surface this distinctly from a network failure — a "not found" is a
/// real business outcome, not an offline condition to retry later.
class ParkingSessionNotFoundException implements Exception {
  final String message;
  ParkingSessionNotFoundException(this.message);
}

/// Backend already shows PAID -- distinct from
/// [TicketAlreadyRecordedException] below's local-duplicate case.
class ParkingSessionAlreadyPaidException implements Exception {
  final String message;
  ParkingSessionAlreadyPaidException(this.message);
}

/// Local not-yet-synced duplicate. Catches the case
/// [ParkingSessionAlreadyPaidException] can't: two lookups before either
/// syncs both see UNPAID from the backend.
class TicketAlreadyRecordedException implements Exception {
  final String message;
  TicketAlreadyRecordedException(this.message);
}

/// Two halves of exit-checkout: 1) look up session over the network
/// (never on-device), 2) record dummy payment strictly to local Drift.
/// Only touches `ContinuityTransactions`.
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

  /// Exactly one of [ticketNumber]/[qrPayload] is normal, but both are
  /// accepted for a scanned QR that also has a readable ticket number.
  Future<ParkingSessionLookupResult> lookupSession({
    String? ticketNumber,
    String? qrPayload,
  }) async {
    assert(ticketNumber != null || qrPayload != null,
        'Must supply a ticket number or QR payload to look up a session.');

    final authHeader = SessionStore().authHeader;
    if (authHeader == null) {
      throw NoActiveSessionException(
          'Your session has expired. Please log in again.');
    }

    final uri = baseUrl.replace(
      path: '/api/bcp/parking-sessions/lookup',
      queryParameters: {
        if (ticketNumber != null) 'ticketNumber': ticketNumber,
        if (qrPayload != null) 'qrPayload': qrPayload,
      },
    );

    final response = await httpClient.get(uri, headers: authHeader);

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
      throw ParkingSessionAlreadyPaidException(
          'Ticket ${result.ticketNumber} is already PAID for.');
    }

    // See TicketAlreadyRecordedException above -- this is the check it exists for.
    final existingLocal = await (db.select(db.continuityTransactions)
          ..where((t) => t.ticketNumber.equals(result.ticketNumber)))
        .getSingleOrNull();
    if (existingLocal != null) {
      final statusNote = existingLocal.localSyncStatus == LocalSyncStatus.synced
          ? 'and has already been synced'
          : 'and is awaiting sync';
      throw TicketAlreadyRecordedException(
          'Ticket ${result.ticketNumber} already has a transaction recorded on this device $statusNote.');
    }

    return result;
  }

  /// Dummy payment -- no rate/time calc on-device (out of scope). Succeeds
  /// offline; [ExitTransactionSyncService] syncs it back later.
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
