---
title: "Customer Discovery Is the Highest-Leverage Work You're Not Doing"
description: "I've spent the last month in back-to-back customer discovery conversations. The insights have been transformative. Here's why customer discovery is arguably the most important activity for early-stage startups, and a practical guide to doing it well."
date: 2026-03-25
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Product Management
  - Leadership
  - Engineering
tags:
  - customer-discovery
  - product-discovery
  - working-backwards
  - startup
  - sdlc
  - interviews
  - product-market-fit
---

I've spent the last month in back-to-back conversations with potential customers. Twenty-plus meetings, each one between thirty and sixty minutes. Every conversation led with listening. Some evolved into demos. Some turned into pitches. But the ones that produced the most valuable insights were the ones that stayed in discovery mode the longest.

It has been, without exaggeration, the most valuable month of work since I started building ShipKode.

Every conversation has sharpened something. My understanding of how teams actually adopt AI-assisted development tools. The language they use to describe their pain. The workflows they've built around the problems I'm trying to solve. The specific dimensions of the problem that matter most to them and the order in which they matter.

I walked into these conversations with a strong thesis. I'd spent 18 months building production software with AI coding agents, writing about the gaps in AI-assisted development, and designing a specification pipeline to close those gaps. I had conviction about the direction. The conversations reinforced that conviction, but they did something even more valuable: they gave me the texture and nuance to make the product significantly better than what I would have built from my thesis alone.

Hearing a VP of Engineering describe how their team wants to adopt AI-assisted development but doesn't know where to start, how they've tried three different tools and still can't get past the POC stage, how they know the transformation is coming but can't find a path from where they are to where they need to be — that adds a dimension no amount of desk research provides. The direction was right. The discovery made it sharper, more specific, and more valuable.

## Understand the customer before the customer understands you

There's a principle I keep coming back to: **understand the customer before the customer understands you.**

The natural instinct when you've built something is to show it. You've spent months on this thing. You're proud of it. You want validation. So you book a meeting, share your screen, and start clicking through the product. I've done this. It works, and there's a time for it.

But when you lead with a demo, the conversation narrows. The customer is reacting to your solution instead of describing their problem. Their feedback becomes bounded by what you showed them. They'll tell you what they think of your feature, not what keeps them up at night.

The best conversations I had this month were the ones where I resisted the demo impulse and started with questions. How does your team work today? What's painful? What have you tried? I let them describe the problem in their language, using their mental models, with their priorities. When I did eventually show the product, later in the conversation, the context I'd gained made the demo dramatically more effective. I knew which parts to focus on because I'd just heard what mattered to them.

The ordering matters. Discovery first, then demo. Understand first, then be understood. The insights you get from this sequence are qualitatively different from leading with a pitch. Demo-first feedback tells you whether someone likes what you built. Discovery-first feedback tells you whether you're building the right thing, and sharpens the demo when it comes.

## Why this is the most important activity for early-stage startups

I've written extensively about how [95% of AI pilots fail to reach production]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %}). The MIT NANDA study found that the root cause is almost never technical. The models work fine. The code compiles. The feature just doesn't solve a real problem, or solves it in a way nobody actually specified.

Customer discovery is the fix for that failure mode. Not better models. Not better prompts. Conversations with the people whose problems you're trying to solve.

For early-stage startups, this matters more than anything else you could spend your time on. Here's why.

**You can't afford to build the wrong thing.** As I noted in my post on [Amazon's Working Backwards SDLC for SMBs]({% post_url 2026-02-17-amazon-working-backwards-sdlc-for-smbs %}), a 5-person team that builds the wrong feature for a quarter has burned 25% of its runway. Customer discovery is how you avoid that. Thirty minutes of conversation can save three months of engineering.

**Discovery refines your direction in ways you can't anticipate.** Every founder believes they understand their customer. I had a strong thesis going in, and the conversations validated the core direction. But they also surfaced refinements I couldn't have reached on my own. Priorities I would have ordered differently. Use cases I'd underweighted. Specific pain points that, once I heard them described in the customer's own words, made the product roadmap click into sharper focus. You can't think your way to these refinements. You have to hear them from someone living the problem.

