# Sessions Log - Builder

*Session summaries: what happened, decisions made*

---

## 2026-02-03
- **Task:** Fix /summon skill - agent identity not loading properly
- **Files:** `.claude/skills/summon/summon.sh` (all 7 launcher functions)
- **Outcome:** SUCCESS - Agents now load identity and execute startup protocol automatically
- **Key decisions:**
  - Used `--append-system-prompt` with full identity content (not path)
  - Added STARTUP INSTRUCTION to trigger immediate action
  - Used temp launcher scripts to avoid escaping issues
  - Previous attempts failed: piping broke interactive mode, system prompt alone didn't trigger action

## 2026-02-03 (continued)
- **Task:** Fix README.md based on Gal's UX review
- **Files:** `README.md`
- **Outcome:** SUCCESS - All 5 must-fix items addressed
- **Changes made:**
  - Added "The Problem" section with pain points (context amnesia, black box)
  - Fixed clone flow with two clear options (new project vs existing)
  - Explained /summon origin (it's a skill in .claude/skills/)
  - Added verification step ("You should see...")
  - Improved FAQ with concrete example (PostgreSQL decision persists)
  - Added Troubleshooting section with memory breakdown table
  - Added Daily Brief explanation for agent coordination
  - Emphasized transparency ("No black box, everything in files")

## 2026-02-04
- **Task:** Terminal color scheme overhaul
- **Files:** `.claude/skills/summon/summon.sh`
- **Outcome:** SUCCESS - All 9 agents have distinct, WCAG-compliant colors
- **Key decisions:**
  - Builder/BrainStorm/Fetcher: Changed to brighter colors with dark text (were too similar before)
  - Legal: Deep Slate `#1E293B` - "trusted co-founder lawyer" feel
  - Orca: Charcoal `#18181B` - "like the whale", dark and deep
  - Added `get_agent_text_color()` function for per-agent text colors
  - Light backgrounds use dark text, dark backgrounds use off-white
  - Saved Deep Teal `#134E4A` for future use
- **User feedback:**
  - "Builder - awesome", "BrainStorm - exactly what I meant", "Fetcher - very good"
  - Legal needed most iteration (tested ~10 options before Deep Slate)
  - Planner/Legal/Orca now clearly distinct (blue → slate → charcoal)

## 2026-02-13
- **Task:** Fix iTerm2 text color bug (from Checker's FIX_REQUEST)
- **Files:** `.claude/skills/summon/summon.sh` (launch_iterm2 function)
- **Outcome:** SUCCESS - iTerm2 now sets text color matching Terminal.app
- **Key fix:**
  - Added `text_color` variable to iTerm2 case statement (lines 110-119)
  - Added `set foreground color to "${text_color}"` in AppleScript (line 156)
  - Light backgrounds get dark text (#1F2937), dark backgrounds get off-white (#F8F8F2)

---

<!-- Template for new entries:

## [YYYY-MM-DD]
- **Task:** [what was requested]
- **Files:** [files created/modified]
- **Outcome:** [what happened]
- **Key decisions:** [important choices made]

-->
