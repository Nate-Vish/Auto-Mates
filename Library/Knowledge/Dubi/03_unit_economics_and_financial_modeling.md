# Topic 3: Unit Economics & Financial Modeling

*The math that tells you if your business model actually works.*

---

## The Core Metrics

### LTV (Lifetime Value)

**Subscription/SaaS:**
```
LTV = ARPU / Monthly Churn Rate
```
Example: $50/mo ARPU, 5% monthly churn = $50/0.05 = $1,000 LTV

**With gross margin:**
```
LTV = (ARPU x Gross Margin %) / Monthly Churn Rate
```

**One-time purchase:**
```
LTV = Average Order Value x Purchase Frequency x Customer Lifespan
```

### CAC (Customer Acquisition Cost)

```
CAC = Total Sales & Marketing Spend / New Customers Acquired
```

Include everything: ad spend, salaries, tools, content production, events.

### The LTV:CAC Ratio

| Ratio | Assessment |
|-------|-----------|
| Below 1:1 | Losing money on every customer. Stop spending. |
| 1:1 to 2:1 | Unsustainable. Fix retention or acquisition cost. |
| 3:1 | Minimum for sustainable B2B SaaS growth |
| 3-5:1 | Strong. Investor-attractive. |
| Above 5:1 | Either very efficient OR under-investing in growth |

**2026 median:** 3.2:1 for B2B SaaS.

### CAC Payback Period

```
CAC Payback (months) = CAC / (ARPU x Gross Margin %)
```

| Payback | Assessment |
|---------|-----------|
| Under 12 months | Best-in-class |
| 12-18 months | Good for growth stage |
| 18-24 months | Acceptable if NRR > 110% |
| Over 24 months | Danger zone |

**2026 median:** 18 months (up from 14 months two years prior). Acquisition costs are rising.

---

## Churn Benchmarks

### Monthly Customer Churn by Stage

| Stage | Median Monthly Churn |
|-------|---------------------|
| Early-stage (under $300K ARR) | 6.5% |
| Growth-stage ($8M+ ARR) | 3.1% |
| SMB-focused | 3-7% (8.2x higher than enterprise) |
| Enterprise-focused | Under 1% |

### Monthly Gross Revenue Churn (SaaS)

| Rate | Assessment |
|------|-----------|
| Over 10% | Catastrophic. Product or market is broken. |
| 8-10% | Not good. Urgent action needed. |
| 6-7% | Mediocre. Survivable but dragging growth. |
| 4-5% | Fine. Typical early-stage. |
| 2-3% | Good. Solid foundation. |
| Under 2% | Great. Competitive advantage. |

### Net Dollar Retention (NRR)

Revenue retained from existing customers including expansion, contraction, and churn.

| NRR | Assessment |
|-----|-----------|
| Below 100% | Leaky bucket. Need ever-increasing acquisition. |
| 101% | Current median |
| 111%+ | Top performers |
| 120%+ | PLG best-in-class |

**NRR above 100% = you grow even without new customers.** This is the ultimate SaaS metric.

---

## Gross Margin Targets by Business Model

| Model | Target Gross Margin |
|-------|-------------------|
| SaaS | 71-80% (below 70% = cost structure problem) |
| Marketplace (platform-only) | 30-60% |
| Marketplace (with logistics) | 10-30% |
| E-commerce (private label) | 60-65% |
| E-commerce (dropshipping) | 65-70% |
| Agency / Services | 50-70% gross, 5-15% net |

---

## Burn Rate & Runway

```
Monthly Burn Rate = Monthly Expenses - Monthly Revenue
Runway (months) = Cash in Bank / Monthly Burn Rate
```

### Burn Multiple (David Sacks)

```
Burn Multiple = Net Burn / Net New ARR
```

| Burn Multiple | Assessment |
|--------------|-----------|
| Under 1.5x | Excellent |
| Under 2x | Good for venture-stage |
| 2-3x | Suspect |
| Above 3x | Dangerous (except seed-stage, where 3.2x is median) |

### Rule of 40

```
Revenue Growth Rate + EBITDA Margin >= 40%
```

- 40%+ = healthy
- 60%+ = excellent
- Below 40% = grow faster or become more profitable

---

## Break-Even Analysis

```
Break-Even Units = Fixed Costs / (Price per Unit - Variable Cost per Unit)
Break-Even Revenue = Fixed Costs / Gross Margin %
```

### Timeline Benchmarks
- CAC payback: 12-18 months median
- Company break-even: 23 months median for SaaS
- E-commerce net profit: 3% (scaling) to 15-20% (mature)

---

## Default Alive or Default Dead? (Paul Graham)

**Binary diagnostic:** At your current revenue growth rate and current expenses, do you reach profitability before running out of cash?

- **Default Alive:** Yes. You can plan.
- **Default Dead:** No. Immediate action: cut costs OR increase growth rate.

Ask this at every board meeting and every fundraise decision.

### Ramen Profitability
Revenue covers founders' basic living expenses ($2-5K/month per founder). Transforms the game from "don't run out of money" to "don't run out of energy."

---

## When to Raise vs. Bootstrap

| Signal | Bootstrap | Raise |
|--------|-----------|-------|
| Unit economics proven | Keep the equity | Consider for acceleration |
| Market is winner-take-all | Risky — may lose to funded competitor | Raise to compete |
| CAC payback < 6 months | Cash-flow positive growth possible | Not needed unless scaling fast |
| CAC payback > 18 months | Dangerous without capital | Raise or fix the economics |
| Default alive | Stay the course | Raise only for strategic acceleration |
| Default dead | Cut costs first | Raise if growth rate justifies it |

**Bootstrap-first principle:** Prove the model before spending someone else's money. Raising doesn't fix bad unit economics — it just delays the reckoning.

---

## Revenue Growth Benchmarks

| Stage | Target Growth |
|-------|--------------|
| YC weekly standard | 5-7% per week |
| Consumer seed | 20-50% MoM MAU growth |
| B2B SaaS seed | 10-20% MoM |
| B2B SaaS Series B | 5-10% MoM |
| Median ARR growth (all stages) | ~26% annually |

---

## Quick Reference

| Question | Metric | Target |
|----------|--------|--------|
| Is my model sustainable? | LTV:CAC | 3:1 minimum |
| How fast do I recover CAC? | CAC Payback | Under 12 months best-in-class |
| Am I leaking revenue? | NRR | 101% median, 111%+ top |
| Am I burning efficiently? | Burn Multiple | Under 2x |
| Will I survive? | Default Alive/Dead | Revenue growth vs. burn |
| Is my margin healthy? | Gross Margin | SaaS 71-80% |
| Am I growing fast enough? | Weekly Growth | 5-7% (YC standard) |

---

*Sources: The SaaS Playbook (Walling), YC Startup School (Graham), SaaS industry benchmarks 2025-2026, Bessemer Efficiency Score, David Sacks Burn Multiple*
