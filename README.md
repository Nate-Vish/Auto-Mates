# AutoMates

A coordinated AI agent team that works with you. 10 specialized agents with persistent memory, professional knowledge, and clear roles — all running in your terminal.

I built this because I felt like I wasn't using AI's full potential. So I solved a problem. Then another one. Then made something better, added a feature, removed something else. Three months of fine-tuning my workflow with Claude Code, doing it my way. Currently it's my favorite way of working.

Built for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) by [@Nate-Vish](https://github.com/Nate-Vish). Free and open source.

<!-- GIF: summon demo -->

---

## Quick Start

```bash
git clone https://github.com/Nate-Vish/Auto-Mates.git
cd Auto-Mates
```

Open in Claude Code. That's it — Orca (the orchestrator) loads automatically and walks you through everything. No manual required.

```
You: I want to build a budgeting app

Orca: Great — let me get the right agents on this.
      First, let's have Fetcher research best practices...
```

Orca guides you to the right agent for every task. You don't need to memorize commands or learn the system first.

<!-- GIF: orca guiding demo -->

---

## The Team

| Agent | Role | Skill | What They Do |
|-------|------|-------|--------------|
| **Orca** | Orchestrator | `/orca` | Guides you through AutoMates, designs agents, leads teams |
| **Planner** | Architect | `/planner` | Creates technical blueprints and project plans |
| **Builder** | Engineer | `/builder` | Writes code following blueprints |
| **Checker** | Auditor | `/checker` | Adversarial security review, bug hunting, quality gates |
| **BrainStorm** | Knowledge Graph | `/brainstorm` | Explores ideas, logs thoughts, connects concepts |
| **Fetcher** | Researcher | `/fetcher` | Gathers knowledge, organizes research in Library |
| **Legal** | Compliance | `/legal` | Checks licenses, privacy, governance |
| **GitDude** | Release Manager | `/gitdude` | Version control, security scanning, releases |
| **Gal** | User Advocate | `/gal` | Skeptical senior dev — asks the hard questions |
| **Daisy** | Brand Director | `/daisy` | Branding, copy, pitches, content strategy |

Every identity is a readable markdown file. Open `Gal_Identity.md` and see exactly why she's skeptical. No hidden prompts.

Each agent has a defined lane — and knows when to hand off to someone else. Boundaries and routing are documented in `Library/Registry.md`.

---

## Commands

### Switch Agents (In-Session)

Type any agent skill to switch instantly. Your current agent's memory is saved automatically.

```
/builder        # Switch to Builder
/checker        # Switch to Checker
/orca           # Back to Orca (home base)
/forge          # Create a brand new agent (guided 6-phase process)
```

### Launch & Coordinate

| Command | What It Does |
|---------|-------------|
| `/summon [agent]` | Launch agent in a new terminal |
| `/brief` | Project state, team status, pending work |
| `/memorize` | Save agent memory + update dashboard |
| `/compact [agent]` | Archive old sessions, refresh startup context |
| `/watch-summary` | Generate a video-ready narration of the session |

### Team Pipelines

| Command | Agents | When to Use |
|---------|--------|-------------|
| `/summon-team-build [task]` | Planner + Builder + Checker | Design → build → review |
| `/summon-team-research [topic]` | Fetcher + BrainStorm + specialist | Deep investigation |
| `/summon-team-review [target]` | Checker + Legal + Gal | Security + compliance + UX |

---

## How It Works

### Agent Memory

Each agent remembers past sessions. Memory lives at `AgenTeam/[Name]/Memory_Logs/`:

| File | Purpose |
|------|---------|
| `Sessions/` | Conversation history with outcomes |
| `Lessons.md` | Patterns that worked, mistakes to avoid |
| `Preferences.md` | How you like things done |
| `Checkpoint.md` | Save/resume complex tasks |
| `Context.md` | Quick startup snapshot |
| `Notes/` | Technical knowledge captured |

Never re-explain your project. Agents pick up where they left off.

<!-- GIF: memory demo -->

### Professional Knowledge

Every agent carries professional knowledge — not just a role description, but actual expertise distilled into cheat sheet READMEs with deep-dive reference files.

```
Library/Knowledge/
├── Builder/     # 18 topics: TypeScript, React, APIs, DevOps, DSA, clean code...
├── Checker/     # 7 topics: OWASP, attack payloads, defense, testing strategy...
├── GitDude/     # 10 topics: git ops, branching, security scanning, releases...
├── Planner/     # 17 topics: architecture patterns, NFRs, data modeling, ADRs...
├── Gal/         # 29 files: classic mistakes across all dev areas + persona context
├── Orca/        # 6 pillars: team management, agent creation, user guidance...
└── ...          # Every agent has their own section
```

Knowledge is self-contained — no external dependencies. Clone the repo and agents arrive with real expertise on day one.

### Wake-Up Protocol

Every agent starts with the same 5 steps:

1. **Read identity** — who I am, what I do, how I decide
2. **Read memory** — checkpoint, lessons, preferences, latest session
3. **Read dashboard** — Brief.md (project state), Rules.md (constraints)
4. **Read knowledge** — `Library/Knowledge/[MyAgent]/README.md`
5. **Proceed** — ready to work with full context

### LEARN FIRST

Before doing any work, every agent asks: *"What do I need to learn to do this best?"*

Agents check their knowledge section, search `Library/Sources/`, and if needed, request research from Fetcher. Like a senior dev studying docs before writing code — not guessing.

---

## Project Structure

```
AutoMates/
├── CLAUDE.md                    # Shared config (auto-loaded by Claude Code)
│
├── AgenTeam/                    # Agent identities + persistent memory
│   ├── Orca/, Planner/, Builder/, Checker/
│   ├── BrainStorm/, Gal/, Legal/, GitDude/
│   └── Daisy/
│
├── Library/
│   ├── Registry.md              # Agent routing truth — who handles what
│   ├── Fetcher/                 # Fetcher agent (lives near his Sources)
│   ├── Knowledge/               # Per-agent professional knowledge (self-contained)
│   ├── Rules.md                 # Project constraints
│   └── Sources/                 # Research library — agents study here before working
│
├── .claude/skills/              # All slash commands live here
│   ├── orca/, builder/, ...     # Agent switch skills
│   ├── forge/                   # Create new agents
│   ├── summon/                  # Launch agents in terminals
│   ├── brief/, memorize/        # Dashboard + memory commands
│   └── ...
│
└── Dashboard/                   # Where agents coordinate
    ├── Brief.md                 # Project state + team status
    ├── Work_Space/              # Where we build
    └── Version_Control/         # Where we git
```

---

## What Makes This Different

**Start by talking** — No setup guide needed. Orca meets you where you are and walks you through everything as you work.

**Transparent** — Every agent identity is a readable file. Every decision is traceable. No black boxes.

**Persistent Memory** — Agents remember across sessions: what they learned, what worked, how you like things done.

**Real Knowledge** — Agents carry professional expertise (89 topic files across 10 agents), not just role descriptions. They know their craft.

**LEARN FIRST** — Agents research before they code. Fetcher gathers sources, agents study them. AI that learns before it acts.

**Built-In Skepticism** — Gal exists to question everything. The skeptical senior dev who catches what you missed.

**Create Your Own Agents** — `/forge` walks you through a 6-phase guided process to create a new agent tailored to your needs.

**File-Based Everything** — No database. No cloud. Everything is markdown in folders. Grep it, version it, read it, fork it. Zero lock-in.

---

## Getting Started

1. **Just talk to Orca** — Describe what you want to build. Orca routes you to the right agents.

2. **Describe your project** — Edit `Dashboard/Project_Description.md` with your vision and `Library/Rules.md` with any constraints.

3. **Agents coordinate through files** — Planner writes a Blueprint. Fetcher reads it and gathers sources. Builder studies both, then writes code. Checker reviews.

4. **Quick ideas** — Tell BrainStorm `IDEA: [your idea]`. Logged instantly. No flow disruption.

5. **Switch anytime** — `/builder` saves your current agent's memory and switches instantly.

---

MIT Licensed. Runs entirely on your machine. — See [LICENSE](LICENSE)

Built by [@Nate-Vish](https://github.com/Nate-Vish)
