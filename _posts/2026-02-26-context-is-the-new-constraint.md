---
title: "Context Is the New Constraint: Managing What Your AI Knows"
description: "Context windows are finite and more context doesn't mean better context. After building a pipeline for 20+ feature products, I learned that context management is the hidden scaling bottleneck in AI-assisted development."
date: 2026-02-26
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
  - context-management
  - spec-driven-development
  - ai-coding
  - sdlc
  - working-backwards
  - progressive-summarization
---

Your AI knows too much. And not enough. At the same time.

I hit this wall six months into building a specification pipeline. The first five features generated cleanly. By feature twelve, the AI started hallucinating component names from unrelated features. By feature eighteen, prompts exceeded 100KB and the model was ignoring interface contracts buried in the middle of the context window.

The instinct was to give the model more context. Longer system prompts. Bigger CLAUDE.md files. The full specification of every upstream feature. This made things worse.

In my [earlier post on the PRFAQ-to-Backlog pipeline]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}), I flagged this problem and promised to cover it in depth. This is that post. After building a pipeline that generates structured specifications for 20+ feature products, I've learned that context management is the scaling bottleneck nobody talks about. Not model capability. Not prompt engineering. The volume and relevance of what you feed the model.

The insight that reframed the problem for me: managing what your AI knows is structurally identical to managing what your engineering team knows. Every engineer can read the full codebase, but nobody starts there. You give them curated onboarding materials that guide them to the parts that matter for their work.

## The problem: context grows quadratically

The [specification pipeline I described in Post 2]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}) has seven steps. Steps 1-4 (personas, use cases, PRFAQ, feature map) have bounded context. Each step takes a small set of upstream artifacts with predictable sizes. No scaling issues.

The problem starts at Step 5, when you begin generating per-feature specifications (requirements, design, tasks). Two forces compound against you.

**Force 1: Upstream artifact repetition.** Every per-feature prompt needs the full product context: the PRFAQ, personas, and use cases. For a realistic product, those total 5,000-15,000 characters, and they're identical across all features. You're paying the same context tax twenty times.

**Force 2: Dependency spec accumulation.** Each feature's prompt includes the full specifications of all previously generated features, so the AI can reference existing component interfaces and avoid duplicating work. Those specs accumulate linearly:

```
Feature 1:  dependency_specs = []                              (0 KB)
Feature 2:  dependency_specs = [Spec1]                         (~3-5 KB)
Feature 3:  dependency_specs = [Spec1, Spec2]                  (~6-10 KB)
...
Feature 20: dependency_specs = [Spec1, Spec2, ..., Spec19]     (~57-95 KB)
```

Each specification contains requirements, components with code snippets, design decisions with rationale, correctness properties, error scenarios, tasks with subtasks, and testing strategy. A typical spec runs 3,000-5,000 characters. The accumulation is O(N) in specs, but each spec is itself O(requirements + components + tasks), so total context growth is quadratic in practice.

For feature 20 of a 20-feature product, the prompt sizes look like this:

| Template | Base | Upstream Artifacts | Dependency Specs | Total |
|----------|------|--------------------|------------------|-------|
| Requirements | ~7 KB | ~10 KB | ~57-95 KB | **~77-112 KB** |
| Design | ~9 KB | -- | ~60-95 KB | **~69-104 KB** |
| Tasks | ~9 KB | -- | ~60-95 KB | **~69-104 KB** |

Those numbers exceed the context budget you'd want to allocate for a system prompt. Worse, models degrade on information buried deep in long contexts. Research on "lost in the middle" effects shows that LLMs pay less attention to content in the middle of their context window (Liu et al., 2023). You're not just hitting token limits. You're hitting attention limits.

> The problem isn't that your context window is too small. It's that you're filling it with information your AI doesn't need for the task at hand.

## I'd solved this problem before. In management.

I spent two weeks trying to solve this as a pure engineering problem. Compression algorithms. Caching strategies. Nothing felt right.

Then I realized where I'd seen this pattern. Not in software. In every engineering organization I've ever run.

Any leader who has scaled a team past 50 people knows the information management problem. Every engineer can access every design document. They should. But nobody has time to read everything, and nobody should have to. You build communication structures that guide people to what they need and summarize the rest.

New engineers get onboarding docs that distill the system architecture into something they can absorb in a week. The full repository of design decisions is there if they want to dig in, but the onboarding doc tells them where to start. Teams working on a service get curated summaries of the services they depend on, not because the full specs are hidden, but because reading 50 internal specs to find the three that matter is a waste of their time. Weekly summaries give stakeholders the signal without requiring them to drink from the firehose.

