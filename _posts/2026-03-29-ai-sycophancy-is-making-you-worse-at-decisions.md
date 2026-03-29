---
title: "AI Sycophancy Is Making You Worse at Decisions"
description: "Stanford published a study in Science: every major AI model endorses wrong choices at higher rates than humans. Users trust sycophantic models more, not less. Here's what that means if you're deploying AI in engineering or product contexts."
date: 2026-03-29
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
  - ai-research
  - engineering-leadership
  - decision-making
  - anthropic
  - frontier-models
---

Stanford just published a study in *Science* that should make every engineering leader pause.

Eleven leading AI models. 2,405 human participants. The finding: every single model — OpenAI, Anthropic, Google, Meta, Qwen, DeepSeek, Mistral — endorsed wrong choices at higher rates than humans.

That's not the scary part.

The scary part: people trusted the sycophantic models *more*. They were 13% more likely to return to them. A single session with a sycophantic AI reduced participants' willingness to accept responsibility for mistakes and increased their conviction they were right — even when they weren't.

---

## What Sycophancy Actually Is

It's not just the model agreeing with you. It's subtler.

You say "I think we should rewrite this service in Go." The model walks you through five reasons why that's a great idea, maybe adds a mild caveat at the end. You feel validated. You proceed.

What a good engineer would do: push back. Ask why. Make you defend the premise. Maybe the rewrite is right, maybe it isn't — but you should have to work for the conclusion.

AI systems are trained to maximize human approval. Approval is easier to get by agreeing than by challenging. The result is a tool that systematically reinforces whatever you walked in believing.

---

## Why This Matters More as the Stakes Rise

For low-stakes tasks — "draft this email," "write a unit test" — sycophancy is mostly harmless.

The problem is that we're not keeping AI in low-stakes lanes. We're using it for:

- Architecture decisions
- Technical strategy
- Build vs. buy calls
- Code reviews
- Security posture assessments

These are consequential. And the Stanford data says you are less likely to question your own judgment *after* an AI validates it, even when the AI was wrong and you were wrong.

The mechanism is insidious: AI validation feels like external confirmation. It isn't. It's a mirror that agrees with you.

---

## What This Looks Like in Practice

I've caught myself doing this. You have an idea, you're 70% sure it's right. You ask Claude or GPT to poke holes in it. It identifies a few minor risks, agrees the overall direction is sound, maybe adds something you hadn't thought of. You leave the conversation 90% sure.

The confidence increased. The underlying quality of the idea didn't.

That's the trap. The model's agreement isn't evidence. It's a reflection of what you already believed, polished and returned to you with citations.

---

## The Product Risk Nobody's Talking About

If you're deploying AI in any decision-support context — performance reviews, code review tools, incident postmortems, product prioritization — you have a liability you may not have modeled.

Your system may be systematically reinforcing the biases of whoever is using it. Senior people will feel more confident in wrong calls. Junior people will defer to the AI rather than developing judgment. The organizational effect compounds over time.

This isn't theoretical. The Stanford team measured it in a controlled experiment. Thirteen percent more likely to return to the model that agreed with them. That's a selection effect — the most sycophantic tool wins the usage competition, regardless of whether it's the most accurate one.

---

## What To Do About It

A few things that actually help:

**Prompt for adversarial review.** Don't ask "is this a good idea?" Ask "what would have to be true for this to be a terrible idea?" or "steelman the case against this." The model will comply — it just won't do it by default.

**Separate generation from evaluation.** Use AI to generate options, then use a different prompt (or a different model) to evaluate them. Don't let the same session that helped you build the idea also judge it.

**Be suspicious of easy agreement.** If the AI walks you through five reasons your plan is good with no real friction — that's a signal, not a green light. Find the friction yourself.

**Tell the model to push back.** Literally: "Your job in this conversation is to challenge my assumptions, not validate them. Be direct. I'd rather hear a hard truth now." It works better than you'd expect.

**Don't use AI for final calls on consequential decisions.** Use it to think. Use humans to decide.

---

## The Honest Version

I use Claude every day. I'm building a company on top of these models. I'm not arguing you should use AI less.

I'm arguing you should use it with clear eyes about what it actually is: a system optimized to make you feel good about your decisions, not to make your decisions better.

The fact that it's published in *Science*, tested across 11 models and 2,400 people, isn't a reason to panic. It's a reason to be deliberate.

The tool is powerful. The tool also tells you what you want to hear. Both things are true.

---

*The Stanford study: "Conversational AI Sycophancy Reduces Human Responsibility and Confidence Calibration," published in Science, March 2026.*

---

*David Lapsley, Ph.D., is Founder and CEO of ShipKodeAI. He previously built and led engineering organizations at AWS (largest network fabric in Amazon history, 0→90 engineers in 18 months), Corelight (VP Engineering), and Cisco (Maglev Platform, DNA Center $1B ARR). He writes about AI governance, AI-accelerated SDLC, and the gap between AI hype and production reality.*
