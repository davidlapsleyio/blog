---
title: "From PRFAQ to Backlog: How Amazon's Working
  Backwards Process Becomes an AI Pipeline"
description: "Working Backwards isn't just a product
  methodology. It's a specification pipeline where each
  artifact narrows ambiguity and adds precision. Here's
  how each transformation maps to an AI-assisted stage."
date: 2026-02-21
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
header:
  og_image: /assets/images/prfaq-pipeline-og.jpg
categories:
  - Engineering
  - AI-Assisted Development
  - Product Management
tags:
  - working-backwards
  - ai-coding
  - spec-driven-development
  - sdlc
  - prfaq
  - product-discovery
---

In my previous post on
[Amazon's Working Backwards SDLC for SMBs](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/),
I walked through the structured artifact chain
(personas, use cases, PRFAQ, capability maps, epics,
user stories) that connects a customer problem to an
actionable engineering backlog. The post covered every
artifact, every format, every linkage.

What I didn't cover is how each transformation in that
chain maps naturally to an AI-assisted pipeline stage.

In my follow-up post on
[The Missing Half of AI-Assisted Development](/engineering/ai-assisted%20development/product%20management/2026/02/19/the-missing-half-of-ai-assisted-development/),
I argued that the gap between product discovery and code
generation is the real bottleneck in AI-assisted
development. The answer isn't a single "Cursor for
product management" tool. It's a pipeline.

This post traces the information flow from a raw
problem-space description through seven transformation
steps, showing how each stage takes structured input
from the previous stage and produces structured output
for the next. The goal: make the pipeline concrete
enough that you can build it yourself.

---

## The Key Insight

Working Backwards isn't just a product methodology.
It's a **specification pipeline** where each artifact
narrows ambiguity and adds precision.

Consider what each artifact actually does:

| Artifact | What It Does | Ambiguity Removed |
|----------|-------------|-------------------|
| Vision statement | Defines the customer problem | "What problem are we solving?" |
| Personas | Identifies who we're solving it for | "Who is the customer?" |
| Use cases | Describes how they'll interact | "What will they do with it?" |
| PRFAQ | Articulates why it matters | "Why will anyone care?" |
| Feature map | Decomposes into buildable units | "What pieces do we need?" |
| Specifications | Defines exact behavior | "How should each piece work?" |
| Tasks | Orders the implementation | "What do we build first?" |

Each stage takes the output of the previous stage as
input, transforms it, and produces structured output
for the next. The ambiguity narrows at every step.
By the time you reach tasks, there's almost nothing
left for a coding agent to guess about.

This is exactly what makes Working Backwards suitable
for AI acceleration. Each transformation is a
*function*: structured input in, structured output out.
Functions can be automated.

---

## The Traditional Pipeline vs. The AI-Accelerated Pipeline

Amazon's traditional Working Backwards process moves
through eight stages:

```
Idea → Personas → Use Cases → PRFAQ →
  BRD/Capability Map → Epics → User Stories → Backlog
```

The first four stages (customer discovery) are
exceptional. They force teams to articulate *why*
before *how*, ground decisions in real customer needs,
and filter out weak ideas before any code is written.
These stages are preserved intact.

The last four stages (execution planning) were designed
for human engineering teams working in sprints. Epics,
user stories, and backlog items are the right
abstraction for coordinating human teams. They're the
wrong abstraction for AI coding agents.

AI coding agents don't need user stories. They need
**specifications**: precise, structured,
machine-parseable descriptions of *what* to build,
*how* to build it, and *in what order*. But a single
spec can only describe a single feature. A product
requires many specs, and those specs must be sequenced,
grouped, and coordinated.

The AI-accelerated pipeline replaces the four execution
stages with three new ones:

```
Idea → Personas → Use Cases → PRFAQ →
  Feature Map → Specs (per feature) →
  AI-Accelerated Implementation
```

The discovery stages remain human-driven because
understanding customers requires empathy, judgment, and
domain expertise. AI can *assist* (drafting personas
from research data, generating use case variations,
producing PRFAQ drafts) but humans *own* the decisions.

The execution stages are where AI changes everything.

| Traditional Stage | Problem for AI | AI-Accelerated Replacement |
|-------------------|---------------|---------------------------|
| BRD / Capability Map | Monolithic requirements doc; too large for a single agent context | **Feature Map**: decomposes into spec-sized features + **requirements.md** per feature |
| Epics + Tech Design | Epics are scoping tools for humans; AI needs architecture decisions and interfaces | **design.md** per feature: components, correctness properties, error handling |
| User Stories + Backlog | Story format is a communication tool for humans; AI needs ordered, dependency-aware tasks | **tasks.md** per feature: hierarchical tasks with requirement traceability |

---

## Seven Transformation Steps

Let me trace the information flow through the full
pipeline, step by step. Each transformation follows the
same internal pattern: take structured input from the
previous stage, transform it, validate the output, pass
it forward.

### Step 1: Problem Space → Personas

**Input:** A natural-language problem-space description.
"Build a tool that helps developers automate code
reviews."

**Transformation:** The LLM generates 2-5 persona
profiles from the problem description. Each persona
includes name, role, pain points, goals, environment,
daily workflow, tools, success metrics, and frustration
quotes.

**Output:** One Markdown file per persona.

**What narrows:** "Who is the customer?" becomes
concrete. Instead of "developers," you have "Solo Dev
Sam, 5 years experience, building production software
solo, spending 40-60% of coding time in manual
prompt-review-fix loops."

**Human gate:** Review the personas. Do they represent
real user segments? Are any missing? Delete or revise
before proceeding.

### Step 2: Personas → Use Cases

**Input:** The rendered persona Markdown from Step 1,
plus optional steering guidance.

**Transformation:** The LLM generates 3-5 structured
use cases from the personas. Each use case includes a
title, user story statement ("As a... I want... so
that..."), actors, preconditions, main flow (ordered
steps), postconditions, and acceptance criteria.

**Output:** One Markdown file per use case.

**What narrows:** "What will they do with it?" becomes
a concrete sequence of interactions. The personas'
pain points and goals are translated into specific
scenarios with measurable outcomes.

**Human gate:** Do these use cases capture the most
important interactions? Are the acceptance criteria
testable?

### Step 3: Personas + Use Cases → PRFAQ

**Input:** Concatenated persona and use case Markdown,
plus optional steering guidance.

**Transformation:** The LLM synthesizes an
Amazon-style Press Release / FAQ document. The press
release captures the product vision in customer-facing
language. The customer FAQ addresses external questions.
The internal FAQ addresses business viability,
technical risks, and operational concerns.

**Output:** A single PRFAQ Markdown document.

**What narrows:** "Why will anyone care?" gets answered.
The PRFAQ forces the product vision into plain language.
If the press release doesn't make someone say "I want
that," the product isn't ready.

**Human gate:** This is the most important gate.
At Amazon, PRFAQs go through 10+ drafts with
leadership review. At a startup, the founder or CTO
reads it and asks: "Is the 'So what?' undeniable?" If
not, iterate. Many ideas should die here, cheaply,
before a dollar is spent on engineering.

### Step 4: PRFAQ + Personas + Use Cases → Feature Map

**Input:** The PRFAQ, personas, use cases, and
technology stack description.

**Transformation:** The LLM decomposes the product into
two categories of features:

- **Foundation features** (IDs: F0a, F0b, ...):
  shared infrastructure that enables product features.
  Authentication, data layer, API framework,
  observability.
- **Product features** (IDs: F1, F2, ...):
  user-facing capabilities that deliver observable
  value. Each traces back to specific PRFAQ sections,
  use cases, and personas.

The features are organized into milestones with
delivery goals and exit criteria. A dependency graph
(a directed acyclic graph) maps which features
depend on which others. Foundation features sit at
the root. Product features depend on them.

**Output:** A Feature Map Markdown document with the
full decomposition, dependency graph (rendered as a
Mermaid diagram), and milestone plan.

**What narrows:** "What pieces do we need?" becomes a
concrete decomposition. The product is no longer a
monolith. It's a set of independently specifiable
features with explicit dependencies.

**Human gate:** Review the decomposition. Are the
feature boundaries right? Are dependencies accurate?
Is the milestone sequencing realistic?

> This is the boundary between Discovery and Delivery.
> Everything before this point is product thinking.
> Everything after is engineering specification.

### Steps 5-7: Feature Map → Specs (Per Feature)

This is where the pipeline gets interesting. Each
feature in the Feature Map gets a complete
three-document specification generated in sequence.
Features are processed in **topological order**
(foundations first, then the product features that
depend on them), ensuring that dependency features are
fully specified before the features that need them.

#### Step 5: Feature Context → Requirements

**Input:** The specific feature being specified, the
full Feature Map for context, all upstream Discovery
artifacts (PRFAQ, personas, use cases), and the
previously generated specs for dependency features.

**Transformation:** The LLM generates a requirements
document with numbered requirements. Each requirement
includes a title, user story, and EARS-style
acceptance criteria (using WHEN/THE/IF/THEN/SHALL
keywords for machine-parseable precision).

**Output:** `requirements.md` for this feature.

**What narrows:** "What should this feature do?" becomes
a set of testable conditions. Every requirement is
specific enough that you can write a test for it.

#### Step 6: Requirements → Design

**Input:** Feature context, requirements from Step 5,
and dependency specs.

**Transformation:** The LLM generates an architecture
document with components (name, description, layer,
file path, code snippet), design decisions (with
options considered and rationale), correctness
properties for property-based testing, and error
scenarios.

**Output:** `design.md` for this feature.

**What narrows:** "How should it work?" becomes an
architecture with explicit interface contracts. The
coding agent now knows which components to create,
which patterns to follow, and which properties the
implementation must satisfy.

#### Step 7: Requirements + Design → Tasks

**Input:** Feature context, requirements, design
components, correctness properties, and dependency
specs.

**Transformation:** The LLM generates a hierarchical
task list with implementation steps. Each task has a
description, requirement references (tracing back to
specific acceptance criteria), and optional property
test references.

**Output:** `tasks.md` for this feature.

**What narrows:** "What do we build first?" becomes an
ordered implementation plan where every task traces
back to a requirement, and every requirement traces
back to the PRFAQ.

---

## The Traceability Chain

This is the payoff. When the pipeline completes, every
line of code traces back through a formal artifact
chain:

```
Code → Task → Requirement → Feature →
  PRFAQ → Use Case → Persona → Customer Problem
```

Ask "why does this function exist?" and you can trace
the answer all the way back to a specific customer
pain point identified in a specific persona.

This traceability serves three purposes that I covered
in my
[Working Backwards post](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/):

1. **It prevents feature creep.** If a proposed task
   doesn't trace back to a requirement that traces
   back to the PRFAQ, it's out of scope.
2. **It enables impact assessment.** When a constraint
   forces a change, you can trace which requirements,
   features, and PRFAQ claims are affected.
3. **It detects drift.** When a coding agent's output
   diverges from intent, the traceability chain tells
   you exactly where the divergence happened.

That third point is new, and it connects to the concept
of **AI drift** I introduced in my post on
[Spec-Driven Development](/engineering/process/best%20practices/ai-assisted%20development/2026/01/11/spec-driven-development-with-llms/).
When every task references specific requirements and
every requirement references specific PRFAQ claims,
drift becomes detectable at every level, not just at
code review.

---

## What Makes This a Pipeline (Not a Methodology)

Here's the distinction that matters. Working Backwards
as Amazon practices it is a *methodology*: a set of
principles and document formats that humans follow.
What I'm describing is a *pipeline*: a system where
each stage is a formalized transformation with
structured input, structured output, and validation
at each boundary.

The difference matters because pipelines can be
automated. Methodologies can't.

Each step in the pipeline follows the same internal
pattern:

1. **Render** a prompt template with upstream artifact
   context
2. **Call** the LLM with the rendered prompt
3. **Parse** the response into structured data
4. **Validate** against a schema (are all required
   fields present? do cross-references resolve?)
5. **Render** into a Markdown document
6. **Persist** for downstream consumption

The LLM does the creative work: synthesizing personas
from problem descriptions, decomposing products into
features, generating architecture decisions. But the
pipeline constrains and validates that work. The LLM
proposes. The pipeline validates. Humans approve at
gates.

This is the architecture that Andrew Miklas's "Cursor
for product management" thesis points toward, whether
he framed it this way or not. The opportunity isn't a
single tool that "does product management." It's a
pipeline where AI accelerates each transformation
while humans retain authority at the boundaries.

---

## The Context Window Challenge

There's a real engineering problem lurking in this
pipeline: context growth.

Steps 1-4 have bounded context. Each step takes a
small set of upstream artifacts with predictable sizes.
The problem begins at Step 5 and compounds through
Steps 6-7.

When generating specs for the 20th feature, the prompt
needs to include the full Feature Map, all upstream
Discovery artifacts (PRFAQ, personas, use cases), and
the previously generated specs for all dependency
features. That context grows with every feature.

The math is straightforward. Each feature spec is
3,000-5,000 characters. For a 20-feature product, the
final feature's prompt can push past 100KB, well
beyond typical LLM context budgets.

The solution is **progressive summarization**: steering
documents that compress upstream artifacts while
preserving critical interface contracts. Instead of
passing the full PRFAQ (5,000-15,000 characters) to
every feature's spec generation, you generate a compact
ProductVision summary (500-1,000 characters) that
captures the essential product context. Instead of
passing full dependency specs, you pass a Dependency
Summary with just the interface contracts.

I'll cover context management in depth in a future
post. For now, the key takeaway: this pipeline works at
small scale (5-10 features) without any summarization.
At larger scale (15+ features), you need a context
strategy.

---

## Where Humans Stay in the Loop

I want to be precise about what's automated and what
isn't. The pipeline has **four human approval gates**:

1. **After personas** (Step 1): Do these represent
   real user segments?
2. **After PRFAQ** (Step 3): Is the "So what?"
   undeniable? This is the highest-stakes gate. Ideas
   that don't survive the PRFAQ should die here.
3. **After Feature Map** (Step 4): Is the
   decomposition right? Are dependencies accurate?
4. **After each spec** (Steps 5-7): Are the
   requirements correct? Is the architecture sound?
   Are the tasks properly sequenced?

Between gates, AI does the heavy lifting:
transforming problem descriptions into personas,
extracting use cases from personas, synthesizing
PRFAQs, decomposing features, generating specs. But
the pipeline never advances past a gate without human
approval.

This is the structural answer to the trust problem.
Teams don't need to trust AI with the whole decision.
They trust it with the *transformation* between
decisions, and make the decisions themselves at the
gates.

---

## Practical Implications

If you're leading a team that's already using AI
coding tools, here's what this pipeline means for
you.

**You already have the downstream half.** Cursor,
Claude Code, GitHub Copilot. These tools implement
specs into code. They're the right side of the
pipeline.

**The upstream half is where you're leaking value.**
How do features get defined at your company? If the
answer involves Google Docs, Slack threads, and
educated guessing, you have a specification gap. Every
hour you invest in structuring your product discovery
process pays back in reduced rework downstream.

**Start with the PRFAQ.** If you do nothing else from
this post, write a PRFAQ for your next major feature
before you start coding. The Working Backwards process
I described in my
[previous post](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/)
walks through the format in detail.

**Then formalize the connection.** Take the PRFAQ's
claims and decompose them into features. Take each
feature and write a requirements document with
testable acceptance criteria. Take the requirements
and generate a design document. Take the design and
generate tasks. Feed those tasks to your coding agent.

You can do this manually. Many teams should start
there. The pipeline I've described is the automated
version of a process that works just as well when
humans do each step by hand. The automation just makes
it faster.

**The output format matters more than the tool.** I've
argued this before in
[The IDE Doesn't Matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/),
and it applies here too. Whether you use a purpose-built tool
or your own scripts, the critical thing is
the three-document specification format
(requirements.md, design.md, tasks.md) and the
traceability chain that connects each document back to
customer evidence.

---

## The Bigger Picture

This post is the second in a series examining how
product discovery and code generation connect (or fail
to connect) in the age of AI coding agents.

In
[The Missing Half of AI-Assisted Development](/engineering/ai-assisted%20development/product%20management/2026/02/19/the-missing-half-of-ai-assisted-development/),
I argued that the gap between product discovery and
code generation is the real bottleneck. The coding
tools are good enough. The upstream pipeline is what's
missing.

In this post, I've shown what that upstream pipeline
looks like: seven transformation steps, four human
gates, full traceability from code back to customer
evidence. Amazon's Working Backwards process provides
the discovery framework. The three-document
specification format provides the bridge to code
generation.

The next post in the series will examine what happens
at that bridge: why specifications need to function as
machine-readable contracts, not human-readable
documents, and why the teams that invest in
specification quality see dramatically better results
from their coding agents.

Every stage narrows ambiguity. Every artifact feeds the
next. Humans decide at the boundaries. AI accelerates
the transformations between them.

Start with the customer. Work backwards. Specify
precisely. Then let the machines build.

---

## References

- Bryar, C. & Carr, B.
  [*Working Backwards: Insights, Stories, and Secrets
  from Inside Amazon*](https://workingbackwards.com/).
  The definitive book on Amazon's product development
  process.
- Challapally, A. et al. (2025). "The GenAI Divide:
  State of AI in Business 2025." MIT Media Lab.
- Lapsley, D. (2026).
  [Amazon's Working Backwards SDLC for SMBs](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/).
  Step-by-step guide to adopting Working Backwards at
  smaller scale.
- Lapsley, D. (2026).
  [The Missing Half of AI-Assisted Development](/engineering/ai-assisted%20development/product%20management/2026/02/19/the-missing-half-of-ai-assisted-development/).
  Why the gap between product discovery and code
  generation is the real bottleneck.
- Lapsley, D. (2026).
  [Spec-Driven LLM Development (SDLD)](/engineering/process/best%20practices/ai-assisted%20development/2026/01/11/spec-driven-development-with-llms/).
  Methodology for production-grade AI-assisted
  development through structured specifications.
- Lapsley, D. (2026).
  [The IDE Doesn't Matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/).
  Philosophy for LLM-powered code generation.
- Lapsley, D. (2026).
  [Introducing KodeOps](/engineering/ai/open%20source/2026/01/19/introducing-kodeops-open-source-sdlc-automation/).
  Open source SDLC automation.

---

David Lapsley, Ph.D., is Founder and CEO of a stealth
startup. He has spent 25+ years building infrastructure
platforms at scale. Previously Director of Network
Fabric Controllers at AWS (largest network fabric in
Amazon history) and Director at Cisco (DNA Center
Maglev Platform, $1B run rate). He writes about AI
infrastructure, AI-accelerated SDLC, and the gap
between POC and production.
