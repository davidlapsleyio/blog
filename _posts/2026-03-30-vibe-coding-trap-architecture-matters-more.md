---
title: "The Vibe Coding Trap: Why Architecture Matters More When AI Writes the Code"
description: "Vibe coding sounds like architecture doesn't matter anymore. The opposite is true. When AI agents write the implementation, your architectural decisions get amplified, not eliminated."
date: 2026-03-30
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering
  - AI Infrastructure
tags:
  - agentic-ai
  - vibe-coding
  - architecture
  - engineering-leadership
  - pdlc
  - ai-agents
  - software-quality
---

A team ported a Go implementation of JSONata from scratch last week. Seven hours. $400 in token spend. They estimate it saves $500,000 a year in engineering costs.

The tool: Claude Code and Codex, alternating roles, iterating toward a complete implementation. The result: production-grade, passing the test suite, shipped.

You'd think the story is about how good AI coding agents have gotten. It is. But the buried lead is more interesting: the existing test suite was the enabling factor. That's what made a 7-hour $400 port possible instead of a 7-month $400K nightmare.

No tests? No vibe port. The agents would have produced something that looked plausible, passed superficial review, and quietly misbehaved in production.

This is the vibe coding trap.

## What "Vibe Coding" Actually Means

The term was coined by Andrej Karpathy and spread fast because it named something real. You describe what you want in natural language, iterate conversationally with an AI agent, and working code appears. You're not reading line-by-line. You're not writing functions. You're specifying intent and reviewing output.

Matt Webb put it well in an essay that circulated widely last week: "While I'm vibing, I am looking at lines of code less than ever before, and thinking about architecture more than ever before."

The popular interpretation of vibe coding is that it lowers the bar: now anyone can build software, architecture doesn't matter, senior engineers are less important. The viral take is that it's dangerous because the code you ship is code you don't understand.

Both interpretations miss the more important point.

Vibe coding doesn't eliminate the need for architecture. It changes where architecture lives and amplifies the consequences of having it or not.

## Why Agents Amplify Your Architecture, Good or Bad

When a human engineer implements a feature, they make dozens of micro-decisions along the way. Some are conscious: they choose an algorithm, they pick a data structure, they decide whether to introduce an abstraction. Some are unconscious: they name things consistently with the existing codebase, they handle edge cases the way the surrounding code handles similar cases, they apply patterns they've internalized from code review.

This is slow. It's also self-correcting. A human engineer building in a messy codebase will slow down, feel friction, and either push back ("this is getting hard to reason about") or work around the problems they hit ("I'll just duplicate this logic, the abstraction is too tangled"). The mess becomes legible as a constraint.

An agent doesn't work like this.

An agent builds what the context implies. In a clean, well-structured codebase with clear conventions, good test coverage, and explicit design documentation, an agent generates code that fits. It extends the architecture naturally because the architecture is legible in the artifacts it has access to.

In a tangled codebase with inconsistent conventions, poor test coverage, and implicit design decisions living only in the heads of senior engineers, an agent generates code that fits the tangle. It extends the bad patterns as fluently as it would extend good ones. It ships faster than a human would, which means the mess compounds faster.

The JSONata story is a proof of concept for the upside. The test suite was the structural artifact that made correctness verifiable. The agents could iterate because there was a ground truth to iterate toward. Remove the tests, and you have a 7-hour sprint toward something plausible but unverifiable.

Good architecture accelerates agentic development. Bad architecture accelerates agentic debt accumulation.

## The Three Architecture Artifacts That Actually Matter

When you're evaluating whether your codebase is ready for agentic development, the question isn't "is the code clean?" It's "do the right artifacts exist?"

Agents need three things to produce correct output reliably.

**Verifiable correctness criteria.** Tests, specifically. Not just unit tests: integration tests that exercise real behavior paths, not implementation details. An agent without a test suite is producing output you can only evaluate by reading it, which puts you back in the loop as a full reviewer. An agent with strong test coverage can be directed to "make the tests pass" and trusted to converge on correct behavior. The test suite is the architecture artifact most directly connected to agentic velocity.

