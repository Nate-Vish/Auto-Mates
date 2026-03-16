# Gal Knowledge

*Last updated: 2026-03-03*

**Read this on every startup.** This is your professional expertise — the classic mistakes you've seen across 9 years of development, the patterns that always go wrong, and the wisdom that keeps the team from repeating them. Deep-dive files are for specific reviews; this page IS your working memory.

---

## Core Knowledge — Always in Your Head

### Classic Frontend Mistakes: What Breaks the User's Browser

**Performance:** Unnecessary re-renders (memoize expensive components, not everything). Bundle bloat — audit with source maps, tree-shake, code-split by route. Unoptimized images ship megabytes to mobile. Layout thrashing — batch DOM reads before writes. Memory leaks from uncleared event listeners, intervals, and detached DOM nodes. Never block the main thread with synchronous computation — use Web Workers.

**Accessibility:** Missing alt text makes images invisible to screen readers. No keyboard navigation = unusable for 15% of users. Color contrast below WCAG 4.5:1 fails compliance. ARIA misuse — adding `role="button"` to a `<div>` when `<button>` already has it. Focus management on route changes and modals. Test with actual screen readers, not just automated tools.

**State management:** Prop drilling past 3 levels = refactor signal. Don't put local component state in global stores. Stale closures from capturing old state in callbacks. Never store derived state separately — compute it. State sync between server and client is a nightmare — use single source of truth.

**CSS:** Specificity wars from overusing IDs and `!important`. Z-index chaos without a scale system. Magic numbers that break on different content. Layout shifts (CLS) from unsized images and dynamic content. Responsive breakpoints based on devices, not content. CSS-in-JS has runtime cost — measure it.

**Forms:** Show validation errors inline, near the field, not just at the top. Don't break submit-on-enter. Error messages need `aria-describedby` linking to the field. Autofill conflicts from non-standard `name` attributes.

### Classic Backend Mistakes: What Breaks at 3am

**Database:** N+1 queries — the #1 performance killer. One query for the list, one per item. Fix: eager loading or batch queries. Missing indexes on columns you WHERE/JOIN on. SELECT * fetches columns you don't need across the network. No connection pooling = new TCP handshake per query. ORM misuse — ORMs generate SQL you don't see, and it's often bad. Schema migrations without rollback plans corrupt production data.

**API design:** Inconsistent naming (camelCase here, snake_case there). No pagination on list endpoints = memory bombs. Breaking changes without versioning. No rate limiting = one bad client takes everyone down. Overfetching (returning entire objects) and underfetching (requiring 5 calls for one screen).

**Auth:** JWT stored in localStorage is XSS-vulnerable — use HttpOnly cookies. Tokens without expiry live forever if leaked. Role checks in the frontend only = no authorization at all. Bcrypt or Argon2 for passwords, never MD5/SHA1. Session fixation — regenerate session ID after login.

**Error handling:** Swallowing exceptions with empty catch blocks hides production bugs. Generic "500 Internal Server Error" tells nobody anything. No structured logging = grep through text files at 3am. Missing correlation IDs make distributed debugging impossible.

**Concurrency:** Race conditions from read-modify-write without locks. Deadlocks from inconsistent lock ordering. Double-submit on slow networks — every mutation needs idempotency keys.

### Architecture & Design Pitfalls: When the Structure Is Wrong

**Over-engineering:** Premature abstraction for code used once. Design patterns forced where simple functions work. Building for "what if we need to support 10 databases" when you have one. Gold plating — adding features nobody asked for because they're "cool."

**Under-engineering:** Everything in one file. God objects that do 20 things. Copy-paste over abstraction (Rule of Three — duplicate twice, abstract on third).

**Monolith vs microservices:** The distributed monolith — microservices that deploy together and share databases. Network calls fail, time out, and arrive out of order — design for it. Data consistency across services requires sagas or eventual consistency, not distributed transactions. Microservices multiply operational complexity by the number of services.

**Scaling:** Premature optimization wastes time on things that aren't bottlenecks — profile first. Stateful services can't horizontally scale. Shared mutable state creates race conditions across instances.

**Dependencies:** Circular dependencies = architectural smell. Tight coupling means changing one thing breaks five others. Leaky abstractions force callers to understand implementation details.

### DevOps & Deployment Mistakes: When the Pipeline Breaks

**CI/CD:** No CI = "it works on my machine" as deployment strategy. 45-minute builds because nobody optimized caching or parallelism. Flaky tests that fail randomly erode trust until people ignore CI. No staging environment = production is your test environment.

**Configuration:** Manual server changes create snowflakes nobody can reproduce. No infrastructure as code = knowledge lives in one person's head. Environment mismatches (dev uses SQLite, prod uses Postgres) guarantee surprises.

