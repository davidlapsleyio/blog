---
title: "AI Agents Are Finding Vulnerabilities Faster Than You Can Patch Them"
description: "AI agents are finding 5-10 new Linux kernel vulnerabilities per day. The gap between discovery speed and patch speed is the new risk frontier for every CTO."
date: 2026-04-04
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
toc: true
toc_label: "Contents"
toc_icon: "list"
toc_sticky: true
categories: [AI, Security, Vulnerability-Research]
---

The Linux kernel security list used to receive 2-3 bug reports per week. That was two years ago. Last year it was 10 per week. This year it is 5-10 per day.

Greg Kroah-Hartman, the Linux kernel maintainer, confirmed the shift publicly about a month ago. The change was not gradual. It was a step function. And the reports are not AI slop anymore. They are real, high-quality vulnerability reports from AI agents that can read code, understand control flow, trace data dependencies, and identify exploitable patterns at a scale and speed that no human reviewer can match.

Willy Tarreau, maintainer of HAProxy, noted that duplicate reports are now common. Multiple AI agents, running independently against the same codebase, finding the same vulnerability at the same time. This is not theoretical. This is happening right now, every day, on one of the most security-critical codebases in the world.

## The Implication for Every CTO

Your attack surface is being scanned 24/7 by autonomous agents that do not sleep, do not take vacation, and do not bill by the hour. They are working for security researchers, for competitors, for nation-state actors, and for anyone with a GPU and a public GitHub repository. The discovery side of the equation has already shifted to AI speed. The patch side has not.

Most engineering organizations are built for human-speed vulnerability management. A report comes in. A triage happens. A developer is assigned. A fix is written, reviewed, tested, and deployed. This process takes days or weeks. AI vulnerability discovery takes minutes.

The gap is widening daily.

## What Is Actually Happening

Thomas Ptacek, a well-known security researcher, wrote an essay that has been circulating widely in the security community. His argument is straightforward: vulnerability research is "cooked." Not in the sense that it is over—that it has fundamentally changed to the point where the human's role in the discovery process is becoming optional.

The Linux kernel is the most scrutinized piece of software on the planet. If AI agents can find 5-10 new vulnerabilities per day in the Linux kernel, they can find vulnerabilities in your codebase too. The only question is whether they are looking at it.

## The Real Cost

I have spent my career in network security. I led the team that built Corelight's network detection platform using Zeek, and I have two US patents in real-time network attack detection. I have seen vulnerability management from both sides: as a defender building detection systems, and as a leader responsible for shipping secure products.

The most expensive vulnerability is not the one that gets exploited. It is the one you did not know existed. The shift from human-speed to AI-speed discovery changes the risk calculus fundamentally. Every organization that ships software now has to assume their code is being actively scanned by AI agents that will find things before humans do. The question is not whether there are vulnerabilities in your codebase. The question is whether someone else finds them before you patch them.

## What This Means for Security Teams

The traditional model of vulnerability management is designed for human-scale discovery. That model is obsolete. The new model requires three things that most organizations do not have yet.

First, AI-native threat modeling. Security teams need to be using the same AI tools that attackers use to find vulnerabilities. This is not optional. If your red team is still manually auditing code while attackers use autonomous agents, you are optimizing for the wrong threat model.

Second, patch velocity that matches discovery velocity. The gap between how fast vulnerabilities are found and how fast they are patched is the exploitation window. That window is widening. Reducing it requires investment in automated testing, canary deployments, and rollback infrastructure that most organizations treat as nice-to-haves rather than critical infrastructure.

Third, a strategy for AI-augmented security engineering. Security products now operate in a world where the threat landscape itself is AI-native. The tools used to find vulnerabilities have changed. The tools used to defend against them must change too.

If you are thinking about this problem at your organization, I would love to hear how you are approaching it. Find me on LinkedIn or reach out through the usual channels.