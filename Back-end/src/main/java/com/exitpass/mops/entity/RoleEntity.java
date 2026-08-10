package com.exitpass.mops.entity;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "roles", schema = "identity")
public class RoleEntity {

    @Id
    @Column(name = "role_id")
    private UUID roleId;

    @Column(name = "role_code", nullable = false, unique = true)
    private String roleCode;

    @Column(name = "role_name", nullable = false)
    private String roleName;

    public String getRoleCode() { return roleCode; }
}
