---
title: "The SDLD Specification Format: A Canonical Reference"
date: 2026-01-12
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering
  - Process
  - Best Practices
  - AI-Assisted Development
tags:
  - spec-driven-development
  - sdld
  - llm
  - ai-coding
  - specifications
  - requirements
  - documentation
---

A comprehensive guide to the SDLD specification format for LLM-assisted software development.

## Introduction

Spec-Driven LLM Development (SDLD) is a methodology where structured specifications guide both human developers and Large Language Models (LLMs) through the software development lifecycle. Unlike traditional documentation that describes code after the fact, SDLD specifications are written first and serve as the authoritative source of truth for implementation.

The core insight behind SDLD is that LLMs excel at following precise, structured instructions but struggle with ambiguity. By investing effort upfront in precise specifications, teams can leverage LLMs to implement features with high fidelity to the original intent. The specifications serve a dual purpose: they communicate intent to human reviewers and provide unambiguous instructions to LLM implementers.

This document provides a canonical reference for the three-document specification format used in SDLD projects. Each section includes both the format definition and the rationale behind it, enabling teams to adapt the format to their needs while preserving its essential characteristics.

## The Three-Document Specification Format

Every feature in an SDLD project is defined by three interconnected documents organized in a feature-specific directory:

```
specs/[feature-name]/
├── requirements.md    # WHAT the system should do
├── design.md          # HOW the system will do it
└── tasks.md           # STEPS to implement it
```

These three documents form a complete specification chain that traces from business need to implementation. The requirements document captures what the system should do from the user's perspective, written in a format that stakeholders can review and approve. The design document translates those requirements into technical architecture, specifying components, interfaces, and correctness properties. The tasks document breaks the design into discrete implementation steps that can be executed sequentially, with each step traceable back to the requirements it fulfills.

This separation serves several purposes. Requirements can be reviewed by product owners without technical details obscuring the business logic. Design can be reviewed by architects without implementation minutiae. Tasks can be executed by developers (or LLMs) without needing to re-derive the design decisions. When questions arise during implementation, the specification chain provides authoritative answers.

## Document 1: Requirements Specification

### Purpose and Philosophy

The requirements document, named `requirements.md`, captures what the system should do from the user's perspective. It translates stakeholder needs into precise, testable acceptance criteria that both humans and LLMs can interpret unambiguously.

The key insight is that natural language requirements are inherently ambiguous. Phrases like "the system should handle errors gracefully" or "the API should be fast" leave too much room for interpretation. SDLD requirements use a structured sentence format called EARS (Easy Approach to Requirements Syntax) that forces precision. Every requirement becomes a testable statement, and the full set of requirements defines exactly what "done" means for the feature.

### Document Structure

A requirements document follows this structure:

```markdown
# Requirements Document: [Feature Name]

## Introduction

[One to three paragraphs describing the feature's purpose and business value,
why this feature is needed, and the scope of what is and is not included]

## Glossary

- **Term_Name**: Definition of the term as used in this specification
- **Another_Term**: Another definition with precise meaning

## Requirements

### Requirement 1: [Capability Name]

**User Story:** As a [role], I want to [action], so that [benefit].

#### Acceptance Criteria

1. [EARS-format criterion]
2. [EARS-format criterion]
...
```

### The Introduction Section

The introduction provides context for the feature, answering three questions: What problem does this feature solve? Who benefits from this feature? What is explicitly out of scope? The introduction should be readable by stakeholders without technical background, establishing shared understanding before diving into detailed requirements.

A well-written introduction for an authentication feature might read:

```markdown
## Introduction

This specification defines the authentication and authorization middleware 
for the Strata platform. The system must support both production JWT-based 
authentication and development/testing bypass modes to enable smoke tests 
and local development.

The middleware will be applied to all three API planes (Management, Control, 
and Data) and must integrate with the existing Chi router infrastructure.
```

### The Glossary Section

The glossary defines domain-specific terms used throughout the specification. This section exists because ambiguous terminology is a primary source of specification defects. When a requirement references "namespace," everyone reading the document must understand exactly what that means.

Terms defined in the glossary are referenced in Title_Case format throughout the document. This convention makes it visually obvious when a defined term is being used, prompting readers to verify they understand the term's precise meaning. The Title_Case format also helps LLMs recognize that a term has a specific definition rather than its common English meaning.

A glossary entry should include not just the definition but also related concepts that clarify the term's boundaries:

