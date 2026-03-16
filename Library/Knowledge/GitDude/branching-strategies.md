# Branching Strategies

**When to use:** Choosing a branching model for a new project, implementing or evaluating an existing strategy, setting up branch protection, or managing branch hygiene.

---

## Decision Matrix — Pick the Right Model

```
Do you need multiple production versions simultaneously?
├── YES → GitFlow
└── NO → Do you have multiple deployment environments (staging, prod)?
          ├── YES → GitLab Flow
          └── NO → Strong CI/CD + disciplined team?
                    ├── YES → Trunk-Based Development
                    └── NO  → GitHub Flow
```

| Criteria | GitFlow | Trunk-Based | GitHub Flow | GitLab Flow |
|----------|---------|-------------|-------------|-------------|
| Team size | 10+ | 2-15 | Any | Any |
| Release cadence | Scheduled (monthly) | Continuous (daily) | Continuous | Continuous with gates |
| Environments | Multiple | Single + flags | Single | Multiple |
| Versions in prod | Multiple | One | One | One |
| CI/CD requirement | Any | Mandatory | Should be strong | Should be strong |
| Complexity | High | Low | Low | Medium |

---

## GitFlow

For scheduled releases, multiple production versions, regulated industries.

| Branch | Purpose | Lifetime | From | Into |
|--------|---------|----------|------|------|
| `main` | Production, tagged releases | Permanent | — | — |
| `develop` | Integration for next release | Permanent | `main` | — |
| `feature/*` | New features | Temporary | `develop` | `develop` |
| `release/*` | Stabilization | Temporary | `develop` | `main` + `develop` |
| `hotfix/*` | Emergency production fixes | Temporary | `main` | `main` + `develop` |

```bash
# Feature
git checkout develop && git checkout -b feature/user-profile
git checkout develop && git merge --no-ff feature/user-profile

# Release
git checkout develop && git checkout -b release/2.0.0
# (bug fixes only during stabilization)
git checkout main && git merge --no-ff release/2.0.0 && git tag -a v2.0.0 -m "Release 2.0.0"
git checkout develop && git merge --no-ff release/2.0.0

# Hotfix
git checkout main && git checkout -b hotfix/2.0.1
git checkout main && git merge --no-ff hotfix/2.0.1 && git tag -a v2.0.1 -m "Hotfix 2.0.1"
git checkout develop && git merge --no-ff hotfix/2.0.1
```

**Always `--no-ff`** for GitFlow merges — preserves branch topology for audit trail.

---

## Trunk-Based Development

For CI/CD environments, small/medium teams, rapid delivery.

- One main branch. All work happens here or on branches that live < 2 days.
- Feature flags hide incomplete work. Never keep a branch open just because a feature isn't ready.
- Every commit to main is built, tested, and deployed automatically.

```bash
git checkout main && git pull
git checkout -b feature/add-search
# Small increments. After 1-4 hours:
git commit -m "feat: add search input component (behind flag)"
git push -u origin feature/add-search
# PR created, reviewed, CI passes, merged same day
```

---

## GitHub Flow

For SaaS products, continuous deployment, PR-based review.

```bash
git checkout main && git pull
git checkout -b feature/dark-mode
# Commits, push, open PR
gh pr create --title "Add dark mode" --body "..."
# PR reviewed, CI passes, merge to main, deploy
git branch -d feature/dark-mode
```

---

## GitLab Flow

For multiple deployment environments with a QA gate.

```
feature/* ──> main ──> staging ──> production
```

Promotes code between environments via branch merges. Code flows one direction only.

---

## Branch Naming Conventions

Pattern: `<prefix>/<ticket-number>-<short-description>`

| Prefix | Use | Example |
|--------|-----|---------|
| `feature/` | New functionality | `feature/PROJ-123-user-auth` |
| `fix/` | Bug fix (non-urgent) | `fix/PROJ-456-login-redirect` |
| `hotfix/` | Urgent production fix | `hotfix/payment-gateway-timeout` |
| `release/` | Release stabilization | `release/3.5.0` |
| `chore/` | Maintenance | `chore/upgrade-dependencies` |
| `docs/` | Documentation only | `docs/api-authentication-guide` |

Rules: lowercase, hyphen-separated, include ticket number when possible. Consistent naming enables automation.

---

## Branch Protection (Non-Negotiable on Main)

| Rule | Why |
|------|-----|
| Require pull request | No direct pushes |
| At least 1 required reviewer | Peer review gate |
| Dismiss stale reviews | Re-review after new pushes |
| Require CI status checks | Tests must pass |
| Require up-to-date branch | No stale merges |
| No force push | Prevent history rewriting |
| No deletions | Prevent branch deletion |

---

## Long-Lived Branches — Kill Them

| Branch Age | Merge Difficulty |
|------------|-----------------|
| < 1 day | Trivial |
| 1-3 days | Easy |
| 3-7 days | Moderate |
| 1-2 weeks | Hard |
| > 1 month | Potentially impossible |

No feature branch lives longer than 5 days. Break large features into smaller PRs or merge behind feature flags. Review branch ages weekly.

**Branch hygiene:**
```bash
git fetch --prune                                                          # remove stale remote refs
git branch --merged main | grep -v "main\|develop\|release" | xargs git branch -d   # delete merged local branches
git branch -r --no-merged main                                            # identify unmerged remote branches
git for-each-ref --sort=committerdate refs/remotes/origin/feature/ --format='%(committerdate:short) %(refname:short)'  # check ages
```

---

## Release Branches & Tagging

```bash
# Cut a release branch
git checkout develop && git pull
git checkout -b release/3.5.0
git push -u origin release/3.5.0

# Tag the release
git tag -a v3.5.0 -m "Release 3.5.0 — User authentication overhaul"
git push origin v3.5.0

# Backport hotfix
git checkout release/3.4
git cherry-pick -x <fix-sha>
git tag -a v3.4.1 -m "Patch: session timeout fix"
git push origin v3.4.1
```

**Always use annotated tags for releases.** `git tag -a` stores tagger, date, and message. Lightweight tags are for local bookmarks only.

**Merge strategy for main:**
- Feature branches → squash merge (clean main history)
- Release branches → `--no-ff` merge commit (preserve stabilization history)

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
