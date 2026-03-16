# Git Hooks & Enforcement

**When to use:** Setting up Husky, lint-staged, commitlint, secret scanning hooks, pre-push gates, or troubleshooting hook issues.

---

## Hook Types

### Client-Side (run on developer machine)

| Hook | Trigger | Can Block | Primary Use |
|------|---------|-----------|-------------|
| `pre-commit` | Before commit created | Yes | Lint, format, secret scan |
| `commit-msg` | After message written | Yes | Enforce conventional commit format |
| `pre-push` | Before push sends to remote | Yes | Run tests, type-check, block protected branches |
| `post-checkout` | After `git checkout` | No | Environment setup, install deps |
| `post-merge` | After merge completes | No | Reinstall dependencies |

### Server-Side (run on hosting platform)

| Hook | Trigger | Can Block |
|------|---------|-----------|
| `pre-receive` | Before any refs updated | Yes |
| `update` | Once per ref being updated | Yes |
| `post-receive` | After all refs updated | No |

**Client hooks can always be bypassed with `--no-verify`. Server hooks cannot.** Branch protection rules are the non-bypassable backstop.

---

## Husky v9 Setup (JavaScript/TypeScript)

```bash
npm install --save-dev husky lint-staged @commitlint/cli @commitlint/config-conventional
npx husky init

# Create hooks
echo "npx lint-staged\ngitleaks protect --staged --verbose" > .husky/pre-commit
echo 'npx --no -- commitlint --edit $1' > .husky/commit-msg
echo "npm run test:ci\nnpx tsc --noEmit" > .husky/pre-push
```

The `prepare` script (`"prepare": "husky"`) ensures hooks install automatically when anyone runs `npm install`. No manual setup required for new team members.

### Full Quick Setup

```bash
npm install --save-dev husky lint-staged @commitlint/cli @commitlint/config-conventional
npx husky init
echo "npx lint-staged\ngitleaks protect --staged --verbose" > .husky/pre-commit
echo 'npx --no -- commitlint --edit $1' > .husky/commit-msg
echo "npm run test:ci\nnpx tsc --noEmit" > .husky/pre-push
git add . && git commit -m "ci(hooks): add pre-commit, commit-msg, and pre-push hooks"
```

---

## lint-staged

Run linters ONLY on staged files. Keeps pre-commit fast.

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix --max-warnings=0",
      "prettier --write"
    ],
    "*.{css,scss}": ["prettier --write"],
    "*.{json,md,yml,yaml}": ["prettier --write"],
    "*.py": ["black", "ruff check --fix"]
  }
}
```

A hook that takes more than 10 seconds will be bypassed by frustrated developers. Speed is a feature of enforcement.

---

## Commitlint

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
    'subject-max-length': [2, 'always', 72],
    'type-case': [2, 'always', 'lower-case'],
    'scope-case': [2, 'always', 'lower-case'],
  },
};
```

**CI integration** (catch bypassed local hooks):
```yaml
# .github/workflows/commitlint.yml
- run: npx commitlint --from ${{ github.event.pull_request.base.sha }} --to ${{ github.event.pull_request.head.sha }} --verbose
```

---

## Secret Scanning in Hooks

Secret scanning is non-negotiable. One leaked credential costs more to remediate than a year of hook maintenance.

### Gitleaks (recommended — fast, runs in pre-commit)

```bash
brew install gitleaks

# .husky/pre-commit
npx lint-staged
gitleaks protect --staged --verbose
```

```toml
# .gitleaks.toml
[extend]
useDefault = true

[[rules]]
id = "custom-internal-token"
regex = '''int_token_[a-zA-Z0-9]{32}'''
tags = ["internal", "token"]

[allowlist]
paths = ['''.*_test\.go''', '''testdata/''']
```

### The pre-commit Framework (Python-Centric)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: detect-private-key
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: no-commit-to-branch
        args: ['--branch', 'main', '--branch', 'release']
      - id: check-merge-conflict
```

```bash
pre-commit install          # install hooks
pre-commit run --all-files  # run once on entire repo
pre-commit autoupdate       # update hook versions
```

---

## Pre-Push Gates

```bash
#!/bin/sh
# .husky/pre-push

PROTECTED_BRANCHES="^(main|master|production|release/.*)$"
CURRENT_BRANCH=$(git symbolic-ref HEAD | sed 's|refs/heads/||')

if echo "$CURRENT_BRANCH" | grep -qE "$PROTECTED_BRANCHES"; then
  echo "ERROR: Direct push to '$CURRENT_BRANCH' is not allowed."
  echo "Please create a pull request instead."
  exit 1
fi

npm run test:ci
```

---

## Lefthook (Alternative for Polyglot Repos)

Go-based, no Node.js required, runs hooks in parallel.

```yaml
# lefthook.yml
pre-commit:
  parallel: true
  commands:
    lint:
      glob: "*.{js,ts,jsx,tsx}"
      run: npx eslint --fix {staged_files} && git add {staged_files}
    secrets:
      run: gitleaks protect --staged --verbose
    python-lint:
      glob: "*.py"
      run: ruff check --fix {staged_files}

commit-msg:
  commands:
    commitlint:
      run: npx commitlint --edit {1}

pre-push:
  parallel: true
  commands:
    test:
      run: npm run test:ci
    typecheck:
      run: npx tsc --noEmit
```

Choose Lefthook for: polyglot monorepos, large teams where parallel execution matters, projects where adding Node.js as a dev dependency is undesirable.

---

## Bypassing Hooks

```bash
git commit --no-verify -m "emergency: reason documented"
git push --no-verify
```

**Policy:** Every `--no-verify` must be:
1. Documented in the PR description or incident report
2. Verbally approved by team lead (for production repos)
3. A temporary exception, not a habit

Frequent bypasses mean a hook is too strict or too slow — fix the hook, don't normalize bypassing.

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Hooks not running | `npm install` not run after setup | Run `npx husky install` or `npm install` |
| Permission denied | Hook file not executable | `chmod +x .husky/pre-commit` |
| Hook runs but doesn't block | Script exits 0 on failure | Check exit codes; add `set -e` |
| lint-staged runs on all files | Wrong glob pattern | Check `.lintstagedrc` patterns |
| Hooks slow on large repos | Running on all files | Use lint-staged (staged files only) |

---

## Distribute Hooks Through Package Manager

All hook configs belong in version control:
```
.husky/pre-commit    .husky/commit-msg    .husky/pre-push
.lintstagedrc.js     commitlint.config.js .gitleaks.toml
```

New developers clone the repo, run `npm install`, hooks are active. No manual setup.

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
