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

**On the Two-Gate System (MANDATORY):**

Every file moving from live system to public repo passes through TWO gates:

| Gate | When | What It Checks |
|------|------|----------------|
| **Sync Gate** | Before copying files to Version_Control/ | File classification (as-is vs template-only vs never-ship). Content filtering for personal data, internal URLs, operational details. HIGH-RISK files (Brief.md, Sessions/, Checkpoint.md) ship as templates only. |
| **Commit Gate** | Before `git commit` | Secret scanning (API keys, credentials). Personal data scanning (career info, company names, personal details). .gitignore verification. Final human approval. |

**Why two gates:** The Sync Gate catches personal/operational data BEFORE it enters the repo folder. The Commit Gate catches secrets and verifies nothing slipped through. One gate is not enough — the Brief.md incident proved that a commit-only scan that checks for API keys will miss personal career data in a dashboard file.

**THE BRIEF.MD INCIDENT (2026-03-08):**
Brief.md was synced as raw live copy to public GitHub. It contained: career data (companies being applied to, personal details like "degree=half"), internal URLs (domains, email addresses, deployment details), and internal process history. **Public for 8 days before Checker caught it.** Root cause: no filtering layer — raw file copy with API-key-only scan. The pilot's rule: *"Don't mix up my data and our dashboard with the basic templates that we publish."* This incident is why the Sync Gate exists. If this lesson is ever skipped, re-read `Memory_Logs/Lessons.md` — the full incident is documented there.

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
- **Personal data in git history is equally permanent.** Career info, company names, personal details — once pushed, they exist in every clone and fork.
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

**Category 1 — Secrets & Credentials:**
API Keys & Tokens: `api_key`, `apikey`, `API_KEY`, `secret_key`, `SECRET_KEY`, `access_token`, `bearer_token`, `auth_token`. Prefixes: `sk_live_`, `pk_live_`, `sk_test_`, `AIza`, `ghp_`, `gho_`, `AKIA`.
Credentials: `password`, `passwd`, `PASSWORD`. Database connection strings with embedded passwords. SSH private keys (`BEGIN RSA PRIVATE KEY`, `BEGIN OPENSSH PRIVATE KEY`). OAuth client secrets.

**Category 2 — Personal & Operational Data:**
Career info: company names being applied to, job application details, interview notes, resume content, personal details (degree status, language proficiency). Internal URLs: domains, email addresses (team@), deployment infrastructure, private repo names. Internal process: agent renames, team decisions, internal codenames. Live dashboard content: anything from Brief.md, Sessions/, or Work_Space/ that references real people, companies, or personal plans.

**Files that should never be committed:** `.env`, `.env.local`, `.env.production`, `credentials.json`, `serviceAccountKey.json`, `*.pem`, `*.key`, database dumps, log files with user data.

**Files that ship as TEMPLATE only (never live copy):**
`Brief.md` — replace with clean template before committing. `Checkpoint.md`, `Preferences.md`, `Sessions/` — ship empty templates or exclude entirely. **Rule: any file that multiple agents write to over time is HIGH RISK — it accumulates personal data and must ship as template only.**

### File Classification (Sync Gate)

| Category | Ships As | Examples |
|----------|----------|---------|
| Identity files | As-is (after review) | `*_Identity.md`, `CLAUDE.md`, `Rules.md` |
| Knowledge files | As-is | `Library/Knowledge/*/README.md`, topic files |
| Templates | Clean template ONLY | `Brief.md`, `Checkpoint.md`, `Preferences.md`, `Sessions/` |
| Local-only | NEVER ships | `Library/Sources/`, `Memory_Logs/` content, `Work_Space/` |
| Skills | As-is (user decision) | `.claude/skills/` |

---

*Knowledge curated 2026-03-02, updated 2026-03-16 (Brief.md incident hardening). Covers Git operations, release management, repository security, AI tool exploits, incident response, and personal data protection — informed by real Release Manager, SCM Engineer, and DevSecOps job requirements plus the Brief.md data leak incident. Request Fetcher to add sources when you identify knowledge gaps.*
