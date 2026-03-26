# Repository Security & Vulnerability Scanning

**When to use:** Secret detection setup, SAST/DAST/SCA scanning, access control review, signed commits, .gitignore, dependency audits, data classification, DLP strategy, PII detection, or configuring Gitleaks/TruffleHog/GitGuardian.

---

## Data Classification Framework

Every file must be classified before entering version control. Classification drives controls — what ships, how it ships, and what gets blocked.

### Four Protection Levels

Adapted from the UC Berkeley P1-P4 standard and confirmed by AWS classification models. The 4-tier approach is the industry consensus.

| Level | Sensitivity | Repository Handling | Examples |
|-------|------------|-------------------|----------|
| **P4 — Restricted** | Unauthorized disclosure causes severe harm. Triggers breach notification laws. | **NEVER ship.** Excluded by .gitignore and Sync Gate. | Secrets, credentials, private keys, SSNs, financial account numbers, health records, database dumps |
| **P3 — Confidential** | PII or private data not classified as P4. Moderate harm if compromised. | **Template only.** Live content stripped, structure preserved. | Session logs, dashboards, checkpoints, preferences, employment records, contributor names in context |
| **P2 — Internal** | Restricted from public but not individually harmful. Need-to-know basis. | **As-is with review.** Human approval required. | Identity files, .claude/rules/automates.md, internal configuration, de-identified data, employee IDs |
| **P1 — Public** | Intended for unrestricted access. | **As-is.** Ships freely. | Knowledge files, README, CHANGELOG, published documentation, press releases |

### Classification Principles

1. **Highest classification wins.** A file containing one P4 element makes the entire file P4. A dataset with both P1 and P3 data is classified P3. No exceptions.
2. **Data owners are responsible** for initial classification. The person creating or syncing the file classifies it.
3. **Context elevates sensitivity.** Individually harmless data can become sensitive in combination. A name alone is P1; a name + salary + health condition is P4.
4. **Classification can change.** Reclassify when context, regulations, or file contents change. A clean template becomes P3 when live data accumulates.
5. **When in doubt, classify higher.** Downgrading is safe; upgrading after exposure is not.

### File Classification Matrix (Sync Gate)

| Category | Ships As | Examples |
|----------|----------|---------|
| Identity files | As-is (after review) | `*_Identity.md`, `.claude/rules/automates.md`, `Rules.md` |
| Knowledge files | As-is | `Library/Knowledge/*/README.md`, topic files |
| Templates | Clean template ONLY | `Brief.md`, `Checkpoint.md`, `Preferences.md`, `Sessions/` |
| Local-only | NEVER ships | `Library/Sources/`, `Memory_Logs/` content, `Work_Space/` |
| Skills | As-is (user decision) | `.claude/skills/` |

**Rule:** If multiple contributors write to a file over time, assume it contains PII until proven otherwise. Ship as template only.

---

## Data Loss Prevention (DLP)

DLP prevents sensitive data from leaving controlled environments. Four mechanisms work together — no single mechanism is sufficient alone.

### The Four DLP Mechanisms

| Mechanism | What It Does | Repository Implementation |
|-----------|-------------|--------------------------|
| **1. Classification** | Identify and categorize data by sensitivity | Sync Gate file classification (P1-P4) |
| **2. Encryption** | Render data unreadable to unauthorized parties | Encrypted secrets in transit and at rest; secret managers for credentials |
| **3. Access Controls** | Restrict who can read, write, and push | Least privilege roles, branch protection, fine-grained tokens, MFA |
| **4. Monitoring** | Track activity and detect anomalies | Audit logs, push protection alerts, CI scan reports, access reviews |

### Why Built-In Tools Are Not Enough

GitHub's native features (token scanning, push protection, branch protection, audit logs) cover **secrets/tokens only**. They do NOT detect:
- PII (names, emails, phone numbers, addresses)
- Private business data (internal URLs, strategy documents, pricing)
- Live operational content (dashboards, session logs accumulating contributor data)

The Two-Gate System fills this gap.

### DLP for Small Teams and Open-Source Projects

No single open-source tool covers all four data categories. Combine:

