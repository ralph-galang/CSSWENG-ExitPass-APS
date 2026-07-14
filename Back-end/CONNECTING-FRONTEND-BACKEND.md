# Connecting the Flutter MoPS App to the Spring Boot Backend (Local)

This wires the real `/api/v1/auth/login` endpoint into the Flutter app's
login screen, replacing `MockApiService` for that flow. Other screens
(dashboard, sync, manual transaction, etc.) still use hardcoded/mock
data and are unaffected — this pass only covers login.

## 1. Start the backend

Files go in your Spring Boot project at the paths shown (this bundle
mirrors that layout under `src/main/...`).

```bash
docker compose up -d
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
```

Flyway runs `V1__schema_subset_for_local_testing.sql` then
`V2__seed_test_data.sql` automatically. Confirm it's up:

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"operator1","password":"Operator@123","deviceCode":"MOPS-DEVICE-TEST-001"}'
```

Expect a 200 with a `token`, `user`, and `device` block. Try a wrong
password or a made-up `deviceCode` too — you should get 401s with
`INVALID_CREDENTIALS` / `UNRECOGNIZED_DEVICE`.

## 2. Update the Flutter project

Apply these on top of `CSSWENG-ExitPass-APS-main`:

- `pubspec.yaml` — added `http: ^1.2.2`
- `lib/config/api_config.dart` — new
- `lib/models/auth_session.dart` — new
- `lib/services/session_store.dart` — new
- `lib/services/auth_service.dart` — new
- `lib/screens/login_screen.dart` — modified (swapped `MockApiService` for `AuthService`)

Then:

```bash
flutter pub get
flutter run   # Android emulator by default
```

Log in with `operator1` / `Operator@123`. On the Android emulator this
talks to `10.0.2.2:8080`, which maps to your host machine's `localhost:8080`
— that's already set in `api_config.dart`. If you're running on a
physical device, iOS simulator, or desktop, see the comments in that
file for what to change.

## What this does and doesn't cover

**Covers:** real login against Postgres, bcrypt password verification,
device/site binding check, JWT issuance, role resolution, and a proper
`{errorCode, message, correlationId}` error response on failure.

**Doesn't cover yet:**
- Persisting the session across app restarts (currently in-memory only —
  swap in `flutter_secure_storage` before this goes beyond local testing)
- Attaching the JWT to subsequent requests (dashboard/sync/etc. don't
  call the backend yet, so there's nothing to attach it to)
- The dashboard/sync/manual-transaction screens still show hardcoded
  data — connecting those is separate follow-up work, not part of this pass

## Known mismatches worth resolving before this goes further

- `DeviceConfig.deviceCode` in Flutter is hardcoded to match the seed
  data (`MOPS-DEVICE-TEST-001`). Real device identity (Backlog item 1)
  should generate/provision this per-device rather than hardcode it.
- The backend's `AuthException` → HTTP status mapping is a first pass
  (`INVALID_CREDENTIALS`/`UNRECOGNIZED_DEVICE` → 401, everything else →
  400) — revisit once more error cases exist.