```markdown
## Glossary

- **JWT (JSON Web Token)**: A compact, URL-safe token format for securely 
  transmitting claims between parties
- **Namespace**: A tenant or organization identifier extracted from 
  authentication context, used to scope all resource access
- **Hard_Enforcement**: Blocking mode that prevents API requests when 
  budget is exhausted
- **Soft_Enforcement**: Warning mode that allows requests but logs 
  budget overruns
```

### The Requirements Section

Each requirement follows a consistent structure beginning with a user story and followed by acceptance criteria. The user story provides context but is not the testable specification. The acceptance criteria are the testable specification.

The user story follows the standard format: "As a [role], I want to [action], so that [benefit]." This format forces the author to identify who benefits from the requirement and why they need it. The user story helps reviewers understand the intent, which is valuable when edge cases arise that weren't explicitly covered.

### The EARS Format for Acceptance Criteria

EARS (Easy Approach to Requirements Syntax) provides five patterns for writing acceptance criteria. Each pattern serves a different purpose:

The **Ubiquitous** pattern describes behavior that always applies: "THE [System] SHALL [behavior]." Use this pattern for unconditional requirements like "THE System SHALL assign a unique ID to each task."

The **Event-Driven** pattern describes behavior triggered by an event: "WHEN [event], THE [System] SHALL [behavior]." Use this pattern for reactive requirements like "WHEN a request includes an expired JWT token, THE System SHALL return HTTP 401."

The **Conditional** pattern describes behavior that depends on system state: "IF [condition], WHEN [event], THE [System] SHALL [behavior]." Use this pattern when behavior varies based on configuration or state, like "IF enforcement mode is hard, WHEN budget is exhausted, THE System SHALL block requests."

The **Optional** pattern describes behavior for optional features: "WHERE [feature enabled], THE [System] SHALL [behavior]." Use this pattern for configurable features like "WHERE audit logging is enabled, THE System SHALL record all changes."

The **Unwanted** pattern explicitly prohibits behavior: "THE [System] SHALL NOT [behavior]." Use this pattern to prevent security issues or common mistakes, like "THE System SHALL NOT log JWT tokens or secrets."

The EARS vocabulary uses precise terms: SHALL indicates a mandatory requirement that must be implemented, SHALL NOT indicates prohibited behavior that must not occur, SHOULD indicates a recommendation that is not mandatory, and MAY indicates optional behavior.

### Numbering and Traceability

Acceptance criteria are numbered within each requirement using a hierarchical scheme. The first criterion of the first requirement is numbered 1.1, the second is 1.2, and so on. The fifth criterion of the third requirement would be 3.5. This numbering enables precise traceability: when a design component or implementation task references "Requirement 1.3," everyone knows exactly which criterion is meant.

### Example Requirement

A complete requirement demonstrating these principles:

```markdown
### Requirement 1: JWT Authentication Middleware

**User Story:** As a platform operator, I want JWT-based authentication, 
so that only authorized users can access the API.

#### Acceptance Criteria

1. WHEN a request includes a valid JWT token in the Authorization header, 
   THE Authentication_Middleware SHALL extract claims and add them to the 
   request context
2. WHEN a request includes an invalid JWT token, 
   THE Authentication_Middleware SHALL return HTTP 401 with error details
3. WHEN a request includes an expired JWT token, 
   THE Authentication_Middleware SHALL return HTTP 401 with 
   "token expired" message
4. WHEN a request is missing the Authorization header, 
   THE Authentication_Middleware SHALL return HTTP 401 with 
   "missing authorization" message
5. THE Authentication_Middleware SHALL extract the namespace claim from 
   the JWT token and add it to the request context
```

Notice how each criterion tests exactly one behavior, uses glossary terms in Title_Case, specifies exact HTTP status codes and error messages, and describes what (not how) the system should behave.

### Writing Effective Requirements

Effective requirements share several characteristics. Each acceptance criterion tests exactly one behavior; compound criteria like "shall validate the token AND extract claims" should be split into separate criteria. Requirements use glossary terms consistently to avoid ambiguity. Requirements are specific about responses, including HTTP status codes, error messages, and data formats rather than vague descriptions like "appropriate error." Requirements describe what the system should do, not how it should do it; implementation details belong in the design document.

