# Builder Knowledge

*Last updated: 2026-03-02*

**Read this on every startup.** This is your professional expertise — the knowledge you carry in your head at all times. Deep-dive files are for specific implementations; this page IS your working memory.

---

## Core Knowledge — Always in Your Head

### TypeScript: Your Primary Language

**Type System Essentials:**
Discriminated unions are your most powerful pattern — `{ kind: "circle"; radius: number } | { kind: "rect"; width: number; height: number }`. Switch on the discriminant field and TS narrows automatically. Use unions over enums (zero-cost, better DX). Utility types derive new types from existing ones: `Partial<T>` for update payloads, `Omit<T, K>` for API responses without sensitive fields, `Pick<T, K>` for selective views, `Record<K, V>` for maps. `ReturnType<typeof fn>` and `Parameters<typeof fn>` extract types from existing functions.

**Daily Rules:** Always `strict: true` in tsconfig. Let inference work — only annotate when TS can't figure it out. `unknown` over `any`, always. Custom type guards (`function isUser(x): x is User`) at system boundaries. Template literal types for string patterns (`type Route = \`/${string}\``). Type-only imports (`import type { User }`) for types that don't need runtime. `satisfies` operator validates without widening.

### CSS: Layout & Styling

**Flexbox** = one-dimensional layout. `justify-content` (main axis), `align-items` (cross axis), `gap` for spacing. `flex: 1` for equal columns. `margin-inline-start: auto` to push items.

**Grid** = two-dimensional layout. `repeat(auto-fit, minmax(250px, 1fr))` for responsive grids without media queries. Named areas for page layouts. Subgrid for child alignment.

**Responsive without breakpoints:** `clamp(1rem, 2.5vw, 2rem)` for fluid typography. `min(90%, 1200px)` as max-width alternative. Container queries (`@container`) for component-level responsiveness.

**Animation rules:** Only animate `transform` and `opacity` — everything else triggers layout recalculation. Always respect `prefers-reduced-motion`. Scroll-snap for carousels.

**Modern features:** `:has()` parent selector, native nesting, `@layer` for specificity, `oklch()` for perceptually uniform colors, `color-mix()` for variants, logical properties (`margin-inline`) for RTL support.

### HTML & Accessibility: Non-Negotiable Standards

**Semantic elements:** `<header>`, `<nav>`, `<main>`, `<section>` (with heading), `<article>` (self-contained), `<aside>`, `<footer>`. Use `<dialog>` for modals. If there's a semantic element for it, use it — `<div>` only when there isn't.

**ARIA first rule:** Don't use ARIA if native HTML does the job. `<button>` not `<div role="button">`. ARIA is for: live regions (`aria-live`), relationships (`aria-describedby`), dynamic states (`aria-expanded`), custom widgets (tabs, trees, comboboxes).

**Forms:** Always `<label>` + `for` attribute. `<fieldset>`/`<legend>` for groups. Input `type` for mobile keyboards (email, tel, url). `autocomplete` attributes for autofill.

**Keyboard:** All interactive elements must be focusable. Never `outline: none` without visible replacement. `tabindex="0"` to add to tab order, `tabindex="-1"` for programmatic focus only.

**Contrast:** 4.5:1 for normal text (AA), 3:1 for large text and non-text elements. Check with DevTools.

### Data Structures & Algorithms: Choose the Right Tool

**Big O — the mental model:** O(1) hash lookup, O(log n) binary search, O(n) single pass, O(n log n) sorting ceiling, O(n^2) nested loops — avoid above this for datasets over 10k items.

**When to use what:** Array for indexed access and ordered iteration. Map/Set for O(1) lookups (use over plain objects for dynamic keys). Stack (LIFO) for undo/redo, DFS, expression parsing. Queue (FIFO) for BFS, task scheduling. Linked list rarely in JS — prefer arrays. Tree for hierarchical data (DOM, file systems, org charts). Graph for networks and relationships.

**Essential algorithms:** Binary search on sorted data. BFS for shortest path in unweighted graphs. DFS for tree traversal, topological sort. Merge sort / quick sort when you need stable or in-place. Dijkstra for weighted shortest path.

**Patterns to recognize:** Two pointers for sorted array problems. Sliding window for contiguous subarray/substring. Hash map for O(n) lookups replacing O(n^2) brute force. Memoization/DP for overlapping subproblems. Greedy for interval scheduling and activity selection.

