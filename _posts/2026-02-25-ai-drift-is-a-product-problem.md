---
title: "AI Drift Is a Product Problem, Not an Engineering Problem"
description: "Most teams treat AI drift as a prompting problem. After 18 months of building with AI agents, I've learned it's almost always a product problem. Here's a framework for finding and fixing it upstream."
date: 2026-02-25
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
  - ai-drift
  - spec-driven-development
  - ai-coding
  - sdlc
  - product-discovery
  - working-backwards
---

**Your coding agent isn't broken. Your specifications are.**

I've seen this play out dozens of times over the past 18 months. A developer prompts their coding agent with something reasonable: "add OAuth login," "implement the review feature," "build the settings page." The agent generates working code in minutes. Passes linting. Sometimes even writes tests.

Then someone else looks at it. The PM says "that's not what I meant." The designer says "where's the empty state?" The security lead says "we need token refresh with sliding expiration, not static tokens." Three days of rework follow. Sometimes a full rebuild.

The code isn't wrong, exactly. It compiles and it handles the happy path. But it doesn't match anyone's actual intent, because that intent was never written down. The agent filled every gap with training data patterns, and those patterns looked right enough to ship. Until they weren't.

I introduced the concept of **AI drift** in my post on [spec-driven development]({% post_url 2026-01-11-spec-driven-development-with-llms %}): the tendency for LLM implementations to diverge from requirements because those requirements were never made explicit. At the time, I framed it as an engineering discipline problem. Write better specs, get better code.

After 18 more months of building production software with AI agents every day, I've changed my mind about where the fix belongs. AI drift is almost always a product problem. The fix that actually works is upstream, not downstream.

## The four layers of drift

Not all drift is the same. When an AI-generated feature misses the mark, the root cause can originate at any point in the chain from customer need to shipped code. I've found it useful to classify drift into four layers, because each one requires a different response.

**Vision drift** is solving the wrong problem entirely. The team builds a feature nobody asked for because the product vision was unclear or disconnected from real customer needs. Building a sophisticated analytics dashboard when customers actually want a simple CSV export. No specification fixes this. The product discovery was wrong or missing.

**Requirements drift** is the right problem with wrong or missing scope. The team correctly identifies the problem but captures incomplete requirements. The OAuth example above is classic requirements drift. The team knew users needed to log in with Google. Nobody specified the consent screen, the token refresh behavior, or the verification step.

**Design drift** is right scope, wrong architecture. The agent implements a synchronous API when the architecture calls for event-driven messaging. Or it puts business logic in the controller layer when the design specifies a domain model. This is the layer most teams notice first because it shows up in code review.

**Implementation drift** is right architecture, wrong code. The rarest form in my experience. Requirements are clear, design is clear, and the agent still generates incorrect code. This is the only layer where "write a better prompt" or "use a better model" is actually the right response.

| Drift Layer | Root Cause | Example | Fix |
|-------------|-----------|---------|-----|
| Vision | Wrong problem | Build analytics when customers want CSV export | Better product discovery |
| Requirements | Missing scope | OAuth flow missing consent screen, token refresh | Structured specifications |
| Design | Wrong architecture | Sync API when design calls for event-driven | Design docs with ADRs |
| Implementation | Wrong code | Off-by-one error, incorrect API usage | Better prompts, better models |

Most teams spend 90% of their effort on implementation drift (better prompts, better models, more code review) when the actual problem is in the top two rows. They're tuning the engine while the steering wheel points off a cliff.

When a coding agent builds the wrong thing, the instinct is to fix the code. The discipline is to fix the specification. But the real skill is knowing which layer you're actually looking at.

## AI agents make product drift worse

Before AI coding tools, building the wrong feature took weeks or months. That slowness was painful, but it served a hidden function. Engineers asked clarifying questions during implementation. Designers pushed back on unclear requirements. The friction of manual coding created space for course correction.

AI coding agents removed that friction. A developer can generate a complete feature in hours. That speed is genuinely useful when you know what to build. When you don't, you just produce the wrong thing faster. The feedback loop that used to catch misalignment shrinks or disappears.

I wrote about this in [The Missing Half of AI-Assisted Development]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %}):

> Vague product thinking produces vague specifications, which produce vague code, no matter how good the coding agent is.

The economics hit small teams hardest:

| Scenario | Cost of Misalignment |
|----------|---------------------|
| 50-person team builds wrong feature for 1 quarter | Expensive, but survivable |
| 5-person team builds wrong feature for 1 quarter | 25% of runway, potentially fatal |

