# Topic 8: Retention & Expansion

*Retention beats acquisition. Keep > Get.*

---

## Churn Analysis Framework

### Types of Churn

| Type | What It Measures | Formula |
|------|-----------------|---------|
| Logo Churn | % of customers lost | Lost customers / Start-of-period customers |
| Revenue Churn (Gross) | % of revenue lost | Lost revenue / Start-of-period revenue |
| Net Revenue Churn | Revenue lost minus expansion | (Lost - Expansion) / Start-of-period revenue |

**Net negative churn** = expansion exceeds losses. MRR grows even with zero new customers. This is the ultimate SaaS metric.

### Churn Benchmarks

| Segment | Monthly Logo Churn |
|---------|-------------------|
| Early-stage (under $300K ARR) | 6.5% median |
| Growth-stage ($8M+ ARR) | 3.1% median |
| SMB-focused | 3-7% (brutal) |
| Enterprise-focused | Under 1% |

**Monthly Revenue Churn (B2B SaaS):**
- Over 10% = catastrophic
- 4-5% = typical early-stage
- 2-3% = good
- Under 2% = competitive advantage

### Churn Diagnosis

| Pattern | Likely Cause | Fix |
|---------|-------------|-----|
| High churn in first 30 days | Onboarding failure, unclear value | Fix onboarding, faster time-to-value |
| Churn after 3-6 months | Product didn't stick into workflow | Build habit loops, deeper integrations |
| Churn at renewal | Price sensitivity, alternatives found | Re-engage before renewal, demonstrate value |
| Churn by segment | Wrong ICP mixed with right ICP | Tighten ICP, adjust marketing |
| Seasonal churn | Business cycle mismatch | Align pricing to customer calendar |

---

## Onboarding Milestone Design

### The "Aha Moment" Framework

The point where the user first experiences core value and decides the product is worth adopting.

**How to find it:**
1. Compare behavioral data of retained vs. churned users
2. Find the action/threshold that most correlates with retention
3. That action IS your aha moment

**Famous examples:**
- Slack: Team sent 2,000 messages
- Dropbox: Saved 1 file in 1 folder on 1 device
- Facebook: Connected with 7 friends in 10 days

**Target:** 3-5 minutes time-to-value (signup to aha moment)

### Onboarding Best Practices

1. **Define 1-3 activation events** that predict 30-day retention
2. **Track activation rate** as a leading indicator
3. **Remove every unnecessary step** between signup and aha moment
4. **Send triggered emails** when users stall before activation
5. **Offer human help** for high-value accounts that don't activate in 48 hours

### Activation Rate
```
Activation Rate = Users who complete key action / Total new signups
```
~30% of signups typically reach aha moment. Continuously improve this.

---

## NPS / CSAT Basics

### Net Promoter Score (NPS)
"How likely are you to recommend us?" (0-10)
- Promoters (9-10) minus Detractors (0-6) = NPS

| NPS | Assessment |
|-----|-----------|
| 50+ | Excellent |
| 30-50 | Good |
| 0-30 | Needs improvement |
| Below 0 | Serious problems |
| SaaS average | ~30-40 |

### CSAT (Customer Satisfaction)
"How satisfied are you with [specific interaction]?" (1-5)
- Best used after support tickets, onboarding, feature launches
- Track trends, not absolute numbers

---

## Expansion Revenue Plays

### Four SaaS Cheat Codes (Walling)

1. **Expansion Revenue** — existing customers pay more over time
2. **Net Negative Churn** — expansion exceeds lost revenue
3. **Virality** — product usage naturally brings new users
4. **Dual Funnels** — self-serve + enterprise sales simultaneously

### Expansion Tactics

| Tactic | How | Trigger |
|--------|-----|---------|
| **Upsell** | Move to higher tier | Hitting usage limits, requesting features in higher tier |
| **Cross-sell** | Sell adjacent product/module | Customer stabilized on core product |
| **Seat expansion** | More users on same account | New department adopts, team grows |
| **Usage-based growth** | Price scales with consumption | Natural usage increase |
| **Annual contract** | Discount for annual prepay | At renewal, after proving value |

### NRR Targets

| NRR | Assessment |
|-----|-----------|
| Below 100% | Leaky bucket |
| 101% | Current median |
| 111%+ | Top performers |
| 120%+ | PLG best-in-class |

---

## Cohort Analysis

The most honest retention metric because it can't be gamed.

### How to Read Cohorts
Track what % of users from each signup cohort are still active at month 1, 2, 3, 6, 12.

**Healthy:** Curve flattens at 20-40%+ retention
**Dangerous:** Curve keeps declining toward zero = no PMF

### DAU/MAU Ratio (Stickiness)
```
DAU/MAU = Daily Active Users / Monthly Active Users
```

| Ratio | Assessment |
|-------|-----------|
| Below 10% | Casual/infrequent use |
| 15-25%+ | Sticky product |
| 50%+ | Exceptional (social/communication apps) |

---

## Churn Early Warning Signals

Monitor these to intervene BEFORE customers leave:

| Signal | Severity | Action |
|--------|----------|--------|
| Login frequency dropping | Medium | Automated re-engagement email |
| Feature usage declining | Medium | In-app prompt for underused features |
| Support ticket spike | High | CSM outreach within 24 hours |
| Key user left the company | Critical | Immediately engage new champion |
| Competitor evaluation (they asked for data export) | Critical | CSM call + executive sponsor |
| NPS score dropped | High | Follow-up survey + personal outreach |
| Payment failed | Medium | Dunning sequence (3 retries + emails) |

### Engagement Scoring

Build a composite score per account:
- **Frequency:** How often they use it
- **Depth:** How many features they use
- **Breadth:** How many team members (B2B)
- **Recency:** When they last used it

Use scores to segment: Power users (upsell targets), At-risk (save targets), Dormant (re-engage or accept loss).

---

## Retention Interventions by Stage

| Stage | Intervention |
|-------|-------------|
| Day 0-7 | Onboarding emails, setup wizard, first-value milestone |
| Day 7-30 | Feature discovery prompts, "Did you know?" emails |
| Day 30-90 | Health check call (high-touch), usage milestone celebrations |
| Day 90+ | Quarterly business reviews (enterprise), renewal prep |
| At-risk detected | Personal CSM outreach, executive sponsor engagement |
| Churned | Exit survey, win-back sequence at 3 and 6 months |

---

## Three Engines of Growth (Ries)

| Engine | How It Grows | Key Metric |
|--------|-------------|-----------|
| **Sticky** | Retain existing. Growth = new - churned. | Churn rate |
| **Viral** | Each user brings more users structurally | Viral coefficient (K > 1 = exponential) |
| **Paid** | Spend to acquire. Sustainable if LTV > CAC. | LTV:CAC ratio (3:1+) |

Pick ONE engine. Optimize its metrics. Only add a second when the first is working.

---

*Sources: The Lean Startup (Ries), The SaaS Playbook (Walling), Sean Ellis PMF framework, SaaS industry benchmarks 2025-2026*
