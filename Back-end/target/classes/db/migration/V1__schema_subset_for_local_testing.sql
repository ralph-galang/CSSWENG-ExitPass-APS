-- =====================================================================
-- V1__schema_subset_for_local_testing.sql
--
-- Purpose: Local/dev-only recreation of the SUBSET of the real
-- exitpass_v12_dev schema needed to unblock Priority 1 backend work
-- (Device Identity & Site Binding, Auth, Core API Setup) while the
-- real API contracts are still pending.
--
-- Source of truth: reconstructed from exitpass-database.sql (pg_dump,
-- custom format) provided 2026-07-09. Column names/types/enums below
-- are copied verbatim from that dump for: identity.*, sites.*,
-- reconciliation.mops_transaction_records.
--
-- ⚠️ ONE INTENTIONAL DEVIATION FROM THE REAL SCHEMA:
-- identity.users in the real DB has NO password/credential column.
-- Every other credential-bearing table in that schema stores only an
-- opaque credential_reference (external secret store), never a raw
-- secret. This migration adds identity.user_credentials as a
-- LOCAL-TESTING-ONLY table so we can exercise JWT login end-to-end.
-- This is NOT a proposal for the real auth design -- flag with the
-- team whether real user auth should follow the credential_reference
-- pattern (external IdP/vault) instead. Do not port this table to
-- staging/prod without that conversation happening first.
-- =====================================================================

CREATE SCHEMA IF NOT EXISTS identity;
CREATE SCHEMA IF NOT EXISTS sites;
CREATE SCHEMA IF NOT EXISTS reconciliation;

CREATE EXTENSION IF NOT EXISTS pgcrypto; -- for gen_random_uuid()

-- ---------------------------------------------------------------------
-- ENUM TYPES (copied verbatim from the real dump)
-- ---------------------------------------------------------------------
CREATE TYPE identity.role_status_enum AS ENUM (
    'DRAFT','ACTIVE','SUSPENDED','RETIRED'
);

CREATE TYPE identity.role_type_enum AS ENUM (
    'SYSTEM','OPERATIONS','MERCHANT','FINANCE','COMPLIANCE','SUPPORT','SECURITY','SERVICE','OTHER'
);

CREATE TYPE identity.service_credential_type_enum AS ENUM (
    'CLIENT_SECRET_REFERENCE','CERTIFICATE_REFERENCE','MTLS_CERTIFICATE_REFERENCE',
    'API_KEY_REFERENCE','JWT_SIGNING_KEY_REFERENCE','KEY_VAULT_REFERENCE',
    'WEBHOOK_SECRET_REFERENCE','NONE'
);

CREATE TYPE identity.service_identity_status_enum AS ENUM (
    'DRAFT','ACTIVE','SUSPENDED','REVOKED','EXPIRED','RETIRED'
);

CREATE TYPE identity.service_identity_type_enum AS ENUM (
    'INTERNAL_SERVICE','EXTERNAL_CLIENT','ADAPTER','BACKGROUND_WORKER','SCHEDULED_JOB',
    'WEBHOOK_RECEIVER','DEVICE','GATEWAY','OTHER'
);

CREATE TYPE identity.user_role_assignment_status_enum AS ENUM (
    'ACTIVE','SUSPENDED','REVOKED','EXPIRED','RETIRED'
);

CREATE TYPE identity.user_status_enum AS ENUM (
    'INVITED','ACTIVE','LOCKED','SUSPENDED','INACTIVE','RETIRED'
);

CREATE TYPE identity.user_type_enum AS ENUM (
    'INTERNAL_ADMIN','OPERATIONS_USER','SITE_OPERATOR','SUPPORT_USER','FINANCE_USER',
    'COMPLIANCE_USER','MERCHANT_USER','SECURITY_USER','OTHER'
);

CREATE TYPE identity.permission_status_enum AS ENUM (
    'DRAFT','ACTIVE','DEPRECATED','RETIRED'
);

CREATE TYPE identity.role_permission_binding_status_enum AS ENUM (
    'ACTIVE','SUSPENDED','REVOKED','EXPIRED'
);

CREATE TYPE sites.device_assignment_status_enum AS ENUM (
    'ACTIVE','SUSPENDED','SUPERSEDED','EXPIRED','RETIRED'
);

-- NOTE: the real enum has no MOPS_DEVICE value. Using 'OTHER' for MoPS
-- handheld devices below as a flagged stopgap -- see README-TEST-DATA.md.
CREATE TYPE sites.device_assignment_type_enum AS ENUM (
    'GATE_DEVICE','LPR_DEVICE','LANE_CONTROLLER','PAYMENT_DEVICE','SERVICE_PRINCIPAL','OTHER'
);

CREATE TYPE sites.lane_direction_enum AS ENUM (
    'INBOUND','OUTBOUND','BIDIRECTIONAL','NOT_APPLICABLE'
);

CREATE TYPE sites.lane_status_enum AS ENUM (
    'DRAFT','ACTIVE','MAINTENANCE','SUSPENDED','INACTIVE','RETIRED'
);

