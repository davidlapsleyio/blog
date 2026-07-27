---
title: "What AWS Taught Me About Automating Expert Judgment"
description: "Lessons from building AWS's intent-driven networking and network fabric controller teams, and what they teach us about automating expert judgment with AI."
date: 2026-07-27
categories:
  - Engineering
  - AI
  - Infrastructure
tags:
  - aws
  - intent-driven-networking
  - ai-infrastructure
  - automation
  - agentic-ai
---

From 2021 to 2024, I led teams at AWS whose entire job was to take the
judgment of the world's best network engineers and turn it into
software. I was hired to build the AWS Intent Driven Networking (AIDN)
team from scratch, and later formed the Network Fabric Controllers
organization, bringing AIDN, Scalable Intent Driven Routing (SIDR),
and several other control-plane teams together under one roof.

Some scope before anything else, because "the AWS network" is a phrase
that invites overclaiming. Amazon's networking organization is
enormous, and it splits across very different problem domains: the
border, the backbone, the edge, the data center. I worked in the data
center part of it, specifically on data center fabrics. AIDN and SIDR
were one set of systems among many operating that vast network, and
other organizations ran their own control and management systems for
the parts I never touched. What AIDN and SIDR became, together, was
the management and control plane for the largest network fabric in
Amazon's history. Big claim, bounded scope. The bounding matters for
everything that follows, because the lessons below come from one
domain, not from the whole network.

Credit where it belongs before I go further. AIDN was the vision of
Stephen Callaghan, one of our senior Principal Engineers, and SIDR was
the vision of another, JR Rivers. My job was to build and lead the
teams that turned their combined vision into production systems
operating Amazon's data center fabrics at scale, and I had exceptional
engineers to do it with. And to be clear about what "leading" meant:
I wasn't just running the program. I spent much of those three years
in the technical work itself, in design reviews, architecture debates,
and operational deep dives alongside the PEs and the teams. That's
where most of the lessons below come from.

I didn't think of it in these terms at the time, but this is exactly
what everyone building with AI is trying to do right now: capture
expert judgment and put it inside a system that can execute it faster,
more consistently, and at greater scale than the experts themselves.
The fabric got there without LLMs. The lessons from that journey map
almost one-to-one onto the problems AI teams are hitting today.
Most of those teams are earlier in the journey than they think.

## The bottleneck was never bandwidth. It was judgment.

By 2021, data center fabric operations had a problem that no amount of
hardware could fix. The systems used to run the fabrics had grown
organically over more than a decade, alongside the separate systems
other parts of the network relied on, with little shared structure
between them. Critical operational knowledge was spread across
multiple systems, none of which was authoritative. The same
information was duplicated in different places, in different formats,
with no guarantee the copies agreed. And the whole apparatus was
reaching its limits. Not in packets per second, but in *operations*
per second. The constraint on growth was how fast humans could safely
decide things: how to route around a failure, when to shift traffic
off a device, whether a change was safe to push.

That's why AIDN existed. Stephen had the vision, and I was brought in
to build the team, greenfield, with a mandate the job postings later
described accurately: completely re-imagine how one of the largest
networks on the planet would be operated for the next decade. In
practice, that meant the fabric layer. Ambitious enough.

But AWS had already tried to automate this judgment once. The way that
first attempt fell short taught me more than the eventual solution
did.

## The YAML era: capturing judgment is not automating it

Before AIDN, fabric engineering judgment *had* been captured, in
infrastructure-as-code. Routing policy decisions, for example, lived
in what amounted to a lightweight wrapper around BGP policy, expressed
as a large collection of YAML files in a git repo.

On paper, this looks like automation. The expert's decision is written
down, version-controlled, reviewable, repeatable. In practice, it was
reaching the end of its life. The YAML was surprisingly hard to
maintain. It was hard to test; you couldn't easily answer "what does
the network do if I merge this?" It was hard to keep well-structured
and normalized, and the repo accumulated near-duplicates and special
cases the way all shared config repos do. Every change still required
an expert to hold the whole system in their head. The reason is worth
stating plainly: those files captured code and configuration, not
intent. They were the *output* of expert judgment, rendered in a
machine-applicable format. The judgment itself, the reasoning that
produced the configuration, never made it into the artifact.

