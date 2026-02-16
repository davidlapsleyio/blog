---
title: "Spec-Driven LLM Development (SDLD): Precise Engineering Through Specifications"
description: "How to build production-grade code with LLMs using spec-driven development. Specifications as contracts that ensure both humans and AI produce exactly what you need."
date: 2026-01-11
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
  - llm
  - ai-coding
  - testing
  - verification
---


LLMs are transforming how we write code. They can generate entire functions, refactor complex modules, and implement features faster than ever before. But they've also exposed a fundamental truth that many engineering teams are learning the hard way: **vague instructions produce vague implementations**.

I've spent the past 18 months refining how I build robust, production-grade code with LLMs, and how I do it quickly. The approach I've landed on, which I call **Spec-Driven LLM Development (SDLD)**, combines the best ideas from tools across the landscape and integrates them with agentic automation, build systems, and CI/CD pipelines. The core insight is simple: specs aren't just documentation-they're the **contract** that ensures both humans and AI produce exactly what you need.

This post shares what I've learned: the methodology, why it works, and concrete examples you can adapt for your own teams and workflows.



## The Problem: AI Drift

Consider a typical interaction with an LLM coding assistant:

> "Add health endpoints to the service. We need a basic liveness check and a readiness check that verifies database connectivity. The endpoints should return JSON and follow REST conventions. Make sure it integrates with our existing router setup."

This seems reasonably detailed. But what you get back probably won't be what you actually needed. The LLM made dozens of implicit decisions: Which HTTP status codes for success vs failure? What fields in the JSON response? Should database checks have timeouts? What happens if the database is intentionally disabled? How should errors be logged?

I call this phenomenon **AI drift**-the tendency for LLM implementations to diverge from your actual requirements because those requirements were never made explicit.

| Without Specs | With Specs |
|---------------|------------|
| "Add health endpoints" | Ambiguous implementation: What status codes? What response format? Which dependencies to check? |
| "Implement requirements 1.1 through 1.5 from control-plane-health-endpoints spec" | Precise implementation: HTTP 200 with JSON, RFC3339 timestamps, Database/cache checks, Configurable timeouts |

The solution isn't to give up on LLMs-it's to give them better inputs. That's where SDLD comes in.



## The Core Idea: Specs as Contracts

Think of a spec as a legally binding contract between you and the LLM. The contract works like this:

1. **You specify** exactly what you want, with testable acceptance criteria
2. **The LLM implements** according to those criteria
3. **Tests verify** the implementation matches the spec
4. **Everyone wins**: you get what you asked for, the LLM has clear guidance

This isn't a new idea-formal specifications have been around for decades. What's new is how critical they become when your "developer" is an AI that can't read your mind, doesn't know your codebase conventions, and will confidently produce plausible-looking code that does the wrong thing.

## The Tools: SDLD Ecosystem

A growing ecosystem of tools has emerged to support SDLD. Here are the major players:

