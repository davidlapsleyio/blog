---
title: "The IDE Doesn't Matter: A Philosophy for LLM-Powered Code Generation"
date: 2026-01-15
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
  - llm
  - ai-coding
  - spec-driven-development
  - sdld
  - build-systems
  - engineering-philosophy
---

LLMs are transforming how we build software. They can generate entire functions, refactor complex modules, and implement features faster than ever before. But after 18 months of production use, I've learned that most teams are focused on the wrong things. They obsess over which IDE to use—Cursor vs Claude Code vs VS Code with Copilot—when the IDE is just a shell. What matters is what's inside.

This post describes the philosophy my team uses for LLM-powered code generation. The core insight is simple: **LLMs are powerful but lack context. Our job is to give them structure, constraints, and feedback.** When you get this right, the specific IDE becomes irrelevant.

## The Tool Trap

Walk into any engineering team adopting AI-assisted development and you'll hear the same debates: Which AI IDE is best? Should we use Cursor or Claude Code? Does Copilot's autocomplete beat Cursor's chat interface?

These debates miss the point entirely.

The IDE is a user interface—a shell that wraps the components that actually matter. You can swap IDEs without changing your development philosophy, but you can't swap your development philosophy without changing your outcomes.

What actually matters falls into six categories, and none of them are IDE-specific:

1. **MCP Servers** - Tools that extend LLM capabilities
2. **Context Management** - What the LLM knows about your project
3. **Steering Documents** - AGENTS.md, conventions, patterns
4. **Model Selection** - Right model for the task
5. **Specification Quality** - Precise, testable requirements
6. **Build Pipeline Integration** - Closed-loop feedback

Let's examine each one.

## MCP Servers: Portable Tool Extensions

Model Context Protocol (MCP) servers extend what LLMs can do beyond text generation. They're the hands and eyes that let AI assistants interact with your development environment.

| MCP Server | Purpose |
|------------|---------|
| File System | Read, write, search files |
| Git | Version control operations |
| GitHub | Issues, PRs, code review |
| Kubernetes | Cluster inspection |
| Memory | Persistent context across sessions |
| Context7 | Library documentation lookup |

The key insight is that MCPs are portable across IDEs. If you configure a memory MCP server in Cursor, you can use the same configuration in Claude Code. Your investment in tooling isn't locked to a vendor—it travels with you.

This is why the IDE doesn't matter. The capabilities come from the MCPs, not the IDE wrapper.

## Context Management: What the LLM Knows

LLMs have limited context windows. A large codebase cannot fit entirely in context. What you load determines whether AI-generated code aligns with project patterns or creates inconsistent drift.

Effective context management follows a hierarchy:

```
ALWAYS LOADED (via AGENTS.md)
├── Steering documents (patterns, conventions)
└── Current task context (spec, design, tasks)

LOADED ON DEMAND
├── Referenced source files
├── Test files
└── Related specifications

PERSISTENT MEMORY (via MCP)
├── Architecture decisions
├── Discovered patterns
└── Debugging learnings
```

The always-loaded layer establishes baseline understanding. Every AI session starts with the same foundation: your project's architecture, coding conventions, and testing philosophy. This prevents the inconsistency that arises when different developers have different conversations with AI assistants.

The on-demand layer brings in specific context for the current task. When implementing a feature, the LLM sees the relevant source files, existing tests, and the feature specification.

The persistent memory layer captures knowledge that should survive across sessions: architecture decisions, discovered patterns, debugging insights. This transforms ephemeral chat conversations into durable project knowledge.

## Steering Documents: The Primary Context

The `AGENTS.md` file at the repository root serves as the primary context for AI assistants. It's the first thing they read, and it establishes everything they need to know about your project:

```markdown
# AGENTS.md

## Quick Reference: Commands
mage build:default, mage test:all, mage quality:lint

## Project Structure
internal/ - CLEAN architecture layers

## Architecture Rules
Entities import nothing, use cases import entities only

## Test Strategy
Property tests for validation, integration for APIs
```

AI assistants automatically read this file at session start. When they generate code, they follow these patterns. When they write tests, they use the right testing framework. When they suggest file locations, they respect the directory structure.

The problem is that steering documents must be kept current. Stale steering documents are worse than none—they cause AI assistants to generate code that violates current patterns. We review ours quarterly, updating them whenever the project evolves.

