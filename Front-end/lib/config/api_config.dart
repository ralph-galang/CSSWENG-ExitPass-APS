/// Backend connection settings for local development against the
/// Spring Boot backend started via `docker compose up -d` +
/// `./mvnw spring-boot:run -Dspring-boot.run.profiles=local`.
class ApiConfig {
  // 10.0.2.2 is the Android emulator's alias for host loopback.
  // iOS sim/desktop: use localhost. Physical device: use your LAN IP, port 8080 reachable.
  static const String baseUrl = 'http://10.0.2.2:8080'; // (Uncomment this if you want to use an Emulator)
  // static const String baseUrl = 'http://localhost:8080'; // (Uncomment this if you want to plain run, but you will need Developer Mode on)

  static const Duration requestTimeout = Duration(seconds: 10);
}

// Matches identity.service_identities.service_identity_code (V2 seed data).
// Hardcoded stand-in until real device provisioning (Backlog item 1) exists.
class DeviceConfig {
  static const String deviceCode = 'MOPS-DEVICE-TEST-001';

  // Hardcoded stand-in -- AuthSession has no lane field yet; real lane
  // selection isn't built. Matches sites.lanes.lane_code in the seed data.
  static const String lane = 'TEST-LANE-EXIT-01';
}
