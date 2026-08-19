# ExitPass BCP Mode — Setup & Testing Guide

This is the canonical guide for getting `merge-test` running locally and validating both the Ticket Transactions and Operational Logs features end to end, including low-level database verification. It folds in everything discovered while debugging the original merge, so following it should avoid every dead end that cost time the first time through.

---

## 0. Prerequisites

### Android Studio (Presentation tier — Flutter frontend, on-device local data)
- Install Android Studio, with the Flutter and Dart plugins.
- Set up an Android emulator (AVD Manager → create a device, e.g. Pixel 7/8, recent API level).
- **Virtualization must be enabled** (BIOS/UEFI setting, e.g. Intel VT-x / AMD-V) for the emulator to run at all. Check via Task Manager → Performance → CPU → "Virtualization."

### Docker (Data tier — Postgres, the authoritative "Projections DB" simulation)
- Install Docker Desktop.
- **Also requires virtualization enabled** — this is a *separate* dependency from the emulator's need for it, not the same check. Docker Desktop needs Hyper-V / WSL2 / Virtual Machine Platform enabled under Windows Features, in addition to the BIOS setting above.

### Maven (Application tier — Spring Boot backend)
- Install Maven, or use a Maven bundled with your IDE. (Note: this repo does **not** currently include the Maven wrapper — `mvnw`/`mvnw.cmd` — so a separate Maven install is required for now. See the Known Issues section.)

### ⚠️ Windows-specific: keep every path free of spaces
This bit us badly the first time through. **Neither the project folder nor the Flutter SDK install path may contain spaces** — not `Documents`, not a folder name like `CSSWENG Group E`, nothing. Spaces in either path break Flutter's native-asset build step with a cryptic `'C:\Users\Name' is not recognized` error that has nothing to do with your code.
- ✅ Good: `C:\dev\ExitPass\...`, `C:\flutter`
- ❌ Bad: `C:\Users\Jane Doe\Documents\...`, `C:\Users\Jane Doe\flutter`

If your Windows username itself contains a space, move both the project and the Flutter SDK to a top-level, no-space path (e.g. `C:\dev`, `C:\flutter`) rather than anything under your user folder.

### ⚠️ Only relevant if you ever target Windows Desktop instead of the emulator
Don't — there's no reason to for this project (the emulator is the actual target), and it opens up two more dead ends: Windows requires **Developer Mode** enabled for the symlink support Flutter's build needs, and beyond that, native asset compilation for Windows desktop requires a fully configured Visual Studio C++ toolchain that this project doesn't otherwise need. Stick to the Android emulator.

---

## 1. Start Postgres (Docker)

From `Back-end/`, with Docker Desktop actually running:
```bash
docker compose up -d
```
This creates the Postgres container simulating the Projections DB.

**Important nuance:** the underlying *data* persists across restarts (it lives in a named Docker volume), but the *container process* does not survive Docker Desktop closing or a machine reboot. You need to run `docker compose up -d` again at the start of every work session where it isn't already running — check with `docker ps` to see if `exitpass-mops-local-db` is currently listed. You do **not** need to recreate or rebuild anything each time; just start it.

To fully wipe and start clean (rare — e.g. testing migrations from scratch):
```bash
docker compose down -v
docker compose up -d
```

---

## 2. Start the backend (Spring Boot)

