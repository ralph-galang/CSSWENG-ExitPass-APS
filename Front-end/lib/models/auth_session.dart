class AuthSession {
  final String token;
  final DateTime expiresAt;
  final String userId;
  final String username;
  final String displayName;
  final String role; // role_code, e.g. SITE_OPERATOR
  final String deviceCode;
  final String siteCode;
  final String siteName;

  AuthSession({
    required this.token,
    required this.expiresAt,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.role,
    required this.deviceCode,
    required this.siteCode,
    required this.siteName,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final device = json['device'] as Map<String, dynamic>;
    return AuthSession(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      userId: user['userId'] as String,
      username: user['username'] as String,
      displayName: user['displayName'] as String,
      role: user['role'] as String,
      deviceCode: device['deviceCode'] as String,
      siteCode: device['siteCode'] as String,
      siteName: device['siteName'] as String,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
