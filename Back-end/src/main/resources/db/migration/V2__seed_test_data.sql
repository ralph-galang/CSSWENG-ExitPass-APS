-- =====================================================================
-- V2__seed_test_data.sql
--
-- Dummy accounts, one MoPS device binding, and sample continuity
-- transactions for local testing of login, device/site binding, the
-- operator dashboard, and sync/reconciliation screens.
--
-- Plain-text passwords are listed here ONLY because this is local
-- seed data with throwaway bcrypt hashes -- never do this for a real
-- environment. See README-TEST-DATA.md for the full credential list
-- and the caveats around identity.user_credentials.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Site group / site / lane
-- ---------------------------------------------------------------------
INSERT INTO sites.site_groups (
    site_group_id, site_group_code, site_group_name, business_label,
    operator_entity_name, timezone_name, default_currency_code,
    site_group_status, default_payment_enabled, effective_from
) VALUES (
    '11111111-1111-1111-1111-111111111111', 'TEST-SG-01', 'Test Site Group',
    'Test Group', 'ExitPass Test Operator Inc.', 'Asia/Manila', 'PHP',
    'ACTIVE', true, now()
);

INSERT INTO sites.sites (
    site_id, site_group_id, site_code, site_name, site_type,
    timezone_name, city, province, country_code, site_status,
    payment_enabled, effective_from
) VALUES (
    '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111',
    'TEST-SITE-01', 'Test Mall Parking', 'MALL_PARKING',
    'Asia/Manila', 'Quezon City', 'Metro Manila', 'PH', 'ACTIVE',
    true, now()
);

INSERT INTO sites.lanes (
    lane_id, site_id, lane_code, lane_name, lane_type, lane_direction,
    lane_status, display_order, effective_from
) VALUES (
    '33333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222',
    'TEST-LANE-EXIT-01', 'Exit Lane 1', 'EXIT', 'OUTBOUND',
    'ACTIVE', 1, now()
);

-- ---------------------------------------------------------------------
-- Roles
-- ---------------------------------------------------------------------
INSERT INTO identity.roles (
    role_id, role_code, role_name, role_type, role_status,
    is_privileged, requires_elevated_approval, effective_from
) VALUES
    ('44444444-4444-4444-4444-444444444441', 'SITE_OPERATOR', 'Site Operator',
     'OPERATIONS', 'ACTIVE', false, false, now()),
    ('44444444-4444-4444-4444-444444444442', 'SITE_SUPERVISOR', 'Site Supervisor',
     'OPERATIONS', 'ACTIVE', true, true, now());
-- NOTE: 'SITE_SUPERVISOR' role_code is our own naming choice -- the real
-- dump only confirms the *user_type* 'SITE_OPERATOR' exists; no seed
-- role rows were recoverable from the dump (COPY data is compressed).
-- Confirm actual role_code conventions with the team before relying on
-- this string anywhere outside local testing.

-- ---------------------------------------------------------------------
-- Users (dummy operator + supervisor accounts)
-- ---------------------------------------------------------------------
INSERT INTO identity.users (
    user_id, username, email, email_normalized, display_name,
    user_type, user_status, effective_from
) VALUES
    ('55555555-5555-5555-5555-555555555551', 'operator1', 'operator1@test.exitpass.local',
     'operator1@test.exitpass.local', 'Test Operator One',
     'SITE_OPERATOR', 'ACTIVE', now()),
    ('55555555-5555-5555-5555-555555555552', 'supervisor1', 'supervisor1@test.exitpass.local',
     'supervisor1@test.exitpass.local', 'Test Supervisor One',
     'SITE_OPERATOR', 'ACTIVE', now());
-- user_type stays 'SITE_OPERATOR' for both -- the enum has no separate
-- supervisor value; supervisor-ness is expressed via role assignment
-- below (identity.user_roles -> SITE_SUPERVISOR), consistent with how
-- BRD SS13.8 describes supervisor-level MoPS activation as a role
-- grant, not a distinct user type.

