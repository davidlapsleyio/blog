---
title: "Working Backwards with SDLD: Building a Go Service with Mage"
date: 2026-01-13
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
  - Go
  - Tooling
tags:
  - spec-driven-development
  - sdld
  - mage
  - golang
  - tutorial
  - workflow
---

Written in the working-backwards narrative style we use for launch docs.*

## Press Release (Day 1)

**Tampa, WA — Two-pizza team ships "Launch Readiness Reporter" (LRR), a Go service that ingests deployment events, evaluates readiness checks, and posts a verdict to Slack.**

LRR is built with Spec-Driven LLM Development (SDLD), runs a Magefile build system, and treats specifications as code. The service answers a simple question every time we deploy: *"Are we actually ready to hit prod, and can we prove it?"*

> "We cut review time by 40% because specs told the LLM exactly what to build," says Priya, the on-call SRE. "The Magefile made the workflow muscle memory—`mage quality:all && mage test:all` and we ship."

## FAQ (Working Backwards)

- **Who is this for?** New engineers (and their AI copilots) joining a Go shop that expects specs-first delivery and Mage-based automation.
- **What problem are we solving?** Ambiguous launch-readiness logic, manual build steps, and "vibe-coded" features that drift from intent.
- **Why Go + Mage?** Type-safe build automation that lives in the same language as the service; no Makefile portability fights.
- **Why SDLD here?** Readiness criteria are brittle. Specs give us traceability from Slack message back to requirement 2.3.
- **How will we know we’re successful?** Green checks for all spec-linked tests, zero undocumented behavior, and a single command (`mage ci:dryRun`) that proves we’re production-ready.

## The Example Project in One Paragraph

Launch Readiness Reporter ingests deployment events (from GitHub or Argo), evaluates three readiness gates (migration status, feature-flag coverage, error budget), and posts a signed Slack message with the verdict plus links to evidence. It is small enough to build in a day, but rich enough for specs, property tests, and Mage targets.

## Repository Layout (Spec-Driven First)

```
lrr/
├── specs/
│   └── launch-readiness/
│       ├── requirements.md
│       ├── design.md
│       └── tasks.md
├── cmd/lrrd/main.go          # HTTP + worker entrypoint
├── internal/
│   ├── ingest/               # Webhook + polling adapters
│   ├── readiness/            # Core evaluation logic
│   ├── slack/                # Signing + formatting
│   └── store/                # Postgres persistence
├── magefiles/
│   ├── magefile.go
│   └── versions.go
└── test/
    └── readiness_property_test.go
```

Specs live beside code. Every code artifact exists because a requirement says it must.

## The Specification (Concise, Traceable, Testable)

### requirements.md (EARS format)

```markdown
# Requirements: Launch Readiness Reporter

## Glossary
- **Deployment_Event**: Signed payload describing git SHA, service, environment.
- **Readiness_Gate**: Boolean check (migrations, flags, error budget) with rationale.
- **Verdict_Payload**: Slack message with status, gates, evidence links.

## Requirements

### Requirement 1: Accept deployment events
1. WHEN a Deployment_Event arrives at /events, THE System SHALL verify signature and persist the payload.
2. WHEN signature verification fails, THE System SHALL return HTTP 401 and SHALL NOT persist the payload.

### Requirement 2: Evaluate readiness gates
1. WHEN a persisted Deployment_Event is processed, THE System SHALL evaluate three Readiness_Gates and record pass/fail with evidence links.
2. WHEN any Readiness_Gate fails, THE System SHALL mark verdict = "blocked" with gate details.
3. WHEN all Readiness_Gates pass, THE System SHALL mark verdict = "go" with timestamps.

### Requirement 3: Post signed Slack verdict
1. WHEN verdict is determined, THE System SHALL sign and POST Verdict_Payload to Slack webhook.
2. WHEN Slack POST fails, THE System SHALL retry with backoff 3 times before marking status = "degraded".
```

### design.md (interfaces + properties)

```markdown
## Architecture
- ingest.HTTPHandler verifies HMAC, writes Deployment_Event to store, enqueues job.
- readiness.Engine consumes jobs, runs Gate checks (migrations, flags, error budget).
- slack.Client signs payloads and POSTs with retry/backoff.

## Correctness Properties
1. *For any* Deployment_Event with invalid signature, no record is persisted. (Validates: 1.2)
2. *For any* set of Readiness_Gates, verdict = "blocked" iff any gate fails. (Validates: 2.2)
3. *For any* failed Slack attempt, retries = 3 with exponential backoff; after retries, status = "degraded". (Validates: 3.2)
```

### tasks.md (atomic, ordered)

```markdown
- [ ] 1. Create Magefile scaffolding (namespaces Build, Test, Quality, Dev) _Requirements: platform parity_
- [ ] 2. Implement HMAC verification + /events handler _Requirements: 1.1, 1.2_
- [ ] 3. Write property test for verdict truth table _Requirements: 2.2_
- [ ] 4. Implement Slack signer with retry/backoff _Requirements: 3.1, 3.2_
- [ ] 5. Checkpoint: mage quality:all && mage test:all
```

Everything traces back to numbered acceptance criteria. No task exists without a requirement.

## Magefile: Build, Test, Verify (in Go)

