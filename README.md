# Claude-Mates

**Your AI dev team for Claude Code.**

---

## The Problem

Tired of re-explaining your project to Claude every session? Frustrated when AI forgets the architectural decisions you made last week? Wish you had specialized help instead of one AI trying to do everything? Sick of AI being a black box you can't inspect?

**Claude-Mates solves this** with:
- **Persistent memory** - Agents remember your project, preferences, and past decisions
- **Specialized roles** - Planner plans, Builder builds, Checker checks (each excels at their job)
- **Full transparency** - No black box. Every decision, every plan, every learned lesson is in files you can read, grep, diff, and version control. See exactly what each agent knows and decided.

---

## Quick Start

### 1. Get Claude-Mates

**Option A: Start a new project with Claude-Mates**
```bash
git clone https://github.com/automates-ai/claude-mates.git my-project
cd my-project
```

**Option B: Add to an existing project**
```bash
# From your project root:
git clone https://github.com/automates-ai/claude-mates.git temp-claude-mates
cp -r temp-claude-mates/{.claude,agents,Dashboard,CLAUDE.md} .
rm -rf temp-claude-mates
```

### 2. Start Claude Code

```bash
claude
```

Claude Code automatically loads `CLAUDE.md` which tells it about the `/summon` skill.

### 3. Summon an Agent

```
/summon planner
```

A new terminal opens with Planner ready to help.

### 4. Verify It Worked

You should see:
- A new terminal window with a **blue** background
- Claude identifying as "The Planner"
- Claude automatically reading its memory files and greeting you

> **Note:** The `/summon` command is a Claude Code skill included in this repo (in `.claude/skills/`). It's automatically available when you run `claude` from this directory.

---

## Available Agents

| Agent | Command | Role |
|-------|---------|------|
| **Planner** | `/summon planner` | Creates blueprints and roadmaps |
| **Builder** | `/summon builder` | Writes code, implements features |
| **Checker** | `/summon checker` | Reviews code, finds bugs and security issues |
| **BrainStorm** | `/summon brainstorm` | Generates ideas, explores solutions |
| **Gal** | `/summon gal` | Tests UX, asks skeptical questions |
| **Legal** | `/summon legal` | Licensing, privacy, compliance |
| **GitDude** | `/summon gitdude` | Commits, versioning, releases |
| **Fetcher** | `/summon fetcher` | Gathers documentation and research |
| **Orca** | `/summon orca` | Designs agent workflows |

### Shortcuts

```
/summon team          # Planner + Builder + Checker
/summon all           # All 9 agents
/summon builder,checker  # Specific agents
```

---

## How It Works

### 1. Describe Your Project

Edit `Dashboard/Project_Description.md` with your project details.

### 2. Plan with Planner

```
/summon planner
> I want to build a CLI tool that converts markdown to HTML
```

Planner creates `Dashboard/Work_Space/BLUEPRINT.md` with the implementation plan.

### 3. Build with Builder

```
/summon builder
```

Builder reads the blueprint and implements the code.

### 4. Review with Checker

```
/summon checker
```

Checker reviews the code for bugs, security issues, and quality.

### 5. Iterate

Repeat until your project is complete. Agents coordinate through shared files in `Dashboard/Work_Space/`.

---

## Coordination

Agents don't talk to each other directly. They coordinate through the Dashboard:

```
Dashboard/
├── Project_Description.md  # Your project details (you edit)
├── Rules.md                # Project rules
├── Daily_Brief.md          # Latest updates from all agents
└── Work_Space/
    ├── BLUEPRINT.md        # Planner writes, Builder reads
    └── Status.md           # Current project state
```

### Daily Brief - How Agents Stay in Sync

When an agent completes significant work, it updates `Daily_Brief.md`:

```markdown
### 2026-02-03
- **Builder:** Fixed /summon skill - identity now loads automatically
- **Planner:** Created blueprint for authentication feature
- **Checker:** Found 3 security issues in API endpoints
```

When any agent starts a new session, it reads the Daily Brief to catch up on what other agents did. No agent works in isolation - everyone sees the full picture.

Everything is transparent - you can read any file to see what's happening.

---

## Memory

Each agent remembers across sessions:

```
agents/<agent>/Memory_Logs/
├── Sessions/       # What happened in past sessions
├── Notes/          # Technical knowledge learned
├── Lessons.md      # Patterns and mistakes to remember
├── Preferences.md  # How you like things done
└── Checkpoint.md   # Resume interrupted tasks
```

No more re-explaining your project every time.

---

## Terminal Profiles (Optional)

Color-coded terminal tabs make it easy to identify agents:

### macOS (iTerm2)

1. Open iTerm2 Preferences → Profiles
2. Import `terminal-profiles/iterm2-profiles.json`
3. Agents now open with their signature colors

### Windows Terminal

1. Open Settings → Add new profile
2. Import from `terminal-profiles/windows-terminal.json`

### Colors

| Agent | Color |
|-------|-------|
| Planner | Blue |
| Builder | Orange |
| Checker | Green |
| BrainStorm | Yellow |
| Gal | Bright Blue |
| Legal | Black |
| GitDude | Purple |
| Fetcher | Brown |
| Orca | Navy |

---

## Requirements

- **Claude Code** - [Install Claude Code](https://claude.ai/code)
- **Terminal** - Works with iTerm2, Terminal.app, Windows Terminal, gnome-terminal, etc.

No API keys required for basic usage.

---

## The AutoMates Paradigm

Claude-Mates isn't just different prompts - it's a different way of working:

| Traditional AI | Claude-Mates |
|----------------|--------------|
| AI as assistant | AI as team |
| Single generalist | Specialized roles |
| Conversations (ephemeral) | Files (persistent) |
| Black box | Transparent |
| "Just generate" | LEARN FIRST, then act |

---

## FAQ

### How is this different from just using Claude Code?

**Concrete example:** You tell Planner on Monday that your app uses PostgreSQL, not MySQL. On Friday, you `/summon builder` - Builder reads Planner's notes and already knows your database choice. No re-explaining.

Regular Claude Code forgets everything between sessions. Claude-Mates agents write to `Memory_Logs/` and read it on startup.

### Can agents talk to each other?

Not directly. They coordinate through shared files in `Dashboard/Work_Space/`. This keeps everything transparent and auditable - you can `grep` any decision.

### Does memory really persist?

Yes. Each agent has a `Memory_Logs/` folder:
- `Sessions/` - What happened in past sessions
- `Lessons.md` - "Never use that API, it's deprecated"
- `Preferences.md` - "User prefers TypeScript over JavaScript"

### What if I don't need all 9 agents?

Start with the core team: `/summon team` gives you Planner, Builder, and Checker. Add others as needed.

---

## Troubleshooting

### `/summon` command not found

Make sure you're running `claude` from the Claude-Mates directory (where `CLAUDE.md` exists). The skill is registered in `.claude/skills/summon/`.

### Agent doesn't load identity

Check that the terminal opened and Claude started. The agent should automatically identify itself and read its memory. If it says "I'm Claude Code" instead of the agent name, the `--append-system-prompt` may have failed - try running `/summon` again.

### Terminal doesn't open

On macOS, the script uses Terminal.app by default (or iTerm2 if installed). Check that you have terminal access permissions in System Preferences → Privacy & Security.

### Agent doesn't remember past sessions

Check each memory section in `agents/<agent>/Memory_Logs/`:

| Section | File | Problem if missing |
|---------|------|-------------------|
| Session history | `Sessions/Session.md` | Agent doesn't know what happened before |
| Learned lessons | `Lessons.md` | Agent repeats past mistakes |
| Your preferences | `Preferences.md` | Agent doesn't know your coding style |
| Technical notes | `Notes/Note.md` | Agent forgets project-specific knowledge |
| Task checkpoint | `Checkpoint.md` | Agent can't resume interrupted work |

If a file is empty or missing, the agent starts fresh for that section.

---

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT License - See [LICENSE](LICENSE)

---

## Links

- [AutoMates.AI](https://automates.ai) - The full AutoMates platform
- [Claude Code](https://claude.ai/code) - Anthropic's coding assistant
- [Issues](https://github.com/automates-ai/claude-mates/issues) - Report bugs or request features

---

*Made with the AutoMates paradigm: "Make imagination become creation."*
