---
title: "Building the End-to-End AI-Native SDLC:
  What I've Learned"
description: "After 18 months building AI-native SDLC
  tooling, here's what works, what doesn't, and why
  the hardest problem isn't technology."
date: 2026-03-04
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
  - ai-native-sdlc
  - spec-driven-development
  - shipkode
  - working-backwards
  - product-engineering-gap
  - ai-coding-agents
---

*This is Post 6 of a series on the AI-Native SDLC. Previous posts: [The Missing Half]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %}), [From PRFAQ to Backlog]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}), [Specifications Are the New API]({% post_url 2026-02-24-specifications-are-the-new-api %}), [AI Drift Is a Product Problem]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}), [Context Is the New Constraint]({% post_url 2026-02-26-context-is-the-new-constraint %}).*

---

## The question that started all of this

Eighteen months ago, I started asking a question I couldn't let go of: what if someone built a "Cursor for product management"? A system where you upload customer interviews and usage data, ask "what should we build next?", and get a feature outline grounded in evidence, with tasks broken down for a coding agent.

I've spent 25 years as part of and building high performance engineering teams. I'd seen the same pattern at AWS, at Cisco, at the many startups I'd worked at. Teams don't fail because their technology is bad. They fail because the connection between "what the customer needs" and "what the engineer builds" is a game of telephone. Layer after layer of translation, each one losing signal.

Software development shouldn't be a game of telephone. But that's exactly what it is for most teams today.

So I started building. First an open-source CLI called [KodeOps]({% post_url 2026-01-19-introducing-kodeops-open-source-sdlc-automation %}). Then a full pipeline that transforms a problem-space description into implementation-ready specifications. I wrote five posts along the way, each digging into a different piece of the system. This post is me stepping back to tell you what actually happened: what works, what doesn't, and what I got wrong.

## The broken pipeline

Every software team faces the same broken pipeline. After dozens of conversations with practitioners at companies ranging from Fortune 10 to 5-person startups, I keep hearing the same four problems.

**Scattered customer insights.** Interviews, support tickets, NPS surveys, and analytics dashboards live in silos. Nobody connects them into a coherent picture. A senior manager at a Fortune 10 technology company told me: "There is a severe disconnection between the intent and the technology... they don't speak the same language, and they don't even know that they are not speaking the same language."

**Manual synthesis and spec writing.** Product managers spend days manually translating those fragmented signals into specifications, introducing bias and gaps along the way. A director at a Fortune 50 social media company put it bluntly: "Pulling a new plan together, it's really expensive. It's like, you look at a room full of very expensive people... and you try to squeeze your brain." Another senior manager at a Fortune 10 estimated that only 20% of the effort in their org goes toward new, novel, innovative things that are actually going to click for their customers. The rest is translation overhead and rework.

**Misinterpreted handoffs.** Engineers interpret specs differently, leading to costly rework and features that miss the mark. A BD and PM lead at a software services firm said simply: "We usually failed there. It was estimation."

**No closed loop.** Specifications become disconnected from ongoing customer feedback. There's no clear path back from what happened in production to the customer insight that could prevent recurring issues. A tech lead at a software company told me: "I would love to have something like this that tells me, those are the design choices that were made to do this project... without having to find the only guy that is still in the company that knows about that."

The cost of this broken pipeline is quantifiable. Product teams spend over **40% of their time** on translation work: turning insights into specs, specs into tasks, tasks into requirements. **Zero direct connections** exist between a customer quote and the engineering specification it informed in a traditional workflow. And context loss at every handoff means only about **30% of the original customer intent** makes it into the final specification.

The gap between "what customers need" and "what gets specified" is where products fail.

## The end-to-end vision

The thesis across this series is blunt: **software development failures in the AI era are planning failures, not technical failures.** This applies whether you're shipping an AI product or using AI to accelerate how you build any product. The bottleneck isn't the agent's capability. It's the quality of what you feed it.

The system I've been building has three stages:

**Discover:** Ingest customer signals, synthesize personas, derive use cases, and produce a north-star PRFAQ document grounded in real evidence.

**Deliver:** Decompose the PRFAQ into a dependency-aware feature map and generate structured, engineering-ready specifications (requirements.md, design.md, tasks.md) for each feature.

**Feedback:** Gather real-world feedback from shipped products, validate specs against outcomes, identify gaps, and feed new signals back into the Discover stage so the next iteration is better than the last.

Each node in the pipeline is an autonomous agent. Each handoff is structured, evidence-based, and traceable. The continuous learning loop from real-world feedback back to discovery never stops, so the product keeps getting better with every cycle.