**The language matters as much as the insight.** When customers describe their pain, they use specific words and phrases. Those words are gold. They're the exact language you'll use in your marketing, your documentation, your PRFAQ, your positioning. I've pulled phrases directly from discovery calls into product descriptions, and the resonance with other customers is immediate.

**It compounds.** Every conversation builds on the last. By conversation five, you're hearing patterns. By conversation ten, you're testing hypotheses. By conversation fifteen, you're refining nuances. By conversation twenty, you have a map of the problem space that no amount of desk research could produce.

| Activity | Time Investment | Information Value | Risk Reduction |
|----------|----------------|-------------------|----------------|
| Building features based on assumptions | Weeks to months | Low (confirms your biases) | Low |
| Reading market research reports | Hours | Medium (generalized, not your market) | Low |
| Analyzing competitor products | Days | Medium (their solution, not your customer's problem) | Medium |
| Customer discovery interviews | 30-60 min each | Very high (specific, actionable, in their words) | Very high |

Nothing else gives you this return. The ROI on a single well-conducted discovery call dwarfs anything you could learn from a competitor analysis or a market report.

## What customer discovery actually looks like

Customer discovery isn't casual conversation. It's a structured practice with specific artifacts and a repeatable process. Here's what I've built over the last month.

### The interview script

Every discovery conversation follows a script. Not a rigid script that you read verbatim, but a structured guide that ensures you cover the important ground while leaving room for the conversation to go where it needs to.

My script has five sections, and I rarely get through all of them in one conversation. That's fine. The first three are the most important.

**Section 1: Their world today.** How does your team build software today? Walk me through what happens from the time someone decides a feature needs to be built to the time it ships. What tools do you use? How many people are involved? How long does a typical feature take?

This section is pure observation. You're building a mental model of their workflow. Don't suggest improvements. Don't react with "oh, we solve that." Just listen and take notes. The details here are where the real insights hide. Not in what they say is painful, but in the workarounds they've normalized.

**Section 2: Pain and friction.** What's the most frustrating part of that process? Where do things break down? What takes longer than it should? If you could fix one thing about how your team ships software, what would it be?

This is where customers start telling you things they haven't articulated before. Often they'll pause, think, and then say something that surprises even themselves. Those moments are the most valuable data points you'll collect. Pay attention to energy shifts. When someone's voice changes, when they lean in, when they start telling a story about a specific incident, that's where the real pain lives.

**Section 3: Prior attempts.** Have you tried anything to solve this? What tools have you evaluated? What worked? What didn't? Why did you stop using it?

This section tells you what you're competing with (and it's usually not another product; it's a spreadsheet, a Slack channel, or a manual process that sort of works). It also tells you where the adoption barriers are. If someone evaluated a tool similar to yours and abandoned it, the reasons why are the most important thing you'll learn all day.

**Section 4: Success criteria.** If a tool solved this problem for you, what would that look like? How would you know it was working? What would change about your team's output or velocity?

This is where you start hearing what success looks like in their language. This maps directly to acceptance criteria in your specifications. I've pulled entire requirements from answers to this question.

**Section 5: The demo (if time and rapport allow).** Now that I understand how you work, let me show you what we've been building. Does this match the problem you described?

Only after you've done sections 1-4. The demo is dessert, not the main course. And you're watching their reaction as much as listening to their words. Where do they lean in? Where do they look confused? What feature do they ask about that you didn't show?

### The tracker

Every conversation gets logged in a structured tracker. Mine is a spreadsheet with these columns:

| Column | Purpose |
|--------|---------|
| Date | When the conversation happened |
| Name / Role / Company | Who you talked to |
| Company size / Stage | Context for their constraints |
| Current workflow | How they build software today |
| Primary pain | The #1 thing they'd fix |
| Secondary pains | Other friction points mentioned |
| Tools evaluated | What they've tried |
| Key quotes | Verbatim phrases that capture their thinking |
| Signals | Buying signals, adoption barriers, enthusiasm indicators |
| Follow-up | Next steps, intros offered, requests made |

The "Key quotes" column is the most important. When a VP of Engineering says "We spend more time arguing about what to build than actually building it," that's a quote you'll use in your PRFAQ, your pitch deck, your website copy, and your specification pipeline. Capture it exactly as they said it.

After every conversation, I spend fifteen minutes filling in the tracker while the details are fresh. This is non-negotiable. Memory degrades fast. The nuance you think you'll remember tomorrow is gone by next week.

### The summary cadence

Every five conversations, I write a summary. Not for anyone else. For myself. The summary forces me to synthesize patterns across conversations and update my understanding.

The summary answers four questions:

1. **What patterns am I seeing?** Which pains are universal versus specific to one persona or company stage?
2. **What surprised me?** What did I learn that contradicts my assumptions?
3. **What's the strongest signal?** If I had to bet the company on one customer problem, which one has the most consistent evidence?
4. **What should I ask next?** What hypotheses should I test in the next five conversations?

These summaries are artifacts that feed directly into the Working Backwards process. The patterns become personas. The pain points become use cases. The strongest signals become the PRFAQ's opening paragraph. The key quotes become the customer testimonials in your FAQ section.

## Feeding discovery into your development process

This is where customer discovery connects to everything I've written about [spec-driven development]({% post_url 2026-01-11-spec-driven-development-with-llms %}) and the [Working Backwards pipeline]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %}). Discovery isn't a standalone activity. It's the first stage of a pipeline that ends with code.

The chain looks like this:

```
Discovery Conversations → Interview Tracker → Pattern Summaries →
  Personas → Use Cases → PRFAQ → Feature Map →
  requirements.md → design.md → tasks.md → Code
```

Every downstream artifact is grounded in something a real customer said. The persona isn't a fictional character you invented in a workshop. It's a composite of five real people you talked to, with their actual job titles, their actual pain points, and their actual words.

This is what I meant in [The Missing Half of AI-Assisted Development]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %}) when I wrote that vague product thinking produces vague specifications which produce vague code. Customer discovery is how you make product thinking precise. Not by being smarter or more creative, but by grounding every decision in evidence from the people you're building for.

