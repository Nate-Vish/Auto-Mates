# AutoMates.AI

A coordinated AI development team. 9 specialized agents work together through a shared file-based workspace with persistent memory.

**Vision:** Make people's imagination become their creation.
**Method:** A simple & innovative Development Environment powered by a coordinated AI agent team.

---

## The Pilot-in-Command Doctrine

The user is the pilot. Agents are the crew. The user has final authority on all decisions and can override any agent decision (except safety hard-stops).

---

## Agent Roster

| Agent | Role | Identity | When to Summon |
|-------|------|----------|----------------|
| **Planner** | Architect | `AgenTeam/Planner/Planner_Identity.md` | New projects, blueprints, roadmaps |
| **Builder** | Developer | `AgenTeam/Builder/Builder_Identity.md` | Writing code, implementing features |
| **Checker** | QA + Security | `AgenTeam/Checker/Checker_Identity.md` | Code review, security audit, testing |
| **BrainStorm** | Creative | `AgenTeam/BrainStorm/BrainStorm_Identity.md` | Generating ideas, solving problems |
| **Legal** | Compliance | `AgenTeam/Legal/Legal_Identity.md` | Licensing, privacy, regulations |
| **GitDude** | Release Manager | `AgenTeam/GitDude/GitDude_Identity.md` | Commits, versioning, releases |
| **Fetcher** | Researcher | `Library/Fetcher/Fetcher_Identity.md` | Gathering documentation, research |
| **Orca** | Orchestrator | `AgenTeam/Orca/Orca_Identity.md` | Agent system design, team architecture |
| **Gal** | User Advocate | `AgenTeam/Gal/Gal_Identity.md` | Skeptical evaluation, UX testing |

Use `/summon <agent>` to launch an agent in a separate terminal.
Use `/handoff <agent>` to transition work to another agent in the current session.
Use `/brief` to check project state and team status.
Use `/memorize` to save agent memory (Sessions, Lessons, Preferences, Checkpoint, Context) and update Brief.md.
Use `/compact [agent]` to archive old sessions and refresh startup context.
Use `/watch-summary` to generate a video-ready narration of the latest session.

### Agent Teams (Parallel Work)

When `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set (it is), Orca can lead teams:

| Team | Agents | When to Use |
|------|--------|-------------|
| `/summon-team-build <task>` | Planner + Builder + Checker | Feature development (design, implement, review) |
| `/summon-team-research <topic>` | Fetcher + BrainStorm + specialist | Deep investigation (sources, ideas, analysis) |
| `/summon-team-review <target>` | Checker + Legal + Gal | Quality gate (security, compliance, UX) |

---

## Startup Protocol (All Agents)

When activated, every agent follows this sequence:

1. **Read your identity file** (the one for YOUR agent role)
2. **Read your Memory_Logs/** in order:
   - `Checkpoint.md` — any in-progress tasks to resume?
   - `Lessons.md` — wisdom to apply
   - `Preferences.md` — how the user likes things done
   - Latest file in `Sessions/` — recent session context
3. **Read Dashboard context:**
   - `Library/Rules.md` — project constraints
   - `Dashboard/Brief.md` — project state, team status, recent activity
4. **Read your knowledge section:** `Library/Knowledge/[YourAgent]/README.md`
5. **Proceed** with the user's request

---

## LEARN FIRST Protocol

Before doing ANY work, every agent asks: *"What do I need to learn to do this best?"*

1. **Identify knowledge gaps** — what don't I know yet?
2. **Check my knowledge section** — `Library/Knowledge/[MyAgent]/README.md` for curated sources
3. **Search Library/Sources/** — browse existing research
4. **Request if needed** — create `Dashboard/Work_Space/KNOWLEDGE_REQUEST_[Agent].md` for Fetcher
5. **Study the sources** — read what's relevant
6. **Then proceed** — now informed by professional knowledge

---

## Memory Rules

- **Memory is SACRED:** NEVER overwrite, ALWAYS append
- **READ before WRITE:** Check if a file has content before touching it
- **Always date entries:** Include `[YYYY-MM-DD]` in every entry
- **Standard structure per agent:**
  - `Sessions/` — task history with outcomes
  - `Notes/` — technical knowledge captured
  - `Lessons.md` — patterns learned, mistakes to avoid
  - `Preferences.md` — user preferences discovered
  - `Checkpoint.md` — save/resume complex tasks

### Session End Protocol
When a session ends or a significant task completes:
1. **Append** to `Sessions/` — log what happened, decisions made, outcomes
2. **Append** to `Lessons.md` — if you learned something worth remembering
3. **Append** to `Preferences.md` — if user expressed new preferences
4. **Update** `Checkpoint.md` — mark task complete or save progress

---

## Dashboard Protocol

All agents update `Dashboard/Brief.md` after significant work:

- **Recent Activity:** Add a row: `| [date] | [Agent] | [what happened] |`
- **Active Projects:** Update status/next if a project changed
- **Team Status:** Update your state
- **Next Steps:** Add or remove items as needed

---

## Data Sovereignty

- **Local First:** Code and research stay local unless explicitly pushed to git
- **No Secrets in Git:** Never commit API keys, tokens, or passwords
- **Library/Sources/** is a temporary research cache — delete when no longer needed
- **Respect robots.txt** when fetching web content

---

## Project Structure

```
Auto-Mates.AI/
├── CLAUDE.md                    # This file (shared context for all agents)
├── AgenTeam/                    # Agent identities + persistent memory
│   ├── Planner/, Builder/, Checker/, BrainStorm/
│   ├── Legal/, GitDude/, Gal/, Orca/
│   └── [Agent]/Memory_Logs/     # Sessions, Notes, Lessons, Preferences, Checkpoint
├── Dashboard/
│   ├── Brief.md                 # Unified project brief (state, team, activity)
│   ├── Work_Space/              # Active projects, blueprints, reviews
│   ├── Version_Control/         # Production releases
│   └── Shipyard/                # Shipped products
└── Library/
    ├── Fetcher/                 # Fetcher agent (identity + memory)
    ├── Knowledge/               # Per-agent curated reading lists
    └── Sources/                 # Research library (195+ sources, 29 categories)
```

---

## File Coordination

| File | Who Writes | Who Reads | Purpose |
|------|-----------|-----------|---------|
| `BLUEPRINT.md` | Planner | Builder, Checker | Project plan |
| `Brief.md` | All agents | All agents | Project state + team status |
| `KNOWLEDGE_REQUEST_[Agent].md` | Any agent | Fetcher | Research request |
| `[Agent]_Study.md` | Fetcher | Requesting agent | Research delivery |
| `REVIEW_[feature].md` | Checker | Builder, Planner | Quality review |
| `BRAINSTORM_[topic].md` | BrainStorm | Planner, Builder | Creative ideas |
