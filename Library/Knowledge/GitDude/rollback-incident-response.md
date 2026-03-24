# Rollback & Incident Response

**When to use:** Production rollback, reverting bad commits, responding to a secret leak, rewriting git history, conducting a postmortem, managing communication during an incident, evidence preservation, or breach notification awareness.

---

## Rollback Decision Tree

```
START: Something is wrong with a commit or release
│
├─ Is the bad code deployed to production?
│  │
│  ├─ YES → Is a previous tag/release known-good?
│  │  │
│  │  ├─ YES → REDEPLOY PREVIOUS TAG (fastest, safest)
│  │  │         Then investigate and fix forward
│  │  │
│  │  └─ NO  → REVERT the bad commits on the release branch
│  │            Deploy the revert commit
│  │
│  └─ NO (still in repository, not deployed)
│     │
│     ├─ Has the bad code been pushed to the remote?
│     │  │
│     │  ├─ YES → Use GIT REVERT (preserves history, safe for shared branches)
│     │  │         Never rewrite shared history
│     │  │
│     │  └─ NO  → Use GIT RESET (rewrite local history, clean and simple)
│     │
│     └─ How many commits are bad?
│        │
│        ├─ Single commit → git revert <sha>
│        ├─ Range of commits → git revert <oldest>^..<newest>
│        └─ Merge commit → git revert -m 1 <merge-sha>
```

**Cardinal rule:** If it has been pushed to a shared branch, use `git revert`. If it is local only, `git reset` is acceptable. Never force-push to rewrite history on shared branches — the one exception is a secret leak.

---

## git revert

`git revert` creates a new commit that undoes the changes of a previous commit. It preserves history and is safe for shared branches.

### Revert a Single Commit

```bash
git revert HEAD
git revert a1b2c3d
git revert --no-commit a1b2c3d  # stage changes without auto-committing
```

### Revert a Range of Commits

```bash
# Revert from oldest to newest (inclusive)
git revert --no-commit older_sha^..newer_sha
git commit -m "revert: undo commits older_sha through newer_sha"
```

### Revert a Merge Commit

```bash
# -m 1 = keep the first parent (usually the target branch)
# This undoes the changes brought in by the merged branch
git revert -m 1 <merge-commit-sha>

# Identify parents
git log --format="%H %P" -1 <merge-commit-sha>
# parent1 = branch you merged INTO, parent2 = branch you merged FROM
```

### Revert of a Revert (Bringing a Feature Back)

```bash
# Original commit: abc123
# Revert commit: def456
# To re-apply the original feature:
git revert def456
```

### Handling Conflicts During Revert

```bash
git revert <sha>
# If conflicts: resolve manually, then
git add .
git revert --continue
# Or cancel:
git revert --abort
```

---

## git reset

`git reset` moves the branch pointer backward, effectively erasing commits. **Only use on local, unpushed work.**

### Three Modes

| Mode | Command | Working Dir | Staging | Commits |
|------|---------|-------------|---------|---------|
| `--soft` | `git reset --soft HEAD~1` | Unchanged | Changes remain staged | Removed |
| `--mixed` | `git reset HEAD~1` | Unchanged | Changes unstaged | Removed |
| `--hard` | `git reset --hard HEAD~1` | Changes discarded | Cleared | Removed |

```bash
# --soft: re-do commit with different message
git reset --soft HEAD~1
git commit -m "fix(auth): corrected message"

# --mixed: unstage and reconsider
git reset HEAD~1
git add specific-file.js
git commit -m "feat(ui): partial implementation"

# --hard: discard last N commits and all changes
git reset --hard HEAD~3
# WARNING: All changes from those 3 commits are gone
```

### Safety Net: git reflog

Even after `git reset --hard`, commits are not immediately deleted:

