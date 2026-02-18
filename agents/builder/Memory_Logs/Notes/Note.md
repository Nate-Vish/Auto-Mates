# Technical Notes - Builder

*Coding patterns, libraries, and project-specific technical knowledge*

---

## 2026-02-04 - Terminal Color Scheme (FINAL)

### FINAL COLORS (All approved by user)
| Agent | Hex | Description | Text |
|-------|-----|-------------|------|
| Planner | `#1E3A8A` | Blue | White |
| Builder | `#F97316` | Vivid Orange | Dark |
| Checker | `#166534` | Forest Green | White |
| BrainStorm | `#F59E0B` | Golden Yellow | Dark |
| Gal | `#0E7490` | Teal | White |
| Legal | `#1E293B` | Deep Slate | White |
| GitDude | `#5B21B6` | Deep Violet | White |
| Fetcher | `#D4A574` | Caramel | Dark |
| Orca | `#18181B` | Charcoal | White |

### Color Principles Learned
- Light backgrounds (yellow, orange, pastel) need DARK text (`#1F2937`)
- Dark backgrounds need OFF-WHITE text (`#F8F8F2`)
- Keep color families but adjust shades for distinction
- WCAG contrast ratio must be 4.5:1+ for readability
- Avoid similar colors in same family (Planner blue vs Legal navy was too close)
- Legal = "trusted co-founder lawyer" → Deep Slate conveys trust + professionalism
- Orca = "like the whale" → Charcoal (deep, dark)

### Saved for Future
- Deep Teal `#134E4A` - cool, calm, modern (not used yet)

---

## 2026-02-13 - iTerm2 Text Color Fix

### Problem
Checker found iTerm2 launcher was NOT setting text color (only background).
Terminal.app correctly used `get_agent_text_color()` but iTerm2 was missing it.

### Fix Applied
In `launch_iterm2()` function:
1. Added `text_color` to case statement (lines 110-119)
2. Added `set foreground color to "${text_color}"` in AppleScript (line 156)

### iTerm2 Text Colors
```bash
# Light backgrounds → dark text
builder)    text_color="#1F2937"
brainstorm) text_color="#1F2937"
fetcher)    text_color="#1F2937"

# Dark backgrounds → off-white text
*)          text_color="#F8F8F2"
```

---

<!-- Template for new entries:

## [YYYY-MM-DD] - [Topic]
- [Technical detail]

-->