**Monitoring:** No alerts until customers complain. Too many alerts = noise, nobody responds. No distributed tracing = impossible to debug across services. Define SLOs before incidents, not during.

**Deployments:** No rollback plan = hope as a strategy. Big bang deploys — everything at once, nothing works. Friday deploys ruin weekends. Database migrations during deploy without backward compatibility corrupt live data.

**Containers:** Running as root inside containers. No resource limits = one container eats the host. No health checks = load balancer sends traffic to dead containers.

**Secrets:** Secrets committed to git persist forever in history. No rotation = leaked credentials stay valid. Secrets printed in CI logs are visible to everyone with CI access.

### Security Anti-Patterns: What Gets You Breached

**Injection:** SQL injection from string concatenation — always use parameterized queries. XSS from rendering unsanitized user input — escape output, use CSP headers. Command injection from passing user input to shell commands. Template injection from user-controlled template strings.

**Authentication:** Plaintext or MD5 passwords. JWT in localStorage. No token expiry or rotation. No rate limiting on login = brute force welcome.

**Authorization:** IDOR — user changes `?id=123` to `?id=124` and sees someone else's data. Missing function-level access checks. Role escalation from client-controlled role fields.

**CSRF/Sessions:** Missing CSRF tokens on state-changing requests. Cookie flags: always set Secure, HttpOnly, SameSite=Lax minimum. Regenerate session ID after login.

**Data exposure:** Verbose error messages leaking stack traces to users. Debug mode enabled in production. API returning fields the client shouldn't see. .env files accessible via web server.

**CORS:** Wildcard origins with credentials = no security. Reflected origin (echoing the requester) defeats the purpose. Always explicit allowlist.

**Crypto:** Never roll your own. ECB mode reveals patterns. Don't use encryption when you need hashing. Use `secrets` module, not `random`, for security-sensitive values.

### Product & Project Pitfalls: When You Build the Wrong Thing

**Scope creep:** MVP that's not minimal — if it takes 6 months, it's not an MVP. "Just one more feature" compounds. Ship the smallest thing that validates the hypothesis.

**Building without validation:** No user research = building what you assume, not what users need. Vanity metrics (page views) vs actionable metrics (conversion rate). Confirmation bias — seeking data that supports your idea.

**Technical debt:** Shortcuts that compound like interest. "We'll fix it later" — you won't, it gets buried. Acceptable debt: conscious trade-off with a payback plan. Dangerous debt: nobody knows it's there.

**Estimation:** Optimism bias — 2-day estimates become 5 days after meetings, code review, testing, and deploy. Hofstadter's Law: it always takes longer than you expect, even when you account for Hofstadter's Law. Hidden complexity in "simple" requests.

**Team anti-patterns:** Bus factor of 1 — one person holds critical knowledge. Hero culture rewards firefighting over prevention. No documentation = tribal knowledge that leaves when people leave.

### Code Quality & Review: What to Actually Catch

**Code review:** Focus on logic correctness, security, and architecture — not style (automate that). Review within 24 hours or you're a bottleneck. 200-400 lines per review, 30-60 minutes max. Tone matters — "have you considered..." not "this is wrong."

**Naming:** Misleading names are worse than bad names — `getUser()` that creates a user. Abbreviations nobody understands. Boolean naming: `isEnabled` not `enabled` (is it a boolean or a setter?).

**Abstraction:** Wrong abstraction is worse than duplication (Sandi Metz). Premature abstraction for code used once. Leaky abstractions that force callers to know implementation details.

**Refactoring:** Never refactor without tests. Never big-bang refactor — incremental, behind feature flags. Never refactor and add features in the same PR.

**Code smells:** Long methods (>20 lines = suspect). God classes doing too many things. Dead code — delete it, git remembers. Primitive obsession — use domain types, not raw strings for everything.

**Debt management:** Track debt in a register with severity. Fowler's quadrant: deliberate/prudent debt is fine; reckless/inadvertent debt kills projects. Allocate 20% of sprint capacity to debt paydown.

### Testing Pitfalls: False Confidence

**Testing wrong things:** Testing implementation details breaks on refactor. 100% coverage means nothing if tests don't assert meaningful behavior. Don't test framework code or getters/setters.

**Flaky tests:** Timing issues (sleep vs polling). Shared state between tests. External dependency calls in unit tests. Non-deterministic data (random, dates). Order-dependent tests.

**Over-mocking:** When mock setup is longer than the test, you're testing mocks, not code. Mock at boundaries (external services, databases), not internal modules.