```bash
git reflog
# HEAD@{0}: reset: moving to HEAD~3
# HEAD@{1}: commit: feat(ui): add dashboard

# Recover a "lost" commit
git reset --hard f4e5d6c
# Or cherry-pick it
git cherry-pick f4e5d6c
```

Reflog entries expire (default: 90 days reachable, 30 days unreachable).

### Never Reset Shared Branches

```bash
# If you MUST force-push (e.g., secret leak), use force-with-lease
git push --force-with-lease
# This fails if someone else has pushed since your last fetch
# NEVER use bare --force on shared branches
```

---

## Redeploy Previous Tag

The fastest and safest production rollback. No git operations on the release branch.

```bash
# List recent tags
git tag --sort=-version:refname | head -10

# Check out the previous good tag
git checkout v1.2.3

# Or create a rollback branch from the tag
git checkout -b rollback/v1.2.3 v1.2.3
```

### CI/CD Rollback Workflow (GitHub Actions)

```yaml
# .github/workflows/rollback.yml
name: Production Rollback
on:
  workflow_dispatch:
    inputs:
      tag:
        description: 'Tag to rollback to (e.g., v1.2.3)'
        required: true
        type: string
      reason:
        description: 'Reason for rollback'
        required: true
        type: string

jobs:
  rollback:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ inputs.tag }}
      - name: Log rollback
        run: |
          echo "ROLLBACK: ${{ inputs.tag }} by ${{ github.actor }}"
          echo "Reason: ${{ inputs.reason }}"
      - name: Build from tag
        run: npm ci && npm run build
      - name: Deploy
        run: npm run deploy:production
        env:
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
      - name: Notify team
        run: |
          curl -X POST "${{ secrets.SLACK_WEBHOOK }}" \
            -H 'Content-Type: application/json' \
            -d "{\"text\":\"ROLLBACK: Production rolled back to ${{ inputs.tag }} by ${{ github.actor }}. Reason: ${{ inputs.reason }}\"}"
```

**Best practice:** Tag every production deploy.
```bash
git tag -a "v1.2.4" -m "Release v1.2.4 — deployed $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push origin "v1.2.4"
```

---

## History Remediation

When sensitive data is committed, it must be removed from the **entire Git history**, not just the current branch tip.

### git-filter-repo (Recommended)

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

# After cleanup
git push --force --all
git push --force --tags
```

### BFG Repo-Cleaner (Faster for Simple Cases)

```bash
brew install bfg

# Remove a file from all history
bfg --delete-files credentials.json

# Replace text in all history
echo "AKIAIOSFODNN7EXAMPLE" > passwords.txt
bfg --replace-text passwords.txt

# Remove large files
bfg --strip-blobs-bigger-than 100M

# After BFG, clean up and force push
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force --all
git push --force --tags
```

### Seven Side Effects of History Rewriting

| # | Side Effect | Impact |
|---|-------------|--------|
| 1 | **Recontamination risk** | Old clones that `git pull` then `git push` will reintroduce sensitive data |
| 2 | **Lost work** | Developers on contaminated branches during cleanup must redo work |
| 3 | **Changed commit hashes** | All affected commits + descendants get new SHAs — breaks tooling |
| 4 | **Branch protection issues** | Force-push protections must be temporarily disabled |
| 5 | **Broken PR diffs** | Closed PR diffs become inaccessible |
| 6 | **Open PR disruption** | Changed SHAs alter diffs; comments become orphaned |
| 7 | **Lost signatures** | Cryptographic signatures stripped (invalid after hash change) |

### Impact on Forks

Commits in forks remain accessible. GitHub cannot contact fork owners — you must coordinate directly with each fork owner to request removal or deletion. **History rewriting is inherently incomplete for public repositories with forks.**

### Post-Cleanup Steps

After rewriting history, every team member must re-clone or reset:

```bash
# Option 1: Fresh clone (recommended)
cd ..
rm -rf old-repo
git clone <repository-url>

