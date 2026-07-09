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
  int unsyncedRecords = 3; 

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

  // Simulates saving a transaction locally when offline
  Future<bool> submitMockTransaction() async {
    if (!isOnline) {
      unsyncedRecords++;
      return true; 
    }
    await Future.delayed(const Duration(seconds: 1)); 
    return true; 
  }
}
