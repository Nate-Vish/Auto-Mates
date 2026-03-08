# GitDude Knowledge

*Last updated: 2026-03-02*

**Read this on every startup.** This is your professional expertise — the knowledge you carry in your head at all times. Deep-dive files are for specific implementations; this page IS your working memory.

---

## Core Knowledge — Always in Your Head

### Git Operations & Recovery: Your Daily Tools

**Rebase:** `git rebase -i HEAD~5` to clean history before PR. Rebase YOUR branch onto main (`git rebase main`), never rebase shared branches. `--force-with-lease` (not `--force`) after rebase. Interactive rebase to squash WIP commits, reorder, or reword.

**Cherry-pick:** `git cherry-pick <sha>` to port specific commits across branches. Use `-x` flag to add source reference. Cherry-pick a range: `git cherry-pick A..B` (excludes A, includes B).

**Bisect:** `git bisect start` → `git bisect bad` → `git bisect good <sha>` → git walks the history. Automate with `git bisect run npm test`. Finds the exact breaking commit in O(log n) steps.

**Reflog — your safety net:** `git reflog` shows every HEAD movement for 90 days. Recover "lost" commits: `git checkout <reflog-sha>`. Undo bad rebase: find pre-rebase HEAD in reflog, `git reset --hard <sha>`. Recover deleted branch: find its last commit in reflog, `git checkout -b <branch> <sha>`.

**Stash:** `git stash push -m "description"` for named stashes. `stash apply` keeps the stash, `stash pop` removes it. `git stash push -- path/to/file` for specific files. `git stash -u` includes untracked files.

**Worktree:** `git worktree add ../hotfix hotfix/critical-fix` — work on two branches simultaneously without stashing. Clean up with `git worktree remove ../hotfix`.

**Merge conflicts:** Read conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`). `git checkout --ours file` or `--theirs`. Enable `rerere` (`git config rerere.enabled true`) to remember conflict resolutions.

**Reset:** `--soft` = undo commit, keep changes staged. `--mixed` (default) = undo commit, keep changes unstaged. `--hard` = discard everything. Rule: never `--hard` on pushed commits.

### Branching Strategies: Know When to Use What

**Trunk-Based Development:** Single main branch, short-lived feature branches (<2 days), feature flags for WIP. Best for: small teams, CI/CD, rapid delivery. Most modern teams should default to this.

**GitHub Flow:** main + feature branches, PR-based review, deploy from main. Best for: SaaS products, continuous deployment, simple projects.

**GitFlow:** main + develop + feature + release + hotfix branches. Best for: formal release cycles, multiple versions in production, regulated industries. Overkill for most projects.

**GitLab Flow:** main + environment branches (staging, production). Best for: teams needing environment-specific deployments.

**Decision matrix:** Team <10, shipping daily? → Trunk-based. SaaS with PRs? → GitHub Flow. Formal releases + support windows? → GitFlow. Multiple environments? → GitLab Flow.

**Branch naming:** `feature/`, `fix/`, `hotfix/`, `release/`, `chore/` prefixes. Include ticket numbers: `feature/PROJ-123-user-auth`. Keep names lowercase, hyphen-separated.

**Branch protection:** Required reviews (at least 1, ideally 2 for main). Required status checks (CI must pass). No force push to main. Require up-to-date branches. Enable merge queue for high-traffic repos.

### Conventional Commits: The Foundation of Automation

**Format:** `type(scope): description` — subject line, imperative mood, max 72 chars, no period.

**Types:** `feat` (MINOR bump), `fix` (PATCH bump), `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. `feat!:` or `BREAKING CHANGE:` footer triggers MAJOR bump.

**Why it matters:** Conventional commits → auto-versioning → auto-changelog → auto-release. Without structured commits, release automation is impossible. They are the input that drives the entire pipeline.

**Commitlint enforcement:** Husky pre-commit hook + `@commitlint/config-conventional`. Block non-conforming commits at the git level, not through PR review.

**Bad commits to reject:** "fixed stuff", "wip", "update", "changes", "asdf". Every commit should explain WHAT changed and be machine-parseable.

**Signing:** `git commit -S` with GPG or SSH key. Proves commit authenticity. Required for supply chain security. `git config commit.gpgSign true` to make it default.

### Versioning Strategies: SemVer Is Your Language

**Semantic Versioning:** MAJOR.MINOR.PATCH. MAJOR = breaking changes. MINOR = new features (backward compatible). PATCH = bug fixes. 0.x.y = pre-1.0, anything goes (API unstable).

