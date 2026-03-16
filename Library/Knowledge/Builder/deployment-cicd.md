# Deployment & CI/CD
**When to use:** Read when setting up CI pipelines, deploying to hosting platforms, configuring environment variables, or implementing rollback strategies.

---

## The Standard Build Pipeline

```
lint → type-check → test → build → deploy
```

| Stage | Command | Purpose |
|-------|---------|---------|
| Lint | `npx eslint src/` | Catch style/quality issues |
| Type Check | `npx tsc --noEmit` | Catch type errors |
| Test | `npm test` / `npx vitest` | Catch logic errors |
| Build | `npm run build` | Create production bundle |
| Deploy | Platform-specific | Ship to production |

**Key insight:** Vite and esbuild do NOT type-check. They only transpile TypeScript. Run `tsc --noEmit` separately in CI.

---

## Static Site / SPA Hosting Platforms

| Feature | Cloudflare Pages | Vercel | Netlify | GitHub Pages |
|---------|-----------------|--------|---------|-------------|
| Auto-deploy from Git | Yes | Yes | Yes | Yes |
| Preview deployments | Yes (per PR) | Yes (per PR) | Yes (per PR) | No |
| Edge functions | Workers | Edge Runtime | Edge Functions | No |
| Free tier bandwidth | Unlimited | 100GB/month | 100GB/month | 100GB/month |
| Custom domains + SSL | Yes | Yes | Yes | Yes |

### General Setup Pattern
1. Connect GitHub/GitLab repo
2. Configure build settings:
   - Build command: `npm run build`
   - Output directory: `dist` (Vite), `build` (CRA), `out` (Next.js static)
   - Node version: via `.node-version` file or env var
3. Every push to `main` triggers auto-deploy
4. Every PR gets a preview deployment (unique URL)

### Redirects & Security Headers
```
# public/_redirects (Cloudflare/Netlify)
/old-page  /new-page  301
/*         /index.html  200    # SPA fallback

# public/_headers (Cloudflare/Netlify)
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Content-Security-Policy: default-src 'self'
```

### Serverless Functions
```typescript
// Cloudflare Pages — functions/api/hello.ts
export const onRequestGet: PagesFunction = async (context) => {
  return new Response(JSON.stringify({ message: "Hello" }));
};

// Vercel — api/hello.ts
import type { VercelRequest, VercelResponse } from "@vercel/node";
export default function handler(req: VercelRequest, res: VercelResponse) {
  res.status(200).json({ message: "Hello" });
}

// Netlify — netlify/functions/hello.ts
export const handler = async () => ({
  statusCode: 200,
  body: JSON.stringify({ message: "Hello" }),
});
```

---

## GitHub Actions — CI/CD Pipelines

### Basic Workflow
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: "npm"

      - run: npm ci              # Clean install (deterministic)
      - run: npx tsc --noEmit    # Type check
      - run: npm run lint
      - run: npm test
      - run: npm run build

      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/
```

### Common Actions
| Action | Purpose |
|--------|---------|
| `actions/checkout@v4` | Clone repo |
| `actions/setup-node@v4` | Install Node.js with caching |
| `actions/cache@v4` | Cache dependencies, build outputs |
| `actions/upload-artifact@v4` | Save build artifacts |

### Secrets
```yaml
# Set in GitHub → Settings → Secrets → Actions
env:
  API_KEY: ${{ secrets.API_KEY }}
# NEVER echo secrets in logs
```

---

## Environment Management

### .env File Hierarchy
```bash
# .env                   — default values (committed — no secrets!)
# .env.local             — local overrides (gitignored)
# .env.development       — dev-only values
# .env.production        — prod-only values
# .env.development.local — local dev overrides (gitignored)