Perhaps most importantly, every criterion should be testable. If you cannot imagine writing an automated test for a criterion, the criterion is too vague. The acceptance criteria collectively define what "done" means for the feature; if all criteria pass, the feature is complete.

## Document 2: Design Specification

### Purpose and Philosophy

The design document, named `design.md`, specifies how the system will implement the requirements. It bridges business requirements and code architecture, providing enough detail for implementation while remaining technology-aware but not implementation-dependent.

The design document serves as the technical contract between the requirements and the implementation. It answers questions that requirements deliberately leave open: Which libraries should we use? How should components communicate? What data structures are needed? What invariants must the implementation maintain?

A key principle is that design decisions should be traceable to requirements. Every component, interface, and property in the design document should exist because one or more requirements demand it. This traceability ensures the design doesn't include unnecessary complexity and provides justification for every design choice.

### Document Structure

A design document follows this structure:

```markdown
# Design Document: [Feature Name]

## Overview

[Summary of the implementation approach in 2-3 paragraphs]

## Architecture

[High-level architecture diagrams and component relationships]

## Components and Interfaces

[Detailed specifications for each component]

## Data Models

[Struct definitions, schemas, and data structures]

## Correctness Properties

[Universal properties that must hold true across all executions]

## Error Handling

[Error conditions, responses, and recovery strategies]

## Integration

[How this feature integrates with existing systems]

## Testing Strategy

[Approach to verifying implementation]

## Deployment Considerations

[Environment variables, configuration, migration steps]

## Dependencies

[External libraries, services, and version requirements]
```

### The Overview Section

The overview provides a high-level summary of the implementation approach, answering three questions: What is the primary technical approach? Which key technologies or patterns are used? Why was this approach chosen over alternatives?

The overview should be readable by engineers who need to understand the system at a high level without studying the details. A well-written overview for authentication middleware might read:

```markdown
## Overview

This design implements a dual-mode authentication system for the Strata 
platform using Chi's official JWT middleware (go-chi/jwtauth). The system 
supports production JWT validation and development mode bypass, enabling 
both secure production deployments and frictionless local testing.

The middleware is implemented as a composable chain that can be applied 
to any Chi router, supporting all three API planes without code duplication.
```

### The Architecture Section

The architecture section uses ASCII diagrams to communicate component relationships. ASCII diagrams are preferred over image files because they render correctly in any environment, can be version-controlled with the code, and require no external tools to create or view.

Two diagram formats are commonly used. Flow diagrams show the sequence of operations through the system, with boxes representing components and arrows showing data flow:

```
HTTP Request
    │
    ▼
┌─────────────────────────────────┐
│  ExemptPaths Middleware         │
│  • Skip /health and configured  │
│    paths                        │
└─────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────┐
│  Mode Selection                 │
│  • AUTH_MODE=production         │
│  • AUTH_MODE=development        │
└─────────────────────────────────┘
    │
    ├─────────────────┬─────────────────┐
    ▼                 ▼                 ▼
Production        Development      Handler
(jwtauth)         (custom)         (with context)
```

Component diagrams show the structure of a package or module, with nested boxes representing contained components:

```
┌──────────────────────────────────────────────────────────────┐
│                    internal/shared/auth                       │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ AuthConfig                                             │  │
│  │  • Configuration structure                             │  │
│  │  • Validation logic                                    │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ NewAuthMiddleware                                      │  │
│  │  • Factory function                                    │  │
│  │  • Mode selection                                      │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### The Components and Interfaces Section

Each component is specified with its purpose, interface, behavior, and implementation notes. The purpose explains what the component does in one paragraph. The interface provides the function signature or API contract, typically as code. The behavior section describes how the component responds to different inputs. Implementation notes provide guidance for the implementer, including warnings about edge cases.

A complete component specification:

```markdown
### 3. NamespaceExtractor

Middleware that extracts the namespace claim from JWT tokens and adds 
it to the request context. This component bridges the JWT verification 
layer and the handler layer, ensuring handlers can access tenant context 
without understanding JWT internals.

