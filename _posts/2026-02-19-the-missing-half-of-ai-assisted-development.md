---
title: "The Missing Half of AI-Assisted Development"
description: "AI coding agents make it faster than ever to
  build the wrong thing. The real gap isn't a missing PM
  tool. It's a missing connection between product
  discovery and code generation."
date: 2026-02-19
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering
  - AI-Assisted Development
  - Product Management
tags:
  - ai-coding
  - product-discovery
  - spec-driven-development
  - sdlc
  - working-backwards
---

There's a growing conversation in the industry about
building a "Cursor for product management," an AI-native
system focused on helping teams figure out *what* to build,
not just *how* to build it. The instinct is right. The
problem is real. But the framing understates the
opportunity.

The gap isn't a missing PM tool. It's a missing
*connection* between product discovery and code generation.

I've spent the past 18 months building production software
with AI coding agents every day, and the pattern I see
over and over is this: teams produce working code faster
than ever, but the code doesn't solve the right problem.
The bottleneck has shifted. It's no longer "can we build
this?" It's "should we build this, and have we defined
*this* precisely enough for a machine to implement it
correctly?"

This post examines why that gap exists, why bridging it
requires more than bolting AI onto existing PM workflows,
and why the teams that close this gap will build better
products faster than anyone relying on coding agents
alone.

---

## The Landscape Today: A Chasm with Nice Tools on Each Side

On one side, we have powerful coding agents. Cursor, Claude
Code, GitHub Copilot, Windsurf. These tools can generate
entire features, refactor complex modules, and implement
code faster than most human developers. They're getting
better every month. I use them daily, and the productivity
gains are real.

On the other side, we have scattered AI-assisted research
tools. ChatGPT and Claude for market analysis. Notion AI
for drafting product docs. Various AI-powered survey tools.
They help with individual tasks, but they're disconnected
from each other and from the coding tools downstream.

Between these two sides sits a chasm.

No system connects "here's what customers need" to "here's
the implementation-ready specification that a coding agent
can execute." Product managers write docs in Google Docs or
Notion. Engineers interpret those docs through conversation,
Slack threads, and educated guessing. Then they prompt a
coding agent with something like "add a user review
feature" and hope the output matches what the PM had in
mind.

Imagine a tool where you upload customer interviews and
product usage data, ask "what should we build next?", and
get the outline of a new feature complete with an
explanation grounded in customer feedback. That's a
compelling vision. But it describes the left side of the
chasm. The hard part is the bridge.

---

## Vague Product Thinking Produces Vague Code

In my post on
[Spec-Driven LLM Development (SDLD)](/engineering/process/best%20practices/ai-assisted%20development/2026/01/11/spec-driven-development-with-llms/),
I introduced the concept of **AI drift**, the tendency
for LLM implementations to diverge from requirements
because those requirements were never made explicit. The
core thesis: vague instructions produce vague
implementations.

That thesis was about the interface between specifications
and code. But the same dynamic operates one level upstream.

**Vague product thinking produces vague specifications,
which produce vague code, no matter how good the coding
agent is.**

Consider the chain:

```
Customer Need → Product Vision → Requirements →
  Design → Implementation
```

AI coding agents operate at the rightmost link. They
transform requirements and designs into code. But if the
requirements are ambiguous, if nobody specified which
OAuth scopes are needed, how token refresh should work,
or what the error states look like, the coding agent
fills the gaps with training data patterns. The result
is plausible-looking code that doesn't match anyone's
intent.

Now extend this upstream. If the product vision is
unclear, if nobody articulated which customer segment
this feature serves or what success looks like, then the
requirements will be vague too. Not because the PM is
lazy, but because you can't write precise requirements for
an imprecise idea.

The chain of ambiguity looks like this:

| Stage | Vague Input | What Happens |
|-------|-------------|--------------|
| Product vision | "We need better reporting" | Team builds dashboards nobody asked for |
| Requirements | "Add a user review feature" | No acceptance criteria, dozens of implicit decisions |
| Design | "Follow REST conventions" | LLM picks arbitrary patterns |
| Implementation | "Make it work" | Code that compiles but solves the wrong problem |

Every stage amplifies the ambiguity of the previous one.
AI coding agents don't fix this. They accelerate it.

---

## The 95% Problem, Amplified

Here's the stat that frames everything:
**95% of corporate generative AI pilots fail to deliver
returns** (MIT Media Lab, 2025). Not because the models
fail. Not because the algorithms are wrong. Because
nobody planned for what comes after the POC.

