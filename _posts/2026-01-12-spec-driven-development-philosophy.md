---
title: "Spec-Driven Development: A Comprehensive SDLC for AI-Assisted Software Engineering"
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
  - sdlc
  - llm
  - ai-coding
  - specifications
  - software-engineering
  - methodology
---

Modern software development teams face a fundamental tension: AI assistants dramatically accelerate code generation, but without structured workflows, this speed creates technical debt, documentation drift, and maintenance burden. This document describes a comprehensive Software Development Lifecycle (SDLC) that harnesses AI acceleration while maintaining engineering discipline—a spec-driven development approach where specifications define what to build, how to build it, and the sequence of implementation before any code is written.

The core insight: **treat specifications as first-class engineering artifacts, version them alongside code, and ensure AI assistants always work from documented requirements rather than conversational context**.

This approach has been refined through production use and addresses the challenges facing engineering organizations that want to adopt AI assistants at scale while maintaining code quality, architectural consistency, and team collaboration.

## The Problem: Vibe Coding vs. Production Software

### The Acceleration Trap

AI assistants have fundamentally changed how developers write code. What once took hours can now be accomplished in minutes through conversational interaction. However, this acceleration creates new challenges:

**Undocumented Decisions**: Design choices made during AI-assisted conversations are lost when the session ends. Six months later, no one remembers why a particular pattern was chosen.

**Architectural Drift**: Without explicit constraints, AI assistants may generate code that violates established patterns, creating inconsistency across the codebase.

**Context Loss**: Each new AI session starts fresh. Complex features developed across multiple sessions lack coherent thread.

**Review Burden**: When AI generates code directly from conversation, reviewers lack context about requirements and design decisions. They can verify syntax but not intent.

**Team Misalignment**: Different developers have different conversations with AI assistants, leading to different interpretations of the same requirements.

### The Vibe Coding Pattern

"Vibe coding" describes rapid AI-assisted development through conversational iteration:

```
Developer: "Add a user review feature"
AI: [generates code]
Developer: "Also add star ratings"
AI: [modifies code]
Developer: "Wait, only verified purchasers should review"
AI: [modifies code again]
```

This works for prototyping but creates problems at scale:

- **Implicit Requirements**: The requirement "only verified purchasers should review" exists only in chat history
- **No Traceability**: How do you test this? What acceptance criteria determine success?
- **No Review Checkpoint**: At what point does a human validate direction before implementation?

### The Spec-Driven Alternative

Spec-driven development inverts this pattern:

1. **Specify First**: Document requirements, design decisions, and implementation tasks before writing code
2. **Human Checkpoints**: Review and approve specifications before implementation begins
3. **AI Implements from Specs**: AI assistants work from documented specifications, not conversational context
4. **Living Documentation**: Specifications remain synchronized with code through version control

## System Architecture Overview

The SDLC described here consists of four interconnected systems:

```
┌───────────────────────────────────────────────────────────────────────────┐
│                        SPEC-DRIVEN DEVELOPMENT SDLC                       │
├───────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │  STEERING   │───▶│    SPECS    │───▶│    BUILD    │───▶│     CI      │ │
│  │  DOCUMENTS  │    │  (Features) │    │   SYSTEM    │    │  WORKFLOWS  │ │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘ │
│        │                  │                  │                  │         │
│        │     Project      │    Per-Feature   │   Automation     │  Quality│
│        │     Context      │    Planning      │   & Execution    │   Gate  │
│        ▼                  ▼                  ▼                  ▼         │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │                    AI ASSISTANT ORCHESTRATION                       │  │
│  │  Commands → Agents → Skills → MCP Servers → Tool Execution          │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

### 1. Steering Documents (Project Context)

Persistent documents that establish project-wide context: technology stack, architecture patterns, coding conventions, testing strategy. AI assistants reference these documents to ensure generated code aligns with established practices.

### 2. Feature Specifications (Per-Feature Planning)

Three-document structure for each feature: requirements (what to build), design (how to build it), and tasks (implementation sequence). Created before implementation begins, reviewed by humans, versioned with code.

### 3. Build System (Automation & Execution)

Type-safe, cross-platform build automation that provides consistent commands for building, testing, generating code, and managing development environments. AI assistants invoke these commands; humans configure them.

### 4. CI Workflows (Quality Gate)

Automated quality gates that verify code meets standards before merge. Ensures AI-generated code passes the same validation as human-written code.

## Steering Documents: Establishing Project Context

### Purpose and Philosophy

Steering documents provide the persistent context that AI assistants need to generate code consistent with established project patterns. Unlike conversational context that evaporates between sessions, steering documents are version-controlled artifacts that evolve with the project.

The key insight: **AI assistants cannot intuit your project's conventions—they must be explicitly documented**.

### Directory Structure

Steering documents are consolidated under a dedicated directory within the project:

```
.opencode/
└── steering/
    ├── product.md              # Business context, domain understanding
    ├── structure.md            # Codebase architecture, directory organization
    ├── tech.md                 # Technology stack, frameworks, libraries
    ├── test-strategy.md        # Testing philosophy and practices
    ├── clean-principles.md     # CLEAN architecture rules
    ├── 12-factor-principles.md # Configuration and deployment patterns
    ├── api-development.md      # OpenAPI-first workflow
    ├── kubernetes.md           # K8s resource patterns
    └── memory.md               # Context management strategies
