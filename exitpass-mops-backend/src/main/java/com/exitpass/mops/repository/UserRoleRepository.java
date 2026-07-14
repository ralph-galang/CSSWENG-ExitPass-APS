package com.exitpass.mops.repository;

import com.exitpass.mops.entity.UserRoleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface UserRoleRepository extends JpaRepository<UserRoleEntity, UUID> {
    List<UserRoleEntity> findByUserIdAndAssignmentStatus(UUID userId, UserRoleEntity.AssignmentStatus status);
}
