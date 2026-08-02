package com.exitpass.mops.dto;

import com.exitpass.mops.entity.ParkingSession;

/**
 * Deliberately thin — no amount-due / elapsed-time figures, since the
 * exit-checkout flow takes a dummy payment and does no rate calculation
 * on either side, per the current scope of this feature.
 */
public record ParkingSessionLookupResponse(
        String ticketNumber,
        String qrPayload,
        String plateNumber,
        String paymentStatus
) {
    public static ParkingSessionLookupResponse from(ParkingSession session) {
        return new ParkingSessionLookupResponse(
                session.getTicketNumber(),
                session.getQrPayload(),
                session.getPlateNumber(),
                session.getPaymentStatus().name()
        );
    }
}
