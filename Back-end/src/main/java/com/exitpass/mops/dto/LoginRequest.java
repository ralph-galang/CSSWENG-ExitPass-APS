package com.exitpass.mops.dto;

import jakarta.validation.constraints.NotBlank;

public class LoginRequest {

    @NotBlank
    private String username;

    @NotBlank
    private String password;

    // service_identity_code of the MoPS handheld, e.g. "MOPS-DEVICE-TEST-001".
    // Real device provisioning (backlog item 1) isn't built yet -- this is
    // just passed through and checked against sites.device_assignments.
    @NotBlank
    private String deviceCode;

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getDeviceCode() { return deviceCode; }
    public void setDeviceCode(String deviceCode) { this.deviceCode = deviceCode; }
}
