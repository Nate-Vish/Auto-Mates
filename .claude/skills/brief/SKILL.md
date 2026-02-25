---
name: brief
description: Show current project state, team status, and pending requests
allowed-tools:
  - Read
  - Glob
---

# /brief - Project Brief

Quick view of project state, team status, and active work.

## Usage

```
/brief
```

## Instructions

When invoked, read and summarize the following:

1. **Read** `Dashboard/Brief.md` — the unified project brief (active projects, recent activity, team status, next steps)
2. **Check** for any `KNOWLEDGE_REQUEST_*.md` files in `Dashboard/Work_Space/`

Present a concise summary in this format:

```
PROJECT BRIEF
=============
Focus: [Current focus from Brief.md]

ACTIVE PROJECTS
===============
[Active projects table]

TEAM STATUS
===========
[Team status table]

PENDING REQUESTS
================
[List any unfulfilled KNOWLEDGE_REQUEST files, or "None"]

NEXT STEPS
==========
[Next steps list from Brief.md]
```

## Notes

- Keep the output concise — this is a quick check, not a deep dive
- If a KNOWLEDGE_REQUEST file exists, note which agent requested it and the topic
- Do not read full agent memory files — this is a project-level view only
