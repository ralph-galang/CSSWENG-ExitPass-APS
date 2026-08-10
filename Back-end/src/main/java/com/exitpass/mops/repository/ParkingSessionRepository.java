package com.exitpass.mops.repository;

import com.exitpass.mops.entity.ParkingSession;
import com.exitpass.mops.entity.SessionPaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ParkingSessionRepository extends JpaRepository<ParkingSession, UUID> {

    Optional<ParkingSession> findByTicketNumber(String ticketNumber);

    Optional<ParkingSession> findByQrPayload(String qrPayload);

    List<ParkingSession> findByTicketNumberIn(Collection<String> ticketNumbers);

    List<ParkingSession> findByQrPayloadIn(Collection<String> qrPayloads);

    long countByPaymentStatus(SessionPaymentStatus paymentStatus);

    // Shared ticket/QR lookup: tries ticketNumber first, falls back to qrPayload.
    default Optional<ParkingSession> resolveByTicketOrQr(String ticketNumber, String qrPayload) {
        if (ticketNumber != null) {
            Optional<ParkingSession> byTicket = findByTicketNumber(ticketNumber);
            if (byTicket.isPresent()) {
                return byTicket;
            }
        }
        if (qrPayload != null) {
            return findByQrPayload(qrPayload);
        }
        return Optional.empty();
    }
}
