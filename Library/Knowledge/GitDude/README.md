# GitDude Knowledge Section

*Last updated: 2026-02-25*

## Our Version Control System (Read First)

This is how version control works in AutoMates. Follow this exactly.

### Repository Structure

```
Dashboard/Version_Control/
└── AutoMates/          ← .git lives here. This is the repo root.
    ├── .git/           ← The database. Stores ALL versions internally.
    ├── CLAUDE.md       ← Latest version of every file sits at root
    ├── README.md
    ├── CHANGELOG.md
    ├── AgenTeam/
    ├── Library/
    ├── .claude/
    └── ...             ← All files = current (latest) version
```

- **Repo root = latest version.** Every file at root is the newest release.
- **Old versions = git tags.** `git checkout v1.0` shows v1.0. `git checkout main` shows latest.
- **NEVER create version subfolders** (v1.0/, v1.1/, etc.). That's what git tags do.
- **One folder, many versions.** The `.git/` directory stores everything internally.

### Where Things Live

| Location | Purpose | Has .git? |
|----------|---------|-----------|
| `Dashboard/Work_Space/` | Building — active development | NO |
| `Dashboard/Version_Control/AutoMates/` | Shipping — the GitHub repo | YES |
| `Dashboard/Version_Control/FinCat/` | Shipping — separate GitHub repo | YES |
| `Dashboard/Shipyard/` | Shipped products archive | NO |

- `.git` lives ONLY in `Version_Control/[Product]/`. Never in Work_Space, never in root.
- Each product has its own folder and its own `.git` connected to its own GitHub repo.
- Work_Space is for building. Version_Control is for shipping.

### How to Release a Version

1. **Copy live files to repo root** — `rsync` or `cp` from live system to `Version_Control/AutoMates/`
2. **Security scan** — grep the diff for API keys, secrets, passwords, tokens (see Sensitive Data Patterns below)
3. **Check for coordination files** — look for `MESSAGE_FROM_*`, `HANDOFF_*` from other agents
4. **Stage and commit** — `git add` changed files, write descriptive commit message
5. **Tag** — `git tag -a v1.X -m "description"` (annotated tags only)
6. **Push** — `git push origin main && git push origin v1.X`
7. **Verify** — `git status`, `git log --oneline -3`, `git tag -l`

### Versioning: Semantic Versioning (SemVer)

Format: **vMAJOR.MINOR.PATCH**

| Increment | When | Example |
|-----------|------|---------|
| MAJOR | Breaking changes — old setup won't work | v1.0 → v2.0 |
| MINOR | New features, backward compatible | v1.0 → v1.1 |
| PATCH | Bug fixes, small improvements | v1.1.0 → v1.1.1 |

Current tags: v1.0 → v1.1 → v1.3 (v1.2 was deleted — pointed to a cosmetic commit, not real content).

### Live vs Committed: The Staleness Problem

The live system (`Auto-Mates.AI/`) evolves constantly as agents work. The repo (`Version_Control/AutoMates/`) is a snapshot. **They diverge within hours.**

To sync: copy live → repo, commit, push. Always sync from live (the truth) to repo (the snapshot), never the other way around.

When updating the repo tag after a sync:
```bash
git tag -d v1.X                        # delete old local tag
git push origin --delete v1.X          # delete old remote tag
git tag -a v1.X -m "description"       # create new tag at HEAD
git push origin v1.X                   # push new tag
```

### What Gets Committed vs What Doesn't

**Committed (public on GitHub):**
- Agent identity files (`AgenTeam/*/`, `Library/Fetcher/`)
- CLAUDE.md, README.md, CHANGELOG.md
- Skills (`.claude/skills/`)
- Knowledge READMEs (`Library/Knowledge/`)
- Rules.md, summon.sh, settings
- Folder structure and templates

**Never committed:**
- `.env` files — secrets stay local
- `MESSAGE_FROM_*.md` — internal agent coordination
- `.DS_Store` — macOS junk
- `Library/Sources/` — research cache, user-specific
- `Memory_Logs/` content — sessions, notes (templates OK, content private)
- Anything in `Work_Space/` — that's for building, not shipping

### Commit Message Style

Look at recent commits for style consistency:
```
v1.3 — Native Claude Code integration
Fix GitDude identity: no version subfolders, use git tags
Sync v1.3 with live system: identities, knowledge, handoff
```

Pattern: short subject line describing the "what" and "why". Multi-line body for details when needed. Always end with `Co-Authored-By: Claude <noreply@anthropic.com>`.

---

## Sensitive Data Patterns (Pre-Commit Scanning)

Scan every diff before committing. Block if any match.

### API Keys & Tokens
- `api_key`, `apikey`, `API_KEY`, `secret_key`, `SECRET_KEY`
- `access_token`, `bearer_token`, `auth_token`
- Prefixes: `sk_live_`, `pk_live_`, `sk_test_`, `AIza`, `ghp_`, `gho_`

### Credentials
- `password`, `passwd`, `PASSWORD`
- Database connection strings with embedded passwords
- SSH private keys (`BEGIN RSA PRIVATE KEY`, `BEGIN OPENSSH PRIVATE KEY`)
- OAuth client secrets

### Files That Should Never Be Committed
- `.env`, `.env.local`, `.env.production`
- `credentials.json`, `serviceAccountKey.json`
- `*.pem`, `*.key` (private keys)
- Database dumps, log files with user data

### GitHub Will Block You
GitHub's own secret scanning catches real-looking keys. Even example keys in docs can trigger it. Use obviously fake patterns: `sk_live_EXAMPLE_KEY_DO_NOT_USE_1234567890`.

---

## Shell Scripting (For Release Scripts)
- [Bash Scripting Cheatsheet](../Sources/bash/bash_scripting_cheatsheet.md) — Fundamentals
- [Google Shell Style Guide](../Sources/bash/google_shell_style_guide.md) — Industry standard
- [Bash Version Compatibility](../Sources/bash/bash_version_compatibility.md) — Bash 3.2 vs 4.0
- [Cross-Platform Shell](../Sources/bash/cross_platform_shell.md) — POSIX compliance
- [ShellCheck Guide](../Sources/bash/shellcheck_guide.md) — Script validation

## Security References
- [Bash Pitfalls & Security](../Sources/bash/bash_pitfalls_security.md) — Script vulnerabilities
- [OWASP Top 10 LLM](../Sources/Legal/Liability/owasp_top_10_llm_applications.md) — Security risks
- [Vibe Coding Security Risks](../Sources/trends/vibe_coding_security_risks.md) — 45% vulnerability rate

## Claude Code Reference
- [Claude Code CLI Reference](../Sources/claude-code/cli_reference.md) — CLI flags
- [Claude Code Custom Skills](../Sources/claude-code/custom-skills.md) — Skill system

## Open Source & Licensing
- [Open Source AI Disclaimers](../Sources/Legal/Liability/open_source_ai_liability_disclaimers.md) — MIT/Apache warranty
- [US Copyright Office AI](../Sources/Legal/Copyright/us_copyright_office_ai_initiative.md) — AI authorship

---
*Request Fetcher to add sources when you identify knowledge gaps.*