# Priority: .env.local > .env.[mode].local > .env.[mode] > .env
```

### Build-Tool Env Var Prefixes
| Build Tool | Client-Exposed Prefix | Access Pattern |
|-----------|----------------------|----------------|
| Vite | `VITE_` | `import.meta.env.VITE_*` |
| Create React App | `REACT_APP_` | `process.env.REACT_APP_*` |
| Next.js | `NEXT_PUBLIC_` | `process.env.NEXT_PUBLIC_*` |
| Nuxt | `NUXT_PUBLIC_` | `useRuntimeConfig().public.*` |

**Critical rule:** Only prefixed vars reach the client — they're bundled into JavaScript. NEVER put secrets in client-exposed vars.

### .env.example — Always Commit This
```bash
# New developers copy this to .env.local and fill in real values
VITE_API_URL=https://api.example.com
VITE_APP_TITLE=My App
# DATABASE_URL=postgres://user:pass@localhost:5432/mydb
```

### Feature Flags
```typescript
const FEATURES = {
  darkMode: import.meta.env.VITE_FEATURE_DARK_MODE === "true",
  newDashboard: import.meta.env.VITE_FEATURE_NEW_DASHBOARD === "true",
};

if (FEATURES.darkMode) { /* render dark mode toggle */ }

// For complex flags: LaunchDarkly, Flagsmith, or Unleash
```

---

## Docker Basics

```dockerfile
# Multi-stage: build then serve
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Serve with nginx
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

```yaml
# docker-compose.yml — local development
services:
  app:
    build: .
    ports: ["3000:80"]
    volumes:
      - ./src:/app/src    # Hot reload
    environment:
      - VITE_API_URL=http://api:8080

  api:
    image: node:20-alpine
    working_dir: /app
    volumes: [./server:/app]
    ports: ["8080:8080"]
    command: npm run dev

  db:
    image: postgres:16
    environment:
      POSTGRES_DB: myapp
      POSTGRES_PASSWORD: localdev
    ports: ["5432:5432"]
    volumes: [pgdata:/var/lib/postgresql/data]

volumes:
  pgdata:
```

---

## DNS Basics

| Record Type | Purpose | Example |
|-------------|---------|---------|
| **A** | Domain → IPv4 address | `example.com → 192.0.2.1` |
| **CNAME** | Domain → another domain | `www.example.com → example.com` |
| **MX** | Mail server for domain | Handled by email provider |
| **TXT** | Verification, SPF, DKIM | Domain ownership proof |

- **TTL:** How long resolvers cache the record. Set to 300s (5 min) before migrations.
- **Propagation:** DNS changes can take 0-48 hours globally. Usually minutes.

---

## Monitoring Basics

### Error Tracking (Sentry)
```typescript
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  environment: import.meta.env.MODE,
  tracesSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
});

<Sentry.ErrorBoundary fallback={<ErrorPage />}>
  <App />
</Sentry.ErrorBoundary>
```

### Health Check Endpoint
```typescript
app.get("/api/health", (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    version: process.env.COMMIT_SHA || "unknown",
  });
});
```

---

## Rollback Strategies

| Strategy | How | Speed |
|----------|-----|-------|
| Platform rollback | One-click in platform dashboard | Instant |
| Git revert | `git revert <hash> && git push` → triggers auto-deploy | 1-2 min |
| Re-deploy previous build | Select known-good deployment in platform UI | 1-2 min |

**Rule:** Roll back first, investigate second.

---

## 12-Factor App Principles (Key Ones)

| Principle | Rule |
|-----------|------|
| **Config in env** | Store config in env vars, not code |
| **Stateless processes** | Don't store state in the process (use DB, cache) |
| **Dev/prod parity** | Keep dev, staging, and prod as similar as possible |
| **Logs as events** | Treat logs as streams, don't manage log files |
| **Admin processes** | Run admin tasks as one-off processes (migrations, scripts) |

---

## Daily Rules

1. Auto-deploy from `main` via hosting platform — test in preview deployments first
2. `tsc --noEmit` in CI — bundlers don't catch type errors
3. Never put secrets in client-exposed env vars — they're bundled into JS
4. Commit `.env.example` — so new devs know what's needed
5. Preview deployments for every PR — test before merging
6. Roll back first, investigate second — when production breaks
7. Security headers on every deployment — CSP, X-Frame-Options, X-Content-Type-Options