| Category | Tool/Mechanism |
|----------|---------------|
| Category 1 — Secrets | Gitleaks (pre-commit + CI) |
| Category 2 — PII | PII pre-commit hooks (regex + NER) |
| Category 3 — Private business data | File classification + Sync Gate |
| Category 4 — Live operational content | File classification + .gitignore + template-only rule |

### The Scale of the Problem

- **10 million secrets** found on GitHub in 2022 (67% increase from 2021).
- **23.8 million secrets** leaked on public GitHub in 2024 (25% year-over-year increase).
- **70% of secrets** leaked in 2022 remained active two years later.
- **60% of data breaches** stem from insider threats.
- Repositories using AI coding assistants show a **40% higher** secret leakage rate.

---

## The Two-Gate System

Every file moving from live system to public repository passes through TWO gates. One gate is not enough — the 2026-03-08 Brief.md incident proved that a commit-only scan checking for API keys will miss PII accumulated in a live operational file.

### Gate 1: Sync Gate (Content Filtering)

**When:** Before copying files to Version_Control/.

| Step | Action |
|------|--------|
| **Classify** | Assign P1-P4 level to every file |
| **Filter** | P4 files blocked. P3 files converted to clean templates. P2 files reviewed. |
| **Verify** | Check for PII, private business data, live operational content |
| **Approve** | Human sign-off before copy proceeds |

The Sync Gate is a mini-DPIA (Data Protection Impact Assessment) for every file:

| DPIA Question | Sync Gate Equivalent |
|--------------|---------------------|
| What personal data is being processed? | What data does this file contain? |
| Is processing necessary and proportionate? | Does this file need to be in the repo? |
| What are the risks to individuals? | PII? Private business data? Live operational content? |
| What measures mitigate those risks? | Ship as template, redact, or exclude entirely |
| Sign-off | Human approval before copy to Version_Control/ |

### Gate 2: Commit Gate (Secret + PII Scanning)

**When:** Before `git commit`.

| Step | Action |
|------|--------|
| **Secret scan** | Gitleaks/TruffleHog on staged diff (Category 1) |
| **PII scan** | Regex + NER + predefined patterns on staged diff (Category 2) |
| **Private data scan** | Pattern matching for internal URLs, business data (Category 3) |
| **.gitignore verify** | Confirm no excluded file types are staged |
| **Human approval** | Final review before commit |

### Why Two Gates

The Sync Gate catches PII and private data BEFORE it enters the repo folder. The Commit Gate catches secrets and verifies nothing slipped through. Defense in depth: `.gitignore` -> file classification -> Sync Gate -> pre-commit hooks -> CI scanning -> push protection.

---

## PII Detection Pipeline

PII detection requires three complementary methods. No single method catches everything.

### Three Detection Methods

| Method | What It Catches | Strengths | Weaknesses |
|--------|----------------|-----------|------------|
| **Regex patterns** | Structured PII: emails, phone numbers, credit cards, government IDs | Fast, deterministic, low false negatives for known formats | Cannot catch PII in free text, requires pattern maintenance |
| **Named Entity Recognition (NER)** | Unstructured PII: names, locations, organizations in prose | Catches what regex cannot — names in sentences, contextual PII | Higher false positive rate, requires ML model, slower |
| **Predefined secret patterns** | API keys, tokens, credentials, SSH keys | Well-known formats with reliable signatures | Only covers secrets, not broader PII |

### Implementation Architecture

```
Developer runs git commit
    |
    v
Pre-commit framework triggers PII/secret hooks
    |
    v
Scan staged files against all three methods
    |
    v
Finding detected?
    |
    +--> YES: Block commit. Show filename + line number + character range.
    |         CRITICAL: Never display the actual PII — only location info.
    |
    +--> NO: Commit proceeds.
```

### False Positive Handling

| Strategy | When to Use |
|----------|-------------|
| Inline marker (e.g., `PS-IGNORE`) | Preferred. Marks specific line as reviewed and safe. |
| NER exclusion file | For recurring NER false positives (product names detected as person names) |
| File-level exclusion | **Discouraged.** Bypasses all checks for that file — defeats the purpose. |

### Design Principles for PII Scanning