```

### Core Steering Documents

#### product.md - Business Context

Establishes the business domain, target users, and product vision. AI assistants reference this to understand the "why" behind requirements.

```markdown
# Product Overview

[Product Name] is an enterprise-grade platform that solves [core problem] 
for [target users].

## Purpose
- **For [User Type A]**: [Value proposition]
- **For [User Type B]**: [Value proposition]

## Core Architecture
- **Component A**: [Responsibility]
- **Component B**: [Responsibility]
- **Component C**: [Responsibility]

## Key Features
- **Feature 1**: [Description and business value]
- **Feature 2**: [Description and business value]
```

#### structure.md - Codebase Architecture

Documents directory organization, file naming conventions, and architectural patterns. Ensures AI-generated code lands in the correct locations.

```markdown
# Project Structure

## Directory Organization
internal/                   # CLEAN architecture layers
├── entities/               # Layer 1: Domain objects, business rules
├── usecases/               # Layer 2: Application logic, ports/interfaces
├── adapters/               # Layer 3: HTTP handlers, repositories
└── drivers/                # Layer 4: Config, database, web server setup

gen/                        # Generated code (NEVER edit manually)
api/                        # OpenAPI specifications
specs/                      # Feature specifications

## Conventions
- One package per directory
- Test files alongside source: *_test.go
- Property tests: *_property_test.go
- Integration tests: *_integration_test.go
```

#### tech.md - Technology Stack

Documents frameworks, libraries, tool versions, and common patterns. AI assistants reference this to use the correct APIs and idioms.

```markdown
# Technology Stack

## Language & Runtime
- Go 1.24+ with module support
- Module: github.com/organization/project

## Key Dependencies
- gopter: Property-based testing
- Ginkgo/Gomega: BDD-style integration tests
- testcontainers: Real infrastructure in tests

## Build System
- Mage for build automation
- Wire for dependency injection
- oapi-codegen for API type generation
```

#### test-strategy.md - Testing Philosophy

Establishes the testing pyramid, layer assignments, and anti-patterns to avoid. Critical for ensuring AI-generated tests follow project standards.

```markdown
# Test Strategy

## Three-Layer Testing Decision Tree

Does it require Kubernetes cluster?
├─ YES → E2E Test (Ginkgo + KIND)
│   Examples: Operators, webhooks, controllers
│
└─ NO → Does it require database or cache?
    ├─ YES → Integration Test (Ginkgo + testcontainers)
    │   Examples: API endpoints, workflows, persistence
    │
    └─ NO → Does it test properties across random inputs?
        ├─ YES → Property Test (gopter)
        │   Examples: Validation, serialization, round-trips
        │
        └─ NO → Unit Test (standard Go testing)
            Examples: Business logic, pure functions, validation

