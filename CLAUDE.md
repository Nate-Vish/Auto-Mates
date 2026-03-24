# AutoMates.AI

A coordinated AI development team. 10 specialized agents work together through a shared file-based workspace with persistent memory.

**Vision:** Make people's imagination become their creation.
**Method:** A simple & innovative Development Environment powered by a coordinated AI agent team.

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
| **BrainStorm** | Knowledge Graph | `/brainstorm` | `AgenTeam/BrainStorm/BrainStorm_Identity.md` | Adding notes, asking about topics, brainstorming |
| **Legal** | Compliance | `/legal` | `AgenTeam/Legal/Legal_Identity.md` | Licensing, privacy, regulations |
| **GitDude** | Release Manager | `/gitdude` | `AgenTeam/GitDude/GitDude_Identity.md` | Commits, versioning, releases |
| **Fetcher** | Researcher | `/fetcher` | `Library/Fetcher/Fetcher_Identity.md` | Gathering documentation, research |
| **Gal** | User Advocate | `/gal` | `AgenTeam/Gal/Gal_Identity.md` | Skeptical evaluation, UX testing |
| **Daisy** | Brand Director | `/daisy` | `AgenTeam/Daisy/Daisy_Identity.md` | Branding, social media, PR, pitches, speeches, ads |

### Agent Skills (In-Session Switch)

Use these skills to switch agents within the current session. Each performs a hard reset, loads the target agent's full identity and memory, and reads `Library/Registry.md` for routing awareness.

| Skill | Action |
|-------|--------|
| `/orca` | Switch to Orca (Orchestrator) — default home agent |
| `/planner` | Switch to Planner (Architect) |
| `/builder` | Switch to Builder (Developer) |
| `/checker` | Switch to Checker (QA + Security) |
| `/brainstorm` | Switch to BrainStorm (Knowledge Graph) |
| `/legal` | Switch to Legal (Compliance) |
| `/gitdude` | Switch to GitDude (Release Manager) |
| `/fetcher` | Switch to Fetcher (Researcher) |
| `/gal` | Switch to Gal (User Advocate) |
| `/daisy` | Switch to Daisy (Brand Director) |
| `/forge` | Create a new agent (6-phase guided process) |

### Other Commands

Use `/summon <agent>` to launch an agent in a separate terminal.
Use `/brief` to check project state and team status.
Use `/memorize` to save agent memory (Sessions, Lessons, Preferences, Checkpoint, Context) and update Brief.md.
Use `/video` to create videos — recaps, explainers, comparisons, demos, marketing.
Use `/slides` to create presentations (PPTX or HTML slideshow) from any content.
Use `/cv` to build or tailor a resume for a job application (intake, fit assessment, scoring, export).
Use `/idea` to quick-capture an idea to BrainStorm's knowledge graph (works from any agent).

### Agent Teams (Parallel Work)

**Status:** Temporarily disabled (Anthropic fixing bugs). Available when `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set. Orca can lead teams:

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
   - `Library/Arsenal.yaml` — available tools, MCP servers, skills, CLIs
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
├── GEMINI.md                    # Gemini CLI integration
├── AGENTS.md                    # Codex CLI integration (auto-loaded)
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
    ├── Arsenal.yaml               # Tool/skill/MCP registry (single source)
    ├── Fetcher/                 # Fetcher agent (identity + memory)
    ├── Knowledge/               # Per-agent curated reading lists
    └── Sources/                 # Research library (agents study here before working)
```

---

## File Coordination

| File | Who Writes | Who Reads | Purpose |
|------|-----------|-----------|---------|
| `Arsenal.yaml` | Orca | All agents | Available tools, skills, MCPs, CLIs |
| `BLUEPRINT.md` | Planner | Builder, Checker | Project plan |
| `Brief.md` | All agents | All agents | Project state + team status |
| `KNOWLEDGE_REQUEST_[Agent].md` | Any agent | Fetcher | Research request |
| `[Agent]_Study.md` | Fetcher | Requesting agent | Research delivery |
| `REVIEW_[feature].md` | Checker | Builder, Planner | Quality review |
| `BRAINSTORM_[topic].md` | BrainStorm | Planner, Builder | Creative ideas |
