---
title: "Non-Functional Requirements & Quality Attributes"
category: "planning"
tags:
  - nfrs
  - quality-attributes
  - performance
  - scalability
  - availability
  - reliability
  - security
  - sla
  - capacity-planning
  - architecture-drivers
  - iso-25010
  - sre
date_created: "2026-03-05"
scope: "universal"
audience: "Software Architect / Solutions Architect"
---

# Non-Functional Requirements & Quality Attributes

A complete professional reference for specifying, prioritizing, and managing the
quality attributes that drive architectural decisions.

---

## 1. What NFRs Are and Why They Matter

### Definition

Functional requirements define **what** a system does.
Non-functional requirements define **how well** it does it.

NFRs — also called quality attributes, cross-cutting concerns, or system
qualities — describe the constraints and expectations placed on the behavior
of the system as a whole. They are the difference between a system that works
in a demo and a system that survives production.

### Why NFRs Are Architectural Drivers

Functional requirements rarely force architectural decisions by themselves.
You can implement a login feature with a monolith, microservices, or
serverless equally well. But the moment someone says "the login must respond
in under 200ms at 10,000 concurrent users with 99.99% availability," the
architecture starts to take shape.

NFRs are the primary drivers of:
- Technology selection (languages, frameworks, databases)
- Deployment topology (single region vs. multi-region, cloud vs. on-premises)
- Infrastructure cost (the difference between a $500/month and $50,000/month system)
- Team structure (a system with strict security NFRs needs security expertise)
- Operational practices (monitoring, alerting, incident response)

### The Cost of Missing NFRs

When NFRs are absent from a blueprint:
- Developers make implicit assumptions that diverge across the team
- The system works under ideal conditions but collapses under real-world load
- Performance problems are discovered in production, where fixes cost 10-100x more
- Security vulnerabilities surface after launch, often through breach
- Stakeholders are disappointed because "it works but it's slow/unreliable/insecure"

**Rule of thumb:** If your blueprint does not contain at least 5 explicit,
measurable NFRs, it is incomplete.

### NFRs vs. Constraints

NFRs and constraints are related but distinct:

| Aspect | NFR | Constraint |
|--------|-----|------------|
| Nature | Quality target to achieve | Limitation to work within |
| Example | "Response time under 200ms" | "Must run on existing hardware" |
| Negotiable? | Often — trade-offs are possible | Rarely — imposed externally |
| Source | Stakeholders, users, business goals | Budget, regulation, legacy systems |

Both must appear in blueprints. Both drive architecture. But NFRs are targets
you optimize toward, while constraints are boundaries you must stay within.

---

## 2. Quality Attribute Categories

The following taxonomy is inspired by ISO 25010 but organized for practical
use by architects. Each category includes what it means, how to specify it,
common targets, and how it drives architecture.

### 2.1 Performance

Performance describes how fast and efficiently the system responds to
interactions and processes workload.

**Key Metrics:**

| Metric | What It Measures | How to Specify |
|--------|-----------------|----------------|
| Response time | Time from request to response | P50, P95, P99 latency targets |
| Throughput | Requests processed per unit time | Requests/second, transactions/minute |
| Resource utilization | CPU, memory, disk, network usage | Peak utilization targets (e.g., < 70% CPU) |
| Processing time | Time to complete batch or async work | Max duration for batch jobs |

**Percentile Targets (Critical Concept):**

Averages lie. A system with 100ms average response time might have a P99 of
3 seconds, meaning 1 in 100 users waits 30x longer than average. Always
specify percentiles.

```
P50  = median (half of requests are faster)
P95  = 95th percentile (only 5% are slower)
P99  = 99th percentile (only 1% are slower)
P99.9 = 99.9th percentile (the "long tail")
```

**How to write performance NFRs:**

Bad: "The system should be fast."
Bad: "API responses should be quick."
Good: "95th percentile API response time shall be under 200ms for
      authenticated read endpoints under normal load (up to 1,000
      concurrent users)."
Good: "Batch processing of daily transaction reconciliation shall complete
      within 30 minutes for up to 1 million records."

**Performance tiers for blueprint planning:**

| Tier | P95 Target | Typical Use |
|------|-----------|-------------|
| Real-time | < 50ms | Trading systems, gaming, autocomplete |
| Interactive | < 200ms | API endpoints, page loads, search |
| Responsive | < 1s | Dashboard rendering, report generation |
| Tolerant | < 5s | File uploads, complex queries |
| Background | < 5min | Batch processing, report compilation |
| Scheduled | < 1hr | ETL pipelines, data migrations |

**Architectural implications:**
- Sub-100ms targets often require in-memory caching or pre-computation
- Sub-50ms targets may require proximity (edge computing, co-located services)
- High throughput targets push toward async processing and message queues
- Resource utilization targets affect autoscaling policies and cost

### 2.2 Scalability

Scalability describes the system's ability to handle growing workload by
adding resources.

**Scaling Dimensions:**

