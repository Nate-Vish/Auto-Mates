# Technology Stack Evaluation Guide
**Category:** Planning
**Sources:**
- https://fullscale.io/blog/how-to-choose-tech-stack/
- https://fullscale.io/blog/build-vs-buy-software-development-decision-guide/
- https://neontri.com/blog/build-vs-buy-software/
- https://www.baytechconsulting.com/blog/rethink-build-vs-buy-2025
- https://www.baytechconsulting.com/blog/build-vs-buy-strategic-framework-2025
- https://www.thoughtworks.com/radar
- https://www.thoughtworks.com/about-us/news/2025/thoughtworks-tech-radar-33-rapid-ai
- https://www.ml4devs.com/articles/datastore-choices-sql-vs-nosql-database/
- https://designgurus.substack.com/p/sql-vs-nosql-the-definitive-decision
- https://www.integrate.io/blog/the-sql-vs-nosql-difference/
- https://www.graphapp.ai/blog/build-vs-buy-framework-a-mckinsey-analysis

**Last updated:** 2026-03-01

---

## 1. Technology Stack Decision Criteria

Choosing a tech stack is one of the most consequential decisions in a project. It's hard to reverse, affects every subsequent decision, and has implications far beyond the code itself.

### The Six Evaluation Dimensions

| Dimension | Key Questions | Weight |
|-----------|---------------|--------|
| **Team Expertise** | Does the team know this? How long to ramp up? | Critical |
| **Maturity & Stability** | Battle-tested? Stable API? Regular releases? | High |
| **Community & Ecosystem** | Active community? Libraries? Stack Overflow answers? | High |
| **Performance** | Meets our throughput/latency requirements? | Medium-High |
| **Hiring Pool** | Can we hire developers for this? At what cost? | Medium-High |
| **Long-term Viability** | Who maintains it? Company backing? Adoption trend? | Medium |

### Scoring Method

For each candidate technology, rate each dimension from 1 (poor) to 5 (excellent) and multiply by a weight (1-3):

```
Score = Sum of (Rating x Weight) for all dimensions
```

**Example:**

| Dimension | Weight | React | Vue | Svelte |
|-----------|--------|-------|-----|--------|
| Team expertise | 3 | 5 (15) | 3 (9) | 1 (3) |
| Maturity | 2 | 5 (10) | 4 (8) | 3 (6) |
| Community | 2 | 5 (10) | 4 (8) | 3 (6) |
| Performance | 1 | 4 (4) | 4 (4) | 5 (5) |
| Hiring pool | 2 | 5 (10) | 3 (6) | 2 (4) |
| Long-term viability | 1 | 5 (5) | 4 (4) | 3 (3) |
| **Total** | | **54** | **39** | **27** |

In this example, the team knows React well and needs to hire -- so React wins despite Svelte's technical edge. The scoring makes the reasoning explicit and auditable.

### What NOT to Base Decisions On

| Bad Reason | Why It's Bad | Better Alternative |
|-----------|-------------|-------------------|
| "It's the latest thing" | New doesn't mean better. New means unproven. | Check ThoughtWorks Radar ring (Adopt vs. Assess) |
| "HN/Reddit says it's the best" | Online opinions skew toward novelty | Look at production use cases in similar domains |
| "Our lead developer loves it" | Personal preference != team fit | Score against all 6 dimensions |
| "Company X uses it" | Their scale, team, and constraints differ from yours | Understand WHY they chose it |
| "It has the most GitHub stars" | Stars measure marketing, not quality | Check commit activity, issue response time, release cadence |

---

## 2. Framework Selection: How to Actually Compare

### The "Why X Over Y" Framework

Don't just pick a framework. Document the comparison so the decision is reviewable:

```
Decision: Use Next.js for the web application

Considered: Next.js, Remix, SvelteKit, plain React + Vite

Why Next.js:
- Team has 3 developers with Next.js experience
- Server-side rendering needed for SEO
- Vercel hosting simplifies deployment
- Largest community and most third-party packages

Why not Remix:
- Only 1 team member has experience
- Smaller ecosystem of compatible libraries

Why not SvelteKit:
- No team experience
- Smaller hiring pool if we need to expand

Why not plain React + Vite:
- Would need to build SSR infrastructure manually
- More configuration overhead for what Next.js provides out of the box
```

### Frontend Framework Decision Tree

```
Do you need SEO / server-side rendering?
  YES --> Next.js (React) or Nuxt (Vue) or SvelteKit
  NO  --> Does the team know React?
            YES --> React + Vite (or Next.js if you might need SSR later)
            NO  --> Is this a small/medium project?
                      YES --> Vue (lower learning curve)
                      NO  --> Consider team training on React (largest ecosystem)
```

### Backend Framework Decision Tree