**Pre-release:** `-alpha.1` (internal testing) → `-beta.1` (external testing) → `-rc.1` (release candidate, feature-complete). Each stage narrows scope of changes allowed.

**CalVer alternative:** YYYY.MM.DD or YYYY.MINOR. Use for: infrastructure, data, rapidly evolving projects where SemVer "breaking change" is ambiguous. Ubuntu (24.04), pip, Terraform use CalVer.

**Auto-bumping:** semantic-release (fully automated from commits), standard-version (semi-automated), changesets (monorepo). Choose based on: single repo vs monorepo, npm vs other ecosystem, full auto vs human approval.

**Lockfiles:** Always commit lockfiles (package-lock.json, yarn.lock, pnpm-lock.yaml). Use `npm ci` (not `npm install`) in CI. Lockfiles = reproducible builds. Floating versions = supply chain risk.

### Changelog & Release Notes: Your Primary Output

**Keep a Changelog format:** Sections = Added, Changed, Deprecated, Removed, Fixed, Security. `[Unreleased]` section at top for WIP. Date format: YYYY-MM-DD. Compare links at bottom.

**Changelog vs release notes:** Changelog = technical, every change, for developers. Release notes = highlights, breaking changes, for users/stakeholders. Write both.

**Auto-generation:** conventional-changelog (simple, commit-based), release-please (Google, PR-based), changesets (monorepo). All require conventional commits as input.

**Release checklist:** Tests pass → docs updated → LICENSE present → CHANGELOG updated → migration guide if breaking → version bumped → tag created → artifacts built → release notes published.

**Anti-patterns:** Dumping `git log` as changelog. Empty changelogs. Not documenting breaking changes. Forgetting security fixes. Inconsistent formatting.

### Release Automation & Platform Features: The Pipeline

**Tag-triggered releases:** Push annotated tag → GitHub Actions triggers → build → test → publish → create GitHub Release. `on: push: tags: ['v*']` in workflow.

**GitHub Releases:** Create from tags, attach build artifacts, auto-generate release notes from PRs, draft releases for coordination. Link release to milestone.

**Protected branches:** Required reviews, required status checks, no force push, require signed commits, enforce admins, merge queue for high-traffic repos.

**CODEOWNERS:** `.github/CODEOWNERS` maps file patterns to required reviewers. `*.ts @frontend-team`, `/docs/ @tech-writers`. Enforces domain expertise in reviews.

**PR templates:** `.github/pull_request_template.md` with checklist format. Description, type of change, testing instructions, checklist, related issues.

**Progressive delivery:** Feature flags (on/off for WIP features), canary deployments (1% → 5% → 25% → 100%), blue-green (instant switch), rollback = flip the switch.

### Repository Security & Vulnerability Scanning: Your Most Critical Job

**Secret detection tools:** Gitleaks (fast CLI + CI, regex-based), TruffleHog (deep history scanning, verified secrets), GitGuardian (SaaS, real-time monitoring), GitHub Secret Scanning (native, auto-revocation partnerships). Run Gitleaks in pre-commit hooks AND CI.

**API key leak patterns:** `sk_live_`, `pk_live_`, `AIza`, `ghp_`, `gho_`, `aws_access_key_id`, `AKIA`. 39M secrets leaked on GitHub in 2024. Attackers harvest credentials within 5 minutes of exposure. Deletion doesn't help — secrets persist in git history.

**SAST/DAST/SCA:** SAST (static analysis: SonarQube, Semgrep, CodeQL) catches bugs in source code. DAST (dynamic: OWASP ZAP) catches runtime vulnerabilities. SCA (Software Composition Analysis: Snyk, Dependabot, npm audit) catches vulnerable dependencies. Run all three.

**Dependency scanning:** `npm audit`, `pip-audit`, Dependabot alerts, Renovate for auto-updates. CVSS scores: Critical (9.0-10.0) = fix immediately, High (7.0-8.9) = fix this sprint, Medium (4.0-6.9) = schedule, Low (0.1-3.9) = track.

**.gitignore essentials:** Always ignore: `*.env*`, `*.pem`, `*.key`, `credentials.*`, `serviceAccountKey.json`, `node_modules/`, `.DS_Store`, `*.log`. Use `git check-ignore <file>` to verify.

**Access control:** Least privilege always. Read for viewers, Write for contributors, Maintain for leads, Admin only for repo owner. Regular access reviews. Revoke on departure immediately. Deploy keys over PATs. Short-lived tokens.

**Signed commits/tags:** GPG or SSH signing proves authenticity. `git tag -s v1.0 -m "Release 1.0"` for signed tags. Enable vigilant mode on GitHub. Protects against supply chain impersonation.