-- Password hashes generated locally via Python's crypt.METHOD_BLOWFISH
-- (libxcrypt bcrypt, $2b$ variant, cost 10) -- compatible with Spring
-- Security's BCryptPasswordEncoder.
--   operator1   / Operator@123
--   supervisor1 / Supervisor@123
INSERT INTO identity.user_credentials (user_id, password_hash) VALUES
    ('55555555-5555-5555-5555-555555555551',
     '$2b$10$ndky691CIju7SfMW1/CFieM99mbbLKU2PT4grjPrSgaHl6kLfct46'),
    ('55555555-5555-5555-5555-555555555552',
     '$2b$10$9MCtXRWf1DSaEkoXD/460OnoAD1Vxp.J88yY4QYT6FC0gfy6omyE6');

INSERT INTO identity.user_roles (
    user_id, role_id, assignment_status, effective_from
) VALUES
    ('55555555-5555-5555-5555-555555555551', '44444444-4444-4444-4444-444444444441',
     'ACTIVE', now()),
    ('55555555-5555-5555-5555-555555555552', '44444444-4444-4444-4444-444444444442',
     'ACTIVE', now());

-- ---------------------------------------------------------------------
-- MoPS device identity + site binding
-- ---------------------------------------------------------------------
INSERT INTO identity.service_identities (
    service_identity_id, service_identity_code, service_identity_name,
    identity_type, identity_status, owning_service_name,
    credential_reference, credential_type, effective_from
) VALUES (
    '66666666-6666-6666-6666-666666666666', 'MOPS-DEVICE-TEST-001', 'Test MoPS Handheld 001',
    'DEVICE', 'ACTIVE', 'exitpass-mops-android',
    'local-test-device-secret-ref', 'API_KEY_REFERENCE', now()
);

-- Assignment type 'OTHER' used as a flagged stopgap: the real
-- device_assignment_type_enum has no MOPS_DEVICE value. See
-- README-TEST-DATA.md before treating this as final.
INSERT INTO sites.device_assignments (
    device_assignment_id, site_id, lane_id, service_identity_id,
    assignment_type, assignment_status, assignment_reason_code, assigned_at
) VALUES (
    '77777777-7777-7777-7777-777777777777', '22222222-2222-2222-2222-222222222222',
    '33333333-3333-3333-3333-333333333333', '66666666-6666-6666-6666-666666666666',
    'OTHER', 'ACTIVE', 'MOPS_CONTINUITY_TEST_BINDING', now()
);

-- ---------------------------------------------------------------------
-- Sample continuity transactions (reconciliation.mops_transaction_records)
-- One row per record_status value, so sync/reconciliation UI screens
-- have something of every kind to render.
-- ---------------------------------------------------------------------
INSERT INTO reconciliation.mops_transaction_records (
    site_id, lane_id, source_system_code, source_transaction_ref,
    currency_code, amount, payment_method_label, continuity_reason_code,
    record_status, captured_at, captured_by_user_id, captured_by_service_identity_id,
    correlation_id
) VALUES
    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0001', 'PHP', 150.00, 'CASH',
     'NETWORK_OUTAGE', 'RECORDED', now() - interval '2 hours',
     '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid()),

    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0002', 'PHP', 80.00, 'CASH',
     'NETWORK_OUTAGE', 'IMPORTED', now() - interval '1 hour 45 minutes',
     '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid()),

    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0003', 'PHP', 220.00, 'QR_MANUAL',
     'CENTRAL_PMS_UNREACHABLE', 'PENDING_RECONCILIATION', now() - interval '1 hour 30 minutes',
     '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid()),

    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0004', 'PHP', 100.00, 'CASH',
     'NETWORK_OUTAGE', 'RECONCILED', now() - interval '1 hour',
     '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid()),

    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0005', 'PHP', 300.00, 'QR_MANUAL',
     'GATE_HARDWARE_FAILURE', 'DISPUTED', now() - interval '45 minutes',
     '55555555-5555-5555-5555-555555555552', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid()),

    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0006', 'PHP', 60.00, 'CASH',
     'NETWORK_OUTAGE', 'REJECTED', now() - interval '30 minutes',
     '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid()),

    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333',
     'MOPS_ANDROID', 'MOPS-TEST-TXN-0007', 'PHP', 175.00, 'CASH',
     'NETWORK_OUTAGE', 'CANCELLED', now() - interval '15 minutes',
     '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666666',
     gen_random_uuid());