| Dimension | Description | Example |
|-----------|------------|---------|
| Vertical (scale up) | Adding resources to existing nodes | Bigger server, more RAM |
| Horizontal (scale out) | Adding more nodes | More application instances behind a load balancer |
| Data scalability | Handling growing data volume | Sharding, partitioning, archival strategies |
| Geographic scalability | Serving distributed users | Multi-region deployment, CDN |

**Load Pattern Classification:**

Understanding load patterns drives scaling strategy:

```
Steady:    ████████████████████████  (consistent, predictable)
Diurnal:   ██░░████████████░░░░██░░  (daily cycles)
Burst:     ░░░░░░░░████████░░░░░░░░  (sudden spikes)
Seasonal:  ░░░░████████████████░░░░  (periodic high seasons)
Growth:    ░░██████████████████████  (steady increase over time)
Event:     ░░░░░░░░░░░░████░░░░░░░░  (known future spike)
```

**How to write scalability NFRs:**

Bad: "The system should scale."
Good: "The system shall support horizontal scaling from 2 to 20 application
      instances with linear throughput increase and no service interruption."
Good: "The system shall handle a 10x traffic spike (from 1,000 to 10,000
      concurrent users) within 5 minutes of auto-scaling trigger, maintaining
      P95 response time under 500ms during scale-out."

**Capacity planning formula (starting point):**

```
Required capacity = Current users
                    x Expected growth rate
                    x Peak-to-average ratio
                    x Safety margin (typically 1.5-2x)
```

### 2.3 Availability

Availability describes the proportion of time the system is operational and
accessible.

**SLA Tiers (The Nines):**

| SLA | Uptime | Downtime/Year | Downtime/Month | Downtime/Week |
|-----|--------|--------------|----------------|---------------|
| 99% | "Two nines" | 3.65 days | 7.3 hours | 1.68 hours |
| 99.9% | "Three nines" | 8.77 hours | 43.8 minutes | 10.1 minutes |
| 99.95% | "Three and a half nines" | 4.38 hours | 21.9 minutes | 5.04 minutes |
| 99.99% | "Four nines" | 52.6 minutes | 4.38 minutes | 1.01 minutes |
| 99.999% | "Five nines" | 5.26 minutes | 26.3 seconds | 6.05 seconds |

**Critical insight:** Each additional "nine" roughly 10x the cost and
operational complexity. Most applications do not need five nines. Be honest
about what the business actually requires.

**Redundancy Strategies by Tier:**

| SLA Target | Minimum Architecture |
|-----------|---------------------|
| 99% | Single deployment with automated restarts |
| 99.9% | Redundant instances, health checks, automated failover |
| 99.95% | Multi-availability-zone, no single points of failure |
| 99.99% | Multi-region active-active or active-passive with fast failover |
| 99.999% | Multi-region active-active with real-time replication and zero-downtime deployments |

**Failure Domains:**

Availability planning requires thinking in failure domains — groups of
components that can fail together:

```
Process → Host → Rack → Availability Zone → Region → Provider
```

Design so that a failure at one level is contained and does not cascade.
This means: no single points of failure at any level that your SLA demands.

**How to write availability NFRs:**

Bad: "The system should be highly available."
Good: "The system shall maintain 99.95% availability measured monthly,
      excluding planned maintenance windows (max 4 hours/month, scheduled
      with 72-hour notice)."
Good: "Core transaction processing shall remain available during the failure
      of any single availability zone, with automatic failover completing
      within 30 seconds."

### 2.4 Reliability

Reliability describes the system's ability to perform its functions
correctly and consistently over time.

**Key Metrics:**

| Metric | Definition | Example Target |
|--------|-----------|---------------|
| MTBF | Mean Time Between Failures | > 720 hours (30 days) |
| MTTR | Mean Time To Recovery | < 15 minutes for critical services |
| Error rate | Percentage of failed requests | < 0.1% of all requests |
| Data durability | Probability of not losing data | 99.999999999% (eleven nines) |
| Consistency | Data correctness across replicas | Eventual (< 5s) or strong |

**Error Budgets (SRE Approach):**

An error budget is the inverse of availability: if your SLO is 99.9%
availability, your error budget is 0.1% — that is the amount of failure
you can tolerate before action is required.

```
Error budget = 1 - SLO target
Error budget (99.9% SLO) = 0.1% = ~43 minutes/month of downtime
```

Error budgets are powerful because they turn reliability into a measurable,
manageable resource. When the budget is healthy, teams can ship faster and
take more risk. When the budget is depleted, teams must focus on reliability.

**Graceful Degradation Hierarchy:**

Define what happens when things fail, not just that they should not fail:

```
Level 0: Full functionality — everything works as designed
Level 1: Reduced features — non-critical features disabled (e.g., recommendations off)
Level 2: Core only — only essential workflows functional (e.g., checkout works, browsing degraded)
Level 3: Read-only — system serves cached/static content, no writes accepted
Level 4: Maintenance page — system is unavailable, users see status information
```