```go
// magefiles/magefile.go
//go:build mage

package main

import (
    "fmt"
    "github.com/magefile/mage/mg"
    "github.com/magefile/mage/sh"
)

type Build mg.Namespace

func (Build) Default() error { return sh.RunV("go", "build", "./...") }
func (Build) Clean() error   { return sh.RunV("rm", "-rf", "./bin", "./dist") }

type Test mg.Namespace

func (Test) Unit() error      { return sh.RunV("go", "test", "./...", "-short") }
func (Test) Property() error  { return sh.RunV("go", "test", "./test", "-run", "Property") }
func (Test) All() error       { return sh.RunV("go", "test", "./...") }

type Quality mg.Namespace

func (Quality) Lint() error { return sh.RunV("go", "run", "github.com/golangci/golangci-lint/cmd/golangci-lint@v1.59.1", "run") }
func (Quality) Fmt() error  { return sh.RunV("gofmt", "-w", "./") }
func (Quality) All() error  { return mg.SerialDeps(Quality.Fmt, Quality.Lint) }

type Dev mg.Namespace

func (Dev) Up() error   { return sh.RunV("docker", "compose", "up", "-d") }
func (Dev) Down() error { return sh.RunV("docker", "compose", "down") }

type CI mg.Namespace

func (CI) DryRun() error {
    fmt.Println("== CI dry run ==")
    return mg.SerialDeps(Quality.All, Test.All, Build.Default)
}
```

Mage becomes the single UX for humans and AI agents. Every task in `tasks.md` names a Mage target in its verification note.

## Selected Implementation Slices (Practitioner to Practitioner)

### HMAC verification and ingest handler

```go
// internal/ingest/http.go
func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    body, _ := io.ReadAll(r.Body)
    if !h.signer.Valid(body, r.Header.Get("X-Signature")) {
        http.Error(w, "unauthorized", http.StatusUnauthorized)
        return
    }
    evt, err := decodeEvent(body)
    if err != nil {
        http.Error(w, "bad request", http.StatusBadRequest)
        return
    }
    if err := h.store.Save(r.Context(), evt); err != nil {
        http.Error(w, "server error", http.StatusInternalServerError)
        return
    }
    h.queue.Enqueue(evt)
    w.WriteHeader(http.StatusAccepted)
}
```

- Requirement hook: 1.1 (persist valid) and 1.2 (reject invalid). 
- Test hook: property 1 ensures invalid signatures never persist.

### Verdict truth table property test

```go
// test/readiness_property_test.go
func TestProperty_VerdictTruthTable(t *testing.T) {
    props := gopter.NewProperties(nil)
    props.Property("blocked iff any gate fails", prop.ForAll(
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
    props.TestingRun(t)
}
```

- Requirement hook: 2.2, correctness property 2.
- Outcome: regressions in gate logic surface immediately.

### Slack signer with backoff

```go
// internal/slack/client.go
func (c *Client) Post(ctx context.Context, payload VerdictPayload) error {
    signed := c.sign(payload)
    var err error
    backoff := []time.Duration{1 * time.Second, 2 * time.Second, 4 * time.Second}
    for i := 0; i < len(backoff)+1; i++ {
        if err = c.doPost(ctx, signed); err == nil {
            return nil
        }
        if i < len(backoff) {
            time.Sleep(backoff[i])
        }
    }
    return fmt.Errorf("slack degraded after retries: %w", err)
}
```

- Requirement hook: 3.1 and 3.2; test hook in integration layer can assert retry counts.

## Running the SDLD Loop (Hands-On)

1. **Write the spec first**: fill in `specs/launch-readiness/requirements.md`, `design.md`, `tasks.md` with the snippets above and your specifics (e.g., Argo webhook schema).
2. **Share context with your AI assistant**: provide all three docs and say, *"Implement tasks 1 and 2; verify with mage quality:all && mage test:unit."*
3. **Implement sequentially**: the LLM builds ingest handler → verdict engine → Slack signer in that order.
4. **Verify**: run `mage quality:all`, `mage test:unit`, `mage test:property`, then `mage ci:dryRun` before opening a PR.
5. **Update specs when behavior changes**: if you tweak retry logic, change requirements 3.2 and the property test in the same PR.

## Onboarding Playbook (60–90 Minutes)

- **0–15 min**: Read the spec (requirements/design/tasks). Annotate gaps.
- **15–30 min**: Run `mage ci:dryRun` to confirm toolchain. Fix any missing deps.
- **30–60 min**: Pair your AI assistant on tasks 2 and 3. Keep spec open; paste acceptance criteria into the prompt.
- **60–75 min**: Write/adjust property and integration tests until green.
- **75–90 min**: Draft PR description referencing requirements numbers (e.g., "Implements 2.1–2.3, 3.1–3.2").

## Pitfalls and Guardrails

- **Do not code before the spec**: every drift we’ve seen came from skipping requirements edits.
- **Keep Mage targets deterministic**: pin tool versions in `magefiles/versions.go` and avoid `bash -lc` shells.
- **Property tests are cheap insurance**: catch logical regressions faster than end-to-end tests.
- **Trace everything**: add `_Requirements:` references in tasks and test names that echo requirement IDs.

## What You Get

- A concrete, moderately complex Go service that demonstrates the full SDLD loop.
- A Magefile that makes verification one command away for humans and agents.
- A repeatable pattern for specs-first feature work that keeps code, tests, and documentation locked together.

Working backwards keeps us honest: we define the customer need (deployment clarity), codify it in specs, and let Mage enforce it. From practitioner to practitioner—copy this pattern, adjust the gates for your domain, and ship without drift.
