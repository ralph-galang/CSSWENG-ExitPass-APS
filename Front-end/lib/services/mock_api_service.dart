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

  List<Map<String, String>> get history => List.unmodifiable(_history);

  // Mock User Session
  String? currentUserRole;

  void logout() {
    currentUserRole = null;
  }

  // Adds a new transaction to history
  void addTransaction(Map<String, String> transaction) {
    _history.insert(0, transaction);
  }
}