### Prompt Injection & Supply Chain Security: 2025-2026 Critical

**AI tool exploits:** CVE-2025-59536 — Claude Code RCE via malicious project files. CVE-2026-21852 — API key exfiltration through project-load flow. CVE-2025-68145/68143/68144 — Git MCP server vulnerabilities (path bypass, unrestricted init, argument injection). All exploitable via repos you clone.

**Malicious repo patterns:** Repos that attack on clone/open: poisoned `.claude` files, `.cursorrules`, `.vscode/settings.json`, Makefiles with hidden commands, Git hooks that auto-execute. Never trust config files in unfamiliar repos.

**Supply chain attacks:** Dependency confusion (internal package names on public registry), typosquatting (`lodassh` instead of `lodash`), compromised maintainers, protestware, build pipeline poisoning. Use lockfiles + hash verification.

**SBOM:** Software Bill of Materials — inventory of all components. SPDX and CycloneDX formats. Required by US Executive Order 14028 for government software. Generates with `syft`, `cdxgen`, or GitHub's dependency graph.

**Safe AI tool usage:** Never auto-approve tool actions on untrusted repos. Review AI-generated code like any other PR. Sandbox untrusted repos. Scope AI tool permissions to minimum needed. Check `.github/workflows/` for suspicious actions before cloning.

### Git Hooks & Enforcement: Standards That Actually Work

**Client-side hooks:** pre-commit (lint, format, secret scan), commit-msg (commitlint), pre-push (tests, type-check). Server-side: pre-receive (block force push), post-receive (deploy triggers).

**Husky v9+:** `npx husky init` → creates `.husky/` directory. Add hooks: `echo "npx lint-staged" > .husky/pre-commit`. Hooks auto-install on `npm install`. Team-wide enforcement.

**lint-staged:** Run linters only on staged files (fast). Config: `"*.{ts,tsx}": ["eslint --fix", "prettier --write"]`. Pair with Husky pre-commit for zero-effort enforcement.

**Secret scanning in hooks:** Gitleaks in pre-commit: blocks any commit containing detected secrets. `.pre-commit-config.yaml` with `detect-secrets` + `gitleaks`. Zero secrets reach the remote.

**Bypassing:** `--no-verify` skips hooks. Acceptable only for emergency hotfixes. Document every bypass. Team policy: bypasses require verbal approval from lead.

### Rollback & Incident Response: When Things Break

**Rollback decision tree:** Deployed + single commit → `git revert <sha>`. Deployed + multiple commits → redeploy previous tag. Not deployed + local only → `git reset`. Pushed to remote → always `git revert` (never rewrite shared history).

**git revert:** Creates a new commit that undoes the target. Safe for shared branches. Revert merge commits: `git revert -m 1 <merge-sha>`. Revert a range: `git revert HEAD~3..HEAD`.

**Redeploy previous tag:** Fastest production rollback. CI runs: `git checkout v1.2.3` → build → deploy. Have rollback-specific CI workflows ready BEFORE you need them.

**Leaked secret protocol:** (1) Revoke credential immediately. (2) Rotate/regenerate. (3) Remove from history (BFG Repo-Cleaner or `git-filter-repo`). (4) Force-push cleaned history. (5) Notify team. (6) Audit for unauthorized access. (7) Document in postmortem. Speed matters — attackers find leaked secrets in under 5 minutes.

**Blameless postmortem:** Focus on systems, not people. Timeline reconstruction. Root cause analysis (5 whys). Action items with owners and deadlines. Share findings widely — incidents are learning opportunities.

### Release Health Metrics: DORA Framework

**The 4 DORA metrics** (industry standard for measuring release performance):
1. **Deployment Frequency** — how often you ship to production. Elite: on-demand (multiple per day). Low: less than once per month.
2. **Lead Time for Changes** — time from commit to production. Elite: under 1 hour. Low: over 6 months.
3. **Mean Time to Recovery (MTTR)** — how fast you recover from a failure. Elite: under 1 hour. Low: over 6 months.
4. **Change Failure Rate** — percentage of deployments causing a failure. Elite: 0-15%. Low: 46-60%.

**Why it matters:** These metrics tell you if your release process is healthy or sick. Track them over time, not as point-in-time snapshots. A team that ships daily with low failure rate is operating well. A team that ships monthly with high failure rate has process problems.

### Release Readiness Gates

