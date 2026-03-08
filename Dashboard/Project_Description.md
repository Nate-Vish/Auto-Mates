# Project Description

---

## Project Name

**AutoMates.AI**

---

## Vision

**To make people's imagination become their creation.**

AutoMates is a simple & innovative Development Environment powered by a coordinated AI agent team. Instead of one AI assistant that does everything mediocrely, AutoMates provides 10 specialized agents that excel at their roles, remember across sessions, and coordinate through slash commands — running on Claude Code, Google Antigravity (Gemini), and OpenAI Codex.

---

## The Problem We Solve

Current AI coding tools have fundamental issues:
- **Trust is declining** — Developers went from 70% to 33% trust in AI code (2023-2025)
- **"Almost right" syndrome** — AI gives code that looks correct but fails in production
- **Context amnesia** — Re-explaining your project every session
- **Black boxes** — You can't read what your AI is thinking or how it decides
- **No coordination** — Users manually juggle between tools and prompts

---

## Our Solution

**10 specialized AI agents with persistent memory, slash-command orchestration, and transparent file-based coordination — across Claude Code, Google Antigravity, and OpenAI Codex.**

| Agent | Role | Specialty |
|-------|------|-----------|
| **Planner** | Architect | Blueprints, roadmaps, task breakdown |
| **Builder** | Developer | Implementation, coding, debugging |
| **Checker** | QA + Security | Code review, security, quality |
| **BrainStorm** | Creative | Ideas, alternatives, innovation |
| **Legal** | Compliance | Licensing, privacy, regulations |
| **GitDude** | Release Manager | Version control, commits, releases |
| **Fetcher** | Researcher | Knowledge acquisition, documentation |
| **Orca** | Orchestrator | Agent system design, team coordination |
| **Gal** | User Advocate | Skeptical evaluation, UX testing |
| **Daisy** | Brand Director | Branding, social media, PR, pitches, ads |

---

## Target Users

### Primary: Developers
- Solo developers who want a capable AI team
- Small teams who need to move fast
- Anyone frustrated with opaque AI coding tools

### Secondary: Non-Technical Creators
- Entrepreneurs with ideas but no coding skills
- Designers who want to build their visions
- Anyone who can imagine but can't implement

---

## Key Features

### 1. Specialized Agents
Each agent has a focused identity, memory, and expertise. They don't try to do everything — they do one thing well.

### 2. Persistent Memory
Every agent maintains memory across sessions:
- `Sessions/` — what happened each day
- `Lessons.md` — what worked and what didn't
- `Preferences.md` — how you like things done
- `Checkpoint.md` — resume mid-task
- `Context.md` — quick startup snapshot

### 3. Slash-Command Orchestration
10 commands to coordinate the team:
- `/summon <agent>` — launch in separate terminal
- `/handoff <agent>` — transition in-session
- `/brief` — project state and team status
- `/memorize` — save all agent memory
- `/compact` — archive old sessions
- `/summon-team-build` — parallel build pipeline
- `/summon-team-research` — deep investigation team
- `/summon-team-review` — quality gate team
- `/watch-summary` — video-ready session narration

### 4. LEARN FIRST Protocol
Agents research before acting. Fetcher gathers sources to `Library/Sources/`, agents study them before writing code. Like a senior dev would.

### 5. Transparent Identities
Every agent has a readable identity file — not hidden prompts. Open `Gal_Identity.md` and see exactly why she's skeptical.

### 6. File-Based Everything
No database. No cloud. No proprietary formats. Everything is markdown in folders. Zero lock-in.

### 7. Built-In Skepticism
Gal exists to question everything. No other tool has a built-in critic that catches problems before your users do.

### 8. Knowledge Library
`Library/Sources/` contains 195+ organized, agent-accessible research sources across 29 categories. `Library/Knowledge/` has per-agent curated reading lists.

---

## How It Works

```
/summon planner           → Creates blueprint from your idea
/handoff builder          → Implements the blueprint
/handoff checker          → Reviews code quality and security
/handoff gitdude          → Commits and pushes to GitHub

/summon-team-build task   → Runs the full pipeline in parallel
```

BrainStorm helps when stuck. Legal ensures compliance. Fetcher gathers knowledge. Gal validates from a user perspective.

---

## Project Structure

```
Auto-Mates.AI/
├── CLAUDE.md                    # Claude Code platform config
├── ANTIGRAVITY.md               # Google Antigravity (Gemini) platform config
├── CODEX.md                     # OpenAI Codex platform config
├── AgenTeam/                    # Agent identities + persistent memory
│   ├── Planner/, Builder/, Checker/, BrainStorm/
│   ├── Legal/, GitDude/, Gal/, Orca/
│   └── [Agent]/Memory_Logs/     # Sessions, Notes, Lessons, Preferences, Checkpoint
├── Dashboard/
│   ├── Brief.md                 # Project state, team status, recent activity
│   ├── Work_Space/              # Active projects, blueprints, reviews
│   └── Version_Control/         # Git repos (one per product)
└── Library/
    ├── Fetcher/                 # Fetcher agent (identity + memory)
    ├── Knowledge/               # Per-agent curated reading lists
    └── Sources/                 # Research library (195+ sources)
```

---

## What Makes AutoMates a Paradigm

| Traditional AI Tools | AutoMates |
|---------------------|-----------|
| AI as **assistant** | AI as **team** |
| Single generalist | 10 specialized agents |
| Ephemeral (forgets everything) | **Persistent memory** across sessions |
| Black box behavior | **Readable identity files** |
| "Just generate" | **LEARN FIRST** — research, then code |
| Always optimistic | **Built-in skepticism** (Gal) |
| One AI, one conversation | **Team orchestration** (/summon-team-build) |
| Tool-centric | **Human is the pilot** |

---

## Success Criteria

1. **A developer can start a project in under 5 minutes**
2. **Agents produce code that works on first try (most of the time)**
3. **Context persists across sessions — no re-explaining**
4. **The system is transparent — you can read every file and understand what happened**
5. **Gal says "I'd use this"**

---

## Current Status

**Version:** 1.3 (February 2026)
**Platforms:** Claude Code, Google Antigravity (Gemini), OpenAI Codex

### What's Built
- 10 agents with persistent memory (Context, Checkpoint, Sessions, Lessons, Preferences)
- 10 slash commands for orchestration
- Platform config files: CLAUDE.md, ANTIGRAVITY.md, CODEX.md (self-contained, auto-loaded per platform)
- Library/Knowledge/ per-agent curated reading lists
- Library/Sources/ with 195+ research sources
- v1.3 on GitHub (github.com/Nate-Vish/Auto-Mates)
- Claude-Mates shipped to GitHub
- AutoMates-Web MVP live at automate-s.com

### Active Projects
- **AutoMates-Web** — Spatial Development Environment (Phases 1-5 live)
- **Sunny** — Personal AI assistant (persona designed)
- **FinCat** — Financial categorization tool (v3 functional)
- **AM-CLI** — Command-line tool (planning phase)

---

## The AutoMates Way

> "We believe everyone's imagination deserves to become their creation. We make this possible through a simple, innovative Development Environment powered by a coordinated AI agent team. AutoMates is 10 specialized agents — with readable identities, persistent memory, and honest skepticism — ready to plan, build, and ship what you imagine."

---

*This file is read by all agents to understand the project context.*
