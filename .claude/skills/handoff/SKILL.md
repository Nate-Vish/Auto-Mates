---
name: handoff
description: Transition work context from one agent to another within the current session
allowed-tools:
  - Read
  - Write
  - Edit
---

# /handoff - Agent-to-Agent Transition

Hand off work from the current agent to another agent, preserving context through file-based handoff.

## Usage

```
/handoff <target-agent>
```

## Available Agents

planner, builder, checker, brainstorm, gal, legal, gitdude, fetcher, orca

## Instructions

When invoked with a target agent name, perform these steps IN ORDER:

### Step 1: Memorize Before Handoff

Run the full `/memorize` flow for the current agent BEFORE handing off:

1. **Sessions/** — Append what happened this session (create `Session_[YYYY-MM-DD].md` or append if same date)
2. **Lessons.md** — Append any new lessons learned (READ first)
3. **Preferences.md** — Append any new user preferences (READ first)
4. **Checkpoint.md** — Update with current task status, what's done, what's next, key files for the target agent (READ first, then update)
5. **Context.md** — Refresh the quick startup snapshot
6. **Dashboard/Brief.md** — Update if project-wide changes happened (Recent Activity row, Team Status, etc.)

**IMPORTANT:** Memory is sacred — ALWAYS read before write, ALWAYS append (except Context.md which is overwritten as a generated snapshot).

### Step 2: Print Handoff Summary

```
=== HANDOFF ===
From: [Current Agent]
To:   [Target Agent]

Task:   [current task description]
Status: [what's done so far]
Next:   [what the target agent should do]
Files:  [key files to read]
================
```

### Step 3: Load Target Agent

Read the target agent's files in this order:

1. **Identity file:**
   - planner: `AgenTeam/Planner/Planner_Identity.md`
   - builder: `AgenTeam/Builder/Builder_Identity.md`
   - checker: `AgenTeam/Checker/Checker_Identity.md`
   - brainstorm: `AgenTeam/BrainStorm/BrainStorm_Identity.md`
   - legal: `AgenTeam/Legal/Legal_Identity.md`
   - gitdude: `AgenTeam/GitDude/GitDude_Identity.md`
   - fetcher: `Library/Fetcher/Fetcher_Identity.md`
   - orca: `AgenTeam/Orca/Orca_Identity.md`
   - gal: `AgenTeam/Gal/Gal_Identity.md`

2. **Knowledge section:** `Library/Knowledge/[TargetAgent]/README.md`

3. **Memory (in order):**
   - `Memory_Logs/Checkpoint.md`
   - `Memory_Logs/Lessons.md`
   - `Memory_Logs/Preferences.md`

4. **Dashboard:**
   - `Dashboard/Brief.md`

### Step 4: Announce Transition

```
I am now [Target Agent]. [Agent tagline].
I've received the handoff from [Previous Agent].
Here's what I understand needs to happen: [brief summary from handoff]
```

## Common Handoffs

| From | To | When |
|------|----|------|
| Planner | Builder | Blueprint approved, ready to implement |
| Builder | Checker | Implementation done, ready for review |
| Checker | Builder | Review done, fixes needed |
| Checker | GitDude | Review passed, ready for version control |
| Any | BrainStorm | Stuck, need creative solutions |
| Any | Fetcher | Need knowledge before proceeding |
| Any | Orca | System design question |

## Notes

- Memory is sacred: ALWAYS read before write, ALWAYS append
- The handoff is within a single session — context carries over
- For parallel work (separate terminals), use `/summon` instead
