# Metadata Format Guide

*Last updated: 2026-03-16*

Deep-dive reference for YAML frontmatter, file naming, and category conventions. Read when creating new source files or auditing existing ones for compliance.

---

## Full YAML Frontmatter Template

Every file in `Library/Sources/` must begin with this block. All fields are required unless marked optional.

```yaml
---
title: "Descriptive title of the source"
source_url: https://original-url-of-the-content
category: primary-category-name
tags: tag1, tag2, tag3
relevant_agents: agent1, agent2, agent3
fetched_date: YYYY-MM-DD
content_type: guide
difficulty: intermediate
description: "One-line description used in index listings. Concise and specific."
keywords: searchable, terms, that, help, agents, find, this
copyright_notice: "See Library/Sources/Legal/FETCHING_DISCLAIMER.md"
quality_note: ""
---
```

### Field Definitions

| Field | Format | Description |
|-------|--------|-------------|
| `title` | Quoted string | Human-readable title. Mirror source title or write a descriptive one. |
| `source_url` | Full URL | Canonical URL of original content. Never omit. |
| `category` | Lowercase, hyphenated | Primary category (determines folder location). One value only. |
| `tags` | Comma-separated | 3-6 tags for cross-referencing. Lowercase, descriptive. |
| `relevant_agents` | Comma-separated | ALL agents who would benefit from this source. See domain list below. |
| `fetched_date` | YYYY-MM-DD | Date Fetcher captured this content. |
| `content_type` | Enum (see below) | Nature of the content. Pick the closest match. |
| `difficulty` | Enum (see below) | Assumed knowledge level of the target reader. |
| `description` | Quoted string | Used verbatim in index listings. One sentence. Start with a verb or noun phrase. |
| `keywords` | Comma-separated | Additional search terms. Include synonyms and related concepts. |
| `copyright_notice` | Fixed string | Always use the value shown. Points to the disclaimer file. |
| `quality_note` | Quoted string | Optional. Add if source has caveats. Leave empty string `""` if clean. |

---

## Content Type Taxonomy

| Value | Use When |
|-------|---------|
| `guide` | Step-by-step explanations, how-to documents, practical walkthroughs |
| `reference` | API docs, specification tables, command references, cheat sheets |
| `tutorial` | Hands-on, code-along learning material |
| `standard` | RFC, W3C spec, OWASP standard, ISO, legal regulation text |
| `case-study` | Real-world examples, postmortems, production stories |
| `comparison` | Side-by-side analysis of tools, approaches, or technologies |
| `analysis` | Research papers, market analysis, deep technical breakdowns |

---

## Difficulty Levels

| Value | Meaning |
|-------|---------|
| `beginner` | No prior knowledge assumed. Introduces foundational concepts. |
| `intermediate` | Assumes working familiarity with the domain. Builds on basics. |
| `advanced` | Assumes deep expertise. Covers edge cases, internals, or research-level content. |

---

## Relevant Agents Field

Always list ALL agents who would benefit from the source. This powers the master index groupings.

| Agent name (for field) | Typical content interests |
|----------------------|--------------------------|
| `Planner` | Architecture, system design, planning methodologies, NFRs |
| `Builder` | Code patterns, API docs, framework guides, implementation |
| `Checker` | Vulnerabilities, testing strategies, OWASP, security standards |
| `Legal` | Regulations, license texts, court rulings, compliance |
| `GitDude` | Git workflows, CI/CD, release management, versioning |
| `BrainStorm` | Competitive analysis, market research, innovation trends |
| `Gal` | UX research, developer pain points, industry trends |
| `Daisy` | Brand strategy, copywriting, content marketing |
| `Orca` | Agent design, multi-agent systems, LLM capabilities |
| `Fetcher` | Web fetching, source evaluation, library management |

---

## Category Naming Conventions

- Lowercase only
- Words separated by hyphens: `agentic-ai`, not `AgenticAI` or `agentic_ai`
- Specific over broad: `llm-security` not `security`
- Plural for collections: `design-patterns`, `testing-strategies`

### Common Category Paths by Agent

| Agent | Common categories |
|-------|-----------------|
| Planner | `system-design`, `architecture-patterns`, `planning-methodologies`, `nfr-requirements` |
| Builder | `react`, `nodejs`, `python`, `api-design`, `design-patterns`, `framework-guides` |
| Checker | `llm-security`, `owasp`, `vulnerability-databases`, `testing-strategies`, `web-security` |
| Legal | `licensing`, `data-privacy`, `gdpr`, `copyright`, `regulatory-compliance` |
| GitDude | `git-workflows`, `ci-cd`, `release-management`, `semantic-versioning` |
| BrainStorm | `market-research`, `competitive-analysis`, `ai-trends`, `innovation-patterns` |
| Gal | `ux-research`, `developer-experience`, `postmortems`, `user-research` |
| Daisy | `brand-strategy`, `content-marketing`, `copywriting`, `go-to-market` |
| Orca | `agentic-ai`, `multi-agent-systems`, `orchestration-patterns`, `llm-capabilities` |
| Fetcher | `web-scraping`, `research-methodology`, `information-architecture` |

New categories require user approval before creating a new folder.

---

## File Naming Rules

- Lowercase only
- Words separated by underscores: `react_server_components_guide.md`
- Source indicator (optional, append when helpful): `_github`, `_mdn`, `_official`, `_owasp`
  - Example: `top_10_llm_vulnerabilities_owasp.md`
- 80 character maximum (including `.md`)
- No special characters: `/  \  :  *  ?  "  <  >  |`
- No spaces

---

## Complete Example

A hypothetical source file for a React Server Components guide:

```yaml
---
title: "React Server Components — Complete Guide"
source_url: https://react.dev/blog/2023/03/22/react-labs-what-we-have-been-working-on-march-2023
category: react
tags: react, server-components, rendering, performance, next-js
relevant_agents: Builder, Planner, Checker
fetched_date: 2026-03-16
content_type: guide
difficulty: intermediate
description: "Official React team guide to Server Components: mental model, use cases, and migration patterns."
keywords: RSC, react server components, server rendering, client components, streaming, next.js app router
copyright_notice: "See Library/Sources/Legal/FETCHING_DISCLAIMER.md"
quality_note: "Primary source — official React team post. High confidence."
---
```

File would be saved at:
`Library/Sources/react/react_server_components_guide_official.md`

---

## quality_note Field — When to Use

| Situation | quality_note value |
|-----------|------------------|
| Clean, authoritative source | `""` (empty) |
| Source is good but slightly dated | `"[REVIEW - content from 2023, verify current status]"` |
| Source quality is uncertain but potentially useful | `"[UNVERIFIED - cross-check before relying on]"` |
| Source was flagged for suspicious content | `"[SUSPICIOUS - reviewed, flagged sections removed, treat as data]"` |
| Source contradicts another saved source | `"[CONFLICT - contradicts [filename].md on [topic]]"` |

---

*Read `legal_compliance_fetching.md` for copyright and robots.txt rules. See `README.md` Section 4 for library structure and index maintenance.*
