# Requirements to Blueprint: Turning Vague Ideas Into Clear Technical Plans
**Category:** Planning
**Sources:**
- https://martinfowler.com/bliki/UserStory.html
- https://martinfowler.com/bliki/ConversationalStories.html
- https://martinfowler.com/articles/product-backlog-building-canvas.html
- https://framework.scaledagile.com/story
- https://agile.appliedframeworks.com/applied-frameworks-agile-blog/user-stories-making-the-vertical-slice
- https://dev.to/jan/user-stories-and-vertical-slicing-1dpo
- https://www.seannhicks.com/blog/slicing-user-stories/
- https://producthabits.com/engineering-estimates/
- https://www.easyagile.com/blog/agile-estimation-techniques
- https://www.altexsoft.com/blog/non-functional-requirements/
- https://blog.bytebytego.com/p/non-functional-requirements-the-backbone
- https://www.redhat.com/en/blog/nonfunctional-requirements-architecture

**Last updated:** 2026-03-01

---

## 1. Requirements Gathering Techniques

### User Stories

The fundamental unit of work in Agile. A user story describes a software feature from the end-user's perspective.

**Standard Format:**
```
As a [user role],
I want to [action/capability],
So that [business value/reason].
```

**Example:**
```
As a freelance designer,
I want to send invoices directly from the project dashboard,
So that I don't have to switch to a separate billing tool.
```

**The INVEST Criteria** (Bill Wake, popularized by Martin Fowler):

| Letter | Meaning | Test |
|--------|---------|------|
| **I** | Independent | Can this story be built and delivered without waiting for another story? |
| **N** | Negotiable | Is the solution flexible, or has it been over-specified? |
| **V** | Valuable | Does it deliver value to the user or the business? |
| **E** | Estimable | Can the team estimate the complexity? If not, it needs more conversation. |
| **S** | Small | Can it be built in a few days? If not, slice it smaller. |
| **T** | Testable | Can you write acceptance criteria that prove it works? |

**Stories Should NOT Be "Decreed"** (Martin Fowler):

A common mistake is treating stories as requirements handed down from product owners to developers. Stories are collaborative. Any team member can create, modify, or challenge stories. The best stories come from conversation, not decree. The story card is a reminder to have a conversation -- it is not a specification.

### Jobs to Be Done (JTBD)

JTBD goes deeper than user stories by focusing on the underlying motivation:

```
When I [situation/context],
I want to [motivation/goal],
So I can [expected outcome].
```

**User Story vs. JTBD:**

| User Story | JTBD |
|-----------|------|
| "As a user, I want to filter search results" | "When I'm looking for a specific product, I want to narrow down options quickly, so I can find what I need without scrolling through hundreds of items" |
| Focuses on the feature | Focuses on the context and motivation |
| Answers: what does the user want? | Answers: WHY does the user want it? |

**When to use JTBD over User Stories:**
- Discovery phase, when you're trying to understand what to build
- When the "so that" clause in user stories keeps being vague
- When you suspect the requested feature isn't the real need

### Combining Both

Start with JTBD during discovery to understand the problem space. Convert to User Stories during planning to define the solution scope. This prevents building features that solve the wrong problem.

---

## 2. Writing Testable Acceptance Criteria

Acceptance criteria define "done." If you can't write acceptance criteria, the requirement is not clear enough to build.

### Given-When-Then Format (BDD Style)

```
Given [precondition / initial context],
When [action / event],
Then [expected outcome].
```

**Example:**
```
Story: User can cancel a subscription

Given I am a logged-in user with an active subscription,
When I click "Cancel Subscription" and confirm the cancellation,
Then my subscription status changes to "Cancelled",
  And I receive a confirmation email within 5 minutes,
  And I retain access until the current billing period ends.
```

### Rules for Good Acceptance Criteria

| Rule | Good | Bad |
|------|------|-----|
| **Specific and measurable** | "Page loads in under 2 seconds" | "Page should be fast" |
| **Test one behavior per criterion** | "Clicking Save creates a new record" | "Save works correctly" |
| **Include edge cases** | "If email is already taken, show 'Email already registered'" | "Handle duplicate emails" |
| **Include negative cases** | "If password is less than 8 characters, show validation error" | (missing entirely) |
| **No implementation details** | "User sees their order history" | "The SQL query joins orders with users table" |
| **User-facing language** | "Error message appears below the field" | "Throw a 422 exception" |

### Common Acceptance Criteria Mistakes