The mapping is almost uncomfortably direct:

| Managing a team | Managing AI context |
|---------------------|---------------------|
| New engineer needs project context | New feature needs product context |
| Team needs interface contracts for dependencies | Feature spec needs component interfaces from dependency features |
| Stakeholders need summaries, not raw data | Templates need compressed artifacts, not verbatim text |
| Information grows as the org grows | Context grows as features accumulate |
| Over-communication wastes attention | Over-context wastes tokens and degrades quality |

In management, the fix is communication architecture: steering documents, executive summaries, interface contracts, guided navigation. The same categories apply to AI context management.

## Progressive summarization: the core strategy

The solution I landed on is **progressive summarization**: steering documents that compress upstream artifacts while preserving the interface contracts that downstream steps actually depend on. Instead of passing the full PRFAQ (5,000-15,000 characters) to every feature's spec generation, you generate a compact ProductVision summary (800-1,500 characters) that captures the product context the AI needs. Instead of passing full dependency specs, you pass a DependencySummary with just the interfaces.

Four steering documents do the job.

### 1. Architectural Principles (~2,000-3,000 characters)

The equivalent of your team's coding standards and architecture decision records. CLEAN layer definitions with dependency rules. SOLID principles with project-specific guidance. CQRS separation. DRY and YAGNI boundaries. Protocol patterns. Testing philosophy. Error handling conventions. 12-Factor operational patterns.

It's static. You define it once and inject it into every spec generation step. Without it, the AI makes arbitrary architectural decisions that conflict across features. Feature 8 puts business logic in the controller layer. Feature 12 creates a domain model for the same concern. Now you have two patterns for one problem, and every subsequent feature has to guess which one to follow.

Not every step needs every principle. Requirements generation needs CQRS (to separate commands from queries), YAGNI (to constrain scope), and relevant 12-Factor patterns (config externalization, statelessness). That's about 450 characters. Design generation needs the full suite because that's where component structure, layer placement, and interface design happen. That's about 1,800 characters. Tasks generation falls in between at about 1,200 characters.

Step-specific filtering avoids two failure modes: no architectural guidance (the AI guesses) and dumping everything into every prompt (wasting context on irrelevant principles).

### 2. ProductVision Summary (~800-1,500 characters)

**Replaces:** Full PRFAQ + personas + use cases (5,000-15,000 characters).

Product name. The first paragraph of the press release (the hook, not the full release). The top two pain points per persona. Persona names and roles. Use case titles and statements. The first three customer FAQ pairs.

That's enough for the AI to understand the product's purpose and target users. It does not need the full competitive analysis, the internal FAQ, or every pain point. Those details mattered during PRFAQ generation. They don't matter when generating a database migration feature's requirements.

Generated once after Step 3 completes. Used identically across all 20+ feature specs.

### 3. TechArch Summary (~500-2,000 characters)

This replaces the full feature map enumeration (which includes complete multi-sentence descriptions of every feature) with a compact catalog: product name, tech stack, each feature's ID, name, type, and first sentence of its description, plus the milestone overview and dependency graph.

The first-sentence extraction matters more than you'd expect. Each feature's full description might run 200+ characters. The first sentence captures the "what" in 40-80 characters. The AI needs to know what each feature does to avoid duplication. It doesn't need the implementation rationale.

Also generated once (after Step 4) and reused across all features.

### 4. DependencySummary (~500-1,500 characters per feature)

This is where the biggest win lives. Instead of passing all 19 full FeatureSpec objects (3,000-5,000 characters each) to feature 20, you extract a DependencySummary for each completed feature: feature ID and name, introduction, component summaries (name, layer, file path, code snippet), and design decisions (decision and choice only, no rationale).

Then you filter. Feature 20 doesn't get all 19 summaries. It gets summaries for only its direct dependencies, typically 1-3 features.

That's compression and filtering working together: 500-1,500 characters per feature instead of 3,000-5,000, and 1-3 summaries instead of 19. The dependency context drops by 90-97%.

Each DependencySummary is generated once, immediately after that feature's spec completes, and stored in a dictionary keyed by feature ID.

## Why rule-based extraction, not LLM summarization

You'd expect the right approach to summarizing AI-generated artifacts would be another AI call. I tried that first. It's worse.

All four steering documents use structural extraction from the pipeline's Pydantic models. No LLM calls. No summarization prompts.

| Factor | Rule-based extraction | LLM summarization |
|--------|----------------------|-------------------|
| Determinism | Identical output for identical input | Variable, may lose details |
| Cost | Zero additional LLM calls | 3+ extra calls minimum |
| Latency | Microseconds | 5-30 seconds per call |
| Testability | Pure function, property-testable | Requires mocking, non-deterministic |
| Information loss | Controlled: you choose what to keep | Uncontrolled: the LLM decides |

