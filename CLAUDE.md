# CLAUDE.md — ExitPass MoPS

*Context file for Claude Code. Read this before making changes. It merges project domain/architecture knowledge with hands-on findings from real debugging and live-validation sessions. Where sources conflicted, both are shown — verify against actual source files rather than assuming either account is exactly right (see §10, Known Doc Conflicts).*

**Current status: MVP reached and live-validated end to end.** Both Ticket Transactions and Operational Logs work as designed, confirmed via direct low-level inspection of both databases simultaneously (ticket lookup → local capture → sync → Postgres update → dashboard metrics update, all observed live). See §11 for what was fixed to get there and what's now confirmed working.

## Companion Documents

This file covers durable architecture, data model, and conventions — it deliberately does **not** duplicate click-by-click setup or testing steps. For that:
- **`ExitPass_BCP_Mode_Setup_and_Testing_Guide.md`** — the canonical, step-by-step guide for getting the project running locally and manually validating both features end to end, including exact DB-inspection tooling and sample data to use. Consult this for "how do I run/test this," not this file.

Prior working-session source material already folded into this file: `ExitPass_Overview_Chat_Summary.md`, `merge-test-debugging-summary.md`, `ExitPass_BCP_Mode_Session_Summary.md`. `ExitPass_CLAUDE_MD_Session_Summary.md` is a historical record of an earlier update to this file, kept for reference, not something that needs re-reading for day-to-day work.

---

## 1. What This Project Is

**ExitPass MoPS (Mobile Operations System)** is a capstone project: a **Business Continuity Plan (BCP) fallback device application** for parking exit operations. It's what an operator uses when a parking facility's normal Central PMS becomes unreachable.

This is **not** the customer-facing ExitPass app, and **not** the full ExitPass platform described in the BRD (no Central PMS, Vendor PMS adapters, Payment Orchestrator, coupon/wallet system, statutory discounts, or live gate control are being built here). Actual scope, per the Scope of Work and client-approved Product Backlog: an Android application that lets an operator keep processing vehicle exits and capturing payment evidence while the primary system is down, then sync that evidence back once possible.

