# Senior Engineering Practices
**When to use:** Read when doing code reviews, making architectural decisions, managing tech debt, writing RFCs, or responding to incidents.

---

## Code Review

### Giving Good Reviews

**Start with the big picture.** Read the PR description and skim the full diff before commenting on any single line. Ask: Does this approach solve the right problem? Is the architecture sound?

**Be specific and actionable.** "Consider renaming `processData` to `validateAndTransformOrder`" not "this is confusing."

**Use clear severity prefixes:**
- `[must]` — Blocks merge. Correctness, security, or data integrity issue.
- `[suggestion]` — I think this would be better, but it's your call.
- `[nit]` — Trivial style preference. Ignore if you want.
- `[question]` — I want to understand, not necessarily change.

**Review tests as carefully as implementation.** Tests reveal intent. If tests are unclear, requirements are probably unclear too. Ask: do these cover failure modes? What about boundaries?

**Praise good work.** Positive reinforcement shapes team culture more than criticism.

### Receiving Reviews

- Assume good intent — re-read harsh comments with the kindest interpretation
- Respond to every comment, even just "Done" or "Good point, fixed"
- Know when to push back — explain reasoning with data, not opinions
- Separate your ego from your code — it's a shared artifact, not your identity

### Code Review Checklist

| Category | What to Check |
|----------|---------------|
| **Correctness** | Does it do what the ticket says? Edge cases? Off-by-one errors? |
| **Readability** | Could a new team member understand this in six months? |
| **Performance** | N+1 queries? Unnecessary loops? Large allocations in hot paths? |
| **Security** | Input validation? SQL injection? XSS? Auth checks? Secrets in code? |
| **Testing** | Tests present? Do they test behavior, not implementation? Happy AND sad paths? |
| **Error handling** | What happens when things fail? Errors logged with context? |
| **API design** | Public interfaces minimal and intuitive? Breaking changes flagged? |
| **Dependencies** | New dependency justified? License compatible? Actively maintained? |

### Review Anti-Patterns

- **Rubber-stamping** — Approving without reading. Worse than no review.
- **Nitpicking style over substance** — Let the linter handle formatting.
- **Blocking on opinions** — "I would have done it differently" is not a merge blocker.
- **Review hoarding** — One person reviewing everything creates a bottleneck and knowledge silo.
- **Drive-by negativity** — Every criticism should come with a path forward.

---

## Architecture Decision Records (ADRs)

Write an ADR for every decision that would confuse a new hire in six months.

```
# ADR-001: [Title]
**Status:** Accepted | Superseded | Deprecated
**Date:** YYYY-MM-DD

## Context
What is the situation? What problem are we solving?

## Decision
What did we decide and why?

## Consequences
What trade-offs does this create? What becomes easier? Harder?
```

**When to write one:** Decision affects multiple components, is hard to reverse, or team members will ask "why did we do it this way?" later. One decision per record. Half a page is usually enough. Store in the repo.

---

## Design Patterns That Matter

| Pattern | What It Does | When to Use |
|---------|-------------|-------------|
| **Repository** | Abstracts data access | When you need to swap data sources or test without a DB |
| **Factory** | Encapsulates creation logic | When construction is complex or conditional |
| **Strategy** | Swaps algorithms at runtime | When behavior varies by context (pricing, sorting, auth) |
| **Observer** | Notifies dependents of state changes | Event systems, pub/sub within a process |
| **Adapter** | Wraps incompatible interface | Integrating third-party libraries or legacy systems |
| **Decorator** | Adds behavior without modifying class | Logging, caching, auth wrappers, retry logic |
| **Singleton** | One global instance | **Avoid** — makes testing hard. Use dependency injection. |

---

## Technical Debt Management

### Types of Debt

- **Intentional:** "We know this isn't ideal, but shipping matters more right now." Legitimate when tracked and time-bound.
- **Accidental:** "We didn't know the framework wouldn't support this." Reduce with spikes and learning.
- **Bit rot:** Untouched code with dependencies three major versions behind. Requires ongoing maintenance.
- **Not all shortcuts are debt.** Choosing a simpler solution when complexity isn't needed is good engineering (YAGNI).

### Debt Register Fields

| Field | Description |
|-------|-------------|
| **What** | Description of the debt |
| **Where** | Affected files/modules/systems |
| **Impact** | What breaks or slows if left untreated |
| **Severity** | Critical / High / Medium / Low |
| **Effort** | T-shirt size estimate |
| **Owner** | Who tracks it (not necessarily fixes it) |

### When to Pay It Down

- **Boy Scout Rule:** Leave code cleaner than you found it. Small improvements compound.
- **Before building on top:** Clean up before adding a major feature to a debt-heavy area.
- **When it causes incidents:** Repeated production issues move debt from "nice to fix" to "business critical."
- **Dedicated time:** 15-20% of each sprint, or dedicated quarterly debt sprints.

### Communicating Debt to Stakeholders

