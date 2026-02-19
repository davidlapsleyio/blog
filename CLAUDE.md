# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Jekyll-based personal blog deployed to GitHub Pages at https://blog.davidlapsley.io. Uses the **minimal-mistakes-jekyll** theme (v4.27.3).

## Commands

All development uses Docker via the Makefile:

```bash
make install   # Build Docker image (first time setup)
make serve     # Dev server at http://localhost:4000 (live reload on :35729)
make build     # Production build
make clean     # Remove _site/, .jekyll-cache/, .jekyll-metadata
make doctor    # Check Jekyll environment
make update    # Rebuild Docker image without cache
```

## Architecture

- **_config.yml** — Jekyll configuration: theme, plugins, author info, defaults, pagination
- **_posts/** — Blog posts as `YYYY-MM-DD-title.md` with YAML front matter
- **_pages/** — Static pages (categories, tags, search, about)
- **_includes/** — Custom HTML overrides (SEO structured data, analytics, nav)
- **_data/navigation.yml** — Site navigation menu
- **assets/** — Images and SCSS styling (`assets/css/main.scss`)
- **.working/** — Draft/WIP content (git-ignored)

## Blog Post Front Matter

Posts use this front matter structure:

```yaml
---
title: "Post Title"
description: "Brief description for SEO"
date: YYYY-MM-DD
layout: single
author_profile: true
read_time: true
comments: false
share: true
related: true
categories:
  - Engineering    # e.g., Engineering, Leadership, AI, Cloud, Career, Infrastructure
tags:
  - relevant-tag
---
```

Default values for posts (set in `_config.yml`): `layout: single`, `author_profile: true`, `read_time: true`, `toc: true` with sticky table of contents. You only need to specify values that differ from defaults.

## Writing Style and Tone

### Voice
- **Practitioner-to-practitioner**: Write as someone who has shipped systems at scale, not as a vendor or academic. Ground claims in experience ("I've seen this pattern dozens of times") rather than theory.
- **Authoritative but humble**: Confident in hard-won lessons, honest about trade-offs, willing to say "your situation might be different."
- **Anti-marketing**: Never use superlatives like "revolutionary," "game-changing," "seamless," "leverage," "synergy," "cutting-edge," "best-in-class," or "AI-powered."
- **Active voice preferred**: "GPU pooling reduces costs by 50-70%" not "Cost reductions can be achieved through GPU pooling."

### Sentence Structure
- **Vary rhythm intentionally**: Short sentences for impact ("The IDE is a shell."), medium for explanation, longer for nuance.
- **Use sentence fragments for emphasis**: "Not obvious. Not prevalent in your team."
- **Prefer periods over em dashes or semicolons** to break ideas into digestible chunks.
- **No em dashes** (`--` or `—`). Use commas, periods, colons, or parentheses instead.
- Rarely exceed 25 words per sentence unless building a complex thought.

### Specificity Over Vagueness
- Replace vague claims with concrete numbers: "$285K/month for 5 production models" not "significant costs."
- When citing statistics, always include the source and year.
- Quantify timelines and costs: "18 months, $500K hardware investment" not "extended timeline."

### Post Structure
1. **Opening hook** (1-3 paragraphs): Problem or surprising stat, why the reader should care, clear thesis statement.
2. **Problem definition**: Data-backed, with key insight in a blockquote or bold.
3. **Framework/solution**: Multiple sections building the argument with concrete examples (code, specs, tables, comparison matrices).
4. **Best practices AND anti-patterns**: Show both what to do and what not to do.
5. **Actionable conclusion**: Specific next steps, not abstract wisdom. Often ends with a short punchy line.
6. **References section**: All sources cited with links and year.
7. **Author bio**: Boilerplate at the end after a horizontal rule.

### Formatting Conventions
- **Bold** for key terms on first use, critical numbers, and important takeaways. Max 3-4 bolded elements per section.
- **Italic** for formal definitions and phrases deserving a second read. Used sparingly.
- **Tables** for comparisons (before/after, option A vs. option B, with vs. without).
- **Bulleted lists** for parallel ideas; **numbered lists** for sequential steps.
- **Blockquotes** for key insight callouts.
- **Links** are contextual ("in my post on [Spec-Driven Development](url)"), never "click here."
- **Line length**: ~60-70 characters for markdown source files.
- Horizontal rules (`---`) separate major sections.

### Recurring Rhetorical Patterns
- **Problem-first framing**: Open with the gap or pain, not the solution.
- **Contrast pattern**: "Teams that do X fail. Teams that do Y succeed."
- **Personal grounding**: "I learned that..." / "I've built..." / "In my experience..."
- **Trade-off honesty**: Always acknowledge costs and limitations of proposed solutions.
- **Transition phrases**: "But here's...", "The key insight is...", "This is where...", "What actually matters..."

### What to Avoid
- Marketing buzzwords and superlatives
- Hedge language when data is available ("many companies struggle" → use the actual stat)
- Over-claiming: never say the approach is always right
- Filler content: every sentence must earn its place
- Emojis (unless explicitly requested)

## Deployment

Pushes to `main` trigger GitHub Actions (`.github/workflows/jekyll.yml`) which builds with Jekyll and deploys to GitHub Pages. Custom domain configured via `CNAME` file.

## Custom Includes

- **head-custom-seo.html** — JSON-LD schema.org structured data (BlogPosting, Person, BreadcrumbList)
- **head-custom-google-analytics.html** — Google Tag Manager
- **head-custom-theme-colors.html** — Theme color meta tags
- **masthead.html** — Navigation bar override