## Anti-Patterns (NEVER do these)
- Mock databases (use testcontainers)
- YAML fixtures (use type-safe Go code)
- E2E for API tests (use integration tests)
- Share state between tests (reset in BeforeEach)
```

### Steering Document Lifecycle

**Initial Setup**: Create steering documents during project initialization. Start with basics and expand as patterns emerge.

**Continuous Evolution**: Update steering documents as the project matures:
- New architectural patterns → Update structure.md
- New frameworks/tools → Update tech.md
- Testing strategy changes → Update test-strategy.md
- Business pivot → Update product.md

**Quarterly Review**: Explicitly review steering documents to ensure they reflect current reality. Stale steering documents are worse than none—they cause AI assistants to generate code that violates current patterns.

## Feature Specifications: The Three-Phase Workflow

### Philosophy: Specifications as Engineering Artifacts

Traditional documentation drifts from code because it exists separately. Spec-driven development treats specifications as first-class engineering artifacts:

- **Stored with code**: Specifications live in the same repository
- **Versioned with code**: Same branching strategy, same pull request workflow
- **Reviewed with code**: Specification changes reviewed alongside implementation

### Directory Structure

```
specs/
├── README.md                    # Specification workflow documentation
├── user-authentication/
│   ├── requirements.md          # EARS-format requirements
│   ├── design.md                # Technical design with correctness properties
│   └── tasks.md                 # Checkbox-style implementation tasks
├── product-catalog/
│   ├── requirements.md
│   ├── design.md
│   └── tasks.md
└── [feature-name]/
    ├── requirements.md
    ├── design.md
    └── tasks.md
```

### Phase 1: Requirements Specification

#### Purpose

Transform high-level feature requests into structured requirements using the EARS format (Easy Approach to Requirements Syntax). EARS provides unambiguous templates that make acceptance criteria testable.

#### Document Structure

```markdown
# Requirements Document: [Feature Name]

## Introduction
[2-4 paragraphs describing the feature, its purpose, and business context]

## Glossary
- **Term_One**: [Definition]
- **Term_Two**: [Definition]
[Define ALL domain-specific terms before using them]

## Requirements

### Requirement 1: [Title]

**User Story:** As a [user type], I want [goal], so that [benefit].

#### Acceptance Criteria
1. WHEN [trigger], THE System SHALL [behavior]
2. WHEN [condition], THE System SHALL [response]
3. THE [Component] SHALL [capability]
4. IF [error condition], THE System SHALL [recovery behavior]

### Requirement 2: [Title]
...
```

#### EARS Syntax Patterns

| Pattern | Template | Example |
|---------|----------|---------|
| **Event-Driven** | WHEN \<trigger\>, THE System SHALL \<response\> | WHEN a user submits a review, THE System SHALL validate the content |
| **Ubiquitous** | THE \<system\> SHALL \<requirement\> | THE System SHALL log all API requests |
| **State-Driven** | WHILE \<state\>, THE System SHALL \<behavior\> | WHILE in maintenance mode, THE System SHALL reject new connections |
| **Unwanted** | IF \<condition\>, THE System SHALL \<response\> | IF database connection fails, THE System SHALL retry 3 times |
| **Complex** | WHEN \<trigger\> AND WHILE \<state\>, THE System SHALL | WHEN timeout AND WHILE processing, THE System SHALL rollback |

#### Quality Checklist

Before proceeding to design:
- [ ] Introduction provides sufficient context
- [ ] All domain terms defined in glossary
- [ ] Every acceptance criterion uses EARS format
- [ ] Each criterion is testable with clear pass/fail
- [ ] Requirements reviewed and approved by stakeholders

### Phase 2: Technical Design

#### Purpose

Translate approved requirements into technical specifications including architecture, data models, interfaces, and—critically—**correctness properties** that bridge requirements to tests.

#### Document Structure

```markdown
# Design Document: [Feature Name]

## Overview
[Technical approach, design principles, how this implements the requirements]

## Architecture

### Layer Organization
[Directory structure showing where code lives]

### Data Flow
[Step-by-step flow for key operations]

### Key Design Decisions
1. **Decision**: [Rationale]
2. **Decision**: [Rationale]

## Components and Interfaces

### [Component Name]
```[language]
[Interface or struct definition with comments]
```

## Data Models

### [Model Name]
```[language]
[Type definition with field documentation]
```

## Correctness Properties

*Properties bridge requirements to tests. Each property states an invariant 
that must hold across all valid inputs.*

### Property 1: [Name]
*For any* [input domain], [operation] should [expected invariant].
**Validates: Requirements X.Y**

### Property 2: [Name]
*For any* [condition], [system behavior] must [guarantee].
**Validates: Requirements X.Y**

## Testing Strategy

### Test Layer Assignment
| Property | Test Layer | Test File | Rationale |
|----------|------------|-----------|-----------|
| Property 1 | Property | `*_property_test.go` | Random input validation |
| Property 2 | Integration | `*_integration_test.go` | Requires database |

## Error Handling
[Error types, HTTP status mapping, recovery behaviors]

