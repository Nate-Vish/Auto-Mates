# MVP Scoping Guide
**Category:** Planning
**Sources:**
- https://www.ycombinator.com/library/6f-how-to-plan-an-mvp
- https://www.ycombinator.com/library/Io-how-to-build-an-mvp
- https://basecamp.com/shapeup
- https://basecamp.com/shapeup/0.3-chapter-01
- https://softices.com/blogs/mvp-feature-prioritization-frameworks-methods
- https://www.mvpexpert.com/blog/rice-vs-moscow-the-ultimate-2025-guide-to-mvp-feature-prioritization-frameworks
- https://www.curiosum.com/blog/prioritizing-ux-in-your-mvp-80-20-rule-and-other-practical-methods
- https://www.cabotsolutions.com/blog/how-to-prioritize-features-in-your-mvp-build-only-what-you-need-to-validate
- https://martinfowler.com/bliki/TechnicalDebt.html
- https://www.atlassian.com/agile/software-development/technical-debt
- https://www.splunk.com/en_us/blog/learn/technical-debt.html

**Last updated:** 2026-03-01

---

## 1. What Makes a Good MVP

### The Definition That Actually Matters

An MVP is not a crappy version of your product. It is the **smallest thing you can build that proves or disproves your core hypothesis.** The "Viable" part is what most teams forget.

### Michael Seibel's Rules (Y Combinator)

1. **Ask one question:** "What is the one job users expect this product to do well?" If you can't answer in one sentence, you haven't scoped enough.
2. **Build for 100 passionate users, not 100K lukewarm ones.** Those 100 will give you the feedback you need to grow.
3. **Launch something bad quickly.** The first iPhone had 2G internet and no App Store. Airbnb didn't have payments or a map. Twitch was a single page.
4. **Don't fall in love with your MVP.** It will change dramatically through iteration. Emotional attachment to the first version creates resistance to necessary pivots.
5. **Build in weeks, not months.** In most cases, a lean MVP should take weeks to build. If it takes months, you've over-scoped.

### The MVP Litmus Test

Ask these questions. If you answer "no" to any, you've either under-built or over-built:

| Question | If No... |
|----------|----------|
| Does it solve the core problem for the target user? | Under-built -- missing the "Viable" |
| Can a user complete the core workflow end-to-end? | Under-built -- it's a demo, not a product |
| Is every feature directly tied to validating the core hypothesis? | Over-built -- cut the extras |
| Can you build it in 2-6 weeks? | Over-built -- scope down ruthlessly |
| Can you explain the value in one sentence? | Unfocused -- clarify what you're testing |

---

## 2. Feature Prioritization Frameworks

### MoSCoW Method

Categorize every feature into one of four buckets:

| Category | Meaning | MVP Rule |
|----------|---------|----------|
| **Must Have** | Product doesn't function without it | This IS your MVP |
| **Should Have** | Important, but product works without it | V1.1 -- right after MVP |
| **Could Have** | Nice to have if time/budget allows | V2 -- only if data supports it |
| **Won't Have** | Explicitly deferred | Backlog -- may never be built |

**MoSCoW Rules:**
- Keep "Must Have" ruthlessly small. If everything is Must Have, nothing is.
- MoSCoW is best for early-stage decisions when you need speed over precision.
- Revisit categories as priorities shift. What was "Should Have" might become "Must Have" based on user feedback.

### RICE Framework

Score each feature with a formula: **(Reach x Impact x Confidence) / Effort**

| Factor | What It Measures | Scale |
|--------|-----------------|-------|
| **Reach** | How many users will this affect in a given period? | Number (e.g., 500 users/quarter) |
| **Impact** | How much will it move the needle per user? | 0.25 (minimal) to 3 (massive) |
| **Confidence** | How sure are you about R, I, and E estimates? | 100% (high), 80% (medium), 50% (low) |
| **Effort** | How many person-months to build? | Number (e.g., 2 person-months) |

**RICE Example:**