# Option 2: Force-reset existing clone
git fetch origin
git reset --hard origin/main
git clean -fd
```

**Alert all contributors.** Anyone with the old history still has the secrets in their local clone and reflog. A single `git pull` + `git push` from an old clone reintroduces contamination — fresh clone is the only safe path.

---

## Leaked Secret Response Protocol

Execute this protocol immediately when a secret is discovered. Time is the enemy.

```
MINUTE 0-5: CONTAIN
├── Step 1: REVOKE the credential immediately
│   - API key? Regenerate in the provider's console
│   - Database password? Change it now
│   - SSH key? Remove from authorized_keys
│   DO NOT WAIT to remove from git first. Revoke FIRST.
│
├── Step 2: ROTATE / REGENERATE
│   - Create a new credential
│   - Update it in your secrets manager (Vault, AWS SSM, etc.)
│   - Deploy the new credential to running services
│   - Verify services are working with the new credential
│
MINUTE 5-30: PRESERVE EVIDENCE + REMEDIATE
├── Step 3: PRESERVE EVIDENCE (before rewriting history)
│   - Record the exposure window: when committed → when discovered
│   - Record which branches, tags, and refs contain the data
│   - Save access logs from the affected service for the exposure window
│   - Screenshot or export any relevant CI/CD logs showing the leak
│   - Document: who had access to the repo during the exposure window?
│   - If the repo was public: assume the secret was harvested by bots
│   NOTE: History rewriting destroys forensic evidence. Capture it FIRST.
│
├── Step 4: REMOVE from Git history (BFG or git-filter-repo)
│   - Remove from ALL branches, not just main
│   - Clean reflog and garbage collect
│
├── Step 5: FORCE-PUSH cleaned history
│   - git push --force --all
│   - git push --force --tags
│   - Notify all team members to re-clone
│
MINUTE 30-60: INVESTIGATE
├── Step 6: NOTIFY the team
│   - Post in team channel: what leaked, when, current status
│   - If customer data may be affected: notify security team / DPO
│
├── Step 7: AUDIT for unauthorized access
│   - Check access logs for the exposure window
│   - Determine: when was it committed? When was it discovered?
│   - Look for: unusual API calls, new resources created, data exports
│   - Check: was the leaked credential used from unexpected IP addresses?
│
AFTER INCIDENT: ASSESS REGULATORY OBLIGATIONS + PREVENT
├── Step 8: ASSESS BREACH NOTIFICATION REQUIREMENTS
│   - Was personal data exposed? (If the leaked secret granted access to PII)
│   - Determine scope: how many individuals potentially affected?
│   - Check notification deadlines:
│     * GDPR: 72 hours to supervisory authority (if personal data at risk)
│     * US state laws: vary (30-90 days typically)
│     * PCI-DSS: immediate notification to payment brands if card data at risk
│   - Escalate to Legal agent for regulatory determination
│   - Document the decision: why notification is/is not required
│
└── Step 9: DOCUMENT in post-mortem
    - Timeline, root cause, impact, remediation, prevention
    - Update pre-commit hooks to catch similar patterns
    - Record all evidence preservation actions taken
