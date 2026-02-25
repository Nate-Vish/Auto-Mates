# Terminal Profiles

Color-coded terminal profiles for AutoMates agents. Makes it easy to identify which agent you're working with.

---

## Quick Setup

### macOS (iTerm2)

1. Open iTerm2
2. Go to **Preferences** (Cmd+,) → **Profiles**
3. Click the **Other Actions** dropdown (gear icon)
4. Select **Import JSON Profiles**
5. Choose `iterm2-profiles.json` from this folder
6. Done! The profiles will appear in your profile list

### Windows Terminal

1. Open Windows Terminal
2. Open **Settings** (Ctrl+,)
3. Click **Open JSON file** (bottom left)
4. Add the profiles from `windows-terminal.json` to your `profiles.list` array
5. Save and restart Windows Terminal

### Linux (gnome-terminal)

Gnome-terminal doesn't support JSON import. Create profiles manually:

1. Open Terminal → **Preferences**
2. Click **+** to add a new profile
3. Set the name (e.g., "Planner")
4. Under **Colors**, set the background color (see color reference below)
5. Repeat for each agent

---

## Agent Colors

| Agent | Role | Hex Color | RGB |
|-------|------|-----------|-----|
| Planner | Architect | `#1E3A8A` | 30, 58, 138 |
| Builder | Developer | `#EA580C` | 234, 88, 12 |
| Checker | QA/Security | `#15803D` | 21, 128, 61 |
| BrainStorm | Creative | `#CA8A04` | 202, 138, 4 |
| Gal | User Advocate | `#0EA5E9` | 14, 165, 233 |
| Legal | Compliance | `#1F2937` | 31, 41, 55 |
| GitDude | Release | `#7C3AED` | 124, 58, 237 |
| Fetcher | Researcher | `#92400E` | 146, 64, 14 |
| Orca | Orchestrator | `#1E3A5F` | 30, 58, 95 |

---

## Files

| File | Platform |
|------|----------|
| `iterm2-profiles.json` | macOS (iTerm2) |
| `windows-terminal.json` | Windows Terminal |
| `terminal-colors.md` | Color reference |

---

## Why Colors?

When running multiple agents in separate tabs, colors help you:
- Quickly identify which agent you're looking at
- Stay organized during complex workflows
- Reduce context-switching friction

The color scheme groups related roles:
- **Blues** (Planner, Orca, Gal) - Strategy & design
- **Warm** (Builder, BrainStorm, Fetcher) - Action & creation
- **Green** (Checker) - Quality & safety
- **Dark** (Legal, GitDude) - Governance & control