Frame in business language:
- "This debt adds two days to every feature in the payments module."
- "We're on an unsupported database version. No security patches available."
- "Our deploy takes 45 minutes instead of 5 — that's time wasted per deploy, 8 deploys per week."

---

## System Design Patterns

### Monolith vs. Microservices

**Start with a monolith.** A well-structured modular monolith gives you architectural rigor without distributed system complexity.

**Move to microservices when:**
- Team is large enough (50+ engineers) that independent deployment matters
- Components have genuinely different scaling requirements
- You have platform engineering capacity to operate distributed infrastructure

**Do NOT move to microservices because:**
- A conference talk made it sound exciting
- You want to use multiple programming languages
- You assume it will be faster (network calls are slower than function calls)

### CQRS (Command Query Responsibility Segregation)
Separate read model from write model. Write optimizes for business rules. Read optimizes for query performance.

**When to use:** High-read/low-write systems, complex domains where read/write shapes differ significantly.
**When NOT to use:** Simple CRUD apps, small teams. Don't add CQRS for sophistication.

### Event-Driven Architecture
**When to use:** Multiple systems need to react to the same event, handle traffic spikes, temporal decoupling matters.
**Key concepts:** Pub/Sub, Event Sourcing, eventual consistency.

### Domain-Driven Design Basics
- **Bounded Contexts:** Different parts can use different models for the same concept. A "User" in billing ≠ "User" in social features.
- **Ubiquitous Language:** Use the same terms in code that domain experts use in conversation.
- **Aggregates:** Cluster of related objects treated as a unit for data changes.

---

## Writing RFCs (Technical Proposals)

Write the RFC **before** writing the code. Circulate and give a week for comments.

**RFC Structure:**
1. **Problem statement** — What is broken? Why does it matter?
2. **Proposed solution** — What do you want to build? Be specific.
3. **Alternatives considered** — What else did you evaluate? Why rejected?
4. **Trade-offs** — What does this sacrifice? What risks does it introduce?
5. **Implementation plan** — How do you get there? Milestones and phases.
6. **Open questions** — What do you not yet know? Where do you need input?

---

## Estimation

- **Relative sizing:** "This is twice as complex as the login feature" is more reliable than "3.5 days"
- **Break it down:** Split work into 1-3 day pieces. Sum of small estimates > one big estimate
- **Track actuals:** Compare estimates to actuals over time. Learn your personal underestimation factor.
- **Communicate uncertainty:** "2-4 weeks, main risk is the third-party API integration"
- **Pad for the unexpected:** 20-30% of time goes to meetings, reviews, bugs, context switching

---

## Incident Response

### Severity Levels
| Level | Definition | Response |
|-------|-----------|----------|
| **SEV1** | Service down. Revenue loss. Data at risk. | All hands. War room. Exec notification. |
| **SEV2** | Major feature degraded. Significant user impact. | On-call + team. Hourly updates. |
| **SEV3** | Minor issue. Workaround available. | On-call investigates. Fix in next deploy. |
| **SEV4** | Cosmetic or low impact. | Track in backlog. Fix when convenient. |

**Protocol:** Respond within 15 minutes. Mitigate first, root-cause later. Communicate early and often.

### Blameless Postmortems

- Focus on systems, not people: "The deploy pipeline lacked rollback" not "Alice pushed a broken build"
- Document timeline, root cause, contributing factors, action items with owners
- Ask "What was missing in our system that allowed this to happen?"
- Review action items in the next team meeting

---

## Senior Developer Dos and Don'ts

| Do | Don't |
|----|-------|
| Write code others can read and maintain | Write clever code only you understand |
| Break work into small, reviewable PRs | Submit 2,000-line PRs |
| Test edge cases and failure modes | Only test the happy path |
| Ask "what is the simplest thing that works?" | Over-engineer for hypothetical requirements |
| Write meaningful commit messages (why) | Write "fix stuff" or "wip" |
| Design APIs before implementations | Start coding without understanding the problem |
| Make tech debt visible with tickets | Complain about debt without tracking it |
| Communicate blockers early | Sit on blockers hoping they resolve |
| Estimate with ranges and assumptions | Give single-number estimates with false precision |
| Write runbooks for systems you build | Leave operational knowledge only in your head |
| Receive feedback with curiosity | Take review comments as personal attacks |
| Build monitoring alongside features | Ship features and add observability "later" |
| Document architectural decisions | Assume everyone will remember the Slack conversation |

---

## Daily Rules

1. Review code in layers — architecture first, logic second, style last
2. Use `[must]`/`[suggestion]`/`[nit]`/`[question]` prefixes in reviews
3. Write an ADR for every decision that would confuse a new hire
4. Track tech debt like bugs — severity, owner, business impact
5. Start monolith, earn microservices — don't distribute until justified
6. Estimate in ranges with stated assumptions
7. In incidents: mitigate first, root-cause later, postmortem within 48 hours
8. Leave code better than you found it — every PR is an opportunity
9. Write the RFC before writing the code for any multi-component change
10. Document the "why" — code shows what, comments/ADRs show why
