package com.exitpass.mops.controller;

import com.exitpass.mops.dto.ExitTransactionSyncDtos.ExitTransactionSyncRequest;
import com.exitpass.mops.dto.ExitTransactionSyncDtos.ExitTransactionSyncResponse;
import com.exitpass.mops.dto.ParkingSessionLookupResponse;
import com.exitpass.mops.entity.ParkingSession;
import com.exitpass.mops.repository.ParkingSessionRepository;
import com.exitpass.mops.service.ExitTransactionSyncService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

/**
 * Endpoints backing the "Exit Transactions and Sync" feature:
 *   - GET  /lookup — scan/enter-ticket step, queries the Projections DB.
 *   - POST /sync   — pushes locally-captured (Drift) exit transactions
 *                     back to the Projections DB, updating time_out and
 *                     payment_status.
 *
 * Scope note: nothing here touches incidents or manual gate action data —
 * those endpoints belong to a different developer's area.
 */
@RestController
@RequestMapping("/api/bcp")
public class BcpExitTransactionController {

    private final ParkingSessionRepository parkingSessionRepository;
    private final ExitTransactionSyncService syncService;

    public BcpExitTransactionController(ParkingSessionRepository parkingSessionRepository,
                                         ExitTransactionSyncService syncService) {
        this.parkingSessionRepository = parkingSessionRepository;
        this.syncService = syncService;
    }

    @GetMapping("/parking-sessions/lookup")
    public ResponseEntity<ParkingSessionLookupResponse> lookup(
            @RequestParam(required = false) String ticketNumber,
            @RequestParam(required = false) String qrPayload) {

        if (ticketNumber == null && qrPayload == null) {
            return ResponseEntity.badRequest().build();
        }

        Optional<ParkingSession> session = ticketNumber != null
                ? parkingSessionRepository.findByTicketNumber(ticketNumber)
                : parkingSessionRepository.findByQrPayload(qrPayload);

        return session
                .map(ParkingSessionLookupResponse::from)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/exit-transactions/sync")
    public ResponseEntity<ExitTransactionSyncResponse> sync(
            @RequestBody ExitTransactionSyncRequest request) {

        var results = syncService.applyAll(request.transactions());
        return ResponseEntity.ok(new ExitTransactionSyncResponse(results));
    }
}
