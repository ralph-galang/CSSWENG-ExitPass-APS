package com.exitpass.mops.dto;

import java.time.OffsetDateTime;

public class LoginResponse {
    private String token;
    private OffsetDateTime expiresAt;
    private UserInfo user;
    private DeviceInfo device;

    public LoginResponse(String token, OffsetDateTime expiresAt, UserInfo user, DeviceInfo device) {
        this.token = token;
        this.expiresAt = expiresAt;
        this.user = user;
        this.device = device;
    }

    public String getToken() { return token; }
    public OffsetDateTime getExpiresAt() { return expiresAt; }
    public UserInfo getUser() { return user; }
    public DeviceInfo getDevice() { return device; }

    public static class UserInfo {
        public String userId;
        public String username;
        public String displayName;
        public String role; // role_code, e.g. SITE_OPERATOR

        public UserInfo(String userId, String username, String displayName, String role) {
            this.userId = userId; this.username = username;
            this.displayName = displayName; this.role = role;
        }
    }

    public static class DeviceInfo {
        public String deviceCode;
        public String siteCode;
        public String siteName;

        public DeviceInfo(String deviceCode, String siteCode, String siteName) {
            this.deviceCode = deviceCode; this.siteCode = siteCode; this.siteName = siteName;
        }
    }
}
