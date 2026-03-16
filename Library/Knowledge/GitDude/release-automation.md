# Release Automation & Platform Features

**When to use:** Setting up GitHub Actions release pipelines, configuring protected branches, managing CODEOWNERS, creating PR templates, setting up tag-triggered workflows, or implementing progressive delivery.

---

## Tag-Triggered Release Workflow

The standard pattern: push a tag, the pipeline does the rest.

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ["v*.*.*"]

permissions:
  contents: write
  packages: write

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20, 22]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: ${{ matrix.node-version }}, cache: "npm" }
      - run: npm ci && npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: "npm" }
      - run: npm ci && npm run build
      - uses: actions/upload-artifact@v4
        with: { name: dist, path: dist/, retention-days: 30 }

  publish:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, registry-url: "https://registry.npmjs.org" }
      - run: npm ci && npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}

  github-release:
    needs: [build, publish]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with: { name: dist, path: dist/ }
      - run: |
          gh release create "${{ github.ref_name }}" \
            --title "Release ${GITHUB_REF#refs/tags/v}" \
            --generate-notes \
            dist/*
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## release-please vs semantic-release

| Aspect | release-please | semantic-release |
|--------|---------------|-----------------|
| Trigger | Merging the Release PR | Every qualifying push to main |
| Human review | Yes (PR-based, editable) | No (fully automated) |
| Risk | Low | Higher (requires commit discipline) |
| Monorepo | Native manifest mode | Via plugins |

**When to use release-please:** Team wants human review of release content before publishing.
**When to use semantic-release:** Team fully trusts commit conventions and wants zero manual steps.

Never mix both on the same project.

---

## Protected Branches Configuration

```bash
gh api repos/{owner}/{repo}/branches/main/protection --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["test","lint","build"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field allow_force_pushes=false \
  --field allow_deletions=false
```

| Rule | Purpose | Recommendation |
|------|---------|---------------|
| Require PR reviews | No direct pushes | 1-2 reviewers minimum |
| Dismiss stale reviews | Re-review after new pushes | Always enable |
| Require status checks | CI must pass | All critical checks |
| Require up-to-date branch | No stale merges | Enable for main |
| No force push | Prevent history rewriting | Always on main |
| Require linear history | Clean history | Recommended |
| Require signed commits | Verify authorship | Enable for high-security repos |

---

## CODEOWNERS

Maps file patterns to required reviewers. Enforces domain expertise.

```bash
# .github/CODEOWNERS

# Default owner for everything
*                           @org/engineering-leads

# Frontend
/src/web/                   @org/frontend-team

# Security-sensitive paths
/src/auth/                  @org/security-team

# CI/CD — release manager and devops must review
/.github/workflows/         @org/devops @release-manager

# Release files — release manager must approve
/package.json               @release-manager
/CHANGELOG.md               @release-manager
/.releaserc.json            @release-manager

# Database migrations — DBA approval required
/migrations/                @dba-lead @org/backend-team
```

**Rule:** Later rules override earlier ones. More specific paths take precedence.
**Update CODEOWNERS when directories are added or ownership changes — same day.**

---

## PR Templates

```markdown
<!-- .github/pull_request_template.md -->
## Description

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation / Refactoring / CI

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] New tests added for new functionality

## Checklist
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md entry added under `[Unreleased]`
- [ ] No new warnings generated

## Related Issues
<!-- Fixes #123, Relates to #456 -->
```

Multiple templates: place in `.github/PULL_REQUEST_TEMPLATE/` (feature.md, bugfix.md, release.md, hotfix.md)

---

## Tag Management

```bash
# Annotated tag (for releases — always)
git tag -a v1.2.0 -m "Release v1.2.0 — CSV export and performance improvements"
git push origin v1.2.0

# Tag a specific commit
git tag -a v1.2.0 abc123f -m "Release v1.2.0"

# List tags with dates
git tag -l --format='%(refname:short) %(creatordate:short) %(subject)'

# Push all tags
git push origin --tags
```

**Tag Safety Rules:**
1. Never move a pushed tag — users may have pulled it. Create a new version instead.
2. Always use annotated tags for releases (stores tagger identity and date)
3. Sign release tags: `git tag -s v1.2.0 -m "msg"`
4. Protect tags in GitHub settings to prevent unauthorized creation/deletion

---

## Docker Tag Conventions

| Tag | Stability | Example |
|-----|-----------|---------|
| `myapp:1.2.3` | Immutable | Exact version, pin this for stability |
| `myapp:1.2` | Mutable | Latest patch for this minor |
| `myapp:1` | Mutable | Latest minor for this major |
| `myapp:latest` | Mutable | Current stable release |
| `myapp:a1b2c3d` | Immutable | Exact build SHA |

Always push both the immutable exact tag AND convenience tags.

---

## Progressive Delivery

Decouple deployment from release. Code reaches production but is exposed gradually.

| Strategy | How | Rollback |
|----------|-----|----------|
| Feature flags | Toggle per user/group | Instant (flip the flag) |
| Canary | Route small % of traffic to new version | Fast (remove canary) |
| Blue-green | Two environments, swap traffic | Fast (point DNS back) |
| Rolling | Gradually replace old instances | Medium |

**Progressive delivery checklist:**
1. Deploy behind feature flag (off) → feature invisible
2. Enable for internal team → internal testing
3. Enable for 5% of users → watch metrics
4. Expand to 25%, 50%, 100% → monitor each step
5. Remove feature flag code → clean up technical debt

**Every release should have an instant rollback path.** Test it before you need it.

---

## Post-Deployment Protocol

After go-live the release isn't done — it's entering observation:
1. **Monitor for 30 minutes** — watch error rates, latency, CPU/memory vs pre-deploy baseline
2. **Announce completion** — notify the team
3. **Watch for 24 hours** — some issues only appear under real traffic (time zones, batch jobs)
4. **Close the release** — update changelog status, tag as stable

If anything looks wrong: rollback first, investigate second.

---

## DORA Metrics

Track these over time to measure release process health.

| Metric | Elite | Low | What It Measures |
|--------|-------|-----|-----------------|
| Deployment Frequency | Multiple/day | < 1/month | How often you ship |
| Lead Time for Changes | < 1 hour | > 6 months | Commit to production time |
| Mean Time to Recovery | < 1 hour | > 6 months | Recovery speed from failures |
| Change Failure Rate | 0-15% | 46-60% | % deployments causing failures |

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