Humans make decisions at approval gates between stages. They're not micromanaging every line of code, and they're not rubber-stamping AI output. They're making the judgment calls that machines can't: Is this the right problem? Does this spec actually capture what we mean?

That senior manager at the Fortune 10 company summed up the aspiration: "If you manage to create a path, an assisted process to get from the business intent and incrementally and hierarchically break down to the level that is necessary for execution... I think that you win."

That's the vision. Here's what actually happened.

## Lesson 1: Spec-to-code is solved. Signal-to-spec and feedback are not.

This is the most important thing I've learned, and it took me longer than it should have to see it clearly.

Many tools already do spec-to-code well. Kiro generates implementation from structured specs. Cursor and Claude Code turn well-written prompts into working code. GitHub Copilot autocompletes the obvious parts. The delivery stage, turning a specification into running software, has real products with real users. It's not finished, but it's well underway.

What almost nobody is building is the stage before that: turning raw customer signals, market data, and half-formed product ideas into the structured specifications those coding agents need. I call this signal-to-spec. It's the discovery stage of the pipeline: Problem Space to Personas to Use Cases to PRFAQ to Feature Map to requirements.md, design.md, and tasks.md.

And what truly nobody is building is the feedback stage: taking production signals (bugs, usage patterns, performance data, customer behavior) and flowing them back upstream to inform the next round of discovery. Without feedback, the pipeline is open-loop. You ship, but you don't learn. You build features, but you don't know if they're the right features until someone complains.

That Fortune 10 senior manager again: "How do I get from the literal CRs, or pull requests, to the business value?" That's the feedback question. And right now, nobody can answer it systematically.

These are the two stages I focus on. Signal-to-spec, because vague product thinking produces vague specs produces vague code, and no coding agent fixes upstream ambiguity. And feedback, because without it you're just guessing faster.

Feature decomposition sits at the boundary between discovery and delivery, and it's harder than it looks. You need dependency graphs with topological ordering (I use Kahn's algorithm) to figure out which features can be built in parallel and which have prerequisites. You need cycle detection (DFS three-color algorithm) to catch circular dependencies before they deadlock your pipeline.

Specification generation has to be context-aware. As I wrote in [Context Is the New Constraint]({% post_url 2026-02-26-context-is-the-new-constraint %}), by feature 20 of a 20-feature product, raw prompts hit 79-117 KB. You can't just dump everything into the context window. You need progressive summarization, steering documents, and explicit context budgets.

> Discovery and feedback are where the pipeline creates or destroys value. Delivery is where it executes.

## Lesson 2: Specs are the hardest sell, and the highest leverage

In [Specifications Are the New API]({% post_url 2026-02-24-specifications-are-the-new-api %}), I argued that specs are no longer documentation for humans. They're contracts for machines. I still believe that. The data supports it: vague specifications produce 50-60% rework rates. Structured specifications bring that down to 10-20%. A 30-minute spec investment saves 3+ hours of rework. 6:1 return.

But I underestimated a different problem: it's not that developers won't write specs. Most will, if specs are part of their IDE workflow. Kiro and Cursor have proven that. The real challenge is that every developer wants the freedom to use their own methodology and tooling. That's a reasonable preference. It's also not inherently scalable.

At some point, you need commonality. Governance. Shared formats that let one team's output feed into another team's input. But push too hard on standardization and you kill the autonomy that makes good engineers productive. The trick is finding the mix that enables scaling while still empowering developers to innovate. I don't think anyone has nailed that balance yet, including me.

The developers who actually do it have usually been burned. They spent a week debugging a feature that was built to spec, only to discover the spec was wrong. Or they watched an AI coding agent confidently implement the wrong thing because the prompt was ambiguous. One developer I talked to burned 25% of a sprint on rework that a 30-minute spec would have prevented. That's what converts people.

You can't convince teams to invest in specifications by showing them the math. They have to feel the cost first. Then the math lands differently.

This is why I think the tooling needs to make spec creation nearly effortless. If writing a spec takes 30 minutes, some teams will do it. If it takes 5 minutes because the system drafts it from the PRFAQ and you just review and approve, most teams will do it. The activation energy matters more than the ROI calculation.

## Lesson 3: The pipeline is really three different problems

When I started, I thought I was building one system. Turns out I was building three.

The first is the **discovery loop.** Teams spend 1-2 weeks manually synthesizing customer interviews, support tickets, and analytics into product decisions. The process is unstructured and loses the connection between decisions and evidence. This is a synthesis problem. LLMs handle it well, if you give them the right structure.