**JS built-in complexities:** Array `.push()`/`.pop()` = O(1), `.shift()`/`.unshift()` = O(n), `.includes()`/`.indexOf()` = O(n). Map/Set `.get()`/`.has()`/`.set()` = O(1). Object property access = O(1) average. `Array.sort()` = O(n log n) — TimSort.

### API Design & Integration: The Connective Tissue

**REST fundamentals:** Nouns for resources (`/api/v1/users`), HTTP methods for actions (GET=read, POST=create, PUT=replace, PATCH=partial, DELETE=remove). Status codes: 200 OK, 201 Created, 204 No Content, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable, 429 Rate Limited, 500 Server Error.

**URL patterns:** Nested resources for relationships (`/users/42/orders`). Query strings for filtering, sorting, pagination (`?sort=-created_at&page=2&limit=20`). Use cursor-based pagination for real-time data, offset-based for simple cases.

**REST vs GraphQL:** REST for simple CRUD, public APIs, caching needs. GraphQL for complex nested data, mobile clients (avoid over-fetching), rapid iteration. GraphQL adds schema complexity — don't use it for simple APIs.

**WebSockets:** Use for real-time features (chat, live updates, collaborative editing). Socket.IO adds reconnection, rooms, and fallbacks over native WebSocket. Always implement heartbeats for connection health.

**Auth patterns:** JWT for stateless APIs (access token 15min + refresh token 7d). OAuth 2.0 for third-party login. API keys for server-to-server. Session cookies for traditional web apps. Never store tokens in localStorage — use httpOnly cookies or in-memory.

**Security essentials:** Always HTTPS. CORS `origin` whitelist (never `*` in production). Rate limiting on all endpoints. Input validation with Zod at the boundary. OWASP API Security Top 10 awareness.

### React: Implementation Patterns

**Custom hooks** for reusable logic — `useDebounce`, `useLocalStorage`, `useMediaQuery`, `useOnClickOutside`. Extract when two+ components share behavior.

**Compound components** for related UI — tabs, accordions, dropdowns. Shared state via Context, clean API via component composition.

**useEffect decision tree:** Syncing with external system? → Yes. Transforming data? → No, do in render. Responding to event? → No, use handler. Fetching data? → Use TanStack Query. Always clean up subscriptions, timers, listeners.

**Performance:** Don't memoize by default. React 19 Compiler handles most cases. Profile first with React DevTools. Virtualize lists over 100 items (`@tanstack/react-virtual`). Route-based code splitting with `React.lazy` + `Suspense`.

**Error boundaries** at route/feature level, not every component. Still require class component syntax.

### React Ecosystem: Libraries & Tools

**State management:** Zustand (~3KB, hook-based) for most apps. Redux Toolkit (~15KB) for large enterprise with complex state. Jotai (~2KB, atomic) for fine-grained reactivity. Context for low-frequency updates (theme, locale, auth). Rule: `useState` for local, Zustand for shared client, TanStack Query for server state.

**React Router v7:** `createBrowserRouter` with loader/action pattern. Nested routes with `<Outlet/>`. Protected routes via wrapper component. Route-based code splitting with `lazy()`.

**Forms:** React Hook Form + Zod (zodResolver). Uncontrolled inputs by default (performance). `FormProvider` for nested components. Multi-step forms: per-step Zod schema + Zustand for persistence.

**TanStack Query:** `useQuery` for GET, `useMutation` for POST/PUT/DELETE. Stale-while-revalidate caching. `queryClient.invalidateQueries` after mutations. Optimistic updates with `onMutate` + `onError` rollback.

**React 19 features:** `use()` hook for promises and context. `useActionState` for form submissions. `useOptimistic` for instant UI feedback. Server Components (zero client JS). `<form action>` for progressive enhancement.

**Component libraries:** shadcn/ui (copy-paste, full control, Tailwind). Radix UI (unstyled primitives, a11y built-in). Mantine (batteries-included). MUI (Material Design, enterprise).

**Testing:** Vitest for unit + component tests. Testing Library queries: `getByRole`, `getByLabelText`, `getByText` — test behavior, not implementation. Playwright for E2E critical paths.

