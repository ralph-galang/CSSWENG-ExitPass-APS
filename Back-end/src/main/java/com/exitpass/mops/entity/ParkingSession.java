package com.exitpass.mops.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * Maps to {@code projections.parking_sessions}, created in
 * V3__add_projections_schema_simulation.sql. This is our own invented
 * stand-in schema (see that migration's header comment) — NOT the
 * client's real Projections DB schema, which hasn't been provided yet.
 * Expect this entity to be replaced, not just tweaked, once that arrives.
 *
 * Scope note: this entity, its repository, and the sync/lookup/seed code
 * built around it only cover the "Exit Transactions and Sync" feature.
 * incidents / manual gate actions are out of scope and untouched here.
 */
@Entity
@Table(name = "parking_sessions", schema = "projections")
public class ParkingSession {

    @Id
    @Column(name = "parking_session_id")
    private UUID parkingSessionId;

    @Column(name = "ticket_number", nullable = false, unique = true)
    private String ticketNumber;

    @Column(name = "qr_payload")
    private String qrPayload;

    @Column(name = "plate_number")
    private String plateNumber;

    @Column(name = "site_id", nullable = false)
    private UUID siteId;

    @Column(name = "time_in", nullable = false)
    private OffsetDateTime timeIn;

    @Column(name = "time_out")
    private OffsetDateTime timeOut;

    @Column(name = "rate_per_hour", nullable = false)
    private BigDecimal ratePerHour;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "payment_status", nullable = false, columnDefinition = "projections.session_payment_status_enum")
    private SessionPaymentStatus paymentStatus;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    protected ParkingSession() {
        // JPA
    }

    public ParkingSession(UUID parkingSessionId, String ticketNumber, String qrPayload,
                           String plateNumber, UUID siteId, OffsetDateTime timeIn,
                           BigDecimal ratePerHour, SessionPaymentStatus paymentStatus,
                           OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        this.parkingSessionId = parkingSessionId;
        this.ticketNumber = ticketNumber;
        this.qrPayload = qrPayload;
        this.plateNumber = plateNumber;
        this.siteId = siteId;
        this.timeIn = timeIn;
        this.ratePerHour = ratePerHour;
        this.paymentStatus = paymentStatus;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public UUID getParkingSessionId() {
        return parkingSessionId;
    }

    public String getTicketNumber() {
        return ticketNumber;
    }

    public String getQrPayload() {
        return qrPayload;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public UUID getSiteId() {
        return siteId;
    }

    public OffsetDateTime getTimeIn() {
        return timeIn;
    }

    public OffsetDateTime getTimeOut() {
        return timeOut;
    }

    public void setTimeOut(OffsetDateTime timeOut) {
        this.timeOut = timeOut;
    }

    public BigDecimal getRatePerHour() {
        return ratePerHour;
    }

    public SessionPaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(SessionPaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
