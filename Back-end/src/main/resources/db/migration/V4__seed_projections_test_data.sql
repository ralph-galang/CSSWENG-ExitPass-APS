-- =====================================================================
-- V4__seed_projections_test_data.sql
--
-- Sample parking sessions for testing the normal-case BCP lookup flow
-- (scan/enter ticket -> find session -> compute amount due -> pay).
-- Uses relative offsets from now() rather than fixed timestamps so the
-- "time in" values stay realistic no matter when this migration
-- actually runs, rather than silently becoming stale test data months
-- from now.
--
-- References the test site/lane seeded in V2 -- see that file for the
-- site_group/site/lane values these rows depend on.
-- =====================================================================

INSERT INTO projections.parking_sessions (
    ticket_number, qr_payload, plate_number, site_id,
    time_in, rate_per_hour, payment_status
) VALUES
    -- Still parked, unpaid -- the "happy path" normal-case lookup target.
    (
        'TCK-000001', 'QR-TCK-000001', 'ABC 1234',
        '22222222-2222-2222-2222-222222222222',
        now() - interval '2 hours 15 minutes', 40.00, 'UNPAID'
    ),
    -- A second unpaid session, different plate, for testing that lookup
    -- returns the right row and doesn't just grab "the first one."
    (
        'TCK-000002', 'QR-TCK-000002', 'XYZ 5678',
        '22222222-2222-2222-2222-222222222222',
        now() - interval '45 minutes', 40.00, 'UNPAID'
    ),
    -- Longer stay, still unpaid -- useful for sanity-checking the
    -- elapsed-time x rate calculation isn't just eyeballed right for
    -- short durations.
    (
        'TCK-000003', 'QR-TCK-000003', 'DEF 9012',
        '22222222-2222-2222-2222-222222222222',
        now() - interval '1 day 3 hours', 40.00, 'UNPAID'
    );