Beyond AGENTS.md, we maintain a set of steering documents in `.opencode/steering/`:

- `product.md` - Business context, domain understanding
- `structure.md` - Codebase architecture, directory organization
- `tech.md` - Technology stack, frameworks, libraries
- `test-strategy.md` - Testing philosophy and practices

These documents answer the questions a new team member would ask: What does this system do? How is it organized? What technologies do we use? How do we test? The difference is that AI assistants ask these questions on every session, and steering documents provide consistent answers.

## Model Selection: Right Tool for the Task

Different models excel at different tasks. Using Opus for a typo fix wastes resources. Using Haiku for complex architecture creates errors that cost more to fix than the savings on model costs.

Our approach:

| Task | Model | Rationale |
|------|-------|-----------|
| Complex architecture | Opus | Deep reasoning |
| Code implementation | Sonnet | Balance of speed/quality |
| Quick fixes, refactors | Haiku | Fast, cost-effective |

This isn't a rigid rule—it's a starting point. The key principle is matching model capability to task complexity. When you're designing a distributed system, you want the model that can reason about failure modes and consistency guarantees. When you're renaming a variable across a codebase, you want the model that can do it quickly without overthinking.

## Specification Quality: Precision Eliminates Ambiguity

This is where most teams fail. They give LLMs vague instructions and get vague implementations. I call this phenomenon **AI drift**—the tendency for LLM implementations to diverge from actual requirements because those requirements were never made explicit.

Consider the difference between vague and precise:

**Vague (AI Drift)**:
> "Add health endpoints to the service"

**Precise (SDLD)**:
```markdown
1. WHEN a client sends GET /health,
   THE System SHALL return HTTP 200 with JSON
2. THE response SHALL include status field
   with value "healthy"
3. THE response SHALL include timestamp field
   in RFC3339 format
```

The vague instruction leaves dozens of implicit decisions: Which HTTP status codes? What fields in the response? Should there be timeouts? The LLM will make those decisions, but they won't necessarily match what you needed.

The precise specification uses the EARS format (Easy Approach to Requirements Syntax), which forces every criterion to be testable:

| Pattern | Template |
|---------|----------|
| Event-Driven | WHEN \<trigger\>, THE System SHALL \<response\> |
| Ubiquitous | THE \<system\> SHALL \<requirement\> |
| Conditional | IF \<condition\>, WHEN \<event\>, THE System SHALL |
| Unwanted | THE System SHALL NOT \<behavior\> |

When you hand EARS-format requirements to an LLM, it knows exactly what to build. When you write tests, you know exactly what to verify. Precision eliminates ambiguity at every stage.

## Build Pipeline Integration: The Closed-Loop

Here's the insight that changes everything: **code generation isn't separate from the build pipeline—it's part of it.**

```
Spec → LLM Implementation → Build → Test → Deploy
              ↑                        │
              └────── Feedback ────────┘
```

LLMs are confident even when wrong. Without feedback, they will generate plausible-looking code that fails, violate project conventions, miss edge cases, and create subtle bugs. The solution is automated feedback at every step.

If it doesn't build, it doesn't ship. If tests fail, fix and retry. The LLM becomes part of the build pipeline, subject to the same quality gates as human-written code.

## Engineers as Team Leaders

This philosophy requires a fundamental shift in how engineers see their role.

**Before**: Engineers write code line by line.

**Now**: Engineers lead a team of AI assistants.

Think about it this way: the engineer is the team lead, and LLMs are junior developers. The team lead sets direction through specifications, reviews output for correctness, makes architectural decisions, and owns quality. The junior developers implement tasks from specs, generate tests, follow established patterns, and need clear instructions.

This framing is useful because it maps to something engineers already understand. Think about onboarding a new hire. What do they need to be productive?

1. **Clear requirements** - What exactly should they build?
2. **Coding standards** - How do we write code here?
3. **Architecture guidance** - Where does this code go?
4. **Feedback loops** - How do they know if it's right?

LLMs need the exact same things. The steering documents are the onboarding materials. The specifications are the task assignments. The build pipeline is the feedback loop. The engineer's job is to provide these structures, not to write every line of code.

Your responsibilities shift accordingly:

| Old Role | New Role |
|----------|----------|
| Write all code | Write specs, review implementations |
| Debug line by line | Define correctness properties |
| Memorize API docs | Curate context and steering docs |
| Manual testing | Define verification criteria |
| Solo work | Lead AI team |