```go
// NamespaceExtractor extracts namespace from JWT claims and adds to context
func NamespaceExtractor(logger *Logger) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            _, claims, err := jwtauth.FromContext(r.Context())
            if err != nil {
                logger.Error("failed to extract JWT claims", zap.Error(err))
                http.Error(w, "internal server error", http.StatusInternalServerError)
                return
            }
            
            namespace, ok := claims["namespace"].(string)
            if !ok || namespace == "" {
                logger.Warn("JWT missing namespace claim")
                http.Error(w, "missing namespace claim", http.StatusUnauthorized)
                return
            }
            
            ctx := context.WithValue(r.Context(), "jwt_claims", claims)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

When JWT claims are present and contain a namespace, the component adds claims 
to the request context and passes control to the next handler. When JWT claims 
are missing (which should not happen if the Verifier middleware ran), the 
component returns HTTP 500 to indicate an internal error. When the namespace 
claim is missing from an otherwise valid token, the component returns HTTP 401 
to indicate the token is not authorized for this system.

The context key "jwt_claims" must match the key used by existing handlers; 
changing this key would break backward compatibility. The logger should include 
the request ID for correlation with other log entries.
```

### The Data Models Section

Data models are specified with struct definitions including field documentation and JSON tags. The documentation should explain not just what each field contains but how it is used:

```markdown
## Data Models

### AuthConfig

AuthConfig holds all configuration for the authentication middleware. 
It is loaded from environment variables at application startup and 
validated before use.

```go
type AuthConfig struct {
    // Mode determines authentication behavior. In "production" mode, 
    // JWT tokens are validated. In "development" mode, authentication 
    // is bypassed and namespace comes from headers.
    Mode string
    
    // JWTSecret is the shared secret for HS256 algorithm validation.
    // Required when Mode is "production" and JWTAlgorithm is "HS256".
    JWTSecret string
    
    // JWTPublicKey is the public key for RS256/ES256 algorithm validation,
    // in PEM format. Required when JWTAlgorithm is "RS256" or "ES256".
    JWTPublicKey string
    
    // JWTAlgorithm specifies which signing algorithm to expect.
    // Valid values: "HS256", "RS256", "ES256". Defaults to "HS256".
    JWTAlgorithm string
    
    // ExemptPaths lists URL paths that bypass authentication entirely.
    // Health check endpoints should always be included.
    ExemptPaths []string
    
    // Logger for authentication events. Should be the application's
    // configured logger for consistent log formatting.
    Logger *Logger
}
```
```

### The Correctness Properties Section

Correctness properties are the most distinctive and powerful element of SDLD design documents. A correctness property is a universal invariant that must hold true across all valid executions of the system. Properties are written as "For any..." statements, which distinguishes them from example-based test cases.

The insight is that traditional tests verify specific examples: "When I pass token X, I get result Y." Property-based tests verify universal statements: "For any valid token, the system accepts it." Property-based tests can generate thousands of random inputs, finding edge cases that example-based tests miss.

Each property follows a consistent format:

```markdown
### Property N: [Property Name]

*For any* [input domain], [invariant that must hold].

**Validates:** Requirements X.X, Y.Y
```

The "Validates" line traces the property back to the requirements it verifies, maintaining the traceability chain.

Common property types include:

**Round-trip properties** verify that data survives serialization and deserialization unchanged. If you create an entity, serialize it, and deserialize it, you should get an equivalent entity.

**Uniqueness properties** verify that certain values are unique within their scope. If the requirements say IDs must be unique, a property can verify that generating 10,000 IDs produces 10,000 distinct values.

**Idempotency properties** verify that repeated operations have the same effect as a single operation. If completing a task is idempotent, completing it twice should leave the system in the same state as completing it once.

**Invariant properties** verify that certain conditions always hold. If budget utilization must never be negative, a property can verify this holds across thousands of random transaction sequences.

An example correctness properties section:

```markdown
## Correctness Properties

### Property 1: Valid JWT Always Passes Production Auth

*For any* valid JWT token with required claims (namespace, exp), production 
authentication middleware should allow the request through and populate 
context with claims.

**Validates:** Requirements 1.1, 6.2, 6.3

### Property 2: Invalid JWT Always Fails Production Auth

*For any* invalid JWT token (expired, wrong signature, missing claims), 
production authentication middleware should return HTTP 401.

**Validates:** Requirements 1.2, 1.3, 1.4, 6.2

### Property 3: Development Mode Never Returns 401

*For any* request in development mode (regardless of headers), 
authentication middleware should never return HTTP 401.

**Validates:** Requirements 2.1, 2.4

### Property 4: Namespace Extraction Consistency

*For any* authenticated request, extractNamespace should return the 
same namespace whether from JWT claims (production) or X-Test-Namespace 
header (development).

**Validates:** Requirements 3.1, 3.2, 3.4
```

