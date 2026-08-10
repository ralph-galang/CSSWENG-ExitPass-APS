package com.exitpass.mops.entity;

// Mirrors projections.session_payment_status_enum (V3). Deliberately only
// UNPAID/PAID -- no in-progress/partial state, matching the simplified
// stand-in tariff model.
public enum SessionPaymentStatus {
    UNPAID,
    PAID
}
