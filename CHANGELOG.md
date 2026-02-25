# Changelog

## v1.3 — 2026-02-23

### New: Native Claude Code Integration

AutoMates now uses Claude Code's built-in features instead of manual copy-paste workflows.

**CLAUDE.md (Shared Context)**
- 151-line shared context auto-loaded every session
- All agents inherit: Startup Protocol, LEARN FIRST Protocol, Memory Rules, Dashboard Protocol, Session End Protocol
- Agent Roster with identity paths and when-to-summon guide
- Agent Teams table for parallel work

**9 Skills (Slash Commands)**
- `/summon <agent>` — Launch agent in new terminal (supports: single, comma-separated, team, all)
- `/handoff <agent>` — Switch agents in-session (saves context, loads new identity)
- `/brief` — Quick project state, team status, pending requests
- `/memorize` — Save agent memory (Sessions, Lessons, Preferences, Checkpoint, Context) + update Brief.md
- `/compact [agent]` — Archive old sessions, refresh Context.md
- `/team-build <task>` — Fetcher → Planner → Builder → Checker pipeline
- `/team-research <topic>` — Fetcher + BrainStorm + specialist
- `/team-review <target>` — Checker + Legal + Gal + GitDude quality gate
- `/watch-summary` — Generate a video-ready narration script of the latest session

**Agent Teams**
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` enabled
- Orca serves as Team Lead with orchestration rules
- Three team templates for common workflows

**Library/Knowledge/ (Per-Agent Reading Lists)**
- 9 curated knowledge sections pointing to Library/Sources/
- Fetcher auto-updates these when delivering research

**Late Additions (post-audit)**
- `/watch-summary` skill — session narration for AI video tools
- `/save` skill renamed to `/memorize` (directory now matches command)
- `/handoff` now runs full `/memorize` flow before transitioning

**Memory Restructure**
- Context.md per agent (quick startup snapshot)
- Archive/ per agent (compacted session storage)
- `/compact` skill for automated session archival

**Identity Streamlining**
- Removed ~418 lines of repeated protocol across 9 identities
- Added "Shared Context" sections referencing CLAUDE.md
- Orca: Agent Teams section (Team Lead role, orchestration rules)
- Fetcher: Knowledge Section Updates instruction

**Dashboard**
- Brief.md replaces Daily_Brief.md + Status.md (single source of truth)
- Rules.md moved from Dashboard/ to Library/
- Stop hook reminds agents to update memory on session end

**Infrastructure**
- summon.sh — Cross-platform launcher (iTerm2, Terminal.app, gnome-terminal, Windows Terminal)
- Hooks in settings.local.json for session end reminders
- Agent colors preserved from v1.2

### Changed from v1.2
- `agents/` → `AgenTeam/` (uppercase, reflects team identity)
- `dashboard/` → `Dashboard/`
- `Library/sources/` → `Library/Sources/`
- Fetcher now lives at `Library/Fetcher/` (near his Sources)
- `Dashboard/Rules.md` → `Library/Rules.md`
- `Daily_Brief.md` + `Status.md` → `Brief.md`
- Memory structure: added Context.md, Archive/, removed redundant protocol from identities

---

## v1.2 — 2026-02-13

- 9 agents with persistent memory
- File-based coordination via Dashboard/Work_Space
- Terminal color profiles
- LEARN FIRST protocol
- Cross-platform summon.sh launcher

## v1.1 — 2026-01-27

- 7 agents (Orca and Gal added later)
- Initial memory system
- Basic README and documentation

## v1.0 — 2026-01-24

- Initial release
- 6 agents with identity files
- Basic project structure