From `Back-end/`, in a **separate terminal that you leave open for the entire session**:
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```
Unlike Docker, this process dies the moment its terminal is closed — there's no "detached" mode for it. Keep this terminal visible for the whole time you're testing; it's also where you'll see backend stack traces if something goes wrong.

This seeds Postgres with 50 sample parking session records (`TCK-TEST-001` through `TCK-TEST-050`) on **every** startup — the existing 50 rows are wiped and replaced fresh each time, giving deterministic ticket numbers/plates/status for testing, though row IDs and timestamps differ between runs.

**Verify the backend independently before touching the app**, using curl:
```bash
curl -X POST http://localhost:8080/api/v1/auth/login -H "Content-Type: application/json" -d "{\"username\":\"operator1\",\"password\":\"Operator@123\",\"deviceCode\":\"MOPS-DEVICE-TEST-001\"}"
```
A 200 response with a `token` confirms Docker + migrations + backend are all healthy, before you ever open the app.

---

## 3. Run the frontend (Flutter)

Either:
```bash
cd Front-end
flutter pub get
flutter run
```
...picking the Android emulator when prompted — or, in Android Studio, just confirm the device dropdown shows your emulator (not "Windows (desktop)") and press the green **Run** ▶ button.

---

## 4. Log in

```
Username: operator1
Password: Operator@123
```
(`supervisor1` / `Supervisor@123` also works, for the Site Supervisor role.)

---

## 5. Test ticket transactions

- The dashboard's three top metrics (**Active Parking**, **Vehicles Exited**, **Total Transactions**) are live, queried from Postgres via the backend. `Active + Exited` always equals `Total` (50).
- Below that, the **Pending Sync** card shows how many local (not-yet-synced) transactions are currently sitting in the on-device database.
- Tap the **Tickets** icon (bottom nav, between Dashboard and Log) and enter a ticket number:
  ```
  TCK-TEST-0XX   (where XX is 01–50)
  e.g. TCK-TEST-021
  ```
- Tap **Proceed to Payment** (no real payment processing — this records a dummy local transaction, which is expected).

**Note:** re-entering a ticket number you've already captured on this device — even before syncing — will now correctly throw *"Ticket TCK-TEST-0XX already has a transaction recorded on this device and is awaiting sync."* This is an intentional duplicate guard, not a bug. If you want to test the same ticket number again, you'll need to clear the local database first (see Section 7).

---

## 6. Test operational logs

Tap the **Log** icon (bottom nav, between Tickets and Settings).

**Incident:**
```
Category: (choose from dropdown, e.g. Power Outage)
Notes: any non-empty string, e.g. "Main breaker tripped at south exit gate; backup generator not yet online."
```

**Manual Gate Action:**
```
Reason Code: (choose from dropdown, e.g. Power Outage)
Justification: any non-empty string, e.g. "Gate arm stuck open after power blip; manually logged vehicle exit for plate SEED 0014 without ticket scan."
```

Both of these are **local-only** — there's no backend endpoint for either yet, so they'll show a local sync status of "pending" indefinitely. That's expected, not an error.

---

## 7. Validate the ticket transaction flow at the database level

Two separate tools for two separate databases — don't confuse them, they are **not** interchangeable and one of them (Android Studio's native "Database Inspector") does not work for this project at all.

### Postgres — **Database Navigator** plugin (not Android Studio's built-in "Database Inspector")
If not already installed: `File → Settings → Plugins → Marketplace` → search **"Database Navigator"** (plugin ID `1800`) → Install → restart.

Connect via the **DB Browser** panel → `+` → PostgreSQL:
```
Host: localhost
Port: 5432
Database: exitpass_mops_local
User: exitpass
Password: exitpass_local_dev_only
```
Double-click `projections.parking_sessions` → click **"No Filter"** on the prompt that appears → this opens the full grid view. Keep this open.

**This view does not auto-refresh.** After syncing a transaction, you need to manually hit the refresh icon in the grid's toolbar to see the updated `payment_status`.

### Drift (local/on-device) — **Flutter DevTools' "Drift" tab** (also not Android Studio's "Database Inspector" — that one never works here, since Drift's `NativeDatabase` bypasses Android's Java SQLite API entirely)
With the app running: open **Flutter DevTools Extensions** (right side of the Android Studio window) → enable the `package:drift` extension if not already enabled → the **Drift** tab appears automatically, showing your live database.

You'll see the transaction you just captured in `continuity_transactions`.

### Now trigger the sync and confirm both sides update
- Back in the app, go to the Dashboard → tap the **Pending Sync** card → tap **Sync Transactions**.
- **Expected result:** the dashboard's Active/Exited counts update immediately (e.g. 49/1 → 48/2). Back in the Database Navigator grid you kept open, hit refresh — the ticket you transacted with should now show `payment_status: PAID` and a real `time_out`.

---

## 8. Validate the operational logs flow

Since this feature is local-only, only the Drift side matters here.

Open the **Drift** tab in Flutter DevTools Extensions (same as above) → select the `incidents` and `manual_gate_logs` tables → confirm the sample entries you logged in Step 6 are present with the data you entered.

---

## Known issues / cleanup backlog

These don't block testing, but are worth handling before this branch merges into `main`:

1. **`Back-end/schema_final/`** — a stale, superseded draft of the Drift schema. Not compiled or referenced by anything (it's outside Maven's source root, and the real schema lives in `Front-end/lib/database/`). Safe to `git rm -r`.
2. **Committed `Back-end/target/`** — build artifacts that shouldn't be tracked (already `.gitignore`d, but present in the repo anyway, likely from a non-clean zip/copy rather than a git export). Run `git rm -r --cached Back-end/target` and commit.
3. **Missing Maven wrapper** — `mvnw`/`mvnw.cmd`/`.mvn/wrapper/` aren't in the repo, forcing everyone to have Maven installed separately. Generate once via `mvn -N io.takari:maven:wrapper -Dmaven=3.9.6` and commit the result.
4. **Local/remote data mismatch across backend restarts** — since the seeder wipes `projections.parking_sessions` on every backend startup but Drift's local data persists indefinitely, a ticket synced in one backend session will show as fresh/`UNPAID` again after a restart, while the local device still believes it was already processed (and the duplicate-guard in Step 5 will block re-testing that same ticket number). Currently handled via manual clearing (Drift DevTools' "Clear database" button) rather than automatic reconciliation — acceptable for now, revisit if this becomes a real pain point.
5. **`sync_transactions_screen.dart`'s displayed list and `MockApiService`-driven Dashboard "Recent Transactions" section** — the transaction list itself is now wired to real Drift data, but the Dashboard's "Recent Transactions" section below the metrics is still mock/dummy data, unrelated to this pass.
