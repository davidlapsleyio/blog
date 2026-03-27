---
title: "Issue Tracking Is Dead. Long Live the Spec."
description: "Linear's CEO declared issue tracking dead this week and pivoted the company to agentic AI. He's right - but the implication isn't that tickets go away. It's that the artifact upstream of the ticket becomes the new unit of engineering work."
date: 2026-03-27
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering
  - AI Infrastructure
  - Product Engineering
tags:
  - agentic-ai
  - issue-tracking
  - spec-driven-development
  - engineering-leadership
  - sdlc
  - shipkode
  - product-engineering
---

Linear's CEO made a striking announcement this week: the company is pivoting from issue tracking to agentic AI. The product will evolve to capture issues autonomously and, eventually, debug code. The framing was blunt - *issue tracking is dead*.

He's right. But the conclusion most people will draw from that is wrong.

The end of issue tracking doesn't mean the end of structure. It means the structure moves upstream.

---

## What Issue Tracking Actually Does

Before declaring it dead, it's worth being precise about what a ticket actually is.

A Jira issue, a Linear task, a GitHub issue - at their core, these are containers for *intent*. They say: here is a thing that needs to happen, here is who's responsible, here is what done looks like. They exist because software development involves multiple people, multiple timelines, and more work than any individual can hold in their head.

That coordination function doesn't go away when agents enter the picture. It gets compressed.

When an AI agent can take a ticket from open to closed in minutes rather than days - create a branch, write the code, open the PR, run the tests - the ticket lifecycle collapses. The human handoff points that made the tracker useful (assign → start → review → merge → close) compress into near-zero time. At that point, maintaining a tracker at the old granularity becomes overhead without benefit.

Linear's CEO is responding to this reality. If agents resolve tickets faster than humans can write them, the tracker's coordination function is largely gone.

But coordination hasn't disappeared. It's just moved.

---

## The Bottleneck Moves Up the Stack

Here's what happens when agents handle implementation:

The bottleneck is no longer writing code. It's knowing what to build.

That sounds obvious, but the implications are non-trivial. Every ambiguity in a requirement that a human engineer might have resolved through a Slack thread, a quick question to the PM, or a judgment call during implementation - an agent resolves through training-data patterns. Silently. Without flagging that a decision was made.

This is the same dynamic I described in [cognitive debt]({% post_url 2026-03-26-cognitive-debt-agents-move-faster-than-humans-can-review %}) last week, from a different angle. Agents don't ask clarifying questions by default. They fill ambiguity with plausible defaults. That looks fine in the moment. It compounds into drift, rework, and systems that don't match the product intent over time.

If the ticket is still the primary artifact - a short description of what to build, maybe some acceptance criteria, assigned to an agent - the agent will ship something. It might even pass the tests. But whether it's the *right* thing, built the *right* way, in a manner consistent with where the product is going? That's not in the ticket. It never was.

The issue tracker hid this gap as long as human engineers were filling it with judgment. Agents expose it.

---

## What Has to Exist Before the Ticket

When agents handle implementation, the work that matters happens before the ticket is created.

Specifically:

**Clear product intent.** What is this feature actually for? Who uses it, in what context, with what goal? Not a user story - genuine clarity on the problem being solved. Agents implement what you specify. If the specification is a one-liner in a tracker, you'll get a one-liner's worth of thinking embedded in the implementation.

**Explicit design decisions.** What approach are we taking? What are the constraints - performance, security, backward compatibility? What's explicitly out of scope? These decisions will be made either by a human before generation or by the agent during generation. If the agent makes them, they're invisible.

**Acceptance criteria that capture behavior, not just output.** "User can reset password" is a different specification than "user can reset password via email link, link expires in 24 hours, expired links show a specific error message, rate limiting applies at 3 attempts per hour." The second version gives an agent enough structure to get it right. The first version gives an agent permission to fill in everything you didn't say.

**Traceability from intent to implementation.** When an agent ships a PR, what requirement does it satisfy? Which design decision does each architectural choice reflect? Without this, debugging unexpected behavior six months from now means reverse-engineering decisions that were never documented.

None of this is a ticket. All of it is a spec.

---

## The Spec Becomes the Unit of Work

When agents handle implementation, the engineering team's leverage moves to specification quality.

This is a meaningful shift. In a traditional development process, a senior engineer's value is partly in their ability to write good code quickly. In an agentic process, the code comes fast regardless - the value is in writing specifications precise enough that the code is correct the first time, and structured enough that it can be understood and changed later.

That's a different skill profile. It's closer to product architecture than to individual contributor coding. The engineers who thrive in an agentic-first organization will be the ones who are excellent at:

- Decomposing complex product intent into unambiguous requirements
- Making design decisions explicit before they're implemented
- Structuring work so agents can execute it in reviewable chunks
- Evaluating agent output against stated intent, not just functional correctness

The issue tracker was built around a different unit of work - the individually assigned, human-implemented task. That unit is changing. The spec - the structured artifact that captures what to build and why - is what replaces it.

---

## This Is What ShipKode Is For

I've spent the past year thinking about exactly this problem. Not as an abstract organizational design question, but as the practical question of: what does an engineering team need to operate effectively when agents handle implementation?

The answer we've arrived at at ShipKode is that the gap isn't in the tracker. It's upstream of the tracker - in the translation from customer signal to validated product intent to engineering-ready specification.

Most teams are flying blind on that translation. Customer interviews generate insights that aren't systematically captured. Product intuition drives roadmaps that aren't traceable to evidence. Requirements are written fast to unblock development, without the structure agents need to implement correctly.

ShipKode is a governed agentic control plane for that process - from raw market signals and customer evidence through personas, use cases, PRFAQs, and feature maps to Kiro-format engineering specifications with full traceability. Every requirement traces back to the customer evidence that motivated it. Every design decision is documented before implementation begins.

When the ticket is created - or when the agent picks up the work - the spec already exists. The agent isn't filling ambiguity with guesses. It's implementing a decision that was made, by a human, with evidence.

That's the organization that gets the velocity benefit of agentic development without the cognitive debt that comes from skipping the thinking.

---

## The Org Design Question Nobody Is Asking

Linear's CEO declared issue tracking dead and pivoted to agentic AI. That's a product decision - Linear will adapt or be displaced like every other tool in the developer workflow that agents are disrupting.

But the harder question isn't "what happens to the tracker?" It's "what does the engineering org look like when agents handle implementation?"

My read: the org gets smaller at the implementation layer and much more important at the specification layer. The ratio of engineers who are primarily specifying and reviewing to engineers who are primarily coding shifts dramatically. The skills that matter shift. The artifacts that matter shift.

Teams that recognize this early and restructure accordingly - building the muscles for high-quality specification, establishing traceability from customer intent to code, treating the spec as the primary engineering artifact - will have a significant and compounding advantage over teams that just point agents at their existing backlog and wonder why the output doesn't match what they wanted.

The tracker is dead. Long live the spec.

---

*David Lapsley, Ph.D., is Founder and CEO of ShipKodeAI. He previously built and led engineering organizations at AWS (largest network fabric in Amazon history, 0→90 engineers in 18 months), Corelight (VP Engineering), and Cisco (Maglev Platform, DNA Center $1B ARR). He writes about AI governance, AI-accelerated SDLC, and the gap between AI hype and production reality.*
