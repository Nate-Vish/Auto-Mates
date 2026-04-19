# AutoMates

**The environment where imagination becomes creation.**

AI agents that remember, learn before they code, and hide nothing. Built because the current tools keep failing in the same ways.

I built this because I felt like I wasn't using AI's full potential. So I solved a problem. Then another one. Then made something better, added a feature, removed something else. Three months of fine-tuning my workflow with Claude Code, doing it my way. Currently it's my favorite way of working.

Built for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) by [@Nate-Vish](https://github.com/Nate-Vish). Also works with [OpenAI Codex](https://openai.com/index/codex/) and [Gemini CLI](https://github.com/google-gemini/gemini-cli), though Claude Code has the deepest integration (skills, hooks, native config). Won't overwrite your existing config — uses `.claude/rules/` (zero conflict). Free and open source.

Currently used daily by the author for real projects. Early but stable.

### Why

AI coding tools are everywhere now. But something's off.

They forget everything between sessions — you spend the first 15 minutes re-explaining your project. They give you code that looks right, passes tests, and breaks at 3am. They don't know about the pattern your team deprecated last month. And when something goes wrong, you can't see how they decided anything.

Developer trust in AI accuracy has [dropped to 29%](https://stackoverflow.blog/2026/02/18/closing-the-developer-ai-trust-gap/). Almost half of developers say their #1 frustration is code that's ["almost right, but not quite"](https://stackoverflow.blog/2025/12/29/developers-remain-willing-but-reluctant-to-use-ai-the-2025-developer-survey-results-are-here/). AI-generated code ships with [1.75x more logic errors and nearly 3x more security vulnerabilities](https://thenewstack.io/vibe-coding-could-cause-catastrophic-explosions-in-2026/). Meanwhile, [40% of committed code is now AI-generated](https://developers.redhat.com/articles/2026/02/17/uncomfortable-truth-about-vibe-coding) — and review capacity can't keep up.

AutoMates is my answer to that. Not "more AI" — but AI that works like a team: agents that remember, research before they code, review each other's work, and show you every decision in plain markdown files.

<!-- GIF: summon demo -->

---

## Quick Start

**Requires:** [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (CLI from Anthropic — works with an API key or a Claude Pro/Max subscription). Also compatible with Codex (`AGENTS.md`) and Gemini CLI (`GEMINI.md`).

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

Every identity is a readable markdown file. Open `Gal_Identity.md` and see exactly why he's skeptical. No hidden prompts.

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
| `/video` | Create videos — recaps, explainers, comparisons, demos |
| `/slides` | Create presentations (PPTX or HTML slideshow) |
| `/cv` | Build or tailor a resume for a job application |
| `/automates` | Open AutoMates root folder in Finder |
| `/idea` | Quick-capture an idea to BrainStorm's knowledge graph |

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
├── Builder/     # TypeScript, React, APIs, DevOps, DSA, clean code...
├── Checker/     # OWASP, attack payloads, defense, testing strategy...
├── GitDude/     # git ops, branching, security scanning, releases...
├── Planner/     # architecture patterns, NFRs, data modeling, ADRs...
├── Gal/         # classic mistakes across all dev areas + persona context
├── Orca/        # 6 pillars: team management, agent creation, user guidance...
└── ...          # Every agent has their own section
```

Knowledge is self-contained — no external dependencies. Clone the repo and agents arrive with real expertise on day one.

### Wake-Up Protocol

Every agent starts with the same 5 steps:

1. **Read identity** — who I am, what I do, how I decide
2. **Read memory** — checkpoint, lessons, preferences, latest session
3. **Read project context** — Brief.md (project state), Rules.md (constraints)
4. **Read knowledge** — `Library/Knowledge/[MyAgent]/README.md`
5. **Proceed** — ready to work with full context

### LEARN FIRST

Before doing any work, every agent asks: *"What do I need to learn to do this best?"*

Agents check their knowledge section, search `Library/Sources/`, and if needed, request research from Fetcher. Like a senior dev studying docs before writing code — not guessing.

---

## Project Structure

```
AutoMates/
├── GEMINI.md                    # Gemini CLI config
├── AGENTS.md                    # Codex + multi-tool config (23+ AI tools read this)
│
├── .claude/
│   ├── rules/automates.md       # Claude Code config (auto-loaded, zero conflict)
│   └── skills/                  # All slash commands live here
│       ├── orca/, builder/, ... # Agent switch skills
│       ├── forge/               # Create new agents
│       ├── summon/              # Launch agents in terminals
│       ├── brief/, memorize/    # Brief + memory commands
│       └── ...
│
├── Brief.md                     # Project state + team status
│
├── AgenTeam/                    # All 10 agent identities + persistent memory
│   ├── Orca/, Planner/, Builder/, Checker/
│   ├── BrainStorm/, Gal/, Legal/, GitDude/
│   ├── Daisy/, Fetcher/
│   └── [Agent]/Memory_Logs/     # Sessions, Notes, Lessons, Preferences, Checkpoint
│
└── Library/
    ├── Registry.md              # Agent routing truth — who handles what
    ├── Arsenal/                 # Tools, MCPs, and integrations — shared across all agents
    │   └── Arsenal.yaml
    ├── Knowledge/               # Per-agent professional knowledge (self-contained)
    ├── Rules.md                 # Project constraints
    └── Sources/                 # Research library — agents study here before working
```

---

## What Makes This Different

**Start by talking** — No setup guide needed. Orca meets you where you are and walks you through everything as you work.

**Transparent** — Every agent identity is a readable file. Every decision is traceable. No black boxes.

**Persistent Memory** — Agents remember across sessions: what they learned, what worked, how you like things done.

**Real Knowledge** — Agents carry professional expertise (topic files across every agent), not just role descriptions. They know their craft.

**LEARN FIRST** — Agents research before they code. Fetcher gathers sources, agents study them. AI that learns before it acts.

**Built-In Skepticism** — Gal exists to question everything. The skeptical senior dev who catches what you missed.

**Create Your Own Agents** — `/forge` walks you through a 6-phase guided process to create a new agent tailored to your needs.

**File-Based Everything** — No database. No cloud. Everything is markdown in folders. Grep it, version it, read it, fork it. Zero lock-in.

---

## Getting Started

### Step 0: What You Need

One of these AI coding tools (any works, Claude Code has the deepest integration):

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — full skill/hook support, native config
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) — reads `GEMINI.md`
- [Codex CLI](https://github.com/openai/codex) — reads `AGENTS.md`

Also works from VS Code and JetBrains IDEs (via their built-in AI integrations).

### Step 1: Clone and Open

```bash
git clone https://github.com/Nate-Vish/Auto-Mates.git
cd Auto-Mates
```

These files become your AI's team structure.

### Step 2: Meet Your Team Lead

```
/orca
```

Orca loads automatically — it reads the project, your past sessions, and walks you through everything.

### Step 3: Tell It What You Want

```
You: I want to build a budgeting app
Orca: Let me get the right agents on this...
```

You're the pilot. Agents are the crew. Describe what you want — Orca routes you to the right agent.

### Step 4: Save Your Progress

```
/memorize
```

Saves what happened, lessons learned, and your preferences — as text files in your local folder.

### Step 5: Come Back Anytime

Next session, agents pick up where they left off. No re-explaining. They read their own memory on startup.

---

MIT Licensed. Runs entirely on your machine. — See [LICENSE](LICENSE)

Built by [@Nate-Vish](https://github.com/Nate-Vish)
