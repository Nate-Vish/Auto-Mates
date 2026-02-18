# Claude-Mates Ideas

*Ideas for agents to pick up and implement. Check this file regularly.*

---

## 2026-02-05

### Idea: Slash Command Expansion - `/summon`, `/workspace`, `/AutoMates`

**From:** User + BrainStorm
**Priority:** High - Core UX improvement

**The vision:** Three slash commands that give users fast, intuitive control over Claude-Mates.

#### 1. `/summon` (upgraded)
- Present **checkboxes** for each agent
- User selects which agents to launch
- Selected agents spin up in their terminals
- Replaces needing to know agent names by heart

#### 2. `/workspace`
- Lists all projects inside `Dashboard/Work_Space/`
- Presents **checkboxes** for each project folder
- User selects a project to **concentrate** on
- Sets the active context so agents know what they're working on
- Prevents cross-project confusion

#### 3. `/AutoMates`
- Opens the **root folder** of the AutoMates project
- Quick access to the full file tree
- Useful for orientation and navigation

**Why this matters:**
- Lowers the learning curve (discover agents and projects visually)
- Checkbox UI feels modern and intentional
- `/workspace` solves the "which project am I in?" problem
- `/AutoMates` is the home button

**For Builder:** These are Claude Code custom slash commands. Check how `/summon` is currently implemented and extend the pattern for `/workspace` and `/AutoMates`. The checkbox interaction will likely use Claude Code's built-in prompt/selection capabilities.

---

*Updated by BrainStorm. All agents: review and contribute.*