The second is the **delivery loop.** Developers spend 40-60% of their AI-assisted coding time in the manual generate-test-fail-fix-reprompt loop. This is an execution problem. Many tools are already attacking it. Kiro, Cursor, Claude Code. This part of the pipeline has real momentum.

The third is the **feedback loop.** Production data, customer behavior, bug reports, usage patterns, performance metrics, all of this should flow back into discovery to inform the next iteration. Without it, you're flying blind. You shipped something. Did it work? Did customers use the feature you built? Did it solve the problem you identified in the PRFAQ? Without feedback, you can't answer those questions except by gut feel.

These three problems share a pipeline, but they fail in completely different ways and they serve different people.

The discovery loop fails when it loses signal. Customer quotes get paraphrased into generic insights. Competitive analysis gets smoothed into "the market is growing." The PRFAQ reads well but isn't grounded in anything a specific customer actually said.

The delivery loop fails when it loses precision. A requirement says "handle errors gracefully" instead of specifying which errors and which retry policies. A design document describes the architecture but skips the interfaces. Or a task is just too large for an agent to hold in context, and it starts hallucinating the parts it can't see.

The feedback loop fails when it doesn't exist. And right now, for most teams, it doesn't. They ship a feature, move to the next sprint, and never systematically connect production outcomes back to the product decisions that created them.

In [AI Drift Is a Product Problem]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}), I described a four-layer drift taxonomy: vision drift, requirements drift, design drift, implementation drift. What I've learned since is that the first two are discovery problems, the last two are delivery problems, and feedback is what prevents all four from compounding over time. The boundary between discovery and delivery is the Feature Map, where a validated PRFAQ gets decomposed into buildable units. That boundary is where most pipelines break. But the absence of feedback is where most products go wrong over time.

## Lesson 4: Traceability is the foundation, not a feature

I used to think of traceability as a nice-to-have. Something you'd add later, once the core pipeline worked. I was wrong. Traceability is the foundation the entire pipeline is built on.

Here's what I mean. The pipeline maintains a structured evidence graph throughout. Every artifact, every persona, use case, feature, and spec, carries references to the customer signals that originated it. When someone asks "why did we spec this?", the answer is one query away. No archaeology through old Slack threads required.

This matters for three reasons.

First, it makes approval gates work. When a reviewer looks at a PRFAQ, they can see exactly which customer signals support it and which are absent. The gate becomes a real decision, not a rubber stamp.

Second, it makes drift detectable. When a specification starts to diverge from the original product intent, the traceability chain shows you exactly where the divergence happened and which layer to fix. I covered this in detail in [AI Drift Is a Product Problem]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}).

Third, and this is the one I didn't expect, it makes feedback possible. The feedback loop only works if you can compare actual outcomes against original intent. "Did this feature solve the problem we identified in the PRFAQ?" is only answerable if you can trace the feature back to the PRFAQ, the PRFAQ back to the use cases, and the use cases back to the customer signals. Without that chain, feedback has nothing to compare against.

Traceability isn't a feature you bolt on. It's the foundation the pipeline is built on.

## Lesson 5: Approval gates matter more than automation

This one surprised me. I expected the automation to be the hard technical challenge and the approval gates to be simple pass/fail checkpoints. It's the opposite.

The automation is mechanical. Render a prompt template, call the LLM, parse the output, validate against a schema, persist to the database. Each step follows the same pattern. Once you build one, you can build the rest.

The gates are harder, and for a subtle reason: the quality of the gate depends on the quality of what you show the reviewer.

Consider the PRFAQ gate. This is the most important gate in the pipeline. Ideas that don't survive the PRFAQ should die here, cheaply, before you spend engineering resources on them. A 5-person team that kills a bad idea at the PRFAQ gate saves itself from burning 25% of its runway building the wrong thing.

But what should the reviewer see at this gate? The raw PRFAQ? The customer evidence that supports it? The personas that would use it? The use cases it addresses? The competitive analysis? All of this is available in the pipeline. Showing too little means the reviewer rubber-stamps. Showing too much means the reviewer drowns.

I've landed on a simple rule: **show the artifact plus its traceability links, nothing else.** At the PRFAQ gate, you see the PRFAQ with links to the specific customer signals, personas, and use cases that inform it. You can drill down if you want. But the default view is focused on the one decision you need to make: should we build this or not?

## Lesson 6: What customer discovery actually revealed

