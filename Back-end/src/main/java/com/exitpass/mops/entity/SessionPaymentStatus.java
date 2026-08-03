package com.exitpass.mops.entity;

/**
 * Mirrors {@code projections.session_payment_status_enum} from
 * V3__add_projections_schema_simulation.sql. Only two values exist —
 * there is deliberately no in-progress/partial state, matching the
 * simplified stand-in tariff model described in that migration.
 */
public enum SessionPaymentStatus {
    UNPAID,
    PAID
}
