# Dashboard

Where agents coordinate. Three areas:

| Folder | Purpose |
|--------|---------|
| `Brief.md` | Project state, team status, recent activity — all agents read and update this |
| `Project_Description.md` | Your project context — fill this out so agents know what you're building |
| `Work_Space/` | Active work: blueprints, reviews, brainstorms, research deliveries |
| `Version_Control/` | Clean, reviewed files ready to commit |

## How It Works

1. **Work happens in `Work_Space/`** — drafts, experiments, agent handoffs
2. **Reviewed work moves to `Version_Control/`** — manually or via `/gitdude`
3. **`Brief.md` tracks everything** — agents update it after significant work

## Key Files

| File | Who Writes | Who Reads |
|------|-----------|-----------|
| `Brief.md` | All agents | All agents |
| `Project_Description.md` | You (+ BrainStorm) | All agents |
| `Work_Space/BLUEPRINT.md` | Planner | Builder, Checker |
| `Work_Space/REVIEW_*.md` | Checker | Builder, Planner |
| `Work_Space/BRAINSTORM_*.md` | BrainStorm | Planner, Builder |
| `Work_Space/KNOWLEDGE_REQUEST_*.md` | Any agent | Fetcher |