**Legible conventions.** Agents learn from context. If your codebase has consistent naming conventions, consistent error handling patterns, consistent module structure, an agent will reproduce those conventions. If your codebase has three different error handling patterns across three different parts of the system, the agent will apply whichever one is statistically dominant in the surrounding context. This might not be what you want. Convention documentation, linting rules, and code review standards are architecture artifacts that agents consume directly.

**Explicit design decisions.** Agents fill ambiguity with plausible defaults. Every design decision that lives only in the head of a senior engineer is an ambiguity the agent will fill during generation. When that decision is something like "we always paginate at 100 records because our downstream service has a hard limit" and the agent decides to paginate at 50 for cleaner code, the generated code looks fine in review and fails in production. Architecture decisions need to be written down, ideally close to the code they govern, to be accessible to agents.

None of this is new guidance. This is what good engineering culture looked like before agents existed. Agents make the consequences of skipping it faster and more expensive.

## The Skill Shift Nobody Is Talking About

Four frontier models dropped in the last 23 days. MCP just crossed 97 million installs. Linear's CEO declared issue tracking dead. JetBrains retired their pair programming product and launched an agentic development platform. The ecosystem signal is consistent: agentic development is crossing the production threshold now, not in 2027.

The organizational response most teams are making is "let's give everyone access to Claude Code and Copilot and see what happens." That's a reasonable start. It's not a strategy.

The engineers who will have the most leverage in an agentic-first org are not the ones who type the fastest or know the most obscure language features. They're the ones who are excellent at:

Decomposing complex product intent into unambiguous requirements that an agent can execute correctly the first time. Writing specifications that capture not just what to build but why, what the constraints are, and what's explicitly out of scope. Structuring work into chunks an agent can execute and a reviewer can verify independently. Evaluating agent output against stated intent, not just functional correctness. And, critically, building and maintaining the test suites and convention artifacts that give agents a structure to build within.

This is closer to product architecture than to traditional senior IC work. The title might still say "Staff Engineer." The day looks different.

## What This Means for Engineering Leaders

If you're a CTO or VP Engineering evaluating how to integrate agentic development into your team, the question to start with isn't which tool to adopt. It's: what is the current quality of our architecture artifacts?

Specifically: what is our test coverage, and does it cover behavior or implementation details? Are our conventions documented and enforced? Are our design decisions written down anywhere, or do they live in senior engineer memory? Is our codebase legible to an outside reader (which is what an agent is)?

If the answers are bad, adding agents adds speed to a compounding problem. The ROI story is real but it's conditional. You get the 7-hour $400 JSONata port when the test suite exists. Without it, you get 7 hours of plausible code that might take 7 weeks to debug.

The good news: the work required to make a codebase agent-ready is the same work that makes it human-maintainable. There's no new category of investment here. There's just a new urgency. The teams that have been cutting corners on testing and documentation have been paying a slow tax. With agents in the loop, that tax gets collected faster.

## The Trap

Vibe coding is genuinely powerful. The velocity gains are real, the JSONata story is not an outlier, and the engineering teams running away from this are going to be structurally disadvantaged in 18 months.

The trap is the framing that comes packaged with the term. "Vibe" implies loose, intuitive, structure-optional. Karpathy's original framing was more precise: he said you embrace the vibes and "forget that the code even exists." That's a statement about attention, not about architecture. The structure still has to be there. You just stop reading every line you generate.

When the code exists in a well-structured system with strong test coverage and explicit conventions, forgetting that it exists is fine. You can trust the artifacts. When it doesn't, forgetting that it exists is how you end up with a codebase nobody understands and agents that confidently extend the confusion.

Architecture has always mattered. It just used to be possible to get away with shortcuts because humans slowed down when things got messy. Agents don't slow down. They build into the mess at full speed.

The teams that will win with agentic development are not the ones that move fastest today. They're the ones that built the foundations that let them move fast safely.

---

*David Lapsley, Ph.D., is Founder and CEO of ShipKodeAI. He previously led engineering at AWS (largest network fabric in Amazon history, 0 to 90 engineers in 18 months), Corelight (VP Engineering), and Cisco (Maglev Platform, DNA Center $1B ARR). He writes about AI governance, AI-accelerated PDLC, and the gap between AI hype and production reality.*
