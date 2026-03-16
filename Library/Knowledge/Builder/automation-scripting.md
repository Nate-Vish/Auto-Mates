# Automation & Scripting
**When to use:** Read when writing shell scripts, Python automation, Node.js scripting, cron jobs, git hooks, or CI/CD task automation.

---

## Shell Scripts — Strict Mode Boilerplate

Every bash script starts with:

```bash
#!/usr/bin/env bash
set -euo pipefail
# -e: Exit on any command failure
# -u: Treat unset variables as errors
# -o pipefail: Pipe fails if any command in chain fails

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/script.log"
```

```bash
# Variables & constants
readonly APP_NAME="myapp"
db_host="${DB_HOST:-localhost}"       # Default values
db_port="${DB_PORT:-5432}"

# Functions with local variables
deploy() {
  local environment="$1"
  local version="${2:-latest}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deploying v${version} to ${environment}"
}

# Cleanup with trap
cleanup() {
  local exit_code=$?
  rm -rf "$tmp_dir"
  if [[ $exit_code -ne 0 ]]; then echo "ERROR: exit code ${exit_code}" >&2; fi
}
trap cleanup EXIT

# Retry function
retry() {
  local max_attempts="$1"; shift
  local attempt=1
  while (( attempt <= max_attempts )); do
    if "$@"; then return 0; fi
    echo "Attempt ${attempt}/${max_attempts} failed." >&2
    (( attempt++ )); sleep $(( attempt * 2 ))
  done
  return 1
}
retry 3 curl -sS https://api.example.com/health

main() { deploy "staging" "2.1.0"; }
main "$@"
```

**Tips:** Run `shellcheck script.sh` on every script. Keep scripts under 50 lines. Use `mktemp` for temp files.

---

## Python Automation

### File Operations
```python
from pathlib import Path
import shutil, json

project_dir = Path("/home/user/project")
data = json.loads((project_dir / "config.json").read_text())
(project_dir / "output.json").write_text(json.dumps(data, indent=2))

for log_file in project_dir.rglob("*.log"):
    print(f"Found log: {log_file}")

# Batch rename
for f in Path("images/").glob("*.jpeg"):
    f.rename(f.with_suffix(".jpg"))
```

### HTTP Requests
```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

session = requests.Session()
retry_strategy = Retry(total=3, backoff_factor=1, status_forcelist=[429, 500, 502, 503])
session.mount("https://", HTTPAdapter(max_retries=retry_strategy))

response = session.get("https://api.example.com/users", timeout=10)
response.raise_for_status()
users = response.json()
```

### Subprocess
```python
import subprocess

result = subprocess.run(["git", "status", "--short"], capture_output=True, text=True, check=True)
print(result.stdout)
```

---

## Node.js Scripting

```javascript
import { readFile, writeFile, readdir, mkdir, cp } from "node:fs/promises";
import { join, extname } from "node:path";
import { execSync } from "node:child_process";

// Read/write JSON
const data = JSON.parse(await readFile("config.json", "utf-8"));
data.version = "2.0.0";
await writeFile("config.json", JSON.stringify(data, null, 2));

// Shell commands
const branch = execSync("git branch --show-current", { encoding: "utf-8" }).trim();
```

### Google zx (Shell Scripting in JS)
```javascript
#!/usr/bin/env npx zx

const branch = (await $`git branch --show-current`).stdout.trim();
const files = (await $`git diff --name-only HEAD~1`).stdout.trim().split("\n");

// Parallel execution
await Promise.all([$`npm run lint`, $`npm run typecheck`]);

// Error handling
try {
  await $`npm test`;
} catch (error) {
  console.error(`Tests failed: ${error.exitCode}`);
  process.exit(1);
}
```

---

## Workflow Automation

### Makefile (Language-Agnostic Task Runner)
```makefile
.PHONY: dev build test lint deploy clean

APP_NAME := myapp
VERSION  := $(shell git describe --tags --always)

dev:
	docker compose up -d && npm run dev
build:
	docker build -t $(APP_NAME):$(VERSION) .
test:
	npm run test:unit && npm run test:integration
deploy: build test
	docker push $(APP_NAME):$(VERSION)
	kubectl set image deployment/app app=$(APP_NAME):$(VERSION)
```

