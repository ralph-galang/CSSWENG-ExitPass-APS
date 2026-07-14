package com.exitpass.mops.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.OffsetDateTime;
import java.util.UUID;

// NOTE: Postgres user-defined enum columns need @JdbcTypeCode(SqlTypes.NAMED_ENUM)
// on top of @Enumerated(STRING) in Hibernate 6, or every insert/select will fail
// with a "column is of type X but expression is of type varchar" error. Easy to
// miss -- flagging here since it'll bite the next enum-mapped entity too.
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

    // --- getters / setters ---
    public UUID getUserId() { return userId; }
    public void setUserId(UUID userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }
    public UserType getUserType() { return userType; }
    public void setUserType(UserType userType) { this.userType = userType; }
    public UserStatus getUserStatus() { return userStatus; }
    public void setUserStatus(UserStatus userStatus) { this.userStatus = userStatus; }
    public OffsetDateTime getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(OffsetDateTime lastLoginAt) { this.lastLoginAt = lastLoginAt; }
}
