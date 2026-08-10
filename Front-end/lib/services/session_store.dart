import '../models/auth_session.dart';

/// In-memory only -- JWT doesn't survive an app restart. Swap for
/// flutter_secure_storage before this goes beyond local testing.
class SessionStore {
  static final SessionStore _instance = SessionStore._internal();
  factory SessionStore() => _instance;
  SessionStore._internal();

  AuthSession? currentSession;

  bool get isLoggedIn => currentSession != null && !currentSession!.isExpired;

  // Null if there's no active (non-expired) session.
  Map<String, String>? get authHeader {
    final session = currentSession;
    if (session == null || session.isExpired) return null;
    return {'Authorization': 'Bearer ${session.token}'};
  }

  void clear() {
    currentSession = null;
  }
}
