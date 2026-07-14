package com.exitpass.mops.dto;

public class ErrorResponse {
    private String errorCode;
    private String message;
    private String correlationId;

    public ErrorResponse(String errorCode, String message, String correlationId) {
        this.errorCode = errorCode;
        this.message = message;
        this.correlationId = correlationId;
    }

    public String getErrorCode() { return errorCode; }
    public String getMessage() { return message; }
    public String getCorrelationId() { return correlationId; }
}