You're the architect, not the bricklayer.

## Vibe Coding vs Spec-Driven Development

The failure mode we see most often is what I call "vibe coding"—rapid AI-assisted development through conversational iteration without structure:

```
Developer: "Add a user review feature"
AI: [generates code]
Developer: "Also add star ratings"
AI: [modifies code]
Developer: "Wait, only verified purchasers should review"
AI: [modifies code again]
```

This works for prototyping but creates problems at scale. The requirement "only verified purchasers should review" exists only in chat history. There's no traceability, no tests, no review checkpoint. Six months later, when someone asks why the feature works this way, no one can answer.

Spec-driven development inverts this pattern:

```
1. Write requirements.md (WHAT)
2. Human review & approve ← CHECKPOINT
3. Write design.md (HOW)
4. Human review & approve ← CHECKPOINT
5. Write tasks.md (STEPS)
6. Human review & approve ← CHECKPOINT
7. LLM implements each task
8. Build/test verifies correctness
```

Specs become the contract. LLMs follow the contract. Every decision is documented, traceable, and reviewable. When requirements change, the spec changes first, then the code follows.

## The Verification Pyramid

The feedback loop requires a verification pyramid that catches different kinds of problems at different levels:

```
                    ┌─────────────────┐
                    │   E2E Tests     │  ← Full system
                    │   (Minutes)     │
                    └────────┬────────┘
                    ┌────────┴────────┐
                    │ Integration     │  ← Components
                    │ (Seconds)       │
                    └────────┬────────┘
              ┌──────────────┴──────────────┐
              │     Property-Based Tests    │  ← Invariants
              │         (Seconds)           │
              └──────────────┬──────────────┘
        ┌────────────────────┴────────────────────┐
        │            Unit Tests                   │  ← Functions
        │            (Milliseconds)               │
        └────────────────────┬────────────────────┘
    ┌────────────────────────┴────────────────────────┐
    │         Linting & Formatting                    │  ← Style
    │         (Milliseconds)                          │
    └─────────────────────────────────────────────────┘
```

Each layer catches different problems. Linting catches style inconsistencies. Unit tests verify individual functions. Property-based tests verify universal invariants. Integration tests verify component interaction. E2E tests verify the complete system.

The LLM feedback loop runs through this pyramid after every change:

1. LLM generates code
2. `mage quality:lint` - Fix style issues
3. `mage quality:fmt` - Format code
4. `mage build:default` - Fix compilation
5. `mage test:unit` - Fix logic
6. `mage test:property` - Fix invariants
7. Ready to commit

We use Mage for build automation because it provides type-safe, cross-platform commands in Go. The same commands work for humans and AI:

```bash
mage quality:lint     # Run linter
mage quality:fmt      # Format code
mage build:default    # Build for current platform
mage test:unit        # Fast unit tests
mage test:property    # Property-based tests
mage test:integration # Integration tests
mage test:all         # Everything
mage ci:dryRun        # Full CI check locally
```

One command vocabulary for humans and AI. No special cases, no exceptions.

## Property-Based Testing

Property-based testing deserves special attention because it's where specs translate most directly into verification.

Traditional tests verify specific examples: "When I pass token X, I get result Y." Property-based tests verify universal statements: "For any valid token, the system accepts it."

```go
props.Property("verdict blocked iff any gate fails",
    prop.ForAll(
        func(gates []bool) bool {
            verdict := readiness.VerdictFromGates(gates)
            blocked := verdict == "blocked"
            anyFail := false
            for _, ok := range gates {
                if !ok { anyFail = true }
            }
            return blocked == anyFail
        },
        gen.SliceOf(gen.Bool()),
    ))
```

This test generates thousands of random inputs and verifies the property holds for all of them. It finds edge cases that humans miss. And it maps directly to the specification:

```markdown
*For any* set of gates, verdict = "blocked" iff any gate fails.
**Validates: Requirement 2.2**
```

The specification states the property. The test verifies it. The implementation must satisfy it. Complete traceability from requirement to verification.

## Code Generation in CI/CD

The final piece is integrating LLM-generated code into CI/CD. AI-generated code passes the same gates as human code:

