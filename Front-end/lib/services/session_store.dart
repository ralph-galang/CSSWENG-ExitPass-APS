import '../models/auth_session.dart';

/// In-memory session storage, following the same singleton pattern
/// MockApiService used for currentUserRole/sessionToken. Fine for now;
/// swap for flutter_secure_storage before this app handles anything
/// beyond local testing, since the JWT currently doesn't survive an
/// app restart.
class SessionStore {
  static final SessionStore _instance = SessionStore._internal();
  factory SessionStore() => _instance;
  SessionStore._internal();

  AuthSession? currentSession;

  bool get isLoggedIn => currentSession != null && !currentSession!.isExpired;

  void clear() {
    currentSession = null;
  }
}