```

### Evidence Preservation During Rollback

When rolling back or rewriting history, forensic evidence can be lost. Preserve before you remediate.

| Evidence Type | How to Preserve | Why It Matters |
|--------------|----------------|---------------|
| **Exposure window** | `git log --all -p -S '<secret-pattern>' --source` | Establishes timeline for regulatory reporting |
| **Access logs** | Export from service provider console | Shows if the leaked credential was exploited |
| **Affected refs** | `git branch --contains <commit>` and `git tag --contains <commit>` | Determines blast radius |
| **CI/CD logs** | Screenshot or export before history rewrite | Proves detection timeline |
| **Repo access list** | Export collaborator list with permissions | Identifies who could have seen the secret |
| **Fork list** | Note all known forks (public repos) | Forks retain original history after rewrite |

**Principle:** History rewriting is destructive by design — it removes data. But during an incident, you may need that data for investigation, audit, or regulatory compliance. Always capture evidence before rewriting.

### Breach Notification Awareness

A leaked secret is not always just a secret rotation problem. If the leaked credential provided access to personal data, the incident may trigger breach notification obligations.

**When a secret leak becomes a data breach:**
- The leaked API key had read access to a database containing user records
- The leaked OAuth token granted access to user email accounts or files
- The leaked service account key had access to storage buckets with customer data
- The leaked credentials were used by an unauthorized party during the exposure window

**GitDude's role:** Identify the data-access implications of the leaked credential and escalate to Legal when personal data may have been exposed. GitDude does not make the legal determination — but GitDude must raise the flag.

**Key deadlines to be aware of:**

| Regulation | Notification Deadline | To Whom |
|-----------|----------------------|---------|
| GDPR (EU) | 72 hours to authority; "without undue delay" to individuals if high risk | Supervisory authority + affected individuals |
| CCPA/CPRA (California) | "Most expedient time possible" | Affected residents + Attorney General if 500+ |
| HIPAA (US health) | 60 days | HHS + affected individuals + media if 500+ |
| PCI-DSS (payment) | Immediately | Payment brands + acquiring bank |

These deadlines start from when the organization becomes **aware** of the breach — not when it occurred. Delayed discovery extends the risk but does not extend the deadline.

### GitHub Auto-Revocation Partners

| Provider | Token Pattern | Auto-Revoked? |
|----------|-------------|---------------|
| AWS | `AKIA...` | Yes |
| Google Cloud | `AIza...` | Yes |
| Stripe | `sk_live_...` | Yes |
| Slack | `xoxb-...` | Yes |
| npm | `npm_...` | Yes |
| GitHub | `ghp_...`, `gho_...` | Yes |

Do not rely on auto-revocation. Always revoke manually as Step 1. Auto-revocation is a safety net, not the primary response.

### Finding the Exposure Window

```bash
# When was the secret first committed?
git log --all --oneline --diff-filter=A -- path/to/secret-file

# Search for the secret text in history
git log --all -p -S 'AKIAIOSFODNN7EXAMPLE' --source

# Which branches contain the contaminated commit?
git branch --contains <commit-sha>

# Which tags contain it?
git tag --contains <commit-sha>
```

---

## Post-Incident Remediation Checklist

After the immediate incident is resolved and the postmortem is complete, work through this checklist to harden against recurrence.

### Immediate Hardening (Within 48 Hours)

- [ ] **Rotate ALL credentials** that could have been exposed — not just the one that was found. Check for other secrets in the same file or directory.
- [ ] **Install pre-commit hooks** if not already present. Minimum: Gitleaks + detect-private-key.
- [ ] **Run full-repo scan** with `gitleaks detect --source . -v` and `pre-commit run --all-files` to find any other secrets that may be lurking.
- [ ] **Verify .gitignore** includes all sensitive file patterns (`.env*`, `*.pem`, `*.key`, `credentials.*`).
- [ ] **Confirm all team members** have re-cloned or force-reset their local copies.
- [ ] **Check forks** — contact fork owners to delete or update if repo was public.

### Systemic Prevention (Within 2 Weeks)

- [ ] **Add CI scanning** — Gitleaks in GitHub Actions or equivalent. Commit Gate should not be the only line of defense.
- [ ] **Enable push protection** if available (GitHub, GitLab). Blocks pushes containing detected secrets.
- [ ] **Review access controls** — remove unnecessary Write/Admin access. Audit token permissions.
- [ ] **Implement the Two-Gate System** if not already in place. Sync Gate + Commit Gate.
- [ ] **Update project setup documentation** to include hook installation as a required step.
- [ ] **Schedule a quarterly access review** if one is not already in place.

### Process Improvements (Within 30 Days)

- [ ] **Create or update rollback runbook** with exact commands for common scenarios.
- [ ] **Run a rollback drill** in staging to verify the procedure works.
- [ ] **Review and update file classification** — has anything changed since last classification?
- [ ] **Train team** on the Two-Gate System and why `git add .` is dangerous.
- [ ] **Track action items** from postmortem to completion. Assign owners and due dates.

---

## Blameless Postmortem

After the immediate incident is resolved, conduct a blameless postmortem within 48 hours. Goal: improve systems, not assign blame.

### Postmortem Template

```markdown
# Incident Postmortem: [Brief Title]