**How to write reliability NFRs:**

Bad: "The system should be reliable."
Good: "The system shall recover from any single-service failure within 60
      seconds without manual intervention and without data loss for committed
      transactions."
Good: "If the recommendation engine is unavailable, the system shall serve
      results from a static fallback dataset rather than returning errors."

### 2.5 Security

Security describes the system's ability to protect information and functions
from unauthorized access while ensuring authorized access works smoothly.

**Security Requirement Dimensions:**

| Dimension | What to Specify |
|-----------|----------------|
| Authentication | Who can prove their identity and how (MFA, SSO, API keys, certificates) |
| Authorization | Who can do what (RBAC, ABAC, resource-level permissions) |
| Data classification | What data exists and its sensitivity level |
| Encryption | At rest (storage), in transit (network), in use (processing) |
| Audit | What actions are logged, retention period, tamper-proof requirements |
| Compliance | Regulatory frameworks that apply (GDPR, HIPAA, SOC2, PCI-DSS) |
| Vulnerability management | Patching cadence, dependency scanning, penetration testing |

**Data Classification Levels:**

| Level | Description | Encryption | Access Control | Example |
|-------|------------|------------|---------------|---------|
| Public | No damage if disclosed | Optional | Open | Marketing content |
| Internal | Minor damage if disclosed | In transit | Authenticated users | Internal docs |
| Confidential | Significant damage if disclosed | At rest + in transit | Role-based | Customer PII |
| Restricted | Severe damage if disclosed | At rest + in transit + field-level | Named individuals | Financial data, health records |

**How to write security NFRs:**

Bad: "The system should be secure."
Good: "All API endpoints shall require authentication via OAuth 2.0 with
      JWT tokens. Tokens shall expire after 15 minutes with refresh tokens
      valid for 7 days."
Good: "All personally identifiable information (PII) shall be encrypted at
      rest using AES-256 and in transit using TLS 1.2 or higher."
Good: "All administrative actions shall be logged with actor identity,
      timestamp, action performed, and affected resource. Audit logs shall
      be retained for 2 years and be tamper-evident."

### 2.6 Maintainability

Maintainability describes how easily the system can be modified, extended,
debugged, and operated over its lifetime.

**Key Aspects:**

| Aspect | What to Specify | Example Target |
|--------|----------------|---------------|
| Modularity | Component independence, interface boundaries | No component > 500 lines; all inter-service communication via defined APIs |
| Testability | Ability to validate changes | > 80% code coverage; all critical paths have integration tests |
| Analyzability | Ability to diagnose problems | Structured logging with correlation IDs; distributed tracing |
| Modifiability | Effort to make changes | New CRUD endpoint deliverable in < 4 hours by any team member |
| Deployment | Frequency and risk of releases | Zero-downtime deployments; rollback within 5 minutes |

**Complexity Targets:**

| Metric | Healthy | Warning | Danger |
|--------|---------|---------|--------|
| Cyclomatic complexity per function | < 10 | 10-20 | > 20 |
| Lines per function | < 50 | 50-100 | > 100 |
| Lines per file/module | < 300 | 300-500 | > 500 |
| Dependency depth | < 4 levels | 4-6 levels | > 6 levels |
| Build time (full) | < 5 min | 5-15 min | > 15 min |
| Test suite time | < 10 min | 10-30 min | > 30 min |

**How to write maintainability NFRs:**

Bad: "The code should be clean."
Good: "No function shall exceed cyclomatic complexity of 15. This shall
      be enforced by automated linting in the CI pipeline."
Good: "The system shall include structured JSON logging with request
      correlation IDs, enabling end-to-end request tracing across all
      services."

### 2.7 Portability

Portability describes the system's ability to operate across different
environments, platforms, and configurations.

**Portability Dimensions:**

| Dimension | What to Specify |
|-----------|----------------|
| Platform independence | Operating systems, hardware architectures supported |
| Containerization | Container runtime requirements, orchestration assumptions |
| Cloud portability | Multi-cloud readiness, cloud-agnostic service usage |
| Data portability | Export formats, migration tooling, data ownership |
| Configuration | Environment-specific configuration externalization |

**Vendor Lock-in Risk Assessment:**

| Risk Level | Description | Example |
|-----------|------------|---------|
| None | Uses open standards exclusively | PostgreSQL, standard HTTP APIs |
| Low | Uses portable abstractions | Container orchestration, object storage APIs |
| Medium | Uses proprietary services with alternatives | Managed message queues, managed databases |
| High | Uses proprietary services without clear alternatives | Proprietary ML services, serverless-specific patterns |
| Critical | Core logic embedded in vendor-specific platform | Vendor-specific workflow engines, proprietary query languages |

**How to write portability NFRs:**

Bad: "The system should not be locked in to one cloud."
Good: "All infrastructure shall be defined as code using provider-agnostic
      tooling where possible. Core application logic shall not depend on
      cloud-provider-specific SDKs."
