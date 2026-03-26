---
title: "Cognitive Debt: What Happens When Your Agents Move Faster Than You Can Review"
description: "AI agents can generate more code in an hour than a team can thoughtfully review in a day. The result isn't velocity — it's a new kind of technical debt that compounds faster than the old kind. Here's how to structure your way out of it."
date: 2026-03-26
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering
  - AI Infrastructure
  - AI-Assisted Development
tags:
  - agentic-ai
  - cognitive-debt
  - code-review
  - engineering-culture
  - spec-driven-development
  - ai-governance
---

Mario Zechner, the creator of the Pi agent framework, published a frank piece this week that's worth sitting with: agents compound mistakes faster than humans can review them, creating what he calls "cognitive debt" — codebases that evolve beyond the team's ability to reason about them. Simon Willison endorsed the thesis and added his own observation: speed is no longer the bottleneck in software development. Discipline is.

I've been building with AI agents every day for over two years. I agree with the diagnosis. I disagree with the prescription.

The answer isn't to slow down. The answer is to build structure that makes fast review possible.

---

## What Cognitive Debt Actually Is

Technical debt is code that works but costs you later — shortcuts that accumulate interest in the form of maintenance burden, fragility, and the eventual painful refactor.

Cognitive debt is different. It's the gap between what exists in your codebase and what your team can reason about, explain, and confidently change. A team accrues cognitive debt when the codebase evolves faster than their mental model of it does.

Traditional technical debt accumulates at human writing speed. Cognitive debt in an AI-assisted codebase accumulates at agent generation speed.

Here's what that looks like in practice:

An engineer opens a Cursor session at 9am with a reasonable feature request: "implement the user notification system." By noon, the agent has generated 800 lines across 12 files — service classes, database migrations, background jobs, API endpoints, email templates. The code compiles. Tests pass. The engineer reviews it for 45 minutes, approves the PR, and moves on.

Three weeks later, a bug appears in the notification system. The engineer who reviewed the PR is in a different context. The engineer who needs to fix the bug wasn't there for the original session. They open the files. The code is readable, technically correct, but they don't understand the *decisions* embedded in it. Why does the retry logic use exponential backoff to 24 hours? Why is there a separate queue for digest notifications vs. real-time ones? Why does this specific handler exist? There are no comments. There's no design document. The only artifact is the code.

That's cognitive debt. The team owns code they can't confidently reason about.

---

## Why Agents Make This Worse

Human developers accumulate cognitive debt too. But agents accelerate it in specific ways that make the problem qualitatively different.

**Agents generate pattern-complete code, not decision-documented code.** A good human engineer writes a comment when they make a non-obvious choice. An agent writes code that looks reasonable and compiles — without flagging that it made a choice at all. The agent doesn't know what you'll need to understand later. It knows what looks right now.

**Agents don't ask questions by default.** A human engineer who doesn't understand a requirement will ask. An agent fills the ambiguity with training-data patterns. It looks decided, even when the underlying decision was never made.

**Agents compress timelines in ways that skip natural review gates.** When a feature takes two weeks to write, review happens incrementally — architecture discussions, PR comments, pairing sessions. When an agent writes it in two hours, the review happens at the end against a fait accompli. The incremental review that catches design problems early is replaced by a single pass that tends to accept what's there.

**Agents make cross-file, cross-service changes that are hard to review holistically.** A 20-line change touching one function is easy to review. An 800-line change touching 12 files is a different cognitive challenge — even if every individual file is readable. The emergent behavior across the system is what matters, and that's hard to evaluate from a diff.

---

## The Failure Mode Is Invisible Until It Isn't

The insidious thing about cognitive debt is that it doesn't show up in your metrics until something breaks.

Velocity looks great. PRs are shipping fast. The feature backlog is moving. Code review turnaround time is down. Every leading indicator says things are going well.

Then a critical system needs to change. Or a new engineer joins and needs to make sense of what exists. Or an incident happens and the team needs to reason about behavior they didn't write. That's when the cognitive debt comes due — usually at the worst possible moment.

I've watched this happen at companies deploying agentic development workflows. Six months in, velocity has doubled. Engineers feel productive. The team is shipping more than they ever have. Then a senior engineer leaves, or a scaling event exposes unexpected behavior, or an audit requires explaining architectural decisions — and suddenly the team realizes they own a system they don't fully understand.