The traceability chain I described in my [post on AI drift]({% post_url 2026-02-25-ai-drift-is-a-product-problem %}) starts here. If you can't trace a feature back through the specification, through the PRFAQ, through the use case, through the persona, to a specific customer conversation, that feature is at risk of drift at every layer.

| Pipeline Stage | Discovery Input | What It Produces |
|----------------|----------------|------------------|
| Personas | Role patterns, company stages, workflow descriptions | Composite customer profiles with real pain points |
| Use Cases | Workflow walkthroughs, "a day in the life" descriptions | Concrete interaction scenarios |
| PRFAQ | Key quotes, strongest signals, success criteria | Press release grounded in real customer language |
| Feature Map | Pain frequency, severity rankings, prior solution attempts | Priority-ordered feature list |
| Specifications | Success criteria answers, acceptance language | Testable requirements in EARS format |

## Common mistakes

Having done this wrong before doing it right, here are the failure modes I've seen and made.

**Leading with the demo.** I've covered this, but it bears repeating because the pull is strong. Demos are valuable, but they're most effective after you've listened. Lead with discovery, and the demo lands harder because you know what to emphasize.

**Asking leading questions.** "Don't you think AI-assisted development tools should integrate with your specification pipeline?" is not a discovery question. It's a validation question wearing a discovery hat. Ask open-ended questions. "How do your specifications get from the product team to the engineering team?" Let them tell you.

**Talking too much.** The ratio should be 80/20 in favor of the customer talking. If you're explaining your product for more than 20% of the conversation, you're doing it wrong. I time myself. It's humbling.

**Ignoring the workarounds.** When a customer says "oh, we just use a spreadsheet for that," pay attention. That spreadsheet is your real competitor. Understand what it does, why it works, and what's missing. The path from their spreadsheet to your product is your adoption strategy.

**Not tracking systematically.** The first three conversations are easy to remember. By conversation ten, details blur together. By conversation twenty, you've lost critical nuance. Track everything. Summarize regularly.

