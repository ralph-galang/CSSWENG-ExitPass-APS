# ExitPass Engineering Context

Document: ExitPass Engineering Context
Version: 1.0
Status: Living Document
Project: ExitPass Android MoPS Application
Repository: CSSWENG-ExitPass-APS
Primary Audience:
  - Developers
  - Technical Reviewers
  - Large Language Models
Authoritative Sources:
  - BRD v1.2
  - Scope of Work
  - Product Backlog
Related Documents:
  - Reading Map
  - Flutter Repository
Last Updated: July 2026

---

# 1. Purpose

## 1.1 Purpose of this Document

This document serves as the primary engineering context for the ExitPass Android Flutter application. It consolidates the architectural intent, project scope, implementation boundaries, development philosophy, and documentation hierarchy into a single reference that can be consumed by both human developers and Large Language Models (LLMs).

The goal of this document is **not** to replace the official project documentation. Instead, it provides a curated interpretation of the project by identifying which documents are authoritative for specific concerns, summarizing key architectural concepts, documenting known inconsistencies, and describing the current state of the Flutter implementation.

Future development should treat this document as the primary onboarding reference before consulting the underlying specifications.

---

## 1.2 What this Document Is

This document is intended to:

- Provide a concise overview of the ExitPass project.
- Explain the scope of this Flutter repository.
- Define the documentation precedence hierarchy.
- Describe the current implementation status.
- Summarize important business concepts from the BRD.
- Document known inconsistencies across project artifacts.
- Establish engineering conventions and development philosophy.
- Help future AI assistants understand the project without repeatedly parsing hundreds of pages of documentation.

---

## 1.3 What this Document Is Not

This document does **not** replace or supersede any official project artifact.

Specifically, it is **not**:

- The Business Requirements Document (BRD)
- The Scope of Work (SOW)
- The Product Backlog
- The System Design Document (SDD)
- The API Contract Pack
- The Database Design
- The Engineering Pack

Whenever detailed implementation rules, business requirements, or architectural decisions are needed, developers should consult the appropriate source document according to the documentation hierarchy defined in Section 3.

---

# 2. Project Summary

## 2.1 ExitPass Overview

ExitPass is a centralized parking payment orchestration platform designed to enable cashierless parking operations while preserving the authority of existing Vendor Parking Management Systems (Vendor PMS).

Rather than replacing deployed parking infrastructure, ExitPass operates as an orchestration layer responsible for payment coordination, financial governance, reconciliation, and exit authorization while integrating with multiple Vendor PMS implementations through standardized adapters.

The overall ExitPass ecosystem consists of multiple independent systems operating within clearly defined authority boundaries.

Examples include:

- Vendor Parking Management Systems
- Central PMS
- Payment Orchestrator
- Merchant Wallet Services
- Payment Providers
- Gate and Barrier Controllers
- Android MoPS Devices
- Administrative Portals

This repository implements only one component of that ecosystem.

---

## 2.2 This Repository

This repository contains the Android Flutter application used on Mobile Point of Service (MoPS) devices.

The application is an operator-facing mobile application intended to support operational continuity workflows under the bounded scope defined by the approved Scope of Work.

The application is **not** the customer-facing ExitPass application, nor is it an implementation of the Central PMS.

Instead, it functions as an operational client that records transactions, captures operational evidence, supports offline operation, and synchronizes collected information with backend services for later reconciliation.

---

## 2.3 Repository Objectives

The primary objectives of this repository are to:

- authenticate authorized operators
- identify registered devices
- support continuity-mode operational workflows
- capture transaction metadata
- collect operational evidence
- support offline-first operation
- synchronize queued transactions
- maintain auditability and traceability
- integrate with provided backend interfaces

The application intentionally avoids assuming responsibilities belonging to other systems within the ExitPass architecture.

---

# 3. Documentation Hierarchy

ExitPass consists of multiple project documents created for different audiences and purposes.

These documents occasionally overlap and, in several cases, contain inconsistencies or incomplete information.

When documentation conflicts occur, the following precedence order shall be used.

| Priority | Document | Authority |
|----------|----------|-----------|
| 1 | Business Requirements Document (BRD v1.2) | Business rules, authority model, workflows, invariants, security principles, state machines |
| 2 | Scope of Work (Android MoPS Application) | Defines the implementation scope and responsibilities of this repository |
| 3 | Product Backlog | Defines implementation priorities and sprint scope |
| 4 | Existing Flutter Repository | Defines the current architecture, folder organization, naming conventions, navigation, and UI philosophy |
| 5 | Reading Map | Serves as a navigation guide to project documentation but does not supersede higher-priority documents |
| 6 | ExitPass Engineering Context | Consolidated interpretation of the above sources |

