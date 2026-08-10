package com.exitpass.mops.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.annotation.Order;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

// Matches the correlation_id convention already used across the real schema
// (e.g. mops_transaction_records.correlation_id) -- propagating it here
// gives new endpoints audit traceability for free.
@Component
@Order(1)
public class CorrelationIdFilter extends OncePerRequestFilter {

    public static final String HEADER = "X-Correlation-Id";

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain) throws ServletException, IOException {

        String correlationId = request.getHeader(HEADER);
        if (correlationId == null || correlationId.isBlank()) {
            correlationId = UUID.randomUUID().toString();
        }
        response.setHeader(HEADER, correlationId);
        // Request headers can't be mutated on the original request object,
        // so stash it as an attribute too -- GlobalExceptionHandler reads
        // this when the client didn't send one itself.
        request.setAttribute(HEADER, correlationId);
        filterChain.doFilter(request, response);
    }
}