I wrote about this dynamic extensively in my post on
[Amazon's Working Backwards SDLC for SMBs](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/).
The root cause is almost never technical. It's a planning
failure. Teams build impressive prototypes without
answering the hard questions: Who is this for? What
problem does it solve? What does production look like?
What are the non-negotiable quality bars?

AI coding agents amplify this dynamic in a specific and
dangerous way: **they make it faster than ever to build
the wrong thing.**

Before AI coding tools, building the wrong feature took
weeks or months. The slow pace of implementation provided
a natural feedback loop. Engineers asked clarifying
questions. Designers pushed back on unclear requirements.
The friction of manual coding created space for course
correction.

With AI coding agents, a developer can generate a complete
feature in hours. That speed is a superpower when you know
what to build. When you don't, it's a liability. You
produce more code, faster, with less deliberation. The
feedback loop that used to catch misalignment shrinks or
disappears entirely.

As I noted in the Working Backwards post, the economics
are stark for small teams:

| Scenario | Cost of Misalignment |
|----------|---------------------|
| 50-person team builds wrong feature for 1 quarter | Expensive, but survivable |
| 5-person team builds wrong feature for 1 quarter | 25% of runway, potentially fatal |

AI coding agents compress the timeline but not the cost.
A 5-person team using Cursor can build the wrong feature
in two weeks instead of two months. They've saved time
on implementation. They've wasted the same amount of
strategic clarity.

---

## Why Bolting AI onto PM Workflows Won't Work

The natural response to this observation is to build AI
tools for each step of the PM workflow. AI for customer
interviews. AI for competitive analysis. AI for writing
PRDs. AI for prioritization.

This is the same mistake the coding tool ecosystem made
early on, and that I argued against in
[The IDE Doesn't Matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/).
Teams obsess over which tool to use (Cursor vs. Claude
Code vs. Copilot) when the tool is just a shell. What
matters is specification quality, context management,
and build pipeline integration. The IDE is irrelevant
without those foundations.

The same principle applies upstream. AI-powered PM tools
are shells. What matters is the *information architecture*
that connects product discovery to code generation. Without
that architecture, you have a collection of AI-assisted
point solutions that produce artifacts no one reads and
that don't feed into the coding tools downstream.

Here's the specific problem. Today's PM tools produce
artifacts designed for human consumption: Google Docs,
Notion pages, Confluence wikis, slide decks. These formats
work when a human engineer reads the document, asks
clarifying questions, and uses professional judgment to
fill in the gaps. They fail when the downstream consumer
is an AI coding agent that interprets instructions
literally, fills ambiguity with training data patterns,
and diverges from intent in ways that are hard to detect
until code review.

What's needed isn't better PM *tools*. It's a better PM
*output format*, one that machines can consume as
reliably as humans once did.

---

## Specifications as the Bridge

This is where the work I've been doing on
[spec-driven development](/engineering/process/best%20practices/ai-assisted%20development/2026/01/11/spec-driven-development-with-llms/)
becomes relevant.

In SDLD, every feature gets three documents:

- **requirements.md**: The *what* and *why*, with
  testable acceptance criteria in EARS format
- **design.md**: The *how*, with architectural decisions
  and correctness properties
- **tasks.md**: The *when*, with implementation steps
  traced to requirements

These documents function as a contract between product
thinking and code generation. The requirements capture
what the product needs to do. The design captures how it
should work. The tasks give the coding agent explicit,
scoped instructions with traceability back to
requirements.

The Working Backwards process I described in my
[recent post](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/)
provides the upstream half. It produces a structured chain
of artifacts (personas, use cases, PRFAQ, capability
maps, epics, user stories) that progressively narrow
ambiguity from "customer problem" to "actionable backlog
item."

The real opportunity is the connection between these
two halves:

```
Working Backwards Artifacts     Spec-Driven Development
(Product Discovery)             (Code Generation)

Personas ──► Use Cases ──► PRFAQ ──► Capability Map
     ──► Epics ──► Stories ──► requirements.md
     ──► design.md ──► tasks.md ──► Code
```

Each transformation takes structured input from the
previous stage and produces structured output for the
next. Personas inform use cases. Use cases inform the
PRFAQ. The PRFAQ informs the capability map. Capabilities
decompose into epics, epics into stories, stories into
specifications, specifications into code.

When you formalize these transformations, you get
something more powerful than any single "Cursor for
product management" tool could provide. You get an
end-to-end pipeline where AI accelerates every stage
while humans retain decision-making authority at the
boundaries.

---

## Why the Teams That Close This Gap Win

The competitive advantage isn't just speed. It's
*precision at speed*.

A team using AI coding agents alone can build features
fast. But without structured product discovery feeding
into those agents, they're optimizing for velocity on
a random heading. They build fast, course-correct at
code review, rebuild, course-correct again. The net
throughput is lower than it looks because so much of the
output gets reworked or discarded.

A team that connects product discovery to code generation
through structured specifications builds features that
are right the first time. Not because the coding agent
is better, but because the input to the coding agent is
better. The spec eliminates ambiguity before the first
line of code is generated.

The difference compounds over time. Consider a team
shipping ten features per quarter:

| Approach | Features Built | Features Right | Rework Rate |
|----------|---------------|----------------|-------------|
| Coding agents + vague specs | 10 | 4-5 | 50-60% |
| Coding agents + structured specs | 10 | 8-9 | 10-20% |

The second team isn't writing more code. They're writing
more *spec*. The time invested in structured product
discovery (defining personas, writing PRFAQs,
specifying acceptance criteria) pays back at
implementation time through reduced rework, fewer
misalignment conversations, and coding agents that
generate correct implementations on the first attempt.

This is why I've argued consistently that
[the IDE doesn't matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/).
The coding tool is a commodity. Specification quality is
the differentiator. The teams that invest in the upstream
half, the "missing half" of AI-assisted development,
will outperform teams with better coding agents but worse
specifications.

---

## What This Means in Practice

If you're leading an engineering team using AI coding
tools, here's what I'd recommend:

**Audit your specification pipeline.** Look at the last
five features your team shipped. For each one, trace the
path from customer need to code. Where did ambiguity
enter? Where did the coding agent fill gaps that should
have been filled by product decisions? That's where
you're losing time.

**Invest in structured specifications.** The three-document
format (requirements.md, design.md, tasks.md) isn't
overhead. It's the contract that makes AI coding tools
reliable. I've found that 30 minutes spent on a precise
specification saves 3+ hours of implementation rework.

**Connect your product artifacts to your specs.** If your
team writes PRFAQs or PRDs, make sure the acceptance
criteria from those documents flow into your specification
files. If there's a gap between "product doc" and "coding
prompt," ambiguity will fill it.

**Treat the whole pipeline as the product.** The
opportunity isn't a single tool. It's an integrated
workflow from customer insight to deployed code. The
teams that build (or adopt) this workflow will have an
asymmetric advantage over teams that optimize only the
coding step.

---

## The Bigger Picture

The AI-assisted development landscape is lopsided. We've
invested billions
in making it faster to write code, and almost nothing in
making it clearer what code to write. The result is
predictable: teams produce more code, faster, with the
same (or worse) hit rate on building things customers
actually want.

The answer isn't a single "Cursor for product management"
tool. It's a pipeline that connects product discovery to
code generation through structured, machine-readable
specifications. Each stage narrows ambiguity. Each
artifact feeds the next. Humans make decisions at the
boundaries. AI accelerates the transformations between
them.

I've been building toward this vision through
[KodeOps](/engineering/ai/open%20source/2026/01/19/introducing-kodeops-open-source-sdlc-automation/)
and the spec-driven development workflow that powers it.
The discovery pipeline (problem space to personas to use
cases to PRFAQ to feature specs) is operational. The
coding pipeline (specs to implementation to verification)
works reliably. The bridge between them is where the
hardest problems remain.

But the direction is clear. The missing half of
AI-assisted development isn't more coding tools. It's
everything that comes before the code: the customer
discovery, the product thinking, the precise
specifications that turn a vague idea into something a
machine can build correctly. The teams that invest in
this half will build better products. The teams that
don't will build the wrong things faster than ever.

Vague product thinking produces vague specifications.
Vague specifications produce vague code. No coding
agent, no matter how capable, can fix that.

Start with the customer. Work backwards. Specify
precisely. Then let the machines build.

---

## References

- Challapally, A. et al. (2025). "The GenAI Divide:
  State of AI in Business 2025." MIT Media Lab. Findings
  on corporate AI pilot failure rates.
- Lapsley, D. (2026).
  [Spec-Driven LLM Development (SDLD)](/engineering/process/best%20practices/ai-assisted%20development/2026/01/11/spec-driven-development-with-llms/).
  Methodology for production-grade AI-assisted
  development through structured specifications.
- Lapsley, D. (2026).
  [The IDE Doesn't Matter](/engineering/process/best%20practices/ai-assisted%20development/2026/01/15/llm-code-generation-philosophy/).
  Philosophy for LLM-powered code generation focused
  on specification quality over tool selection.
- Lapsley, D. (2026).
  [Introducing KodeOps](/engineering/ai/open%20source/2026/01/19/introducing-kodeops-open-source-sdlc-automation/).
  Open source SDLC automation from concept to structured
  backlog.
- Lapsley, D. (2026).
  [Amazon's Working Backwards SDLC for SMBs](/engineering/leadership/process/2026/02/17/amazon-working-backwards-sdlc-for-smbs/).
  Practical guide to adopting Amazon's product
  development process at smaller scale.

---

David Lapsley, Ph.D., has 25+ years of industry
experience in software development, with decades spent
building infrastructure platforms at scale. Previously
Director of Network Fabric Controllers at AWS (largest
network fabric in Amazon history) and Director at Cisco
(DNA Center Maglev Platform, $1B run rate). He
specializes in helping enterprises navigate the
infrastructure challenges that cause 95% of AI projects
to fail.
