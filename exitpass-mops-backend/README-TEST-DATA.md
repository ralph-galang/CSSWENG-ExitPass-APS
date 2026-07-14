# Local Test Data — ExitPass MoPS Backend

Local-only seed data so you can build/test Priority 1 backend work
(auth, device/site binding, dashboard/sync endpoints) without waiting
on real API contracts. Not for staging or production use.

## Setup

```bash
docker compose up -d
# wait for healthy, then run your Spring Boot app with the local profile:
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
```

Flyway will run `V1__schema_subset_for_local_testing.sql` then
`V2__seed_test_data.sql` automatically on startup.

## Test credentials

| Username | Password | Role | Notes |
|---|---|---|---|
| `operator1` | `Operator@123` | SITE_OPERATOR | bound to Test Mall Parking / Exit Lane 1 |
| `supervisor1` | `Supervisor@123` | SITE_SUPERVISOR | privileged, `requires_elevated_approval = true` |

Password hashes are real bcrypt (`$2b$` variant, cost 10), generated
locally with Python's `crypt.METHOD_BLOWFISH` (libxcrypt) since this
environment had no network access to pull the `bcrypt` package. Spring
Security's `BCryptPasswordEncoder` reads `$2b$` hashes natively — no
conversion needed.

## Test device

- `service_identity_code = MOPS-DEVICE-TEST-001`
- Bound to Test Mall Parking / Exit Lane 1 via `sites.device_assignments`

## Sample transactions

Seven rows in `reconciliation.mops_transaction_records`, one for each
value of `record_status` (`RECORDED`, `IMPORTED`, `PENDING_RECONCILIATION`,
`RECONCILED`, `DISPUTED`, `REJECTED`, `CANCELLED`) so dashboard/sync/
reconciliation screens have a full set of states to render against.

## Deliberate deviations from the real schema — confirm with the team

These were necessary to make local testing possible, but none of them
are proposals for the real design. Don't let them leak into a shared
branch without sign-off:

1. **`identity.user_credentials` doesn't exist in the real DB.**
   Every other credential-bearing table in the real schema stores only
   an opaque `credential_reference` pointing at an external secret
   store — never a raw secret. Real user auth may be meant to work the
   same way (external IdP/vault), not via a local password hash table.
   Flag this and get a real answer before building production auth
   against this table.

2. **`sites.device_assignment_type_enum` has no `MOPS_DEVICE` value.**
   The seed data uses `'OTHER'` for the MoPS handheld's assignment
   type as a stopgap. If MoPS devices need to be distinguishable from
   other "other" assignments in real queries/reporting, this enum
   needs a migration to add a proper value.

3. **`identity.roles` seed values (`SITE_OPERATOR`, `SITE_SUPERVISOR`
   role codes) are invented for this test set.** The real dump's
   `COPY` data (actual seeded rows) is compressed and wasn't
   recoverable from the file we have, so we don't actually know what
   role codes the real system uses. Only the `user_type` enum value
   `'SITE_OPERATOR'` is confirmed from the real schema — the role
   table's contents are a guess.

## Source

Table/enum definitions in `V1__schema_subset_for_local_testing.sql`
are copied verbatim from `exitpass-database.sql` (pg_dump, custom
format, `exitpass_v12_dev`) provided 2026-07-09. This is a *subset* —
only `identity.*`, `sites.*`, and `reconciliation.mops_transaction_records`
are reproduced, since that's what Priority 1 needs.
