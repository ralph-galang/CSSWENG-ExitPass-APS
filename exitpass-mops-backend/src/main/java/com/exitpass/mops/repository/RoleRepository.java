package com.exitpass.mops.repository;

import com.exitpass.mops.entity.RoleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface RoleRepository extends JpaRepository<RoleEntity, UUID> {
}
