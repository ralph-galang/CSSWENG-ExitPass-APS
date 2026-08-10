package com.exitpass.mops.dto;

import com.exitpass.mops.entity.ParkingSession;

// Deliberately thin: no amount-due/elapsed-time fields, since exit-checkout
// takes a dummy payment with no rate calc on either side (current scope).
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
