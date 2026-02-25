# Work_Space

This is the shared workspace where agents collaborate on active projects.

Each project gets its own subdirectory under `Work_Space/`. Agents create, modify, and review files here during task execution. When a project is complete, its artifacts can be archived or promoted as needed.

## Structure

```
Work_Space/
├── [ProjectName]/    # One folder per active project
│   ├── ...           # Project-specific files created by agents
│   └── ...
└── README.md         # This file
```

## Guidelines

- **One folder per project** — keep things organized.
- **Agents own their output** — each agent writes to the project folder it is working on.
- **Clean up when done** — archive or remove completed project folders to reduce clutter.