The controlled information loss is what sold me. When the LLM summarizes a spec, it decides what to include and what to cut. Sometimes it drops a component name that a downstream feature needs for its interface contract. That's a subtle, hard-to-debug failure. I lost a full day tracking down a case where the summarizer decided a protocol definition was "redundant" and omitted it. Three downstream features then invented their own incompatible versions. With rule-based extraction, the DependencySummary always includes component names, layers, and file paths. Always.

I keep LLM summarization as a fallback for the raw text path (when parsed models aren't available), but the primary path is deterministic extraction. I wrote about why deterministic approaches matter for complex systems in my [post on the LLM Complexity Gap]({% post_url 2026-01-17-llm-complexity-gap-distributed-systems %}). Same principle: when you can avoid non-determinism, avoid it.

## Context budgeting

I've started calling this **context budgeting**, and I think the framing is useful: you allocate a finite context window across competing information needs, the same way a project manager allocates a finite budget across competing priorities.

Given a context budget (typically 100,000-200,000 characters for modern models), the allocation I settled on:

| Category | Budget share | Rationale |
|----------|-------------|-----------|
| Base template (instructions + output format) | Fixed (~7-9 KB) | Non-negotiable: defines the task |
| The feature's own artifacts | 20% of remaining | Highest priority: the thing being generated |
| Architectural principles | Fixed (~1-2.5 KB) | Non-negotiable: ensures spec quality |
| Steering documents (vision + tech arch) | 10% of remaining | Compact and high-value |
| Dependency summaries | 15% of remaining | Interface contracts for consistency |
| Generated-so-far (requirements for design, components for tasks) | 55% of remaining | The feature's own prior outputs |

The fixed allocations matter. Architectural principles should never be truncated because they directly determine spec quality. The base template should never be truncated because it defines the output structure. Everything else is proportional and can degrade gracefully.

When the assembled prompt exceeds the budget, a progressive truncation order kicks in:

1. Code snippets in dependency summaries (keep names, layers, file paths)
2. Design decision details in dependency summaries (the AI can infer from component structure)
3. Dependency introductions (truncate to first sentence)
4. Persona details in ProductVision (reduce to names and roles)
5. Use case details in ProductVision (reduce to titles only)
6. Feature catalog descriptions in TechArch (reduce to IDs and names)
7. Customer FAQ highlights in ProductVision (remove entirely)

The order is deliberate. Interface contracts (component names, layers, file paths) survive longest because cross-feature consistency depends on them. Product vision details degrade first because they're the least likely to cause specification errors if compressed.

Items that never get truncated: the feature's own description, its generated requirements and components, direct dependency component names and layer assignments, architectural principles, and output format instructions.

This replaces the naive approach of rendering the full prompt and then failing with an "input too large" error. Instead, you estimate the prompt size before rendering, apply progressive truncation if needed, and fail only after all truncation options are exhausted.

## What the numbers look like after

After applying all four steering documents with direct-dependency filtering:

| Step | Before | After | Reduction |
|------|--------|-------|-----------|
| Requirements (feature 20) | 79-117 KB | 10-14 KB | **85-90%** |
| Design (feature 20) | 73-114 KB | 15-22 KB | **80-85%** |
| Tasks (feature 20) | 74-114 KB | 15-21 KB | **80-85%** |

The reduction comes from three sources working together.

**Upstream compression.** Full PRFAQ + personas + use cases (~10 KB) replaced by ProductVisionSummary (~1 KB). A 90% reduction on content that was identical across all features.

**Dependency filtering.** All 19 accumulated specs replaced by only 1-3 direct dependency summaries. For a 20-feature map where each feature depends on 1-3 others, this alone reduces dependency context by 80-95%.

**Spec compression.** Full FeatureSpec objects (3,000-5,000 characters each) replaced by DependencySummary objects (500-1,500 characters each). A 60-70% reduction per dependency.

The pipeline now handles 20+ feature products without hitting context limits. The spec quality also improved, which I didn't expect going in. When the model only sees interface contracts from features it actually depends on, it stops borrowing patterns from unrelated features. The hallucinated component names I was seeing at feature 12 disappeared.

## Where this fits in the series

If you've been following this series, the argument is building in layers.

[The Missing Half]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %}) identified the gap between product discovery and code generation. [From PRFAQ to Backlog]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}) described the pipeline that bridges it. [Specifications Are the New API]({% post_url 2026-02-24-specifications-are-the-new-api %}) showed how specifications become machine-readable contracts between product and engineering. [AI Drift Is a Product Problem]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}) explained what happens when those contracts are missing or imprecise.