**Date of Incident:** YYYY-MM-DD
**Duration:** HH:MM (detection to resolution)
**Severity:** P1 / P2 / P3 / P4
**Author:** [Name]
**Status:** Draft / Reviewed / Final

---

## Summary
[2-3 sentences: what happened, impact, how resolved]

## Timeline (UTC)
| Time | Event |
|------|-------|
| HH:MM | [Triggering event] |
| HH:MM | [Detection] |
| HH:MM | [First response] |
| HH:MM | [Evidence preserved] |
| HH:MM | [Credential revoked/rotated] |
| HH:MM | [History rewritten (if applicable)] |
| HH:MM | [Team notified] |
| HH:MM | [Access audit completed] |
| HH:MM | [Regulatory assessment completed] |
| HH:MM | [Resolution confirmed] |

## Impact
- **Users affected:** [number or percentage]
- **Revenue impact:** [if applicable]
- **Data impact:** [any data loss or exposure]
- **Duration of user-facing impact:** [minutes/hours]
- **Regulatory implications:** [notification required? To whom? Deadline?]

## Root Cause
[Detailed technical explanation]

## Detection
[How detected? Could we have detected faster?]

## Resolution
[Step-by-step: what was done to fix it]

## Evidence Preserved
[What forensic evidence was captured before remediation?]

## What Went Well
- [Things that helped]

## What Went Wrong
- [Things that slowed response]

## Action Items
| Action | Owner | Priority | Due Date | Status |
|--------|-------|----------|----------|--------|
| [Specific action] | [Name] | P1/P2 | YYYY-MM-DD | Open |

## Lessons Learned
[What systemic improvements will prevent recurrence?]
```

### Five Whys Analysis

```
WHY did the secret end up in production?
  → Because it was committed to the repository.

WHY was it committed?
  → Because the developer hardcoded it for local testing.

WHY wasn't it caught before merge?
  → Because the pre-commit secret scan was not installed.

WHY wasn't the scan installed?
  → Because the project setup script does not include hook installation.

WHY doesn't the setup script include hooks?
  → Because there is no standardized project template with security hooks.

ROOT CAUSE: No standardized project template with built-in security hooks.
ACTION: Create a project template with Husky + Gitleaks pre-configured.
```

---

## Communication During Rollback

### Incident Severity Levels

| Level | Definition | Response Time | Communication |
|-------|-----------|---------------|---------------|
| P1 — Critical | Production down, data at risk, security breach | Immediate | All-hands, executive notification, status page |
| P2 — Major | Significant degradation, feature broken for many | < 30 min | Team alert, status page update |
| P3 — Minor | Minor feature broken, workaround exists | < 2 hours | Team channel notification |
| P4 — Low | Cosmetic issue, minor bug | Next business day | Normal issue tracking |

### Communication Checklist

```
## During Rollback:

Internal (Immediate)
- [ ] Engineering team channel: "Incident in progress, rollback initiated"
- [ ] On-call engineer / incident commander assigned
- [ ] Engineering manager aware (P1/P2)
- [ ] VP/CTO aware (P1 only)

External (Within SLA)
- [ ] Status page updated (P1/P2)
- [ ] Support team briefed with talking points
- [ ] Customer communication drafted (P1)