CREATE TYPE sites.lane_type_enum AS ENUM (
    'ENTRY','EXIT','MIXED','VALIDATION','SERVICE','OTHER'
);

CREATE TYPE sites.site_group_status_enum AS ENUM (
    'DRAFT','ACTIVE','SUSPENDED','INACTIVE','RETIRED'
);

CREATE TYPE sites.site_status_enum AS ENUM (
    'DRAFT','ACTIVE','SUSPENDED','INACTIVE','RETIRED'
);

CREATE TYPE sites.site_type_enum AS ENUM (
    'OPEN_LOT','STRUCTURED_PARKING','MALL_PARKING','MIXED_USE_PROPERTY','TERMINAL','CAMPUS','OTHER'
);

CREATE TYPE reconciliation.mops_transaction_record_status_enum AS ENUM (
    'RECORDED','IMPORTED','PENDING_RECONCILIATION','RECONCILED','DISPUTED','REJECTED','CANCELLED'
);

-- ---------------------------------------------------------------------
-- TABLES (identity.*) -- columns copied verbatim from the real dump
-- ---------------------------------------------------------------------
CREATE TABLE identity.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    username character varying(128) NOT NULL,
    email character varying(256),
    email_normalized character varying(256),
    display_name character varying(128) NOT NULL,
    mobile_number_masked character varying(32),
    user_type identity.user_type_enum NOT NULL,
    user_status identity.user_status_enum NOT NULL,
    last_login_at timestamp with time zone,
    locked_at timestamp with time zone,
    suspended_at timestamp with time zone,
    retired_at timestamp with time zone,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT uq_users__username UNIQUE (username),
    CONSTRAINT ck_users__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_users__row_version_positive CHECK (row_version > 0)
);

-- ⚠️ LOCAL-TESTING-ONLY TABLE. Not present in the real schema. See header note.
CREATE TABLE identity.user_credentials (
    user_credential_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES identity.users(user_id),
    password_hash character varying(100) NOT NULL, -- bcrypt, e.g. $2b$10$...
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT uq_user_credentials__user_id UNIQUE (user_id)
);