Whenever conflicts arise, higher-priority documents shall take precedence.

---

## 3.1 Missing Documentation

Several documents referenced by the Reading Map are currently unavailable within this repository.

These include:

- System Design Document (SDD)
- API Contract Pack
- Database Design
- Engineering Pack
- HikCentral Integration Documentation

As a result, technical implementation details such as REST endpoint definitions, DTO structures, synchronization contracts, and database schemas cannot currently be treated as authoritative unless additional documentation is provided.

Where implementation details are absent, development should remain consistent with the BRD and Scope of Work while avoiding assumptions about undocumented interfaces.

---

# 4. Repository Scope

This Flutter repository represents a bounded component of the larger ExitPass ecosystem.

Its responsibility is intentionally limited.

## In Scope

The application is responsible for:

- Operator authentication
- Device registration and site association
- Continuity-mode transaction capture
- Manual operational workflows
- Evidence collection
- Offline transaction storage
- Transaction synchronization
- Audit metadata collection
- Integration with provided backend interfaces
- User interface implementation

## Out of Scope

The application is **not** responsible for:

- Customer-facing parking payments
- Parking session creation
- Entry processing
- Ticket issuance
- Tariff computation
- Payment finality
- Exit authorization
- Vendor PMS implementation
- Central PMS implementation
- Payment gateway implementation
- Barrier controller implementation
- Financial settlement
- Reconciliation decision-making

These responsibilities belong to other systems within the ExitPass architecture.

---

# 5. Current Repository Status

## 5.1 Current Maturity

The Flutter repository currently represents an early-stage functional prototype.

Its primary purpose is to establish navigation, user interface patterns, and screen structure rather than complete business functionality.

Current implementation emphasizes visual workflow validation rather than production-ready backend integration.

---

## 5.2 Existing Screens

The repository currently contains the following primary screens:

- Login
- Dashboard
- Scan Ticket
- Manual Transaction
- Ticket Detail
- Sync Transactions
- Settings

These screens should be viewed as an evolving foundation rather than a finalized implementation of the approved Scope of Work.

Future development should adapt these screens to align with the business workflows defined by the BRD, Scope of Work, and Product Backlog while preserving existing navigation and UI consistency wherever practical.

---

## 5.3 Current Architecture

The current project consists primarily of:

- Flutter UI
- Shared widgets
- Application theme
- Navigation
- Static screen implementations

The following layers are not yet fully implemented:

- Authentication
- API integration
- Repository layer
- Local persistence
- Offline synchronization engine
- Business services
- State management architecture
- Audit services
- Device registration
- Evidence capture
- Backend integration

These capabilities are expected to be introduced incrementally according to the approved Product Backlog.

---

## 5.4 Development Philosophy

This repository should be evolved rather than rewritten.

Future implementation should prioritize:

- extending existing screens instead of replacing them
- preserving established UI conventions
- maintaining modular Flutter architecture
- introducing production-quality business logic incrementally
- avoiding unnecessary redesigns
- remaining consistent with the approved project documentation

Unless explicitly requested, contributors should avoid large-scale architectural refactoring in favor of incremental improvements that preserve existing work.

# 6. Business Domain Overview

Understanding the business domain is more important than understanding the Flutter codebase. The Android application exists within a much larger distributed parking ecosystem where each component has a strictly defined responsibility.

Developers should think of the Flutter application as one operational client among several cooperating systems rather than as a standalone parking management application.

---

## 6.1 Authority Separation

ExitPass follows a strict authority separation model.

Each subsystem owns a specific business responsibility and should never assume the responsibilities of another.

| Component | Primary Authority |
|------------|------------------|
| Vendor PMS | Parking session lifecycle and tariff computation |
| Central PMS | Payment finality, exit authorization, reconciliation |
| Payment Orchestrator | Verified payment outcome reporting |
| Android MoPS App | Continuity-mode transaction capture and evidence collection |
| Gate Controller | Physical barrier control |

The Android application must never become authoritative for responsibilities belonging to another component.

---

## 6.2 Operational Philosophy

The application exists primarily to support continuity operations.

Its purpose is to continue capturing operational records during exceptional circumstances while preserving auditability and allowing backend reconciliation after normal operations resume.

The application should prioritize:

- operational continuity
- traceability
- auditability
- evidence preservation
- synchronization
- data integrity

over convenience or automation.

---

## 6.3 Offline-First Design

