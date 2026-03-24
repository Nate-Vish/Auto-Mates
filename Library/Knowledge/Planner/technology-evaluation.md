# Technology Evaluation — Build vs Buy & OSS Maturity

*Deep-dive reference for Planner. Pull when evaluating technology choices for a new project or major architectural shift.*

---

## Build vs Buy Decision Matrix

| Factor | Build | Buy |
|--------|-------|-----|
| **Core differentiator?** | Build when it is your competitive advantage | Buy when it is commodity functionality |
| **Total cost** | Higher upfront, lower recurring if maintained well | Lower upfront, but **70% of costs come after implementation** (licensing, upgrades, vendor management) |
| **Time to market** | Slower — you own the timeline and risk | Faster — but limited to vendor's roadmap |
| **Internal expertise** | Need staff to build AND maintain long-term | Need staff to integrate, configure, and keep current |
| **Customization** | Full control over direction | Limited to vendor's extensibility points |
| **Risk profile** | Technical risk (can you actually build it?) | Vendor risk (will they survive? change pricing? sunset the product?) |

### The 70% Rule

Most software costs occur after implementation — maintenance, upgrades, licensing renewals, training, integration upkeep. A rigorous total-cost-of-ownership analysis often tips the balance toward buying commodity capabilities. But vendor lock-in can make that 70% even worse if switching costs are high.

**Decision heuristic:**
- If it is your core differentiator: build it.
- If it is commodity: buy it.
- If uncertain: prototype both paths for 2 weeks, then decide with data.

---

## Open Source Maturity Assessment

### 20+ Evaluation Models Exist — Key Ones:

**Navica/Golden Open Source Maturity Model:**
- Assesses maturity, durability, and strategic alignment of an OSS project.
- Examines community health, release cadence, documentation quality.

**CapGemini Open Source Maturity Model:**
- Adds functional assessment to maturity evaluation.
- Considers enterprise readiness and commercial support availability.

### 4-Category Evaluation Framework

1. **Context** — Industry fit, regulatory requirements, compatibility with existing tech stack.
2. **User** — Team skills match, learning curve, quality of community support and documentation.
3. **Process** — Integration effort, migration path complexity, ongoing maintenance burden.
4. **Quality** — Code quality, test coverage, security posture, license compatibility.

---

## The 6 Criteria a Senior Architect Evaluates

For every technology under consideration, score each:

1. **Maturity** — How long has it existed? What major version is it on? Who uses it in production at scale?
2. **Community health** — Number of active contributors, commit frequency, median issue response time, bus factor (how many key maintainers?).
3. **License** — Permissive (MIT, Apache 2.0) vs copyleft (GPL, AGPL). Compatibility with your project's license. Route to Legal agent for review.
4. **Migration cost** — What does it take to switch away if it fails or is abandoned? High switching cost = high lock-in risk.
5. **Security posture** — CVE history, security response process, third-party audit results, dependency chain depth.
6. **Integration fit** — Does it work with your stack without major glue code or adapter layers?

### Scoring Template

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| Maturity | 20% | | | |
| Community | 15% | | | |
| License | 15% | | | |
| Migration cost | 20% | | | |
| Security | 15% | | | |
| Integration fit | 15% | | | |
| **Weighted total** | | | | |

---

## When to Choose Each Approach

| Scenario | Recommendation |
|----------|---------------|
| Core business logic, competitive differentiator | Build |
| Auth, payments, email, analytics, monitoring | Buy or use mature OSS |
| Team has deep expertise in the domain | Build is lower-risk |
| Team has no expertise, tight deadline | Buy and integrate |
| Mature OSS with active community exists | Adopt OSS, contribute back |
| Only immature/abandoned OSS options exist | Build, or buy commercial |
| Vendor offers fair pricing with low lock-in | Buy |
| Vendor has history of price hikes or acquisitions | Build or adopt OSS |

---

## Relevance to Planner

This is pre-architecture work. Before designing the system, Planner evaluates: "What technologies should we use, and what is the total cost of each option?" This knowledge prevents choosing shiny-but-immature tools that become technical debt later. Every technology decision should be captured in an ADR.

---

*Sources: ThoughtWorks Build vs Buy (2022), Navica OSS Maturity Model, CapGemini OSS Maturity Model. Fetched 2026-03-22.*