A 5-person team using Cursor can build the wrong feature in two weeks instead of two months. They've saved time on implementation. They've wasted the same amount of strategic clarity. AI makes small teams faster, but not more accurate. Without structured product discovery, speed just amplifies misalignment.

## Quantifying the rework tax by layer

In my post on [specifications as the API between product and engineering]({% post_url 2026-02-24-specifications-are-the-new-api %}), I presented rework rates across approaches:

| Approach | Features Built | Features Right | Rework Rate |
|----------|---------------|----------------|-------------|
| Coding agents + vague specs | 10 | 4-5 | 50-60% |
| Coding agents + structured specs | 10 | 8-9 | 10-20% |

That 30-40 percentage point gap is the rework tax on missing specifications. But it only captures requirements-level and design-level drift. Vision drift doesn't show up as rework at all. It shows up as a feature nobody uses. That cost is invisible until you measure adoption, which most teams don't do rigorously.

Here's how the rework tax breaks down by layer in what I've observed:

| Drift Layer | Time to Detect | Cost to Fix | Where It Shows Up |
|-------------|---------------|-------------|-------------------|
| Vision | Weeks to months (post-launch) | Full feature rebuild or abandon | Usage metrics, customer complaints |
| Requirements | Days (code review, QA) | 50-80% reimplementation | PR comments, QA bugs, design review |
| Design | Hours to days (code review) | Refactor specific components | Architecture review, performance testing |
| Implementation | Minutes to hours (tests) | Targeted code fixes | Unit tests, CI failures, linting |

The higher the layer, the longer it takes to detect and the more it costs to fix. Vision drift can burn months. Implementation drift burns hours. Yet most teams invest in faster detection at the bottom (better tests, better CI) while ignoring the top entirely.

**95%** of generative AI pilots fail to reach production (MIT Media Lab, 2025). I'd bet most of those failures are vision drift and requirements drift. The models work fine. The code compiles. The feature just doesn't solve a real problem, or solves it in a way nobody actually specified.

## Traceability as a diagnostic tool

If drift is the problem, traceability is the fix. Not traceability as a compliance checkbox, but as a way to figure out where things went wrong.

In [From PRFAQ to Backlog]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}), I described the Working Backwards artifact chain:

```
Customer Problem → Persona → Use Case → PRFAQ →
  Capability → Epic → Story → Specification → Code
```

Each link is a transformation from one structured artifact to the next. When you formalize those transformations, every line of code traces back through the chain to a customer problem.

This matters for drift because traceability makes drift *detectable at every layer*, not just at code review.

A feature that can't trace back to a validated customer problem through the persona and use case artifacts probably shouldn't exist. That catches "we're building this because it's technically cool" before any code gets written. That's vision drift detection.

At the requirements level, if a requirements.md file references a PRFAQ section, you can compare the requirement scope against the original product intent. Missing requirements become visible when the PRFAQ mentions capabilities that have no corresponding acceptance criteria.

Same idea at the design layer. If a design.md traces to requirements, you can verify that every requirement has a design component addressing it. Architectural misalignment becomes visible before implementation starts.

And at the implementation layer, if tasks.md traces to requirements and design, you can verify that the generated code covers every specified behavior. Most teams already handle this through testing, but traceability makes the coverage gap explicit.

You don't need perfect traceability to get value. Even coarse-grained links (this feature traces to this PRFAQ, this requirement traces to this use case) catch the most expensive drift: vision-level and requirements-level divergence that costs weeks or months to fix.

In our [gap analysis]({% post_url 2026-01-12-sdld-specification-format %}) of the SDLD pipeline, we identified four traceability gaps: no end-to-end chain from vision to code, no validation tooling, no coverage reports, and no cross-traceability between foundation features and product features. Closing even the first gap would catch most vision drift before implementation begins.

## How I actually diagnose drift

When a feature doesn't match expectations, most teams start with "the code is wrong." That's the most expensive assumption to start with. Here's what I do instead.

First, I check whether a specification exists. Does a requirements.md exist for this feature? Does it have testable acceptance criteria? If not, I'm looking at requirements drift. The fix isn't better code.

Second, I check the product artifacts. Does the specification trace back to a PRFAQ, user story, or use case? If the spec exists but doesn't connect to a product decision, it might be vision drift. The feature could be well-specified but solving the wrong problem.

