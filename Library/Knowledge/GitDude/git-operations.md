# Git Operations & Recovery

**When to use:** Rebase, cherry-pick, bisect, reflog, stash, worktree, merge conflicts, reset, or any recovery from a bad state.

---

## Rebase

**Interactive rebase to clean history before PR:**
```bash
git rebase -i HEAD~5          # clean last 5 commits
git rebase -i main            # clean everything since branch point
```

Interactive commands: `pick` (keep), `reword` (edit message), `squash`/`fixup` (combine), `drop` (remove), `edit` (amend)

**Rules:**
- Rebase YOUR branch onto main, never rebase shared branches
- After rebasing: `git push --force-with-lease` (NEVER bare `--force`)
- Never rebase: main, develop, any branch others have pulled from

**Typical cleanup:**
```
pick a1b2c3d feat: add auth endpoint
fixup d4e5f6g WIP auth
fixup h7i8j9k fix typo in auth
pick k0l1m2n feat: add rate limiting
```

---

## Cherry-Pick

Copy specific commits across branches. Creates new commit with same changes, different SHA.

```bash
git cherry-pick abc1234           # single commit
git cherry-pick abc1234 def5678   # multiple
git cherry-pick abc1234..ghi9012  # range (excludes abc1234, includes ghi9012)
git cherry-pick abc1234^..ghi9012 # range inclusive of both
git cherry-pick -x abc1234        # ALWAYS use -x: appends source SHA to message
git cherry-pick --no-commit abc1234  # stage without committing (combine multiple)
```

**Always use `-x`.** The `(cherry picked from commit ...)` note is how you track which fixes have been backported to which release branches.

---

## Bisect

Find the exact commit that introduced a bug. Binary search = O(log n) steps.

```bash
git bisect start
git bisect bad              # current commit has the bug
git bisect good v2.1.0      # known-good tag
# Git checks out midpoint. Test it.
git bisect good  # or  git bisect bad
# Repeat until: "<sha> is the first bad commit"
git bisect reset            # return to your branch
```

**Automated bisect:**
```bash
git bisect start
git bisect bad HEAD
git bisect good v2.0.0
git bisect run ./test_regression.sh  # exit 0 = good, non-zero = bad
git bisect reset
```

Bisect before blaming. Never manually scan 200 commits when bisect finds the offender in ~8 steps.

---

## Reflog — Your Safety Net

Reflog records every HEAD movement for 90 days. Nothing is truly lost.

```bash
git reflog                      # all recent HEAD movements
git reflog show feature/auth    # reflog for a specific branch
git reflog --date=relative      # human-readable dates
```

**Recovery patterns:**
```bash
# Recover from bad rebase
git reflog  # find entry BEFORE "rebase (start)"
git reset --hard HEAD@{N}

# Recover deleted branch
git reflog | grep "branch-name"
git branch feature/recovered-work abc1234

# Find dangling objects when reflog doesn't help
git fsck --lost-found
git show <dangling-sha>
git branch recovered-work <dangling-sha>
```

---

## Stash

Parking lot for in-progress work. Not storage — retrieve promptly.

```bash
git stash push -m "description"           # named stash
git stash push -u -m "desc"              # include untracked files
git stash push -- path/to/file           # specific files only
git stash list
git stash apply stash@{1}               # apply and keep in list
git stash pop                            # apply and remove from list
git stash show -p stash@{0}             # inspect contents
git stash drop stash@{2}                # delete specific stash
```

**apply vs pop:** Use `apply` when you might need the stash again (applying to multiple branches). Use `pop` for normal retrieve-and-continue.

Keep stash list under 4 items. If it's important enough to keep, commit it on a branch.

---

## Worktree

Two branches, two directories, zero context loss. Use when you need a hotfix while stabilizing a release.

```bash
git worktree add ../hotfix hotfix/critical-fix
git worktree add -b hotfix/CVE-2025-1234 ../cve-fix main
git worktree list
git worktree remove ../hotfix   # cleanup after merge
git worktree prune              # cleanup if directory was deleted manually
```

**Hotfix while release is open:**
```bash
git worktree add ../hotfix-3.4.1 -b hotfix/3.4.1 v3.4.0
# Work in ../hotfix-3.4.1, commit, push
# Back in main directory, cherry-pick if needed:
git cherry-pick -x <hotfix-commit-sha>
```

Rules: Each branch can only be checked out in ONE worktree. Always clean up worktrees after the task is done.

---

## Merge Conflicts

```bash
git checkout --ours file      # accept your version
git checkout --theirs file    # accept incoming version
git mergetool                 # open visual merge tool
```

Enable `rerere` to remember conflict resolutions:
```bash
git config --global rerere.enabled true
```

---

## Reset

| Mode | Command | Working Dir | Staging | Use Case |
|------|---------|-------------|---------|----------|
| `--soft` | `git reset --soft HEAD~1` | Unchanged | Staged | Undo commit, keep changes staged |
| `--mixed` (default) | `git reset HEAD~1` | Unchanged | Unstaged | Undo commit, keep changes unstaged |
| `--hard` | `git reset --hard HEAD~1` | **Discarded** | Cleared | Nuclear — discard everything |

**Rule:** Never `--hard` on pushed commits. Committed changes can be recovered via reflog; uncommitted changes from `--hard` cannot.

---

## Emergency Recovery Playbook

| Emergency | Command |
|-----------|---------|
| Undo last commit (keep changes) | `git reset --soft HEAD~1` |
| Undo last commit (discard all) | `git reset --hard HEAD~1` |
| Recover from bad rebase | `git reflog` → `git reset --hard HEAD@{N}` |
| Recover deleted branch | `git reflog` → `git branch <name> <sha>` |
| Undo pushed merge | `git revert -m 1 <merge-sha>` |
| Find breaking commit | `git bisect start && git bisect bad && git bisect good <tag>` |
| Abort in-progress rebase | `git rebase --abort` |
| Abort in-progress merge | `git merge --abort` |
| Find dangling commits | `git fsck --lost-found` |
| Full workspace reset | `git reset --hard HEAD && git clean -fdx` |

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