### Build Tooling: Vite

**Config essentials:** Path aliases in BOTH `vite.config.ts` AND `tsconfig.json` (must match). `@vitejs/plugin-react` for React support. Server proxy for API requests.

**Environment:** Client-exposed env vars use build-tool-specific prefixes (`VITE_`, `REACT_APP_`, `NEXT_PUBLIC_`). Never put secrets in client-exposed vars — they're bundled into JavaScript.

**Code splitting:** `React.lazy(() => import("./Page"))` at route level. Manual chunks for large deps. Analyze with `rollup-plugin-visualizer`.

**Critical:** Vite does NOT type-check. Always run `tsc --noEmit` separately.

### Backend Fundamentals: Server-Side Development

**Node.js event loop:** Single-threaded but concurrent via event loop. Never block with synchronous computation. `Promise.all()` for independent async ops. Offload CPU-heavy work to worker threads. Priority: sync code > `process.nextTick` > microtasks > timers.

**Express.js patterns:** Middleware stack order matters — security first (helmet, cors, rate-limit, compression), then routes, then error handler. Error middleware has 4 params `(err, req, res, next)`. Async error wrapper needed for pre-v5 Express.

**Database choice:** PostgreSQL for relational data with complex queries. MongoDB for flexible schemas and rapid iteration. Redis for caching, sessions, rate limiting. Prisma for type-safe ORM with great DX. Drizzle for SQL-first, edge-ready, smaller bundle.

**Auth flow:** bcrypt for password hashing (12 salt rounds). JWT: access token (15min, in-memory) + refresh token (7d, httpOnly cookie). RBAC middleware pattern for role-based access.

**Architecture:** 3-layer (controller → service → repository). Feature-based folder structure over technical grouping. Zod validation at API boundaries. Structured JSON logging (Pino for perf, Winston for flexibility). Cache-aside pattern with Redis.

### Frontend Architecture: Browser & Rendering

**Browser APIs to know:** IntersectionObserver (lazy loading, infinite scroll), ResizeObserver (element-level responsive), Web Workers (offload computation), Service Workers (offline, caching), Fetch + AbortController (timeout/cancel), Web Storage (localStorage = 5-10MB persistent, sessionStorage = tab-scoped).

**Performance checklist:** Route-based code splitting with `React.lazy`. WebP/AVIF images with `srcset` for responsive. Preconnect to API origins. Inline critical CSS. `loading="lazy"` on below-fold images. Font `display: swap` + preload.

**Rendering strategy:** SSG + ISR for public content (blog, docs, products). CSR for authenticated dashboards. SSR only when per-request freshness is needed. React Server Components for zero-JS server rendering.

**Web security:** XSS prevention — sanitize with DOMPurify, never `innerHTML` with user input. CSP with nonces (`strict-dynamic`). Secure cookies (httpOnly, secure, sameSite). CSRF protection via SameSite cookies or tokens.

**Design systems:** Design tokens as code (colors, spacing, typography). CSS custom properties for theming. shadcn/ui or Radix for maximum control.

### Clean Code: Daily Discipline

**Naming:** Variables reveal intent (no abbreviations). Functions use specific verbs. Booleans start with `is`/`has`/`should`/`can`. Constants in `SCREAMING_SNAKE`.

**Functions:** Single responsibility, max ~30 lines, max 3 parameters (use object for more). Guard clauses for early returns — flatten nesting.

**Error handling:** Custom error classes for typed handling. Never swallow errors. Never throw strings. Result type (`{ ok, value } | { ok, error }`) as alternative to try/catch.

**Comments:** Explain WHY, not WHAT. JSDoc for exported APIs. No commented-out code (use git).

**File organization:** Feature-based (colocate related code). Colocation principle: put code close to where it's used, move up only when shared.

### DevOps & Cloud: Infrastructure Awareness

**Cloud providers:** AWS (broadest catalog, most mature), Azure (Microsoft/enterprise, OpenAI), GCP (Kubernetes leader, data/ML, open-source). Use Terraform for multi-cloud IaC.

**Docker essentials:** Multi-stage builds to minimize image size. `.dockerignore` always. Non-root user in production. `COPY package*.json` before source for layer caching. Health checks with `HEALTHCHECK` directive.