CREATE TABLE identity.roles (
    role_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    role_code character varying(64) NOT NULL,
    role_name character varying(128) NOT NULL,
    role_description text,
    role_type identity.role_type_enum NOT NULL,
    role_status identity.role_status_enum NOT NULL,
    is_privileged boolean DEFAULT false NOT NULL,
    requires_elevated_approval boolean DEFAULT false NOT NULL,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT uq_roles__role_code UNIQUE (role_code),
    CONSTRAINT ck_roles__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_roles__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE identity.permissions (
    permission_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    permission_code character varying(96) NOT NULL,
    permission_name character varying(128) NOT NULL,
    permission_description text,
    permission_domain character varying(64) NOT NULL,
    permission_action character varying(64) NOT NULL,
    permission_status identity.permission_status_enum NOT NULL,
    is_sensitive boolean DEFAULT false NOT NULL,
    requires_audit boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT uq_permissions__permission_code UNIQUE (permission_code),
    CONSTRAINT ck_permissions__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE identity.role_permissions (
    role_permission_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    role_id uuid NOT NULL REFERENCES identity.roles(role_id),
    permission_id uuid NOT NULL REFERENCES identity.permissions(permission_id),
    binding_status identity.role_permission_binding_status_enum NOT NULL,
    binding_reason_code character varying(64),
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_by_user_id uuid,
    assigned_by_service_identity_id uuid,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    revoked_at timestamp with time zone,
    revoked_by_user_id uuid,
    revoked_by_service_identity_id uuid,
    revocation_reason_code character varying(64),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT ck_role_permissions__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_role_permissions__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE identity.user_roles (
    user_role_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES identity.users(user_id),
    role_id uuid NOT NULL REFERENCES identity.roles(role_id),
    assignment_status identity.user_role_assignment_status_enum NOT NULL,
    assignment_reason_code character varying(64),
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_by_user_id uuid,
    assigned_by_service_identity_id uuid,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    revoked_at timestamp with time zone,
    revoked_by_user_id uuid,
    revoked_by_service_identity_id uuid,
    revocation_reason_code character varying(64),
    last_reviewed_at timestamp with time zone,
    last_reviewed_by_user_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT ck_user_roles__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_user_roles__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE identity.service_identities (
    service_identity_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    service_identity_code character varying(64) NOT NULL,
    service_identity_name character varying(128) NOT NULL,
    identity_type identity.service_identity_type_enum NOT NULL,
    identity_status identity.service_identity_status_enum NOT NULL,
    owning_service_name character varying(128),
    credential_reference character varying(256),
    credential_type identity.service_credential_type_enum,
    credential_expires_at timestamp with time zone,
    last_rotated_at timestamp with time zone,
    last_authenticated_at timestamp with time zone,
    revoked_at timestamp with time zone,
    revocation_reason_code character varying(64),
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT uq_service_identities__code UNIQUE (service_identity_code),
    CONSTRAINT ck_service_identities__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_service_identities__row_version_positive CHECK (row_version > 0)
);

-- ---------------------------------------------------------------------
-- TABLES (sites.*)
-- ---------------------------------------------------------------------
CREATE TABLE sites.site_groups (
    site_group_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    site_group_code character varying(64) NOT NULL,
    site_group_name character varying(128) NOT NULL,
    business_label character varying(64),
    description text,
    operator_entity_name character varying(128),
    timezone_name character varying(64) NOT NULL,
    default_currency_code character(3) NOT NULL,
    site_group_status sites.site_group_status_enum NOT NULL,
    public_lookup_enabled boolean DEFAULT false NOT NULL,
    default_payment_enabled boolean DEFAULT false NOT NULL,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT uq_site_groups__code UNIQUE (site_group_code),
    CONSTRAINT ck_site_groups__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_site_groups__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE sites.sites (
    site_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    site_group_id uuid NOT NULL REFERENCES sites.site_groups(site_group_id),
    site_code character varying(64) NOT NULL,
    site_name character varying(128) NOT NULL,
    site_description text,
    site_type sites.site_type_enum NOT NULL,
    timezone_name character varying(64) NOT NULL,
    address_line1 character varying(256),
    address_line2 character varying(256),
    city character varying(128),
    province character varying(128),
    country_code character(2) NOT NULL,
    lgu_code character varying(32),
    site_status sites.site_status_enum NOT NULL,
    public_lookup_enabled boolean DEFAULT false NOT NULL,
    payment_enabled boolean DEFAULT false NOT NULL,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT uq_sites__code UNIQUE (site_code),
    CONSTRAINT ck_sites__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_sites__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE sites.lanes (
    lane_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    site_id uuid NOT NULL REFERENCES sites.sites(site_id),
    lane_code character varying(64) NOT NULL,
    lane_name character varying(128) NOT NULL,
    lane_description text,
    lane_type sites.lane_type_enum NOT NULL,
    lane_direction sites.lane_direction_enum NOT NULL,
    lane_status sites.lane_status_enum NOT NULL,
    display_order integer,
    effective_from timestamp with time zone NOT NULL DEFAULT now(),
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT ck_lanes__display_order_non_negative CHECK ((display_order IS NULL) OR (display_order >= 0)),
    CONSTRAINT ck_lanes__effective_window CHECK ((effective_to IS NULL) OR (effective_to > effective_from)),
    CONSTRAINT ck_lanes__row_version_positive CHECK (row_version > 0)
);

CREATE TABLE sites.device_assignments (
    device_assignment_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    site_id uuid NOT NULL REFERENCES sites.sites(site_id),
    lane_id uuid REFERENCES sites.lanes(lane_id),
    gate_device_id uuid,
    service_identity_id uuid REFERENCES identity.service_identities(service_identity_id),
    assignment_type sites.device_assignment_type_enum NOT NULL,
    assignment_status sites.device_assignment_status_enum NOT NULL,
    assignment_reason_code character varying(64),
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    unassigned_at timestamp with time zone,
    assigned_by_user_id uuid,
    assigned_by_service_identity_id uuid,
    unassigned_by_user_id uuid,
    unassigned_by_service_identity_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT ck_device_assignments__row_version_positive CHECK (row_version > 0)
);

-- ---------------------------------------------------------------------
-- TABLES (reconciliation.*)
-- ---------------------------------------------------------------------
CREATE TABLE reconciliation.mops_transaction_records (
    mops_transaction_record_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    parking_session_id uuid,
    manual_gate_log_id uuid,
    incident_record_id uuid,
    site_id uuid NOT NULL REFERENCES sites.sites(site_id),
    lane_id uuid REFERENCES sites.lanes(lane_id),
    source_system_code character varying(64) NOT NULL,
    source_transaction_ref character varying(128),
    source_batch_ref character varying(128),
    collection_reference character varying(128),
    currency_code character(3),
    amount numeric(18,2),
    payment_method_label character varying(64),
    continuity_reason_code character varying(64) NOT NULL,
    record_status reconciliation.mops_transaction_record_status_enum NOT NULL,
    captured_at timestamp with time zone NOT NULL,
    imported_at timestamp with time zone,
    reconciled_at timestamp with time zone,
    rejected_at timestamp with time zone,
    disputed_at timestamp with time zone,
    failure_reason_code character varying(64),
    evidence_ref character varying(256),
    evidence_hash character(64),
    captured_by_user_id uuid REFERENCES identity.users(user_id),
    captured_by_service_identity_id uuid REFERENCES identity.service_identities(service_identity_id),
    imported_by_service_identity_id uuid,
    correlation_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    created_by_service_identity_id uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid,
    updated_by_service_identity_id uuid,
    row_version bigint DEFAULT 1 NOT NULL,
    CONSTRAINT ck_mops_transaction_records__amount_non_negative CHECK ((amount IS NULL) OR (amount >= (0)::numeric)),
    CONSTRAINT ck_mops_transaction_records__row_version_positive CHECK (row_version > 0)
);
