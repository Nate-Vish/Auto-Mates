# Changelog

All notable changes to AutoMates.AI will be documented in this file.

---

## [Current] - 2026-03-24

### Added
- **Daisy** — Brand Director agent (10th agent). Branding, social media, PR, pitches, content strategy
- **Arsenal.yaml** — Single source of truth for all tools, MCP servers, skills, and CLIs
- **21+ slash commands** — Agent switches, `/forge`, `/brief`, `/memorize`, `/compact`, `/video`, `/slides`, `/cv`, `/idea`, `/automates`, team pipelines
- **Professional Knowledge** — 89 topic files across 10 agents (Library/Knowledge/). Self-contained expertise, no external dependencies
- **BrainStorm Knowledge Graph** — 60+ nodes, 387+ connections, personal mind map system with MindMap.md index
- **Landing page** — automate-s.com with HTTPS, "How It Works" guide, sunrise theme
- **Multi-platform support** — CLAUDE.md (Claude Code), GEMINI.md (Gemini CLI), AGENTS.md (Codex CLI)
- **`/idea` skill** — Quick-capture ideas to BrainStorm's graph from any agent
- **`/video` skill** — Create videos via Remotion (recaps, explainers, demos)
- **`/slides` skill** — Create PPTX or HTML presentations
- **`/cv` skill** — Build/tailor resumes for job applications
- **`/forge` skill** — 6-phase guided agent creation
- **office-skills toolkit** — PPTX, DOCX, XLSX, PDF creation (Library/office-skills/)
- **Stitch MCP** — Design generation and editing via Google Cloud
- **Agent Teams** — `/summon-team-build`, `/summon-team-research`, `/summon-team-review` (parallel pipelines)

### Changed
- **10 agents** (was 9) — Daisy joins the team
- **CODEX.md deleted** — Codex CLI auto-loads AGENTS.md, not CODEX.md. Redundant file removed
- **Tools/ merged into Library/** — office-skills now at Library/office-skills/
- **Wake-Up Protocol expanded** — Now reads Arsenal.yaml + Knowledge section on startup
- **LEARN FIRST enforced** — Every agent researches before coding
- **Registry.md** — Full routing table with boundaries and standard chains
- **Brief.md** — Unified dashboard (replaces Daily_Brief + Status.md)
- **All agent identities** — Added boundaries, handoff chains, knowledge sections, shared context

### Improved
- **Memory system** — Context.md quick snapshots, /memorize auto-saves all memory files
- **File coordination** — Arsenal.yaml, BLUEPRINT.md, KNOWLEDGE_REQUEST, REVIEW, BRAINSTORM files
- **Security** — Git history purge (25 rules), pre-commit PII + secret scanning protocol
- **README** — Personal voice, GIF placeholders, 6-step Getting Started, dev-to-dev tone

---

## [v1.3] - 2026-02-25

### Added
- **Playwright CLI** — Browser automation for Checker, Fetcher, Gal (replaces MCP, 4x fewer tokens)
- **Knowledge system** — Builder (18 topics), Checker (7), GitDude (10), Planner (17), Gal (29 files), Orca (6 pillars)
- **`/memorize` skill** — One command to save all agent memory files
- **`/compact` skill** — Archive old sessions, refresh Context.md
- **Multi-platform configs** — GEMINI.md and CODEX.md alongside CLAUDE.md
- **Agent boundary system** — Each agent has defined lanes and handoff chains

### Changed
- **All agent identities hardened** — Memory sections, Knowledge sections, boundary awareness
- **Skill renames** — /team-build → /summon-team-build, etc.
- **Version_Control restructured** — One folder per product, repo root = latest, old versions in git tags

---

## [v1.2] - 2026-01-28

### Added
- **Gal** — User advocate agent (skeptical senior dev perspective)
- **Brief.md** — Unified project brief (merged from Daily_Brief + Status.md)
- **Project_Description.md** — Full AutoMates vision and problem statement
- **Agent Wake-Up Protocol** — Standardized 3-step startup for all agents

### Changed
- **9 agents** (was 8) — Gal joins the team
- **All agent identities updated** — Dashboard reading in wake-up protocol

---

## [v1.1] - 2026-01-27

### Added
- **Orca** — Orchestrator agent (team management, agent creation)
- **BrainStorm Ideas/** — Idea capture with `IDEA:` prefix
- **Agent Memory System** — Fully structured: Checkpoint, Sessions, Notes, Lessons, Preferences

### Changed
- **8 agents** (was 7) — Orca joins
- **README completely rewritten**
- **Fetcher upgraded** — robots.txt respect, Study Files for agent learning

---

## [v1.0] - 2026-01-15

### Initial Release
- **7 agents:** BrainStorm, Planner, Builder, Checker, Legal, GitDude, Fetcher
- **Memory system:** Sessions/, Notes/, Lessons.md, Preferences.md, Checkpoint.md
- **LEARN FIRST protocol** — Agents research before acting
- **File-based coordination** — Dashboard/Work_Space/
- **Legal docs:** LICENSE (MIT), CONTRIBUTING.md, TRADEMARK.md
