---
name: summon
description: Launch Claude-Mates agents in separate terminal windows
allowed-tools:
  - Bash
  - Read
---

# /summon - Launch Claude-Mates Agents

Launch one or more agents in separate terminal windows with their identities.

## Usage

```
/summon <agent>              # Launch single agent
/summon <agent1>,<agent2>    # Launch multiple agents
/summon team                 # Launch Planner, Builder, Checker
/summon all                  # Launch all 9 agents
```

## Examples

```
/summon planner              # Just Planner
/summon builder,checker      # Builder and Checker
/summon team                 # Core team
/summon all                  # Everyone
```

## Available Agents

| Agent | Color | Role |
|-------|-------|------|
| planner | Blue | Creates blueprints and roadmaps |
| builder | Orange | Writes code, implements features |
| checker | Green | Reviews code, finds bugs |
| brainstorm | Yellow | Generates ideas, explores solutions |
| gal | Bright Blue | Tests UX, skeptical evaluation |
| legal | Black | Licensing, privacy, compliance |
| gitdude | Purple | Commits, versioning, releases |
| fetcher | Brown | Gathers documentation, research |
| orca | Navy | Designs agent workflows |

## Instructions

When this skill is invoked, execute the summon script:

```bash
# Get the Claude-Mates root (where .claude folder is)
CLAUDE_MATES_ROOT="$(pwd)"

# Check if we're in a Claude-Mates repo (has agents/ folder)
if [[ ! -d "${CLAUDE_MATES_ROOT}/agents" ]]; then
    echo "Error: Not in a Claude-Mates repository (no agents/ folder found)"
    exit 1
fi

# Run the summon script
bash "${CLAUDE_MATES_ROOT}/.claude/skills/summon/summon.sh" "$ARGUMENTS"
```

## Cross-Platform Support

The script detects your platform and uses the appropriate terminal:

| Platform | Primary | Fallback |
|----------|---------|----------|
| macOS | iTerm2 | Terminal.app |
| Linux | gnome-terminal | xterm |
| Windows | Windows Terminal | PowerShell |

## What Happens

1. A new terminal window/tab opens for each agent
2. Claude Code starts with that agent's identity loaded
3. The agent reads their memory and is ready to work
4. Agents share files via `Dashboard/Work_Space/`

## Notes

- Each agent runs as a separate Claude Code instance
- Agents have persistent memory in `agents/<name>/Memory_Logs/`
- Coordinate work through shared files in `Dashboard/Work_Space/`

---

*Part of Claude-Mates - Your AI dev team for Claude Code*
