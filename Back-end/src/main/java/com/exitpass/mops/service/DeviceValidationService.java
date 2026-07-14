package com.exitpass.mops.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.Optional;

// Deliberately plain JdbcTemplate rather than full JPA entities for the
// `sites` schema -- login only needs a read-only lookup here, and building
// out the full sites.* entity graph belongs with backlog item 1 (Device
// Identity and Site Binding) proper, not bolted onto auth.
@Service
public class DeviceValidationService {

    private final JdbcTemplate jdbc;

    public DeviceValidationService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public record DeviceBinding(String deviceCode, String siteCode, String siteName) {}

    public Optional<DeviceBinding> findActiveBinding(String deviceCode) {
        String sql = """
            SELECT si.service_identity_code AS device_code,
                   s.site_code               AS site_code,
                   s.site_name               AS site_name
            FROM identity.service_identities si
            JOIN sites.device_assignments da ON da.service_identity_id = si.service_identity_id
            JOIN sites.sites s ON s.site_id = da.site_id
            WHERE si.service_identity_code = ?
              AND si.identity_status = 'ACTIVE'
              AND da.assignment_status = 'ACTIVE'
            LIMIT 1
            """;

        return jdbc.query(sql, rs -> {
            if (rs.next()) {
                return Optional.of(new DeviceBinding(
                        rs.getString("device_code"),
                        rs.getString("site_code"),
                        rs.getString("site_name")));
            }
            return Optional.empty();
        }, deviceCode);
    }
}
