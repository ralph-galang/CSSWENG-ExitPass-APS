package com.exitpass.mops.dto;

import java.time.OffsetDateTime;
import java.util.List;

/**
 * Bundles the request/result/wrapper records for the exit-transaction
 * sync endpoint in one file, since they're small and only ever used
 * together.
 */
public final class ExitTransactionSyncDtos {

    private ExitTransactionSyncDtos() {
    }

    /** One locally-recorded exit transaction, as sent by the Flutter app. */
    public record ExitTransactionSyncItem(
            String idempotencyKey,
            String ticketNumber,
            String qrPayload,
            OffsetDateTime occurredAt,
            Integer amountMinorUnits,
            String currencyCode,
            String paymentMethod
    ) {
    }

    /** Wrapper so the request body is a named object, not a bare array. */
    public record ExitTransactionSyncRequest(
            List<ExitTransactionSyncItem> transactions
    ) {
    }

    /** Per-item outcome, so a partial batch failure doesn't fail everything. */
    public record ExitTransactionSyncResult(
            String idempotencyKey,
            boolean success,
            String errorMessage
    ) {
        public static ExitTransactionSyncResult ok(String idempotencyKey) {
            return new ExitTransactionSyncResult(idempotencyKey, true, null);
        }

        public static ExitTransactionSyncResult failed(String idempotencyKey, String errorMessage) {
            return new ExitTransactionSyncResult(idempotencyKey, false, errorMessage);
        }
    }

    public record ExitTransactionSyncResponse(
            List<ExitTransactionSyncResult> results
    ) {
    }
}