| Feature | Reach | Impact | Confidence | Effort | RICE Score |
|---------|-------|--------|------------|--------|------------|
| Social login | 1000 | 2 | 80% | 0.5 | 3200 |
| Dark mode | 500 | 1 | 90% | 1 | 450 |
| Export to PDF | 200 | 3 | 60% | 2 | 180 |

**RICE Caveat for MVPs:** For a pre-launch MVP, you have no real data for Reach or Impact. RICE can become "an exercise in guesswork that leads to analysis paralysis." Use MoSCoW first, then apply RICE to break ties within the "Must Have" and "Should Have" buckets.

### Combined Approach (Recommended)

1. **MoSCoW first** -- quick clarity on what's in and what's out
2. **RICE on Must Haves and Should Haves** -- data-driven tiebreaking when you have more "musts" than you can build
3. **Impact/Effort matrix** -- visual gut-check for the team

```
         High Impact
              |
  Quick Wins  |  Major Projects
  (DO FIRST)  |  (PLAN CAREFULLY)
--------------+------------------
  Fill-Ins    |  Thankless Tasks
  (IF TIME)   |  (AVOID)
              |
         Low Impact
   Low Effort       High Effort
```

---

## 3. Phased Delivery: Slicing Features Into Shippable Increments

### The Shape Up Model (Basecamp)

Basecamp's Shape Up methodology provides a proven framework for phased delivery:

**Phase 1: Shape (2 weeks)**
- Senior team members define the problem, sketch a solution at the right level of abstraction
- Use "breadboarding" (workflow sketches) and "fat marker sketches" (rough UI)
- Set an "appetite" -- how much time this is worth (not how much time it will take)

**Phase 2: Bet (1 meeting)**
- Leadership bets on which shaped projects to build in the next cycle
- No backlog -- if an idea doesn't get picked, it must be re-pitched next cycle
- This forces prioritization by requiring champions to care enough to re-propose

**Phase 3: Build (6 weeks)**
- Small team (2-3 people) owns the entire delivery
- Team defines their own tasks and adjusts scope as needed
- Must ship by the end of the cycle -- no extensions

**Cooldown (2 weeks)**
- Fix bugs, address tech debt, explore new ideas
- Recharge before the next cycle

### Practical Phased Delivery for Any Methodology

| Phase | What to Ship | Success Criteria |
|-------|-------------|------------------|
| **MVP (4-6 weeks)** | Core workflow, one user type, one happy path | Users can complete the primary job-to-be-done |
| **V1.0 (2-4 months)** | Error handling, edge cases, 2-3 user types, basic settings | Product is reliable enough for daily use |
| **V1.x (ongoing)** | Features driven by user feedback and metrics | Retention improves, support tickets decrease |
| **V2.0 (when needed)** | Major new capability or architectural evolution | New market segment or significant expansion |

### Slicing Rules

1. **Slice vertically, not horizontally.** Each slice should deliver user-visible value across all layers (UI + API + DB), not "build the database first, then the API, then the UI."
2. **Each slice should be independently deployable.** If you can't ship slice 3 without slice 4, they're one slice.
3. **The first slice proves the riskiest assumption.** Build the thing you're least sure about first.
4. **Progressive enhancement.** Start with the simplest version that works, then add polish. Login page first, then "forgot password," then OAuth, then 2FA.

---

## 4. Common MVP Mistakes

### Over-Building

| Mistake | Example | Fix |
|---------|---------|-----|
| Building features nobody asked for | Adding a chat feature to a payments app | Start with one core workflow |
| Premature optimization | Building for 1M users when you have 0 | Optimize when you hit real bottlenecks |
| Premature platform | Building iOS, Android, and web simultaneously | Ship one platform, validate, expand |
| Perfect UI before product-market fit | Spending weeks on animations and transitions | Functional > beautiful at MVP stage |
| Building admin tools before user tools | 3 admin dashboards but a broken signup flow | Users first, admin tools can be database queries |

### Under-Building

