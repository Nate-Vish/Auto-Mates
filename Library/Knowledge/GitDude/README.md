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
| `repo-security.md` | Repository Security, Data Classification & DLP | Data classification (P1-P4 framework), DLP strategy (4 mechanisms), PII detection pipeline (regex + NER + predefined patterns), Two-Gate System (Sync Gate + Commit Gate), secret detection (Gitleaks, TruffleHog, GitGuardian), secret removal (git-filter-repo, 7 side effects), SAST/DAST/SCA, .gitignore patterns, access control, signed commits, Security Champion model (OWASP), DPO/DPIA awareness |
| `prompt-injection-supply-chain.md` | Prompt Injection & Supply Chain Security | AI tool exploits (CVE-2025-59536, CVE-2026-21852), MCP vulnerabilities, malicious repo patterns, supply chain attacks, SBOMs, dependency pinning |
| `rollback-incident-response.md` | Rollback & Incident Response | Production rollback, reverting bad commits, history remediation (BFG, git-filter-repo, 7 side effects), leaked secret protocol, evidence preservation during rollback, breach notification awareness (GDPR/CCPA/HIPAA/PCI-DSS deadlines), post-incident remediation checklist, blameless postmortem, communication during incidents |

---

## Core Doctrine — Always Active

These rules apply in every session regardless of which topic file you're reading.

**On the Two-Gate System (MANDATORY):**

Every file moving from live system to public repo passes through TWO gates:

| Gate | When | What It Checks |
|------|------|----------------|
| **Sync Gate** | Before copying files to Version_Control/ | File classification (as-is vs template-only vs never-ship). Content filtering for PII, private business data, live operational content. HIGH-RISK files (dashboards, session logs, task trackers) ship as templates only. |
| **Commit Gate** | Before `git commit` | Secret scanning (API keys, credentials). PII scanning (names, emails, IDs). Private data scanning (internal URLs, business data). .gitignore verification. Final human approval. |

**Why two gates:** The Sync Gate catches PII and private data BEFORE it enters the repo folder. The Commit Gate catches secrets and verifies nothing slipped through. One gate is not enough — the 2026-03-08 incident proved that a commit-only scan checking for API keys will miss PII accumulated in a live operational file.

**THE 2026-03-08 INCIDENT:**
A live operational file was synced as raw copy to public GitHub. It contained PII, internal URLs, and private business data accumulated from multiple contributors over time. **Public for 8 days before detection.** Root cause: no filtering layer — raw file copy with secret-pattern-only scan. The rule: *"Don't mix up user data and live dashboards with the clean templates that get published."* This incident is why the Sync Gate exists. If this lesson is ever skipped, re-read `Memory_Logs/Lessons.md` — the full incident is documented there.

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
- **Classify every file (P1-P4) before it enters the repo.** P4=never-ship, P3=template-only, P2=as-is-with-review, P1=public. Highest classification wins.
- **DLP requires four mechanisms working together:** classification + encryption + access controls + monitoring. No single tool covers all data categories.
- **PII detection needs three methods:** regex (structured PII), NER (names/locations in prose), predefined patterns (secrets). Never display actual PII in scan output.
- **GitDude is the Security Champion** (OWASP model): advise, scan, escalate — but never override the user (Pilot-in-Command). Mirrors the DPO advisory role.
- **Preserve evidence before rewriting history.** Capture exposure window, access logs, and affected refs before git-filter-repo destroys the forensic record.
- **Assess breach notification obligations** when a leaked secret granted access to personal data. Escalate to Legal — do not make legal determinations.
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

**Category 2 — PII (Personally Identifiable Information):**
Full names, email addresses, phone numbers, physical addresses. Government IDs, financial data, health information, biometric data. Usernames, profile URLs, account identifiers tied to real people.

**Category 3 — Private Business Data:**
Internal URLs, domains, IP addresses, deployment infrastructure. Private repo names, internal project codenames. Client/company names in operational context. Internal decisions, strategies, pricing, contracts, HR data.

**Category 4 — Live Operational Content:**
Dashboards, session logs, task trackers, activity history. Any file that multiple contributors write to over time — it accumulates PII and private data by nature.

**Files that should never be committed:** `.env`, `.env.local`, `.env.production`, `credentials.json`, `serviceAccountKey.json`, `*.pem`, `*.key`, database dumps, log files with user data.

**Files that ship as TEMPLATE only (never live copy):**
Dashboards, checkpoints, preferences, session logs — any file where real-world data accumulates over time. **Rule: if multiple contributors write to it over time, assume it contains PII until proven otherwise. Ship as template only.**

### File Classification (Sync Gate)

| Category | Ships As | Examples |
|----------|----------|---------|
| Identity files | As-is (after review) | `*_Identity.md`, `CLAUDE.md`, `Rules.md` |
| Knowledge files | As-is | `Library/Knowledge/*/README.md`, topic files |
| Templates | Clean template ONLY | `Brief.md`, `Checkpoint.md`, `Preferences.md`, `Sessions/` |
| Local-only | NEVER ships | `Library/Sources/`, `Memory_Logs/` content, `Work_Space/` |
| Skills | As-is (user decision) | `.claude/skills/` |

---

*Knowledge curated 2026-03-02, updated 2026-03-23 (security enrichment: data classification P1-P4, DLP strategy, PII detection pipeline, Two-Gate System deep-dive, Security Champion model, DPO/DPIA awareness, evidence preservation, breach notification, post-incident remediation — from 12 sources). Covers Git operations, release management, repository security, AI tool exploits, incident response, and personal data protection — informed by real Release Manager, SCM Engineer, and DevSecOps job requirements plus the Brief.md data leak incident. Request Fetcher to add sources when you identify knowledge gaps.*
