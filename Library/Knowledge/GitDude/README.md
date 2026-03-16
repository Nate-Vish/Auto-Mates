# GitDude Knowledge

**Domain:** Release management, version control, CI/CD pipelines, repository security, and incident response.

**Read this on every startup.** This index is your map. Read topic files during specific tasks — not all at once.

---

## Knowledge Files

| File | Topic | Read When... |
|------|-------|--------------|
| `git-operations.md` | Git Operations & Recovery | Rebasing, cherry-picking, bisect, reflog recovery, stash, worktree, merge conflicts, reset, emergency recovery |
| `branching-strategies.md` | Branching Strategies | Choosing a branching model, setting up branch protection, implementing GitFlow/Trunk-based/GitHub Flow/GitLab Flow, branch hygiene |
| `conventional-commits.md` | Conventional Commits & Commit Standards | Enforcing commit message standards, setting up commitlint, reviewing commit history quality, signing commits, squash vs keep |
| `versioning.md` | Versioning Strategies | Choosing a versioning scheme, bumping versions, setting up semantic-release or release-please, managing lockfiles, monorepo versioning |
| `changelog-release-notes.md` | Changelog & Release Notes | Writing changelogs, creating GitHub Releases, writing migration guides, running release checklists, anti-patterns |
| `release-automation.md` | Release Automation & Platform Features | GitHub Actions release pipelines, protected branches, CODEOWNERS, PR templates, tag management, Docker tags, progressive delivery, DORA metrics |
| `git-hooks-enforcement.md` | Git Hooks & Enforcement | Setting up Husky, lint-staged, commitlint hooks, secret scanning in hooks, pre-push gates, Lefthook, troubleshooting hook issues |
| `repo-security.md` | Repository Security & Vulnerability Scanning | Secret detection (Gitleaks, TruffleHog, GitGuardian), SAST/DAST/SCA, .gitignore patterns, access control, signed commits, dependency audits |
| `prompt-injection-supply-chain.md` | Prompt Injection & Supply Chain Security | AI tool exploits (CVE-2025-59536, CVE-2026-21852), MCP vulnerabilities, malicious repo patterns, supply chain attacks, SBOMs, dependency pinning |
| `rollback-incident-response.md` | Rollback & Incident Response | Production rollback, reverting bad commits, history remediation (BFG, git-filter-repo), leaked secret protocol, blameless postmortem, communication during incidents |

---

## Core Doctrine — Always Active

These rules apply in every session regardless of which topic file you're reading.

**On releases:**
- Tag every production deploy. Without tags, there is no rollback target.
- Run Gitleaks on the full diff before every release. No exceptions.
- Release checklist: tests pass → docs updated → CHANGELOG updated → migration guide if breaking → version bumped → tag created → artifacts built → release notes published.

**On history:**
- `git revert` for anything pushed to a shared branch. `git reset` only for local unpushed work.
- Never force-push to main. If a secret leaked, rotate first, then rewrite history.

**On security:**
- Secrets in git history are permanent. Deletion does not help. Rotation is the only remedy.
- Every leaked credential must be treated as compromised immediately — even if it was only staged for 5 minutes.
- Scan every repo before opening in AI coding tools. Check `.claude/`, `.cursor/`, `.vscode/tasks.json`, and lifecycle scripts.

**On automation:**
- Conventional commits are the input that drives the entire pipeline: commits → versioning → changelog → release.
- Without structured commits, release automation is impossible.
- Lockfiles are non-negotiable. Use `npm ci`, not `npm install`, in CI.

**On incidents:**
- Communicate every 30 minutes during an incident, even if there is nothing new to report.
- Blameless postmortem within 48 hours. Five Whys. Concrete action items with owners and due dates.
- MTTR is a DORA metric. Target under 1 hour for elite teams.

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
- **NEVER create version subfolders** (v1.0/, v1.1/). That is what git tags do.
- `.git` lives ONLY in `Version_Control/[Product]/`. Never in Work_Space or the project root.
- Work_Space → build. Version_Control → ship.

### Sensitive Data Patterns (Pre-Commit Scanning)

Scan every diff before committing. Block if any match.

**API Keys & Tokens:** `api_key`, `apikey`, `API_KEY`, `secret_key`, `SECRET_KEY`, `access_token`, `bearer_token`, `auth_token`. Prefixes: `sk_live_`, `pk_live_`, `sk_test_`, `AIza`, `ghp_`, `gho_`, `AKIA`.

**Credentials:** `password`, `passwd`, `PASSWORD`. Database connection strings with embedded passwords. SSH private keys (`BEGIN RSA PRIVATE KEY`, `BEGIN OPENSSH PRIVATE KEY`). OAuth client secrets.

**Files that should never be committed:** `.env`, `.env.local`, `.env.production`, `credentials.json`, `serviceAccountKey.json`, `*.pem`, `*.key`, database dumps, log files with user data.

---

*Knowledge curated 2026-03-02. Covers Git operations, release management, repository security, AI tool exploits, and incident response — informed by real Release Manager, SCM Engineer, and DevSecOps job requirements. Request Fetcher to add sources when you identify knowledge gaps.*
