/// Backend connection settings for local development against the
/// Spring Boot backend started via `docker compose up -d` +
/// `./mvnw spring-boot:run -Dspring-boot.run.profiles=local`.
class ApiConfig {
  // Android emulator can't reach the host machine via `localhost` --
  // 10.0.2.2 is the emulator's alias for the host loopback interface.
  // - iOS simulator / macOS / Windows / Linux desktop / web: use localhost.
  // - Physical device on the same network: replace with your machine's
  //   LAN IP (e.g. 192.168.1.42) and make sure port 8080 is reachable.
  static const String baseUrl = 'http://10.0.2.2:8080';

  static const Duration requestTimeout = Duration(seconds: 10);
}

/// The MoPS handheld's device identity code, matching
/// identity.service_identities.service_identity_code in the backend
/// seed data (V2__seed_test_data.sql). Real device provisioning
/// (Backlog item 1) isn't built yet -- this hardcoded value is a
/// stand-in until then.
class DeviceConfig {
  static const String deviceCode = 'MOPS-DEVICE-TEST-001';
}
