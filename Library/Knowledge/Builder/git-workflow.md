# Git Workflow
**When to use:** Read when managing branches, writing commit messages, rebasing, resolving conflicts, or recovering from mistakes.

---

## Daily Workflow

```bash
# Start of day — sync with remote
git fetch origin
git pull --rebase origin main    # Rebase local changes on top of remote

# Create feature branch
git checkout -b feature/agent-chat-panel

# Work... then stage and commit specific files
git add src/components/AgentChat.tsx src/hooks/useChat.ts
git commit -m "feat: add agent chat panel with message history"

# Push to remote
git push -u origin feature/agent-chat-panel   # -u sets upstream (first push only)
git push                                        # subsequent pushes
```

---

## Branching

### Naming Conventions
| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New feature | `feature/command-bar` |
| `fix/` | Bug fix | `fix/black-screen-on-load` |
| `chore/` | Maintenance, config | `chore/update-dependencies` |
| `docs/` | Documentation only | `docs/api-readme` |
| `refactor/` | Code restructure, no behavior change | `refactor/extract-scene-hooks` |
| `test/` | Adding/fixing tests | `test/agent-chat-unit-tests` |

### Branch Commands
```bash
git branch                          # List local branches
git branch -a                       # List all (including remote)
git checkout -b feature/new-thing   # Create and switch
git switch -c feature/new-thing     # Modern equivalent
git branch -d feature/merged        # Delete merged branch
git branch -D feature/abandoned     # Force delete unmerged
git push origin --delete old-branch # Delete remote branch
```

---

## Commit Messages — Conventional Commits

### Format
```
<type>(<optional scope>): <description>

[optional body — explain WHY, not WHAT]

[optional footer — breaking changes, issue refs]
```

### Types
| Type | When |
|------|------|
| `feat:` | New feature for the user |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `style:` | Formatting, no code change |
| `refactor:` | Code change that neither fixes nor adds feature |
| `test:` | Adding or fixing tests |
| `chore:` | Build process, tooling, dependencies |
| `perf:` | Performance improvement |
| `ci:` | CI/CD configuration |

### Rules
1. Imperative mood: "add feature" not "added feature"
2. No period at end
3. First line ≤ 72 characters
4. Body explains WHY, not WHAT (the diff shows WHAT)
5. Reference issues: `Fixes #123`, `Closes #456`

### Examples
```bash
git commit -m "feat: add command bar with fuzzy search"

git commit -m "fix: resolve black screen on initial load

The Canvas component was mounting before Three.js initialized.
Added a loading gate in SceneProvider.

Fixes #42"

git commit -m "refactor: extract camera controls into custom hook"
git commit -m "chore: update react-three-fiber to 8.15"
```

---

## Stashing

```bash
git stash                          # Stash all tracked changes
git stash -u                       # Include untracked files
git stash save "chat panel WIP"    # Named stash
git stash list                     # List all stashes
git stash pop                      # Apply most recent, remove from stack
git stash apply                    # Apply most recent, keep in stack
git stash apply stash@{2}          # Apply specific stash
git stash drop stash@{0}           # Delete specific stash
git stash clear                    # Delete all stashes

# Common use case: quick branch switch
git stash
git checkout main && git pull
git checkout -
git stash pop
```

---

## Rebasing vs. Merging

### When to Rebase
- Your feature branch onto main — keeps linear history
- Before opening a PR — clean up commits
- **Local branches only** — never rebase branches others have pulled

### When to Merge
- Main into feature is OK if you want to preserve the merge point
- PR merges via GitHub (merge/squash/rebase buttons)
- Shared branches where others are working

### Golden Rule
**Never rebase a branch that others have pulled.** Rebasing rewrites history — if someone else has the old history, they'll get conflicts.

