import 'dart:async';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  // Mock Device & Site Data
  final String deviceId = "MOPS-DEV-001";
  final String assignedSiteId = "MNT-A"; 
  final String siteGroupId = "MNT";

  // Mock Offline/Online State
  bool isOnline = false;

  // Recent Transactions History (Dashboard) - persists throughout the session
  final List<Map<String, String>> _history = [
    {'dateTime': '05/26/2026 - 8:30 PM', 'plate': 'AAO 2311'},
    {'dateTime': '05/26/2026 - 8:33 PM', 'plate': 'BAO 2501'},
    {'dateTime': '05/26/2026 - 8:47 PM', 'plate': 'LOL 2322'},
  ];

  // Sync Queue (Sync Screen) - cleared after syncing
  final List<Map<String, String>> _syncQueue = [
    {'dateTime': '05/26/2026 - 8:30 PM', 'plate': 'AAO 2311'},
    {'dateTime': '05/26/2026 - 8:33 PM', 'plate': 'BAO 2501'},
    {'dateTime': '05/26/2026 - 8:47 PM', 'plate': 'LOL 2322'},
  ];

  // Parking session summary data for the dashboard
  final List<Map<String, String>> _activeSessions = [
    {'dateTime': '05/26/2026 - 8:30 PM', 'plate': 'AAO 2311'},
    {'dateTime': '05/26/2026 - 8:33 PM', 'plate': 'BAO 2501'},
    {'dateTime': '05/26/2026 - 8:47 PM', 'plate': 'LOL 2322'},
  ];

  final List<Map<String, String>> _exitedSessions = [
    {'dateTime': '05/26/2026 - 7:10 PM', 'plate': 'XZY 5410'},
    {'dateTime': '05/26/2026 - 7:25 PM', 'plate': 'QWE 5678'},
  ];

  List<Map<String, String>> get history => List.unmodifiable(_history);
  List<Map<String, String>> get syncQueue => List.unmodifiable(_syncQueue);
  int get unsyncedRecords => _syncQueue.length;
  int get activeParkingSessions => _activeSessions.length;
  int get exitedParkingSessions => _exitedSessions.length;
  int get totalTransactions => activeParkingSessions + exitedParkingSessions;

  // Mock User Session
  String? currentUserRole;
  String? sessionToken;

  // Simulates validating the tablet during startup
  Future<bool> validateDeviceStatus() async {
    await Future.delayed(const Duration(seconds: 1)); 
    return true; 
  }

  // Simulates the login with dummy accounts
  Future<String?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); 

    if (username == 'operator' && password == 'password') {
      currentUserRole = 'Site Operator'; // Can do manual overrides
      sessionToken = 'mock_token_operator_123';
      return null; 
    } else if (username == 'merchant' && password == 'password') {
      currentUserRole = 'Merchant Operator'; // Restricted role
      sessionToken = 'mock_token_merchant_456';
      return null;
    }
    return 'Invalid credentials or Site Mismatch detected.';
  }

  void logout() {
    currentUserRole = null;
    sessionToken = null;
  }

  // Adds a new transaction to both history and sync queue
  void addTransaction(Map<String, String> transaction) {
    _history.insert(0, transaction);
    _syncQueue.insert(0, transaction);
  }

  // Clears only the sync queue
  Future<void> syncAll() async {
    await Future.delayed(const Duration(seconds: 2));
    _syncQueue.clear();
  }

  // Simulates saving a transaction locally when offline
  Future<bool> submitMockTransaction() async {
    if (!isOnline) {
      return true; 
    }
    await Future.delayed(const Duration(seconds: 1)); 
    return true; 
  }
}