### The Error Handling Section

Error handling documentation maps operations to error conditions and responses. A table format works well for this:

```markdown
## Error Handling

| Operation | Error Condition | HTTP Status | Error Message |
|-----------|-----------------|-------------|---------------|
| Auth | Missing token | 401 | "missing authorization header" |
| Auth | Invalid token | 401 | "invalid token" |
| Auth | Expired token | 401 | "token expired" |
| Auth | Missing namespace | 401 | "missing namespace claim" |

All errors return RFC 7807 Problem Details format:

```json
{
    "type": "/errors/unauthorized",
    "title": "Unauthorized",
    "status": 401,
    "detail": "Token validation failed",
    "instance": "/api/v1/users"
}
```
```

### The Integration Section

The integration section describes how the feature connects with existing code. This is particularly important because LLMs need to understand the integration points to generate compatible code:

```markdown
## Integration

Each plane's server integrates authentication middleware in its Start 
method, after standard middleware (RequestID, RealIP, Logging) and 
before route registration:

```go
func (s *Server) Start(ctx context.Context) error {
    r := chi.NewRouter()
    
    r.Use(middleware.RequestID)
    r.Use(middleware.RealIP)
    r.Use(shared.LoggingMiddleware(s.logger))
    
    authConfig, err := shared.LoadAuthConfig(s.logger)
    if err != nil {
        return fmt.Errorf("loading auth config: %w", err)
    }
    
    authMiddlewares := shared.NewAuthMiddleware(authConfig)
    for _, mw := range authMiddlewares {
        r.Use(mw)
    }
    
    s.handlers.RegisterRoutes(r)
    // ...
}
```

The existing extractNamespace function in handler code requires no changes 
because it already checks both context keys (jwt_claims and namespace_header) 
that this middleware uses.
```

### The Deployment Considerations Section

Deployment considerations document environment variables and configuration. A table format clearly shows what is required versus optional:

```markdown
## Deployment Considerations

The authentication middleware is configured entirely through environment 
variables, following 12-factor app principles:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| AUTH_MODE | Authentication mode | production | No |
| JWT_SECRET | Secret for HS256 | - | Yes (production) |
| JWT_PUBLIC_KEY | Public key for RS256/ES256 | - | Conditional |
| JWT_ALGORITHM | Signing algorithm | HS256 | No |
| AUTH_EXEMPT_PATHS | Comma-separated exempt paths | /health | No |

In production, the configuration should be:

```bash
AUTH_MODE=production
JWT_SECRET=your-secret-key-here
JWT_ALGORITHM=HS256
AUTH_EXEMPT_PATHS=/health,/metrics
```

In development, the configuration simplifies to:

```bash
AUTH_MODE=development
AUTH_EXEMPT_PATHS=/health
```
```

## Document 3: Tasks Specification

### Purpose and Philosophy

The tasks document, named `tasks.md`, breaks the design into discrete, implementable steps. Each task is atomic, testable, and linked back to specific requirements. This document serves as both a work breakdown structure and a progress tracker.

The key insight is that LLMs (and humans) work best with clear, sequential instructions. A design document describes the destination; the tasks document describes the path. By breaking implementation into small steps, each step can be verified before proceeding, catching errors early and ensuring the implementation stays aligned with the design.

Tasks are ordered by dependency, meaning a task should never depend on work described in a later task. This ordering enables sequential execution: complete task 1, verify it works, complete task 2, verify it works, and so on. Checkpoints at key points verify cumulative progress before proceeding to the next phase.

### Document Structure

A tasks document follows this structure:

```markdown
# Implementation Plan: [Feature Name]

## Overview

[Brief description of implementation approach and sequencing rationale]

## Tasks

- [ ] 1. [Task Name]
  - [Subtask or detail]
  - [Subtask or detail]
  - _Requirements: X.X, Y.Y_

- [ ] 2. [Task Name]
  - [ ] 2.1 [Subtask Name]
    - [Detail]
    - _Requirements: X.X_
  - [ ] 2.2 [Subtask Name]
    - [Detail]
    - _Requirements: Y.Y_

- [ ] N. Checkpoint - [Verification Point]
  - [Verification step]
  - [Verification step]

## Notes

[Implementation notes, warnings, and guidance]
```

### The Overview Section

