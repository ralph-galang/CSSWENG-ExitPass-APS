package com.exitpass.mops.repository;

import com.exitpass.mops.entity.ParkingSession;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ParkingSessionRepository extends JpaRepository<ParkingSession, UUID> {

    Optional<ParkingSession> findByTicketNumber(String ticketNumber);

    Optional<ParkingSession> findByQrPayload(String qrPayload);
}