At that point, the debt doesn't come due slowly. It comes due all at once.

---

## The Fix Isn't to Slow Down

Zechner recommends daily limits on agent-generated code and human-authored architecture decisions. I understand the impulse. But in practice, "slow down the agents" isn't a durable policy. Competitive pressure, deadline pressure, and the productivity delta between teams using agents aggressively and teams using them cautiously will eventually win.

The teams that slow down will ship slower. That's a real cost. The goal should be to capture the velocity benefit without paying the cognitive debt price — and that's achievable, but it requires structure.

The structure that works is pre-generation specification, not post-generation review.

---

## Structure Before Generation, Not Review After

The root cause of cognitive debt is generating code from ambiguous intent. When an engineer prompts "implement the notification system" without specifying the decision surface, the agent fills every ambiguity with training-data defaults. The cognitive debt accumulates in the gap between the intent and the defaults.

The solution is to make the decisions explicit *before* generation happens. Not elaborate bureaucratic specs — lean structured artifacts that capture the decisions that would otherwise be implicit in generated code.

What that looks like in practice:

**Requirements** that specify what the feature must do, not how — including edge cases, constraints, and what's explicitly out of scope. An agent that operates with explicit requirements makes fewer silent decisions.

**Design documents** that capture the architectural choices — why this approach over alternatives, what the data model looks like, how it integrates with existing systems. These don't need to be long. They need to capture the non-obvious decisions so reviewers can evaluate them rather than reverse-engineer them.

**Task breakdowns** that decompose the work into reviewable units. A single 800-line PR is hard to reason about. Five 160-line PRs, each with a clear stated purpose, are reviewable in parallel.

I've written about this pattern in the context of [AI drift]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}) and [specifications as the interface between product and engineering]({% post_url 2026-02-24-specifications-are-the-new-api %}). The connection to cognitive debt is direct: the same ambiguity that causes agents to drift away from requirements also makes the resulting code hard to reason about after the fact. Structured specifications solve both problems simultaneously.

---

## What Good Review Looks Like in an Agentic Codebase

Even with good pre-generation structure, review needs to adapt to what agents produce.

**Review the decisions, not the code.** The question isn't "is this code correct?" (the agent usually gets that right). The question is "are the decisions embedded in this code the decisions we wanted to make?" That's a different review, and it requires the spec to review against.

**Require design artifacts in PRs that touch architecture.** Any PR that introduces a new service, changes a data model, or modifies a system integration should include a brief design note — even three sentences explaining why this approach. This is the minimum viable documentation for reasoning about the system later.

**Use the agent to document its own decisions.** After a generation session, prompt the agent: "Write a brief explanation of the non-obvious decisions you made and why." This works surprisingly well and takes two minutes. The output isn't perfect documentation, but it's substantially better than nothing.

**Pair-review high-complexity outputs.** For PRs over a certain complexity threshold, require two reviewers. The first reviews for correctness; the second reviews for whether the design is coherent with the broader system. This is overhead — but it's cheap insurance against cognitive debt in the system's critical paths.

---

## The Architectural Decision Is Yours

Anthropic shipped Claude Code Auto Mode this week — a secondary model that reviews every action the primary agent takes before execution, blocking pushes to main, preventing credential exfiltration, catching unsafe patterns. It's a meaningful step toward production-safe agentic coding.

But Auto Mode solves a different problem. It prevents unsafe *actions* in the moment. It doesn't prevent cognitive debt from accumulating over time. An agent can behave safely at every step and still produce a codebase that your team can't reason about six months from now.

The guardrails on agent *behavior* are improving quickly. The discipline around agent *output* — what decisions get documented, what review looks like, what structure exists before generation — is still largely up to you.

That's where Zechner and Willison are right. Not that you should move slower, but that speed without structure produces a compounding liability. The teams that win won't be the ones that move fastest. They'll be the ones that move fast and stay legible.

---

*David Lapsley, Ph.D., is Founder and CEO of ShipKodeAI. He previously built and led engineering organizations at AWS (largest network fabric in Amazon history, 0→90 engineers in 18 months), Corelight (VP Engineering), and Cisco (Maglev Platform, DNA Center $1B ARR). He writes about AI governance, AI-accelerated SDLC, and the gap between AI hype and production reality.*