I designed a formal customer discovery campaign using The Mom Test and Jobs-to-be-Done frameworks. Three target segments: individual developers (3-8 years experience), engineering managers (8-12 years), and platform engineers (12-18 years).

I had 13 hypotheses going in. Every single one was marked "untested" when I started. Here's what I've learned about the adoption barriers that matter.

Individual developers feel the pain but the solution feels heavy. A solo developer who spends 40-60% of their time in the prompt-review-fix-reprompt loop knows they're wasting time. But asking them to write a requirements.md before they start coding feels like asking them to fill out a TPS report. The tool needs to generate the spec, not ask the developer to write it.

Engineering managers care about something different than I expected. Not velocity. Predictability. They don't care whether AI makes their team 2x faster. They care whether the feature ships on the date they committed to. Structured specifications matter to them because they reduce variance, not because they increase throughput.

Platform engineers made me recalibrate entirely. Security and governance aren't features to them. They're prerequisites. 25.1% of LLM-generated code contains vulnerabilities (2026 benchmark across 6 major models). 6.4% of repos using Copilot leak at least one secret, 40% higher than non-AI repos. 48% of cybersecurity professionals rank agentic AI as the #1 attack vector for 2026. A platform team that deploys an AI coding pipeline without governance isn't being innovative. They're being negligent.

Across all three segments, one thing was clear: nobody wants more process. What they want is to stop wasting time building the wrong thing. The positioning that resonates isn't "write better specs." It's "stop throwing away sprints."

## Lesson 7: Context management is the unsexy scaling problem

I devoted all of [Post 5]({% post_url 2026-02-26-context-is-the-new-constraint %}) to this, and it turned out to be even more important than I thought when I wrote it.

The pipeline generates artifacts at every stage. Personas reference the problem space. Use cases reference personas. The PRFAQ references use cases. The feature map references the PRFAQ. Each specification references the feature map, the architectural decisions of previously-generated specs, and the shared product context. It all stacks up.

By the time you're generating the specification for the twentieth feature, the naive approach (include all upstream artifacts in the prompt) produces prompts that exceed most context windows. Progressive summarization with steering documents reduces prompt size by 85-90%. But it introduces a new problem: information loss.

Rule-based extraction (pulling specific fields from structured artifacts) beats LLM-based summarization for this use case. It's deterministic, zero-cost, and testable. You control exactly what information gets preserved and what gets dropped. But you have to know which information matters, and that knowledge comes from watching the pipeline fail.

I spent weeks debugging cases where a specification was technically correct but missed a cross-cutting concern because the context budget had truncated the relevant architectural decision from a previously-generated spec. The truncation order (what to drop first when context overflows) turned out to be just as important as the context budget itself.

## What the 5% do differently

Across all six posts, one pattern keeps showing up. The teams that succeed with AI-accelerated development share a few habits.

They specify before they build. Not because they love documentation. Because they've been burned enough to know that 30 minutes of specification saves 3+ hours of rework. They use structured formats (requirements.md, design.md, tasks.md) that machines can consume, not free-form documents that humans can misinterpret.

They maintain traceability. Every feature traces back to a customer problem. Every specification traces back to a product decision. When something drifts, they can figure out where and fix the right layer instead of patching symptoms.

They put humans at gates, not in loops. They don't micromanage every AI output. They don't rubber-stamp either. They make the decisions that matter at stage boundaries: Is this the right problem? Does this spec capture what we mean? Then they let the machines execute.

The common thread isn't technical sophistication. It's discipline about where human judgment ends and machine execution begins.

## What I haven't figured out yet

I want to be straight about the unsolved problems.

Feedback is the hardest stage and the one I've made the least progress on. The design is clear: gather real-world feedback from shipped products, compare actual outcomes against original spec intent, identify gaps and unmet needs the original specifications didn't capture, and transform those learnings into new customer signals that re-enter the Discover stage. That's the virtuous cycle. Each iteration of specifications gets better because it's informed by what actually happened, not just what we assumed would happen.

But the implementation is hard. Not every bug report invalidates a PRFAQ. Not every usage pattern means a feature was wrong. The signal-to-noise filtering for feedback is at least as hard as the signal-to-spec problem in discovery, maybe harder. Which production signals matter? How do you weight a usage pattern against a customer complaint? How do you prevent feedback noise from overwhelming the discovery stage? These are open questions.

Traceability tooling is conceptual but not fully enforced. The chain exists in theory. The tooling to enforce it at scale, to generate coverage reports, to flag when a code change breaks the chain, still needs work.

