# Repository Security & Vulnerability Scanning

**When to use:** Secret detection setup, SAST/DAST/SCA scanning, access control review, signed commits, .gitignore, dependency audits, or configuring Gitleaks/TruffleHog/GitGuardian.

---

## Secret Detection Tools

Leaked credentials are the single most exploited attack vector in modern breaches. In 2024, 23.8 million secrets were leaked on public GitHub alone — a 25% year-over-year increase. 70% of secrets leaked in 2022 remained active two years later. Repositories using AI coding assistants show a 40% higher secret leakage rate.

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

1. **Run Gitleaks before every release.** Scan the full diff between the last release tag and HEAD. No release ships with detected secrets.
2. **Enforce pre-commit hooks on every repository.** Include Gitleaks and `detect-private-key` at minimum.
3. **Treat every leaked secret as compromised.** Even staged-only: rotate immediately. Git history is permanent.
4. **Review .gitignore on every new project.** Verify `.env*`, `*.pem`, `*.key`, `credentials.*` are excluded before first commit.
5. **Require signed commits on protected branches.** Prefer SSH signing for simplicity. Enable Vigilant Mode.
6. **Gate releases on dependency scans.** Block releases with Critical or High vulnerabilities.
7. **Set token expiry on everything.** No permanent tokens. Max 90 days. GitHub App tokens preferred for CI/CD.
8. **Use .gitattributes in every repository.** Normalize line endings, mark binaries, set lockfile merge strategies.
9. **Audit access quarterly.** Review Write/Admin access. Remove departed team members immediately.
10. **Layer scanning: pre-commit + CI + monitoring.** Defense in depth is the only strategy that works.

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