## Security Considerations
[Authentication, authorization, data protection]

## Performance Considerations
[Caching, query optimization, resource limits]
```

#### Correctness Properties

The key innovation in this design format is **correctness properties**—formal statements about system behavior that translate directly to tests.

| Property Type | Pattern | Example |
|---------------|---------|---------|
| **Round-Trip** | *For any* valid X, deserialize(serialize(X)) == X | Data integrity through serialization |
| **Uniqueness** | *For any* two entities, their [field] must differ | No duplicate identifiers |
| **Atomicity** | *For any* concurrent operations, final state == sum of operations | No lost updates |
| **Validation** | *For any* invalid input, system rejects with error | Input validation |
| **Idempotency** | *For any* X, operation(operation(X)) == operation(X) | Normalization functions |

### Phase 3: Task Breakdown

#### Purpose

Break design into discrete, actionable implementation tasks with explicit requirement traceability. Each task references the requirements it satisfies.

#### Document Structure

```markdown
# Implementation Plan: [Feature Name]

## Overview
[Summary of implementation approach, estimated scope]

## Tasks

### Phase 1: Foundation

- [ ] 1. [Major Task]
  - [Description of what this task accomplishes]
  - _Requirements: 1.1, 1.2_

- [ ] 1.1 [Subtask]
  - [Detailed description]
  - _Requirements: 1.1_

- [ ] 1.2 Write property test for [Property Name]
  - **Property N: [Name]**
  - **Validates: Requirements X.Y**

### Phase 2: Core Implementation
...

### Checkpoint 1: [Validation Point]
- [ ] All Phase 1 tests pass
- [ ] Code review completed
- [ ] Requirements X.Y verified

### Phase 3: Integration
...
```

#### Task Markers

| Marker | Status |
|--------|--------|
| `- [ ]` | Pending |
| `- [x]` | Completed |
| `- [-]` | In Progress |
| `- [!]` | Failed / Blocked |

#### Task Tracking Principles

1. **Every task references requirements**: Traceability from implementation to business need
2. **Property tests are explicit tasks**: Testing is implementation, not afterthought
3. **Checkpoints every 3-5 major tasks**: Natural validation points
4. **Atomic tasks**: Each task completable in a single session

### The Sequential Workflow

```
┌─────────────────────┐
│   /dev:spec         │ ─── Creates requirements.md
└──────────┬──────────┘
           │ WAIT for approval
           ▼
┌─────────────────────┐
│   /dev:design       │ ─── Creates design.md (reads requirements)
└──────────┬──────────┘
           │ WAIT for approval
           ▼
┌─────────────────────┐
│   /dev:tasks        │ ─── Creates tasks.md (reads design)
└──────────┬──────────┘
           │ WAIT for approval
           ▼
┌─────────────────────┐
│   /dev:implement    │ ─── Implements tasks (reads all specs)
└─────────────────────┘
```

**Critical**: Each phase must complete before the next begins. Design decisions depend on requirements analysis. Task breakdown depends on architectural decisions. Parallel execution causes misalignment between artifacts.

## AI Assistant Orchestration

### Architecture Overview

The AI assistant system consists of four layers:

```
┌────────────────────────────────────────────────────────────────────┐
│                         SLASH COMMANDS                             │
│  /dev:spec  /dev:design  /dev:tasks  /dev:implement  /dev:review   │
├────────────────────────────────────────────────────────────────────┤
│                         SPECIALIZED AGENTS                         │
│  requirements  architect  implementer  reviewer  document-writer   │
├────────────────────────────────────────────────────────────────────┤
│                         REUSABLE SKILLS                            │
│  requirements-gathering  technical-design  task-breakdown          │
├────────────────────────────────────────────────────────────────────┤
│                         MCP SERVERS & TOOLS                        │
│  File I/O  Git  GitHub  Kubernetes  Docker  Memory  Context7       │
└────────────────────────────────────────────────────────────────────┘
```

### Commands Layer

Commands are the user-facing interface. Each command encapsulates a specific workflow step:

```
.opencode/
└── command/
    ├── dev:spec.md          # Generate requirements specification
    ├── dev:design.md        # Create technical design
    ├── dev:tasks.md         # Break down into tasks
    ├── dev:implement.md     # Implement a single task
    ├── dev:implement-all.md # Implement all pending tasks
    ├── dev:review.md        # Review against specifications
    ├── dev:feature.md       # Full guided workflow
    └── dev:status.md        # Show completion progress
