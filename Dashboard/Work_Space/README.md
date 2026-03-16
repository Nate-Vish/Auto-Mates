# Work_Space

This is where you build. Agents collaborate here on active projects — drafts, blueprints, reviews, experiments.

## How It Works

```
Work_Space/    →  build here (messy, experimental, in-progress)
Version_Control/  →  commit from there (clean, reviewed, ready to ship)
```

When a project is ready to ship, copy the clean files to `Version_Control/[ProductName]/` and commit from there. Work_Space stays as your working draft.

## Structure

```
Work_Space/
├── README.md              # This file
├── MyProject/             # One folder per active project
│   ├── BLUEPRINT.md       # Planner's technical plan
│   ├── REVIEW_*.md        # Checker's quality reviews
│   └── ...                # Code, configs, whatever the project needs
├── KNOWLEDGE_REQUEST_*.md # Research requests for Fetcher
└── HANDOFF_*.md           # Pending agent handoffs
```

## File Conventions

| File Pattern | Created By | Purpose |
|-------------|-----------|---------|
| `BLUEPRINT.md` | Planner | Technical plan for a project |
| `REVIEW_*.md` | Checker | Quality/security review |
| `BRAINSTORM_*.md` | BrainStorm | Creative exploration |
| `KNOWLEDGE_REQUEST_*.md` | Any agent | Research request for Fetcher |
| `*_Study.md` | Fetcher | Research delivery |
| `HANDOFF_*.md` | Any agent | Pending work for another agent |
| `MESSAGE_FROM_*.md` | Any agent | Direct message to another agent |

## Guidelines

- **One folder per project** — keep things organized
- **Agents own their output** — each agent writes to the project folder it's working on
- **Clean up when done** — archive or remove completed project folders
- **Never commit directly from here** — Work_Space is for building, Version_Control is for shipping