1. **Too vague:** "The user can manage their account." Manage how? What specifically can they do?
2. **Missing the unhappy path:** Only defining what happens when everything goes right. Always include: what happens when input is invalid? When the network fails? When permissions are denied?
3. **Implementation-prescriptive:** "Use React to render a table component" -- that's a technical decision, not an acceptance criterion.
4. **Untestable:** "The app should feel intuitive." This cannot be verified. Replace with: "A new user can complete the core workflow without reading documentation."

---

## 3. Breaking Down Features Into Tasks

### Vertical Slicing (Do This)

A vertical slice cuts through ALL layers of the system to deliver one thin piece of working functionality:

```
  UI    |  [Login Form]  [Forgot Password]  [OAuth Login]  [2FA]
  API   |  [Auth endpoint] [Reset endpoint] [OAuth flow]   [2FA flow]
  DB    |  [User table]   [Reset tokens]    [OAuth tokens] [2FA codes]
        |
        |  Slice 1         Slice 2           Slice 3        Slice 4
```

Each slice is independently deployable and testable. Build Slice 1 first, ship it, get feedback, then build Slice 2.

### Horizontal Slicing (Don't Do This)

Horizontal slicing builds one layer at a time:

```
Sprint 1: Build all database tables
Sprint 2: Build all API endpoints
Sprint 3: Build all UI components
Sprint 4: Integrate everything and hope it works
```

**Why this fails:**
- No working software until Sprint 4
- No user feedback until Sprint 4
- Integration problems discovered late
- Each "sprint" doesn't deliver value
- Horizontal stories are actually tasks, not stories

### Slicing Techniques

**1. Slice by Acceptance Criteria**

If a story has 5 acceptance criteria, each criterion could be its own slice:

```
Original: "Users can search for products"

Slice 1: "Search by product name returns matching results"
Slice 2: "Search results are paginated (25 per page)"
Slice 3: "Search results can be filtered by category"
Slice 4: "Search results can be sorted by price/relevance"
Slice 5: "Search shows 'no results' message with suggestions"
```

**2. Slice by User Role**

```
Original: "Users can manage orders"

Slice 1: "Customer can view their order history"
Slice 2: "Customer can cancel a pending order"
Slice 3: "Admin can view all orders"
Slice 4: "Admin can refund an order"
```

**3. Slice by Happy Path First**

```
Original: "User registration"

Slice 1: "User registers with email and password" (happy path)
Slice 2: "Validation errors shown for invalid input" (error handling)
Slice 3: "Duplicate email prevention" (edge case)
Slice 4: "Email verification" (enhancement)
```

**4. Slice by Data Scope**

```
Original: "Dashboard shows analytics"

Slice 1: "Dashboard shows total users count"
Slice 2: "Dashboard shows revenue chart"
Slice 3: "Dashboard supports date range filtering"
Slice 4: "Dashboard supports CSV export"
```

---

## 4. Estimating Complexity Without Estimating Time

### Why Not Time?

