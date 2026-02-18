# Blueprint: Claude-Mates

**Version:** 1.0
**Created:** 2026-01-31
**Author:** Planner
**Status:** APPROVED

---

## The User Story

**Need:** Claude Code users want a coordinated AI development team with specialized agents, but setting up AutoMates from scratch is too complex.

**Value:** Claude-Mates packages the AutoMates paradigm as a ready-to-use Claude Code configuration repo. Users clone it and immediately have access to specialized agents (Planner, Builder, Checker, etc.) with persistent memory and transparent coordination.

**Success Criteria:**
1. User can clone and start using agents in under 5 minutes
2. Memory persists automatically across sessions
3. Agents feel specialized (distinct identities, not just different prompts)
4. `/summon` command launches agents in separate terminals
5. At least 100 GitHub stars within 3 months
6. Gal says "I'd use this"

---

## The Logic

### User Journey

```
1. User discovers Claude-Mates (GitHub, social, word-of-mouth)
       ↓
2. User clones the repo to their project folder
       ↓
3. User runs `claude` - Claude Code loads CLAUDE.md config
       ↓
4. User types `/summon planner` - Planner launches in new tab
       ↓
5. Planner reads its identity, auto-creates memory folder
       ↓
6. User describes what they want to build
       ↓
7. Planner creates BLUEPRINT.md in Dashboard/Work_Space/
       ↓
8. User summons Builder: `/summon builder`
       ↓
9. Builder reads BLUEPRINT.md, implements the plan
       ↓
10. User summons Checker: `/summon checker`
       ↓
11. Checker reviews Builder's work, flags issues
       ↓
12. Cycle repeats until project is complete
```

### Agent Coordination Flow

Agents coordinate through shared files, not direct communication:

```
┌─────────────────────────────────────────────────────────┐
│                    Dashboard/                            │
│  ┌─────────────────────────────────────────────────┐   │
│  │                Work_Space/                       │   │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐   │   │
│  │  │BLUEPRINT  │  │ Status.md │  │  Output   │   │   │
│  │  │   .md     │  │           │  │  files    │   │   │
│  │  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘   │   │
│  │        │              │              │         │   │
│  └────────┼──────────────┼──────────────┼─────────┘   │
│           │              │              │             │
│   ┌───────┴───────┬──────┴──────┬───────┴───────┐    │
│   │               │             │               │    │
│   ▼               ▼             ▼               ▼    │
│ Planner       Builder       Checker        Others   │
│ (writes)      (reads/       (reads/        (read/   │
│               implements)   reviews)       write)   │
└─────────────────────────────────────────────────────────┘
```

### Memory System (Pre-Built)

Memory is **pre-built** like the dashboard - agents know exactly where to read and write.

**Every agent has the same memory structure:**

```
agents/<agent>/Memory_Logs/
├── README.md           # Navigation guide (how to use memory)
├── Checkpoint.md       # Current task tracking (save/resume)
├── Lessons.md          # Patterns learned, mistakes to avoid
├── Preferences.md      # How the user likes things done
├── Sessions/
│   └── Session.md      # Session history (what happened, decisions)
└── Notes/
    └── Note.md         # Technical knowledge, research notes
```

**What each file contains:**

| File | Purpose | Agent Reads | Agent Writes |
|------|---------|-------------|--------------|
| `README.md` | How to use memory system | At start | Never |
| `Checkpoint.md` | Save/resume complex tasks | At start | During multi-step work |
| `Lessons.md` | Wisdom from experience | At start | When learning something |
| `Preferences.md` | User's preferences | At start | When user expresses preference |
| `Sessions/Session.md` | Session history | At start | At end of session |
| `Notes/Note.md` | Technical knowledge | When relevant | When discovering useful info |

**Agent startup protocol:**

```
1. Agent reads identity file (agents/<agent>/<Agent>_Identity.md)
       ↓
2. Agent reads Memory_Logs/README.md (navigation guide)
       ↓
3. Agent reads Checkpoint.md (any in-progress tasks?)
       ↓
4. Agent reads Sessions/ folder (past context)
       ↓
5. Agent reads Lessons.md and Preferences.md
       ↓
6. Agent reads Dashboard (Project_Description, Rules, Work_Space)
       ↓
7. Agent is ready to work
```

**Identity files include clear paths:**
Each agent's identity file explicitly states:
- `My identity: agents/<agent>/<Agent>_Identity.md`
- `My memory: agents/<agent>/Memory_Logs/`
- `Dashboard: dashboard/`
- `Work Space: dashboard/Work_Space/`

---

## The Study

### Approach

Claude-Mates is a **Claude Code configuration repository** - not a standalone application. It leverages Claude Code's existing features:

1. **CLAUDE.md** - Project-level configuration that Claude reads automatically
2. **Skills** - Custom commands (like `/summon`) defined in `.claude/skills/`
3. **Identity files** - Agent personalities loaded via `--identity` flag

