# Terminal Color Reference

Quick reference for AutoMates agent colors.

---

## Agent Colors

| Agent | Role | Hex | RGB | Preview |
|-------|------|-----|-----|---------|
| **Planner** | Architect | `#1E3A8A` | 30, 58, 138 | Blue |
| **Builder** | Developer | `#EA580C` | 234, 88, 12 | Orange |
| **Checker** | QA/Security | `#15803D` | 21, 128, 61 | Green |
| **BrainStorm** | Creative | `#CA8A04` | 202, 138, 4 | Yellow |
| **Gal** | User Advocate | `#0EA5E9` | 14, 165, 233 | Bright Blue |
| **Legal** | Compliance | `#1F2937` | 31, 41, 55 | Dark Gray |
| **GitDude** | Release | `#7C3AED` | 124, 58, 237 | Purple |
| **Fetcher** | Researcher | `#92400E` | 146, 64, 14 | Brown |
| **Orca** | Orchestrator | `#1E3A5F` | 30, 58, 95 | Navy |

---

## Color Logic

### Blues (Strategic Thinking)
- **Planner** `#1E3A8A` - Deep blue for architecture
- **Orca** `#1E3A5F` - Navy for orchestration
- **Gal** `#0EA5E9` - Bright blue for user perspective

### Warm (Action & Creation)
- **Builder** `#EA580C` - Orange for building
- **BrainStorm** `#CA8A04` - Yellow/gold for ideas
- **Fetcher** `#92400E` - Brown for research

### Green (Quality)
- **Checker** `#15803D` - Green for approval/quality

### Dark (Governance)
- **Legal** `#1F2937` - Dark gray for formal compliance
- **GitDude** `#7C3AED` - Purple for version control

---

## HSL Values

For tools that prefer HSL:

| Agent | HSL |
|-------|-----|
| Planner | 222, 65%, 33% |
| Builder | 21, 92%, 48% |
| Checker | 145, 72%, 29% |
| BrainStorm | 41, 96%, 40% |
| Gal | 199, 85%, 49% |
| Legal | 217, 28%, 17% |
| GitDude | 263, 83%, 58% |
| Fetcher | 23, 81%, 31% |
| Orca | 211, 52%, 25% |

---

## CSS Variables

```css
:root {
  --planner: #1E3A8A;
  --builder: #EA580C;
  --checker: #15803D;
  --brainstorm: #CA8A04;
  --gal: #0EA5E9;
  --legal: #1F2937;
  --gitdude: #7C3AED;
  --fetcher: #92400E;
  --orca: #1E3A5F;
}
```

---

## Foreground Color

All agents use white (`#FFFFFF`) foreground for readability on dark backgrounds.
