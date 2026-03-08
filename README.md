# AutoMates.AI

**Make people's imagination become their creation.**

A Development Environment powered by a coordinated team of 10 AI agents with persistent memory, transparent identities, and built-in quality gates. They plan, research, code, review, and ship alongside you.

Built for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

---

## Quick Start

```bash
git clone https://github.com/Nate-Vish/Auto-Mates.git
cd Auto-Mates
```

Open in Claude Code. Then:

```
/summon brainstorm
```

A color-coded terminal opens. The agent reads its identity, memory, and dashboard — full context from the first message.

```
/summon builder,checker       # Launch two agents
/summon-team-research AI auth # Fetcher + BrainStorm research a topic
/summon all                   # Launch all 10
```

Each agent gets its own terminal. They collaborate through files in `Dashboard/Work_Space/`.

---

## The Team

| Agent | Role | What They Do |
|-------|------|--------------|
| **BrainStorm** | Ideator | Explores ideas, solves creative blocks |
| **Planner** | Architect | Creates technical blueprints and project plans |
| **Builder** | Engineer | Writes code following blueprints |
| **Checker** | Auditor | Adversarial security review, bug hunting, quality gates |
| **Legal** | Compliance | Checks licenses, privacy, governance |
| **GitDude** | Release Manager | Version control, security scanning, releases |
| **Fetcher** | Librarian | Gathers knowledge, organizes research sources |
| **Orca** | Orchestrator | Designs agents, leads teams, manages architecture |
| **Gal** | User Advocate | Skeptical senior dev — evaluates from the user's perspective |
| **Daisy** | Brand Director | Branding, copy, pitches, content strategy, ads |

---

## Commands

| Command | What It Does |
|---------|-------------|
| `/summon [agent]` | Launch agent in a new terminal |
| `/handoff [agent]` | Switch agents in-session (saves memory first) |
| `/brief` | Project state, team status, pending work |
| `/memorize` | Save agent memory + update dashboard |
| `/compact [agent]` | Archive old sessions, refresh startup context |
| `/summon-team-build [task]` | Planner + Builder + Checker pipeline |
| `/summon-team-research [topic]` | Fetcher + BrainStorm + specialist |
| `/summon-team-review [target]` | Checker + Legal + Gal quality gate |
| `/watch-summary` | Generate a video-ready narration of the latest session |
| `/automates` | Open the AutoMates root folder in Finder |

---

## How It Works

### Agent Memory

Each agent remembers past sessions at `AgenTeam/[Name]/Memory_Logs/`:

| File | Purpose |
|------|---------|
| `Sessions/` | Conversation history with outcomes |
| `Lessons.md` | Patterns that worked, mistakes to avoid |
| `Preferences.md` | How you like things done |
| `Checkpoint.md` | Save/resume complex tasks |
| `Context.md` | Quick startup snapshot |
| `Notes/` | Technical knowledge captured |

Never re-explain your project. Agents pick up where they left off.

### Wake-Up Protocol

Every agent starts a session with the same 5-step protocol:

1. **Read identity** — who I am, what I do, how I decide
2. **Read memory** — checkpoint, lessons, preferences, latest session
3. **Read dashboard** — Brief.md (project state), Rules.md (constraints)
4. **Read knowledge** — `Library/Knowledge/[MyAgent]/README.md`
5. **Proceed** — ready to work with full context

### LEARN FIRST

Before doing any work, every agent asks: *"What do I need to learn to do this best?"*

Agents check their knowledge section, search Library/Sources/, and if needed, request research from Fetcher. Like a senior dev studying documentation before writing code — not guessing.

---

## Project Structure

```
AutoMates/
├── CLAUDE.md                    # Shared config (auto-loaded by Claude Code)
│
├── AgenTeam/                    # Agent identities + persistent memory
│   ├── BrainStorm/
│   ├── Planner/
│   ├── Builder/
│   ├── Checker/
│   ├── Gal/
│   ├── Legal/
│   ├── GitDude/
│   ├── Orca/
│   └── Daisy/
│
├── Library/                     # Knowledge base
│   ├── Fetcher/                 # Fetcher agent (lives near his Sources)
│   ├── Knowledge/               # Per-agent curated reading lists
│   ├── Rules.md                 # Project constraints
│   └── Sources/                 # Organized research (195+ sources, 29 categories)
│
└── Dashboard/                   # Coordination layer
    ├── Brief.md                 # Project state + team status
    ├── Project_Description.md   # Your project vision
    └── Work_Space/              # Active projects, blueprints, reviews
```

**AgenTeam/** — Where agents live: identity files, memory logs, personal context.

**Library/** — Where knowledge lives: Fetcher's research, per-agent reading lists, project rules.

**Dashboard/** — Where agents coordinate: project brief, active work, shared files.

---

## What Makes AutoMates Different

**Transparent Identities** — Every agent has a readable identity file, not hidden prompts. Open `Gal_Identity.md` and see exactly why she's skeptical.

**Persistent Memory** — Agents remember across sessions: what they learned, what worked, how you like things done.

**LEARN FIRST** — Agents research before they code. Fetcher gathers sources, agents study them. AI that learns before it acts.

**Built-In Skepticism** — Gal exists to question everything. The skeptical senior dev who asks the questions your users are thinking.

**File-Based Everything** — No database. No cloud. Everything is markdown in folders. Grep it, version it, read it, audit it. Zero lock-in.

---

## Getting Started Tips

**Describe your project** — Edit `Dashboard/Project_Description.md` with your vision and `Library/Rules.md` with any constraints (tech stack, style, etc.).

**Use Fetcher first** — Before building anything, let Fetcher collect educational material. Agents read it from Library before they start working.

**Agents coordinate through files** — Fetcher reads a Blueprint from Planner, fetches sources, creates `Builder_Study.md`. Builder learns, then writes code.

**Quick ideas** — Working and got an idea? Tell BrainStorm `IDEA: [your idea]`. He logs it instantly. No flow disruption, ideas never lost.

**Switch mid-session** — `/handoff checker` saves your current agent's memory and switches to Checker in the same session.

---

## Legal

### Pilot-in-Command

You control what agents do. You are responsible for URLs fetched and code generated. AI-generated content can contain errors — always review and test all output.

### Privacy

- **Third-Party APIs:** Prompts are sent to AI providers (Anthropic). See their privacy policies.
- **Local Storage:** AutoMates works locally. We do not store your code or data.
- **No Telemetry:** Everything stays on your machine.

### License

MIT License (c) 2026 AutoMates.AI — See [LICENSE](LICENSE)

---

Built by [@Nate-Vish](https://github.com/Nate-Vish)