| Mistake | Example | Fix |
|---------|---------|-----|
| Forgetting "Viable" | A payment app that can't actually process payments | The core job must work end-to-end |
| No error handling | App crashes silently on bad input | Handle the critical errors, even if not all |
| No way to get feedback | No analytics, no feedback mechanism | At minimum: error tracking + a feedback button |
| Skipping authentication | "We'll add login later" | If users create data, auth is a Must Have |

### Wrong Features First

| Mistake | Fix |
|---------|-----|
| Building integrations before the core product works | Nail the core, then integrate |
| Building billing before proving people want the product | Start with free/manual billing, automate later |
| Building social features before individual value | The product must be useful to one user alone first |

---

## 5. Technical Debt: When to Accept, Fight, and Track

### When to Accept Technical Debt

Accept it deliberately when:
- **Speed to market matters more than perfection.** A working MVP with technical debt beats a perfect product that's 6 months late.
- **You're validating an uncertain hypothesis.** Don't build beautiful architecture for something that might pivot entirely.
- **The code is in a non-core area.** Admin tools, one-time scripts, internal dashboards -- debt here costs less.
- **You document it.** Undocumented debt is not "strategic debt." It's negligence.

### When to Fight Technical Debt

Fight it aggressively when:
- **It's in the core product path.** Debt on your most-used features compounds fastest.
- **It's slowing down every new feature.** When your "maintenance load" exceeds 30-40% of dev time, you're in danger.
- **It's creating bugs for users.** Technical debt that causes user-facing issues is no longer "technical" -- it's a product problem.
- **A refactor now prevents a rewrite later.** Small, continuous improvements beat big-bang rewrites.

### How to Track Technical Debt

1. **Treat it like financial debt.** Log it in your backlog with the same visibility as features and bugs.
2. **Tag it.** Use `tech-debt` labels in your issue tracker. Categorize: `[architecture]`, `[testing]`, `[security]`, `[performance]`.
3. **Measure maintenance load.** Track: what percentage of dev time goes to maintenance vs. new features? If more than 50%, you're in a debt crisis.
4. **Pay it down gradually.** Spend an extra day or two removing cruft whenever you touch a file. This naturally targets the highest-traffic code.
5. **Reserve capacity.** Basecamp's Shape Up dedicates 2 weeks every 8 weeks (the "cooldown") to debt and bugs. The 20% rule works too: every sprint, 20% of capacity goes to debt reduction.

### Martin Fowler's Technical Debt Quadrant

| | Deliberate | Inadvertent |
|---|---|---|
| **Reckless** | "We don't have time for design" | "What's layering?" |
| **Prudent** | "We must ship now and deal with consequences" | "Now we know how we should have done it" |

Only the bottom-left quadrant (Prudent + Deliberate) is acceptable in a well-run project. The goal is to make debt decisions consciously, document them, and plan to pay them back.

---

## Planner's Application

When scoping MVPs and planning phased delivery, Planner should:

1. **Start every blueprint with a one-sentence core hypothesis.** "We believe [target user] will [behavior] because [value proposition]." Every Must Have feature must tie back to this sentence.

2. **Include a MoSCoW table in every blueprint.** Every proposed feature gets categorized. The Must Have list IS the MVP scope. Everything else is labeled with a target phase.

3. **Set an appetite, not an estimate.** Instead of "How long will this take?" ask "How much time is this worth?" If it's worth 4 weeks, shape the solution to fit 4 weeks.

4. **Define the vertical slices.** Break the MVP into 3-5 independently deployable slices. Each slice should be demo-able and testable. The first slice should address the riskiest assumption.

5. **Include a Technical Debt section.** List the known debt being accepted for MVP and when it should be addressed. Example: "Auth: MVP uses API keys. Move to OAuth in V1.0."

6. **Define success metrics for each phase.** What numbers tell us the MVP is working? User signups, completion rate, retention, NPS -- pick 2-3 and put them in the blueprint. Without metrics, there's no signal for what to build next.