And to be clear, this wasn't a naive setup. There were real safety
systems wrapped around those repos: CI/CD pipelines, validation
checks, deployment automation. The problem is that guardrails built
beside the artifact scale no better than the artifact itself. The
pipelines took a long time to run, which meant engineers waited hours
to learn whether a change was safe. They grew fragile as the config
sprawled, breaking in ways that had nothing to do with the change
under test. And bugs still crept through and got deployed, because the
checks could only inspect the configuration, not the intent behind it.
You can't verify that a change does what the expert meant when the
system has no representation of what the expert meant. The safety net
had the same operational-scalability ceiling as the YAML it guarded.

That's the distinction that matters. A YAML file that says "prefer
this path" captures a decision. It doesn't capture *why*, under what
conditions the decision holds, or how to verify it's still correct. So
every time conditions changed, a human had to re-derive the reasoning
and update the artifact. We had automated the typing, not the
thinking. And it was hitting the same wall as manual operations. It
just hit it a few years later.

None of this is a knock on AWS, and none of it is unique to Amazon.
Every large infrastructure organization I've worked in or with has a
version of this repo, and most of them are in far worse shape. AWS
almost certainly operates networks better than anyone else on the
planet. That's the point worth sitting with. This ceiling is not a
symptom of doing infrastructure badly. It is what you hit *after* you
have done everything else right, and it shows up first at the
organizations furthest along. If the best network operators in the
world had to build their way past it, the odds that your prompt repo
escapes it are not good.

If you're building with LLMs today, you should recognize this era,
because you're probably living in it. A prompt is a YAML file. It is
the rendered output of expert judgment, not the judgment: hard to
test, hard to keep normalized, silently accumulating special cases,
and still dependent on the original expert to maintain. Prompt
libraries are the config repos of AI. They're a real step forward, and
they will hit exactly the same wall. So will the CI bolted on beside
them, if what it checks is the artifact rather than the intent: slow
eval suites that gate every change, grow brittle as the prompt
sprawls, and still
let regressions through because they don't encode what the expert
actually wanted.

## What AIDN did differently

