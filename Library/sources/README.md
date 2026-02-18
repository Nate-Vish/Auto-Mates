# Knowledge Library

This folder contains knowledge sources fetched by the Fetcher agent.

---

## How It Works

1. **Agents request knowledge** - When an agent needs to learn something, they create a knowledge request
2. **Fetcher gathers sources** - Fetcher downloads and organizes content
3. **Knowledge is indexed** - Sources are categorized and added to INDEX.md
4. **Agents reference sources** - All agents can read from this library

---

## Folder Structure

```
library/sources/
├── README.md           <- You are here
├── INDEX.md            # Master index of all sources (created by Fetcher)
├── planning/           # For Planner
├── coding/             # For Builder
├── security/           # For Checker
├── innovation/         # For BrainStorm
├── licensing/          # For Legal
├── git/                # For GitDude
└── [category]/         # Other categories as needed
```

---

## Adding Sources

### Automatic (Recommended)
Use Fetcher agent to fetch and organize sources:
```
/summon fetcher
> Fetch https://example.com/docs and save to coding/
```

### Manual
If adding sources manually:
1. Create a markdown file with content
2. Add metadata header (see template below)
3. Add entry to INDEX.md
4. Add entry to category README.md

### Metadata Template
```markdown
---
title: [Title]
source_url: [URL]
category: [Category]
tags: [tag1, tag2]
relevant_agents: [planner, builder, etc.]
fetched_date: [YYYY-MM-DD]
---

[Content here]
```

---

## Index Format

**INDEX.md** example:
```markdown
# Sources Index

## For Planner
- [Agile Methodology](planning/agile.md) - Sprint planning basics `planning, agile`

## For Builder
- [Python Best Practices](coding/python-best-practices.md) - PEP 8 guide `python, style`

## For Checker
- [OWASP Top 10](security/owasp-top-10.md) - Security vulnerabilities `security, OWASP`
```

---

## Empty Until Used

This folder starts empty. As you work on projects, Fetcher will populate it with relevant knowledge sources.

The knowledge persists across sessions, building a growing library for your team.