```

#### Command Structure

```markdown
---
description: Generate a requirements specification for a new feature
agent: requirements
subtask: true
---

# Requirements Specification Task

Generate a comprehensive requirements specification for: **$ARGUMENTS**

## Instructions

1. **Create the feature directory** at `specs/$1/`
2. **Analyze the existing codebase** to understand current patterns
3. **Gather and document requirements** following EARS format
4. **Output the specification** to `specs/$1/requirements.md`
5. **Summarize** the key requirements when complete

## Output Format

Use the requirements-gathering skill for the document structure.
```

### Agents Layer

Agents are specialized personas with defined responsibilities, tools, and constraints:

#### Requirements Agent
- **Purpose**: Gathers requirements, identifies stakeholders, documents acceptance criteria
- **Tools**: Read, write, search
- **Constraints**: No code implementation

#### Architect Agent
- **Purpose**: Creates technical designs, defines correctness properties, plans architecture
- **Tools**: Read, write, search, analyze
- **Constraints**: No code implementation, must reference requirements

#### Implementer Agent
- **Purpose**: Implements code following specifications and project patterns
- **Tools**: Read, write, edit, bash (limited), LSP
- **Constraints**: Must follow task sequence, must run verification

#### Reviewer Agent
- **Purpose**: Reviews implementations against specifications, identifies gaps
- **Tools**: Read, search, LSP diagnostics
- **Constraints**: No code modification, must reference specifications

### Skills Layer

Skills are reusable knowledge templates that agents invoke:

```
.opencode/
└── skill/
    ├── requirements-gathering/
    │   └── SKILL.md           # EARS format, glossary structure
    ├── technical-design/
    │   └── SKILL.md           # Correctness properties, test strategy
    └── task-breakdown/
        └── SKILL.md           # Checkbox tracking, requirement references
```

Skills provide:
- Document templates and structure
- Domain-specific terminology
- Quality checklists
- Examples and anti-patterns

### MCP Servers Layer

Model Context Protocol (MCP) servers extend AI capabilities with external tools:

| MCP Server | Purpose |
|------------|---------|
| **File System** | Read, write, search files |
| **Git** | Version control operations |
| **GitHub** | Issues, PRs, code review |
| **Kubernetes** | Cluster inspection, resource management |
| **Docker** | Container management |
| **Memory** | Persistent context across sessions |
| **Context7** | Library documentation lookup |

### Workflow Execution Example

When a developer invokes `/dev:spec user-authentication`:

1. **Command parses** arguments and identifies the `requirements` agent
2. **Agent activates** with the `requirements-gathering` skill
3. **Agent reads** steering documents for project context
4. **Agent analyzes** existing codebase for patterns
5. **Agent generates** requirements document following EARS format
6. **Agent writes** to `specs/user-authentication/requirements.md`
7. **Agent summarizes** key requirements for human review

## Build System: Mage-Based Automation

### Philosophy

The build system serves two audiences:
- **Developers**: Consistent commands for building, testing, quality checks
- **AI Assistants**: Reliable automation targets for delegation

Design principles:
- **Type-Safe**: Build logic is Go code with compile-time validation
- **Cross-Platform**: Works on Linux and macOS (Windows not supported)
- **Zero-Magic**: Explicit behavior, no automatic discovery
- **Hermetic**: Reproducible builds with pinned tool versions

### Namespace Organization

```
Build          # Binary compilation
Test           # Test execution
Gen            # Code generation
Quality        # Lint, format, vet
Validate       # Spec validation, environment checks
Dev            # Development workflow (environment setup)
CI             # Local CI workflow testing
Cluster        # KIND cluster lifecycle
Release        # Release management
Help           # Documentation and help
```

### Key Targets

#### Build Namespace

```bash
mage build:default          # Build for current platform
mage build:all              # Build all platforms (parallel)
mage build:linuxAmd64       # Build specific platform
mage build:clean            # Remove build artifacts
mage build:config           # Display build configuration
```

#### Test Namespace

```bash
mage test:unit              # Unit tests (fast, no dependencies)
mage test:property          # Property-based tests with gopter
mage test:integration       # Integration tests with testcontainers
mage test:e2e               # E2E tests with KIND cluster
mage test:all               # All tests
mage test:coverage          # Generate coverage reports
```

#### Gen Namespace

```bash
mage gen:all                # Generate all code
mage gen:api                # Generate API types from OpenAPI
mage gen:wire               # Generate Wire dependency injection
```

#### Quality Namespace

```bash
mage quality:lint           # Run golangci-lint
mage quality:fix            # Auto-fix lint issues
mage quality:fmt            # Format code
mage quality:all            # All quality checks
```

#### Dev Namespace

```bash
mage dev:up                 # Full dev environment
mage dev:down               # Tear down environment
mage dev:status             # Show environment status
```

### Tool Version Management

Tool versions are pinned in `magefiles/versions.go`:

```go
const (
    wireVersion         = "v0.7.0"
    oapiCodegenVersion  = "v2.5.1"
    golangciLintVersion = "v2.7.2"
)
```

Tools are executed via `go run <module>@<version>`, ensuring:
- No global installation required
- Reproducible across environments
- Automatic download and caching

### Structured Error Handling

All mage targets produce structured errors with actionable guidance:

```
❌ Tool Validation: Required tool 'docker' is not available
🔧 Fix: Install Docker Desktop or ensure Docker daemon is running
```

Error types include:
- `BuildError`: Compilation failures
- `TestError`: Test failures
- `ValidationError`: Specification or environment issues
- `ToolMissingError`: Missing required tools

## CI Workflows: Automated Quality Gates

### Philosophy

CI workflows ensure AI-generated code meets the same standards as human-written code. The key insight: **if AI can generate code, AI-generated code must pass automated validation**.

### Workflow Structure

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  setup:
    # Download dependencies, cache for subsequent jobs
    
  test-native:
    needs: setup
    # Unit tests, property tests, lint, format check
    
  build-matrix:
    needs: test-native
    strategy:
      matrix:
        platform: [linux-amd64, linux-arm64, darwin-amd64, darwin-arm64]
    # Multi-platform builds
    
  integration:
    needs: test-native
    # Integration tests with testcontainers
```