AIDN's answer, visible now in AWS's [re:Invent NET401 talk](https://d1.awsstatic.com/events/Summits/reinvent2023/NET401-R_AWS-journey-toward-intent-driven-network-infrastructure-REPEAT.pdf) and the [intent-driven network management patent family](https://patents.justia.com/patent/12155530), was to stop
encoding decisions and start encoding *intent*: the operational
outcome the expert wants, declared formally, without specifying how to
achieve it. "Traffic between hosts in this zone never leaves this
zone" is an intent. The thousands of device configurations that
enforce it are the system's problem, not the engineer's.

Three properties made this work, and I'd argue all three are
non-negotiable for any system that automates expert judgment, network
or AI.

**It was authoritative.** Every applied intent went into a
transactional journal: a single source of truth recording what was
intended, when it was approved, and when the network converged to it.
This is precisely what the pre-AIDN world lacked. Duplicated,
non-authoritative state is where automated judgment goes to die,
because when two systems disagree about what should be true, a human
gets pulled back in to arbitrate. At that point your automation is a
suggestion.

**It was verified before it acted.** Proposed intents didn't go
straight to the network. They passed admission control:
simulation-based functional verification, conflict detection against
every intent already in the journal, change-control and SLA checks.
Judgment was tested the way code is tested. Before deployment,
automatically, every time.

**It was verified after it acted, forever.** The system continuously
compared observed network behavior against the journal's intended
behavior. When they diverged, it could roll back the transaction,
adjust, or escalate to a human. The loop is closed. Nobody assumes the
automated judgment stays correct; the system checks.

Notice what's absent from that list: intelligence. AIDN's translation
layer, the compilers turning intents into device-native artifacts, was
sophisticated, but it wasn't the source of trust. The trust came from
the journal, the admission checks, and the drift correction. That's
the part AI builders keep getting backwards. Teams pour effort into
making the model smarter and treat evaluation as an afterthought, when
the AWS lesson is that *the verification machinery is the product*.
The intelligence is replaceable.

## SIDR: deciding where the judgment lives

SIDR, the system JR envisioned and whose team I later inherited,
solved a different judgment problem: not "what should the network do?"
but "who decides, and how fast?"

SIDR is the routing protocol behind AWS's 10p10u fabric, the network
that gives massive Trainium UltraClusters ten petabytes of capacity at
under ten microseconds of latency. At that scale, during AI training,
every server talks to every other server simultaneously, and a link
failure has to be routed around in well under a second. No human is in
that loop. No *central system* can even be in that loop; the speed of
light won't allow it.

Peter DeSantis walked through SIDR's architecture in his [re:Invent 2024 Monday Night Live keynote](https://www.networkworld.com/article/3617188/aws-upgrades-its-10p10u-network-to-handle-massive-ai-clusters.html). A
central planner with global visibility distills the network's
structure into directives and pushes them to every switch, and each
switch then makes its own local decisions when a failure occurs.
Expensive, slow, context-rich judgment happens centrally and rarely.
Cheap, fast, local judgment happens at the edge, constantly, within
guardrails the planner computed. The result is failure response in
under one second, roughly ten times faster than the alternatives.

That decomposition, plan centrally, execute locally, constrain the
executor, is the right mental model for agentic AI systems. The
mistake I see constantly is putting all the judgment in one place:
either a single monolithic agent making every decision (slow,
expensive, a single point of failure) or fully autonomous sub-agents
with no shared plan (fast, and incoherent). The systems that work
distill global intent into local guardrails, then let execution run
free inside them.

## The org lesson: teams must own the whole loop

In 2023 we made a call: AIDN and SIDR were too tightly coupled to live
in separate organizations, and SIDR was solving hard problems that
deserved a dedicated leadership focus it couldn't get while the loop
was split across org boundaries. We merged them, along
with several other software controller teams, into a single group:
Network Fabric Controllers. Together, those systems became the
management and control plane for the largest network fabric in
Amazon's history.

The technical logic was simple. An intent system that can't control
routing, and a routing system that doesn't know intent, are each half
of a control loop. But the deeper lesson was organizational. When you
automate expert judgment, the unit of ownership has to be the *entire
loop*: intent, translation, execution, observation, correction. Split
the loop across team boundaries and every drift incident becomes a
cross-team negotiation, which means the loop effectively isn't closed
at all.

AI teams are recreating this mistake today. One team owns prompts,
another owns the model, a third owns evals, and nobody owns drift in
production. If your eval team and your agent team file tickets at each
other, you don't have a closed loop. You have YAML with extra steps.

## Where this leaves us

Automating expert judgment is not a new problem, and it isn't
primarily a model-capability problem. AWS automated the judgment of
elite network engineers using deterministic software, and the hard-won
structure was: make the judgment explicit and declarative; store it in
one authoritative, transactional place; verify before acting; watch
for drift forever; put slow judgment in the center and fast judgment
at the edge; and organize teams around whole control loops.

LLMs change the economics of the translation layer. The part that
turns intent into action is now shockingly general. What they don't
change is everything around it. Most AI systems in production today
are at the YAML stage: captured judgment, no admission control, no
journal, no drift detection, open loops everywhere. The teams that
internalize the rest of the structure first are going to operate their
AI the way AWS operates its fabrics: declaratively, verifiably, and at
a scale where the experts' judgment outlives the experts'
availability.

That's the work I'm doing now. The network was just the first fabric.

## References

- Stephen Callaghan, [AWS's journey toward intent-driven network infrastructure (NET401)](https://d1.awsstatic.com/events/Summits/reinvent2023/NET401-R_AWS-journey-toward-intent-driven-network-infrastructure-REPEAT.pdf), AWS re:Invent, 2023.
- Amazon Technologies, [US 12,155,530: Intent-driven network management](https://patents.justia.com/patent/12155530), granted 2024, and [US 2025/0175479](https://patents.justia.com/patent/20250175479), published 2025.
- Peter DeSantis, Monday Night Live keynote, AWS re:Invent, 2024, via [Network World's coverage of 10p10u and SIDR](https://www.networkworld.com/article/3617188/aws-upgrades-its-10p10u-network-to-handle-massive-ai-clusters.html), 2024.
- [Sr. Software Dev Engineer, Intent Driven Network](https://www.amazon.jobs/en/jobs/3016585/sr-software-dev-engineer-intent-driven-network), Amazon.jobs.

---

> David Lapsley, Ph.D., is Founder and CEO of
> ShipKodeAI. Over a 26-year career, he has spent 15
> years building infrastructure and platform products.
> Previously Director of Network Fabric Controllers at
> AWS, the team that powered the largest network fabric
> in Amazon's history, and Director at Cisco (DNA Center
> Maglev Platform, $1B run rate). He writes about AI
> infrastructure, AI-accelerated SDLC, and the gap
> between POC and production.
