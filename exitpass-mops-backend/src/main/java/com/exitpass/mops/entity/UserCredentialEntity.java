package com.exitpass.mops.entity;

import jakarta.persistence.*;
import java.util.UUID;

// ⚠️ LOCAL-TESTING-ONLY. Maps to identity.user_credentials, which does
// NOT exist in the real exitpass_v12_dev schema -- see README-TEST-DATA.md.
// Real user auth may need to defer to an external IdP/secret store instead,
// consistent with how every other credential-bearing table in the real
// schema stores a credential_reference rather than a raw hash. Confirm with
// the team before this pattern goes anywhere near a shared environment.
@Entity
@Table(name = "user_credentials", schema = "identity")
public class UserCredentialEntity {

    @Id
    @Column(name = "user_credential_id")
    private UUID userCredentialId;

    @Column(name = "user_id", nullable = false, unique = true)
    private UUID userId;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    public UUID getUserCredentialId() { return userCredentialId; }
    public void setUserCredentialId(UUID userCredentialId) { this.userCredentialId = userCredentialId; }
    public UUID getUserId() { return userId; }
    public void setUserId(UUID userId) { this.userId = userId; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
}