Third, I check the design. Does a design.md exist? Does it address every requirement? If the requirements are solid but the architecture is wrong, that's design drift. The fix is an architecture decision record before anyone touches code.

Only after those three checks do I look at the code itself. If the spec is clear, the product connection is solid, and the design is sound, then the coding agent made a mistake. Fix the prompt. Improve the model context. Add a test.

Across the teams I work with, I'd estimate 70% of "the agent got it wrong" complaints trace to the first or second check. The specification was missing or vague. The product intent was never formalized. The agent did exactly what it was told. It just wasn't told enough.

## What the successful teams do differently

The teams that succeed with AI coding agents invest more time upstream than downstream. That's the common trait.

Most teams struggling with drift put their best people on code review, prompt engineering, and model selection. They optimize the last step. When features drift, they add more reviewers, more testing, more manual QA. It helps, but it's expensive and catches problems late.

The teams that do well put their best thinking into product discovery and specification writing. When features drift, they trace the chain back and fix the requirement, the design decision, or the product assumption. The problems get caught earlier, when they're cheaper.

The investment is smaller than people expect. In my experience, 30 minutes spent writing a precise requirements.md saves 3+ hours of implementation rework. That's a 6:1 return. Over a quarter, a team shipping ten features saves 25-30 hours of rework by investing 5 hours in better specifications. That adds up.

## Connecting this to the full pipeline

If you've been following this series, you can see the argument building. The [Missing Half]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %}) post identified the gap between product discovery and code generation. [From PRFAQ to Backlog]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}) described how to structure the upstream artifacts. [Specifications Are the New API]({% post_url 2026-02-24-specifications-are-the-new-api %}) showed how those artifacts become machine-readable contracts.

This post is about what happens when those contracts are missing. AI drift is the symptom you see. Missing traceability is the mechanism underneath. The four-layer framework is how I figure out where things actually went wrong.

This is also what drove me to develop the [ShipKode methodology](https://shipkode.ai). The traceability chain I described above, from customer signal through persona, use case, PRFAQ, specification, to code, is the core of that approach. Drift becomes detectable at every layer because the connections between artifacts are explicit and machine-readable, not implicit and scattered across Notion pages and Slack threads.

## The bottom line

Stop treating AI drift as a prompting problem. In most cases, it's a product problem showing up as an engineering symptom.

When your coding agent builds the wrong thing, trace the chain. Check the spec first. Check the product artifacts second. Check the design third. Only then blame the model.

AI accelerates whatever direction you're already heading. If you're pointed at the right problem with clear specs, that acceleration is worth a lot. If you're not, you'll just get to the wrong place faster and with more code to delete.

---

*David Lapsley, Ph.D., is Founder and CEO of a stealth startup. He has spent 25+ years building infrastructure platforms at scale. Previously Director of Network Fabric Controllers at AWS (largest network fabric in Amazon history) and Director at Cisco (DNA Center Maglev Platform, $1B run rate). He writes about AI infrastructure, AI-accelerated SDLC, and the gap between POC and production.*

## References

[1] MIT NANDA Initiative, "The GenAI Divide: State of AI in Business 2025" (2025), [link](https://fortune.com/2025/08/18/mit-report-95-percent-generative-ai-pilots-at-companies-failing-cfo/)

[2] Lapsley, D., "Spec-Driven LLM Development (SDLD)" (2026), [link]({% post_url 2026-01-11-spec-driven-development-with-llms %})

[3] Lapsley, D., "The Missing Half of AI-Assisted Development" (2026), [link]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %})

[4] Lapsley, D., "From PRFAQ to Backlog: Working Backwards as AI Pipeline" (2026), [link]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %})

[5] Lapsley, D., "Specifications Are the New API Between Product and Engineering" (2026), [link]({% post_url 2026-02-24-specifications-are-the-new-api %})

[6] Lapsley, D., "Amazon's Working Backwards SDLC for SMBs" (2026), [link]({% post_url 2026-02-17-amazon-working-backwards-sdlc-for-smbs %})

[7] Capgemini, "88% of AI Pilots Fail to Reach Production" (2023), [link](https://www.cio.com/article/3850763/88-of-ai-pilots-fail-to-reach-production-but-thats-not-all-on-it.html)

[8] Gartner, "85% of AI Projects Fail to Deliver" (2019), [link](https://www.bmc.com/blogs/cio-ai-artificial-intelligence/)
