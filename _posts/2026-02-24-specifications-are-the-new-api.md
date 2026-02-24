---
title: "Specifications Are the New API Between Product
  and Engineering"
description: "Specifications are no longer documentation
  for humans. They're contracts for machines. The
  three-document spec format functions as an API between
  product discovery and code generation."
date: 2026-02-24
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
header:
  og_image: /assets/images/specs-api-og.jpg
categories:
  - Engineering
  - AI-Assisted Development
  - Product Management
tags:
  - spec-driven-development
  - ai-coding
  - working-backwards
  - sdlc
  - specifications
  - requirements
---

Picture this. Your team just adopted an AI coding agent.
Cursor, Claude Code, Copilot, it doesn't matter which.
The first week is electric. A developer prompts "add a
user review feature" and gets working code in minutes.
Ship it.

Second week, the PM looks at the feature. "That's not
what I meant. Reviews should only be visible after
moderation. Star ratings should be half-star increments.
And where's the verified purchaser badge?"

None of those requirements were written down. The
developer assumed. The coding agent assumed harder. The
result was plausible-looking code that solved a problem
nobody actually had.

This isn't an edge case. It's the default outcome when
you feed vague specifications to a machine that
interprets instructions literally, fills ambiguity with
training data patterns, and diverges from intent in ways
that are invisible until code review.

The interface between product and engineering has changed.
Specifications are no longer documentation for humans.
They're **contracts for machines**.

---

## The Old Interface Tolerated Ambiguity

For decades, the interface between product and
engineering was a Jira ticket, a Figma mock, a Google
Doc with bullet points, or a conversation in a hallway.
Ambiguity in that interface was tolerable because the
downstream consumer was a human engineer.

Human engineers do things that AI coding agents can't:

- They ask clarifying questions: "Should reviews be
  editable after posting?"
- They make reasonable assumptions based on domain
  experience: "This probably needs rate limiting."
- They push back on missing requirements: "The spec
  doesn't say what happens when the API times out."
- They use professional judgment to fill gaps: "This
  pattern is inconsistent with how we handle the rest
  of the UI. Let me align it."

These invisible acts of interpretation made vague
specifications workable. The engineer was a translator
between imprecise product intent and precise
implementation. The translation happened through dozens
of micro-decisions that were never documented but were
(mostly) correct.

AI coding agents don't translate. They execute. When a
specification says "add a user review feature," the
coding agent generates a user review feature. It picks
a data model, an API structure, a UI layout, and a
validation approach. Every one of those decisions might
be wrong. Not because the agent is bad, but because
nobody told it what "right" looks like.

I introduced the concept of **AI drift** in my post on
[Spec-Driven LLM Development](/engineering/process/best%20practices/ai-assisted%20development/2026/01/11/spec-driven-development-with-llms/):
the tendency for LLM implementations to diverge from
requirements because those requirements were never made
explicit. AI drift is what happens when training data
patterns fill the gaps that human judgment used to fill.

The old interface tolerated ambiguity because humans
resolved it. The new interface can't.

---

## Specifications as API Contracts

Here's the analogy that clarified this for me.

In microservices architecture, services communicate
through well-defined APIs. The API contract specifies
exactly what each service accepts, what it returns, and
how it handles errors. When the contract is clear,
services can evolve independently. When the contract is
vague, services break each other in production.

The relationship between product discovery and code
generation has the same structure. Product discovery
produces a description of what to build. Code generation
consumes that description and produces an implementation.
The specification is the API contract between them.

Just as a well-defined API enables loose coupling between
services, a well-defined specification enables loose
coupling between product thinking and code generation.
The product team can iterate on requirements without
knowing which coding agent will implement them. The
coding agent can implement features without understanding
the product strategy behind them. The spec is the
contract that makes this independence possible.

And just as a poorly defined API creates brittle
integrations that break at the worst times, a poorly
defined spec creates implementations that look right but
solve the wrong problem.

