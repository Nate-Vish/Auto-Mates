# Versioning Strategies

**When to use:** Choosing a versioning scheme, bumping a version, setting up automated release tools, working with lockfiles, or managing monorepo package versions.

---

## Semantic Versioning (SemVer)

Default choice for libraries, APIs, and most software projects.

```
MAJOR.MINOR.PATCH

Bug fix only                          → PATCH  (1.4.2 → 1.4.3)
New feature, backward compatible      → MINOR  (1.4.2 → 1.5.0)
Breaking change                       → MAJOR  (1.4.2 → 2.0.0)
```

| Component | Increment When | Promise to Consumers |
|-----------|---------------|---------------------|
| MAJOR | Incompatible API changes | "Your code may break. Read the migration guide." |
| MINOR | New backwards-compatible features | "New features available. Existing code still works." |
| PATCH | Bug fixes only | "Bugs fixed. Nothing else changed." |

### Pre-1.0 Rule
`0.x.y` means "API is unstable, anything goes." Don't stay here indefinitely — it signals immaturity and discourages adoption. Release `1.0.0` when the API is stable enough for external users.

### Pre-Release Versions
```
2.0.0-alpha.1  → Early testing, features incomplete (breaking changes OK)
2.0.0-beta.1   → Feature complete, bugs expected (no new features)
2.0.0-rc.1     → Release candidate, believed ready (critical fixes only)
2.0.0          → Stable release
```

### Version Decision Matrix
```
Did you make a breaking API change?
├── YES → MAJOR (even if the change is small)
└── NO  → Did you add new public functionality?
           ├── YES → MINOR
           └── NO  → Did you fix a bug?
                      ├── YES → PATCH
                      └── NO  → No bump needed (docs, CI, refactor)
```

**Tricky cases:**
- Fixed a bug people depended on → MAJOR (or MINOR + deprecation notice)
- Added a required field to config → MAJOR (existing configs break)
- Added optional parameter → MINOR (existing calls still work)
- Changed default behavior → MAJOR (existing code behaves differently)

---

## Calendar Versioning (CalVer)

Use when release date communicates more than content.

| Format | Example | Used By |
|--------|---------|---------|
| `YYYY.MM.DD` | `2026.03.12` | Daily releases, data packages |
| `YY.MM` | `26.03` | Ubuntu (24.04 LTS) |
| `YYYY.MINOR` | `2026.1` | pip, Spring Cloud |

**Use CalVer for:** Applications and platforms on fixed schedules.
**Use SemVer for:** Libraries with a public API that consumers depend on.

---

## Auto-Bumping Tools

| Tool | Automation | Monorepo | Choose When |
|------|-----------|----------|-------------|
| **semantic-release** | Fully automated | Limited | Team trusts commit discipline, wants hands-off |
| **release-please** | PR-based (human review) | Yes (manifest) | Team wants to review/edit release notes before publishing |
| **changesets** | Developer-driven per PR | Yes (native) | Monorepo; explicit control over changelog wording |
| **standard-version** | Semi-automated | No | Simple single-package projects |

### The Commit-to-Version Pipeline

```
Conventional commit pushed to main
    → Analyze commits since last tag (feat=MINOR, fix=PATCH, BREAKING=MAJOR)
    → Determine new version
    → Generate CHANGELOG.md
    → Update version files (package.json, pyproject.toml, etc.)
    → Commit version bump ("chore(release): 1.5.0 [skip ci]")
    → Create annotated git tag (v1.5.0)
    → Create GitHub Release with changelog
    → Publish package (npm, PyPI, etc.)
```

---

## Lockfiles

Lockfiles record exact versions + integrity hashes of every dependency. They are essential for reproducible builds.

**Always commit lockfiles. Always.**

| Package Manager | Lockfile | CI Command |
|----------------|----------|------------|
| npm | `package-lock.json` | `npm ci` |
| Yarn Classic | `yarn.lock` | `yarn install --frozen-lockfile` |
| Yarn Berry | `yarn.lock` | `yarn install --immutable` |
| pnpm | `pnpm-lock.yaml` | `pnpm install --frozen-lockfile` |
| pip | `requirements.txt` (pinned) | `pip install --require-hashes -r requirements.txt` |
| Poetry | `poetry.lock` | `poetry install --no-interaction` |
| Go | `go.sum` | `go mod download` |
| Rust | `Cargo.lock` | `cargo build --locked` |

**Rules:**
- `npm ci` in CI — never `npm install` (install may update lockfile)
- Never manually edit lockfiles (machine-generated)
- Review lockfile diffs in PRs — unexpected changes = potential supply chain issue
- Floating versions (`^` or `~`) in package.json are fine; the lockfile pins them

---

## Version Range Syntax (npm)

| Syntax | Resolves To |
|--------|------------|
| `4.17.21` | Exact version only |
| `^4.17.0` | `>=4.17.0 <5.0.0` (caret = MINOR+PATCH) |
| `~4.17.0` | `>=4.17.0 <4.18.0` (tilde = PATCH only) |
| `*` | Any version — never use in production |

---

## Version File Locations

| Ecosystem | File | Field |
|-----------|------|-------|
| Node.js | `package.json` | `"version"` |
| Python (modern) | `pyproject.toml` | `[project] version` |
| Python (legacy) | `__init__.py` | `__version__` |
| Rust | `Cargo.toml` | `[package] version` |
| Java (Maven) | `pom.xml` | `<version>` |
| Go | `go.mod` + git tags | module path |
| Generic | `VERSION` | entire file |

**Single source of truth:** Keep version in exactly one place (prefer git tags). Derive all other references from that single source.

---

## Monorepo Versioning

| Strategy | How It Works | Best For |
|----------|-------------|----------|
| Independent | Each package versions separately | Loosely coupled packages |
| Fixed/Locked | All packages share one version | Tightly coupled frameworks |

**Changesets workflow for monorepos:**
```bash
npx changeset      # Developer creates a changeset file describing the change
npx changeset version   # At release time: bumps versions + updates CHANGELOGs
npx changeset publish   # Publishes each changed package
```

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
