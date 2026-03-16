# Version_Control

This is where your git repositories live. One folder per product.

## How It Works

```
Work_Space/    →  where you build (drafts, blueprints, experiments)
Version_Control/  →  where you commit (clean, reviewed, ready to ship)
```

**The workflow:**

1. **Build in Work_Space** — agents create blueprints, code, and reviews here
2. **Sync to Version_Control** — copy clean files to the product folder here. You can do this manually, or use `/gitdude` — he handles the sync, filters personal data, and replaces live files with clean templates
3. **Review before commit** — GitDude scans for secrets, personal data, and stale content before committing (two-gate system: Sync Gate + Commit Gate)
4. **Commit and push** — from the git repo in this folder

## Structure

```
Version_Control/
├── README.md           # This file
└── MyProduct/          # One folder per product (each has its own .git)
    ├── .git/           # Git repo — connected to GitHub/GitLab/etc.
    ├── .gitignore
    └── ...             # Clean, shipping-ready files
```

## Rules

- **One folder per product.** Each product has its own `.git` and its own remote.
- **Repo root = latest version.** Old versions live in git tags, not subfolders.
- **Never sync raw.** Files that agents write to (Brief.md, Sessions, Checkpoint) ship as templates only.
- **No secrets in git.** GitDude scans for API keys, tokens, and personal data before every commit.

## Getting Started

```bash
mkdir MyProduct
cd MyProduct
git init
git remote add origin git@github.com:you/your-repo.git
```

Then sync your clean files from `Work_Space/MyProduct/` — manually or via `/gitdude`.