The overview explains the implementation approach and why tasks are ordered as they are. This context helps implementers understand the rationale, which is valuable when they encounter situations the tasks don't explicitly cover:

```markdown
## Overview

This plan implements dual-mode authentication using Chi's official JWT 
middleware for production and a custom bypass for development/testing. 

Implementation follows a bottom-up approach: configuration provides the 
foundation, individual middleware components are the building blocks, 
the factory function assembles them, server integration deploys them, 
and testing verifies everything works. This ordering ensures each layer 
can be tested before building the next, catching errors early.
```

### Task Format and Numbering

Each task follows a consistent format with a checkbox for status tracking, a number for reference, a descriptive name, implementation details as sub-bullets, and a requirements trace:

```markdown
- [ ] 2. Create authentication configuration structure
  - [ ] 2.1 Implement AuthConfig struct in `internal/shared/auth.go`
    - Add Mode, JWTSecret, JWTPublicKey, JWTAlgorithm, ExemptPaths fields
    - Add Logger field for authentication event logging
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_
  
  - [ ] 2.2 Implement LoadAuthConfig function
    - Read AUTH_MODE from environment with default "production"
    - Read JWT_SECRET from environment
    - Read JWT_PUBLIC_KEY from environment  
    - Read JWT_ALGORITHM from environment with default "HS256"
    - Read AUTH_EXEMPT_PATHS from environment with default "/health"
    - Log configuration at startup, excluding secrets
    - Log warning if running in development mode
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 9.3_
```

Tasks use hierarchical numbering where top-level tasks are numbered 1, 2, 3, subtasks are numbered 2.1, 2.2, 2.3, and sub-subtasks (rarely needed) are numbered 2.1.1, 2.1.2. This numbering enables precise references in discussions and reviews.

Task status uses markdown checkbox syntax: `- [ ]` indicates not started, and `- [x]` indicates completed. As implementation proceeds, tasks are marked complete, providing a visual progress indicator.

### Requirements Traceability

Every task must link to the requirements it fulfills using the format `_Requirements: X.X, Y.Y_`. This traceability serves multiple purposes: it enables forward traceability from requirement to task (what tasks implement requirement 3.2?), backward traceability from task to requirement (why does this task exist?), and coverage analysis (are there requirements without tasks?).

The requirements reference uses the acceptance criteria numbering from the requirements document. Task 5.2 referencing "Requirements: 1.1, 1.5, 3.1, 3.3, 9.1" means this task helps fulfill acceptance criteria 1.1, 1.5, 3.1, 3.3, and 9.1.

### Checkpoint Tasks

Checkpoints are special tasks that verify cumulative progress before proceeding to the next phase. They are named with a "Checkpoint" prefix and contain verification commands:

```markdown
- [ ] 7. Checkpoint - Ensure all tests pass
  - Run `make test-unit` to verify unit tests pass
  - Run `go build ./...` to verify no compilation errors
  - If any test fails, fix before proceeding
  - Ask the user if questions arise
```

Checkpoints serve as quality gates. If a checkpoint fails, implementation should stop until the issue is resolved. The escalation path ("Ask the user if questions arise") acknowledges that LLM implementers may encounter situations requiring human judgment.

### Property Test Tasks

Correctness properties from the design document become explicit implementation tasks. Each property test task references the property by number and name, describes the input generation strategy, describes the verification approach, and links to requirements:

```markdown
- [ ] 13. Write property-based tests
  - [ ] 13.1 Write property test for valid JWT always passes
    - **Property 1: Valid JWT Always Passes Production Auth**
    - Generate random valid JWT tokens with required claims
    - Verify all pass through authentication and populate context
    - _Requirements: 1.1, 6.2, 6.3_
  
  - [ ] 13.2 Write property test for invalid JWT always fails
    - **Property 2: Invalid JWT Always Fails Production Auth**
    - Generate random invalid JWT tokens with expired timestamps, 
      wrong signatures, and missing claims
    - Verify all return HTTP 401
    - _Requirements: 1.2, 1.3, 1.4, 6.2_
```

### Task Characteristics

Every task in an SDLD specification should be atomic, ordered, testable, and traced.

Atomic means each task represents one logical unit of work. A task should not require multiple unrelated changes. A task like "Create ExemptPaths middleware" is atomic; a task like "Create middleware and update all servers" is not.

Ordered means tasks are sequenced by dependency. A task should never require work from a later task. If task 5 requires the output of task 3, task 3 must come before task 5.