1. **Never display the PII.** Show location only (file, line, character range). Displaying PII in terminal output or CI logs creates a new exposure.
2. **Favor line-level exclusions** over file-level exclusions. Granular control preserves scanning for the rest of the file.
3. **Track file hashes** to avoid re-scanning unchanged files. Performance matters for developer adoption.
4. **Run initial full scan** with `pre-commit run --all-files` to establish a baseline before incremental scanning.
5. **Layer methods.** Regex catches structured PII. NER catches unstructured PII. Predefined patterns catch secrets. All three together provide reasonable coverage.

---

## Secret Detection Tools

Leaked credentials are the single most exploited attack vector in modern breaches.

### Tool Comparison

| Feature | Gitleaks | TruffleHog | GitGuardian | GitHub Native | git-secrets |
|---------|----------|------------|-------------|---------------|-------------|
| License | MIT (Free) | AGPL (Free) | Commercial | Free (public) | Apache 2.0 |
| Detection Method | Regex | Regex + Entropy | Regex + ML | Partner patterns | Regex |
| Live Verification | No | Yes (800+ types) | Yes | Yes (partners) | No |
| History Scanning | Yes | Yes (deep) | Yes | Partial | Yes |
| Multi-source | Git only | Git, Docker, S3, Slack, 20+ | Git, Slack, Jira | Git only | Git only |
| Speed | Very fast | Slower (verification) | Fast (SaaS) | Automatic | Fast |
| CI/CD Integration | Excellent | Good | Excellent | Native | Manual |
| False Positive Rate | Moderate | Low (verified) | Low | Low | Higher |
| Best For | Pre-commit, CI gates | Deep audits, multi-source | Enterprise teams | GitHub-native shops | AWS-focused teams |

**Best practice:** Use Gitleaks in pre-commit hooks for speed, TruffleHog in CI for verification, GitGuardian or GitHub Native for continuous monitoring. No single tool catches everything — Gitleaks and TruffleHog produce significant non-overlapping true positives.

### Gitleaks Setup

```bash
brew install gitleaks

# Scan staged changes (pre-commit)
gitleaks protect --staged

# Scan current directory
gitleaks detect --source . -v

# Generate JSON report
gitleaks detect --source . --report-format json --report-path results.json
```

**GitHub Actions integration:**
```yaml
name: Secret Scan
on: [push, pull_request]
jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Custom rules (`.gitleaks.toml`):**
```toml
[extend]
useDefault = true

[[rules]]
id = "custom-internal-token"
description = "Internal API Token"
regex = '''int_token_[a-zA-Z0-9]{32}'''
tags = ["internal", "token"]

[allowlist]
paths = [
  '''.*_test\.go''',
  '''.*\.md''',
  '''testdata/'''
]
```

**Extending Gitleaks for Categories 2-4:** Gitleaks natively handles Category 1 (secrets). Add custom rules in `.gitleaks.toml` for email patterns, phone numbers, and internal URL formats to extend coverage into Categories 2-3.

### TruffleHog Setup

```bash
brew install trufflehog

# Scan entire Git history, only verified secrets
trufflehog git file://. --only-verified

# Scan a remote repo
trufflehog git https://github.com/org/repo.git