```bash
# Rebase your feature onto latest main
git checkout feature/my-thing
git fetch origin
git rebase origin/main

# If conflicts during rebase:
# 1. Fix conflicts in files
# 2. git add <fixed-files>
# 3. git rebase --continue
# Abort if it gets messy:
git rebase --abort

# After rebase, force-push YOUR branch only
git push --force-with-lease   # Safer than --force (checks remote hasn't changed)
```

---

## Conflict Resolution

```
<<<<<<< HEAD (your changes)
const color = "blue";
=======
const color = "red";
>>>>>>> feature/theme (incoming changes)
```

1. Read BOTH versions — understand what each change intended
2. Choose the correct version (or combine both if needed)
3. Remove ALL conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Test the result
5. `git add <file>` then `git rebase --continue` or `git merge --continue`

---

## Undoing Changes

| Situation | Command | Safety |
|-----------|---------|--------|
| Discard unstaged changes in file | `git restore file.txt` | DESTRUCTIVE |
| Unstage a file (keep changes) | `git restore --staged file.txt` | Safe |
| Undo last commit, keep changes staged | `git reset --soft HEAD~1` | Safe |
| Undo last commit, unstage changes | `git reset --mixed HEAD~1` | Safe |
| Undo last commit, discard changes | `git reset --hard HEAD~1` | DESTRUCTIVE |
| Undo a pushed commit (new commit) | `git revert <commit-hash>` | Safe |
| Discard all local changes | `git restore .` | DESTRUCTIVE |
| Delete untracked files | `git clean -fd` | DESTRUCTIVE |

### Reflog — Your Safety Net
```bash
git reflog    # Shows ALL movements of HEAD — even "deleted" commits

# Recover a "deleted" commit
git reflog
# Find the hash you want
git checkout -b recovery <hash>   # Create branch to keep it
```

---

## Cherry-Pick

```bash
git cherry-pick <commit-hash>                  # Apply commit to current branch
git cherry-pick --no-commit <commit-hash>      # Apply changes without committing

# Use case: hotfix on main, then apply to feature branch
git checkout main
git cherry-pick abc123     # Apply the fix
git checkout feature/my-thing
git cherry-pick abc123     # Apply same fix here
```

---

## .gitignore

```gitignore
# Dependencies
node_modules/

# Build output
dist/
build/
*.tsbuildinfo

# Environment — NEVER commit these
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/settings.json
*.swp
.DS_Store

# Logs
*.log
npm-debug.log*

# Testing
coverage/
```

```bash
git status --ignored              # Check what's being ignored
git add -f path/to/file           # Track file that matches gitignore
git rm --cached path/to/file      # Remove from tracking but keep locally
```

---

## Common Mistakes & Fixes

| Mistake | Fix |
|---------|-----|
| Committed to wrong branch | `git reset --soft HEAD~1`, switch branches, commit there |
| Committed secrets | `git reset --soft HEAD~1`, remove secret, re-commit. If pushed: **rotate the secret immediately**, use BFG Repo Cleaner to rewrite history |
| Committed large file | `git reset --soft HEAD~1`, add to .gitignore, re-commit |
| Typo in commit message | `git commit --amend -m "correct message"` (only if not pushed) |
| Forgot to add a file | `git add file && git commit --amend --no-edit` (only if not pushed) |

---

## GitHub CLI (gh)

```bash
gh pr create --title "feat: agent chat" --body "Description"
gh pr list
gh pr checkout 123          # Check out someone's PR locally
gh pr checks 123            # View CI status
gh pr create --draft        # Create draft PR
gh pr create --body "Closes #42"   # Link issue
```

---

## Daily Rules

1. Feature branches with conventional prefixes — `feature/`, `fix/`, `chore/`
2. Conventional commits — `feat:`, `fix:`, `refactor:`, imperative mood
3. Rebase onto main before PR — clean linear history
4. Never rebase shared branches — only your local branches
5. `--force-with-lease` over `--force` — safer force push
6. Stash for quick context switches — not WIP commits
7. Reflog is your safety net — you can recover almost anything
8. Never commit secrets — if you do, rotate immediately and rewrite history