```yaml
name: CI

jobs:
  test:
    steps:
      - run: mage gen:all        # Generate code
      - run: mage quality:lint   # Check style
      - run: mage test:unit      # Unit tests
      - run: mage test:property  # Property tests
      - run: mage build:default  # Build
```

There's no special treatment for AI-generated code. It either passes the gates or it doesn't. This is the closed loop in action: specs define requirements, LLMs implement them, and CI verifies correctness.

## The Three-Document Structure

Every feature gets three files organized in a spec directory:

```
specs/user-authentication/
├── requirements.md    # WHAT (EARS format)
├── design.md          # HOW (architecture + properties)
└── tasks.md           # STEPS (checkboxes + traces)
```

**Requirements** capture stakeholder needs and acceptance criteria in EARS format. This is the contract that defines success.

**Design** translates requirements into technical architecture, including components, interfaces, and correctness properties. This bridges business requirements and implementation.

**Tasks** break the design into discrete, implementable steps with explicit requirement traceability. Each task references the requirements it satisfies.

This structure provides complete traceability:

**Requirement 2.2**:
```markdown
WHEN any Readiness_Gate fails,
THE System SHALL mark verdict = "blocked"
```

**Design Property 2**:
```markdown
*For any* set of gates, verdict = "blocked"
iff any gate fails.
**Validates: Requirement 2.2**
```

**Task 3**:
```markdown
- [ ] 3. Write property test for verdict truth table
  - **Property 2: Verdict Truth Table**
  - _Requirements: 2.2_
```

Everything traces back. When a test fails, you can trace to the requirement. When a requirement changes, you can trace to the affected tasks.

## Anti-Patterns to Avoid

The most common failures I see:

**Writing code before specs** - Vibe coding creates undocumented decisions that haunt you later.

**Skipping tests because the LLM seems right** - LLMs are confident even when wrong. Always verify.

**Vague acceptance criteria** - "Handle errors gracefully" tells you nothing. "WHEN the database query fails, THE System SHALL return HTTP 503" tells you everything.

**Stale steering documents** - AI will generate code matching outdated patterns.

**Treating specs as separate from code** - Specs live in the repo, are reviewed in PRs, and evolve with the code.

The rule I use: if you wouldn't accept it from a junior developer, don't accept it from an LLM.

## Best Practices

What works:

**Specify before implementing** - Always. No exceptions.

**Review at checkpoints** - Approve specs before code. This prevents wasted implementation effort.

**Keep steering docs current** - Reflect actual patterns. Update them when the project evolves.

**Reference specs in PRs** - Traceability from code to requirements. Every PR should cite which requirements it implements.

**Let AI run verification** - `mage test:unit`, `mage quality:lint` after every change. The feedback loop catches errors immediately.

**Version specs with code** - Same branch, same PR. Specs and code stay synchronized.

## Getting Started

If you're joining a team that uses this philosophy:

**Day 1**: Read AGENTS.md and steering documents. Understand the project context.

**Day 2**: Browse existing specs in `specs/`. See how features are specified.

**Day 3**: Pick a task from an existing spec. Start small.

**Day 4**: Follow the workflow. Use AI commands. Run verification.

**Day 5**: Submit a PR with spec references.

You'll be productive in a week.

## Conclusion

LLMs are transforming how we build software. But they need structure, context, and feedback.

The IDE doesn't matter. What matters is:

- **Precise specifications** - The contract between you and the LLM
- **Steering documents** - The patterns and conventions the LLM must follow
- **Build pipeline integration** - The feedback loop that catches errors

Engineers are now team leaders with LLMs as junior developers. Your job is to provide clear requirements, coding standards, architecture guidance, and feedback loops—the same things any junior developer needs to be productive.

Code generation is part of the build pipeline, not separate from it. LLM-generated code passes the same gates as human code. The closed loop from specification to verification ensures correctness.

The tools are ready. The specs are the contract. The feedback loop is the guardrail. Now go lead your AI team.

## Further Reading

- [AWS Kiro](https://kiro.dev) - Agentic AI IDE with SDLD support
- [GitHub Spec Kit](https://github.com/github/spec-kit) - Open-source SDLD toolkit
- [EARS Requirements Pattern](https://alistairmavin.com/ears/) - The syntax foundation for precise requirements
- [Property-Based Testing with gopter](https://github.com/leanovate/gopter) - Go property testing library
- [Mage Build Tool](https://magefile.org/) - Go-based build automation