# Scan a Docker image
trufflehog docker --image myimage:latest
```

### GitGuardian CLI

```bash
pip install ggshield
ggshield secret scan path .
ggshield secret scan repo .
ggshield secret scan ci
```

### GitHub Secret Scanning (Native)

Enable in repository settings: **Settings > Code security and analysis > Secret scanning**. Free for all public repos. Scans for 200+ token formats and auto-revokes with participating providers.

---

## API Key Leak Patterns to Detect

| Service | Pattern Prefix | Example Regex |
|---------|---------------|---------------|
| AWS Access Key | `AKIA` | `AKIA[0-9A-Z]{16}` |
| GitHub PAT (classic) | `ghp_` | `ghp_[A-Za-z0-9]{36}` |
| GitHub OAuth App | `gho_` | `gho_[A-Za-z0-9]{36}` |
| GitHub Fine-grained | `github_pat_` | `github_pat_[A-Za-z0-9]{22}_[A-Za-z0-9]{59}` |
| Stripe Live | `sk_live_` | `sk_live_[A-Za-z0-9]{24,}` |
| Google API Key | `AIza` | `AIza[0-9A-Za-z_-]{35}` |
| Slack Bot Token | `xoxb-` | `xoxb-[0-9]{10,}-[A-Za-z0-9]{24,}` |
| OpenAI API Key | `sk-` | `sk-[A-Za-z0-9]{48,}` |
| Anthropic API Key | `sk-ant-` | `sk-ant-[A-Za-z0-9_-]{90,}` |
| npm Token | `npm_` | `npm_[A-Za-z0-9]{36}` |
| SSH Private Key | `-----BEGIN` | `-----BEGIN (RSA\|EC\|DSA\|OPENSSH) PRIVATE KEY-----` |
| JWT | `eyJ` | `eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}` |

### Why Deletion Does Not Help

```bash
# This does NOT remove the secret from Git
git rm .env
git commit -m "remove secrets"
# The secret is STILL in git history — git is append-only
```

Correct remediation: rotate first, then use `git filter-repo` to rewrite history (see `rollback-incident-response.md`).

---

## Secret Removal & History Rewriting

When prevention fails, history rewriting is the last resort. Understand the costs before proceeding.

### Primary Tool: git-filter-repo

```bash
pip install git-filter-repo

# Remove a file from entire history
git filter-repo --invert-paths --path secrets/api-keys.json

# Remove a directory from entire history
git filter-repo --invert-paths --path-prefix config/credentials/

# Replace text in entire history
git filter-repo --replace-text <(echo 'regex:AKIA[A-Z0-9]{16}==>REDACTED_AWS_KEY')

# Remove files by pattern
git filter-repo --invert-paths --path-glob '*.pem'
git filter-repo --invert-paths --path-glob '*.key'
```

### Seven Side Effects of History Rewriting

Every side effect is a cost. Weigh them against the risk of the exposed data remaining in history.

| # | Side Effect | Impact |
|---|-------------|--------|
| 1 | **Recontamination risk** | Old clones that `git pull` then `git push` will reintroduce the sensitive data |
| 2 | **Lost work** | Developers on contaminated branches during cleanup must redo work |
| 3 | **Changed commit hashes** | All affected commits + descendants get new SHAs — breaks references, tooling, CI |
| 4 | **Branch protection bypass** | Force-push protections must be temporarily disabled |
| 5 | **Broken PR diffs** | Closed PR diffs become inaccessible |
| 6 | **Open PR disruption** | Changed SHAs alter diffs; review comments become orphaned |
| 7 | **Lost signatures** | Cryptographic signatures stripped — invalid after hash change |

### Impact on Forks

Forks retain the original commits. GitHub cannot contact fork owners on your behalf. You must coordinate directly with each fork owner to request removal or deletion. **This means history rewriting is inherently incomplete for public repositories with forks.**

### Post-Cleanup Coordination

After rewriting history:
- All collaborators must **rebase (not merge)** from old history. A single merge commit can reintroduce contamination.
- Fresh clone recommended over attempting to rebase.
- Alert all contributors — anyone with the old history still has the sensitive data in their local clone and reflog.

### Prevention Is Infinitely Cheaper Than Remediation

The Two-Gate System exists to make history rewriting unnecessary. Every dollar invested in prevention saves ten in incident response. This is why the Sync Gate and Commit Gate are mandatory, not optional.

---

## SAST / DAST / SCA

### When to Use Each

| Phase | Tool Type | What It Catches |
|-------|-----------|----------------|
| Writing code | SAST + Linting | Injection, logic bugs, insecure patterns |
| Building | SCA | Known CVEs in dependencies |
| Deployed staging | DAST | Runtime misconfigs, auth bypasses |
| Pre-release | All three | Full coverage gate |

### SAST Tools

| Tool | Language Support | License | Best For |
|------|-----------------|---------|----------|
| SonarQube | 30+ languages | Community (free) / Commercial | Broad coverage, quality gates |
| Semgrep | 30+ languages | LGPL (free) / Commercial | Custom rules, fast, lightweight |
| CodeQL | 10+ languages | Free for OSS | Deep semantic analysis, GitHub native |
| Bandit | Python only | Apache 2.0 | Python security linting |
| ESLint Security | JavaScript/TS | MIT | JS/TS security patterns |

**Semgrep CI example:**
```yaml
- name: Semgrep Scan
  run: |
    pip install semgrep
    semgrep scan --config auto --error