Unlike conventional mobile applications, the Android MoPS application must assume that network connectivity may be unavailable during operation.

Core workflows should therefore be designed around:

- local persistence
- deferred synchronization
- idempotent retries
- conflict avoidance
- audit preservation

Synchronization is an extension of transaction capture rather than its prerequisite.

---

# 7. Business Invariants

The following principles should remain true regardless of implementation.

These are derived from the BRD and should never be violated.

## Authority

The Android application:

- never computes parking fees
- never determines tariff rules
- never finalizes payments
- never issues exit authorization
- never replaces the Vendor PMS
- never replaces the Central PMS

---

## Audit

Every operational action should be attributable.

Operators, devices, timestamps, site identifiers, and synchronization status should always be traceable.

No silent data mutation should occur after capture.

---

## Synchronization

Synchronization should preserve transaction identity.

Retrying synchronization must not create duplicate records.

Idempotency should be preserved whenever backend interfaces support it.

---

## Failure Handling

The application should fail safely.

If an operation cannot be completed confidently, the system should preserve the transaction for later review rather than attempting unsupported recovery.

---

# 8. Flutter Architecture Strategy

The current repository represents a UI-first prototype.

Future development should introduce additional layers incrementally without disrupting the existing navigation or screen organization.

The intended architecture is illustrated below.

UI

↓

Controllers / State Management

↓

Business Services

↓

Repositories

↓

Local Storage + API Layer

↓

Backend Services

---

## Architectural Principles

Future implementation should emphasize:

- modular widgets
- reusable components
- separation of concerns
- dependency inversion where practical
- testability
- maintainability

Avoid introducing unnecessary complexity before business functionality requires it.

---

## Repository Evolution

Existing screens should be extended rather than replaced.

Placeholder logic should gradually be replaced with production-ready implementations while preserving user experience and navigation.

---

# 9. Flutter Prototype Mapping

The current prototype establishes navigation and user interaction patterns.

Although individual screens may evolve, their overall workflow should remain familiar to operators.

| Existing Screen | Intended Evolution |
|-----------------|-------------------|
| Login | Operator authentication and device validation |
| Dashboard | Operational overview and continuity dashboard |
| Scan Ticket | Transaction/session identification |
| Manual Transaction | Manual continuity transaction workflow |
| Ticket Detail | Transaction review and evidence summary |
| Sync Transactions | Offline synchronization queue |
| Settings | Device registration, site binding, configuration |

The objective is to evolve the prototype into the approved application rather than redesign it.

---

# 10. Known Documentation Issues

The project documentation contains several inconsistencies that contributors should be aware of.

These inconsistencies should not be resolved through implementation assumptions.

Instead, they should remain documented until clarified by the project owner.

---

## 10.1 MoPS Terminology

Different documents expand the "MoPS" acronym differently.

Known definitions include:

- Mobile Parking System
- Manual / Managed Operational Payment Substitution

Additionally, the term "MARS MoPS" appears without defining "MARS."

No implementation should assume one interpretation unless clarified by the project owner.

---

## 10.2 Reconciliation Statuses

Different documents define different reconciliation status vocabularies.

Until clarified, developers should avoid introducing custom status values or modifying backend-facing enumerations.

---

## 10.3 Missing Reference Documents

Several documents referenced by the Reading Map are currently unavailable, including:

- System Design Document
- API Contract Pack
- Database Design
- Engineering Pack

Technical assumptions beyond the BRD and Scope of Work should therefore be minimized.

---

## 10.4 Endpoint Naming

Different project artifacts reference different endpoint paths for similar functionality.

Endpoint definitions should be validated against future API documentation before implementation.

---

## 10.5 Flutter Prototype vs Approved Scope

The current Flutter prototype predates the finalized project documentation.

Some screen names and placeholder workflows reflect early design assumptions rather than the approved Scope of Work.

Future development should evolve these screens to align with the approved architecture while preserving existing user experience where practical.

# 11. Development Guidelines

This section defines the engineering principles contributors should follow when extending the Flutter application.

---

## 11.1 Preserve Existing Architecture

Unless explicitly requested otherwise:

- Extend existing screens instead of replacing them.
- Preserve established navigation.
- Reuse existing widgets where practical.
- Avoid unnecessary architectural redesigns.
- Introduce new abstractions only when justified by business complexity.

The current Flutter repository is intentionally lightweight and should evolve incrementally.

---

## 11.2 Production Quality

Generated code should be suitable for production-quality software.

Contributors should prioritize:

- readability
- maintainability
- consistency
- modularity
- testability

Avoid placeholder implementations unless specifically requested.

---

