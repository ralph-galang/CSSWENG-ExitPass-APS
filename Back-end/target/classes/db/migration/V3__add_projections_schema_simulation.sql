-- =====================================================================
-- V3__add_projections_schema_simulation.sql
--
-- Local simulation of the client's real "Projections DB" for ticket /
-- parking session lookup during BCP mode.
--
-- IMPORTANT: this is NOT part of the real client-provided schema. The
-- dump this project's schema was reconstructed from (see V1's header
-- comment) only covered identity/sites/reconciliation -- no real
-- Projections DB schema has ever been provided, and what the client HAS
-- given us for this area is outdated/incomplete. Everything below is
-- our own invented stand-in, good enough to exercise the full BCP-mode
-- lookup -> pay -> sync workflow end to end against a real backend
-- rather than hand-waved local test data.
--
-- Kept in its own `projections` schema (rather than mixed into `sites`
-- or `reconciliation`) specifically so it stays obvious which parts of
-- this database came from the client's real dump and which parts we
-- made up ourselves. Expect this to be REPLACED, not just tweaked, once
-- the real Projections DB schema/API is provided -- don't build
-- long-term assumptions on top of these exact column names.
--
-- Architecture note: the client described Central DB replicating to a
-- Projections DB every minute, both server-side. The MoPS app looks up
-- sessions here over the network (via a backend endpoint querying this
-- table), even when Central PMS itself is unreachable -- this is NOT
-- data that lives on the device. Compare to `reconciliation`, which is
-- real client-provided schema; and to the Front-end's local Drift
-- database, which only holds Incidents/Exceptions/ManualGateLogs/
-- Transactions -- never parking session data.
-- =====================================================================

CREATE SCHEMA IF NOT EXISTS projections;

CREATE TYPE projections.session_payment_status_enum AS ENUM (
    'UNPAID',
    'PAID'
);

CREATE TABLE projections.parking_sessions (
    parking_session_id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,

    -- What the operator scans or types in.
    ticket_number varchar(64) NOT NULL,
    qr_payload varchar(256),
    plate_number varchar(32),

    site_id uuid NOT NULL REFERENCES sites.sites(site_id),

    time_in timestamp with time zone NOT NULL,
    -- Null until the MoPS app syncs the transaction that paid for this
    -- session. Set to that transaction's exit timestamp at that point.
    time_out timestamp with time zone,

    -- Flat hourly rate used to compute amount due (elapsed time x rate).
    -- Deliberate simplification versus the BRD's real tariff model
    -- (Vendor-PMS-owned, snapshot-based, grace periods, statutory
    -- discounts, etc.) -- this is only meant to be realistic enough to
    -- test the workflow, not a real tariff engine.
    rate_per_hour numeric(10, 2) NOT NULL,

    payment_status projections.session_payment_status_enum NOT NULL DEFAULT 'UNPAID',

    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),

    CONSTRAINT uq_parking_sessions_ticket_number UNIQUE (ticket_number)
);

-- Lookup by ticket number (manual entry) or QR payload (scan) are both
-- primary access patterns per the app's Scan/Enter Ticket screen.
CREATE INDEX idx_parking_sessions_ticket_number
    ON projections.parking_sessions (ticket_number);

CREATE INDEX idx_parking_sessions_qr_payload
    ON projections.parking_sessions (qr_payload)
    WHERE qr_payload IS NOT NULL;

-- Fast "does this session already have an unresolved lookup available"
-- filter -- useful once there's an endpoint listing active sessions per
-- site for dashboard/testing purposes.
CREATE INDEX idx_parking_sessions_site_payment_status
    ON projections.parking_sessions (site_id, payment_status);