**[AWS Kiro](https://kiro.dev)** is Amazon's agentic AI IDE, launched in mid-2025. Kiro pioneered the three-file spec structure (requirements.md, design.md, tasks.md) that forms the foundation of my workflow. It uses EARS notation for requirements, generates sequence diagrams in design docs, and provides a task execution interface with real-time status tracking. After evaluating several approaches, I found Kiro's format the most natural and rigorous-it produced the best results when integrated with my build and CI/CD systems.

**[GitHub Spec Kit](https://github.com/github/spec-kit)** is an open-source toolkit that works with GitHub Copilot, Claude Code, and other LLM assistants. It uses a four-phase process (Specify → Plan → Tasks → Implement) with slash commands like `/specify` and `/plan`. The key principle: "Maintaining software means evolving specifications."

**[Traycer](https://traycer.ai)** takes a different approach as a workflow orchestration layer. It generates file-level detailed plans with mermaid diagrams, then hands off execution to your preferred coding agent (Cursor, Claude Code, GitHub Copilot). It also verifies that implementations adhere to the plan.

**[Actualyze](https://actualyze.dev)** automates SDLD and incorporates it into a fully automated SDLC. If you're looking to scale this approach across teams or integrate it into CI/CD pipelines, Actualyze provides the infrastructure to make that happen.

**[Semcheck](https://semcheck.ai)** focuses specifically on verification-it checks whether code matches its specification. You can run it in pre-commit hooks or CI/CD pipelines to prevent implementation drift.

All these tools share a common philosophy: specs become the source of truth, not code. They move teams from "vibe coding" (impromptu prompting) to structured, testable specifications that AI agents can reliably execute. My approach takes this further by wiring these specs directly into automated build pipelines and CI/CD systems, creating a closed loop from specification to verified, deployed code.



## Specs as First-Class Code Artifacts

Here's a principle that took me a while to internalize: **specs belong in your repository, not in a wiki or a separate documentation system.**

When specs live alongside code, several good things happen:

- **Traceability**: `git blame` shows who changed what requirement and when
- **History**: You can see how requirements evolved over time
- **Context**: New engineers understand *why* code exists by reading the original spec
- **Synchronization**: Specs and code stay in sync through the same PR process

Our directory structure looks like this:

```
your-project/
├── specs/
│   ├── README.md
│   ├── mage-build-system/
│   │   ├── requirements.md
│   │   ├── design.md
│   │   └── tasks.md
│   ├── authentication-middleware/
│   │   ├── requirements.md
│   │   ├── design.md
│   │   └── tasks.md
│   └── control-plane-health-endpoints/
│       ├── requirements.md
│       ├── design.md
│       └── tasks.md
├── internal/
├── cmd/
└── test/
```

Every feature gets its own spec folder with three documents. Let me explain what each one does.



## The Three-Document Structure

### Requirements: The "What" and "Why"

The `requirements.md` file defines success criteria. For LLMs, this is especially critical-they need explicit, testable statements, not vague descriptions of intent.

We use the **EARS (Easy Approach to Requirements Syntax)** pattern because it produces machine-parseable requirements:

| Keyword | Meaning | Example |
|---------|---------|---------|
| WHEN | Trigger condition | WHEN a client sends GET /health |
| THE | System component | THE System |
| SHALL | Mandatory | SHALL return HTTP 200 |
| SHALL NOT | Forbidden | SHALL NOT log secrets |
| IF | Conditional | IF the cache is nil |

Here's a real example from our health endpoints spec:

```markdown
### Requirement 1

**User Story:** As a platform operator, I want a basic health check endpoint,
so that I can verify the Control Plane service is running and responsive.

#### Acceptance Criteria

1. WHEN a client sends GET /health, THE System SHALL return HTTP 200 with JSON
2. WHEN the health endpoint responds, THE System SHALL include status field
   with value "healthy"
3. WHEN the health endpoint responds, THE System SHALL include timestamp field
   in RFC3339 format
4. WHEN the health endpoint responds, THE System SHALL include service field
   with value "control-plane"
5. WHEN the health endpoint responds, THE System SHALL include version field
   with the current service version
```

Notice what's happening here: every criterion is specific and testable. Values are explicitly stated ("healthy", "RFC3339"). There's no ambiguity about expected behavior.

When you hand this to an LLM, it knows exactly what to build. When you write tests, you know exactly what to verify.

### Design: The "How"

The `design.md` document captures architectural decisions that the LLM must follow. Without this guidance, LLMs will make their own architectural choices-and you'll spend hours reversing them.

Here's an example from our build system spec:

```go
### Mage Target Organization

Targets are organized into namespaces for clarity (100% namespaced):

type Build mg.Namespace

func (Build) Default() error           // Build for current platform
func (Build) All() error               // Build for all platforms
func (Build) LinuxAmd64() error        // Build for linux-amd64
```

Now the LLM knows: use namespaces (not flat functions), follow this naming convention, match the existing pattern. No guessing required.

A critical part of design documents is **correctness properties**-formal statements about system behavior that become property-based tests:

```markdown
### Property 4: Status Code Mapping

*For any* ready endpoint response, if all checks have value "ok" then
HTTP status should be 200, and if any check has value "error" then
HTTP status should be 503.

**Validates: Requirements 2.3, 2.4, 4.2, 4.3**
```

### Tasks: The "When"

The `tasks.md` file is the implementation checklist-direct instructions for whoever is writing the code, whether human or LLM.

```markdown
- [ ] 1. Create health check logic file and implement dependency testing
  - Create `internal/control/health.go` with package declaration and imports
  - Implement `CheckDatabaseHealth(db *gorm.DB) string` function
    - Handle nil database connection (return "error")
    - Execute ping with 500ms timeout
    - Return "ok" on success, "error" on failure
  - _Requirements: 5.1, 5.2, 5.3, 5.5_

- [ ] 1.1 Write property test for database health check function
  - **Property 5: Database Check Result Mapping**
  - **Validates: Requirements 5.2, 5.3**
```

Notice the pattern: every implementation task has corresponding test tasks. Nothing ships without verification.



## The Verification Pyramid

Specs are only valuable if you can verify the implementation matches them. We use a multi-layered approach:

```
                    ┌─────────────────┐
                    │   E2E Tests     │  ← Full system verification
                    │   (Minutes)     │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │ Integration     │  ← Component interaction
                    │ (Seconds)       │
                    └────────┬────────┘
                             │
              ┌──────────────┴──────────────┐
              │     Property-Based Tests    │  ← Universal properties
              │         (Seconds)           │
              └──────────────┬──────────────┘
                             │
        ┌────────────────────┴────────────────────┐
        │            Unit Tests                   │  ← Individual functions
        │            (Milliseconds)               │
        └────────────────────┬────────────────────┘
                             │
    ┌────────────────────────┴────────────────────────┐
    │         Linting & Formatting                    │  ← Code quality
    │         (Milliseconds)                          │
    └─────────────────────────────────────────────────┘
```

Each layer catches different kinds of problems:

**Linting and Formatting** catches style inconsistencies and common bugs. LLMs sometimes generate code with subtle issues that automated tools catch immediately.

**Unit Tests** verify individual functions behave correctly for specific inputs.

**Property-Based Tests** verify universal truths across all valid inputs. This is where specs really shine-those correctness properties I mentioned earlier become executable tests:

```go
func TestProperty_DatabaseCheckResultMapping(t *testing.T) {
    parameters := gopter.DefaultTestParameters()
    parameters.MinSuccessfulTests = 100

    properties := gopter.NewProperties(parameters)

    properties.Property("database check returns correct status", prop.ForAll(
        func(dbState string) bool {
            switch dbState {
            case "working":
                return CheckDatabaseHealth(workingDB) == "ok"
            case "nil":
                return CheckDatabaseHealth(nil) == "error"
            case "failed":
                return CheckDatabaseHealth(failedDB) == "error"
            }
            return true
        },
        gen.OneOfConst("working", "nil", "failed"),
    ))

    properties.TestingRun(t)
}
```

**Integration Tests** verify components work together correctly.

**E2E Tests** verify the complete system works as intended.



## The Workflow: Spec-Test-Verify Loop

Here's how this plays out in practice. The key is that each step feeds into automated systems that verify correctness before anything reaches production:

**Step 1: Write the spec first.** Before engaging the LLM, create your requirements, design, and tasks documents. This forces you to think through what you actually want.

**Step 2: Share context with the LLM.** Give it all three documents and point it at a specific task:

> "I need to implement the control-plane-health-endpoints feature. Here are the specs: [requirements.md, design.md, tasks.md]. Please implement task 1."

**Step 3: The LLM implements.** It follows requirements for behavior, design for architecture, and tasks for scope.

**Step 4: Verify with tests.**

```bash
mage quality:lint      # Does it pass linting?
mage test:unit         # Do unit tests pass?
mage test:property     # Do properties hold?
```

**Step 5: Iterate if needed.** If verification fails, you have specific feedback to give:

> "Task 1 is failing property test 5. The requirement says 'WHEN the database connection is nil, THE System SHALL return error' but the implementation returns 'ok'. Please fix."

**Step 6: Mark complete and continue.** Update the task checklist and move to the next item. When integrated with CI/CD, this entire loop can run automatically, with the build system orchestrating LLM agents, running verification, and only promoting code that passes all checks.



## Real-World Results

Let me share three examples from our codebase where this approach paid off.

### Mage Build System Migration

We needed to migrate from Makefile to Mage while maintaining all functionality. The spec included 19 detailed requirements, a design document with exact interface signatures, and 23 implementation tasks.

The outcome: complete migration with zero functionality loss. Every target was verified against explicit requirements.

### CLEAN Architecture Reorganization

Restructuring an entire codebase is risky. Our spec included property-based tests that verify architectural constraints:

```markdown
**Property 6: Dependency rule enforcement**
*For any* Go source file in the repository, its import statements
should follow the dependency rule where entities import nothing
from other layers, use cases import only from entities...
```

These constraints are now automatically verified on every commit. The architecture can't drift because the tests won't let it.

### Authentication Middleware

Implementing JWT auth with a development bypass mode required clear requirements for both production and development behavior:

```markdown
1. WHEN running in development mode with X-Test-Namespace header present,
   THE Authentication_Middleware SHALL use the header value as the namespace
2. WHEN running in development mode without X-Test-Namespace header,
   THE Authentication_Middleware SHALL use a default namespace "default"
```

The spec made edge cases explicit. The tests verified them. The LLM implemented them correctly on the first try.



## Specs as Living Documentation

Beyond guiding implementation, specs serve as permanent records of decision-making.

Six months from now, when someone asks "why does the cache check return 'ok' when the cache is nil?", the spec has the answer:

```markdown
5. WHEN the cache connection is nil, THE System SHALL mark cache status
   as "ok" (cache is optional)
```

The design document explains the rationale:

```markdown
**Rationale**: The cache is used for performance optimization, not core
functionality. A missing cache should not prevent the service from
being marked as ready.
```

When debugging, specs help you distinguish between implementation bugs (code doesn't match spec) and spec gaps (spec doesn't cover this case).

For onboarding, new team members can read specs to understand what the system does, designs to understand how it's built, and tasks to see what was verified.



## Best Practices

After 18 months of refining this approach, here's what I've learned:

**Write specs before implementation.** Even if the LLM could "just figure it out," specs ensure you get what you actually need.

**Make every requirement testable.** "The system should be fast" isn't a requirement. "THE System SHALL respond within 100 milliseconds" is.

**Include verification in tasks.** Every implementation task should have corresponding test tasks.

**Update specs when requirements change.** If a PR changes behavior, it must update the spec. This keeps everything synchronized.

**Reference requirements in tests.** A comment like `// Requirement 1.3: timestamp field in RFC3339 format` makes traceability explicit.



## Anti-Patterns to Avoid

**Writing specs after implementation.** This defeats the purpose. Specs guide implementation; they don't document it after the fact.

**Skipping tests because the LLM seems right.** LLMs are confident even when wrong. Always verify.

**Vague acceptance criteria.** "Handle errors gracefully" tells you nothing. "WHEN the database query fails, THE System SHALL return HTTP 503" tells you everything.

**Treating specs as separate from code.** Specs live in the repo, are reviewed in PRs, and evolve with the code.



## Conclusion

SDLD comes down to two principles: **precision** and **verification**.

Specs define success with testable acceptance criteria. LLMs implement following explicit guidance. Tests verify the implementation matches the spec. Versioned specs provide permanent, searchable history.

The result is reliable code that does exactly what you specified, comprehensive tests that catch regressions, living documentation that explains why code exists, and efficient LLM collaboration with clear contracts. When you integrate this with agentic automation and CI/CD, you get a development workflow that's both fast and rigorous.

Specs aren't overhead-they're the foundation of production-grade LLM development.



## Further Reading

- [AWS Kiro](https://kiro.dev) - Agentic AI IDE with SDLD support
- [GitHub Spec Kit](https://github.com/github/spec-kit) - Open-source SDLD toolkit
- [Actualyze](https://actualyze.dev) - Automated SDLD platform
- [EARS Requirements Pattern](https://alistairmavin.com/ears/)
- [Property-Based Testing with gopter](https://github.com/leanovate/gopter)
- [CLEAN Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Mage Build Tool](https://magefile.org/)
- [12-Factor App](https://12factor.net/)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