### Quality Gates

| Gate | Purpose | Blocking |
|------|---------|----------|
| **Lint** | Code quality and style | Yes |
| **Format** | Consistent formatting | Yes |
| **Unit Tests** | Business logic correctness | Yes |
| **Property Tests** | Invariant validation | Yes |
| **Integration Tests** | API and database behavior | Yes |
| **Build** | Compilation success | Yes |

### Local CI Testing

Developers can run CI workflows locally using `act`:

```bash
mage ci:testLocal           # Run complete CI workflow locally
mage ci:testSetup           # Run only setup job
mage ci:testNative          # Run only test-native job
mage ci:dryRun              # Show what would run
mage ci:list                # List all CI jobs
```

This enables developers (and AI assistants) to validate changes before pushing.

## Integration: The Complete Workflow

### Feature Development Lifecycle

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      COMPLETE FEATURE DEVELOPMENT CYCLE                     │
└─────────────────────────────────────────────────────────────────────────────┘

1. STEERING CONTEXT
   └─► Review/update steering documents if needed
       └─► .opencode/steering/*.md

2. REQUIREMENTS PHASE
   └─► /dev:spec [feature-name]
       └─► Creates specs/[feature]/requirements.md
           └─► Human Review & Approval ◄── CHECKPOINT

3. DESIGN PHASE
   └─► /dev:design [feature-name]
       └─► Creates specs/[feature]/design.md
           └─► Human Review & Approval ◄── CHECKPOINT

4. TASK BREAKDOWN
   └─► /dev:tasks [feature-name]
       └─► Creates specs/[feature]/tasks.md
           └─► Human Review & Approval ◄── CHECKPOINT

5. IMPLEMENTATION
   └─► /dev:implement [task-id] [feature-name]
       └─► AI implements each task sequentially
           └─► Runs: mage test:unit
           └─► Runs: mage quality:lint
           └─► Updates task status in tasks.md

6. VERIFICATION
   └─► /dev:review [feature-name]
       └─► Review against specifications
           └─► Runs: mage test:all
           └─► Runs: mage quality:all

7. CI VALIDATION
   └─► git push → CI workflow
       └─► Automated quality gates
           └─► All checks pass ◄── MERGE READY
```

### Key Integration Points

#### Specifications → Build System

Tasks reference mage targets for verification:

```markdown
- [ ] 3.1 Implement validation logic
  - Create validation functions in internal/entities/
  - _Requirements: 2.1, 2.3_
  - **Verify**: `mage test:unit` passes

- [ ] 3.2 Write property tests for validation
  - **Property 2: Input Validation**
  - **Verify**: `mage test:property` passes
```

#### Build System → CI

CI workflows invoke the same mage targets developers use:

```yaml
- name: Run tests
  run: |
    mage gen:all
    mage test:unit
    mage quality:lint
```

#### AI Assistants → Build System

Agents delegate to mage targets for consistent execution:

```markdown
After implementing, the AI assistant runs:
1. mage quality:lint - Verify code style
2. mage test:unit - Verify tests pass
3. mage build:default - Verify compilation
```

#### Steering → Specifications

Design documents reference steering documents for patterns:

```markdown
## Architecture

The implementation follows project's established patterns (see .opencode/steering/):
- **CLEAN Architecture**: Layer separation per structure.md
- **Testing Strategy**: Test layer assignment per test-strategy.md
- **API Patterns**: OpenAPI-first per api-development.md
```

## Context Management for AI Assistants

### The Context Challenge

AI assistants have limited context windows. A large codebase cannot fit entirely in context. Effective context management determines whether AI-generated code aligns with project patterns.

### Context Strategy

```
┌───────────────────────────────────────────────────────────────────┐
│                         CONTEXT MANAGEMENT HIERARCHY              │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ALWAYS LOADED (via AGENTS.md)                                    │
│  ├── Steering documents (project patterns, conventions)           │
│  └── Current task context (spec, design, task being implemented)  │
│                                                                   │
│  LOADED ON DEMAND                                                 │
│  ├── Referenced source files (implementation context)             │
│  ├── Test files (testing patterns)                                │
│  └── Related specifications (cross-feature context)               │
│                                                                   │
│  PERSISTENT MEMORY (via MCP)                                      │
│  ├── Architecture decisions (ADRs)                                │
│  ├── Discovered patterns                                          │
│  ├── Debugging learnings                                          │
│  └── Domain clarifications                                        │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

### AGENTS.md: The Primary Steering Document

The `AGENTS.md` file at the repository root serves as the primary context for AI assistants:

```markdown
# AGENTS.md

Guidelines for AI coding agents working in this codebase.

## Quick Reference: Commands
[Build, test, quality, generation commands]

## Project Structure
[Directory organization, layer responsibilities]

## Code Style Guidelines
[Imports, function constraints, error handling]

## Architecture Rules
[CLEAN architecture, dependency rules]

## Test Strategy
[Decision tree, file naming, anti-patterns]

## Tool Versions
[Pinned versions for reproducibility]
```

AI assistants automatically read `AGENTS.md` at session start, establishing baseline context.

### Memory Persistence

For knowledge that should persist across sessions, use memory MCP:

```
.basic-memory/
├── architecture/     # Architecture decisions, patterns
├── decisions/        # ADRs (Architecture Decision Records)
├── learnings/        # Debugging insights, gotchas
├── patterns/         # Discovered patterns
└── domains/          # Domain clarifications
```

#### When to Persist

| Trigger | Destination |
|---------|-------------|
| Non-obvious technical decision | `.basic-memory/decisions/adr-YYYY-MM-DD-{topic}.md` |
| Discovered pattern not in AGENTS.md | `.basic-memory/patterns/{topic}.md` |
| Debugging insight (prevent repeat) | `.basic-memory/learnings/YYYY-MM-DD.md` |

## Onboarding New Team Members

### For Engineers

#### Day 1: Environment Setup

Use [KodeOps](https://kodeops.dev) to automate your complete development environment setup. KodeOps handles repository cloning, dependency installation, build system bootstrapping, and AI assistant tooling configuration in a single workflow.

After KodeOps completes, verify your setup:

```bash
mage help:usage
mage build:default
mage test:unit
```

#### Day 2: Understanding the System

1. **Read AGENTS.md** - Primary reference for all development
2. **Read steering documents** - `.opencode/steering/*.md`
3. **Browse existing specs** - `specs/*/` for examples
4. **Run the full test suite** - `mage test:all`

#### Day 3: First Contribution

1. Pick a small task from an existing spec
2. Follow the implementation workflow
3. Use AI assistant commands if available
4. Submit PR with specification reference

### For Engineering Managers

#### Understanding the Workflow

The spec-driven approach provides natural checkpoints:

```
Requirements → Design → Tasks → Implementation → Review
      ↑           ↑        ↑          ↑            ↑
   Approve    Approve  Approve   Monitor      Validate
