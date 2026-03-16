# Conventional Commits & Commit Standards

**When to use:** Enforcing commit message standards, setting up commitlint, reviewing commit history quality, understanding how commits drive automation, or writing/reviewing commit messages.

---

## The Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Concrete example:**
```
feat(auth): add OAuth2 login with Google provider

Implements the full OAuth2 authorization code flow for Google.
Users can now sign in with their Google account instead of
creating a local password. Session tokens are stored as
HTTP-only cookies with a 24-hour expiry.

Closes #142
Co-authored-by: Bob <bob@example.com>
```

---

## Commit Types

| Type | Purpose | SemVer Bump |
|------|---------|-------------|
| `feat` | New feature visible to users | MINOR |
| `fix` | Bug fix visible to users | PATCH |
| `docs` | Documentation only | No bump |
| `style` | Formatting, whitespace | No bump |
| `refactor` | Code change, not a fix or feature | No bump |
| `perf` | Performance improvement | PATCH (configurable) |
| `test` | Tests only | No bump |
| `build` | Build system or dependencies | No bump |
| `ci` | CI configuration changes | No bump |
| `chore` | Maintenance, no production code | No bump |
| `revert` | Reverts a previous commit | Depends |

**Breaking changes** trigger MAJOR bump. Signal with `!` after type, or `BREAKING CHANGE:` footer:
```
feat(api)!: change authentication endpoint response format

BREAKING CHANGE: The /auth/login endpoint now returns { token, expires_at }
instead of a plain token string. Clients must update response parsing.
```

---

## Subject Line Rules

```
feat(auth): add OAuth2 login with Google provider
^    ^      ^
|    |      +-- imperative mood, lowercase, no period, max 72 chars
|    +--------- scope: optional, lowercase, in parentheses
+-------------- type: required, lowercase
```

| Rule | Good | Bad |
|------|------|-----|
| Imperative mood | `add user validation` | `added user validation` |
| Lowercase start | `fix null pointer` | `Fix null pointer` |
| No period | `update dependencies` | `update dependencies.` |
| Max 72 chars | keep it concise | don't write a paragraph |
| WHAT, not HOW | `support IPv6 addresses` | `use regex to parse IPv6` |

**The test:** "If applied, this commit will **[subject line]**."

---

## Bad Commits to Reject

| Bad | What's Wrong | Rewrite As |
|-----|-------------|------------|
| `fixed stuff` | No type, no scope, no context | `fix(auth): prevent session timeout on idle` |
| `wip` | Not a complete unit of work | `feat(search): add partial query matching (WIP)` |
| `update` | Update what? Why? | `build(deps): update lodash to 4.17.21 for CVE fix` |
| `fix bug` | Which bug? | `fix(checkout): correct total when coupon applied twice` |
| `changes` | Every commit is changes | `refactor(db): normalize user address into separate table` |
| `PR feedback` | Describes process, not change | `style(components): rename props per review guidelines` |
| `Monday work` | Describes when, not what | `feat(dashboard): add weekly revenue chart` |

---

## The Value Chain

```
Conventional Commits
        |
        v
Determine version bump    →    Generate CHANGELOG    →    Auto-publish release
(feat=MINOR, fix=PATCH,        (grouped by type,           (tag, package,
 BREAKING=MAJOR)                linked to issues)            deploy)
```

Without structured commits, release automation is impossible.

---

## Commitlint Setup

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
npm install --save-dev husky
npx husky init
echo 'npx --no -- commitlint --edit "$1"' > .husky/commit-msg
```

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert',
    ]],
    'subject-empty': [2, 'never'],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-full-stop': [2, 'never', '.'],
    'header-max-length': [2, 'always', 72],
    'type-case': [2, 'always', 'lower-case'],
    'scope-case': [2, 'always', 'lower-case'],
  },
};
```

**CI integration** (catch bypassed local hooks):
```yaml
- run: npx commitlint --from ${{ github.event.pull_request.base.sha }} --to ${{ github.event.pull_request.head.sha }} --verbose
```

---

## Squash vs Keep Individual Commits

| Squash | Keep Separate |
|--------|---------------|
| Multiple WIP commits | Logically distinct changes |
| Fix-then-fix-the-fix chain | Refactor then feature |
| Typo fixes after a feature | Multiple bug fixes referencing different issues |
| 20+ tiny commits in one PR | Migration then code change |

```bash
# Clean up before PR
git rebase -i HEAD~5
# Reword, squash, fixup, drop as needed
git push --force-with-lease origin feature/my-branch
```

---

## Signing Commits

Signed commits prove authenticity. Prevents impersonation and supply chain attacks.

```bash
# SSH signing (simpler)
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true

# GPG signing (traditional)
git config --global user.signingkey ABC123DEF456
git config --global commit.gpgsign true
```

```bash
# Signed tags for releases
git tag -s v1.0.0 -m "Release v1.0.0"
```

---

## Co-authored Commits

```
feat(search): implement full-text search with ranking

Co-authored-by: Alice Chen <alice@example.com>
Co-authored-by: Claude <noreply@anthropic.com>
```

Use for pair programming, mob sessions, and significant review contributions.

---

## Commit Hygiene Checklist

Before pushing:
- [ ] Every commit has a valid conventional type
- [ ] Subject lines are under 72 characters and use imperative mood
- [ ] Body explains WHY (if non-obvious)
- [ ] Breaking changes have `BREAKING CHANGE:` footer
- [ ] Related issues are referenced in footers
- [ ] No WIP or temp commits remain
- [ ] Co-authors properly attributed
- [ ] Commits signed (if required)
- [ ] Each commit compiles and passes tests independently

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
