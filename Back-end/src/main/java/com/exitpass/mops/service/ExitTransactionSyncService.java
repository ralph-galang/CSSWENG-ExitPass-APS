package com.exitpass.mops.service;

import com.exitpass.mops.dto.ExitTransactionSyncDtos.ExitTransactionSyncItem;
import com.exitpass.mops.dto.ExitTransactionSyncDtos.ExitTransactionSyncResult;
import com.exitpass.mops.entity.ParkingSession;
import com.exitpass.mops.entity.SessionPaymentStatus;
import com.exitpass.mops.repository.ParkingSessionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Applies exit-transaction sync items to {@code projections.parking_sessions}.
 *
 * NOTE on idempotency: {@code idempotencyKey} is generated client-side per
 * local Drift row and is unique there, but this table (an invented stand-in
 * — see V3's header comment) doesn't have anywhere to persist "already
 * applied" idempotency keys itself. As written, a retried sync of the same
 * item is safe in effect (setting time_out/PAID again is a no-op the
 * second time), but not strictly idempotent against a *second real
 * payment* for the same ticket after the first already succeeded — that
 * case is treated as "already PAID, reject" below. If exact-once semantics
 * beyond that become a hard requirement, this needs its own idempotency-key
 * ledger table, which is out of scope for this pass since it isn't part of
 * the client-provided schema either.
 */
@Service
public class ExitTransactionSyncService {

    private final ParkingSessionRepository parkingSessionRepository;

    public ExitTransactionSyncService(ParkingSessionRepository parkingSessionRepository) {
        this.parkingSessionRepository = parkingSessionRepository;
    }

    @Transactional
    public List<ExitTransactionSyncResult> applyAll(List<ExitTransactionSyncItem> items) {
        return items.stream()
                .map(this::applyOne)
                .collect(Collectors.toList());
    }

    private ExitTransactionSyncResult applyOne(ExitTransactionSyncItem item) {
        Optional<ParkingSession> sessionOpt = resolveSession(item);

        if (sessionOpt.isEmpty()) {
            return ExitTransactionSyncResult.failed(
                    item.idempotencyKey(),
                    "No parking session found for ticketNumber=" + item.ticketNumber());
        }

        ParkingSession session = sessionOpt.get();

        if (session.getPaymentStatus() == SessionPaymentStatus.PAID) {
            // Already applied (retry) or a genuine double-submission. Either
            // way this is a safe no-op rather than an error, since the
            // session already reflects the paid/exited state we'd be
            // setting anyway.
            return ExitTransactionSyncResult.ok(item.idempotencyKey());
        }

        session.setTimeOut(item.occurredAt() != null ? item.occurredAt() : OffsetDateTime.now());
        session.setPaymentStatus(SessionPaymentStatus.PAID);
        session.setUpdatedAt(OffsetDateTime.now());
        parkingSessionRepository.save(session);

        return ExitTransactionSyncResult.ok(item.idempotencyKey());
    }

    private Optional<ParkingSession> resolveSession(ExitTransactionSyncItem item) {
        if (item.ticketNumber() != null) {
            Optional<ParkingSession> byTicket =
                    parkingSessionRepository.findByTicketNumber(item.ticketNumber());
            if (byTicket.isPresent()) {
                return byTicket;
            }
        }
        if (item.qrPayload() != null) {
            return parkingSessionRepository.findByQrPayload(item.qrPayload());
        }
        return Optional.empty();
    }
}
