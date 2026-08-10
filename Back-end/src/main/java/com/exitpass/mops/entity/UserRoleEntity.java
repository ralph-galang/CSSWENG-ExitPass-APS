package com.exitpass.mops.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.util.UUID;

@Entity
@Table(name = "user_roles", schema = "identity")
public class UserRoleEntity {

    @Id
    @Column(name = "user_role_id")
    private UUID userRoleId;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "role_id", nullable = false)
    private UUID roleId;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "assignment_status", nullable = false, columnDefinition = "identity.user_role_assignment_status_enum")
    private AssignmentStatus assignmentStatus;

    public enum AssignmentStatus { ACTIVE, SUSPENDED, REVOKED, EXPIRED, RETIRED }

    public UUID getRoleId() { return roleId; }
}