### Why This Approach

| Alternative | Why Not |
|-------------|---------|
| Build a CLI from scratch | High effort, duplicates Claude Code functionality |
| Use MCP servers | Adds complexity, requires API setup |
| Single multi-prompt agent | Loses specialization benefit |
| **Skills + Identity files** | **Zero dependencies, immediate value, simple to understand** |

### Sources Referenced

- `Library/Sources/claude-code/custom-skills.md` - How to create skills
- `Library/Sources/claude-code/CLAUDE-md-config.md` - Project configuration
- `Library/Sources/terminal-automation/iterm2-scripting.md` - Multi-tab launching
- `Library/Sources/competition/claude-code/everything_claude_code_resource.md` - Production patterns

### Design Decisions

**D1: Full Identity Files**
- Include complete agent identities (~400 lines each)
- Rationale: Full power of the paradigm; simplified versions lose too much

**D2: Main Agents Only (MVP)**
- 9 agents: Planner, Builder, Checker, BrainStorm, Gal, Legal, GitDude, Fetcher, Orca
- Sub-agents deferred to v2
- Rationale: Simpler to understand; proves paradigm without complexity

**D3: Pre-Built Memory Structure**
- Memory folders are pre-built with template files (like dashboard)
- Each agent has identical memory structure in `agents/<agent>/Memory_Logs/`
- Rationale: Agents know exactly where to read/write; no guessing or creating

**D4: Cross-Platform Terminal Support**
- `/summon` works on macOS, Windows, and Linux
- Platform detection with graceful fallbacks:
  - **macOS:** iTerm2 → Terminal.app
  - **Windows:** Windows Terminal → PowerShell → CMD
  - **Linux:** gnome-terminal → konsole → xterm → tmux
- Rationale: Reach all Claude Code users, not just macOS

---

## The Tech

### Repository Structure

```
Claude-Mates/
├── README.md                    # User guide (how to install, use)
├── CLAUDE.md                    # Claude Code config (auto-loaded)
├── .claude/
│   └── skills/
│       └── summon/
│           ├── SKILL.md         # /summon command definition
│           └── summon.sh        # Agent launcher script
├── agents/
│   ├── planner/
│   │   ├── Planner_Identity.md      # Full identity
│   │   └── Memory_Logs/
│   │       ├── README.md            # Memory navigation guide
│   │       ├── Checkpoint.md        # Task tracking
│   │       ├── Lessons.md           # Patterns learned
│   │       ├── Preferences.md       # User preferences
│   │       ├── Sessions/
│   │       │   └── Session.md       # Session history
│   │       └── Notes/
│   │           └── Note.md          # Technical knowledge
│   ├── builder/
│   │   ├── Builder_Identity.md
│   │   └── Memory_Logs/             # Same structure
│   ├── checker/
│   │   ├── Checker_Identity.md
│   │   └── Memory_Logs/
│   ├── brainstorm/
│   │   ├── BrainStorm_Identity.md
│   │   └── Memory_Logs/
│   ├── gal/
│   │   ├── Gal_Identity.md
│   │   └── Memory_Logs/
│   ├── legal/
│   │   ├── Legal_Identity.md
│   │   └── Memory_Logs/
│   ├── gitdude/
│   │   ├── GitDude_Identity.md
│   │   └── Memory_Logs/
│   ├── fetcher/
│   │   ├── Fetcher_Identity.md
│   │   └── Memory_Logs/
│   └── orca/
│       ├── Orca_Identity.md
│       └── Memory_Logs/
├── dashboard/
│   ├── Project_Description.md   # User fills in: project name, vision, goals
│   ├── Rules.md                 # AutoMates rules (pre-filled)
│   ├── Daily_Brief.md           # Project updates (agents update this)
│   └── Work_Space/
│       ├── .gitkeep             # Empty, agents create files here
│       └── README.md            # Explains what goes in Work_Space
├── terminal-profiles/
│   ├── README.md                # How to import profiles (all platforms)
│   ├── iterm2-profiles.json     # macOS iTerm2 profiles
│   ├── windows-terminal.json    # Windows Terminal profiles
│   └── terminal-colors.md       # Reference for all platforms
└── LICENSE                      # MIT or similar
```

### Dashboard Templates Explained

The `dashboard/` folder is the project control center. Here's what each file does:

| File | Purpose | Who Edits | Content |
|------|---------|-----------|---------|
| `Project_Description.md` | Define your project | **User** | Project name, vision, goals, target users, success criteria |
| `Rules.md` | Project principles | Pre-filled | Pilot-in-command doctrine, data sovereignty, security rules |
| `Daily_Brief.md` | What's happening | Agents | Recent updates, current focus, team status (auto-updated) |
| `Work_Space/` | Active work area | Agents | BLUEPRINT.md, Status.md, and other work files created by agents |

