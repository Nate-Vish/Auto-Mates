# AutoMates.AI

**Where imagination becomes creation.**

> *AutoMates is a Development Environment that empowers developers, entrepreneurs, and creators to build exactly what they imagine — through a coordinated team of 9 AI agents with persistent memory, transparent identities, and built-in quality gates that plan, research, code, review, and ship alongside you, so that the gap between what you can dream and what you can deliver disappears.*

---

## Quick Start

### 1. Clone & Open
```bash
git clone https://github.com/Nate-Vish/Auto-Mates.git
cd Auto-Mates
```
Open the folder in Claude Code.

### 2. Describe Your Project
Edit `Dashboard/Project_Description.md` with your vision.
Edit `Library/Rules.md` with any constraints (tech stack, style, etc.).

### 3. Summon an Agent
```
/summon brainstorm
```
A color-coded terminal opens. The agent reads its identity, memory, and dashboard — full context from the first message.

### 4. Run Multiple Agents
```
/summon builder,checker       # Launch two agents
/summon team                  # Launch Planner + Builder + Checker
/summon all                   # Launch all 9
```
Each agent gets its own terminal. They collaborate through files in `Dashboard/Work_Space/`.

### 5. Switch Agents In-Session
```
/handoff checker              # Save context, become Checker
/brief                        # See project state and team status
/memorize                     # Save agent memory + update dashboard
```

---

**Tip:** Use Fetcher to collect educational material for the agents. Let them read it before they start working on a task (they'll find it in Library).

**Hint:** Every agent can create a file for other agents to read and work by.

**Example:** Fetcher can read a Blueprint that Planner made, go fetch some sources and create `Builder_Study.md`, then Builder learns like a pro and starts writing some fine code.

**Try this:** Got a quick idea while working? Just tell BrainStorm `IDEA: [your idea]` — he'll log it instantly and keep working. No flow disruption, ideas never lost.

---

## How It Works

### The Team (9 Agents)

| Agent | Role | What They Do |
|-------|------|--------------|
| **BrainStorm** | Ideator | Explores ideas, solves creative blocks |
| **Planner** | Architect | Creates technical blueprints |
| **Builder** | Engineer | Writes code following blueprints |
| **Checker** | Auditor | Reviews for bugs, security, quality |
| **Legal** | Compliance | Checks licenses, privacy, governance |
| **GitDude** | Release Manager | Version control, security scanning |
| **Fetcher** | Librarian | Gathers knowledge, organizes sources |
| **Orca** | Orchestrator | Designs agents, leads teams, manages architecture |
| **Gal** | User Advocate | Skeptical senior dev — evaluates from the user's perspective |

### 9 Slash Commands

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

### The Three Zones

```
AutoMates/
├── AgenTeam/                    # Where agents live
│   ├── BrainStorm/
│   ├── Planner/
│   ├── Builder/
│   ├── Checker/
│   ├── Gal/
│   ├── Legal/
│   ├── GitDude/
│   └── Orca/
│
├── Library/                     # Where information is stored
│   ├── Fetcher/                # He lives here near his Sources
│   ├── Knowledge/              # Per-agent curated reading lists
│   ├── Rules.md                # Project constraints
│   └── Sources/                # Organized knowledge base
│
└── Dashboard/                   # Where agents work together
    ├── Project_Description.md
    ├── Brief.md                # Project state + team status
    ├── Work_Space/             # The fun happens here
    └── Version_Control/
```

**AgenTeam/** — Where the agents live, including their identity and memory.

**Library/** — Where information is stored and organized by Fetcher (he lives there near his Sources). Per-agent curated reading lists in Knowledge/.

**Dashboard/** — The place where all agents work together on your tasks and manage the versions for you.

### Agent Memory

Each agent remembers past sessions at `AgenTeam/[Name]/Memory_Logs/`:
- `Sessions/` — Conversation history
- `Notes/` — Technical knowledge captured
- `Lessons.md` — Patterns that worked, mistakes to avoid
- `Preferences.md` — How you like things done
- `Checkpoint.md` — Save/resume complex tasks
- `Context.md` — Quick startup snapshot

### Agent Wake-Up Protocol

When an agent starts a session, they follow a 5-step protocol:

```
Step 1: Read My Identity
  → Who I am, what I do, how I decide

Step 2: Read My Memory
  → Checkpoint, Lessons, Preferences, latest Session

Step 3: Read the Dashboard
  → Brief.md (project state, team status, recent activity)
  → Library/Rules.md (constraints)

Step 4: Read My Knowledge Section
  → Library/Knowledge/[MyAgent]/README.md

Step 5: Proceed
  → Ready to work with full context
```

This ensures every agent wakes up with full context — your project vision, current priorities, and what other agents have been doing. If they need more knowledge, they leave a request for Fetcher instead of working blind.

### LEARN FIRST Protocol

Before doing any work, every agent asks: *"What do I need to learn to do this best?"*

Agents check their knowledge section, search Library/Sources/, and if needed, request research from Fetcher. Like a senior dev studying documentation before writing code.

---

## What Makes AutoMates Different

**Transparent Identities** — Every agent has a readable identity file, not hidden prompts. Open `Gal_Identity.md` and see exactly why she's skeptical.

**Persistent Memory** — Agents remember across sessions: what they learned, what worked, how you like things done. Never re-explain your project.

**LEARN FIRST** — Agents research before they code. Fetcher gathers sources, agents study them. AI that learns before it acts.

**Built-In Skepticism** — Gal exists to question everything. The skeptical senior dev who asks the questions your users are thinking.

**File-Based Everything** — No database. No cloud. Everything is markdown in folders. Grep it, version it, read it, audit it. Zero lock-in.

---

## Roadmap

**Current (v1.3):**
- 9 specialized agents with persistent memory
- CLAUDE.md shared context (auto-loaded every session)
- 9 slash commands for orchestration
- Agent Teams for parallel work
- Library/Knowledge/ per-agent curated reading lists
- Brief.md for project-wide synchronization
- 195+ research sources across 29 categories

---

## Legal, License & Links

### You Are the Pilot-in-Command

- **Your Responsibility:** You control what agents do. You are responsible for URLs fetched and code generated.
- **AI Disclaimer:** AI-generated content can contain errors. Always review and test all output.
- **Copyright:** Respect intellectual property when using Fetcher.

### Privacy

- **Third-Party APIs:** Prompts are sent to AI providers (Anthropic). See their privacy policies.
- **Local Storage:** AutoMates works locally. We do not store your code or data.
- **No Telemetry:** Everything stays on your machine.

### License

MIT License (c) 2026 AutoMates.AI — See [LICENSE](LICENSE)

### Links

- [GitHub Repository](https://github.com/Nate-Vish/Auto-Mates) — Source & releases