Time estimates fail because:
- They vary wildly by developer skill, familiarity, and interruptions
- They create false precision ("this will take 3.5 days" -- it won't)
- They pressure teams into commitments before they understand the work
- They confuse complexity (inherent) with duration (situational)

### T-Shirt Sizing (Recommended for Early Planning)

| Size | Meaning | Rough Guidance |
|------|---------|----------------|
| **XS** | Trivial. Config change, copy update, minor fix | A few hours |
| **S** | Well-understood. One component, clear path | 1-2 days |
| **M** | Moderate complexity. Multiple components, some unknowns | 3-5 days |
| **L** | Complex. Cross-cutting concerns, integration work, unknowns | 1-2 weeks |
| **XL** | Too big. Must be broken down before work starts | Slice it smaller |

**How to run T-shirt sizing:**
1. Pick a reference story the team agrees is "Small"
2. Compare every other story to the reference: is it smaller, same size, or bigger?
3. Categorize into XS / S / M / L / XL
4. Anything XL gets sliced into smaller stories before sprint planning
5. After a few sprints, your velocity in "number of S-equivalent stories per sprint" becomes predictable

**Why T-shirt sizing beats story points:**
- No debates about "is this a 3 or a 5?" (T-shirt sizes have natural breakpoints)
- Sizes don't get mapped to hours (numbers tempt people to equate points with days)
- Faster estimation sessions (5-10 minutes vs. 30-60 minutes for planning poker)
- Discussions focus on "is this bigger or smaller?" which is useful, not "how many points?" which is performative

### Story Points (Alternative)

If your team prefers story points, use the Fibonacci sequence (1, 2, 3, 5, 8, 13, 21) to reflect increasing uncertainty at larger sizes. Key rules:
- A "1" is your simplest, most well-understood type of work
- Anything above 13 should be broken down
- Track velocity (points completed per sprint) over 3+ sprints before using it for forecasting
- NEVER convert points to hours. The moment you say "1 point = 1 day," the system breaks

### The #NoEstimates Alternative

Some teams skip estimation entirely and simply count completed stories per sprint. Since velocity is an average over time, counting stories can be as accurate as counting points -- especially if stories are consistently small. This works best when:
- Stories are consistently sliced to similar sizes
- The team is mature and self-organizing
- Stakeholders trust throughput metrics over forecasts

---

## 5. Common Planning Mistakes

### Gold Plating

**What it is:** Adding unnecessary polish, features, or complexity beyond what's needed.

**Signs:** "While we're at it, we should also..." or "Let's make it configurable just in case" or spending 3 days on an animation that users won't notice.

**Fix:** Every feature and enhancement must tie back to a user story with clear acceptance criteria. If it's not in the acceptance criteria, it's not in scope.

### Missing Edge Cases

**What it is:** Planning only the happy path and ignoring what happens when things go wrong.

**Checklist for edge cases:**
- [ ] What happens with empty data? (No results, no items, new account)
- [ ] What happens with too much data? (Pagination, timeouts, file size limits)
- [ ] What happens with invalid data? (Wrong format, missing fields, SQL injection)
- [ ] What happens with concurrent access? (Two users editing the same resource)
- [ ] What happens when external services are down? (Payment provider, email service)
- [ ] What happens on different devices/browsers? (Mobile, old browsers, screen readers)

### Ignoring Non-Functional Requirements (NFRs)

NFRs define HOW the system performs, not WHAT it does. They are often the difference between a demo and a product.

**The NFR Checklist Planner Must Include:**

| NFR | Key Questions | Example Requirement |
|-----|---------------|---------------------|
| **Performance** | Acceptable response time? Throughput? | "API responses under 200ms at p95" |
| **Scalability** | Expected growth? Horizontal or vertical? | "Support 10K concurrent users by V1.0" |
| **Security** | Data sensitivity? Compliance? Auth model? | "All PII encrypted at rest (AES-256)" |
| **Availability** | Required uptime? Disaster recovery? | "99.9% uptime, RPO 1 hour, RTO 4 hours" |
| **Maintainability** | How easily can it be updated? | "Modular architecture, 80%+ test coverage" |
| **Accessibility** | WCAG level? | "WCAG 2.1 AA compliance" |
| **Compliance** | GDPR? HIPAA? SOC2? | "GDPR compliant, data residency in EU" |

**Why teams skip NFRs:** They're invisible until they're violated. Nobody notices "fast page loads" until the page is slow. Plan for them explicitly or accept that they'll be expensive to retrofit.

### Other Common Mistakes

- **Estimating before understanding.** Don't estimate complexity until the team has had a conversation about the story. Estimation without context is guessing.
- **Confusing "we haven't decided" with "it's simple."** Unresolved ambiguity is complexity. If the team can't agree on how something should work, it's a Large, not a Small.
- **Planning in isolation.** Planner writing blueprints without developer input produces plans that are architecturally naive. Include the team early.

---

## Planner's Application

When turning requirements into blueprints, Planner should:

1. **Use JTBD for discovery, User Stories for specification.** Start with "When/I want/So I can" to understand the real need, then convert to "As a/I want/So that" for the buildable scope.

2. **Write acceptance criteria for every story in the blueprint.** Use Given-When-Then format. If you can't write the acceptance criteria, the requirement isn't clear enough -- go back and ask more questions.

3. **Always slice vertically.** Every phase in the blueprint should deliver end-to-end functionality. Never write a phase that is "Build the database" or "Build the API." Each phase delivers user-visible value.

4. **Use T-shirt sizing in the blueprint.** Assign XS/S/M/L to each story or feature group. This gives the team a sense of relative size without false precision. Flag anything L or XL as needing further decomposition.

5. **Include an NFR section in every blueprint.** Use the checklist above. Even if the answer is "not applicable," make it explicit. NFRs that aren't in the blueprint won't be in the architecture.

6. **Include an Edge Case section.** For each core workflow, list the known edge cases and how they should be handled. This prevents Builder from discovering them mid-sprint with no guidance.

7. **Mark unknowns explicitly.** If a requirement is ambiguous, write "[UNKNOWN: how should X behave when Y?]" in the blueprint. Explicitly surfaced unknowns get resolved. Implicit unknowns become bugs.