**User fills in `Project_Description.md`:**
```markdown
# Project Description

## Project Name
[Your project name]

## Vision
[What are you building? Why does it matter?]

## Target Users
[Who is this for?]

## Success Criteria
[How do you know when it's done?]
```

**`Work_Space/` is where agents work:**
- Planner creates `BLUEPRINT.md` here
- Agents update `Status.md` with progress
- Output files, research, and drafts go here
- User can read everything (transparent coordination)

---

### Agent Colors

| Agent | Color | Hex | Description |
|-------|-------|-----|-------------|
| Planner | Blue | `#2196F3` | Calm, strategic |
| Builder | Orange | `#FF9800` | Energetic, productive |
| Checker | Green | `#4CAF50` | Quality, safety |
| BrainStorm | Yellow | `#FFEB3B` | Creative, bright |
| Legal | Black | `#212121` | Serious, formal |
| GitDude | Purple | `#9C27B0` | Version control |
| Fetcher | Bright Brown | `#D4A574` | Research, novel |
| Orca | Dark Navy | `#1A237E` | Deep, orchestrating |
| Gal | Bright Blue | `#03A9F4` | User-focused, questioning |

---

### Files to Create

**Root files:**
| File | Purpose | Source |
|------|---------|--------|
| `README.md` | User-facing install/usage guide | New |
| `CLAUDE.md` | Claude Code project config | New |
| `LICENSE` | Open source license | New (MIT) |

**Dashboard (4 files):**
| File | Purpose | Source |
|------|---------|--------|
| `dashboard/Project_Description.md` | Template for user's project | New (template) |
| `dashboard/Rules.md` | AutoMates rules | Copy from Dashboard |
| `dashboard/Daily_Brief.md` | Project updates template | New (template) |
| `dashboard/Work_Space/README.md` | Explains the work space | New |

**Agents (9 agents × 7 files each = 63 files):**
| File | Purpose | Source |
|------|---------|--------|
| `agents/<agent>/<Agent>_Identity.md` | Agent identity | Copy + adapt from AgenTeam |
| `agents/<agent>/Memory_Logs/README.md` | Memory navigation | Copy from AgenTeam templates |
| `agents/<agent>/Memory_Logs/Checkpoint.md` | Task tracking | Copy from AgenTeam templates |
| `agents/<agent>/Memory_Logs/Lessons.md` | Patterns learned | Copy from AgenTeam templates |
| `agents/<agent>/Memory_Logs/Preferences.md` | User preferences | Copy from AgenTeam templates |
| `agents/<agent>/Memory_Logs/Sessions/Session.md` | Session history | Copy from AgenTeam templates |
| `agents/<agent>/Memory_Logs/Notes/Note.md` | Technical notes | Copy from AgenTeam templates |

**Terminal profiles (4 files):**
| File | Purpose | Source |
|------|---------|--------|
| `terminal-profiles/README.md` | Setup instructions | New |
| `terminal-profiles/iterm2-profiles.json` | macOS iTerm2 | Update existing |
| `terminal-profiles/windows-terminal.json` | Windows Terminal | New |
| `terminal-profiles/terminal-colors.md` | Color reference | New |

### Files Already Done (Need Updates)

| File | Status | Updates Needed |
|------|--------|----------------|
| `.claude/skills/summon/SKILL.md` | Exists | Update for cross-platform support |
| `.claude/skills/summon/summon.sh` | Exists | Rewrite for Mac/Windows/Linux |
| `iterm2-profiles/README.md` | Exists | Rename folder, add cross-platform docs |
| `iterm2-profiles/automates-profiles.json` | Exists | Update colors to new scheme |

### CLAUDE.md Content

```markdown
# Claude-Mates Configuration

This project uses the AutoMates paradigm - a team of specialized AI agents.

## Available Agents

Use `/summon <agent>` to launch agents in separate terminals:

| Agent | Role | When to Use |
|-------|------|-------------|
| planner | Architect | Starting projects, creating blueprints |
| builder | Developer | Writing code, implementing features |
| checker | QA + Security | Reviewing code, finding bugs |
| brainstorm | Creative | Generating ideas, solving problems |
| gal | User Advocate | Testing UX, skeptical evaluation |
| legal | Compliance | Licensing, privacy, regulations |
| gitdude | Release Manager | Commits, versioning, releases |
| fetcher | Researcher | Gathering documentation, research |
| orca | Orchestrator | Designing agent workflows |

## Quick Start

1. `/summon planner` - Start with planning
2. Describe what you want to build
3. `/summon builder` - Implement the plan
4. `/summon checker` - Review the code

## Coordination

Agents share files in `dashboard/work-space/`:
- `BLUEPRINT.md` - Current plan (Planner writes, Builder reads)
- `Status.md` - Project status (all agents update)

## Memory

Each agent has pre-built memory in `agents/<name>/Memory_Logs/`:
- `Checkpoint.md` - Save/resume tasks
- `Sessions/` - Session history
- `Notes/` - Technical knowledge
- `Lessons.md` - Patterns learned
- `Preferences.md` - Your preferences

Memory persists across sessions - agents remember what they learned.
```

