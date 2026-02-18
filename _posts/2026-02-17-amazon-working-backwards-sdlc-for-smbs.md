---
title: "Amazon's Working Backwards SDLC: A Practical Guide
  for SMB Engineering Teams"
description: "How to adopt Amazon's Working Backwards process
  — from PRFAQ to backlog — without Amazon-scale resources. A
  step-by-step guide for SMB engineers, engineering leaders,
  and product managers."
date: 2026-02-17
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering
  - Leadership
  - Process
tags:
  - sdlc
  - working-backwards
  - amazon
  - product-management
  - engineering-culture
  - prfaq
  - agile
---

Amazon's software development lifecycle is one of the most
effective product development processes ever created. It has
produced AWS, Kindle, Prime, Alexa, and thousands of internal
services that power a trillion-dollar company. The core idea
is deceptively simple: start with the customer and work
backwards to the implementation. As Jeff Bezos put it,
*["We innovate by starting with the customer and working
backwards."](https://www.aboutamazon.com/news/workplace/an-insider-look-at-amazons-culture-and-processes)*

Most people know about the PRFAQ — Amazon's famous press
release document written before a line of code exists. But the
PRFAQ is just one artifact in a structured chain that connects
a customer problem to an actionable engineering backlog. The
full process — personas, use cases, PRFAQ, capability maps,
epics, user stories — is what makes it work. Colin Bryar and
Bill Carr document this process extensively in
[*Working Backwards*](https://workingbackwards.com/), the
definitive book on Amazon's internal practices, drawn from
their combined 27 years at the company.

Here's what most people get wrong: they assume this process
only works at Amazon scale. It doesn't. I've used variants of
this process at AWS, at Cisco, and at startups with fewer than
ten people. The principles scale down. In fact, they're *more*
valuable at smaller companies where you can't afford to build
the wrong thing.

This post walks through Amazon's entire Working Backwards
SDLC — every artifact, every format, every linkage — and
shows how SMB engineering teams can adopt it without the
overhead of a 10,000-person organization.

---

## Why This Matters for SMBs

Large companies can absorb the cost of building the wrong
product. They have the headcount, the runway, and the
institutional tolerance for failed initiatives. You don't.

When you have a 5-person engineering team and 12 months of
runway, every sprint matters. Building the wrong feature for
three months isn't a learning experience — it's an existential
threat. The Working Backwards process exists precisely to
prevent this. It forces clarity before code.

The economics are straightforward:

| Scenario | Cost of Misalignment |
|----------|---------------------|
| 50-person team builds wrong feature for 1 quarter | Expensive, but survivable |
| 5-person team builds wrong feature for 1 quarter | 25% of your runway, potentially fatal |

I've seen this pattern play out dozens of times. A team
burns three months building something nobody asked for,
then wonders why they're behind. The root cause is almost
never technical — it's a planning failure. This is the same
dynamic behind the stat that **87% of data science projects
never reach production** (VentureBeat, 2019). The models
work. The algorithms are fine. Projects fail because nobody
planned for what comes after the POC. Working Backwards
attacks that exact problem — forcing you to plan for the
end state before you write a single line of code.

Amazon invented Working Backwards because even at their
scale, they couldn't afford to waste engineering resources
on products customers didn't want. At your scale, the
stakes are higher.

---

## The Full Process: Seven Artifacts, One Chain

The Working Backwards SDLC produces seven artifacts in
sequence. Each artifact feeds the next. Skip one, and the
chain breaks.

```
Idea → Personas → Use Cases → PRFAQ →
  Capability Map → Epics → User Stories
```

This isn't bureaucracy. It's a decision-making funnel that
kills bad ideas early and gives good ideas the clarity they
need to ship. Let me walk through each step.

---

## Step 1: Start with the Customer Problem

Every project begins with a clearly identified customer
problem. Not a technology. Not a feature request. Not
"we should build X because our competitor has it."
A customer problem.

This is the most important discipline in the entire process,
and it's rooted in
[Amazon's first Leadership Principle: Customer Obsession](https://www.amazon.jobs/content/en/our-workplace/leadership-principles)
— *"Leaders start with the customer and work backwards."*
Teams naturally gravitate toward solutions — "let's build
a recommendation engine" or "we need a mobile app." Working
Backwards forces you to articulate the problem first.

AWS's own
[prescriptive guidance on product strategy](https://docs.aws.amazon.com/prescriptive-guidance/latest/strategy-product-development/start-with-why.html)
frames this as "Start with Why" — begin by answering why
the product should exist and how it contributes to business
outcomes before defining what to build.

The questions that matter at this stage:

- **Why should this product be built?** Not "what" — "why."
- **What customer outcome would it achieve?** Be specific.
  "Make customers happier" isn't an outcome. As Bezos wrote
  in his
  [2016 letter to shareholders](https://www.aboutamazon.com/news/company-news/2016-letter-to-shareholders),
  customers are *"always beautifully, wonderfully
  dissatisfied, even when they report being happy"* — your
  job is to find the specific dissatisfaction worth solving.
- **What does success look like?** Define it in measurable
  terms.

The output is a **product vision statement** — a concise
articulation of the customer problem and the desired
outcome. This becomes the north star for everything that
follows.

**Example:** A B2B SaaS team observes that customers spend
3+ hours per week manually compiling status reports from
Jira, GitHub, and Slack. The vision statement: *"Enable
engineering leaders to generate accurate weekly status
reports in minutes instead of hours, so they can spend time
leading instead of reporting."*

Notice what this doesn't say. It doesn't mention AI,
dashboards, integrations, or any specific technology. It
describes a customer problem and a desired outcome. The
solution comes later.

### For SMB Teams: Keep It Short

At Amazon, this stage might involve multi-week discovery
processes with customer interviews and market research. At
an SMB, you probably already know your customers'
problems — you talk to them every day.

Write the vision statement in one paragraph. Share it with
the team. If everyone can't articulate the customer problem
in one sentence, you're not ready to proceed.

---

## Step 2: Define Your Personas

A **persona** is a fictional but research-grounded profile
of a target user. It puts a human face on "the customer"
and prevents the team from building for an abstract
audience. AWS's product strategy guidance
[describes personas as a tool](https://docs.aws.amazon.com/prescriptive-guidance/latest/strategy-product-development/start-with-why.html)
for understanding customer behavior, goals, and
frustrations — and for mapping the transition from current
state to target state.

Personas answer the question: **"Who exactly are we
building this for, and what does that person need?"**

### Standard Format

Each persona includes:

- **Name and Role:** A memorable name and brief context.
  *"Busy Brenda — Time-strapped working parent"* or
  *"DevOps Dan — Senior engineer managing 15
  microservices."*
- **Demographics and Background:** Age, occupation, tech
  proficiency, environment. Enough to make the persona
  feel real.
- **Goals and Needs:** What the persona is trying to
  accomplish with your product.
- **Frustrations/Pain Points:** The specific challenges
  they face today.
- **Behaviors:** How they work, what tools they use, when
  and how they'd interact with your product.
- **Quote (optional):** A one-liner that captures their
  mindset. *"I need to finish my shopping in minutes,
  not hours."*

The whole thing fits on one page. The goal is empathy —
understanding the user deeply enough to make good decisions
on their behalf. As
[Nielsen Norman Group explains](https://www.nngroup.com/articles/persona/),
personas work because humans connect better with specific
examples than with abstract statistics — referencing
"DevOps Dan" in a design review is more powerful than
"our users."

**Example Persona:**

> *"DevOps Dan, age 38, is a senior platform engineer at a
> 50-person SaaS company. He manages 15 microservices
> across three Kubernetes clusters. He's technically strong
> but drowning in operational toil — alert fatigue,
> deployment issues, and status reporting consume 60% of
> his week. His goal is to spend more time on architecture
> and less time firefighting. His frustration: every tool
> his company adopts adds another dashboard to check and
> another alert channel to monitor."*

### For SMB Teams: Two Personas Are Enough

Amazon might create five or six personas to capture diverse
user segments. You probably need two: your primary user and
your buyer (if they're different people). A developer tool
might have "the engineer who uses it daily" and "the
engineering manager who approves the purchase."

Don't over-invest here. Spend 30 minutes writing each
persona. The value isn't in the document — it's in the
conversation the team has while creating it.

---

## Step 3: Map the Use Cases and Customer Journeys

Use cases describe how a persona interacts with your
product to achieve a specific goal. They bridge the gap
between "who is the customer" (personas) and "what must the
product do" (requirements).

A use case answers: **"What are the primary things this
user will do with our product? What steps do they take,
and what outcome do they expect?"**

### Three Formats That Work

**User Story Narratives:** Short scenarios from the
persona's perspective.

> *"Dan opens the platform dashboard Monday morning. He
> sees a single-pane view of all 15 services — health
> status, deployment history, and active incidents. He
> spots a memory leak in the payments service, clicks
> through to the details, and creates a Jira ticket
> directly from the alert. Total time: 2 minutes instead
> of the 20 minutes it used to take checking three
> different tools."*

**Use Case Briefs:** A structured format for precision.

| Field | Example |
|---|---|
| **Title** | Morning Service Health Check |
| **Actor** | DevOps Dan (platform engineer) |
| **Scenario** | Dan needs to quickly assess the health of all services at the start of his day. |
| **Steps** | Opens dashboard → views service health grid → identifies anomaly → drills into details → creates ticket |
| **Outcome** | All services assessed in under 5 minutes with action items captured. |

**Journey Maps:** Visual flows showing the user's
end-to-end experience. Create two versions:

- **As-Is Map:** How the user accomplishes the goal today,
  with all the friction and pain points.
- **To-Be Map:** The ideal experience with your product.

The gap between these two maps is your product's value
proposition.

### For SMB Teams: Focus on the Top 3

You don't need exhaustive journey maps. Identify the three
most important things your personas will do with your
product. Write a use case brief for each. If those three
use cases are compelling, you have a product worth
building. If they're not, no amount of additional use cases
will save you.

---

## Step 4: Write the PRFAQ

The **PRFAQ** (Press Release / Frequently Asked Questions)
is Amazon's signature Working Backwards artifact. It is the
single most valuable document in the entire process. The
[Working Backwards website](https://workingbackwards.com/concepts/working-backwards-pr-faq-process/)
— maintained by the book's authors — describes the PRFAQ
as the principal tool of the Working Backwards process:
*"a second form of written narrative that starts by
defining the customer experience, then iteratively works
backwards from that point until the team achieves clarity
of thought around what to build."*

The PRFAQ is a fictional press release announcing your
product as if it already launched successfully, followed by
an FAQ that addresses every hard question about the
product. You write it *before any code exists*.

### Why the PRFAQ Works

The PRFAQ forces two things that most product processes
skip:

**It forces clarity.** Writing a press release requires you
to articulate, in plain language, what the product does and
why customers will care. If you can't write a compelling
one-page press release, the product isn't ready to build.
As Amazon puts it: if the press release doesn't answer
*"So what?"* — if it doesn't describe something
meaningfully better than what exists — *then it isn't
worth building.*

**It forces hard questions early.** The FAQ section
requires you to confront business viability, technical
risks, competitive threats, and operational challenges — on
paper, before you've spent a dollar on development. This is
where bad ideas die cheaply. Amazon teams commonly write
10+ drafts of a PRFAQ. Many never get approved. That's the
point. As Bryar and Carr write in an
[excerpt published on About Amazon](https://www.aboutamazon.com/news/workplace/an-insider-look-at-amazons-culture-and-processes):
*"Spending time up front to think through all details… to
determine — without writing code — which products not to
build, preserves resources for highest-impact ideas."*

### The Press Release Format

The press release is one page. Written in journalistic
style — headline, date, body paragraphs, customer quote.
It includes:

- A headline that captures the product's value
- What the product does and why it matters
- The specific customer problem it solves
- A quote from a leader or satisfied customer
- How it works in simple, non-technical terms

**Example Press Release:**

> **"Actualyze Launches Automated Status Reporting,
> Cutting Engineering Leaders' Admin Time by 80%"**
>
> *Tampa, FL — February 2026* — Actualyze today announced
> Automated Status Reporting, a new capability that
> generates weekly, monthly, and quarterly business reviews
> directly from engineering activity data. Engineering
> leaders can now produce executive-ready reports in
> minutes instead of hours.
>
> Engineering teams at growing companies spend an average
> of 3+ hours per week compiling status updates from Jira,
> GitHub, and Slack. This administrative burden falls on
> senior engineers and managers — the people whose time is
> most valuable.
>
> "I used to spend every Friday afternoon pulling data
> from five different tools to write my weekly update,"
> said an early adopter. "Now it's generated
> automatically. I get that time back for actual
> engineering work."
>
> Automated Status Reporting connects to existing project
> management and development tools, analyzes activity
> patterns, and produces structured reports aligned with
> each organization's reporting cadence. No data migration
> required. Setup takes less than 10 minutes.

### The FAQ Format

The FAQ follows the press release and runs up to five
pages. It's organized into sections:

**Customer / External Questions:**

- *What customer problem does this solve?*
- *How does the solution work?*
- *What is the customer experience?*
- *How is this different from what exists today?*

**Business / Strategy Questions:**

- *What's the business model?*
- *Why now? What's changed that makes this the right time?*
- *How will we launch or phase this?*

**Risk & Success Questions:**

- *What are the biggest risks or challenges?*
- *What does success look like? What metrics will we
  track?*

**Internal / Operational Questions:**

- *What changes are required internally to support this?*
- *What's the estimated effort and timeline?*

The language throughout is non-technical and clear. No
jargon. No architecture diagrams. The PRFAQ is a thinking
tool, not a technical document.
[Product School's PRFAQ guide](https://productschool.com/blog/product-fundamentals/prfaq)
emphasizes that the framework forces teams to *"think from
the customer's perspective from day one"* — the document
serves as both a strategic planning tool and a
communication device for securing organizational buy-in.

### For SMB Teams: The PRFAQ Is Your Most Important Document

At Amazon, PRFAQs go through formal leadership review with
VP-level approvals. You don't need that ceremony. But you
absolutely need the document.

Here's what I recommend for SMB teams:

**Write the PRFAQ yourself.** The founder, CTO, or product
lead writes the first draft. Not a committee. One person,
forcing themselves to articulate the vision clearly. Cedric
Chin documented
[nine months of adapting the PR/FAQ to a small team](https://commoncog.com/putting-amazons-pr-faq-to-practice/)
and found the hardest part is emotional — *"writing forces
you to confront uncomfortable truths about your idea's
viability from a customer perspective."* That discomfort
is the value.

**Keep it to 2-3 pages total.** One page for the press
release, one to two pages for the FAQ. You don't need five
pages of FAQ — you need to answer the five hardest
questions about your product.

**Share it with the whole team.** Engineers, designers,
everyone. If they can't understand the PRFAQ, your
customers won't understand the product.

**Iterate until the "So what?" is undeniable.** If a smart
person reads your press release and shrugs, rewrite it.
The press release must make someone say "I want that."

**Skip the PRFAQ for small features.** Amazon
differentiates between major initiatives (which require a
PRFAQ) and incremental improvements (which don't).
[Celine Chalhoub, a product leader at Amazon Music](https://withluna.ai/blog/the-working-backwards-launch-strategy-at-amazon),
describes how Amazon categorizes launches into PRFAQ
launches (major initiatives requiring executive approval)
and non-PRFAQ launches (smaller improvements). If a couple
of engineers can build it in a sprint or two, skip straight
to user stories. Save the PRFAQ for bets that matter — new
products, major features, pivots.

---

## Step 5: Break It Down — Capability Map and Requirements

Once the PRFAQ is approved (or at an SMB, once the team
aligns on it), you need to translate the vision into
specific capabilities and requirements. As
[Ryan Lysne describes in his walkthrough of Amazon's product development process](https://agiledata.io/podcast/no-nonsense-agile-podcast/amazons-product-development-process-with-ryan-lysne/),
this is where the team performs a detailed requirements
breakdown, often producing a Business Requirements Document
that *"outlines key user stories with clear priorities"*
to guide engineering.

A **Capability Map** is a structured outline of what the
product needs to do. Think of it as a hierarchy:

- **High-level capability areas** (major buckets of
  functionality)
- **Specific features or requirements** under each

This often takes the form of a **Business Requirements
Document (BRD)** that includes:

### Overview

A short recap of the product vision, target users, and
objectives — tying back to the PRFAQ.

### Functional Requirements by Capability

Organized by major feature area. Each requirement is
specific and testable.

**Example for "Automated Report Generation":**

- The system shall connect to Jira, GitHub, and Slack
  via API integrations.
- The system shall aggregate activity data by team and
  time period.
- The system shall generate a weekly status report in
  under 60 seconds.
- The system shall allow users to customize report
  templates.
- The system shall deliver reports via email and Slack
  notification.

### Non-Functional Requirements

These are your quality bars. Amazon has extremely high
standards here, and you should too — adjusted for your
context:

- **Performance:** Report generation must complete in
  under 60 seconds for teams up to 50 people.
- **Security:** All API tokens must be encrypted at rest.
  No customer data stored outside the tenant's region.
- **Reliability:** 99.9% uptime during business hours.
- **Scalability:** Support organizations with up to 500
  engineers.

Amazon's internal bar is uncompromising: *"There are some
things that are non-negotiable… when we add an experience
to an existing page, it needs to add literally zero
milliseconds of latency. Security is non-negotiable… a
service must meet certain availability and error rate
benchmarks before launch."*

You won't match Amazon's standards on day one. But
defining your non-negotiables upfront prevents the
"we'll fix it later" drift that kills product quality.
I've watched teams defer performance requirements to
"v2" a dozen times. V2 never comes. Define your bars
now.

### Prioritization

Use MoSCoW or a similar framework:

- **Must-have:** Required for launch. Without these, the
  product doesn't solve the customer problem.
- **Should-have:** Important but not blocking. Ship in
  v1.1.
- **Nice-to-have:** Valuable but deferrable. Backlog for
  later.

Amazon aims for a **Minimum Lovable Product (MLP)** — a
step above MVP. The initial release should delight
customers, not just barely work. This is a critical
distinction. As
[Aha!'s product management guide explains](https://www.aha.io/roadmapping/guide/plans/what-is-a-minimum-lovable-product),
an MLP goes beyond basic functionality to create something
users genuinely love from day one. MVPs often ship
something so stripped down that customers don't care. MLPs
ship something that makes customers say "this is great,
and I want more."

### For SMB Teams: One Page Is Enough

You don't need a 30-page BRD. Write one page that lists:

1. The five to ten capabilities the product must have at
   launch
2. The non-functional requirements that are non-negotiable
3. What's explicitly out of scope for v1

That's it. If your requirements fit on one page, everyone
will read them. If they fill 30 pages, nobody will.

---

## Step 6: Define Epics

An **Epic** is a large unit of work that delivers a
significant piece of customer value. Epics are derived
directly from the capabilities identified in Step 5.

### The Critical Rule: Epics Are Outcome-Based

Amazon emphasizes **outcome-based planning**. Epics are
defined by the result they provide, not the tasks involved.

- **Not an epic:** "Build Database Schema" — that's a
  technical task with no customer-visible outcome.
- **An epic:** "Enable Automated Weekly Reports" —
  outcome-focused, encompasses database, API, and UI work.

This matters because outcome-based epics keep the team
focused on delivering value, not just completing tasks.
When an engineer asks "why am I doing this?", the epic's
outcome provides the answer.

### Epic Format

Each epic includes:

- **Title:** A concise name phrased as a goal.
  *"Automated Weekly Report Generation"*
- **Narrative:** A few sentences describing what and why.
  *"As an engineering leader, I can receive a comprehensive
  weekly status report generated automatically from my
  team's Jira, GitHub, and Slack activity, so that I spend
  minutes reviewing instead of hours compiling."*
- **Acceptance Criteria:** High-level conditions for
  "done."
- **Success Metric:** The key metric this epic moves.
  *"Reduce time spent on status reporting by 80%."*

### Vertical Slicing

Each epic should be a
**[vertical slice](https://agile.appliedframeworks.com/applied-frameworks-agile-blog/user-stories-making-the-vertical-slice)**
— cutting through all layers of the stack to deliver a
complete feature. Don't split epics into "backend epic"
and "frontend epic." A "backend epic" doesn't produce
anything a customer can use. A vertical slice does.

**Example Epics for the Automated Reporting Product:**

1. **Epic 1:** Jira Integration and Activity Aggregation
2. **Epic 2:** Automated Weekly Report Generation
3. **Epic 3:** Report Customization and Templates
4. **Epic 4:** GitHub Integration for Code Activity
5. **Epic 5:** Slack Integration and Report Delivery

Each epic traces back to the PRFAQ. If someone proposes an
epic that doesn't connect to the PRFAQ, that's a feature
creep signal.

### For SMB Teams: 3-5 Epics for v1

Keep it tight. If your v1 has more than five epics, you're
probably trying to do too much. Identify the three epics
that deliver the core value proposition — the ones that
make the press release true — and ship those first.

Amazon's
[two-pizza teams](https://aws.amazon.com/executive-insights/content/amazon-two-pizza-team/)
(6-10 people) typically deliver an epic in a few weeks to a
couple of months. These are cross-functional teams that own
features end-to-end — as
[Martin Fowler describes](https://martinfowler.com/bliki/TwoPizzaTeam.html),
they *"possess all necessary capabilities to deliver
valuable software with minimal handoffs"* and operate under
a "you build it, you run it" model. Scale that to your team
size. If you have three engineers, an epic should be
something they can deliver in two to four weeks.

---

## Step 7: Write User Stories

**User Stories** are the smallest units of work in your
backlog. Each story captures a single feature or
interaction from the user's perspective.

### The Format

Amazon uses the classic format:

> **"As a \<user type\>, I want \<some ability\> so that
> \<some benefit\>."**

Every story includes **Acceptance Criteria** — the specific
conditions that define when the story is done.

### Example

**Story:** *"As an engineering leader, I want to see a
summary of completed Jira tickets by team member in my
weekly report, so that I can quickly assess each person's
contributions."*

**Acceptance Criteria:**

- Report includes a section listing completed tickets
  grouped by assignee.
- Each ticket shows title, ticket ID, and completion date.
- Tickets are sorted by completion date, most recent
  first.
- If a team member completed zero tickets, they still
  appear with "No completed tickets."
- The section header shows total ticket count for the
  period.

Notice the specificity. Every criterion is testable.
There's no ambiguity about what "done" means.

### Breaking Down an Epic into Stories

Under the epic "Automated Weekly Report Generation":

1. **Story 1:** *"As an engineering leader, I want the
   system to automatically aggregate Jira activity for the
   past week, so that I don't have to pull data
   manually."*
   - Acceptance: System connects to Jira API, pulls
     activity for configured date range, handles
     pagination.

2. **Story 2:** *"As an engineering leader, I want the
   weekly report to include ticket completion metrics by
   team member, so that I can see individual
   contributions."*
   - Acceptance: Report shows tickets completed per person
     with details.

3. **Story 3:** *"As an engineering leader, I want to
   receive the weekly report via email every Monday at
   8 AM, so that it's ready when I start my week."*
   - Acceptance: Report is generated and emailed on
     schedule. Delivery is configurable.

4. **Story 4:** *"As an engineering leader, I want to
   preview a report before it's sent to stakeholders, so
   that I can verify accuracy."*
   - Acceptance: Preview mode generates report without
     sending. Edit capability before sending.

5. **Story 5:** *"As a product manager, I want to track
   how often reports are generated and opened, so that I
   can measure adoption."*
   - Acceptance: Analytics events logged for generation
     and email opens.

### Vertical Slices in Stories

Each story implies **all the work required** — UI, API,
database, tests — to deliver that user-facing result. Don't
split a story into "frontend: add button" and "backend:
process data." Those are horizontal slices that deliver
nothing usable on their own.

### The INVEST Criteria

Good stories follow
**[INVEST](https://agilealliance.org/glossary/invest/)**
— a set of criteria
[first articulated by Bill Wake](https://agileforall.com/new-to-agile-invest-in-good-user-stories/)
to assess the quality of a user story:

- **Independent:** Can be developed and delivered
  separately.
- **Negotiable:** Details can be discussed and refined.
- **Valuable:** Delivers something the user cares about.
- **Estimable:** The team can reasonably estimate the
  effort.
- **Small:** Completable in one sprint (typically 1-5
  days of work).
- **Testable:** Acceptance criteria are specific and
  verifiable.

### For SMB Teams: The Product Manager Writes Stories, Engineers Refine Them

At Amazon, the Product Manager drafts stories and the team
refines them during backlog grooming. At an SMB, the
"product manager" might be the founder, CTO, or a senior
engineer wearing a product hat. That's fine. What matters
is that someone writes the stories with acceptance criteria
*before* the engineer starts coding.

The refinement conversation is where the value is.
Engineers ask: "What happens if the Jira API is down?"
"What if a team member was added mid-week?" "What's the
maximum report size?" These edge cases, surfaced before
coding begins, prevent rework later.

---

## Traceability: The Chain That Holds It All Together

The most powerful aspect of the Working Backwards process
isn't any single artifact — it's the **traceability**
between them.

Every user story traces back to an epic. Every epic traces
back to a capability. Every capability traces back to the
PRFAQ. Every PRFAQ traces back to a customer problem
identified through personas and use cases.

This means anyone on the team can answer
**"Why are we building this?"** at any level:

> *"Why are we implementing the 'preview before send'
> feature?"*
>
> **Trace:** That story is part of the Automated Weekly
> Report epic → The epic addresses the PRFAQ's claim that
> reports are "accurate and trustworthy" → The FAQ
> acknowledged that auto-generated reports might contain
> errors → The persona (DevOps Dan) expressed concern
> about sending inaccurate data to his VP.

This traceability serves three purposes:

**It prevents feature creep.** If a proposed story doesn't
trace back to the PRFAQ, it triggers a discussion. Maybe
it's a great idea — but it's not *this* product's idea.
Put it in the backlog for later.

**It enables impact assessment.** When a technical
constraint forces a change — "we can't get real-time Jira
data, only hourly snapshots" — the team can trace the
impact. Which stories are affected? Which acceptance
criteria need updating? Which PRFAQ claims are at risk?

**It provides accountability.** When a stakeholder asks why
the team is spending two weeks on email delivery
infrastructure, you point to the PRFAQ: "The press release
promises automatic Monday morning delivery. This is the
work that makes that promise real."

### For SMB Teams: A Spreadsheet Is Fine

You don't need a sophisticated requirements management
tool. A simple spreadsheet that maps stories → epics →
PRFAQ sections is enough. Or use labels in your issue
tracker. The mechanism doesn't matter — the discipline of
maintaining the connections does.

---

## Putting It All Together: A Lightweight Implementation

Here's how I recommend SMB teams adopt this process. I've
helped teams implement this at companies ranging from 5
to 200 people, and this timeline is realistic:

### Week 1: Problem and Personas (1-2 days)

- Write a one-paragraph vision statement articulating
  the customer problem.
- Write two personas: your primary user and your buyer.
- Identify three key use cases.

**Output:** One page covering vision, personas, and use
cases.

### Week 1-2: PRFAQ (2-3 days)

- Write a one-page press release.
- Write a one-to-two-page FAQ covering the five hardest
  questions.
- Share with the team. Iterate based on feedback.
- If the "So what?" isn't compelling, stop. Rethink the
  product.

**Output:** Two-to-three-page PRFAQ.

### Week 2: Requirements and Epics (1-2 days)

- List the capabilities required to make the press
  release true.
- Define non-functional requirements (performance,
  security, reliability).
- Group capabilities into 3-5 epics with acceptance
  criteria.

**Output:** One-page capability map. Epic definitions in
your issue tracker.

### Week 2-3: User Stories (2-3 days)

- Break each epic into 3-7 user stories with acceptance
  criteria.
- Prioritize: what ships in sprint 1?
- Refine stories with the engineering team.

**Output:** A prioritized backlog ready for sprint
planning.

### Total Time: 5-10 Working Days

That's one to two weeks from idea to actionable backlog.
Not months. Not quarters. Days.

The key insight: **the process compresses, not eliminates,
the thinking.** You still do all the hard work — defining
the customer problem, articulating the value, specifying
the requirements. You just do it in days instead of weeks
because you're a small team with direct customer knowledge
and fast decision-making.

---

## Common Mistakes and How to Avoid Them

I've watched teams make every one of these mistakes. Here's
how to avoid them.

### Mistake 1: Skipping the PRFAQ for "Obvious" Products

"We already know what to build, we don't need a press
release." This is the most common mistake. You think you
know what to build because you haven't been forced to
articulate it precisely. Write the PRFAQ. If the product is
obvious, it'll take an hour. If it takes longer, the
product wasn't as obvious as you thought.

### Mistake 2: Writing Technical PRFAQs

The PRFAQ is written for customers, not engineers. If it
contains words like "microservices," "Kubernetes," or
"neural network," you're doing it wrong. The press release
should be understandable by the customer who'll use the
product. Technical details belong in the capability map
and design documents.

### Mistake 3: Horizontal Epics and Stories

"Backend API epic" and "Frontend UI epic" are horizontal
slices. They don't deliver customer value independently.
Slice vertically: "User can generate a weekly report"
includes whatever backend, frontend, and database work is
needed to make that happen.

### Mistake 4: Skipping Acceptance Criteria

A user story without acceptance criteria is a wish, not a
requirement. "As a user, I want reports" tells an engineer
nothing. Acceptance criteria define done. Without them,
you'll review the implementation and say "that's not what
I meant" — which wastes everyone's time.

### Mistake 5: Treating the Process as One-and-Done

The PRFAQ is a living document. Revisit it during sprint
reviews. Ask: "Is what we're building still consistent
with the press release?" If requirements change, update
the PRFAQ. If a new constraint surfaces, trace its impact
through the artifact chain.

---

## For Engineering Leaders

If you're leading a team of 3-20 engineers, the Working
Backwards process gives you three things you desperately
need:

**Alignment.** When every engineer can articulate the
customer problem and trace their current work back to the
PRFAQ, you eliminate the "why are we building this?"
conversations that drain momentum.

**Prioritization clarity.** When a stakeholder asks for a
new feature, you evaluate it against the PRFAQ. Does it
serve the customer problem described in the press release?
If yes, prioritize it. If no, it's a separate initiative —
write its own PRFAQ.

**Hiring efficiency.** When you interview candidates, you
can explain the product vision in five minutes using the
press release. Candidates who light up are the ones you
want.

Start with the PRFAQ. If you do nothing else from this
post, write a one-page press release for your current
project. Share it with your team. The conversation it
sparks will be worth more than the document itself.

## For Product Managers

The Working Backwards process is your operating system. It
gives you a structured path from customer insight to
engineering backlog — with clear handoffs and
accountability at each step.

**Own the PRFAQ.** You are the author. Not the engineer,
not the designer, not the CEO. You write the first draft.
You iterate it. You defend it. The PRFAQ is your primary
artifact.

**Own the acceptance criteria.** Engineers implement. You
define done. Every user story needs acceptance criteria
that you've written and the team has reviewed. This is
where product quality lives or dies.

**Use traceability as your shield.** When scope creep
threatens, trace the request back to the PRFAQ. If it
doesn't connect, it's not in scope. This isn't about
saying no — it's about saying "not now, and here's why."

## For Engineers

The Working Backwards process makes your life better, even
if it doesn't feel like it at first.

**Acceptance criteria are your friend.** When a PM hands
you a story with clear acceptance criteria, you know
exactly what to build and exactly when you're done. No
ambiguity. No rework. No "that's not what I meant" at
review time.

**Traceability gives you context.** When you're deep in
implementation and wondering why a requirement exists, the
trace back to the PRFAQ gives you the answer. This context
helps you make better technical decisions — because you
understand the *intent*, not just the *specification*.

**Push back on vague stories.** If a story doesn't have
acceptance criteria, don't start coding. Ask for them. If
a requirement is ambiguous, flag it. The Working Backwards
process only works if everyone maintains the standard.

---

## The Bottom Line

Amazon's Working Backwards SDLC isn't magic. It's
disciplined thinking, applied in sequence, producing
artifacts that build on each other. The process works
because it forces the hardest questions — "What customer
problem are we solving?" and "Why will customers care?" —
to be answered before a line of code is written.

For SMB teams, the process scales down to days instead of
weeks. You don't need 10 drafts of the PRFAQ or VP-level
review boards. You need a one-page press release that
makes someone say "I want that," acceptance criteria that
make "done" unambiguous, and traceability that keeps every
sprint connected to customer value.

The artifacts chain together: personas tell you who you're
building for. Use cases tell you what they'll do. The
PRFAQ tells you why it matters. The capability map tells
you what's needed. Epics organize the work. Stories make
it actionable.

Skip a step, and you're guessing. Follow the chain, and
you're building with clarity.

Start with the press release. If you can't write a
compelling one-page announcement of your product, you're
not ready to build it. If you can, you have the foundation
for everything that follows.

---

## Join the Conversation

I'd love to hear how your team handles product planning.
Have you tried Working Backwards or a similar process?
What worked? What didn't?

- Share your experience in the comments below
- Find me on Twitter/X:
  [@actualaboratory](https://x.com/actualaboratory)
- Email me directly: david@actualyze.ai

If this post was useful, share it with a fellow
engineering leader or product manager who's struggling
with alignment between product vision and engineering
execution. The Working Backwards process won't solve
every problem — but it will make sure you're solving the
right ones.

---

## References

### Books

- Bryar, C. & Carr, B.
  [*Working Backwards: Insights, Stories, and Secrets from Inside Amazon*](https://workingbackwards.com/)
  — The definitive book on Amazon's product development
  process, written by two executives with 27 combined
  years at Amazon. Covers the PRFAQ methodology, narrative
  culture, and Leadership Principles in depth.

### Amazon and AWS Official Resources

- [Amazon Leadership Principles](https://www.amazon.jobs/content/en/our-workplace/leadership-principles)
  — Amazon's official 16 Leadership Principles, starting
  with Customer Obsession. The foundation of the Working
  Backwards culture.
- [An Insider Look at Amazon's Culture and Processes](https://www.aboutamazon.com/news/workplace/an-insider-look-at-amazons-culture-and-processes)
  — Excerpt from *Working Backwards* published on About
  Amazon, detailing how the PR/FAQ process works and why
  most PRFAQs never make it to development.
- [AWS Prescriptive Guidance: Start with Why](https://docs.aws.amazon.com/prescriptive-guidance/latest/strategy-product-development/start-with-why.html)
  — AWS's public guidance on using personas, journey maps,
  and PR/FAQ to craft a product vision.
- [AWS Prescriptive Guidance: FAQ](https://docs.aws.amazon.com/prescriptive-guidance/latest/strategy-product-development/faq.html)
  — Companion FAQ covering how the product strategy
  supports agile development, epics, and user stories.
- [Amazon's Two-Pizza Teams](https://aws.amazon.com/executive-insights/content/amazon-two-pizza-team/)
  — AWS Executive Insights article on how Amazon structures
  small, autonomous teams for speed and ownership.
- [Two-Pizza Teams: Accountability and Empowerment](https://aws.amazon.com/blogs/enterprise-strategy/two-pizza-teams-are-just-the-start-accountability-and-empowerment-are-key-to-high-performing-agile-organizations-part-2/)
  — AWS Enterprise Strategy blog on scaling the two-pizza
  team model.

### PRFAQ Process Guides

- [The Working Backwards PR/FAQ Process](https://workingbackwards.com/concepts/working-backwards-pr-faq-process/)
  — Detailed guide from the *Working Backwards* authors on
  the PR/FAQ structure, review process, and common
  pitfalls.
- [Working Backwards PR/FAQ Instructions and Template](https://workingbackwards.com/resources/working-backwards-pr-faq/)
  — Practical template and writing instructions from
  workingbackwards.com.
- [The Working Backwards Launch Strategy at Amazon](https://withluna.ai/blog/the-working-backwards-launch-strategy-at-amazon)
  — Celine Chalhoub (Amazon Music product leader) walks
  through the 10-step Working Backwards launch process,
  including PRFAQ vs non-PRFAQ launches.
- [PRFAQ: Amazon's Innovation Blueprint](https://productschool.com/blog/product-fundamentals/prfaq)
  — Product School's comprehensive guide with templates
  and a worked example.
- [Working Backwards: The Amazon PR/FAQ for Product Innovation](https://productstrategy.co/working-backwards-the-amazon-prfaq-for-product-innovation/)
  — Overview of the PR/FAQ framework with real examples
  and downloadable templates.

### Agile Practices

- [Amazon's Product Development Process with Ryan Lysne](https://agiledata.io/podcast/no-nonsense-agile-podcast/amazons-product-development-process-with-ryan-lysne/)
  — No Nonsense Agile Podcast episode with detailed
  walkthrough of how Amazon teams define epics and stories
  from the PRFAQ.
- [User Stories: Making the Vertical Slice](https://agile.appliedframeworks.com/applied-frameworks-agile-blog/user-stories-making-the-vertical-slice)
  — Applied Frameworks guide on vertical slicing with nine
  slicing patterns and before/after examples.
- [INVEST Criteria for User Stories](https://agilealliance.org/glossary/invest/)
  — Agile Alliance glossary entry on the INVEST criteria
  for assessing user story quality.
- [New to Agile? INVEST in Good User Stories](https://agileforall.com/new-to-agile-invest-in-good-user-stories/)
  — Agile for All's practical guide to writing stories
  that meet the INVEST criteria.
- [Two-Pizza Team](https://martinfowler.com/bliki/TwoPizzaTeam.html)
  — Martin Fowler's explanation of the two-pizza team
  concept, its origins, and how it relates to team
  autonomy and ownership.

### Product Strategy and UX

- [Minimum Lovable Product (MLP): Why PMs Should Embrace It](https://www.aha.io/roadmapping/guide/plans/what-is-a-minimum-lovable-product)
  — Aha! guide on why MLPs outperform MVPs for product
  launches.
- [Putting Amazon's PR/FAQ to Practice](https://commoncog.com/putting-amazons-pr-faq-to-practice/)
  — Cedric Chin documents nine months of adapting the
  PR/FAQ process to a small team, with a real worked
  example. Especially relevant for SMBs.
- [Personas: A Simple Introduction](https://www.nngroup.com/articles/persona/)
  — Nielsen Norman Group's authoritative guide to creating
  and using personas in product development.
- [Jeff Bezos's 2016 Letter to Shareholders](https://www.aboutamazon.com/news/company-news/2016-letter-to-shareholders)
  — Bezos on "Day 1" thinking, customer obsession, and
  high-velocity decision-making.
- [How Amazon Defines and Operationalizes a Day 1 Culture](https://aws.amazon.com/executive-insights/content/how-amazon-defines-and-operationalizes-a-day-1-culture/)
  — AWS Executive Insights on the cultural foundations
  behind Working Backwards, including two-pizza teams and
  the one-way/two-way door decision framework.

---

David Lapsley, Ph.D., has spent 25+ years building
infrastructure platforms at scale. Previously Director of
Network Fabric Controllers at AWS (largest network fabric
in Amazon history) and Director at Cisco (DNA Center
Maglev Platform, $1B run rate). He specializes in helping
enterprises navigate the infrastructure challenges that
cause 87% of AI projects to fail.
