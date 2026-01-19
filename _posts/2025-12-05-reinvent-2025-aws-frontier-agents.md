---
title: "re:Invent 2025: AWS Frontier Agents and Developer Tools"
date: 2025-12-05
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - AI
  - Cloud
  - Engineering
tags:
  - aws
  - reinvent
  - agentic-ai
  - kiro
  - bedrock
  - devops
---

Last day at re:Invent. Want to share notes on the AWS developer tools announcements.

AWS announced three "frontier agents": Kiro autonomous agent, AWS Security Agent, and AWS DevOps Agent. The premise is they can work autonomously for extended periods rather than just assist with individual tasks.

## What they announced

### Kiro autonomous agent

Maintains context across repos, pipelines, and tools (Jira, GitHub, Slack). Can handle multiple tasks over extended periods. They introduced "Kiro powers" with partnerships (Datadog, Dynatrace, Figma, Neon, Netlify, Postman, Stripe, Supabase) for tool-specific expertise via dynamic loading.

### AWS Security Agent

Automated application security reviews and penetration testing throughout development lifecycle. Includes design consultation and code reviews.

### AWS DevOps Agent

Incident triage, guided resolution, and reliability improvements across AWS, multicloud, and hybrid environments.

### Amazon Bedrock AgentCore

Framework-agnostic infrastructure layer (supports CrewAI, LangGraph, LlamaIndex, OpenAI SDK, Strands Agents). New capabilities:

- Policy enforcement that blocks unauthorized agent actions
- 13 prebuilt evaluations (correctness, faithfulness, tool selection accuracy, etc.)
- Episodic memory for learning over time

### Strands Agents in TypeScript

Open-source framework (3M+ Python downloads) now supports TypeScript with AWS CDK integration and edge device support.

## Why this matters

The interesting part is the end-to-end coverage: development, security, and operations in one ecosystem. Framework-agnostic, so you can use your preferred tools and models (including OpenAI and Gemini).

Looking forward to testing these in practice. If the autonomous capabilities work as described, they could significantly accelerate the SDLC. The real question is how well they handle the context switching and complexity of actual production environments.

All three agents are in preview. Worth evaluating if you're working on production AI systems.