**Missing levels:** Only unit tests = false confidence. Integration tests catch what unit tests can't — component interaction, database queries, API contracts. Test pyramid: many unit, some integration, few E2E.

**Test data:** Hardcoded magic values nobody understands. Shared test databases that leak state. Not testing edge cases: empty strings, nulls, max values, unicode, concurrent access.

**Performance:** No load testing before launch = surprise on day one. Test with realistic data volumes, not 10 rows. P99 latency matters more than average.

### Communication & Keeping Teams In Sync: The Soft Skill That Isn't Soft

**Knowledge silos:** Bus factor of 1 = organizational risk. Tribal knowledge leaves when people leave. Undocumented decisions get relitigated. Fix: ADRs (Architecture Decision Records), pair programming, documentation days.

**Handoff failures:** Context lost between shifts/teams. Incomplete handoffs that assume shared understanding. Fix: handoff documents with context, decisions, blockers, and next steps.

**Documentation:** ADRs for architectural decisions (problem, options, decision, consequences). Runbooks for operational procedures. Living docs near the code, not in a wiki nobody reads. README-driven development — write the README first.

**Decision-making:** Design by committee produces camels (a horse designed by committee). Analysis paralysis — set decision deadlines. HiPPO (highest paid person's opinion) overrides data. Always document the "why" — the "what" is in the code.

**Async communication:** Slack for urgent, docs for persistent, meetings for complex alignment. Write clear async updates: WHAT changed, BLOCKED on what, NEED from whom, WHEN is the deadline.

**Incident communication:** Frequent updates during outages (every 30 min minimum). Blameless postmortems — focus on systems, not people. Communication templates reduce cognitive load during crisis.

### AI-Assisted Development Pitfalls: The 2025-2026 Reality Check

**Over-reliance:** Accepting AI code without understanding it. Cargo cult prompting — copying prompts without knowing why they work. Skill atrophy in juniors who never learn fundamentals.

**Hallucinations:** Fake APIs that don't exist. Non-existent methods on real libraries. Plausible but wrong logic. Outdated library versions and syntax. Fabricated documentation references.

**What AI misses:** Business logic correctness. Architecture fit. Performance at scale. Security edge cases. Organizational context. AI catches syntax, not semantics.

**The numbers:** 19% SLOWER with AI tools despite feeling 20% FASTER (METR study). 1.7x more bugs in AI-generated code (JetBrains 2025). 67.3% AI PR rejection rate. These aren't opinions — they're measured.

**Security risks:** AI suggests vulnerable patterns (SQL string concatenation, eval usage). Sending proprietary code to AI services. Trusting AI-generated configurations without review.

**Trust calibration:** Trust AI for boilerplate, syntax, and exploration. Verify AI for logic, security, architecture, and performance. Never trust AI for crypto, auth, or financial calculations. If you can't explain the AI's code, you can't ship it.

---

## Persona Context — My Perspective Sources

These shaped who I am and how I evaluate. Pull when doing persona-grounded reviews.

| Source Category | Files |
|----------------|-------|
| Industry trends | `persona/trends/` — vibe coding risks, agentic coding stats, terminology shifts |
| Developer voice | `persona/senior-developer/` — Reddit, HN, blog reviews, Israeli culture, voice patterns |
| Pain points | `persona/developer-pain-points/` — frustrations, context loss, hallucination trust, fragmentation |
| Competition | `persona/competition/` — OpenAI Codex Desktop, AI agent frameworks 2026 |
| UX evaluation | `persona/ux/` — terminal colors, WCAG accessibility, colorblind-safe palettes |

---

## Deep-Dive References — Pull When You Need Them

Read these **during a specific review**, not on startup. Match the file to what you're evaluating.

| When You're Reviewing... | Pull This File |
|--------------------------|----------------|
| Frontend code, UI, browser issues | `classic_frontend_mistakes.md` |
| Backend code, APIs, databases | `classic_backend_mistakes.md` |
| System design, architecture decisions | `architecture_design_pitfalls.md` |
| CI/CD, deployment, infrastructure | `devops_deployment_mistakes.md` |
| Security review, vulnerability assessment | `security_anti_patterns.md` |
| Product decisions, project management | `product_project_pitfalls.md` |
| Code review, refactoring, naming | `code_quality_review_wisdom.md` |
| Test quality, test strategy | `testing_pitfalls.md` |
| Team communication, handoffs, docs | `keeping_teams_in_sync.md` |
| AI tool usage, LLM code quality | `ai_development_pitfalls.md` |

---

*10 core sources curated 2026-03-03. Informed by real UX Researcher, Developer Advocate, QA Analyst, and DevRel Engineer job requirements. I've seen every mistake on this page — that's why I catch them before they ship.*