**Kubernetes awareness:** Pod = smallest deployable unit. Deployment manages replicas. Service exposes pods. Ingress routes external traffic. ConfigMap/Secret for config. HPA for auto-scaling. GKE is the gold standard.

**CI/CD pipeline:** lint → type-check → test → build → deploy. Cache dependencies between runs. Run tests in parallel. Preview deployments per PR. Blue-green or canary for zero-downtime deploys.

**Monitoring:** Three pillars — metrics (Prometheus/Grafana), logs (structured JSON, ELK/Loki), traces (OpenTelemetry/Jaeger). Alert on symptoms (error rate, latency), not causes. RED method for services: Rate, Errors, Duration.

### Automation & Scripting: Developer Productivity

**Shell scripts:** Always `set -euo pipefail`. `readonly` for constants. Functions for reusable blocks. Use `trap` for cleanup. `shellcheck` for linting.

**Python automation:** `pathlib` for file operations, `requests`/`httpx` for HTTP, `json`/`csv` for data, `subprocess.run()` for shell commands. Use `argparse` for CLI tools.

**Node.js scripting:** `fs/promises` for async file ops. `child_process.execSync` for quick shell commands. `zx` (Google) for shell-script-like DX in JS.

**Workflow tools:** Makefile for language-agnostic task runner. npm scripts for JS projects. Turborepo/nx for monorepo task orchestration.

**Git hooks:** Husky + lint-staged for pre-commit (lint, format, type-check staged files only). Commitlint for conventional commit enforcement. Pre-push for test runs.

**Cron & scheduling:** Crontab syntax (`* * * * *` = min hour day month weekday). Node: `node-cron`. Use lock files to prevent overlapping executions.

### Data & ML: Awareness Level

**Python data stack:** pandas (data manipulation), numpy (numerical computing), matplotlib/seaborn (static plots), Plotly (interactive charts), scikit-learn (ML), Polars (high-performance DataFrames for 10GB+ datasets).

**pandas essentials:** `pd.read_csv()` / `pd.read_json()` / `pd.read_parquet()` for ingestion. `.head()`, `.info()`, `.describe()` for exploration. `.loc[]` / `.iloc[]` for selection. `.groupby()` for aggregation. `.merge()` / `.join()` for combining.

**Statistics to know:** Mean, median, standard deviation. Percentiles and IQR for outlier detection. Correlation (Pearson for linear, Spearman for ranked). Normal distribution basics.

**ML concepts:** Supervised (labeled data → prediction) vs unsupervised (pattern discovery). Classification (categories) vs regression (numbers). Train/test split (80/20). Overfitting = memorizing training data, underfitting = too simple. Accuracy, precision, recall, F1 for evaluation.

**ML integration:** Use APIs first (OpenAI, Hugging Face, cloud ML services) before training custom models. Prompt engineering for LLMs. scikit-learn `fit()` / `predict()` pattern for traditional ML. Rule: if hand-coded rules solve it, don't use ML.

### Senior Engineering Practices: Beyond Code

**Code review:** Read the full diff before commenting. Be specific and actionable. Prefix with `[must]`, `[suggestion]`, `[nit]`, `[question]`. Review tests as carefully as implementation. Praise good work.

**Architecture decisions:** Write ADRs (Architecture Decision Records) — Context, Decision, Consequences. Evaluate technology on: community, maintenance, team familiarity, escape cost. Design for the current load, not fantasy scale.

**Technical debt:** Track it (tech debt register). Classify by impact (blocks features, causes incidents, slows onboarding). Pay it down with the 20% rule — allocate time every sprint. Communicate in business terms.

**System design patterns:** Start monolith-first, extract services when you have clear domain boundaries. Event-driven for decoupled systems. CQRS when read/write patterns differ significantly. DDD for complex business domains.

**Professional growth:** T-shaped skills (broad + one deep specialty). Write RFCs for significant changes. Estimate with ranges, not points. Run blameless incident postmortems. Mentor through pairing, not lecturing.

### Debugging: Half of Development

**Chrome DevTools:** Conditional breakpoints > console.log. Network panel for API issues. Performance panel for 60fps check. Memory panel for leak detection.

**React DevTools:** Profiler shows render times. "Why did this render?" setting. Highlight updates for visual feedback.

