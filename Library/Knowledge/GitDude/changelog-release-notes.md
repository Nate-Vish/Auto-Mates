# Changelog & Release Notes

**When to use:** Writing changelogs, creating GitHub Releases, writing migration guides, running release checklists, or setting up auto-generation tools.

---

## Keep a Changelog Format

The de facto standard. Changelogs are for humans, not machines. A git log dump is not a changelog.

### Standard Sections

Every version entry uses these categories (omit empty ones):

| Section | What Goes Here |
|---------|---------------|
| **Added** | New features or capabilities |
| **Changed** | Modifications to existing functionality |
| **Deprecated** | Features marked for future removal |
| **Removed** | Features that were deleted |
| **Fixed** | Bug fixes |
| **Security** | Vulnerability patches — always include CVE references |

### File Structure

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Dark mode support for dashboard

## [1.2.0] - 2026-02-15

### Added
- CSV export for all report types

### Fixed
- Fixed pagination bug on filtered results

### Security
- Updated libxml to patch CVE-2026-1234

## [1.1.0] - 2026-01-10

[Unreleased]: https://github.com/owner/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/owner/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/owner/repo/releases/tag/v1.1.0
```

**Key rules:**
- `[Unreleased]` section at top — developers add entries as they merge PRs
- When cutting a release: rename `[Unreleased]` to the new version + date, create fresh `[Unreleased]` above
- Date format: `YYYY-MM-DD` always. No exceptions.
- Comparison links at bottom — lets anyone click through to see exact code changes
- Yanked releases: `## [1.2.1] - 2026-02-20 [YANKED]`

---

## Changelog vs Release Notes

Maintain both. They serve different audiences.

| Aspect | Changelog (`CHANGELOG.md`) | Release Notes (GitHub Releases, blog) |
|--------|---------------------------|--------------------------------------|
| Audience | Developers, contributors | Users, stakeholders, management |
| Detail | Every notable change, technical | Highlights, summaries, user impact |
| Tone | Factual, terse | Approachable |
| Frequency | Every version | Major/minor (skip patches sometimes) |

### Writing Release Notes

```markdown
# v2.0.0 — "Project Codename"

## Highlights
- **Dark Mode:** Entire dashboard supports dark mode. Enable in Settings > Appearance.
- **50% faster search:** Rebuilt search index from scratch.

## Breaking Changes
- The `/api/v1/` endpoints have been removed. Migrate to `/api/v2/`.
  See the [Migration Guide](#migration-guide).

## New Features
- CSV export for all report types
- Keyboard shortcuts (press `?` to see the list)

## Bug Fixes
- Fixed race condition causing duplicate notifications

## Security
- Patched CVE-2026-5678 in image processing library

## Upgrade Instructions
1. Back up your database
2. Run `./migrate.sh` to update the schema
3. Restart all services
```

---

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Fix |
|-------------|-------------|-----|
| Dumping git log | Unreadable noise | Curate entries grouped by category |
| Empty changelog | Zero visibility | Maintain `[Unreleased]` continuously |
| Missing breaking changes | Code breaks with no warning | Dedicated "Breaking Changes" section always |
| Forgetting security fixes | Users don't know to upgrade | Always include "Security" with CVE refs |
| Internal jargon | "Fixed the frobnicator" means nothing | Write from the user's perspective |
| No dates | Can't tell when things happened | ISO 8601 on every version |
| No comparison links | Users can't see code diff | Add comparison links at bottom |

---

## Auto-Generation Tools

| Tool | Approach | When to Use |
|------|----------|-------------|
| **conventional-changelog** | Parses conventional commits | Simple, commit-based, single package |
| **release-please** (Google) | PR-based, bot updates changelog | Want human review before publishing |
| **changesets** | Developer adds changeset per PR | Monorepo; control over wording |
| **git-cliff** | Template-based, configurable | Highly custom formats |

```bash
# conventional-changelog
conventional-changelog -p angular -i CHANGELOG.md -s

# GitHub Release from tag
gh release create v1.2.0 --title "v1.2.0" --notes-file RELEASE_NOTES.md
gh release create v1.2.0 --generate-notes   # auto-generate from PR descriptions
```

---

## Release Checklist

Run on every release, no shortcuts.

```markdown
### Code Quality
- [ ] All CI checks pass (lint, test, build)
- [ ] No open critical or high-severity bugs
- [ ] Code coverage has not decreased

### Documentation
- [ ] CHANGELOG.md updated with all changes
- [ ] README.md reflects current state
- [ ] API documentation is current
- [ ] Migration guide written (if breaking changes)

### Legal & Compliance
- [ ] LICENSE file present and correct
- [ ] All dependencies have compatible licenses

### Security
- [ ] Dependency audit clean (npm audit / pip-audit)
- [ ] No secrets in codebase
- [ ] Security fixes documented with CVE references

### Artifacts
- [ ] Build artifacts generated and verified
- [ ] Package version numbers correct in all manifests

### Communication
- [ ] Release notes drafted
- [ ] Stakeholders notified of release timeline
```

### Go / No-Go Criteria

| Criterion | Go | No-Go |
|-----------|-----|-------|
| CI pipeline | All green | Any failure |
| Critical bugs | Zero open | One or more |
| Breaking changes | Documented + migration guide | Undocumented |
| Security vulns | All patched or risk accepted | Unpatched critical/high |
| Rollback plan | Documented and tested | Missing |

---

## Migration Guides

Required for any release with breaking changes.

**When required:** Removed endpoint, changed function signature, changed config format, dropped runtime version support, changed default behavior.

**Format:**
```markdown
# Migration Guide: v1.x to v2.0

## Overview
Most migrations complete in under 30 minutes.

## Breaking Changes Summary

| Change | Impact | Action Required |
|--------|--------|----------------|
| Removed /api/v1/ | All API consumers | Update base URL to /api/v2/ |
| YAML config only | JSON config users | Convert config.json to config.yaml |

## Step-by-Step Migration

### 1. Update API Endpoints

**Before (v1.x):** `curl https://api.example.com/v1/users`
**After (v2.0):** `curl https://api.example.com/v2/users`

## Deprecated Features (Removal Target: v3.0)
| Feature | Alternative |
|---------|-------------|
| /api/v2/legacy-search | /api/v2/search |
```

**Rules for migration guides:**
1. Always show before and after code examples
2. State the time estimate
3. List deprecated features with removal timeline
4. Test the migration yourself before publishing

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