**Stopping too early.** Five conversations isn't enough. You'll think it is, because by conversation five you're hearing patterns and feeling confident. That confidence is premature. Conversations six through fifteen are where the patterns get tested and the nuances emerge. Twenty conversations is where the map of the problem space starts to stabilize.

## Why I love doing this

I want to be direct about something. Customer discovery is not a chore. It's the most energizing part of building a company.

Every conversation teaches me something I didn't know. Every customer has built workarounds and mental models that I never would have imagined. The creativity that teams apply to solving their own problems, with duct tape and spreadsheets and Slack bots and manual processes, is remarkable. Understanding those solutions tells you more about the problem than any abstract analysis ever could.

There's a specific moment in most discovery conversations that I've come to look forward to. It happens when the customer stops answering your questions and starts thinking out loud. They're no longer being interviewed. They're working through their own problem, using you as a sounding board, and the insights that emerge in those moments are extraordinary. You can't get there with a survey. You can't get there with analytics. You can only get there by sitting with someone, asking the right questions, and giving them space to think.

After twenty-plus conversations this month, the product vision is sharper than it's ever been. The 18 months of building gave me the technical depth to ask the right questions and recognize the significance of the answers. The discovery conversations gave me the customer language, the priority ordering, and the specific refinements that turn a strong thesis into a product people will pay for. The building and the discovery compound on each other.

## The bottom line

Customer discovery is the highest-leverage activity an early-stage startup founder can do. It's not a phase you complete and move past. It's a practice you maintain throughout the life of the company.

The mechanics are simple. Talk to potential customers. Ask open-ended questions. Listen. Track everything. Synthesize patterns. Feed what you learn into your development process so that every feature traces back to a real customer conversation.

The principle is even simpler. Understand the customer before the customer understands you. Resist the urge to demo. Resist the urge to pitch. Resist the urge to validate. Seek to understand. The validation comes naturally when you build something grounded in what you heard.

I've spent 25 years building infrastructure and software at scale. I've shipped products used by millions of people. And the most valuable thing I've done in the last month is sit in conversations and listen.

If you're building something and you haven't done twenty discovery conversations, stop what you're building and go do them. The product you build after those conversations will be fundamentally different from, and better than, the product you would have built without them.

Start with the customer. Work backwards. Everything else follows.

---

*David Lapsley, Ph.D., is Founder and CEO of ShipKodeAI. He has spent 25+ years building infrastructure platforms at scale. Previously Director of Network Fabric Controllers at AWS (largest network fabric in Amazon history) and Director at Cisco (DNA Center Maglev Platform, $1B run rate). He writes about AI infrastructure, AI-accelerated SDLC, and the gap between POC and production.*

## References

[1] MIT NANDA Initiative, "The GenAI Divide: State of AI in Business 2025" (2025), [link](https://fortune.com/2025/08/18/mit-report-95-percent-generative-ai-pilots-at-companies-failing-cfo/)

[2] Lapsley, D., "The Missing Half of AI-Assisted Development" (2026), [link]({% post_url 2026-02-19-the-missing-half-of-ai-assisted-development %})

[3] Lapsley, D., "Amazon's Working Backwards SDLC for SMBs" (2026), [link]({% post_url 2026-02-17-amazon-working-backwards-sdlc-for-smbs %})

[4] Lapsley, D., "From PRFAQ to Backlog: Working Backwards as AI Pipeline" (2026), [link]({% post_url 2026-02-21-from-prfaq-to-backlog-working-backwards-as-ai-pipeline %})

[5] Lapsley, D., "AI Drift Is a Product Problem, Not an Engineering Problem" (2026), [link]({% post_url 2026-02-25-ai-drift-is-a-product-problem %})

[6] Lapsley, D., "Spec-Driven LLM Development (SDLD)" (2026), [link]({% post_url 2026-01-11-spec-driven-development-with-llms %})

[7] Bryar, C. & Carr, B., *Working Backwards: Insights, Stories, and Secrets from Inside Amazon* (2021)

[8] Fitzpatrick, R., *The Mom Test: How to talk to customers & learn if your business is a good idea when everyone is lying to you* (2013)