```
What language does the team know?
  TypeScript/JS --> Node.js: Express (simple), Fastify (performance), NestJS (enterprise)
  Python       --> FastAPI (modern, async), Django (batteries-included), Flask (minimal)
  Go           --> Standard library + Chi/Gin (performance-critical services)
  Java/Kotlin  --> Spring Boot (enterprise standard)
  Rust         --> Axum/Actix (systems-level performance needs)
  C#           --> ASP.NET Core (Microsoft ecosystem)

Is this a startup/MVP?
  YES --> Use the language your team is fastest in. Speed > optimization.
  NO  --> Match language strengths to system requirements.
```

---

## 3. Build vs. Buy vs. Open Source

### The 3-Model Decision Framework

The old binary "build vs. buy" is outdated. The real options are:

| Model | What It Means | Best For |
|-------|---------------|----------|
| **Build** | Custom development from scratch | Core differentiators, unique business logic |
| **Buy** | License commercial software (SaaS/COTS) | Commodity functions, non-differentiating |
| **Compose** | Open source + custom integration | Semi-custom needs, tight budgets, composable architectures |

### The Strategic Differentiation Test

This is the single most important question:

> **"If our competitor bought the same software, would they have the same competitive advantage?"**

- **If YES:** Buy it. Spending engineering time on non-differentiating functionality is waste.
- **If NO:** Build it. This is where your product's unique value lives.

**Examples:**

| Function | Build or Buy? | Why |
|----------|--------------|-----|
| User authentication | **Buy** (Auth0, Clerk, Supabase Auth) | Auth is not your product. It's solved. |
| Payment processing | **Buy** (Stripe, Paddle) | Unless you're a fintech, payments aren't your differentiator |
| CMS / content management | **Buy or Compose** (Strapi, Sanity, Contentful) | Unless content IS your product |
| Your core algorithm/engine | **Build** | This is literally your competitive advantage |
| Email sending | **Buy** (SendGrid, Resend, Postmark) | Email delivery is infrastructure, not product |
| Analytics dashboard | **Depends** | Buy for internal analytics. Build if analytics IS your product |
| Admin panel | **Compose** (Retool, AdminJS) | Admin tools for internal use rarely justify custom builds |

### Total Cost of Ownership (TCO) Analysis

Look beyond the sticker price. Over 5 years:

| Cost Category | Build | Buy |
|------|-------|-----|
| Initial development | $$$$ | $ |
| Licensing / subscription | $0 | $$ per year (rising) |
| Customization | Included (it's your code) | $-$$$ (may require workarounds) |
| Maintenance | $$ per year (declining) | Included (vendor handles it) |
| Integration | $ (full control) | $-$$$$ (depends on vendor APIs) |
| Migration risk | $0 | $$$$ (vendor lock-in) |
| **Break-even point** | **~33 months for mid-market** | |

**Key insight:** 65% of total software costs occur after initial deployment. The cheapest-to-build option is often not the cheapest-to-own option.

### The "Bounded Buy" (Hybrid Approach)

The most sophisticated approach: buy a commercial platform for commodity functions, but draw a hard architectural boundary around it so you can replace it later.

**How it works:**
1. Buy the commercial tool (e.g., Stripe for payments)
2. Wrap it in your own abstraction layer (your PaymentService interface)
3. Your code never calls Stripe directly -- it calls your abstraction
4. If you need to switch providers, you only rewrite the adapter, not the entire codebase

**This is the recommended default for most projects.** It gives you speed now with flexibility later.

---

## 4. Database Selection: SQL vs. NoSQL Decision Tree

### The Decision Tree

```
START: What does your data look like?

Is your data structured with clear relationships (users have orders, orders have items)?
  YES --> Do you need ACID transactions (financial data, inventory, bookings)?
            YES --> SQL (PostgreSQL recommended)
            NO  --> Do you need massive write throughput at scale?
                      YES --> Consider NoSQL document store
                      NO  --> SQL (simpler, more versatile)
  NO  --> Is your data document-shaped (JSON blobs, nested objects, variable schemas)?
            YES --> NoSQL Document Store (MongoDB, DynamoDB)
            NO  --> Is your data a graph of relationships (social networks, recommendations)?
                      YES --> Graph Database (Neo4j)
                      NO  --> Is it key-value pairs needing ultra-fast lookups?
                                YES --> Key-Value Store (Redis, DynamoDB)
                                NO  --> Re-evaluate your data model
```

### SQL vs. NoSQL Comparison

| Factor | SQL (PostgreSQL/MySQL) | NoSQL (MongoDB/DynamoDB) |
|--------|----------------------|--------------------------|
| **Data structure** | Tables, rows, columns, strict schema | Documents, key-value, flexible schema |
| **Relationships** | Joins, foreign keys, referential integrity | Embedded documents, manual references |
| **Schema changes** | Migration required, can be painful | Flexible, fields added on the fly |
| **Transactions** | Full ACID | Usually BASE (eventual consistency) |
| **Scaling** | Vertical (bigger server) or read replicas | Horizontal (add more nodes) |
| **Query power** | Complex joins, aggregations, subqueries | Simple lookups, limited joins |
| **Best for** | Financial data, e-commerce, CMS, anything with clear relationships | IoT, real-time analytics, content feeds, catalogs with variable attributes |

### Polyglot Persistence (Use Both)

Modern applications often use multiple databases:

| Use Case | Database |
|----------|----------|
| User accounts, orders, billing | PostgreSQL (relational, ACID) |
| Session data, caching | Redis (key-value, fast) |
| Product catalog with variable attributes | MongoDB (document, flexible schema) |
| Full-text search | Elasticsearch |
| Analytics / OLAP | ClickHouse or BigQuery |
| Real-time events / messaging | Kafka (event stream) |

### Default Recommendation

**When in doubt, start with PostgreSQL.** It handles 90% of use cases well:
- Relational data with full ACID compliance
- JSON/JSONB columns for semi-structured data
- Full-text search built-in
- Excellent performance with proper indexing
- Massive community and tooling
- Can scale surprisingly far with read replicas and connection pooling

Add specialized databases only when PostgreSQL demonstrably can't handle a specific workload.

---

## 5. When to Use New Technology vs. Proven Stack

### The Innovation Tokens Model

Every project gets a limited number of "innovation tokens." Each new/unproven technology you adopt spends one. Most projects can afford 1-2 innovation tokens, not 5.

**Spend innovation tokens on:**
- Technology that directly enables your core differentiator
- Cases where the proven option genuinely can't do the job
- Areas where the team has deep expertise in the new tech

**Don't spend innovation tokens on:**
- "Resume-driven development" (picking tech because developers want to learn it)
- Infrastructure that needs to be boring and reliable (databases, auth, CI/CD)
- Anything where failure means extended debugging with no community resources

### ThoughtWorks Technology Radar Rings

Use the ThoughtWorks Technology Radar as a decision input:

| Ring | Meaning | Risk Level | When to Use |
|------|---------|------------|-------------|
| **Adopt** | Industry-proven, widely used | Low | Default choice for production |
| **Trial** | Promising, used successfully in production by early adopters | Medium | If it solves a specific problem better than Adopt options |
| **Assess** | Worth exploring, not production-proven | Medium-High | Spike/prototype only, not for core product |
| **Hold** | Proceed with caution, known issues | High | Avoid for new projects, migrate away if using |

### The Boring Technology Thesis

From Dan McKinley's "Choose Boring Technology":
- Every technology choice carries an operational cost
- Well-understood, "boring" technology has lower operational cost because failures are well-documented and solutions are googleable
- Save your complexity budget for your product, not your infrastructure

**Practical rule:** Your tech stack should be boring everywhere except where boring can't solve the problem.

---

## 6. Technology Stack Anti-Patterns

| Anti-Pattern | Description | Consequence |
|---|---|---|
| **Resume-Driven Development** | Choosing tech to pad resumes, not solve problems | Team moves on, orphaned codebase in obscure tech |
| **Framework Hopping** | Switching frameworks between projects without justification | No accumulated expertise, constant re-learning |
| **Silver Bullet Thinking** | "If we just switch to X, all our problems go away" | Problems are usually organizational, not technological |
| **Hype-Driven Development** | Adopting whatever HN/Twitter is excited about this month | Unstable dependencies, missing documentation, dead-end tech |
| **Premature Microservices** | Splitting into 20 services before you have product-market fit | Distributed systems complexity for a problem that doesn't exist yet |
| **Not Invented Here** | Building everything custom when solid solutions exist | Wasted engineering time on solved problems |
| **Vendor Lock-In Paralysis** | Refusing to use any managed service for fear of lock-in | Building commodity infrastructure instead of your product |

---

## Planner's Application

When evaluating technology stacks for blueprints, Planner should:

1. **Include a Technology Decision Record (TDR) in every blueprint.** For each major technology choice, document: what was chosen, what alternatives were considered, and why this choice was made. Use the scoring method from Section 1.

2. **Apply the Strategic Differentiation Test for build-vs-buy.** Every component in the architecture should be labeled: Build (core differentiator), Buy (commodity), or Compose (open source + custom). If something is labeled "Build" but isn't a differentiator, challenge it.

3. **Default to PostgreSQL unless there's a specific reason not to.** Document the reason for any non-PostgreSQL database choice. "We need document storage" is valid. "MongoDB is cool" is not.

4. **Count innovation tokens.** For each blueprint, list the unproven/new technologies being adopted and justify each one. If the count exceeds 2, push back and ask which innovations are truly necessary.

5. **Specify the operational implications.** A tech stack isn't just "what we build with" -- it's "what we run and maintain." Include in the blueprint: hosting approach, deployment strategy, monitoring requirements, and who maintains each component.

6. **Plan for the team you have, not the team you want.** If the team knows Python, the blueprint should default to Python unless there's a compelling technical reason to switch. Training costs and ramp-up time must be factored into the plan.

7. **Include a "what changes at scale" section.** Document which parts of the stack will need revisiting when the product grows 10x. This prevents premature optimization while ensuring the team knows where the pressure points will be.