Good: "User data shall be exportable in standard formats (JSON, CSV) via
      a self-service API, completing within 24 hours for accounts with
      up to 10GB of data."

### 2.8 Usability

Usability describes how effectively, efficiently, and satisfactorily users
can interact with the system.

**Response Time Perception (Jakob Nielsen's Research):**

| Response Time | User Perception | Implication |
|--------------|----------------|-------------|
| < 100ms | Instantaneous | User feels in direct control |
| 100-300ms | Slight delay | Noticeable but not disruptive |
| 300ms-1s | Noticeable delay | User still feels engaged, show progress |
| 1-5s | Losing attention | Must show loading indicator |
| 5-10s | Frustrating | User may abandon task |
| > 10s | Unacceptable | User will abandon; must redesign interaction |

**Accessibility Levels (WCAG):**

| Level | Description | Typical Requirement |
|-------|------------|-------------------|
| WCAG A | Minimum accessibility | Basic screen reader support, keyboard navigation |
| WCAG AA | Standard accessibility | Sufficient contrast, resizable text, error identification |
| WCAG AAA | Enhanced accessibility | Sign language, extended audio description, highest contrast |

Most organizations should target **WCAG AA** as the baseline. Some industries
and government projects require **WCAG AAA**.

**How to write usability NFRs:**

Bad: "The system should be user-friendly."
Good: "All primary user workflows shall be completable using keyboard
      navigation only, conforming to WCAG 2.1 AA standards."
Good: "First meaningful content shall render within 1.5 seconds on a 4G
      mobile connection for 95% of page loads."

---

## 3. How to Specify NFRs in Blueprints

### The NFR Specification Template

Every NFR in a blueprint should follow this structure:

```
ID:          NFR-[category]-[number]
Category:    [Performance | Scalability | Availability | Reliability |
              Security | Maintainability | Portability | Usability]
Priority:    [Critical | High | Medium | Low]
Statement:   Under [conditions], the system shall [measurable target]
             with [measurement method].
Rationale:   Why this matters to the business.
Trade-offs:  What this NFR costs or conflicts with.
Verification: How we will test/prove compliance.
```

### Bad vs. Good NFR Examples

| Category | Bad | Good |
|----------|-----|------|
| Performance | "Fast response times" | "NFR-PERF-01: Under normal load (up to 500 concurrent users), the system shall respond to search queries within 300ms at the 95th percentile, measured by application performance monitoring." |
| Scalability | "Must scale" | "NFR-SCAL-01: The system shall support horizontal scaling from 2 to 50 instances without code changes, handling up to 50,000 concurrent users with linear throughput increase." |
| Availability | "High availability" | "NFR-AVAIL-01: The system shall maintain 99.95% monthly availability, measured as successful HTTP responses (non-5xx) divided by total requests." |
| Security | "Must be secure" | "NFR-SEC-01: All user sessions shall timeout after 30 minutes of inactivity. Re-authentication shall be required for sensitive operations regardless of session state." |
| Maintainability | "Clean code" | "NFR-MAINT-01: Automated test coverage shall exceed 80% for business logic modules, verified by CI pipeline on every pull request." |

### How NFRs Drive Architecture Decisions

NFRs are not just documentation — they are the primary input to
architectural decision-making. Here is how specific NFRs translate to
architectural choices:

```
NFR: "99.99% availability"
  → Multi-AZ or multi-region deployment required
  → No single points of failure in any component
  → Automated failover and health checking
  → Estimated infrastructure cost: 3-5x vs. single deployment
  → Operational cost: dedicated on-call rotation

NFR: "Sub-50ms P99 response time"
  → In-memory caching layer required
  → Pre-computation of expensive queries
  → Proximity to users (CDN, edge)
  → Likely eliminates relational DB for hot path
  → Team needs performance engineering expertise

NFR: "HIPAA compliance"
  → Encryption at rest and in transit mandatory
  → Audit logging for all data access
  → Business Associate Agreements with all vendors
  → Annual security assessments
  → Incident response plan required
  → Adds 2-4 months to initial development timeline

NFR: "Handle 10x traffic within 5 minutes"
  → Auto-scaling infrastructure required
  → Stateless application tier
  → Connection pooling and queue-based load leveling
  → Pre-provisioned capacity or serverless for burst
  → Load testing as part of regular CI/CD
```

### The NFR Trade-offs Matrix

You cannot maximize every quality attribute simultaneously. Architecture
is the art of making informed trade-offs. Common tensions:

```
Performance  ←→  Security      (encryption adds latency)
Availability ←→  Consistency   (CAP theorem)
Scalability  ←→  Simplicity    (distributed = complex)
Security     ←→  Usability     (more friction = fewer users)
Performance  ←→  Maintainability (optimized code is harder to read)
Portability  ←→  Performance   (abstractions add overhead)
Cost         ←→  Nearly everything (more nines = more money)
```

When documenting a blueprint, make trade-offs explicit:

```markdown
## Trade-off Decision: Availability vs. Consistency

We chose eventual consistency (< 2 second propagation) for user profile
data to enable multi-region active-active deployment. This means a user
who updates their profile may see stale data for up to 2 seconds if
their next request is routed to a different region.

**Accepted because:** Profile updates are infrequent (< 1/day/user) and
brief staleness has negligible user impact. The availability benefit of
active-active (99.99% vs. 99.95%) justifies this trade-off for our
user base of 2M+ distributed globally.
```

---

## 4. Capacity Planning

### Estimating Load

Capacity planning starts with understanding the load profile. Gather or
estimate these numbers:

```
1. Total users (registered accounts or addressable market)
2. Active users (DAU/MAU ratio — typically 10-30% for most apps)
3. Concurrent users (typically 5-15% of DAU at peak)
4. Requests per user per session (varies by app type)
5. Session duration and frequency
6. Peak-to-average ratio (typically 2-5x for most apps)
7. Growth rate (monthly or annual)
```

**Load estimation formula:**

```
Requests/second (average) = DAU x requests_per_session x sessions_per_day
                            / seconds_per_day (86,400)

Requests/second (peak)    = average_rps x peak_multiplier

Example:
  100,000 DAU x 50 requests/session x 2 sessions/day / 86,400
  = ~116 requests/second average
  x 4 (peak multiplier for diurnal pattern)
  = ~464 requests/second peak
```

### Back-of-Envelope Calculations

Every architect should be able to do rough capacity math quickly. Key
reference numbers:

**Compute:**
```
Single modern server: ~10,000-50,000 simple HTTP requests/second
Single database connection: ~1,000-5,000 queries/second (simple reads)
Single message queue consumer: ~1,000-10,000 messages/second
```

**Storage:**
```
1 million rows of typical user data: ~100MB-1GB
1 million images (1MB each): ~1TB
1 million log entries/day (1KB each): ~1GB/day = ~365GB/year
```

**Network:**
```
1 Gbps link: ~125 MB/second actual throughput
Typical API response: 1-10KB
Typical page load (all assets): 500KB-5MB
```

**Quick sizing example:**

```
Question: How much storage for 1 year of user activity logging?

Given: 100K DAU, ~200 events/user/day, ~500 bytes/event average

Calculation:
  100,000 users x 200 events x 500 bytes = 10 GB/day
  10 GB x 365 days = 3.65 TB/year
  With indexes and overhead (2x): ~7.3 TB/year
  With replication (3x): ~22 TB/year total storage
```

### The 10x Rule

**Design for 10x. Plan for 100x.**

- **Design for 10x:** The architecture should handle 10x current load
  without fundamental redesign. This means choosing patterns and
  technologies that scale, avoiding hardcoded limits, and maintaining
  horizontal scaling capability.

- **Plan for 100x:** Have a documented plan for what changes would be
  needed at 100x. This does not mean building for 100x today — that
  would be wasteful. It means knowing where the bottlenecks would appear
  and having a roadmap for addressing them.

- **Build for 1x-2x:** Actually provision for current load plus a
  reasonable buffer. Do not pay for 10x infrastructure today.

```
Current load:    1,000 requests/second
Build for:       1,500-2,000 rps (provision this)
Design for:      10,000 rps (architecture supports this without redesign)
Plan for:        100,000 rps (documented path to reach this; may require
                 new architecture components like sharding, CQRS, etc.)
```

### Load Testing vs. Estimation

| Approach | When to Use | Strengths | Limitations |
|----------|-------------|-----------|-------------|
| Estimation | Early planning, budgeting, architecture selection | Fast, cheap, good for ballpark | Can miss real-world bottlenecks |
| Load testing | Pre-launch validation, capacity verification | Reveals actual bottlenecks, accurate | Requires working system, costs time |
| Production monitoring | After launch | Real data, continuous | Requires production traffic |

**Load testing types:**

| Type | Purpose | Pattern |
|------|---------|---------|
| Baseline | Establish normal performance | Steady load at expected average |
| Stress | Find breaking point | Increasing load until failure |
| Spike | Test burst handling | Sudden 5-10x load increase |
| Soak | Find memory leaks, resource exhaustion | Sustained load for 24-72 hours |
| Breakpoint | Determine max capacity | Ramp until specific SLO is violated |

### Cost Implications

Over-provisioning wastes money. Under-provisioning loses users and revenue.
The sweet spot depends on the cost of downtime:

```
Cost of over-provisioning = excess infrastructure cost/month
Cost of under-provisioning = lost revenue + reputation damage + recovery cost

If downtime costs $10,000/hour and excess capacity costs $500/month,
over-provisioning is obviously cheaper.

If downtime costs $10/hour and excess capacity costs $5,000/month,
right-sizing matters more.
```

Always calculate both sides and present to stakeholders.

---

## 5. Performance Budgets

### Web Performance: Core Web Vitals

Core Web Vitals are the industry standard for measuring user-facing
web performance:

| Metric | What It Measures | Good | Needs Improvement | Poor |
|--------|-----------------|------|-------------------|------|
| LCP (Largest Contentful Paint) | Loading speed | < 2.5s | 2.5-4.0s | > 4.0s |
| FID (First Input Delay) | Interactivity | < 100ms | 100-300ms | > 300ms |
| INP (Interaction to Next Paint) | Responsiveness | < 200ms | 200-500ms | > 500ms |
| CLS (Cumulative Layout Shift) | Visual stability | < 0.1 | 0.1-0.25 | > 0.25 |

**Blueprint specification example:**

```markdown
## Web Performance Budget

| Metric | Target | Measurement Condition |
|--------|--------|----------------------|
| LCP | < 2.0s | 4G mobile, mid-tier device, 75th percentile |
| INP | < 150ms | All interactions, 75th percentile |
| CLS | < 0.05 | Full page lifecycle |
| TTFB | < 500ms | Origin response, 95th percentile |
| Total page weight | < 1.5MB | Initial load, compressed |
| JavaScript bundle | < 300KB | Main bundle, compressed |
```

### API Performance Budgets

Assign latency budgets by endpoint classification:

| Tier | P95 Target | P99 Target | Examples |
|------|-----------|-----------|---------|
| Critical path | < 100ms | < 250ms | Authentication, checkout, payment |
| Standard read | < 200ms | < 500ms | List/detail views, search results |
| Standard write | < 500ms | < 1s | Create/update operations |
| Complex query | < 2s | < 5s | Reporting, aggregations, analytics |
| Batch/async | N/A (queue-based) | N/A | File processing, bulk import |

**Budget allocation across the stack:**

For a 200ms total budget, break down where time is spent:

```
Network (client → LB):      10ms
Load balancer:                2ms
Application processing:      50ms
  - Authentication:          10ms
  - Business logic:          25ms
  - Serialization:           15ms
Database queries:            80ms
  - Primary query:           50ms
  - Secondary lookups:       30ms
External service calls:      40ms
Network (LB → client):      10ms
Buffer:                       8ms
─────────────────────────────────
Total budget:               200ms
```

This breakdown reveals where optimization effort should focus and where
caching or pre-computation might be needed.

### Database Query Time Budgets

| Query Type | Target | Notes |
|-----------|--------|-------|
| Simple key lookup | < 5ms | By primary key or indexed field |
| Indexed query | < 20ms | WHERE clause on indexed columns |
| Join query (2-3 tables) | < 50ms | With proper indexes |
| Complex aggregation | < 200ms | GROUP BY with filters |
| Full-text search | < 100ms | Using search index |
| Reporting query | < 5s | Complex joins, large datasets |

**Anti-pattern:** Allowing unbounded queries in user-facing endpoints.
Always enforce query limits (pagination, max result count) and timeout
thresholds.

### Frontend Bundle Size Budgets

| Asset Type | Budget (compressed) | Rationale |
|-----------|-------------------|-----------|
| HTML | < 50KB | Minimal; most content is dynamic |
| CSS (total) | < 100KB | Covers all styles including framework |
| JavaScript (main bundle) | < 150KB | Core application logic |
| JavaScript (total) | < 400KB | Including lazy-loaded chunks |
| Images (above the fold) | < 200KB | Critical rendering path |
| Fonts | < 100KB | Limit to 2-3 font files |
| Total initial load | < 1MB | First meaningful paint budget |

---

## 6. SLA/SLO/SLI Framework

### Definitions

The SLA/SLO/SLI framework, popularized by Google's Site Reliability
Engineering practice, provides a structured way to define, measure, and
manage service reliability.

```
SLI (Service Level Indicator)
  = What you MEASURE
  = A quantitative metric of service behavior
  Example: "Proportion of HTTP requests that return a 2xx status code"

SLO (Service Level Objective)
  = What you TARGET
  = An internal goal for an SLI
  Example: "99.9% of requests shall return 2xx over a 30-day window"

SLA (Service Level Agreement)
  = What you PROMISE
  = A contractual commitment with consequences for breach
  Example: "99.5% availability; customer receives 10% service credit
            for each 0.1% below target"
```

**Key principle:** SLO > SLA. Your internal target should always be
stricter than your contractual promise. If your SLA is 99.9%, your SLO
should be 99.95% or higher. This gives you a buffer before contractual
penalties apply.

### Choosing Good SLIs

Good SLIs are:
- **Measurable** — can be computed from actual telemetry
- **User-centric** — reflect what users experience, not internal metrics
- **Actionable** — when the SLI degrades, the team knows what to investigate

**SLI Selection by Service Type:**

| Service Type | Primary SLIs |
|-------------|-------------|
| HTTP/API service | Availability (success rate), latency (P50, P95, P99), throughput |
| Data pipeline | Freshness (data age), correctness (error rate), completeness (coverage) |
| Storage system | Durability, availability, latency |
| Batch/scheduled job | Completion rate, execution time, correctness |
| Messaging/queue | Delivery rate, processing latency, dead letter rate |

### Setting SLOs

SLO-setting is a negotiation between ambition and pragmatism:

**Step 1:** Measure current performance (you cannot set a target without a baseline)

**Step 2:** Determine user expectations (what would users notice? what would cause them to leave?)

**Step 3:** Consider the cost of each reliability increment

**Step 4:** Set the SLO slightly above the minimum acceptable and well below 100%

```
Why not 100%? Because:
- 100% reliability is infinitely expensive
- 100% means you can never deploy (deployments carry risk)
- 100% means you can never do maintenance
- Users don't actually notice the difference between 99.99% and 100%
```

**SLO Example Set:**

```markdown
## Service: User Authentication API

### Availability SLO
- SLI: Proportion of non-5xx responses to total requests
- Target: 99.95% over a rolling 30-day window
- Measurement: Application load balancer access logs

### Latency SLO
- SLI: Time from request received to response sent
- Target P50: 50ms
- Target P95: 150ms
- Target P99: 300ms
- Measurement: Application performance monitoring (server-side)

### Correctness SLO
- SLI: Proportion of authentication decisions that match expected outcome
- Target: 99.999% (false positive rate < 0.001%)
- Measurement: Automated correctness testing suite, anomaly detection
```

### Error Budgets in Practice

The error budget is the most powerful concept in the SRE framework.

```
Monthly error budget for 99.95% SLO:
  Total minutes in 30 days: 43,200
  Allowed failure: 0.05% = 21.6 minutes

If the service has been down for 15 minutes this month:
  Remaining budget: 6.6 minutes
  Budget consumed: 69.4%
  Action: Freeze risky deployments, focus on stability
```

**Error budget policies (example):**

| Budget Remaining | Allowed Actions |
|-----------------|----------------|
| > 50% | Normal development velocity; deploy at will |
| 25-50% | Increased caution; require extra review for risky changes |
| 10-25% | Freeze non-critical deployments; focus on reliability |
| < 10% | Emergency mode; only reliability fixes deployed |
| Exhausted | Full deployment freeze until budget resets or root cause resolved |

### Negotiating SLAs with Stakeholders

**Common stakeholder conversations:**

Stakeholder: "We need 99.99% availability."
Architect: "That requires multi-region deployment and dedicated on-call.
           Infrastructure cost increases from $5K to $25K/month. The
           expected revenue impact of dropping to 99.95% is approximately
           $2K/month in lost transactions during additional downtime.
           Do we want to spend $20K/month to save $2K?"

Stakeholder: "All responses must be under 100ms."
Architect: "Under what conditions? At current load of 100 concurrent
           users, we can achieve that. At projected load of 10,000
           concurrent users, that requires a caching layer and CDN
           adding $8K/month. At 100ms P99, we need to pre-compute
           all expensive queries. Which endpoints are truly latency-
           sensitive?"

**Negotiation principles:**
1. Always quantify the cost of each reliability increment
2. Distinguish between what users need and what stakeholders want
3. Propose tiers — different SLAs for different services/endpoints
4. Include escape clauses for planned maintenance and force majeure
5. Define measurement methodology precisely — ambiguity breeds disputes

---

## 7. NFR Prioritization

### Not All NFRs Are Equal

A system with 30 NFRs all marked "Critical" has zero useful NFRs. Effective
architecture requires honest prioritization.

**Priority levels:**

| Priority | Definition | Architectural Impact |
|----------|-----------|---------------------|
| Critical | System is unusable without this | Core architectural driver; must be satisfied |
| High | Significant user/business impact | Strongly influences design; can be relaxed slightly |
| Medium | Noticeable impact but workarounds exist | Considered in design; may be deferred for MVP |
| Low | Nice to have; improves polish | Documented but not an architectural driver |

### The "Pick Two" Framework

When quality attributes conflict (and they always do), use this framework
to force honest prioritization:

**Classic tensions:**

```
1. Fast, Cheap, Good — pick two
2. Consistent, Available, Partition-tolerant — pick two (CAP theorem)
3. Secure, Usable, Fast — pick two (usually)
```

In practice, you are not literally picking two and abandoning the third. You
are choosing which two you will optimize and which one you will satisfice
(meet a minimum acceptable level rather than optimizing).

**Example prioritization for an e-commerce system:**

```
OPTIMIZE (primary drivers):
  - Availability (revenue directly tied to uptime)
  - Performance (conversion rate drops 7% per second of load time)

SATISFICE (minimum acceptable):
  - Security (must meet PCI-DSS, but beyond compliance is not differentiating)
  - Maintainability (good enough to ship features monthly)

ACCEPT TRADE-OFF:
  - Portability (acceptable to use cloud-specific services for cost/speed)
```

### Running a Quality Attribute Workshop

A Quality Attribute Workshop (QAW) is a structured technique for eliciting
and prioritizing NFRs with stakeholders.

**Workshop structure (2-4 hours):**

```
1. CONTEXT (30 min)
   - Present business goals and key drivers
   - Present architectural approach at high level
   - Ensure shared understanding

2. SCENARIOS (60 min)
   - Each stakeholder writes quality attribute scenarios on cards
   - Format: "When [stimulus] occurs under [conditions],
              the system should [response] within [measure]"
   - Example: "When 5,000 users simultaneously search for products
              during a flash sale, the system should return results
              within 2 seconds for 95% of requests"

3. PRIORITIZATION (45 min)
   - Each stakeholder gets N votes (typically = scenarios / 3)
   - Vote on the scenarios they care about most
   - Tally votes; rank scenarios by total votes

4. REFINEMENT (45 min)
   - Take top-voted scenarios
   - Refine into measurable NFRs
   - Discuss trade-offs between competing high-priority items
   - Assign architectural owner for each NFR

5. DOCUMENTATION (post-workshop)
   - Architect documents all NFRs in the blueprint
   - Includes rationale and trade-off decisions
   - Circulates for stakeholder sign-off
```

### Decision Matrix for NFR Conflicts

When two NFRs conflict, use this structured approach:

```markdown
## NFR Conflict Resolution

**Conflict:** NFR-PERF-01 (sub-100ms responses) vs NFR-SEC-03 (encrypt
all data at field level)

**Analysis:**

| Factor | NFR-PERF-01 | NFR-SEC-03 |
|--------|------------|------------|
| Business impact of violation | 5% conversion loss | Regulatory fine, breach risk |
| Users affected | All users | All users (if breached) |
| Cost to achieve both | Field-level encryption adds ~20ms | Would need faster hardware/caching |
| Reversibility if wrong | Can optimize later | Cannot un-breach data |
| Stakeholder priority | High (Product team) | Critical (Legal, Security) |

**Decision:** Security takes precedence. Accept 120ms target for encrypted
endpoints. Mitigate performance impact through:
1. Hardware-accelerated encryption
2. Caching decrypted results for authorized sessions (TTL: 5 min)
3. Monitoring actual latency; optimize if P95 exceeds 150ms

**Accepted by:** [stakeholder names and date]
```

### Common Anti-Patterns in NFR Management

**Anti-pattern 1: Copy-paste NFRs**
Using the same NFRs from a previous project without adapting to the current
context. A real-time trading platform and a content management system have
fundamentally different quality attribute priorities.

**Anti-pattern 2: The "should" trap**
Using "should" instead of "shall" makes NFRs advisory rather than mandatory.
In contract language: "shall" = required, "should" = nice to have,
"may" = optional.

**Anti-pattern 3: Unmeasurable NFRs**
"The system shall be user-friendly" is not an NFR. It is a wish. Every NFR
must have a measurement method and a numeric threshold.

**Anti-pattern 4: All-or-nothing thinking**
"We need 99.99% availability for everything." No, you need 99.99% for
checkout and 99.9% for the recommendation engine. Differentiate.

**Anti-pattern 5: Ignoring NFR costs**
Every NFR has a cost in money, complexity, and time. Blueprints should
include rough cost implications for significant NFRs so stakeholders make
informed decisions.

**Anti-pattern 6: Set and forget**
NFRs must be continuously monitored in production. An NFR that is not
measured is not enforced, and an NFR that is not enforced does not exist.

**Anti-pattern 7: NFRs as afterthought**
Adding NFRs after the architecture is designed. By then, the fundamental
decisions are made and retrofitting quality attributes is 5-10x more
expensive than designing for them from the start.

---

## Quick Reference: NFR Blueprint Checklist

Before finalizing any blueprint, verify these items:

```
[ ] At least one measurable NFR per quality attribute category
[ ] Each NFR has: conditions, measurable target, measurement method
[ ] NFRs are prioritized (Critical/High/Medium/Low)
[ ] Trade-offs between competing NFRs are documented
[ ] Cost implications of significant NFRs are estimated
[ ] SLIs and SLOs are defined for all user-facing services
[ ] Graceful degradation levels are specified
[ ] Capacity estimates with 10x headroom are documented
[ ] Performance budgets are allocated across the stack
[ ] Security data classification is defined
[ ] Compliance requirements are identified
[ ] Each NFR has an explicit verification method
[ ] Stakeholders have reviewed and accepted trade-offs
```

---

## Further Reading

These topics are covered in depth in the canonical texts on software
architecture and site reliability:

- ISO/IEC 25010 — Systems and software quality models
- The SEI Quality Attribute Workshop methodology
- Google SRE: error budgets, SLI/SLO/SLA framework
- Performance engineering: capacity planning, load testing
- The Architecture Tradeoff Analysis Method (ATAM)
- TOGAF quality attribute guidance

---

*This document provides universal professional knowledge for software
architecture planning. It is not tied to any specific project, technology
stack, or organizational context. Apply these frameworks by adapting the
specific numbers and priorities to each project's unique requirements.*