This post addresses what happens after you get the contracts right. You have good specs. You have a working pipeline. You start scaling to a real product with 15, 20, 30 features. And context becomes the bottleneck. The raw volume of information the AI needs to do its job exceeds what you can fit in a single prompt without degrading quality.

The solution connects back to what I described in my [SDLD Specification Format post]({% post_url 2026-01-12-sdld-specification-format %}): structure your artifacts so they compress well. Specifications written as machine-readable contracts with clear field boundaries are easy to extract from. Free-form prose specifications are not. The three-document format (requirements.md, design.md, tasks.md) turns out to be not just a better API for coding agents, but a better format for progressive summarization.

## Applying this to your own workflow

You don't need a full specification pipeline to use these ideas.

If you're using Claude Code or Cursor with a CLAUDE.md file, you're already doing context management. The question is whether your CLAUDE.md compresses institutional knowledge well or just dumps everything in. I've seen CLAUDE.md files that are 50KB of unfiltered project documentation. That's the equivalent of handing a new engineer the entire wiki and saying "good luck."

If you're building multi-step AI workflows, pay attention to what passes between steps. Are you forwarding raw artifacts verbatim, or generating summaries at step boundaries? Every boundary is an opportunity to compress.

If you're managing dependencies between AI-generated artifacts, filter to direct dependencies. Transitive dependency information is already embedded in each direct dependency's interface contracts. You don't need the entire history.

The short version: compress context in stages (progressive summarization), filter to direct dependencies only (O(max_deps) not O(N)), and allocate your context window deliberately with a truncation order for when you exceed the budget.

## Why I built this into ShipKode

This is the problem that led me to build [ShipKode](https://shipkode.ai). The specification pipeline I've described throughout this series needs a context management strategy that scales. Without one, the pipeline breaks at 10-15 features. With steering documents and context budgeting, it handles 20+ features with better quality than the naive approach produced for 5.

The traceability chain I described in my [post on AI drift]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}), from customer signal through persona, use case, PRFAQ, specification, to code, is what makes progressive summarization possible. Because every artifact has structured fields and explicit links to upstream artifacts, you can extract exactly the information each downstream step needs. You can't do progressive summarization on a pile of Google Docs and Slack threads. You need structure first.

ShipKode is open source (Apache 2.0). If you're hitting context scaling issues in your own AI-assisted workflows, the steering document patterns are in the codebase. Try it and tell me what's missing.

## The bottom line

Context is the constraint nobody plans for. Model capability keeps growing, but context management determines whether you can actually use that capability as your product scales past 10-15 features.

I spent two weeks over-engineering this before the management analogy clicked. The fix was the same thing I'd been doing with human teams for twenty years: figure out what each consumer actually needs to know, compress everything else, and build a system that degrades gracefully when capacity gets tight.

---

*David Lapsley, Ph.D., is Founder and CEO of a stealth startup. He has spent 25+ years building infrastructure platforms at scale. Previously Director of Network Fabric Controllers at AWS (largest network fabric in Amazon history) and Director at Cisco (DNA Center Maglev Platform, $1B run rate). He writes about AI infrastructure, AI-accelerated SDLC, and the gap between POC and production.*

## References

[1] Liu, N.F. et al., "Lost in the Middle: How Language Models Use Long Contexts" (2023), [link](https://arxiv.org/abs/2307.03172)

[2] Lapsley, D., "From PRFAQ to Backlog: Working Backwards as AI Pipeline" (2026), [link]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %})

[3] Lapsley, D., "The Missing Half of AI-Assisted Development" (2026), [link]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %})

[4] Lapsley, D., "Specifications Are the New API Between Product and Engineering" (2026), [link]({% post_url 2026-02-24-specifications-are-the-new-api %})

[5] Lapsley, D., "AI Drift Is a Product Problem, Not an Engineering Problem" (2026), [link]({% post_url 2026-02-25-ai-drift-is-a-product-problem %})

[6] Lapsley, D., "The SDLD Specification Format" (2026), [link]({% post_url 2026-01-12-sdld-specification-format %})

[7] Lapsley, D., "The LLM Complexity Gap: Why No-Code Works for Web UIs But Not for Distributed Systems" (2026), [link]({% post_url 2026-01-17-llm-complexity-gap-distributed-systems %})

[8] MIT NANDA Initiative, "The GenAI Divide: State of AI in Business 2025" (2025), [link](https://fortune.com/2025/08/18/mit-report-95-percent-generative-ai-pilots-at-companies-failing-cfo/)
