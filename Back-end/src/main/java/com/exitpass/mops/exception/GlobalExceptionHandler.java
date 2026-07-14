package com.exitpass.mops.exception;

import com.exitpass.mops.dto.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AuthException.class)
    public ResponseEntity<ErrorResponse> handleAuthException(AuthException ex, HttpServletRequest request) {
        String correlationId = correlationIdFrom(request);
        HttpStatus status = "UNRECOGNIZED_DEVICE".equals(ex.getErrorCode()) || "INVALID_CREDENTIALS".equals(ex.getErrorCode())
                ? HttpStatus.UNAUTHORIZED
                : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status)
                .body(new ErrorResponse(ex.getErrorCode(), ex.getMessage(), correlationId));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex, HttpServletRequest request) {
        return ResponseEntity.badRequest()
                .body(new ErrorResponse("VALIDATION_ERROR", "Request failed validation.", correlationIdFrom(request)));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception ex, HttpServletRequest request) {
        return ResponseEntity.internalServerError()
                .body(new ErrorResponse("INTERNAL_ERROR", "Unexpected server error.", correlationIdFrom(request)));
    }

    private String correlationIdFrom(HttpServletRequest request) {
        Object attr = request.getAttribute("X-Correlation-Id");
        if (attr != null) return attr.toString();
        String header = request.getHeader("X-Correlation-Id");
        return header != null ? header : "unknown";
    }
}