### Agent Identity Adaptations

Each agent identity file needs these modifications for Claude-Mates:

1. **Add explicit paths section** at the top:
   ```markdown
   ## My Locations
   - **My Identity:** `agents/<agent>/<Agent>_Identity.md`
   - **My Memory:** `agents/<agent>/Memory_Logs/`
   - **Dashboard:** `dashboard/`
   - **Work Space:** `dashboard/Work_Space/`
   ```

2. **Update all path references:**
   - `AgenTeam/` → `agents/`
   - `Dashboard/` → `dashboard/`
   - `Dashboard/Work_Space/` → `dashboard/Work_Space/`
   - `Library/Sources/` → `library/sources/` (if included)

3. **Ensure startup protocol references correct paths:**
   - Read `agents/<agent>/Memory_Logs/README.md`
   - Read `agents/<agent>/Memory_Logs/Checkpoint.md`
   - Read `agents/<agent>/Memory_Logs/Sessions/`
   - etc.

4. **Remove auto-create logic** - Memory is pre-built, agents just use it

### Implementation Phases

**Phase 1: Core Structure**
- [ ] Create `README.md` (user guide with quick start)
- [ ] Create `CLAUDE.md` (Claude Code project config)
- [ ] Create `dashboard/` folder:
  - [ ] `Project_Description.md` (template for user)
  - [ ] `Rules.md` (copy from existing)
  - [ ] `Daily_Brief.md` (template)
  - [ ] `Work_Space/README.md` (explains work space)
- [ ] Add `LICENSE` file (MIT)

**Phase 2: Agent Folders with Memory**
For each of the 9 agents, create:
- [ ] `agents/<agent>/<Agent>_Identity.md` (copy + adapt paths)
- [ ] `agents/<agent>/Memory_Logs/README.md`
- [ ] `agents/<agent>/Memory_Logs/Checkpoint.md`
- [ ] `agents/<agent>/Memory_Logs/Lessons.md`
- [ ] `agents/<agent>/Memory_Logs/Preferences.md`
- [ ] `agents/<agent>/Memory_Logs/Sessions/Session.md`
- [ ] `agents/<agent>/Memory_Logs/Notes/Note.md`

**Agents to create:**
- [ ] Planner (blue)
- [ ] Builder (orange)
- [ ] Checker (green)
- [ ] BrainStorm (yellow)
- [ ] Gal (bright blue)
- [ ] Legal (black)
- [ ] GitDude (purple)
- [ ] Fetcher (bright brown)
- [ ] Orca (dark navy)

**Phase 3: Terminal & Summon**
- [ ] Update `/summon` skill for cross-platform
- [ ] Create `terminal-profiles/README.md` (setup guide)
- [ ] Update `terminal-profiles/iterm2-profiles.json` (new colors)
- [ ] Create `terminal-profiles/windows-terminal.json`
- [ ] Create `terminal-profiles/terminal-colors.md` (reference)

**Phase 4: Testing & Polish**
- [ ] Test full user journey (clone → summon → use)
- [ ] Test on macOS (iTerm2, Terminal.app)
- [ ] Test on Windows (Windows Terminal, PowerShell)
- [ ] Test on Linux (gnome-terminal, or WSL)
- [ ] Verify memory persistence across sessions
- [ ] Get Gal's review
- [ ] Prepare for GitHub release

---

## Dependencies

- **Claude Code** - User must have Claude Code installed
- **Cross-platform** - Works on macOS, Windows, and Linux
- **No API keys required** - Works out of the box

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Identity files too large | Accept trade-off for full power |
| Memory folder clutters repo | Add to .gitignore by default |
| Terminal differences across platforms | Detect platform, use appropriate terminal with fallbacks |
| Users don't understand paradigm | Write clear README with examples and quick start guide |
| Windows path differences | Use relative paths, handle backslash/forward slash |

---

## Success Metrics

1. **Time to first agent** - Under 5 minutes from clone to working
2. **GitHub stars** - 100 within 3 months
3. **Issues/PRs** - Community engagement indicates value
4. **Gal approval** - "I'd use this"

---

## Next Steps

After approval:
1. Builder implements Phase 1 (Core Structure)
2. Builder implements Phase 2 (Agent Files)
3. Builder implements Phase 3 (Terminal & Summon)
4. Checker reviews implementation
5. Gal tests user experience
6. GitDude prepares GitHub release

---

*Blueprint created by Planner on 2026-01-31*
