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
import java.util.UUID;

/**
 * Wipes {@code projections.parking_sessions} and seeds exactly 50
 * deterministic rows on startup, for reproducible local testing of the
 * exit-checkout + sync workflow.
 *
 * SAFETY GUARDRAIL: gated with {@code @Profile("local")}. This is the
 * single thing standing between this class and a DELETE running against
 * staging/production data on every restart — do not relax this to
 * "local,test" or similar without separately confirming a "test" profile
 * can never point at a shared database.
 *
 * DEVIATION FROM SPEC — read before assuming this matches the request
 * literally: the task asked to "leave the time-in field blank." That's
 * not possible: {@code projections.parking_sessions.time_in} is
 * NOT NULL, per the already-applied V3 migration, which this class is
 * not allowed to touch (Flyway migrations are assumed already done, per
 * the task's own constraints). Seeding a NULL there would violate the
 * constraint and fail every insert. Instead, every row's time_in is set
 * to the exact moment the seeder runs ({@code now()}, captured once and
 * reused for all 50 rows) — no elapsed-time or rate math, just "the
 * session started existing now," which is the closest honest
 * approximation of "blank" that satisfies the schema. Flag this to
 * whoever wrote the original task constraint if a NULL is actually
 * required — that would mean a new Flyway migration relaxing the
 * NOT NULL constraint, which is a real schema change, not something to
 * silently work around here.
 *
 * TICKET NUMBER SCHEME: TCK-TEST-001 .. TCK-TEST-050, distinct from the
 * TCK-000001 style already used by V4's seed data, so this seeder's rows
 * are visually distinguishable from anything V4 already inserted and
 * don't collide on the unique ticket_number constraint if both are
 * present.
 */
@Component
@Profile("local")
public class ProjectionsDbSeeder implements CommandLineRunner {

    private static final int SEED_COUNT = 50;

    /** Dummy payment amount — no rate calculation, fixed for every row. */
    private static final BigDecimal DUMMY_RATE_PER_HOUR = BigDecimal.valueOf(0);

    /**
     * Must match a real, already-seeded site_id so the FK to sites.sites
     * succeeds. This is the TEST-SITE-01 site_id from V2__seed_test_data.sql
     * ('Test Mall Parking'). If your local V2 seed data ever changes this
     * UUID, update it here too.
     */
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

        for (int i = 1; i <= SEED_COUNT; i++) {
            String ticketNumber = String.format("TCK-TEST-%03d", i);
            String qrPayload = "QR-" + ticketNumber;
            String plateNumber = String.format("SEED %04d", i);

            ParkingSession session = new ParkingSession(
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
            );

            parkingSessionRepository.save(session);
        }
    }
}