**Mental model (client's own words):** the client's Central DB replicates into a "Projections DB" every minute. When BCP mode activates and Central DB is unreachable, this app lets the operator keep working off the Projections DB, capture activity locally on-device, and reconcile it back — using **only** the terms `unsynced` and `synced`. No richer reconciliation vocabulary exists anywhere in this workflow.

---

## 2. Source-of-Truth Hierarchy

Project documents disagree with each other at points. In descending order of authority:

1. **Direct, recent client meeting clarifications** (verbal, relayed by the team) — highest authority, especially when contradicting something written.
2. **The approved Product Backlog** — what production work is actually scoped/estimated.
3. **The client-provided Postgres schema dump** (`exitpass-database.sql`, 2026-07-09) — real/sound for `identity`/`sites`; client has confirmed it's outdated/incomplete for ticket/parking-session data. RBAC role definitions and Payment APIs were never provided.
4. **The BRD (v1.2)** — good for domain vocabulary and full-platform shape, but has internal inconsistencies and describes mechanisms (e.g. cached on-device tariff logic) that don't match what the client has since described verbally for this project specifically.
5. **Original project context notes** — describe an earlier, different concept (a normal-operations cashier-style exit terminal) that predates BCP/continuity scoping. Superseded for workflow; still fine for general Flutter style conventions.

**Rule:** when sources disagree, follow the most recent/most specific one, and flag the conflict — don't silently pick a side.

**Extend this hierarchy for Claude Code work:** the actual source code on disk is ground truth for implementation details (exact table/column names, current method signatures, etc.) even when project docs describe something slightly different. Docs win for *intent and business rules*; code wins for *current implementation state*. If they diverge, flag it rather than guessing.

---

## 3. Architecture

```
Flutter App (device/emulator)                    Spring Boot Backend (API only, no storage of its own)
  ⇄ JWT / HTTP ⇄
  Local Drift DB (SQLite, on-device)              PostgreSQL (Docker container, reachable ONLY via backend)
    - Incidents                                     identity.*        (real, client-provided)
    - ExceptionTags                                 sites.*           (real, client-provided)
    - ManualGateLogs / OperationalLogs               reconciliation.*  (real, flagged — see §10)
    - OverrideRequests                              projections.*     (SIMULATED, ours — stand-in for
    - ContinuityTransactions                                          client's real Projections DB)
```

**Critical points:**
- Parking session / ticket data (the "Projections DB") is a **server-side** concern — Central DB replicating to a Projections DB is server-to-server replication. The operator's app reaches it over the network via the backend, even when Central PMS specifically is down. It is deliberately **not** stored in the local Drift database.
- Only records the operator actually creates on-device — Incidents, Exceptions, Manual Gate Logs, Override Requests, ContinuityTransactions — live locally.
- **The Flutter app never talks to Postgres directly.** It only calls the Spring Boot backend over HTTP; the backend is the only thing that queries Postgres. Both the Docker container *and* the `mvn spring-boot:run` process must be running simultaneously, or the app can't reach the database at all.
- **Operational Logs (Incidents / Manual Gate Logs) are 100% local.** There is no server-side implementation — no tables, no endpoints for them. The nullable `manual_gate_log_id` / `incident_record_id` columns in `reconciliation.mops_transaction_records` are unused placeholder FK columns reserved for future linkage, not an actual implementation. Don't assume backend endpoints exist for these just because the columns do.
- **Ticket transactions span both tiers:** the parking session lookup happens over the network against Postgres (`projections.parking_sessions`); the resulting continuity transaction is then saved locally in Drift, soft-linked back to the session **only by `ticketNumber` (a string), not a stable ID** — confirmed, not just assumed.
- **Every backend endpoint except `/api/v1/auth/login` requires `Authorization: Bearer <token>`** (`SecurityConfig` also carves out `/actuator/health`, though no reachable endpoint at that path has actually been confirmed — the login curl in §9 is the real health check in practice). A real bug traced to this exact requirement — see §11.1.
- **Three independent tiers, three independent failure modes:** Flutter app →(HTTP, `10.0.2.2:8080`)→ Spring Boot backend →(JDBC, `localhost:5432`)→ Postgres in Docker. Even fully local, these are three separate processes over real network sockets, each independently startable/stoppable and each failing in its own distinct way — when debugging, check each tier separately rather than assuming the failure is in the one you're currently looking at.

---

## 4. Local Data Model — Drift/SQLite

Files: `Front-end/lib/database/tables/*.dart`, wired together in `Front-end/lib/database/app_database.dart`.

### `Incidents`
Operator note for anything happening near the site — power outage, flooding, fire, system/hardware/network failure. **Independent of any transaction** (confirmed by client — can exist with nothing else happening).

| Column | Notes |
|---|---|
| `id` | local autoincrement PK |
| `recordId` | app-generated UUID, used for correlation/sync |
| `category` | `IncidentCategory` enum, controlled list |
| `deviceId`, `siteId`, `operatorId` | attribution |
| `occurredAt` | defaults to now |
| `linkedTransactionId` | nullable — soft reference to transaction |
| `evidenceReference` | reserved slot for photo evidence (Epic 7, not yet built) |
| `notes` | free text |
| `localSyncStatus` | `unsynced` / `synced` |
| `createdAt` | bookkeeping |

### `ExceptionTags`
Classification attached to a transaction explaining why ticket/session lookup failed. **Always requires a transaction** — "exceptions by definition are the metadata" (client-confirmed).

| Column | Notes |
|---|---|
| `id` | local autoincrement PK |
| `recordId` | app-generated UUID |
| `linkedTransactionId` | **required**, not nullable |
| `reasonCode` | `ExceptionReasonCode` enum, controlled list |
| `deviceId`, `siteId`, `operatorId` | attribution |
| `taggedAt` | defaults to now |
| `localSyncStatus` | `unsynced` / `synced` |

### `ManualGateLogs`
"Opened the gate manually at this time" report. **Independent of any transaction**, same reasoning as Incidents.

| Column | Notes |
|---|---|
| `id` | local autoincrement PK |
| `recordId` | app-generated UUID |
| `idempotencyKey` | unique, prevents duplicate submission on retry |
| `justificationText` | required free text |
| `reasonCode` | `ManualActionReasonCode`, nullable — optional structured tag on top of free text |
| `operatorId`, `deviceId`, `siteId`, `lane` | attribution |
| `performedAt` | defaults to now |
| `linkedTransactionId`, `linkedIncidentId`, `linkedSessionId` | all nullable soft references |
| `localSyncStatus` | `unsynced` / `synced` |

### `OverrideRequests`
⚠️ **Scope not reconfirmed with client** (not mentioned in the client's latest "3 tables" recap — Incidents, Exceptions, Manual Gate Actions). Kept in schema, not deleted, pending confirmation.

Submits justification for an exceptional action requiring approval. **No local approve/deny logic on purpose** — approval happens entirely on the backend; the app only displays whatever outcome comes back, read-only.

### `ContinuityTransactions` table
**Confirmed name** — this table was historically referred to as "`Transactions`"/`exitId` in project documentation (PROJECT-STATUS.md/BRD-derived summaries), but that was outdated doc language. `ContinuityTransactions` is the real class/table name in the actual Drift source (`Front-end/lib/database/`, generated into `app_database.g.dart`). **Docs have been updated to match code, not the other way around** — do not rename the Dart class/table back to `Transactions`.

The actual exit/payment event (Epic 5 / BCP exit-sync work).

| Column | Notes |
|---|---|
| `id` | local autoincrement PK |
| `exitId` | app-generated UUID — "Exit ID," used instead of session ID because the abnormal case has no session to borrow one from *(verify this still exists under this name — see note below)* |
| `idempotencyKey` | unique |
| `linkedParkingSessionId` | nullable. Set = normal case, points at a row in the *backend's* `projections.parking_sessions`. Null = abnormal case |
| `ticketNumber`, `plateNumber` | what the operator actually entered |
| `qrPayload` | added in schema v2, specifically for the BCP exit-sync workflow — confirmed present per the hands-on debugging pass |
| `amountCollected` | required |
| `paymentMethod` | plain string, not an enum — vocabulary not confirmed (cash-only assumed) |
| `operatorId`, `deviceId`, `siteId`, `lane` | attribution |
| `exitTimestamp` | defaults to now — becomes the linked session's `time_out` once synced |
| `linkedExceptionId` | populated in the abnormal case, by convention (not DB-enforced) |
| `linkedIncidentId`, `linkedManualGateActionId` | fully optional in either case |
| `localSyncStatus` | `unsynced` / `synced` |

**Note:** the column list above blends the older doc-derived field names (`exitId`, `amountCollected`, etc.) with the confirmed additions (`ticketNumber`, `qrPayload`). Only the table name and the presence of `ticketNumber`/`qrPayload` have been directly confirmed against the real schema so far — treat individual column names beyond those as still doc-derived until checked against `app_database.g.dart` (search for `class ContinuityTransactionsTable` / `ContinuityTransactionsCompanion`).

**Why no real Drift foreign keys:** `Incidents`/`ManualGateLogs` optionally link to Transactions, and Transactions optionally links back to `Incidents`/`ExceptionTags`/`ManualGateLogs` — a genuine circular reference. Enforcing real FK constraints requires a specific two-phase insert order not yet built. All cross-table references are plain soft (unconstrained) columns, consistently, rather than mixing real and soft ones.

**Confirmed duplicate-ticket guard (local):** before recording a new transaction, `lookupSession()` now checks Drift for an existing `ContinuityTransactions` row with that same `ticketNumber` — **regardless of whether it's already synced or not** — and throws `TicketAlreadyRecordedException` if found, with a message naming the ticket. This exists because the backend-only check (session already `PAID`) misses the case where two lookups happen locally before either has synced. See §11.2 for how this was found and fixed; don't remove or weaken this check without replacing it with something equivalent.

---

## 5. Backend Data Model — PostgreSQL

Files: `Back-end/src/main/resources/db/migration/V1__..sql` through `V4__..sql`. Managed by Flyway.

### Real, client-provided (2026-07-09 dump)
- **`identity`** — `users`, `user_credentials` *(NOT in the real dump — added locally as a stopgap so JWT login can be exercised end-to-end; flagged for a real decision on whether production auth should use a `credential_reference`/external-IdP pattern instead)*, `roles`, `permissions`, `role_permissions`, `user_roles`, `service_identities`.
- **`sites`** — `site_groups`, `sites`, `lanes`, `device_assignments`.
- **`reconciliation`** — `mops_transaction_records`. ⚠️ Flagged: its status enum (`RECORDED`/`IMPORTED`/`PENDING_RECONCILIATION`/etc.) doesn't match the client's confirmed `unsynced`/`synced`-only vocabulary, and its FK direction (transaction → incident/manual-log) contradicts the client's verbal description (incident/manual-log → transaction) for the local schema. Also contains unused placeholder `manual_gate_log_id` / `incident_record_id` columns — no actual server-side Operational Logs implementation exists behind them.

### Simulated, ours (real schema never provided)
- **`projections.parking_sessions`** (`V3`/`V4`) — stand-in for the client's real Projections DB, good enough to test the full lookup → pay → sync workflow. **Not** a claim about the real Projections DB's actual columns. Kept in its own schema so it's visually obvious which parts are real vs. invented.

### Confirmed working endpoints
- `POST /api/v1/auth/login` — see §8 for credentials/device code.
- `GET /api/bcp/parking-sessions/summary` (`BcpExitTransactionController`, new) — returns `unpaidSessions`, `paidSessions`, `totalSessions` (the latter computed as the sum of the first two, so `active + exited == total` holds by construction, not by coincidence). Backed by `ParkingSessionRepository.countByPaymentStatus(...)` and `ParkingSessionSummaryResponse`. Powers the Dashboard's three live top metrics. Requires the `Authorization` header like everything else — see §11.1 for why that matters here specifically.
- Ticket lookup and sync (exact route paths not yet documented here) — handled by `ExitCheckoutService.lookupSession()` and `ExitTransactionSyncService`'s sync call on the frontend; both now correctly attach the auth header (see §11.1).

---

## 6. Application Flow

1. **BCP mode activates.**
2. **A car wants to exit** — becomes a Transaction.
3. **Case 1 — Normal:**
   - Ticket intact (readable QR or ticket number).
   - Operator looks up the ticket/QR against the Projections DB (live network call to backend, not a local read). Payment computed from elapsed time × rate.
   - Driver pays, exits. Transaction stored locally (`linkedParkingSessionId` set, `localSyncStatus = unsynced`).
   - Operator presses **Sync** → backend's `projections.parking_sessions` row gets `time_out` + `payment_status = PAID`. **Confirmed live end to end**, including the Dashboard's Active/Exited metrics updating immediately after (e.g. 50/0 → 49/1) — this is no longer just designed behavior, it's been observed working. See §11.3.
4. **Case 2 — Abnormal:**
   - Ticket cannot be looked up (lost, torn, unreadable).
   - Operator falls back to **Manual Transaction** entry — this *is* what creates an Exception (operator chooses the exception type as part of this flow).
   - Driver fined per policy. Transaction stored with `linkedParkingSessionId = null`, `linkedExceptionId` set.
5. **Optional, either case:** operator can attach an already-logged (or newly-logged) Incident or Manual Gate Action to this specific exit — separate from Incidents/Manual Gate Actions being recordable fully independently at any other time.

---

## 7. Controlled Vocabularies

| Enum | Values | Status |
|---|---|---|
| `LocalSyncStatus` | `unsynced`, `synced` | **Confirmed** — client explicitly retired "reconciliation" terminology |
| `IncidentCategory` | `powerOutage`, `flooding`, `fire`, `systemDown`, `networkFailure`, `hardwareFailure`, `maintenance`, `other` | Concept confirmed; exhaustive list still placeholder |
| `ExceptionReasonCode` | `tornTicket`, `lostTicket`, `unreadableTicketNumber`, `unreadableQrCode`, `other` | Concept confirmed; exhaustive list still placeholder |
| `ManualActionReasonCode` | `systemDown`, `powerOutage`, `maintenance`, `networkOutage`, `other` | **Not separately confirmed** — reused from shipped prototype's dropdown |
| `SessionPaymentStatus` (Postgres) | `UNPAID`, `PAID` | Ours, simulation-only |

---

## 8. Tech Stack

| Layer | Choice | Status |
|---|---|---|
| Frontend | Flutter / Dart | ✓ |
| Backend | Spring Boot, Java 21, Spring Boot 3.3.4 | ✓ |
| Local DB | Drift (over `sqlite3`/native FFI) | ✓ — chosen over plain `sqflite`/Room for type-safe schema, reactive queries, and multi-table coherence |
| Backend DB | PostgreSQL 16 | ✓ — Drift is the on-device tier, Postgres is the server tier; different jobs, not competing choices |
| Auth | JWT | ✓ — working end-to-end |
| Local dev orchestration | Docker (Postgres only) | Partial — no Dockerfile yet for the Spring Boot app itself |

**Login mechanism — important:** there are two "login" code paths in the frontend. `MockApiService.login()` is **dead code**, never called by `login_screen.dart`, purely in-memory. The real path is `AuthService.login()` → `POST /api/v1/auth/login` → device/site validation → credential check → JWT issuance. Don't confuse the two when debugging auth.

**Working test credentials** (seeded via `V2__seed_test_data.sql`, documented in `Back-end/README-TEST-DATA.md`):
- `operator1` / `Operator@123` — Site Operator role
- `supervisor1` / `Supervisor@123` — Site Supervisor role
- Real login requires `deviceCode: "MOPS-DEVICE-TEST-001"` for device-binding validation (`DeviceValidationService`) — already hardcoded correctly in `api_config.dart`.

---

## 9. Running the Project Locally

Three processes must run **simultaneously**, in separate terminals:

```bash
# 1. Docker (Postgres) — persists in background once started
cd Back-end
docker compose up -d
docker compose ps        # wait for "healthy", not just "running"

# 2. Backend — must stay running in its own terminal, dies if closed
mvn spring-boot:run -Dspring-boot.run.profiles=local
# (local profile is already the default, but keep the flag explicit)

# 3. Frontend
cd ../Front-end
flutter pub get
# dart run build_runner build --delete-conflicting-outputs   # only if schema changed
flutter run   # or use Android Studio's ▶ Run button targeting an emulator
```

**Sanity check before touching Flutter at all** — verify the backend independently:
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"operator1","password":"Operator@123","deviceCode":"MOPS-DEVICE-TEST-001"}'
```
A 200 response with a `token` confirms Docker + migrations + backend are all healthy — isolates any remaining issue to the Flutter side. No `/actuator/health` endpoint exists, so this curl call is the standard health check.

**Android emulator networking gotcha:** `api_config.dart` points at `10.0.2.2:8080`, not `localhost` — the emulator's special alias for the host machine. Change this for a physical device (use LAN IP) or desktop (use `localhost`).

### Seed data behavior
- **Flyway migrations (`V1`–`V4`)** run **once ever**, tracked per Docker volume — only re-run after `docker compose down -v` (wipes the volume).
- **`ProjectionsDbSeeder`** (`@Profile("local")`) runs on **every backend startup**: wipes `projections.parking_sessions` completely, re-inserts exactly 50 rows.

| Deterministic every run | NOT deterministic |
|---|---|
| Row count: 50 | Primary key `id` (`UUID.randomUUID()`) |
| Ticket numbers: `TCK-TEST-001`–`050` | `timeIn` / `createdAt` / `updatedAt` (real "now" at restart) |
| QR payloads: `QR-TCK-TEST-XXX` | |
| Plate numbers: `SEED 0001`–`0050` | |
| Site: always `TEST-SITE-01` | |
| Payment status: always `UNPAID` | |

V4's original seed tickets (`TCK-000001`–`003`) get wiped by the seeder the first time the backend ever starts — don't expect to find them after the app has run at least once. If the team wants automatic reset-and-reseed as a distinct behavior from "seed once ever," that needs a separate, explicitly `local`-profile-gated mechanism — not yet built.

**Known, accepted local/remote mismatch:** because the seeder wipes Postgres on *every* backend restart but Drift persists indefinitely, a ticket synced in one backend session will show as fresh/`UNPAID` again after a restart — while the device still "remembers" processing it, and the duplicate-ticket guard (§4) will block re-testing that same ticket number. This is resolved manually via Flutter DevTools' Drift "Clear database" button (§15), not automatic reconciliation — a deliberate choice, not an oversight (see §16.5).

---

## 10. Known Doc Conflicts / Things to Verify Against Actual Code

Flag these rather than silently resolving — check the real source files before assuming either description:

1. ~~Local transaction table naming~~ — **RESOLVED.** Earlier project-status-level docs referred to a `Transactions` table with `exitId` as PK identifier. That was outdated documentation language. The confirmed real name, taken from the actual Drift source/generated code, is **`ContinuityTransactions`**. This CLAUDE.md has been updated throughout to use the confirmed name — do not reintroduce `Transactions` as a class/table name in code based on older docs.
2. `qrPayload` field — confirmed present, added in schema v2 for the BCP exit-sync workflow. Column-level detail beyond `ticketNumber`/`qrPayload` (e.g. exact naming of `exitId`, `amountCollected`, etc.) is still doc-derived and not yet individually confirmed against `app_database.g.dart` — cheap to verify by searching that generated file for `ContinuityTransactionsTable`/`ContinuityTransactionsCompanion`.
3. **`reconciliation.mops_transaction_records`** — status enum and FK direction don't match the client's confirmed local model; not yet reconciled either way with the client.
4. **BRD §9.19.3** describes MoPS devices computing `amount_due` from cached on-device tariff logic — contradicts the client's actual described Projections DB mechanism (a live-ish replicated read source, not a device-side cache). Worth a BRD update, not yet done.
5. ~~`Back-end/schema_final/`~~ — **RESOLVED.** A repo-wide reference check confirmed zero references anywhere, consistent with it being dead, superseded draft code rather than an intentional minimal-schema replacement for `Front-end/lib/database/`. Safe to delete — see §16.1.

---

## 11. Recently Fixed Issues & Confirmed Live Features — Do Not Reintroduce

Two genuine, pre-existing code defects (unrelated to any merge — both present since `bcp-exit-sync` was first written) were found and fixed while getting the app to a live-validated MVP state. Documented here so they don't get silently reintroduced.

### 11.1 Missing JWT on ticket-related API calls
`SecurityConfig` requires a valid `Authorization: Bearer <token>` on every endpoint except `/api/v1/auth/login` (and, per config, `/actuator/health`). Both `ExitCheckoutService.lookupSession()` and `ExitTransactionSyncService`'s sync call were sending **no Authorization header at all**, so every ticket lookup and sync attempt always returned `403 Forbidden` — confirmed by reproducing the exact same rejection via a direct `curl`.

**Fix:** both services now attach `Authorization: Bearer ${SessionStore().currentSession.token}`. A new `NoActiveSessionException` gives a clear "please log in again" message instead of a misleading generic network-error string when there's no active session. **Any new service call to the backend must include this header** — it is not automatic/global yet.

### 11.2 Duplicate local transactions for the same ticket
The existing guard only checked whether the *backend* already showed a session as `PAID`. Two lookups on the same ticket, both happening before either syncs, both see `UNPAID` from Postgres — so nothing stopped a second local capture of the same ticket.

**Fix:** see §4's `ContinuityTransactions` section — a local Drift check now blocks this via `TicketAlreadyRecordedException`, checked before a duplicate can ever be recorded.

### 11.3 Dashboard and Sync screen: from mock to live
Both the Dashboard's three top metrics and the Sync Transactions screen were originally driven entirely by `MockApiService` hardcoded data, disconnected from real state. Now:
- **Backend:** `GET /api/bcp/parking-sessions/summary` (see §5) provides real counts.
- **Frontend:** new `DashboardMetricsService` fetches that summary and separately queries local Drift for the pending-sync count; `dashboard_screen.dart` shows live data with loading/error states, refreshes automatically on return from the Sync screen, and has pull-to-refresh as a manual fallback; `sync_transactions_screen.dart` is fully rewired off real pending `ContinuityTransactions` rows (not `MockApiService.syncQueue`), and re-queries after sync rather than assuming success; `ticket_detail_screen.dart`'s previously-misleading "will sync automatically" message was corrected to describe the actual (correct) local-only-until-manual-sync behavior.

**Confirmed live:** processing and syncing one ticket correctly moved the dashboard from 50/0 (Active/Exited) to 49/1, Total holding steady at 50 — observed directly, not just expected from the code.

**Remaining mock data, not yet addressed:** the Dashboard's separate **"Recent Transactions"** section (below the live metrics) is still `MockApiService`-driven — distinct from the Sync screen's list, which is real. See §12.

---

## 12. Known Limitations & Deliberate Simplifications

- **Flat-rate tariff** (`rate_per_hour × elapsed time`) in `projections.parking_sessions` — a significant simplification vs. the BRD's real tariff model. Intentional, for testing the workflow only.
- **The abnormal-case invariant is not DB-enforced.** "An abnormal transaction should have an exception attached" is documented, not backed by a `CHECK` constraint — enforce at app/DAO layer if/when tightened.
- **No real foreign keys between local Drift tables** — see §4.
- **JWT session is in-memory only** on the frontend — needs `flutter_secure_storage` before going further.
- **No Dockerfile for the Spring Boot app** — only local Postgres dev DB is containerized.
- **Windows builds need Developer Mode** once any real local DB is added (`path_provider`, `sqlite3_flutter_libs` both require native platform code).
- **No Maven wrapper committed** (`mvnw`/`mvnw.cmd` missing from every branch as of the last check) — requires a locally-installed `mvn`. Generate via `mvn -N io.takari:maven:wrapper -Dmaven=3.9.6` if fixing this.
- **Dashboard's "Recent Transactions" section is still mock data** — `MockApiService`-driven, unrelated to and not fixed by the live-metrics work in §11.3. The Sync screen's transaction list, by contrast, is real.

---

## 13. Open Questions — Needs Client Confirmation

1. RBAC role definitions (Operator, Admin, etc.) — still not provided.
2. Payment APIs — still not provided.
3. `identity.user_credentials` — doesn't exist in the real schema dump; needs a real decision on whether local password auth is the right long-term design vs. `credential_reference`/external-IdP pattern.
4. `reconciliation.mops_transaction_records` status enum / FK direction — see §10.3.
5. BRD §9.19.3 on-device tariff caching — see §10.4.
6. `OverrideRequests` scope — not in client's latest "3 tables" recap; unconfirmed but not removed.
7. Can an Exception exist with no Transaction at all? Current design assumes no.
8. Payment method vocabulary — assumed cash-only given BCP context, not confirmed.
9. Full offline (zero network, not just Central PMS down) behavior — undefined; does normal-case lookup fail closed and force everything into the abnormal path, or is caching expected?
10. Automatic reset-and-reseed of Projections DB on every backend startup vs. current "seed once ever" — not yet decided.

---

## 14. Environment Gotchas (Windows + Android Studio, encountered and fixed)

These were real local-setup blockers, not code defects — useful if similar issues recur:

1. **Docker Desktop not running / virtualization disabled** → enable virtualization in BIOS + Windows Features (Hyper-V, WSL, Virtual Machine Platform).
2. **`./mvnw` not found** → wrapper isn't committed to any branch; use a locally-installed `mvn`, or generate the wrapper (see §12).
3. **Symlink error building for Windows Desktop** → enable Developer Mode (`start ms-settings:developers`), or target the Android emulator instead (recommended — what the team actually uses).
4. **Native asset build failure referencing an unrecognized path** → caused by **spaces in file paths** — both the project folder and the Flutter SDK install path need to be space-free (e.g. `C:\CSSWENG-Group-E-ExitPass\...`, `C:\flutter`), then update PATH + Android Studio's Flutter SDK setting.
5. **`docker compose up -d` failing on stale state** → resolved once Docker Desktop itself was confirmed healthy.
6. **`Column` name collision (Dart compile error)** — hit when first wiring Drift into a UI screen: Drift's DSL `Column` class collides with Flutter's `Column` widget when both packages are imported unqualified in the same file. → alias the Drift import: `import 'package:drift/drift.dart' as drift;`.
7. **`&` operator not defined on `Expression<bool>`** — caused by an overly-restrictive `show` clause on the Drift import hiding the extension that provides that operator. → import Drift's members properly rather than narrowing with `show` (resolved together with #6, in the same file).

**Full merge/branch investigation note:** a suspected login-breaking merge (`operational-logs` + `bcp-exit-sync` → `merge-test`) turned out to involve zero actual code conflicts — every auth-related file was byte-for-byte identical across branches. `operational-logs` is frontend-only and never touches the backend; `bcp-exit-sync` only adds new files, never modifies shared code. All login failures traced to the environment issues above, not code. Worth remembering: **rule out local environment/setup before assuming a merge broke something.**

---

## 15. Database Inspection

### ⚠️ Android Studio's native "Database Inspector" does NOT work for this project, for either database
This is **architectural, not a misconfiguration** — no amount of navigating to the right screen or refreshing fixes it, so don't waste time trying it again:
- **Drift/SQLite:** confirmed via Drift's own maintainer — Database Inspector only instruments Android's Java `SQLiteDatabase` class via JDWP. Drift's `NativeDatabase` uses direct FFI bindings to SQLite (via `sqlite3_flutter_libs`), bypassing that Java layer entirely by design, for cross-platform support.
- **Postgres:** never applicable regardless — Android Studio's bundled tooling doesn't include full database support without an IntelliJ Ultimate license, and "Database Inspector" specifically is Android/SQLite-only either way.

### What actually works — Drift (local): Flutter DevTools' "Drift" tab
A DevTools extension bundled with Drift 2.13+/Flutter 3.16+, no extra dependency needed. With the app running, open Flutter DevTools Extensions (right side of the Android Studio window), enable the `package:drift` extension if not already on — the **Drift** tab appears automatically, showing the live database. Provides live table browsing/editing, a one-click **"Download database"** export (replacing manual `adb run-as` pulls), and a one-click **"Clear database"** reset (replacing manual file deletion — this is also the standard way to resolve the local/remote mismatch described in §9).

Full guided walkthrough with exact steps and sample data: `ExitPass_BCP_Mode_Setup_and_Testing_Guide.md` §7–8.

### What actually works — Postgres: Database Navigator plugin (not the IDE's generic "Database" tool)
JetBrains Marketplace, plugin ID `1800` (an Oracle open-source product, free — an initially-considered paid alternative was ruled out for this reason). Install via `File → Settings → Plugins → Marketplace`, restart, then connect through the plugin's own **"DB Browser"** panel:
```
Host: localhost   Port: 5432
Database: exitpass_mops_local
User: exitpass    Password: exitpass_local_dev_only
```
Double-click `projections.parking_sessions` → **"No Filter"** on the prompt → full grid view. **Does not auto-refresh** — after triggering a sync in the app, manually hit the refresh icon in the grid's toolbar to see the updated `payment_status`.

CLI alternative: `docker exec -it exitpass-mops-local-db psql -U exitpass -d exitpass_mops_local`.

**Neither database resets automatically between runs.** Postgres persists via a named Docker volume (`docker compose down -v` wipes it). Drift persists via app private storage (uninstall, emulator "Wipe Data," or the Drift DevTools "Clear database" button wipes it — hot reload/restart never touches it).

---

## 16. Repo Cleanup Backlog

1. **Delete `Back-end/schema_final/`** — an earlier, superseded draft of the Drift schema (missing the singleton fix, missing `ticketNumber`/`qrPayload`, schema v1 not v2). Outside Maven's source root, never compiled — dead weight, present even on `main` before any feature branches existed. **Confirmed safe to delete** — a repo-wide reference check turned up zero references anywhere. Go ahead and remove it; no build/runtime impact expected. *(A theory surfaced that this folder was actually an intentional minimal local-DB rebuild meant to replace an outdated `Front-end/lib/database/` — the debugging doc's own dating/content claims argued against that, and the zero-references result is consistent with it being dead code rather than an active replacement; see §10.5.)*
2. **Remove committed `Back-end/target/`** — compiled build artifacts that shouldn't be tracked. Run `git rm -r --cached Back-end/target` and commit.
3. **Add missing Maven wrapper** (`mvnw`, `mvnw.cmd`, `.mvn/wrapper/`) via `mvn -N io.takari:maven:wrapper -Dmaven=3.9.6`.
4. *(Non-urgent)* AGP 8.7.3 and Kotlin 2.1.0 approaching Flutter's deprecation cutoff — backlog item to upgrade before Flutter drops support.
5. **Deliberately declined, not a gap:** automatic local/remote reconciliation on backend restart, and a bespoke in-app "Reset Local Data" button. Drift DevTools' built-in "Clear database" (§15) already covers this need manually — don't build either of these unless the manual workflow genuinely becomes a pain point.
6. **Considered, not yet built:** a single setup/run script and a "preflight check" script (à la `flutter doctor`) to automate/validate the multi-terminal startup sequence and catch the space-in-path/Docker/Developer-Mode issues (§14) before they produce confusing downstream errors. Non-blocking, worth doing if onboarding friction continues.

---

## 17. Ground Rules for Claude Code on This Project

- **Preserve existing architecture, naming conventions, operator workflows, and UI philosophy** unless a redesign is explicitly requested.
- **Extend the existing implementation rather than replacing it.**
- **Treat contradictions across project docs as expected**, not errors — resolve via §2's hierarchy, and flag anything unresolved rather than silently picking a side.
- **Verify exact table/column names in the actual Drift/migration files before writing code that references them** — see §10 for known naming drift between docs.
- **Don't assume backend support exists for Operational Logs (Incidents/Manual Gate Logs)** — confirmed 100% local-only, no server endpoints.
- **Keep local cross-table references soft/unconstrained**, consistent with the rest of the schema — don't introduce a real FK for one relationship while leaving the others soft.
- **`OverrideRequests` stays read-only on the client** — no local approve/deny logic; this is intentional, not a missing feature.
- **Always attach the `Authorization: Bearer <token>` header on new backend service calls** — it is not applied automatically/globally on the frontend yet, and forgetting it is a confirmed real bug pattern, not a hypothetical (§11.1).
- **Don't reintroduce the local duplicate-ticket gap** — any new path that records a `ContinuityTransactions` row must go through (or replicate) the local existing-ticket check in §4/§11.2, not just a backend `PAID`-status check.
- **For setup/testing steps, defer to `ExitPass_BCP_Mode_Setup_and_Testing_Guide.md`** rather than re-deriving them — this file intentionally doesn't duplicate that content.
- **Before editing or adding any file, present the intended change and get explicit confirmation first.** This applies to production work specifically — describe what will change (files touched, what's added/removed/modified) before touching disk, and wait for a go-ahead rather than making the edit and reporting it after the fact.
- **As part of that same presentation, state the expected effect on the rest of the program** — will this break something, change existing functionality, expose or create new bugs, or leave current behavior unchanged? Call out anything touching a confirmed-working flow (§11), a known duplicate/auth-header guard (§4/§11.1/§11.2), or a soft cross-table reference (§4) specifically, since those are the areas most likely to regress silently.
- Before assuming a bug is a code defect, rule out local environment/setup issues first (Docker health, both backend processes running, path/space issues on Windows) — see §14 for precedent.