```

### DAST Tools

| Tool | License | Best For |
|------|---------|----------|
| OWASP ZAP | Apache 2.0 | Free, comprehensive, CI-friendly |
| Burp Suite | Commercial | Manual pentesting, advanced |
| Nuclei | MIT | Template-based, fast |

**OWASP ZAP in CI:**
```yaml
- name: ZAP Baseline Scan
  uses: zaproxy/action-baseline@v0.12.0
  with:
    target: 'https://staging.example.com'
    fail_action: 'warn'
```

### SCA Tools

| Tool | Ecosystem | License | Key Feature |
|------|-----------|---------|-------------|
| Snyk | Multi-language | Free tier / Commercial | Fix PRs, container scanning |
| Dependabot | Multi-language | Free (GitHub) | Auto-update PRs |
| npm audit | Node.js | Built-in | Zero setup for Node |
| pip-audit | Python | Apache 2.0 | Official Python advisory DB |
| Trivy | Multi + containers | Apache 2.0 | Fast, broad, IaC scanning |

```bash
# Node
npm audit
npm audit fix

# Python
pip install pip-audit
pip-audit -r requirements.txt

# JSON output for CI parsing
npm audit --json
pip-audit --format json --output results.json
```

### CVSS Severity Response

| CVSS Range | Severity | Action Required |
|------------|----------|----------------|
| 9.0 - 10.0 | Critical | Fix immediately, consider hotfix |
| 7.0 - 8.9 | High | Fix within 7 days |
| 4.0 - 6.9 | Medium | Fix within 30 days |
| 0.1 - 3.9 | Low | Fix in normal cycle |

### Dependabot Configuration

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 10
    reviewers:
      - "security-team"
    labels:
      - "dependencies"
      - "security"
```

---

## .gitignore Security Patterns

### Critical Patterns to Always Include

```gitignore
# SECRETS & CREDENTIALS
*.env
*.env.*
.env.local
.env.production
.env.staging
*.pem
*.key
*.crt
*.p12
*.pfx
*.jks
credentials.json
service-account*.json
*-credentials.json
*_credentials.json
secrets.yml
secrets.yaml
vault-token
.htpasswd

# API Keys & Tokens
*.token
*.secret
api_keys.*
oauth_tokens.*

# SSH
id_rsa
id_ed25519
id_ecdsa
known_hosts

# Cloud Provider
.aws/credentials
.aws/config
.gcp/
terraform.tfvars
*.auto.tfvars
terraform.tfstate
terraform.tfstate.backup

# Dependencies
node_modules/
vendor/
.venv/
__pycache__/
*.pyc

# Build Artifacts
dist/
build/

# IDE & OS
.DS_Store
Thumbs.db
.idea/
.vscode/settings.json
*.swp
*~

# Logs & Databases
*.log
*.sqlite
*.db
```

### AutoMates-Specific Patterns

Files that should never be committed from this project:
`.env`, `.env.local`, `.env.production`, `credentials.json`, `serviceAccountKey.json`, `*.pem`, `*.key`, database dumps, log files with user data.

### Retroactive Cleanup

Adding a pattern to `.gitignore` does not remove already-tracked files:

```bash
git rm --cached .env
git commit -m "stop tracking .env"

git rm -r --cached node_modules/
git commit -m "stop tracking node_modules"
```

### Global Gitignore

```bash
git config --global core.excludesFile ~/.gitignore_global
```

---

## .gitattributes

### Line Ending Normalization

```gitattributes
# Default: normalize all text files to LF in the repo
* text=auto eol=lf

# Force LF for scripts (even on Windows)
*.sh    text eol=lf
*.py    text eol=lf
*.yml   text eol=lf
*.yaml  text eol=lf
*.json  text eol=lf

# Force CRLF for Windows-specific files
*.bat   text eol=crlf
*.cmd   text eol=crlf
*.ps1   text eol=crlf

# Binary files — never normalize, never diff as text
*.png   binary
*.jpg   binary
*.pdf   binary
*.zip   binary
*.gz    binary
*.woff  binary
*.woff2 binary
```

