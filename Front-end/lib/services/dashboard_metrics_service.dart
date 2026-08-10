import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../database/app_database.dart';
import 'session_store.dart';

/// Backend (`projections.parking_sessions` summary) feeds the first 3
/// counters; local Drift feeds [pendingSync] -- two different sources, on purpose.
class DashboardMetrics {
  final int activeParkingSessions;
  final int vehiclesExited;
  final int totalTransactions;
  final int pendingSync;

  const DashboardMetrics({
    required this.activeParkingSessions,
    required this.vehiclesExited,
    required this.totalTransactions,
    required this.pendingSync,
  });
}

/// Thrown when the summary call fails (no session, unreachable backend,
/// etc.) so the dashboard can show a clear state instead of silently
/// displaying zeros.
class DashboardMetricsException implements Exception {
  final String message;
  DashboardMetricsException(this.message);
}

class DashboardMetricsService {
  final AppDatabase db;
  final http.Client httpClient;
  final Uri baseUrl;

  DashboardMetricsService({
    required this.db,
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<DashboardMetrics> load() async {
    final authHeader = SessionStore().authHeader;
    if (authHeader == null) {
      throw DashboardMetricsException('Your session has expired. Please log in again.');
    }

    final uri = baseUrl.replace(path: '/api/bcp/parking-sessions/summary');

    // Independent sources (backend summary, local pending count) -- fetched
    // concurrently rather than sequentially.
    final (json, pendingCount) = await (
      _fetchSummary(uri, authHeader),
      _fetchPendingCount(),
    ).wait;

    return DashboardMetrics(
      activeParkingSessions: (json['unpaidSessions'] as num).toInt(),
      vehiclesExited: (json['paidSessions'] as num).toInt(),
      totalTransactions: (json['totalSessions'] as num).toInt(),
      pendingSync: pendingCount,
    );
  }

  Future<Map<String, dynamic>> _fetchSummary(
      Uri uri, Map<String, String> authHeader) async {
    http.Response response;
    try {
      response = await httpClient.get(uri, headers: authHeader);
    } catch (_) {
      throw DashboardMetricsException(
          'Could not reach the server. Check your connection and try again.');
    }

    if (response.statusCode != 200) {
      throw DashboardMetricsException(
          'Could not load session summary (${response.statusCode}).');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<int> _fetchPendingCount() {
    return (db.selectOnly(db.continuityTransactions)
          ..addColumns([db.continuityTransactions.id.count()])
          ..where(db.pendingExitCheckoutFilter))
        .map((row) => row.read(db.continuityTransactions.id.count()) ?? 0)
        .getSingle();
  }
}
