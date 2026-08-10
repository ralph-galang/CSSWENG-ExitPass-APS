package com.exitpass.mops.service;

import com.exitpass.mops.dto.ExitTransactionSyncDtos.ExitTransactionSyncItem;
import com.exitpass.mops.dto.ExitTransactionSyncDtos.ExitTransactionSyncResult;
import com.exitpass.mops.entity.ParkingSession;
import com.exitpass.mops.entity.SessionPaymentStatus;
import com.exitpass.mops.repository.ParkingSessionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

// idempotencyKey is unique client-side but never persisted here (no ledger
// table in this stand-in schema) -- retries are safe (no-op if already PAID)
// but NOT idempotent against a genuine second payment for the same ticket.
@Service
public class ExitTransactionSyncService {

    private final ParkingSessionRepository parkingSessionRepository;

    public ExitTransactionSyncService(ParkingSessionRepository parkingSessionRepository) {
        this.parkingSessionRepository = parkingSessionRepository;
    }

    @Transactional
    public List<ExitTransactionSyncResult> applyAll(List<ExitTransactionSyncItem> items) {
        Map<String, ParkingSession> byTicketNumber = new HashMap<>();
        Map<String, ParkingSession> byQrPayload = new HashMap<>();

        List<String> ticketNumbers = items.stream()
                .map(ExitTransactionSyncItem::ticketNumber)
                .filter(t -> t != null)
                .toList();
        List<String> qrPayloads = items.stream()
                .map(ExitTransactionSyncItem::qrPayload)
                .filter(q -> q != null)
                .toList();

        if (!ticketNumbers.isEmpty()) {
            parkingSessionRepository.findByTicketNumberIn(ticketNumbers)
                    .forEach(s -> byTicketNumber.put(s.getTicketNumber(), s));
        }
        if (!qrPayloads.isEmpty()) {
            parkingSessionRepository.findByQrPayloadIn(qrPayloads)
                    .forEach(s -> byQrPayload.put(s.getQrPayload(), s));
        }

        List<ExitTransactionSyncResult> results = new ArrayList<>(items.size());
        List<ParkingSession> toSave = new ArrayList<>();

        for (ExitTransactionSyncItem item : items) {
            results.add(applyOne(item, byTicketNumber, byQrPayload, toSave));
        }

        parkingSessionRepository.saveAll(toSave);
        return results;
    }

    private ExitTransactionSyncResult applyOne(ExitTransactionSyncItem item,
                                                Map<String, ParkingSession> byTicketNumber,
                                                Map<String, ParkingSession> byQrPayload,
                                                List<ParkingSession> toSave) {
        Optional<ParkingSession> sessionOpt = resolveFromBatch(item, byTicketNumber, byQrPayload);

        if (sessionOpt.isEmpty()) {
            return ExitTransactionSyncResult.failed(
                    item.idempotencyKey(),
                    "No parking session found for ticketNumber=" + item.ticketNumber());
        }

        ParkingSession session = sessionOpt.get();

        if (session.getPaymentStatus() == SessionPaymentStatus.PAID) {
            // Already-PAID = retry or double-submission; safe no-op since the session
            // already reflects the state we'd be setting anyway.
            return ExitTransactionSyncResult.ok(item.idempotencyKey());
        }

        session.setTimeOut(item.occurredAt() != null ? item.occurredAt() : OffsetDateTime.now());
        session.setPaymentStatus(SessionPaymentStatus.PAID);
        session.setUpdatedAt(OffsetDateTime.now());
        toSave.add(session);

        return ExitTransactionSyncResult.ok(item.idempotencyKey());
    }

    private Optional<ParkingSession> resolveFromBatch(ExitTransactionSyncItem item,
                                                        Map<String, ParkingSession> byTicketNumber,
                                                        Map<String, ParkingSession> byQrPayload) {
        if (item.ticketNumber() != null && byTicketNumber.containsKey(item.ticketNumber())) {
            return Optional.of(byTicketNumber.get(item.ticketNumber()));
        }
        if (item.qrPayload() != null && byQrPayload.containsKey(item.qrPayload())) {
            return Optional.of(byQrPayload.get(item.qrPayload()));
        }
        return Optional.empty();
    }
}