Testable means each task can be verified. After completing a task, there should be a concrete way to confirm it was done correctly. This might be running a test, compiling the code, or manually verifying behavior.

Traced means every task links to requirements. If a task cannot be traced to a requirement, either the task is unnecessary or the requirements are incomplete.

### The Notes Section

The notes section provides implementation guidance that does not fit in individual tasks:

```markdown
## Notes

All tasks in this plan are required for comprehensive authentication 
implementation. Each task references specific requirements for traceability, 
and skipping tasks will result in incomplete requirement coverage.

Checkpoints ensure incremental validation. If a checkpoint fails, do not 
proceed until the issue is resolved. Property tests validate universal 
correctness properties and should be treated as blocking if they fail.

The implementation leverages Chi's official JWT middleware to minimize 
custom cryptographic code. Do not implement custom JWT parsing or 
signature validation. All configuration comes from environment variables 
following 12-factor app principles.
```

## Specification Traceability

The three documents form a traceability chain. Requirements trace to design through the "Validates" annotations on correctness properties and the requirement references on component specifications. Design traces to tasks through the implementation details. Tasks trace back to requirements through the "_Requirements:_" annotations.

This traceability enables several workflows. When a requirement changes, you can trace forward to find affected design components and tasks. When a test fails, you can trace backward to understand what business requirement is violated. When reviewing a task, you can trace to requirements to understand why the task exists.

A coverage matrix can verify that all requirements have corresponding tasks:

| Requirement | Design Component | Tasks |
|-------------|------------------|-------|
| 1.1 | ProductionAuth, Property 1 | 5.1, 5.2, 13.1 |
| 1.2 | CustomAuthenticator, Property 2 | 5.3, 13.2 |
| 2.1 | DevelopmentAuth, Property 3 | 4.1, 13.3 |

If any requirement lacks tasks, either the tasks are incomplete or the requirement is not actually being implemented.

## The SDLD Workflow

### Specification Phase

Before implementation begins, the team creates all three specification documents. The requirements document is written first with stakeholder input, then reviewed for completeness and testability. The design document is written based on approved requirements, then reviewed for feasibility and correctness. The tasks document is written breaking the design into implementable steps, then reviewed for completeness and ordering.

This phase front-loads the thinking. Ambiguities are resolved in specification review rather than during implementation. Design decisions are made deliberately rather than ad hoc. The full scope of work is visible before any code is written.

### Implementation Phase

During implementation, tasks are executed in order from top to bottom. Each task is marked complete using `[x]` as it is verified. At checkpoints, cumulative progress is verified before proceeding. If implementation reveals a specification gap, the specification is updated before proceeding.

This phase is where LLMs excel. Given precise specifications, LLMs can implement tasks with high fidelity. The sequential structure prevents LLMs from making assumptions about unspecified behavior, and the checkpoint structure catches errors before they propagate.

### Verification Phase

After implementation, the team verifies that all acceptance criteria are satisfied, all correctness properties hold (ideally through automated property tests), and all tasks are marked complete. The specification is then archived as documentation of what was built and why.

## Conclusion

The SDLD three-document format provides a complete specification chain from business requirements to implementation tasks. Requirements are precise and testable through the EARS format. Designs are traceable to requirements through explicit validation annotations. Tasks are atomic and verifiable with clear requirements traceability.

This format enables effective collaboration between humans and LLMs. Humans provide the judgment needed to write specifications: understanding stakeholder needs, making design tradeoffs, and verifying correctness. LLMs provide the throughput needed to implement specifications: translating precise instructions into code, generating test cases, and maintaining consistency across a codebase.

The specifications are not documentation. They are the source of truth that drives implementation. When the code and specification disagree, the specification is authoritative. When requirements change, the specification changes first, then the code follows.

By investing in precise specifications, teams transform ambiguous requirements into unambiguous instructions that both humans and LLMs can execute faithfully.

## Further Reading

- [EARS Requirements Pattern](https://alistairmavin.com/ears/) - The syntax foundation for precise requirements
- [AWS Kiro](https://kiro.dev) - Agentic AI IDE with SDLD support
- [GitHub Spec Kit](https://github.com/github/spec-kit) - Open-source SDLD toolkit
- [Property-Based Testing with gopter](https://github.com/leanovate/gopter) - Go property testing library
- [12-Factor App](https://12factor.net/) - Configuration best practices