```

Each checkpoint is a review opportunity without blocking developer flow.

#### Metrics to Track

| Metric | Indicates |
|--------|-----------|
| Spec completion rate | Planning discipline |
| Requirements-to-implementation traceability | Accountability |
| CI pass rate | Code quality |
| Time from spec to merge | Velocity |
| Rework rate | Specification clarity |

#### Common Pitfalls

1. **Skipping specifications**: Short-term speed, long-term debt
2. **Stale steering documents**: AI generates outdated patterns
3. **Over-specifying**: Analysis paralysis
4. **Under-specifying**: Ambiguous requirements surface in implementation

## Best Practices Summary

### Do

- **Specify before implementing**: Requirements → Design → Tasks → Code
- **Review at checkpoints**: Approve specifications before implementation
- **Keep steering documents current**: Reflect actual project patterns
- **Reference specifications in PRs**: Traceability from code to requirements
- **Let AI run verification**: `mage test:unit`, `mage quality:lint` after changes
- **Persist valuable knowledge**: Use memory MCP for ADRs, patterns, learnings
- **Version specifications with code**: Same branch, same PR

### Don't

- **Skip to implementation**: "Just vibe code it" creates undocumented decisions
- **Ignore steering documents**: AI will generate inconsistent code
- **Over-parallelize specification phases**: Design depends on requirements
- **Edit generated code directly**: Regenerate from specifications instead
- **Commit without verification**: Run build and tests before pushing
- **Let specifications drift**: Update specs when implementation changes

## Conclusion

Spec-driven development transforms AI-assisted software development from conversational improvisation to structured engineering. By treating specifications as first-class artifacts versioned alongside code, teams gain:

**For Developers**:
- Clear requirements before implementation
- Documented design decisions
- Testable acceptance criteria
- AI assistants that understand project context

**For Teams**:
- Shared understanding through specifications
- Natural review checkpoints
- Traceability from requirements to code
- Onboarding through documentation

**For Organizations**:
- Consistent code quality from AI-assisted development
- Reduced maintenance burden through documentation
- Audit trail for regulatory compliance
- Scalable AI adoption with quality controls

The key insight remains: **AI assistants are powerful but lack project context unless explicitly provided**. Spec-driven development ensures that context is documented, versioned, and always available.

This is not about slowing down—it's about sustaining velocity. Teams that skip specifications accumulate debt that eventually stops all progress. Teams that specify first build maintainable systems that accelerate over time.

## Appendix: Command Reference

### Spec-Driven Development Commands

| Command | Description |
|---------|-------------|
| `/dev:spec <feature>` | Generate requirements specification |
| `/dev:design <feature>` | Create technical design |
| `/dev:tasks <feature>` | Break down into tasks |
| `/dev:implement <id> <feature>` | Implement single task |
| `/dev:implement-all <feature>` | Implement all pending tasks |
| `/dev:review <feature>` | Review against specifications |
| `/dev:feature <feature>` | Full guided workflow |
| `/dev:status <feature>` | Show completion progress |

### Build System Commands

| Command | Description |
|---------|-------------|
| `mage build:default` | Build for current platform |
| `mage test:unit` | Run unit tests |
| `mage test:property` | Run property-based tests |
| `mage test:integration` | Run integration tests |
| `mage test:all` | Run all tests |
| `mage quality:lint` | Run linter |
| `mage quality:all` | All quality checks |
| `mage gen:all` | Generate all code |
| `mage dev:up` | Start dev environment |
| `mage ci:testLocal` | Run CI workflow locally |

## Further Reading

### Methodology

- [Easy Approach to Requirements Syntax (EARS)](https://www.iaria.org/conferences2010/filesICCGI10/Tutorial%20Slides%20ICCGI%202010%20Mavin.pdf) - The EARS format for requirements
- [Property-Based Testing](https://increment.com/testing/in-praise-of-property-based-testing/) - Testing with invariants

### Tools

- [Mage Build System](https://magefile.org/) - Go-based build automation
- [Ginkgo Testing Framework](https://onsi.github.io/ginkgo/) - BDD-style testing
- [testcontainers](https://testcontainers.com/) - Real infrastructure in tests
- [gopter](https://github.com/leanovate/gopter) - Property-based testing for Go

### Architecture

- [CLEAN Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Dependency rule and layer separation
- [12-Factor App](https://12factor.net/) - Cloud-native application methodology
