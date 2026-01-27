# Changelog

All notable changes to AutoMates.AI will be documented in this file.

---

## [v1.1] - 2026-01-27

### Added
- **Orca** — New orchestrator agent that modifies existing agents, creates new ones, and manages team structure
- **BrainStorm Ideas/ folder** — `Shared_Ideas.md` and `Implemented_Ideas.md` for capturing creative sparks
- **`💡 IDEA:` function** — Tell BrainStorm your idea mid-conversation, he logs it instantly without breaking flow
- **Orca_Logo.png** — Logo for the new agent

### Changed
- **8 agents** (was 7) — Orca joins the team
- **README.md completely rewritten** — Correct workflow, clearer structure, user-friendly language
- **Fetcher upgraded** — Now respects robots.txt before fetching, and creates Study Files (like `Builder_Study.md`) so agents learn from sources before working

### Major Improvements
- **Legal documents** — Full LICENSE (MIT), CONTRIBUTING.md, and TRADEMARK.md now included and polished
- **Agent Memory System** — Was empty templates, now fully structured and alive:
  - `README.md` in each Memory_Logs/ — Navigation guide so agents know where to look
  - `Checkpoint.md` — Save/resume complex multi-step tasks
  - `Sessions/` folder — Organized conversation history
  - `Notes/` folder — Technical knowledge files
  - `Lessons.md` — Patterns that worked, mistakes to avoid
  - `Preferences.md` — How the user likes things done
  - **Agents now wake up with full context** — They read their memory first, instantly understand what's going on

### Removed
- **User_Guide.md** — Redundant with new README

### Fixed
- Example API keys now clearly marked as fake (`sk_live_EXAMPLE_KEY_DO_NOT_USE`)

---

## [v1.0] - 2026-01-15

### Initial Release
- **7 agents:** BrainStorm, Planner, Builder, Checker, Legal, GitDude, Fetcher
- **Memory system:** Sessions/, Notes/, Lessons.md, Preferences.md, Checkpoint.md
- **LEARN FIRST protocol** — Agents research before acting
- **File-based coordination** — Agents collaborate through Dashboard/Work_Space/
- **AutoMates_Logos/** — 14 folder icons for visual organization
- **Legal docs:** LICENSE (MIT), CONTRIBUTING.md, TRADEMARK.md