**Strategy:** Read the error message (file, line, stack trace). Binary search (comment out half) for hard-to-locate bugs. `git bisect` for finding breaking commits.

**Web Vitals:** LCP < 2.5s, INP < 200ms, CLS < 0.1. Bundle analysis for size optimization.

### Git: Daily Workflow

**Branching:** `feature/`, `fix/`, `chore/`, `refactor/`, `docs/`, `test/` prefixes.

**Commits:** Conventional format — `feat:`, `fix:`, `refactor:`. Imperative mood. Body explains WHY.

**Rebasing:** Rebase YOUR branch onto main before PR. Never rebase shared branches. `--force-with-lease` over `--force`.

**Safety:** Reflog recovers almost anything. Stash for quick context switches. Never commit secrets.

### Deployment: Ship It

**Hosting platforms:** Cloudflare Pages, Vercel, Netlify, GitHub Pages — all support auto-deploy from Git. All offer preview deployments per PR (except GitHub Pages). Choose based on project needs.

**Pipeline:** lint → type-check → test → build → deploy. `tsc --noEmit` is mandatory (bundlers skip it).

**Environment vars:** Each build tool has its own prefix for client-exposed vars. Only prefixed vars reach the client — never put secrets there.

**Rule:** Roll back first, investigate second when production breaks.

---

## Deep-Dive References — Pull When You Need Them

Read these **during a specific implementation**, not on startup. Match the file to what you're building.

| When You're Building... | Pull This File |
|------------------------|----------------|
| TypeScript types, generics, utility types | `Sources/builder-knowledge/core/typescript_essentials.md` |
| CSS layouts, animations, responsive | `Sources/builder-knowledge/core/modern_css_patterns.md` |
| HTML semantics, ARIA, forms, a11y | `Sources/builder-knowledge/core/html_accessibility_essentials.md` |
| Data structures, Big O, algorithm patterns | `Sources/builder-knowledge/core/data_structures_algorithms.md` |
| REST, GraphQL, WebSockets, auth, CORS | `Sources/builder-knowledge/core/api_design_integration.md` |
| React components, hooks, Suspense | `Sources/builder-knowledge/react/react_implementation_patterns.md` |
| Zustand, Router, Forms, TanStack Query, React 19 | `Sources/builder-knowledge/react/react_ecosystem.md` |
| Vite config, code splitting, env vars | `Sources/builder-knowledge/react/vite_build_tooling.md` |
| Node.js, Express, databases, auth, caching | `Sources/builder-knowledge/backend/backend_fundamentals.md` |
| Browser APIs, state, performance, rendering, PWA | `Sources/builder-knowledge/frontend/frontend_architecture.md` |
| AWS, GCP, Azure, Docker, K8s, CI/CD, monitoring | `Sources/builder-knowledge/devops/devops_cloud_essentials.md` |
| Shell, Python, Node scripting, cron, git hooks | `Sources/builder-knowledge/devops/automation_scripting.md` |
| pandas, numpy, scikit-learn, ML concepts, ETL | `Sources/builder-knowledge/data/data_ml_fundamentals.md` |
| Naming, functions, refactoring, code smells | `Sources/builder-knowledge/quality/clean_code_principles.md` |
| Code review, architecture, tech debt, system design | `Sources/builder-knowledge/quality/senior_engineering_practices.md` |
| Chrome DevTools, React DevTools, profiling | `Sources/builder-knowledge/quality/debugging_devtools.md` |
| Git branches, commits, rebase, conflict | `Sources/builder-knowledge/patterns/git_workflow_developers.md` |
| Hosting, CI/CD, Docker, DNS | `Sources/builder-knowledge/patterns/deployment_cicd_basics.md` |

### Additional References (Legacy)
- [Claude Code 2.1.0](../Sources/anthropic/claude_code_2_1_0.md) — Agent teams, hooks, hot reload
- [Claude Agent SDK Architecture](../Sources/Agent_Architecture/Patterns/claude_agent_sdk_architecture.md) — Implementation patterns
- [iTerm2 Scripting](../Sources/terminal-automation/iterm2-scripting.md) — Terminal automation

---

*18 core sources curated 2026-03-02. Knowledge gaps flagged for BrainStorm → Gal → Fetcher pipeline. Request Fetcher to add sources when you identify knowledge gaps.*
