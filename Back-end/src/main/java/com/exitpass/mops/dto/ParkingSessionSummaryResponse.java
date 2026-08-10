package com.exitpass.mops.dto;

// Backs the dashboard's 3 top counters. totalSessions = unpaid+paid by
// construction (same table/instant, one query each) -- exposed explicitly
// so the frontend doesn't have to assume the invariant itself.
public record ParkingSessionSummaryResponse(
        long totalSessions,
        long unpaidSessions,
        long paidSessions
) {
}
