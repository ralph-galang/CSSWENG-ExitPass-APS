package com.exitpass.mops.service;

import com.exitpass.mops.entity.ParkingSession;
import com.exitpass.mops.entity.SessionPaymentStatus;
import com.exitpass.mops.repository.ParkingSessionRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Wipes projections.parking_sessions and seeds 50 deterministic rows on
 * startup for reproducible local testing.
 *
 * SAFETY GUARDRAIL: gated to @Profile("local") -- the only thing preventing
 * this DELETE from running against a shared database on restart. Don't
 * loosen this without confirming no non-local profile can point at shared data.
 */
@Component
@Profile("local")
public class ProjectionsDbSeeder implements CommandLineRunner {

    private static final int SEED_COUNT = 50;

    /** Dummy payment amount — no rate calculation, fixed for every row. */
    private static final BigDecimal DUMMY_RATE_PER_HOUR = BigDecimal.valueOf(0);

    // Must match TEST-SITE-01's site_id from V2__seed_test_data.sql ('Test Mall
    // Parking') for the FK to sites.sites to succeed -- update here too if V2
    // ever changes that UUID.
    private static final UUID TEST_SITE_ID =
            UUID.fromString("22222222-2222-2222-2222-222222222222");

    private final ParkingSessionRepository parkingSessionRepository;

    public ProjectionsDbSeeder(ParkingSessionRepository parkingSessionRepository) {
        this.parkingSessionRepository = parkingSessionRepository;
    }

    @Override
    @Transactional
    public void run(String... args) {
        parkingSessionRepository.deleteAllInBatch();

        OffsetDateTime seedTime = OffsetDateTime.now();

        List<ParkingSession> sessions = new ArrayList<>(SEED_COUNT);
        for (int i = 1; i <= SEED_COUNT; i++) {
            String ticketNumber = String.format("TCK-TEST-%03d", i);
            String qrPayload = "QR-" + ticketNumber;
            String plateNumber = String.format("SEED %04d", i);

            sessions.add(new ParkingSession(
                    UUID.randomUUID(),
                    ticketNumber,
                    qrPayload,
                    plateNumber,
                    TEST_SITE_ID,
                    seedTime,               // time_in — see class doc: can't be null, so "now" not a real elapsed duration.
                    DUMMY_RATE_PER_HOUR,    // no rate calc; dummy payment only.
                    SessionPaymentStatus.UNPAID,
                    seedTime,
                    seedTime
            ));
        }

        parkingSessionRepository.saveAll(sessions);
    }
}