### npm Scripts
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "typecheck": "tsc --noEmit",
    "test:ci": "vitest run --coverage",
    "db:migrate": "prisma migrate deploy",
    "db:seed": "tsx prisma/seed.ts",
    "prebuild": "npm run lint && npm run typecheck",
    "postinstall": "prisma generate"
  }
}
```

---

## Cron Jobs & Scheduling

```bash
# Crontab syntax: min hour day month weekday
0 3 * * *     /home/user/scripts/backup.sh     # Every day at 3 AM
*/15 * * * *  /home/user/scripts/health.sh     # Every 15 minutes
0 9 * * 1-5   /home/user/scripts/daily.sh      # Monday-Friday at 9 AM

crontab -e   # Edit crontab
crontab -l   # List cron jobs
```

```javascript
// node-cron — in-process scheduling
import cron from "node-cron";
cron.schedule("0 0 * * *", async () => { await cleanupExpiredSessions(); });
```

Cloud scheduling: AWS EventBridge, GCP Cloud Scheduler, Azure Logic Apps.

---

## Git Hooks

| Hook | Common Use |
|------|-----------|
| **pre-commit** | Lint, format staged files (lint-staged) |
| **commit-msg** | Validate commit message format (commitlint) |
| **pre-push** | Run full test suite |
| **post-merge** | Auto-install if lockfile changed |

### Husky + lint-staged
```json
// package.json
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md,yml}": ["prettier --write"]
  }
}
```

```bash
# .husky/pre-commit
npx lint-staged

# .husky/commit-msg (with commitlint)
npx --no -- commitlint --edit "$1"
```

```javascript
// commitlint.config.js
export default { extends: ["@commitlint/config-conventional"] };
// Enforces: feat(auth): add OAuth2 login | fix(api): handle null response
```

---

## Database Automation

```bash
# Prisma migrations
npx prisma migrate dev --name add_user_roles   # Dev
npx prisma migrate deploy                       # Production
```

```typescript
// Seed script — always idempotent (use upsert)
await prisma.user.upsert({
  where: { email: "admin@example.com" },
  update: {},
  create: { email: "admin@example.com", name: "Admin", role: "ADMIN" },
});
```

```bash
# Backup script
pg_dump "$DB_NAME" | gzip > "${BACKUP_DIR}/${DB_NAME}_$(date +%Y%m%d).sql.gz"
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +30 -delete
```

---

## Notification Automation

```typescript
// Slack
async function notifySlack(message: string) {
  await fetch(process.env.SLACK_WEBHOOK_URL!, {
    method: "POST", headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ text: message, channel: "#deployments" }),
  });
}
await notifySlack(`:white_check_mark: *v${version}* deployed to production`);

// Email with Resend
const resend = new Resend(process.env.RESEND_API_KEY);
await resend.emails.send({
  from: "App <notifications@yourdomain.com>",
  to: ["user@example.com"],
  subject: "Deployment Complete",
  html: `<p>Version <strong>${version}</strong> deployed to production.</p>`,
});
```

---

## Web Scraping (Ethical)

```javascript
// Playwright — preferred for 2026
import { chromium } from "playwright";
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();
await page.goto("https://example.com/products", { waitUntil: "networkidle" });
const products = await page.$$eval(".product-card", cards =>
  cards.map(card => ({ name: card.querySelector("h2")?.textContent?.trim() }))
);
await browser.close();
```

**Ethical rules:** Check robots.txt. Add 1-3 second delays. Never scrape PII. Set User-Agent header.

---

## Daily Rules

1. Automate repetitive tasks — if you do it more than twice, script it
2. Strict mode in every script — `set -euo pipefail`, proper error codes
3. Git hooks are your first quality gate — lint on pre-commit, tests on pre-push
4. Makefile (or npm scripts) as universal entry point — document all common commands
5. Database migrations are code — never modify production schemas manually; make seeds idempotent
6. Use right tool for scheduling: system cron for OS tasks, node-cron for app jobs, cloud schedulers for serverless
7. Notify on outcomes, not activities — deploy completions, failures, review requests
8. Keep all scripts in the repo (`scripts/`, `tools/`) — version-controlled, documented
