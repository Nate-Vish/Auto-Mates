# Claude-Mates Configuration

This project uses the AutoMates paradigm - a team of specialized AI agents with persistent memory and transparent file-based coordination.

## Available Agents

Use `/summon <agent>` to launch agents in separate terminals:

| Agent | Color | Role | When to Use |
|-------|-------|------|-------------|
| planner | Blue | Architect | Starting projects, creating blueprints |
| builder | Orange | Developer | Writing code, implementing features |
| checker | Green | QA + Security | Reviewing code, finding bugs |
| brainstorm | Yellow | Creative | Generating ideas, solving problems |
| gal | Bright Blue | User Advocate | Testing UX, skeptical evaluation |
| legal | Black | Compliance | Licensing, privacy, regulations |
| gitdude | Purple | Release Manager | Commits, versioning, releases |
| fetcher | Brown | Researcher | Gathering documentation, research |
| orca | Navy | Orchestrator | Designing agent workflows |

## Quick Start

1. `/summon planner` - Start with planning
2. Describe what you want to build
3. Planner creates `Dashboard/Work_Space/BLUEPRINT.md`
4. `/summon builder` - Implement the plan
5. `/summon checker` - Review the code

## Coordination

Agents share files in `Dashboard/Work_Space/`:
- `BLUEPRINT.md` - Current plan (Planner writes, Builder reads)
- `Status.md` - Project status (all agents update)

## Memory

Each agent has persistent memory in `agents/<name>/Memory_Logs/`:
- `Checkpoint.md` - Save/resume tasks
- `Sessions/` - Session history
- `Notes/` - Technical knowledge
- `Lessons.md` - Patterns learned
- `Preferences.md` - Your preferences

Memory persists across sessions - agents remember what they learned.

## The AutoMates Way

> "The user is the pilot. The agents are the crew."

- **Specialized agents** - Each does one thing well
- **File-based coordination** - Transparent, auditable
- **Persistent memory** - No re-explaining every session
- **LEARN FIRST** - Agents research before they act
