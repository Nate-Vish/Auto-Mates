# Lifecycle Management — Product Stages, Tech Debt & Sunsetting

*Deep-dive reference for Planner. Pull when managing a product through growth, dealing with accumulated debt, or planning end-of-life.*

---

## Four Product Lifecycle Stages

| Stage | Focus | Planner's Role |
|-------|-------|----------------|
| **Introduction** | Adoption metrics, user feedback loops | MVP scope, rapid iteration architecture, validate riskiest assumption first |
| **Growth** | Rapid iteration, scaling under load | Scalability architecture, feature prioritization (MoSCoW/RICE), performance budgets |
| **Maturity** | Stability, incremental improvements, cost control | Tech debt reduction, system hardening, optimization, NFR tightening |
| **Decline** | Reduced usage, replacement decisions | EOL planning, migration path design, sunset strategy, documentation preservation |

### Stage Transitions — What Triggers the Shift

- Introduction to Growth: product-market fit signals (retention, organic growth, revenue)
- Growth to Maturity: growth rate flattens, feature requests shift from "new" to "improve existing"
- Maturity to Decline: usage drops, maintenance cost exceeds value, modern replacement emerges

---

## Technical Debt Management

### Two Types of Debt

- **Intentional** — Deliberate trade-offs for short-term gains. "We know this is a shortcut, we will fix it next sprint." Planner documents these in the blueprint with a repayment plan.
- **Unintentional** — From poor design, knowledge gaps, or architectural drift. "We did not know this was wrong." Signals systemic issues needing broader fixes (training, better reviews, architecture overhaul).

Address intentional debt first (it was knowingly incurred with a plan). Unintentional debt requires root-cause analysis before fixing symptoms.

### The Quadrant Method — Risk x ROI Prioritization

| Quadrant | Risk | ROI | Action |
|----------|------|-----|--------|
| **Fix immediately** | High | High | Blocking features, causing incidents, security exposure |
| **Mitigate and schedule** | High | Low | Risky but low payoff — contain the blast radius, schedule fix |
| **Quick win** | Low | High | Easy to fix, clear benefit — do it in the current sprint |
| **Accept or defer** | Low | Low | Not worth the effort right now — document and move on |

### Sprint Budget for Debt Reduction

Allocate **10-20% of every sprint** to debt repayment. This is not optional — it is infrastructure investment.

- 10% minimum: keeps debt from compounding
- 15% standard: sustainable pace for healthy codebases
- 20% or more: when maintenance exceeds 30% of dev time (debt crisis)

### 6 Best Practices

1. **Identify the type** — intentional vs unintentional drives the strategy.
2. **Choose modern tech** — technology decisions ARE debt decisions. Prevent new debt at the source.
3. **Prioritize legacy modernization** — assess which legacy systems block new development most.
4. **Define risk vs ROI** — use the quadrant method above, not gut feeling.
5. **Continuous analysis + periodic reviews** — real-time monitoring for urgent issues, quarterly deep reviews for patterns.
6. **Get expert help when needed** — external perspective identifies blind spots in long-running codebases.

### Communicating Debt to Stakeholders

Frame in business terms, not code terms:
- Bad: "The code is messy and needs refactoring."
- Good: "This technical debt causes ~2 incidents per month and adds 3 days to every new feature. Fixing it is a 2-sprint investment that reduces feature delivery time by 40%."

---

## 5-Step Sunset Framework

When a product, feature, or API reaches end-of-life:

### 1. Usage Analysis
Gather telemetry data and conduct customer interviews to gauge real impact. Never sunset something people rely on without understanding who is affected and how.

### 2. Early Stakeholder Communication
Share timelines, rationales, and alternatives well in advance. No surprises. Route through Gal (user-facing) and Daisy (public positioning).

### 3. Migration Support
Provide documentation, transition tools, and migration guides for deprecated features. Make it easy to move. Builder implements migration tooling; Planner designs the migration path.

### 4. Clear Deadlines
Publish EOL dates and support windows in ALL communications. Repeat them in release notes, dashboards, and API responses (deprecation headers). GitDude tags EOL versions.

### 5. Documentation Preservation
Archive all materials for compliance, legal reference, and historical context. Never delete history — it has regulatory and institutional value.

### Sunset Triggers

A product or feature is a sunset candidate when:
- A legacy product has been replaced by a modern platform
- Usage is consistently low with poor ROI
- Technology dependencies are outdated or insecure
- Maintenance cost exceeds value delivered
- Regulatory or compliance changes make it untenable

---

## Shared Responsibility Across the Team

| Agent | Sunset Responsibility |
|-------|----------------------|
| **Planner** | Define lifecycle criteria, set sunset benchmarks, design migration architecture |
| **Builder** | Assess technical feasibility, build migration tools, implement deprecation |
| **Gal** | Manage user expectations, gather feedback on impact, test migration UX |
| **Daisy** | Position transitions publicly, handle external communications |
| **GitDude** | Tag EOL versions, manage deprecation branches, coordinate release timing |
| **Legal** | Review contractual obligations, data retention requirements |
| **Checker** | Verify migration completeness, security of archived systems |

---

## Versioning Coordination with Deprecation

| Strategy | Best For | Signal |
|----------|----------|--------|
| **Semantic Versioning (SemVer)** | API and modular systems | MAJOR.MINOR.PATCH — clear compatibility contract |
| **Date-Based** | Scheduled releases | Predictability for consumers |
| **Incremental Build** | Internal development cycles | Fast deployment visibility |

Coordinate releases with phase-outs: a major version (e.g., 4.0) introduces new architecture while formally deprecating the old branch (e.g., 2.x EOL announced, 3.x enters maintenance-only).

### Tools for Lifecycle Management

- **Jira / Azure DevOps** — version support deadline tracking
- **LaunchDarkly / Split** — gradual feature deprecation via feature flags
- **Docs-as-Code** — automated versioned documentation that preserves history

---

*Sources: Harbinger Group Technical Debt Management (2026), Agile Seekers Product Lifecycle & Sunset Strategies (2026). Fetched 2026-03-22.*
