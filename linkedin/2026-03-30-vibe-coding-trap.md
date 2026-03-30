# LinkedIn Post - March 30, 2026

---

A team ported a full Go implementation of JSONata last week.

7 hours. $400 in token spend. Saves an estimated $500K/year.

Claude Code and Codex, iterating against the existing test suite until it passed.

The story everyone's sharing is "AI coding agents are incredible."

The more important story is buried: **the test suite was the enabling factor.**

No tests? No 7-hour port. You get 7 hours of plausible-looking code that fails in production in ways nobody predicted.

---

This is the vibe coding trap.

The popular take is that vibe coding means architecture doesn't matter anymore. You describe what you want, the agent builds it, you ship.

Matt Webb's essay (circulating this week) gets it right: "While I'm vibing, I am looking at lines of code less than ever before, and thinking about architecture more than ever before."

Vibe coding doesn't eliminate architecture. It amplifies the consequences of having it or not.

---

**Here's why:**

A human engineer working in a messy codebase slows down. They feel friction. They push back or work around problems. The mess becomes legible as a constraint.

An agent doesn't slow down.

In a clean codebase with good test coverage and clear conventions, an agent builds code that fits. It extends the architecture naturally.

In a tangled codebase with inconsistent patterns and implicit design decisions, an agent extends the tangle at full speed. Faster than a human would. Which means the debt compounds faster.

Good architecture accelerates agentic development.
Bad architecture accelerates agentic debt accumulation.

---

**The three artifacts that matter:**

→ **Tests** that cover behavior, not implementation details. This is what gives agents a ground truth to iterate toward. Without it, you're reviewing every line manually and the speed advantage evaporates.

→ **Legible conventions** -- naming, error handling, module structure. Agents reproduce what they see in context. If your codebase has three different patterns for the same thing, agents will pick one. Maybe not the one you wanted.

→ **Written design decisions.** Every decision that lives only in a senior engineer's head is ambiguity the agent fills with a plausible default. "We paginate at 100 because downstream has a hard limit" needs to be somewhere the agent can see it.

---

**The org shift:**

The engineers with the most leverage in an agentic-first team aren't the fastest coders. They're the ones who can decompose product intent into specifications an agent can execute correctly the first time, and evaluate agent output against stated intent rather than just checking if it compiles.

That's closer to product architecture than to IC coding.

---

Four frontier models shipped in 23 days this month. MCP crossed 97 million installs. Linear declared issue tracking dead. JetBrains pivoted to agentic dev.

The production threshold isn't approaching. It's here.

The teams that will win aren't the ones moving fastest today. They're the ones that built the foundations that let them move fast safely.

---

Full post with the deep dive: [link in comments]

#engineering #agentic #vibecoding #architecture #cto #aigovernance #softwaredevelopment

---

*[Add blog post URL as first comment]*