After Resolution
- [ ] Status page updated: "Resolved"
- [ ] Team channel: "Incident resolved, postmortem scheduled"
- [ ] Postmortem scheduled within 48 hours
- [ ] Action items tracked in issue tracker
- [ ] Regulatory notification sent (if required — see breach notification deadlines)
```

### Status Page Update Stages

1. **Investigating** — "We are investigating reports of..."
2. **Identified** — "We have identified the cause..."
3. **Monitoring** — "A fix has been deployed, we are monitoring..."
4. **Resolved** — "The issue has been resolved, incident report to follow."

### Communication Anti-Patterns

| Do Not | Instead |
|--------|---------|
| "We think it might be fixed" | "The fix has been deployed and is being monitored" |
| Blame individuals publicly | Use neutral language: "A configuration error was introduced" |
| Go silent for extended periods | Update every 30 minutes even if status has not changed |
| Share technical details with customers | Share impact and expected resolution time |
| Promise it will never happen again | Promise specific improvements |

---

## Rollback Testing

The worst time to test your rollback procedure is during a real incident.

### What to Validate After Rollback

| Check | Method | Expected Result |
|-------|--------|-----------------|
| Application starts | Health endpoint | HTTP 200 |
| Database compatibility | Migration status | No pending migrations blocking old version |
| API contracts | Smoke tests | All critical endpoints respond correctly |
| Background jobs | Job queue dashboard | No stuck or failing jobs |
| External integrations | Integration health checks | Webhooks, OAuth still functional |
| Feature flags | Flag state | Flags match rolled-back version expectations |

### Database Rollback Rules

1. Write backward-compatible migrations — add columns, never rename/remove in the same release.
2. Every migration must have a tested down/rollback path.
3. Separate deploy from migrate — deploy code first, run migrations second.
4. For blue-green deploys, ensure both versions can operate against the same database schema simultaneously.

---

## Daily Rules (GitDude)

1. **Tag every production deploy.** Without tagged releases, there is no reliable rollback target. Make tagging an automated step in your deployment pipeline.
2. **Revert, do not reset, on shared branches.** `git revert` for anything pushed to a shared remote. `git reset` only for local unpushed work.
3. **Revoke credentials before cleaning history.** The absolute first action when a secret leaks is to revoke or rotate the credential. An attacker with the secret can act in seconds; cleaning history takes minutes.
4. **Preserve evidence before rewriting history.** Capture exposure window, access logs, affected refs, and CI logs before git-filter-repo destroys the forensic record. You may need this for audit or regulatory compliance.
5. **Keep a rollback runbook.** Maintain a step-by-step rollback runbook in the repository or wiki. Include exact commands for: redeploy previous tag, revert last merge, rotate database credentials, update status page. Review and update it monthly.
6. **Practice rollbacks before you need them.** Run a monthly rollback drill in staging. Measure time-to-rollback, verify smoke tests pass, document gaps.
7. **Communicate early and often.** Update your team channel every 30 minutes during an incident minimum, even if there is nothing new to report. Silence causes panic.
8. **Write backward-compatible database migrations.** The number one obstacle to clean rollbacks is schema changes. Always make migrations additive.
9. **Conduct blameless postmortems within 48 hours.** Reconstruct the timeline, identify root cause with Five Whys, assign concrete action items with owners and due dates.
10. **Audit for unauthorized access after every secret leak.** Check the service's access logs for the entire exposure window. This step is frequently skipped.
11. **Assess breach notification obligations.** When a leaked secret granted access to personal data, determine whether regulatory notification is required. Escalate to Legal — do not make the legal determination yourself.
12. **Automate the rollback trigger.** If monitoring detects a critical health check failure after deploy, the rollback should start automatically or with a single button press. Target MTTR under 5 minutes.
13. **Complete the post-incident remediation checklist.** Rotate all related credentials, install hooks, run full-repo scan, verify .gitignore, confirm re-clones, check forks, add CI scanning, review access controls.

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