### Merge Strategies Per File Type

```gitattributes
# Always keep our version of lockfiles on merge conflicts
package-lock.json merge=ours
yarn.lock         merge=ours
poetry.lock       merge=ours

# Exclude generated code from language stats
vendor/*        linguist-vendored
dist/*          linguist-generated
*.min.js        linguist-generated
```

---

## Access Control & Permissions

### GitHub Role Comparison

| Capability | Read | Triage | Write | Maintain | Admin |
|------------|------|--------|-------|----------|-------|
| Clone / Pull | Yes | Yes | Yes | Yes | Yes |
| Manage issues/labels | No | Yes | Yes | Yes | Yes |
| Push to non-protected | No | No | Yes | Yes | Yes |
| Merge pull requests | No | No | Yes | Yes | Yes |
| Manage branch rules | No | No | No | Yes | Yes |
| Manage repo settings | No | No | No | No | Yes |
| Delete repository | No | No | No | No | Yes |

**Principle of least privilege:** Every user, token, and service account should have the minimum permissions necessary.

### Token Types and Expiry

| Token Type | Scope | Expiry | Best For |
|------------|-------|--------|----------|
| Fine-grained PAT | Per-repo, per-permission | Configurable (max 1yr) | CI/CD, automation |
| Classic PAT | Broad scopes | Configurable | Legacy systems |
| Deploy Key | Single repo, read or read/write | No expiry (rotate manually) | Server deployments |
| GitHub App Token | Per-installation | 1 hour (auto-refresh) | CI/CD, enterprise |
| GITHUB_TOKEN | Workflow-scoped | Job lifetime | GitHub Actions |

**Rules:**
- Always set token expiry. Never create tokens without expiration.
- Prefer fine-grained PATs over classic PATs.
- Rotate tokens on a schedule (90 days maximum).
- 96% of leaked GitHub tokens have write access — default to read-only.

---

## Signed Commits & Tags

Signed commits prevent commit spoofing, unauthorized code injection, and attribution fraud. Without signing, anyone who gains push access can impersonate any committer.

### SSH Signing (Recommended — Simpler)

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgSign true
git config --global tag.gpgSign true

# Create an allowed signers file for verification
echo "$(git config --get user.email) $(cat ~/.ssh/id_ed25519.pub)" >> ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Upload your SSH signing key to GitHub: Settings > SSH and GPG keys > New SSH Key > Key type: Signing key.

### GPG Signing (Traditional)

```bash
gpg --full-generate-key  # RSA 4096-bit

# Find key ID
gpg --list-secret-keys --keyid-format=long
# Output: sec rsa4096/3AA5C34371567BD2

git config --global user.signingkey 3AA5C34371567BD2
git config --global commit.gpgSign true
git config --global tag.gpgSign true

# Export for GitHub
gpg --armor --export 3AA5C34371567BD2
# Paste into GitHub > Settings > SSH and GPG keys > New GPG key
```

### Vigilant Mode

Enable in GitHub settings: Settings > SSH and GPG keys > Flag unsigned commits as unverified. All unsigned commits will display a yellow "Unverified" badge.

### Verifying Signatures

```bash
git verify-commit HEAD
git log --show-signature -1
# G = Good, B = Bad, U = Untrusted, N = No signature
git log --pretty="format:%H %G? %aN %s"

# Signed tags
git tag -s v1.0.0 -m "Release v1.0.0"
git verify-tag v1.0.0
```

---

## The Security Champion Model

GitDude operates as the Security Champion for the repository — a role defined by OWASP as "a single point of contact in regards to security for their team."

### Core Responsibilities (Mapped to GitDude)

| OWASP Responsibility | GitDude Implementation |
|---------------------|----------------------|
| **Evangelize security** | Educate team on Two-Gate System, classification, and scanning |
| **Contribute to standards** | Enforce conventional commits, branching rules, release checklists |
| **Conduct threat modeling** | File classification via Sync Gate — assess what data each file contains |
| **Perform code reviews** | Pre-commit scanning via Commit Gate — secrets, PII, private data |
| **Deploy testing tools** | Configure and maintain Gitleaks, PII hooks, CI scanning pipelines |
| **Facilitate activities** | Run pre-release security scans, dependency audits, access reviews |

