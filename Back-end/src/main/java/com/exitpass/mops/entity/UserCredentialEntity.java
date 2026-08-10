package com.exitpass.mops.entity;

import jakarta.persistence.*;
import java.util.UUID;

// LOCAL-TESTING-ONLY: identity.user_credentials does NOT exist in the real
// schema (see README-TEST-DATA.md). Real auth likely needs an external-IdP/
// credential_reference pattern instead -- confirm before reuse elsewhere.
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

    public String getPasswordHash() { return passwordHash; }
}