## 11.3 Separation of Concerns

Business logic should remain independent from presentation.

Preferred layering:

UI

↓

State Management

↓

Business Services

↓

Repositories

↓

API / Local Storage

Avoid embedding business logic directly inside widgets whenever practical.

---

## 11.4 Flutter Conventions

Preferred practices include:

- Material Design
- reusable widgets
- descriptive naming
- small widget trees
- composition over inheritance
- strongly typed models
- immutable data where practical

---

## 11.5 Documentation

Whenever new functionality is introduced:

- update relevant documentation
- document architectural decisions
- document assumptions
- avoid undocumented business rules

---

# 12. Feature Implementation Roadmap

This section summarizes how the Flutter repository is expected to evolve.

Implementation order should generally follow the approved Product Backlog.

---

## Foundation

- Authentication
- Device registration
- Site binding
- User session management

---

## Operational Workflows

- Continuity-mode transaction capture
- Manual transaction workflows
- Evidence collection
- Incident tagging

---

## Offline Capability

- Local persistence
- Synchronization queue
- Retry mechanisms
- Conflict handling

---

## Backend Integration

- Vendor PMS Adapter
- Mock Payment Orchestrator
- Synchronization APIs

---

## Future Enhancements

Examples include:

- reporting
- analytics
- operational dashboards
- improved diagnostics

These should remain outside current scope unless explicitly approved.

---

# 13. LLM Development Instructions

This section provides guidance for future AI assistants contributing to the project.

---

## Always

Before implementing a feature:

1. Understand the business purpose.
2. Verify implementation scope.
3. Preserve existing architecture.
4. Extend rather than redesign.
5. Respect authority boundaries.
6. Follow approved workflows.

---

## Never Assume

Do not assume:

- undocumented REST endpoints
- undocumented database schemas
- undocumented state transitions
- undocumented backend capabilities

When documentation is incomplete, ask for clarification rather than inventing behavior.

---

## When Documentation Conflicts

When project documents disagree:

1. Follow the BRD.
2. Then the Scope of Work.
3. Then the Product Backlog.
4. Then the Flutter implementation.
5. Document assumptions if clarification is unavailable.

---

## Code Generation

Generated Flutter code should:

- compile
- follow Dart best practices
- minimize breaking changes
- integrate into the existing repository
- avoid unnecessary abstraction

---

# 14. Project Glossary

Common project terminology.

| Term | Meaning |
|------|---------|
| Vendor PMS | Parking Management System responsible for parking sessions and tariff computation |
| Central PMS | Canonical ExitPass backend responsible for payment finality and exit authority |
| MoPS | Android Mobile Point of Service device/application (see documentation inconsistency notes regarding acronym expansion) |
| Payment Attempt | Individual payment execution attempt |
| Evidence | Photos, notes, metadata, or other operational artifacts collected during continuity mode |
| Synchronization | Uploading locally stored transactions to backend services |
| Reconciliation | Backend process validating synchronized operational records |
| Continuity Mode | Operational mode used when standard workflows cannot be followed |

---

# 15. Repository Reference

## Folder Organization

Document the repository structure.

Example:

lib/

├── screens/

├── widgets/

├── models/

├── services/

├── repositories/

├── theme/

├── utils/

└── main.dart

---

## Existing Screens

List every screen with a short description.

This section should be updated whenever new screens are added.

---

## Dependencies

Summarize major project dependencies.

Flutter

Dart

State management

Database

Networking

Image picker

QR scanner

etc.

---

## Important Files

Examples:

main.dart

pubspec.yaml

app_routes.dart

theme.dart

README.md

---

# 16. Maintenance

This document should evolve together with the project.

Whenever one of the following changes occurs, this document should be reviewed:

- Scope changes
- Architecture changes
- New backend interfaces
- New documentation
- Product Backlog revisions
- Screen redesigns
- Folder restructuring

Contributors should treat this document as the primary onboarding reference for future development.

---

# Appendix A - Screen Mapping

Current Screen

↓

Future Responsibility

↓

Backlog Story

↓

BRD Reference

---

# Appendix B - Known Assumptions

List temporary assumptions made due to missing documentation.

Each assumption should include:

- reason
- source
- validation status

---

# Appendix C - Open Questions

Maintain a living list of unresolved project questions.

Examples include:

- Final MoPS acronym
- Reconciliation status vocabulary
- Missing API Contract Pack
- Final endpoint definitions
- Missing Engineering Pack

No implementation should silently resolve these questions without confirmation.

---

# Appendix D - Changelog

Version history for this engineering context document.

Version

Date

Author

Summary of changes