In my post on
[The IDE Doesn't Matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/),
I argued that specification quality is the differentiator
in AI-assisted development, not the choice of coding
tool. The API analogy explains why. The IDE is the
HTTP client. The specification is the API contract. You
can swap HTTP clients all day. If the contract is broken,
nothing works.

---

## The Three-Document Specification Format

In the
[SDLD specification format](/engineering/process/best%20practices/ai-assisted%20development/2026/01/12/sdld-specification-format/),
every feature gets three documents:

```
specs/[feature-name]/
├── requirements.md    # WHAT the system should do
├── design.md          # HOW the system will do it
└── tasks.md           # STEPS to implement it
```

These three documents are the API contract between
product discovery and code generation. Each document
serves a different consumer:

- **requirements.md** is the contract with stakeholders.
  It defines what the system should do in terms they can
  review and approve.
- **design.md** is the contract with the architecture.
  It specifies components, interfaces, and correctness
  properties.
- **tasks.md** is the contract with the coding agent.
  It provides ordered, atomic implementation steps with
  explicit traceability to requirements.

This separation matters for the same reason API
versioning matters. Requirements can change without
redesigning the architecture. Architecture can evolve
without rewriting the task list. Each document has its
own lifecycle, its own reviewers, and its own rate of
change.

But the real power is in the connections between them.
Every design component traces to requirements it
satisfies. Every task traces to requirements it
implements. Every correctness property traces to
requirements it validates. This traceability is the
contract enforcement mechanism. When the implementation
matches the tasks, and the tasks match the requirements,
and the requirements match the product intent, the
system works correctly. When any link breaks, you can
trace exactly where the break occurred.

---

## What Makes a Spec "Machine-Readable"

Not all specifications function as good API contracts.
A Google Doc with bullet points is a specification.
It's not machine-readable in any meaningful sense.

Three characteristics distinguish machine-readable
specifications from human-readable documentation.

### 1. EARS-Format Requirements

The EARS format (Easy Approach to Requirements Syntax)
turns natural language requirements into structured,
testable statements. Consider the difference:

**Human-readable (ambiguous):**

> "The system should handle errors gracefully."

**Machine-readable (EARS format):**

```markdown
1. WHEN the database query fails,
   THE System SHALL return HTTP 503 with a
   JSON error body containing "service unavailable"
2. WHEN the external API returns a non-200 status,
   THE System SHALL log the response and retry
   up to 3 times with exponential backoff
3. THE System SHALL NOT expose internal error
   details in API responses
```

The human-readable version leaves dozens of decisions
to the implementer. Which errors? What does "gracefully"
mean? HTTP 500? A friendly error page? A retry?

The EARS version specifies exactly one behavior per
criterion. Each criterion is testable. There's no room
for the coding agent to improvise.

The EARS vocabulary is precise: **SHALL** indicates a
mandatory requirement. **SHALL NOT** indicates prohibited
behavior. **WHEN** triggers event-driven behavior. **IF**
introduces conditional behavior. This vocabulary
eliminates the ambiguity that causes AI drift.

### 2. Explicit Acceptance Criteria

In my post on
[Amazon's Working Backwards SDLC](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/),
I walked through a concrete example. A user story for
the Jira report feature included five testable acceptance
criteria:

> - Report includes a section listing completed tickets
>   grouped by assignee.
> - Each ticket shows title, ticket ID, and completion
>   date.
> - Tickets sorted by completion date, most recent first.
> - If a team member completed zero tickets, they still
>   appear with "No completed tickets."
> - The section header shows total ticket count for the
>   period.

This is exactly the level of precision that coding
agents need. Every criterion answers a question the
agent would otherwise have to guess about: What fields
does each ticket show? What's the sort order? What's the
empty state? What's the header content?

Most teams skip this level of detail. They write "show
completed tickets per person" and assume the engineer
will figure out the rest. A human engineer would ask:
"What fields? What sort order? What if someone has no
tickets?" An AI coding agent will decide for itself,
confidently, and probably differently from what the PM
had in mind.

**A user story without acceptance criteria is a wish,
not a requirement.** I've said this before. It's worth
saying again. In the context of AI-assisted development,
it's the difference between code that works on the first
attempt and code that requires three rounds of rework.

### 3. Component-to-Requirement Traceability

The third characteristic is traceability. Every design
component links to the requirements it implements. Every
task links to the requirements it fulfills. The
correctness properties in the design document link to the
requirements they validate.

This isn't bureaucratic overhead. It's contract
enforcement.

In the
[SDLD specification format](/engineering/process/best%20practices/ai-assisted%20development/2026/01/12/sdld-specification-format/),
traceability works through explicit annotations:

```markdown
## Correctness Properties

### Property 1: Valid JWT Always Passes Auth

*For any* valid JWT token with required claims,
production auth middleware should allow the
request through and populate context.

**Validates:** Requirements 1.1, 6.2, 6.3
```

```markdown
## Tasks

- [ ] 5. Implement production auth middleware
  - _Requirements: 1.1, 1.5, 3.1, 3.3, 9.1_
```

When a test fails, you trace backward: which
requirement was violated? When a requirement changes,
you trace forward: which tasks and properties need
updating? When a coding agent produces output that
doesn't match expectations, you trace the gap: is it a
requirements problem, a design problem, or an
implementation problem?

This is exactly how API contracts work in practice.
When a service returns unexpected data, you check the
contract. When the contract changes, you update all
consumers. The traceability chain is the enforcement
mechanism.

---

## Vertical Slices: How Spec Structure Shapes Code Quality

In the Working Backwards post, I emphasized a discipline
that Amazon teams follow rigorously:
**[vertical slicing](https://agile.appliedframeworks.com/applied-frameworks-agile-blog/user-stories-making-the-vertical-slice)**.
Both epics and stories must be vertical slices that cut
through all layers of the stack to deliver a complete
feature. "Backend API epic" and "Frontend UI epic" are
horizontal slices. They don't deliver customer value
independently.

This principle applies directly to how you structure
specifications for AI coding agents. The effect on
code quality is measurable and consistent.

### Horizontal Specs Produce Fragmented Code

When specs are organized by technical layer, the coding
agent implements each layer in isolation:

```
specs/
├── backend-api/
│   ├── requirements.md  # API endpoints
│   ├── design.md        # Service architecture
│   └── tasks.md         # Backend tasks
├── frontend-ui/
│   ├── requirements.md  # UI components
│   ├── design.md        # Component architecture
│   └── tasks.md         # Frontend tasks
└── database/
    ├── requirements.md  # Schema requirements
    ├── design.md        # Data models
    └── tasks.md         # Migration tasks
```

The coding agent implements the backend without knowing
what the frontend needs. The frontend spec references
API endpoints that may not match what the backend
actually provides. The database schema satisfies the
backend requirements but doesn't account for the queries
the frontend will generate. Integration bugs are
guaranteed.

This is the equivalent of defining separate APIs for
each microservice without an integration contract. The
services are internally consistent but externally
incompatible.

### Vertical Specs Produce Cohesive Features

When specs are organized as vertical slices, each
feature cuts through every layer:

```
specs/
├── user-reviews/
│   ├── requirements.md  # Full feature: UI + API + data
│   ├── design.md        # End-to-end architecture
│   └── tasks.md         # Tasks that build the full slice
├── report-generation/
│   ├── requirements.md  # Full feature: generation + delivery
│   ├── design.md        # End-to-end architecture
│   └── tasks.md         # Tasks that build the full slice
```

The coding agent sees the complete feature in a single
specification. The API endpoints are designed for the UI
that will consume them. The database schema supports the
queries the feature actually needs. Integration is built
in, not bolted on.

I've seen this pattern dozens of times in my own work.
When I structure specs as vertical slices, the coding
agent produces implementations that integrate cleanly
on the first attempt. When I organize by layer (even
accidentally, by writing the backend spec before
thinking about the frontend), I spend hours debugging
integration issues that shouldn't exist.

A vertical spec gives
the coding agent complete context about how all the
pieces fit together. A horizontal spec gives it
context about one layer in isolation. Coding agents,
like human engineers, produce better work when they
understand the full picture.

---

## MLP: Spec Quality Is About Ambition, Not Just Precision

In the Working Backwards post, I introduced Amazon's
concept of the **Minimum Lovable Product (MLP)**: a step
above MVP. As
[Aha!'s product management guide explains](https://www.aha.io/roadmapping/guide/plans/what-is-a-minimum-lovable-product),
an MLP goes beyond basic functionality to create
something users genuinely love from day one.

> MVPs ship something so stripped down that customers
> don't care. MLPs ship something that makes customers
> say "this is great, and I want more."

This distinction matters for AI-assisted development.
Here's why.

A vaguely specified MVP produces code that barely works.
The acceptance criteria are thin: "user can submit a
review." The coding agent generates a text box, a submit
button, and a database write. Technically correct.
Nobody loves it.

A well-specified MLP produces code that delights. The
acceptance criteria are rich: "user sees a half-star
rating widget with hover previews, review text supports
markdown with live preview, submitted reviews show a
verified purchaser badge, reviews appear after moderator
approval with the average time to approval displayed to
the submitter." The coding agent generates all of this
because you *specified* all of this.

**When AI does the implementation, the cost of ambition
drops.** Specifying five acceptance criteria takes the
same effort as specifying two. But the difference in
output quality is obvious. The rich spec produces a
feature users actually want. The thin spec produces a
feature that checks a box.

This is the insight most teams miss. They think
specification quality is only about precision:
eliminating ambiguity so the coding agent doesn't
generate the wrong thing. That's half the story.
Specification quality is also about *ambition*:
specifying a product that customers actually love, not
one that barely functions.

A well-specified MLP beats a vaguely-specified MVP every
time. Especially when AI is doing the implementation.

The Working Backwards process supports this naturally.
The PRFAQ forces you to articulate a compelling product
vision. The acceptance criteria force you to specify
what "compelling" means in testable terms. The coding
agent implements the vision faithfully. The result is a
product that matches the press release you wrote before
a line of code existed.

---

## The Contrast: Teams That Specify vs. Teams That Don't

I've been building production software with AI coding
agents for 18 months. The pattern is consistent.

Teams that invest in specification quality get
first-attempt implementations that match intent, rework
rates of 10-20%, and traceability from code back to
customer need. The coding agent produces consistent
output regardless of which IDE wraps it.

Teams that skip specification quality get the opposite.
Implementations that look right but miss requirements.
Rework rates of 50-60%. Hours spent in the
generate-review-fix-reprompt loop I described in
[The Missing Half of AI-Assisted Development](/engineering/ai-assisted%20development/product%20management/2026/02/19/the-missing-half-of-ai-assisted-development/).
And when something breaks six months later, nobody knows
why it was built that way, because the only artifact is
a Slack thread that's long since been archived.

The numbers compound. Consider a team shipping ten
features per quarter:

| Approach | Features Built | Right First Time | Rework Hours |
|----------|---------------|------------------|--------------|
| Vague specs | 10 | 4-5 | 100-150 hrs |
| Structured specs | 10 | 8-9 | 20-40 hrs |

The structured-spec team isn't faster at writing code.
They're faster at *shipping correct code*. The 30
minutes spent on a precise specification saves 3+ hours
of implementation rework. That's a 6:1 return on
spec investment.

As I argued in
[The LLM Complexity Gap](/ai%20infrastructure/engineering/distributed%20systems/2026/01/17/llm-complexity-gap-distributed-systems/),
this effect is even more pronounced for complex systems.
Web UIs have well-established patterns that coding
agents can replicate from training data. Distributed
systems have novel architectural decisions, invisible
failure modes, and coordination requirements that
training data can't cover. The more complex the system,
the more the specification matters.

---

## The API Contract in Practice

Let me make this concrete with an example from the
[Working Backwards post](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/).

The PRFAQ for the automated reporting product promises:
*"Engineering leaders can now produce executive-ready
reports in minutes instead of hours."*

That promise decomposes through the artifact chain:

**Epic:** Automated Weekly Report Generation

**User Story:** "As an engineering leader, I want to
see a summary of completed Jira tickets by team member
in my weekly report, so that I can quickly assess each
person's contributions."

**Acceptance Criteria (from the Working Backwards post):**

1. Report includes a section listing completed tickets
   grouped by assignee.
2. Each ticket shows title, ticket ID, and completion
   date.
3. Tickets sorted by completion date, most recent first.
4. If a team member completed zero tickets, they still
   appear with "No completed tickets."
5. The section header shows total ticket count for the
   period.

Now translate this into the three-document specification
format:

**requirements.md:**

```markdown
### Requirement 3: Jira Ticket Summary by Assignee

**User Story:** As an engineering leader, I want to
see completed Jira tickets grouped by team member, so
that I can assess individual contributions.

#### Acceptance Criteria

1. WHEN the system generates a weekly report,
   THE Report SHALL include a section listing
   Completed_Tickets grouped by Assignee
2. THE Report SHALL display each Completed_Ticket
   with title, Ticket_ID, and Completion_Date
3. THE Report SHALL sort Completed_Tickets by
   Completion_Date, most recent first
4. IF an Assignee has zero Completed_Tickets,
   THE Report SHALL display the Assignee with the
   text "No completed tickets"
5. THE Report section header SHALL display the
   total Completed_Ticket count for the
   Reporting_Period
```

**design.md:**

```markdown
### Correctness Property 3: Ticket Ordering

*For any* set of Completed_Tickets assigned to an
Assignee, the Report SHALL display them in
descending order of Completion_Date.

**Validates:** Requirement 3.3

### Correctness Property 4: Assignee Completeness

*For any* Assignee who is a member of the team
during the Reporting_Period, the Report SHALL
include a section for that Assignee, regardless
of whether they have Completed_Tickets.

**Validates:** Requirement 3.4
```

**tasks.md:**

```markdown
- [ ] 7. Implement ticket grouping by assignee
  - Group Completed_Tickets by Assignee field
  - Sort each group by Completion_Date descending
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 8. Implement empty-state handling
  - Include all team members in report output
  - Display "No completed tickets" for members
    with zero completions
  - _Requirements: 3.4_

- [ ] 9. Implement section header with ticket count
  - Calculate total Completed_Ticket count
  - Display count in section header
  - _Requirements: 3.5_

- [ ] 10. Write property test for ticket ordering
  - **Property 3: Ticket Ordering**
  - Generate random sets of tickets with random
    dates
  - Verify output is always sorted descending
    by Completion_Date
  - _Requirements: 3.3_
```

Every task traces to a requirement. Every requirement
traces to the user story. The user story traces to the
epic. The epic traces to the PRFAQ. The coding agent
implements each task in order, and the property tests
verify correctness.

This is the API contract in action. The product team
defined *what*. The spec format defined *how precisely*.
The coding agent delivered *exactly that*.

---

## From PRFAQ to Code: The Full Traceability Chain

In
[From PRFAQ to Backlog](/engineering/ai-assisted%20development/product%20management/2026/02/21/from-prfaq-to-backlog-working-backwards-as-ai-pipeline/),
I traced the information flow through seven
transformation steps. This post adds the missing piece: *why* the
specification layer in that pipeline must be an API
contract.

The full traceability chain looks like this:

```
Customer Problem → Persona → Use Case → PRFAQ →
  Feature Map → requirements.md → design.md →
  tasks.md → Code → Tests
```

Each arrow is a transformation that narrows ambiguity.
By the time a coding agent receives a task from
tasks.md, the chain has eliminated nearly all room for
interpretation. The agent implements what was specified,
the tests verify what was required, and the traceability
chain connects the result back to a customer need.

As I noted in the PRFAQ to Backlog post, this
traceability serves three purposes:

1. **It prevents feature creep.** If a task doesn't
   trace to a requirement that traces to the PRFAQ,
   it's out of scope.
2. **It enables impact assessment.** When a constraint
   forces a change, you trace which requirements,
   features, and PRFAQ claims are affected.
3. **It detects AI drift.** When a coding agent's output
   diverges from intent, the traceability chain tells
   you exactly where the divergence happened.

Without this chain, specifications are documentation.
With it, they're enforceable contracts.

---

## What This Means for Your Team

If you're using AI coding tools today, here are the
changes that will have the most impact.

**Write acceptance criteria for every story.** This is
the single most impactful change you can make. Five testable
acceptance criteria per story, written before any code
is generated. This alone will cut your rework rate in
half.

**Use EARS format for requirements.** The structured
syntax (WHEN/THE System SHALL/IF/SHALL NOT) forces
precision. It eliminates the ambiguity that causes
AI drift. The
[EARS website](https://alistairmavin.com/ears/) has
the complete reference.

**Structure specs as vertical slices.** One spec per
feature, covering all layers. Don't split by technical
component. Give the coding agent the full picture.

**Specify the MLP, not the MVP.** AI makes ambition
cheap. The cost of specifying a delightful feature is
minutes of additional acceptance criteria. The cost of
shipping a feature nobody loves is a wasted sprint and
eroded customer trust.

**Maintain traceability.** Every task should reference
the requirements it implements. It takes seconds per
task and saves hours of debugging when things go wrong.

These aren't theoretical recommendations. I've applied
every one of them across 18 months of daily AI-assisted
development. The teams that adopt them see measurably
better results from their coding agents, regardless of
which IDE they use.

---

## The Bigger Picture

This post is the third in a series examining how product
discovery and code generation connect in the age of AI
coding agents.

In
[The Missing Half of AI-Assisted Development](/engineering/ai-assisted%20development/product%20management/2026/02/19/the-missing-half-of-ai-assisted-development/),
I argued that the gap between product discovery and code
generation is the real bottleneck. Coding tools are good
enough. The upstream pipeline is what's missing.

In
[From PRFAQ to Backlog](/engineering/ai-assisted%20development/product%20management/2026/02/21/from-prfaq-to-backlog-working-backwards-as-ai-pipeline/),
I traced the information flow through seven
transformation steps, showing how Working Backwards
becomes an AI-accelerated pipeline.

In this post, I've argued that the specification layer
in that pipeline is an API contract. The
three-document format (requirements.md, design.md,
tasks.md) provides the contract structure. EARS-format
requirements, explicit acceptance criteria, and
component-to-requirement traceability make it
machine-readable. Vertical slicing produces better code.
MLP-level ambition produces better products.

The next post will examine what happens when
specifications are imprecise: why AI drift is a product
problem, not an engineering problem, and why the
best fix is almost always upstream.

Specifications are no longer documentation. They're
the API between what you want and what you get.

Define the contract. Let the machines implement it.

---

## References

- Mavin, A. et al.
  [Easy Approach to Requirements Syntax (EARS)](https://alistairmavin.com/ears/).
  The syntax foundation for precise, testable
  requirements.
- Challapally, A. et al. (2025). "The GenAI Divide:
  State of AI in Business 2025." MIT Media Lab.
  Findings on corporate AI pilot failure rates.
- Aha! (2025).
  [What Is a Minimum Lovable Product?](https://www.aha.io/roadmapping/guide/plans/what-is-a-minimum-lovable-product)
  Guide to MLP vs. MVP product strategy.
- Applied Frameworks.
  [User Stories: Making the Vertical Slice](https://agile.appliedframeworks.com/applied-frameworks-agile-blog/user-stories-making-the-vertical-slice).
  Why vertical slicing produces better outcomes.
- Lapsley, D. (2026).
  [The SDLD Specification Format](/engineering/process/best%20practices/ai-assisted%20development/2026/01/12/sdld-specification-format/).
  Canonical reference for the three-document
  specification format.
- Lapsley, D. (2026).
  [Spec-Driven Development Philosophy](/engineering/process/best%20practices/ai-assisted%20development/2026/01/12/spec-driven-development-philosophy/).
  Comprehensive SDLC for AI-assisted engineering.
- Lapsley, D. (2026).
  [The IDE Doesn't Matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/).
  Why specification quality matters more than tool
  selection.
- Lapsley, D. (2026).
  [The LLM Complexity Gap](/ai%20infrastructure/engineering/distributed%20systems/2026/01/17/llm-complexity-gap-distributed-systems/).
  Why no-code works for UIs but not distributed systems.
- Lapsley, D. (2026).
  [Amazon's Working Backwards SDLC for SMBs](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/).
  Practical guide to Working Backwards at smaller scale.
- Lapsley, D. (2026).
  [The Missing Half of AI-Assisted Development](/engineering/ai-assisted%20development/product%20management/2026/02/19/the-missing-half-of-ai-assisted-development/).
  Why the gap between product discovery and code
  generation is the real bottleneck.
- Lapsley, D. (2026).
  [From PRFAQ to Backlog](/engineering/ai-assisted%20development/product%20management/2026/02/21/from-prfaq-to-backlog-working-backwards-as-ai-pipeline/).
  How Working Backwards becomes an AI-accelerated
  pipeline.

---

David Lapsley, Ph.D., is Founder and CEO of a stealth
startup. He has spent 25+ years building infrastructure
platforms at scale. Previously Director of Network
Fabric Controllers at AWS (largest network fabric in
Amazon history) and Director at Cisco (DNA Center
Maglev Platform, $1B run rate). He writes about AI
infrastructure, AI-accelerated SDLC, and the gap
between POC and production.