### Operating Principles

1. **Advise and monitor, do not override.** The Security Champion flags risks; the user (Pilot-in-Command) decides. This mirrors the GDPR DPO model — independent advisor, not decision-maker.
2. **Automate where possible, judge where necessary.** Automated tooling handles known patterns. Human judgment handles ambiguous cases (is this string a name or a product?).
3. **Escalate, do not block silently.** When a scan finds something ambiguous, surface it with context. Never suppress findings without user awareness.
4. **First line of escalation.** For security concerns beyond GitDude's scope (legal obligations, breach notification, regulatory compliance), escalate to Checker or Legal agents.

### DPO/DPIA Awareness

The Sync Gate implements principles from GDPR data protection:

- **Data protection by design:** File classification happens before data enters the repo, not after.
- **Data minimization:** Never-ship files embody the principle of collecting/sharing only what is necessary.
- **Impact assessment:** Every file passing through the Sync Gate undergoes a mini-DPIA — what personal data does it contain, is it necessary, what are the risks, what mitigates them.
- **Advisory role:** GitDude advises and monitors (like a DPO) but the user retains decision authority (like a data controller).

When a file classification decision could trigger regulatory obligations (e.g., a leaked file contained personal data of EU residents), GitDude should flag this for escalation to the Legal agent. GitDude does not make legal determinations — it identifies the data and raises the flag.

---

## Pre-Commit Security Scanning

### Security-Focused `.pre-commit-config.yaml`

```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.21.2
    hooks:
      - id: gitleaks

  - repo: https://github.com/trufflesecurity/trufflehog
    rev: v3.88.0
    hooks:
      - id: trufflehog
        entry: trufflehog git file://. --since-commit HEAD --only-verified --fail
        stages: [pre-commit]

  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: check-merge-conflict
      - id: detect-private-key
      - id: no-commit-to-branch
        args: ['--branch', 'main', '--branch', 'release']
      - id: check-json
      - id: check-yaml

  - repo: https://github.com/semgrep/semgrep
    rev: v1.99.0
    hooks:
      - id: semgrep
        args: ['--config', 'auto', '--error']
```

```bash
pre-commit install          # install hooks
pre-commit run --all-files  # run once on entire repo
pre-commit autoupdate       # update hook versions

# Create baseline for detect-secrets
detect-secrets scan > .secrets.baseline
detect-secrets audit .secrets.baseline
```

---

## Daily Rules (GitDude)

1. **Classify every file before it enters the repo.** Use P1-P4 levels. Highest classification wins. When in doubt, classify higher.
2. **Run both gates on every sync and commit.** Sync Gate for content filtering, Commit Gate for secret/PII scanning. Skipping a gate is how incidents happen.
3. **Run Gitleaks before every release.** Scan the full diff between the last release tag and HEAD. No release ships with detected secrets.
4. **Enforce pre-commit hooks on every repository.** Include Gitleaks, `detect-private-key`, and PII detection at minimum.
5. **Treat every leaked secret as compromised.** Even staged-only: rotate immediately. Git history is permanent.
6. **Never display actual PII in scan output.** Show file, line, and character range only. PII in terminal output or CI logs creates a new exposure.
7. **Review .gitignore on every new project.** Verify `.env*`, `*.pem`, `*.key`, `credentials.*` are excluded before first commit.
8. **Require signed commits on protected branches.** Prefer SSH signing for simplicity. Enable Vigilant Mode.
9. **Gate releases on dependency scans.** Block releases with Critical or High vulnerabilities.
10. **Set token expiry on everything.** No permanent tokens. Max 90 days. GitHub App tokens preferred for CI/CD.
11. **Use .gitattributes in every repository.** Normalize line endings, mark binaries, set lockfile merge strategies.
12. **Audit access quarterly.** Review Write/Admin access. Remove departed team members immediately.
13. **Layer scanning: pre-commit + CI + monitoring.** Defense in depth is the only strategy that works.
14. **Escalate regulatory concerns.** When classification decisions involve personal data of identifiable individuals, flag for Legal agent review.

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
