package com.exitpass.mops.service;

import com.exitpass.mops.dto.LoginRequest;
import com.exitpass.mops.dto.LoginResponse;
import com.exitpass.mops.entity.RoleEntity;
import com.exitpass.mops.entity.UserCredentialEntity;
import com.exitpass.mops.entity.UserEntity;
import com.exitpass.mops.entity.UserRoleEntity;
import com.exitpass.mops.exception.AuthException;
import com.exitpass.mops.repository.RoleRepository;
import com.exitpass.mops.repository.UserCredentialRepository;
import com.exitpass.mops.repository.UserRepository;
import com.exitpass.mops.repository.UserRoleRepository;
import com.exitpass.mops.security.JwtService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final UserCredentialRepository userCredentialRepository;
    private final UserRoleRepository userRoleRepository;
    private final RoleRepository roleRepository;
    private final DeviceValidationService deviceValidationService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(
            UserRepository userRepository,
            UserCredentialRepository userCredentialRepository,
            UserRoleRepository userRoleRepository,
            RoleRepository roleRepository,
            DeviceValidationService deviceValidationService,
            PasswordEncoder passwordEncoder,
            JwtService jwtService) {
        this.userRepository = userRepository;
        this.userCredentialRepository = userCredentialRepository;
        this.userRoleRepository = userRoleRepository;
        this.roleRepository = roleRepository;
        this.deviceValidationService = deviceValidationService;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest request) {
        // 1. Device/site validation first -- BRD frames this as a
        // Zero-Trust check that should happen before credentials are
        // even considered, so an unrecognized device fails fast.
        var binding = deviceValidationService.findActiveBinding(request.getDeviceCode())
                .orElseThrow(() -> new AuthException("UNRECOGNIZED_DEVICE",
                        "Device is not recognized or not bound to an active site."));

        // 2. Look up user + verify password.
        UserEntity user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new AuthException("INVALID_CREDENTIALS", "Invalid username or password."));

        if (user.getUserStatus() != UserEntity.UserStatus.ACTIVE) {
            throw new AuthException("USER_NOT_ACTIVE", "User account is not active.");
        }

        UserCredentialEntity credential = userCredentialRepository.findByUserId(user.getUserId())
                .orElseThrow(() -> new AuthException("INVALID_CREDENTIALS", "Invalid username or password."));

        if (!passwordEncoder.matches(request.getPassword(), credential.getPasswordHash())) {
            throw new AuthException("INVALID_CREDENTIALS", "Invalid username or password.");
        }

        // 3. Resolve the user's active role.
        List<UserRoleEntity> activeAssignments =
                userRoleRepository.findByUserIdAndAssignmentStatus(user.getUserId(), UserRoleEntity.AssignmentStatus.ACTIVE);

        if (activeAssignments.isEmpty()) {
            throw new AuthException("NO_ACTIVE_ROLE", "User has no active role assignment.");
        }

        RoleEntity role = roleRepository.findById(activeAssignments.get(0).getRoleId())
                .orElseThrow(() -> new AuthException("NO_ACTIVE_ROLE", "Assigned role could not be resolved."));

        // 4. Issue JWT and build response.
        String token = jwtService.issueToken(
                user.getUserId().toString(), user.getUsername(), role.getRoleCode(),
                binding.deviceCode(), binding.siteCode());

        return new LoginResponse(
                token,
                jwtService.expiryFor(token),
                new LoginResponse.UserInfo(
                        user.getUserId().toString(), user.getUsername(), user.getDisplayName(), role.getRoleCode()),
                new LoginResponse.DeviceInfo(binding.deviceCode(), binding.siteCode(), binding.siteName())
        );
    }
}
