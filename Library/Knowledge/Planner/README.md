# Planner Knowledge

*Last updated: 2026-03-05*

**Read this on every startup.** This is your professional expertise — the knowledge you carry in your head at all times. Deep-dive files are for specific blueprints; this page IS your working memory.

---

## Core Knowledge — Always in Your Head

### Architecture: How to Structure Systems

**Design Patterns — Use the Right One, Not All of Them:**
Pattern Selection Guide: Singleton (DB pool, config — but ES module exports are singletons by default), Factory (runtime object creation — don't over-abstract), Adapter (third-party API integration), Decorator (middleware, caching, logging), Facade (simplify multi-service orchestration), Observer (events, state management — Redux/Zustand are Observer), Strategy (swappable algorithms — payment providers, auth methods), Command (undo/redo, task queues). MVC for server-side apps. Component-based with unidirectional data flow for SPAs (React).

**SOLID Principles — Practical, Not Academic:**
- **S** (Single Responsibility): A module should have one reason to change. If a file handles auth AND email AND logging, split it.
- **O** (Open/Closed): Extend behavior through composition (Strategy, Decorator), don't modify existing code.
- **L** (Liskov Substitution): Subtypes must be substitutable. If your code checks `instanceof`, the abstraction is wrong.
- **I** (Interface Segregation): Many small interfaces > one big one. Don't force implementers to depend on methods they don't use.
- **D** (Dependency Inversion): Depend on abstractions, not concretions. High-level modules shouldn't import low-level modules directly.

**DRY/KISS/YAGNI — Know When Each Is WRONG:**
- DRY is wrong when the "duplication" is coincidental — two things that look alike but change for different reasons. Wrong abstraction is worse than duplication.
- KISS is wrong when confused with "easy" — simple solutions require deep thinking, not shortcuts.
- YAGNI is wrong when skipping foundational infrastructure (auth, logging, error handling). Some things you WILL need.

**Architecture Patterns — Start Simple, Evolve:**
Monolith → Modular Monolith → Selective Microservices. Default to monolith for teams < 10 and pre-product-market-fit. Modular monolith when you need clear boundaries but not distributed complexity. Microservices only when you need independent deployment and have the operational maturity. Amazon Prime Video moved BACK from microservices to monolith for cost savings.

### Data Modeling: The Skeleton Everything Wraps Around

**Three levels:** Conceptual (entities + relationships, business language — for stakeholders), Logical (attributes + types + keys — for blueprints), Physical (tables + indexes + constraints — for Builder). Planner works at conceptual and logical levels.

**Normalization decisions:** Normalize (3NF) for transactional systems where data integrity matters. Denormalize for read-heavy queries, reporting, caching. The trade-off: normalization = integrity + write efficiency, denormalization = read performance + query simplicity. Don't over-normalize for the sake of theory.

**Database selection:** Relational (PostgreSQL) for structured data + complex queries + ACID. Document (MongoDB/Firestore) for flexible schema + rapid iteration. Key-Value (Redis) for caching + sessions. Graph (Neo4j) for relationship-heavy data. Time-Series (InfluxDB) for metrics/IoT. Vector (Pinecone/pgvector) for AI embeddings. **Start with PostgreSQL** — it handles 90% of use cases. Only add another DB when PostgreSQL provably can't handle a specific access pattern.

**Schema patterns to specify:** Soft deletes (deleted_at) vs hard deletes, audit trails (created_at/updated_at/by), UUID vs auto-increment (UUID for distributed, auto-inc for simple), multi-tenancy approach (shared DB with tenant_id vs separate schemas vs separate DBs), JSON columns (good for config/metadata, bad for queried/indexed data).

**Data flow in blueprints:** Define how data moves — input → validation → processing → storage → retrieval → output. Specify sync vs async flows. Event-driven (event sourcing, CQRS) when you need audit trails or separate read/write models. Message queues for decoupling and async processing. Caching strategy: cache-aside is the default; always plan for cache invalidation.

### Non-Functional Requirements: How Well the System Works

NFRs are architectural drivers. Missing NFRs = systems that work in demos but fail in production. **Every blueprint must specify NFRs.**

**Performance:** Specify with percentiles, not averages. "P95 API response under 200ms for authenticated endpoints." Performance tiers: real-time (<100ms), interactive (<1s), batch (<5min). Front-load performance budgets: Core Web Vitals (LCP <2.5s, FID <100ms, CLS <0.1), API latency budgets by endpoint tier, bundle size budgets.

**Scalability:** Horizontal (add machines) vs vertical (bigger machine). Estimate load: current users × growth rate × peak multiplier. The 10x rule: design for 10x current load, plan for 100x. Load patterns: steady, burst, seasonal — each drives different architecture.

**Availability:** The nines — 99.9% = 8.7h downtime/year, 99.99% = 52min/year, 99.999% = 5min/year. Each additional nine roughly 10x the cost. Specify per component, not globally. Redundancy strategies: active-passive, active-active, multi-region.

**Reliability:** MTBF (mean time between failures), MTTR (mean time to recovery). Error budgets (SRE approach): if SLO is 99.9%, you have 0.1% error budget — spend it on shipping features fast, save it when budget is low. Graceful degradation: define what happens when dependencies fail (fallback, cached response, degraded mode, circuit breaker).

**SLA/SLO/SLI:** SLI = what you measure (latency, error rate, throughput). SLO = what you target (99.9% of requests under 200ms). SLA = what you promise contractually (with penalties). Always set SLO tighter than SLA. Error budget = 100% - SLO.

**NFR specification template:** "Under [conditions], the system shall [measurable target] measured by [method]." Bad: "The system should be fast." Good: "Under normal load (1,000 concurrent users), the dashboard API shall return results within 200ms at the 95th percentile, measured by server-side instrumentation."

**NFR trade-offs:** You can't maximize everything. Performance vs cost, availability vs consistency, security vs usability. Document which quality attributes are prioritized and why.

### Architecture Documentation: ADRs, RFCs, Technical Specs

Planner produces documents. These are the standards.

**ADRs (Architecture Decision Records):** Short documents capturing ONE architecture decision. Write an ADR when: the decision is hard to reverse, affects multiple components, or involves significant trade-offs. **Template:** Title → Status (Proposed/Accepted/Deprecated/Superseded) → Context (forces/constraints) → Decision (what we decided) → Consequences (positive + negative + neutral — be honest). Keep under 2 pages. Store in `/docs/adr/` with sequential numbering. Anti-patterns: ADRs written after the fact, ADRs without consequences, ADRs for trivial decisions.

**RFCs:** Proposals that need team discussion before deciding. Use when multiple stakeholders need input. **Template:** Summary → Motivation → Detailed Design → Alternatives Considered → Drawbacks/Risks → Open Questions. Time-box review: 5 business days default. Async comments first, sync meeting only for unresolved disagreements.

**Technical Specs:** Detailed implementation plans for specific features. More detailed than blueprints, more implementation-focused. **Template:** Overview + Goals → Non-Goals (explicitly what this does NOT cover) → Background → Detailed Design (system diagram, data flow, API contracts) → Testing Strategy → Rollout Plan → Monitoring → Open Questions.

**C4 Model for diagrams:** Level 1 = System Context (your system + external actors). Level 2 = Containers (apps, databases, queues). Level 3 = Components (modules within a container). Level 4 = Code (rarely needed). Match the level to the audience. Use Mermaid or draw.io.

**Trade-off documentation:** Decision matrix (criteria × options × weighted scores). Always include "reversibility" as a dimension — prefer reversible decisions. Two-way door decisions (easy to reverse) → decide fast. One-way door decisions (hard to reverse) → decide carefully with data.

### Risk Assessment & Stakeholder Communication

**Risk identification:** For every blueprint, ask: What could go wrong? What are we assuming? What dependencies could fail? What's the blast radius if this component breaks? Create a risk register: risk → probability (low/medium/high) → impact (low/medium/high) → mitigation → owner.

**Common architectural risks:** Third-party API dependency (mitigation: circuit breaker + fallback), single point of failure (mitigation: redundancy), data loss (mitigation: backups + replication), security breach (mitigation: threat modeling + penetration testing), scope creep (mitigation: MoSCoW + clear non-goals), hiring risk (mitigation: choose technologies with large hiring pools).

**Stakeholder communication:** Present trade-offs in business terms, not just technical terms. "We can have it in 2 weeks with 99.9% availability, or 6 weeks with 99.99%. The difference is ~$X/month in infrastructure and 8h vs 52min max downtime per year." Frame decisions as options with consequences, not as "I recommend X" — let stakeholders choose.

### Frontend: React Patterns That Matter

**Component Patterns:** Custom hooks (extract reusable logic), Compound components (related components that share state implicitly — tabs, accordions), Render props (rare now — hooks replaced most use cases). HOCs are legacy — use hooks instead.

**State Management Decision Tree:**
- Start with `useState`/`useReducer` — most state is local
- Server data → TanStack Query (not Redux). Server state ≠ client state.
- Shared UI state → Zustand (tiny, fast, no boilerplate) or Jotai (atomic, bottom-up)
- URL state → use search params (`nuqs` library). Filters, pagination, tabs = URL state.
- Redux Toolkit — only for large enterprise apps with complex client-side workflows. It's not the default anymore.
- Context API — good for static/rare-change data (theme, locale). Bad for frequently changing data (kills performance via full subtree re-render).

**Performance Rules:** `React.memo` only when profiler shows the component re-renders expensively with same props. `useMemo`/`useCallback` are NOT free — they have memory cost. React 19 Compiler handles most memoization automatically.

**Anti-Patterns:** `useEffect` abuse (if it's not syncing with an external system, you probably don't need it — see react.dev). Prop drilling past 2 levels (use composition, Context, or Zustand). God components > 300 lines (decompose by responsibility). Barrel exports (`index.ts` re-exporting everything) break tree-shaking and slow builds.

### API Design: REST Done Right

**Resource Naming:** Plural nouns (`/users`, not `/user`). Nested for relationships (`/users/123/orders`). No verbs in URLs (HTTP methods ARE the verbs). Lowercase, hyphens for multi-word (`/user-profiles`).

**Status Codes That Matter:** 200 OK, 201 Created (include Location header), 204 No Content (successful DELETE), 400 Bad Request (client error), 401 Unauthorized (not authenticated), 403 Forbidden (authenticated but not authorized — never say "why"), 404 Not Found, 409 Conflict, 422 Unprocessable Entity, 429 Too Many Requests, 500 Internal Server Error (never expose stack trace).

**REST vs GraphQL vs tRPC:** REST for public APIs and simple CRUD. GraphQL for complex client-driven queries with multiple data shapes. tRPC for full-stack TypeScript apps (type-safe, zero overhead, not for public APIs). The hybrid approach is increasingly common — REST for most, GraphQL for the data-heavy frontend.

**Pagination:** Cursor-based for large/real-time datasets (17x faster than offset at scale). Offset for small/static datasets with page jumping needs. Always include `total`, `hasNext`, `nextCursor` in response.

### Planning: Blueprint Methodology

**MVP Scoping — MoSCoW First:**
Must Have = the MVP. Should Have = V1.1. Could Have = V2. Won't Have = backlog. Keep Must Have ruthlessly small. Use RICE scoring (Reach x Impact x Confidence / Effort) to break ties within Must Haves.

**Vertical Slicing — Every Phase Ships Value:**
Each slice cuts through ALL layers (UI + API + DB) to deliver one working feature. Never plan horizontal phases ("Sprint 1: database, Sprint 2: API, Sprint 3: UI"). The first slice proves the riskiest assumption.

**Requirements to Blueprint:**
User Stories for specification (`As a / I want / So that`). JTBD for discovery (`When I / I want to / So I can`). Every story needs Given-When-Then acceptance criteria. If you can't write acceptance criteria, the requirement isn't clear enough.

**T-Shirt Sizing:** XS (hours), S (1-2 days), M (3-5 days), L (1-2 weeks), XL (too big — slice it). Never convert to time estimates. Track velocity in stories/sprint after 3+ sprints.

**Technical Debt:** Accept deliberately for MVP (document it). Fight aggressively when maintenance > 30% of dev time. Reserve 20% capacity for debt reduction. Only "Prudent + Deliberate" debt is acceptable (Fowler's quadrant).

**Tech Stack Evaluation:** Score on 6 dimensions (Team Expertise, Maturity, Community, Performance, Hiring Pool, Long-term Viability). Default to PostgreSQL unless specific reason not to. Count "innovation tokens" — most projects can afford 1-2 new/unproven technologies, not 5. Boring technology wins.

---

## Deep-Dive References — Pull When You Need Them

Read these **during a specific blueprint**, not on startup. Match the file to what you're planning.

| When You're Planning... | Pull This File |
|------------------------|----------------|
| Choosing patterns for components | `Sources/planner-knowledge/architecture/design_patterns_essential.md` |
| Defining system architecture | `Sources/planner-knowledge/architecture/system_design_principles.md` |
| Monolith vs microservices decision | `Sources/planner-knowledge/architecture/component_architecture_patterns.md` |
| Data model, schema design, database selection | `Sources/planner-knowledge/architecture/data_modeling_architecture.md` |
| React component structure | `Sources/planner-knowledge/frontend/react_patterns_best_practices.md` |
| Choosing state management approach | `Sources/planner-knowledge/frontend/state_management_guide.md` |
| Designing API endpoints | `Sources/planner-knowledge/api/rest_api_design_guide.md` |
| REST vs GraphQL vs tRPC | `Sources/planner-knowledge/api/api_architecture_patterns.md` |
| Scoping an MVP / phased delivery | `Sources/planner-knowledge/planning/mvp_scoping_guide.md` |
| Writing requirements + acceptance criteria | `Sources/planner-knowledge/planning/requirements_to_blueprint.md` |
| Evaluating technology choices | `Sources/planner-knowledge/planning/tech_stack_evaluation.md` |
| Performance budgets, SLAs, capacity planning | `Sources/planner-knowledge/planning/nfrs_quality_attributes.md` |
| ADRs, RFCs, technical spec templates | `Sources/planner-knowledge/planning/architecture_documentation_standards.md` |

### Additional References (Legacy)
- [Deep Agent Architecture](../Sources/Agent_Architecture/Patterns/deep_agent_architecture.md) — Orchestrator/Explorer/Coder pattern
- [Multi-Agent Systems Guide](../Sources/Agent_Architecture/Patterns/multi_agent_systems_guide.md) — 5 architecture patterns
- [OpenAI Codex Desktop](../Sources/competition/openai_codex_desktop.md) — Competitor reference
- [Agentic Engineering](../Sources/trends/agentic_engineering.md) — Post-vibe-coding terminology

---

*13 core sources curated 2026-03-05. Audit: job posting research + Gal consultation applied retroactively. Added NFRs, architecture documentation, and data modeling to fill gaps identified in Solutions Architect job requirements.*
