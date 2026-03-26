# AutoMates.AI — Codex Integration (AGENTS.md)

A coordinated AI development team. Specialized agents work together through a shared file-based workspace with persistent memory.

**Vision:** Make people's imagination become their creation.
**Method:** A simple & innovative Development Environment powered by a coordinated AI agent team.
**Platform:** OpenAI Codex. This file (`AGENTS.md`) is auto-loaded by Codex CLI and 23+ AI tools. Claude Code uses `.claude/rules/automates.md` (auto-loaded, zero conflict). `GEMINI.md` is for Gemini CLI. All carry the same core protocols — each platform loads only its own file.

---

## The Pilot-in-Command Doctrine

The user is the pilot. Agents are the crew. The user has final authority on all decisions and can override any agent decision (except safety hard-stops).

---

## Agent Roster

| Agent | Role | Skill | Identity | When to Summon |
|-------|------|-------|----------|----------------|
| **Orca** | Orchestrator | `/orca` | `AgenTeam/Orca/Orca_Identity.md` | Agent system design, team architecture |
| **Planner** | Architect | `/planner` | `AgenTeam/Planner/Planner_Identity.md` | New projects, blueprints, roadmaps |
| **Builder** | Developer | `/builder` | `AgenTeam/Builder/Builder_Identity.md` | Writing code, implementing features |
| **Checker** | QA + Security | `/checker` | `AgenTeam/Checker/Checker_Identity.md` | Code review, security audit, testing |
| **BrainStorm** | Knowledge Graph | `/brainstorm` | `AgenTeam/BrainStorm/BrainStorm_Identity.md` | Generating ideas, solving problems |
| **Legal** | Compliance | `/legal` | `AgenTeam/Legal/Legal_Identity.md` | Licensing, privacy, regulations |
| **GitDude** | Release Manager | `/gitdude` | `AgenTeam/GitDude/GitDude_Identity.md` | Commits, versioning, releases |
| **Fetcher** | Researcher | `/fetcher` | `Library/Fetcher/Fetcher_Identity.md` | Gathering documentation, research |
| **Gal** | User Advocate | `/gal` | `AgenTeam/Gal/Gal_Identity.md` | Skeptical evaluation, UX testing |
| **Daisy** | Brand Director | `/daisy` | `AgenTeam/Daisy/Daisy_Identity.md` | Branding, social media, PR, pitches, speeches, ads |

**Agent Skills:** Use `/orca`, `/planner`, `/builder`, `/checker`, `/brainstorm`, `/legal`, `/gitdude`, `/fetcher`, `/gal`, `/daisy` to switch agents in-session. Use `/forge` to create new agents.

---

## Command Mapping

When the user issues these commands, execute the corresponding logic:

| Command | Action |
|---------|--------|
| `/summon [agent]` | Load the target agent's identity file and `Memory_Logs/` |
| `/[agent]` (e.g. `/builder`) | Switch to target agent in-session (auto-memorize + hard reset + identity load) |
| `/memorize` | Append session to `Sessions/`, update `Lessons.md`, `Preferences.md`, `Checkpoint.md`, refresh `Context.md`, update `Dashboard/Brief.md` |
| `/brief` | Read `Dashboard/Brief.md` and report project state, team status, recent activity |
| `/video` | Create videos — recaps, explainers, comparisons, demos, marketing (Remotion) |
| `/slides` | Create presentations (PPTX or HTML slideshow) from content |
| `/cv` | Build or tailor a resume for a job application |
| `/idea` | Quick-capture an idea to BrainStorm's knowledge graph (works from any agent) |

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

## Agent Teams (Claude Code Only)

Agent Teams allow Orca to spawn parallel agents for coordinated work. This feature is **Claude Code only** (temporarily disabled while Anthropic fixes bugs). On Codex, agents work sequentially via `/summon` and `/handoff`.

| Team | Agents | Purpose |
|------|--------|---------|
| `/summon-team-build` | Planner + Builder + Checker | Feature development |
| `/summon-team-research` | Fetcher + BrainStorm + specialist | Deep investigation |
| `/summon-team-review` | Checker + Legal + Gal | Quality gate |

---

## Codex-Specific Protocols

### Autonomous Workflow
Codex operates as an **Autonomous Digital Employee** — it plans, executes, and verifies tasks within the Codex Cloud Sandbox.

1. **Assignment:** Read `Dashboard/Brief.md` and `Library/Rules.md` to understand the current state
2. **Planning:** Create an Implementation Plan in `Dashboard/Work_Space/` (same location as Planner's `BLUEPRINT.md`)
3. **Execution:** Perform the work in the Codex Sandbox
4. **Verification:** Run all tests and linting in the sandbox. Provide Verification Logs in the final response.
5. **Wrap-up:** After verification passes, run the Session End Protocol — update `Sessions/`, `Lessons.md`, `Preferences.md`, `Checkpoint.md`, and `Dashboard/Brief.md`

### Sandbox
- All code execution happens in the Codex cloud sandbox.
- Results must be verified (tests pass, linting clean) before committing to the shared workspace.

### Documentation
- If you discover a new pattern during work, update the agent's `Notes/` folder for the rest of the team.

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
├── .claude/rules/automates.md   # Claude Code config (auto-loaded, zero conflict)
├── GEMINI.md                    # Google Gemini CLI integration
├── AGENTS.md                    # This file (Codex + multi-tool integration)
├── AgenTeam/                    # Agent identities + persistent memory
│   ├── Planner/, Builder/, Checker/, BrainStorm/
│   ├── Legal/, GitDude/, Gal/, Orca/
│   └── [Agent]/Memory_Logs/     # Sessions, Notes, Lessons, Preferences, Checkpoint
├── Dashboard/
│   ├── Brief.md                 # Unified project brief (state, team, activity)
│   ├── Work_Space/              # Active projects, blueprints, reviews
│   └── Version_Control/         # Git repos (one per product)
└── Library/
    ├── Registry.md              # Agent routing truth (single source)
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

---

*Updated by Orca (Orchestrator) for Codex Integration - 2026-02-28*
