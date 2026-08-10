package com.exitpass.mops.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.OffsetDateTime;
import java.util.UUID;

// Postgres enum columns need @JdbcTypeCode(SqlTypes.NAMED_ENUM) +
// @Enumerated(STRING) in Hibernate 6, or inserts/selects fail with a type
// mismatch error -- easy to miss; will bite the next enum-mapped entity too.
@Entity
@Table(name = "users", schema = "identity")
public class UserEntity {

    @Id
    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "username", nullable = false, unique = true)
    private String username;

    @Column(name = "display_name", nullable = false)
    private String displayName;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "user_type", nullable = false, columnDefinition = "identity.user_type_enum")
    private UserType userType;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "user_status", nullable = false, columnDefinition = "identity.user_status_enum")
    private UserStatus userStatus;

    @Column(name = "last_login_at")
    private OffsetDateTime lastLoginAt;

    public enum UserType {
        INTERNAL_ADMIN, OPERATIONS_USER, SITE_OPERATOR, SUPPORT_USER, FINANCE_USER,
        COMPLIANCE_USER, MERCHANT_USER, SECURITY_USER, OTHER
    }

    public enum UserStatus {
        INVITED, ACTIVE, LOCKED, SUSPENDED, INACTIVE, RETIRED
    }

    public UUID getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getDisplayName() { return displayName; }
    public UserStatus getUserStatus() { return userStatus; }
}