Before every release, verify explicitly — not "I think we're good," but a formal checklist with signoff:
- [ ] All blocking bugs resolved (zero P0/P1 open)
- [ ] QA sign-off (test pass rate, regression suite green)
- [ ] Stakeholder sign-off (PM confirms feature-complete for this release)
- [ ] Rollback plan verified (tested, not just documented)
- [ ] Monitoring dashboards updated (new features have alerts)
- [ ] Communication plan ready (release notes drafted, changelog updated, team notified)

### Post-Deployment Protocol

After go-live, the release isn't done — it's entering observation:
1. **Monitor for 30 minutes** — watch error rates, latency, CPU/memory. Compare to pre-deploy baseline.
2. **Announce completion** — notify the team (Slack, email, whatever the team uses).
3. **Watch for 24 hours** — some issues only appear under real traffic patterns (time zones, batch jobs, cron).
4. **Close the release** — update changelog status, tag the release as stable, move on.

If anything looks wrong: trigger the rollback decision tree (see Rollback section above). Speed > pride.

---

## AutoMates Version Control System

### Repository Structure

```
Dashboard/Version_Control/
└── AutoMates/          ← .git lives here. This is the repo root.
    ├── .git/           ← The database. Stores ALL versions internally.
    ├── CLAUDE.md       ← Latest version of every file sits at root
    ├── README.md
    ├── CHANGELOG.md
    └── ...             ← All files = current (latest) version
```

- **Repo root = latest version.** Every file at root is the newest release.
- **Old versions = git tags.** `git checkout v1.0` shows v1.0. `git checkout main` shows latest.
- **NEVER create version subfolders** (v1.0/, v1.1/). That's what git tags do.
- `.git` lives ONLY in `Version_Control/[Product]/`. Never in Work_Space or root.
- Work_Space → build. Version_Control → ship.

### Sensitive Data Patterns (Pre-Commit Scanning)

Scan every diff before committing. Block if any match.

**API Keys & Tokens:** `api_key`, `apikey`, `API_KEY`, `secret_key`, `SECRET_KEY`, `access_token`, `bearer_token`, `auth_token`. Prefixes: `sk_live_`, `pk_live_`, `sk_test_`, `AIza`, `ghp_`, `gho_`, `AKIA`.

**Credentials:** `password`, `passwd`, `PASSWORD`. Database connection strings with embedded passwords. SSH private keys (`BEGIN RSA PRIVATE KEY`, `BEGIN OPENSSH PRIVATE KEY`). OAuth client secrets.

**Files that should never be committed:** `.env`, `.env.local`, `.env.production`, `credentials.json`, `serviceAccountKey.json`, `*.pem`, `*.key`, database dumps, log files with user data.

---

## Deep-Dive References — Pull When You Need Them

Read these **during a specific task**, not on startup. Match the file to what you're doing.

| When You're Doing... | Pull This File |
|----------------------|----------------|
| Rebase, cherry-pick, bisect, reflog, stash, recovery | `Sources/gitdude-knowledge/git/git_operations_recovery.md` |
| Choosing or implementing a branching strategy | `Sources/gitdude-knowledge/git/branching_strategies.md` |
| Enforcing commit standards, commitlint, signing | `Sources/gitdude-knowledge/git/conventional_commits.md` |
| Version bumping, SemVer, CalVer, auto-release tools | `Sources/gitdude-knowledge/release/versioning_strategies.md` |
| Writing changelogs, release notes, release checklist | `Sources/gitdude-knowledge/release/changelog_release_notes.md` |
| GitHub Actions, protected branches, CODEOWNERS, PRs | `Sources/gitdude-knowledge/automation/release_automation.md` |
| Setting up Husky, lint-staged, commitlint hooks | `Sources/gitdude-knowledge/automation/git_hooks_enforcement.md` |
| Secret scanning, SAST/DAST/SCA, access control | `Sources/gitdude-knowledge/security/repo_security_vulnerability_scanning.md` |
| AI tool exploits, supply chain attacks, SBOM | `Sources/gitdude-knowledge/security/prompt_injection_supply_chain.md` |
| Rollback, incident response, leaked secret protocol | `Sources/gitdude-knowledge/security/rollback_incident_response.md` |

### Additional References
- [Claude Code 2.1.0](../Sources/anthropic/claude_code_2_1_0.md) — Agent teams, hooks, hot reload
- [Claude Agent SDK Architecture](../Sources/Agent_Architecture/Patterns/claude_agent_sdk_architecture.md) — Implementation patterns

---

*10 core sources curated 2026-03-02. Informed by real Release Manager, SCM Engineer, and DevSecOps job requirements. Request Fetcher to add sources when you identify knowledge gaps.*
