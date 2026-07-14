import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/auth_session.dart';
import 'session_store.dart';

/// Real backend-backed replacement for MockApiService's login flow.
/// Keeps the same `Future<String?> login(...)` contract (null = success,
/// non-null = error message to show) so LoginScreen barely has to change.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SessionStore _sessionStore = SessionStore();

  String get deviceId => DeviceConfig.deviceCode;

  Future<String?> login(String username, String password) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/login');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'deviceCode': DeviceConfig.deviceCode,
            }),
          )
          .timeout(ApiConfig.requestTimeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        _sessionStore.currentSession = AuthSession.fromJson(body);
        return null;
      }

      // Backend error envelope: { errorCode, message, correlationId }
      return (body['message'] as String?) ?? 'Login failed.';
    } on SocketException {
      return 'Cannot reach the server. Check your connection and try again.';
    } on FormatException {
      return 'Unexpected response from the server.';
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  void logout() {
    _sessionStore.clear();
  }
}