Pipeline orchestration works for one product. Running the pipeline for a product portfolio with shared infrastructure, shared personas, and cross-product dependencies is a different animal. That orchestration layer needs real work.

Discovery works. Delivery has good tools from others and I'm building the spec-generation piece. Feedback has a design and early implementation. The full closed loop is the goal.

## Why I'm building this

This is why I built [ShipKode](https://shipkode.ai). The delivery stage has good tools. Kiro, Cursor, Claude Code, Copilot. What's missing is the stage before and the stage after. Signal-to-spec: turning raw customer signals into the structured specifications those coding agents need. And feedback: flowing production outcomes back upstream so the next iteration is better than the last.

ShipKode is an open-source agentic pipeline that automates the full journey from raw customer data to engineering-ready specifications. Three stages. One closed loop. Full traceability at every step.

In the Discover stage, it ingests customer signals from any source (interviews, support tickets, NPS surveys, analytics), clusters them into themes, scores opportunities by frequency and severity, generates structured personas grounded in real evidence (not assumptions), derives use cases, and synthesizes everything into a PRFAQ north-star document.

In the Deliver stage, it decomposes the approved PRFAQ into a dependency-aware feature map (foundation features first, using topological sorting), then generates structured Kiro-format specifications (requirements.md, design.md, tasks.md) for each feature. Specs are validated for completeness, consistency, and testability. Human-in-the-loop gates let your team review and approve before handoff to whatever coding tools you already use.

In the Feedback stage (still early), it gathers real-world feedback from shipped products, compares actual outcomes against original spec intent, surfaces gaps and unmet needs, and transforms validated learnings into new customer signals that re-enter the Discover stage.

Every artifact in the pipeline, every persona, use case, feature, and spec, carries references to the customer signals that originated it. When someone asks "why did we spec this?", the answer is one query away.

It's built on LangGraph (stateful, interruptible agent graphs with human-in-the-loop gates), exposed as both an open-source CLI/TUI and an MCP server with 30+ tools that work with any MCP-compatible IDE. Apache 2.0 licensed. BYOK: bring your own LLM API key (Anthropic, OpenAI, AWS Bedrock, or Ollama). No data leaves your environment. No proxy. No SaaS middleman. Your keys, your data, your infrastructure.

I'm not claiming it's complete. But I've shipped enough of it to know the architecture is right and the spec-driven approach works. The traceability chain, connecting every specification back to the customer signal that justified it, is the feature that matters most. And it's the one nobody else is building.

It's open source. Try it and tell me what's missing.

## The real lesson

The answer isn't "a Cursor for product management." The answer is a pipeline that connects product management to Cursor. A system where understanding customers, validating ideas, and specifying features flows directly into the tools that build them, and where real-world outcomes flow back to make the next iteration better.

The technology is solvable. Every piece of this pipeline uses well-understood components: LLMs for synthesis, structured schemas for validation, graph algorithms for decomposition, context management for scaling. None of this is research. It's engineering.

The hard part is cultural. Convincing teams that the 30 minutes they spend writing a spec isn't overhead. That it's the highest-leverage activity in their development process. That the cost of building the wrong thing is always higher than the cost of specifying the right thing.

Every handoff in the traditional pipeline is an opportunity for signal to degrade, context to vanish, and customer intent to get lost in translation. Teams end up specifying features nobody asked for while the real pain points sit untouched in a backlog.

When every specification traces back to a customer need, and every real-world outcome feeds back into discovery, you're no longer guessing what to build next. You know.

Eighteen months in, I'm more convinced of this than when I started.

---

## References

[1] MIT Media Lab, "95% of Generative AI Pilots Fail to Reach Production" (2025)

[2] Capgemini, "88% of AI Pilots Failed to Reach Production" (2023)

[3] Algorithmia, "State of Machine Learning" (failure causes by category)

[4] Gartner, "53% of Employees Use Unsanctioned AI Tools" (2024)

[5] Deloitte, "68% of Employees Share Sensitive Data with Public LLMs" (2023)

[6] 2026 Benchmark, "25.1% of LLM-Generated Code Contains Vulnerabilities" (across 6 major models)

---

> David Lapsley, Ph.D., is Founder and CEO of
> ShipKodeAI. He has spent 25+ years building infrastructure
> platforms at scale. Previously Director of Network
> Fabric Controllers at AWS (largest network fabric in
> Amazon history) and Director at Cisco (DNA Center
> Maglev Platform, $1B run rate). He writes about AI
> infrastructure, AI-accelerated SDLC, and the gap
> between POC and production.
