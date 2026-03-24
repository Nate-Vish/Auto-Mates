---
name: idea
description: Quick-capture an idea to BrainStorm's knowledge graph — no agent switch needed
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

# /idea - Quick Idea Capture

Captures an idea instantly to BrainStorm's knowledge graph Inbox. Works from any agent — no need to switch to BrainStorm first. BrainStorm processes the Inbox on its next startup and connects it to the graph.

## Usage

```
/idea Build a CLI that logs what you worked on each day
/idea What if Arsenal.yaml had a "recommended by" field per tool?
/idea Comparison GIF — raw Claude Code vs AutoMates side by side
```

## Instructions

### Step 1: Get the Idea

The user's arguments after `/idea` are the idea content. If no arguments were provided, ask: "What's the idea?"

### Step 2: Generate Metadata

- **Date:** today's date in YYYY-MM-DD format
- **Slug:** kebab-case from the first ~5 words (e.g., `cli-daily-work-logger`)
- **Source agent:** whichever agent is currently active (check the conversation context), or "direct" if no agent is active
- **Tags:** generate 2-4 relevant tags from the content

### Step 3: Write to Inbox

Write the idea to `AgenTeam/BrainStorm/Memory_Logs/MindMap/Inbox/{slug}.md`:

```markdown
---
date: YYYY-MM-DD
source: [agent name or "direct"]
type: idea
tags: [tag1, tag2, tag3]
---

# [Idea title — clean, concise version of the user's words]

[The full idea text as the user wrote it. Add nothing, remove nothing.]
```

If a file with the same slug already exists, append a number (e.g., `cli-daily-work-logger-2.md`).

### Step 4: Confirm

Report back briefly:

```
Idea captured → BrainStorm/MindMap/Inbox/{slug}.md
Tags: #tag1 #tag2 #tag3
BrainStorm will connect it to the graph next session.
```

## Rules

- **Never switch agents.** This skill works inline — the current agent stays active.
- **Never edit the idea.** Capture the user's exact words. Don't improve, rewrite, or expand.
- **Keep it fast.** This is a 5-second operation, not a brainstorm session. No follow-up questions beyond "what's the idea?" if arguments are missing.
- **The Inbox is a drop zone.** BrainStorm owns processing (categorizing, connecting, indexing). This skill just captures.
