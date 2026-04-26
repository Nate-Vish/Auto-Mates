# Topic 9: Operations & Automation

*Build systems, not jobs. The business should work without you in it.*

---

## The Three Personalities (Gerber)

Every founder contains three warring archetypes:

| Personality | Focus | Typical Time Spent |
|-------------|-------|--------------------|
| **Entrepreneur** | Vision, strategy, "what if" | 10% (should be more) |
| **Manager** | Systems, processes, organization | 20% |
| **Technician** | Doing the work | 70% (should be less) |

**The problem:** Most founders are 70%+ Technician. They ARE the business, not the OWNER of one.

**The fix:** Deliberately rebalance. Block calendar time for each persona. Track your ON vs. IN ratio weekly.

---

## Working ON vs. IN the Business

**IN:** Serving customers, doing tasks, fighting fires, writing code
**ON:** Building systems, designing processes, hiring, strategy

### The "Hit by a Bus" Test
If you disappeared for 30 days, would the business survive?
- **Yes:** You have a business
- **No:** You have a job

### Target Ratios

| Stage | ON Time | IN Time |
|-------|---------|---------|
| Solo founder | 20% minimum | 80% |
| First hires | 40% | 60% |
| Scaled team | 60%+ | 40% |

---

## SOP Priority List (What to Document First)

Document in this order — highest leverage first:

1. **Customer onboarding** — first impression, retention driver
2. **Sales process** — qualification, demo, proposal, close
3. **Support workflow** — ticket routing, response templates, escalation
4. **Billing & invoicing** — payment processing, dunning
5. **Content publishing** — creation, review, publish cadence
6. **Hiring process** — job posting, screening, interviews, offers
7. **Release/deployment** — build, test, deploy, rollback
8. **Reporting** — weekly metrics, board reporting

### SOP Template

```
# [Process Name]

**Trigger:** What causes this process to start
**Owner:** Who is responsible
**Frequency:** How often it runs

## Steps
1. [Action] — [Tool/System used]
2. [Action] — [Expected output]
3. [Action] — [Quality check]

## Output
What the completed process produces

## Quality Check
How to verify it was done correctly

## Exceptions
What to do when the normal flow doesn't apply
```

**Rule:** If it's not written down, it doesn't exist. If you've done it three times, it needs an SOP.

---

## The Franchise Prototype (Gerber)

Build your business as if you were going to franchise it 5,000 times.

### Six Rules

1. **Consistent value** — predictable results every time
2. **Lowest possible skill level** — systems are operable by non-experts (depend on elite SYSTEMS, not elite TALENT)
3. **Impeccable order** — nothing left to chance
4. **Documented in Operations Manuals** — all work is written down
5. **Uniformly predictable service** — same experience every time
6. **Uniform appearance** — consistent brand experience

**The test:** Could someone with no industry experience follow your systems and produce a consistent result?

---

## Innovation / Quantification / Orchestration (Gerber)

The three-part engine for continuously improving operations:

### Step 1: Innovation
Find a better way to do what you already do:
- "What if we followed up within 2 hours instead of 24?"
- "What if we automated the onboarding email sequence?"
- Not invention — improvement of existing processes

### Step 2: Quantification
Measure the impact:
- What's the close rate with Script A vs. Script B?
- How long does onboarding take now vs. before?
- "If you can't measure it, you can't improve it, and you can't replicate it."

### Step 3: Orchestration
Lock in what works:
- Create the standard process
- Remove discretion where consistency matters
- Update the Operations Manual
- Train the team on the new standard

**Cycle continuously:** Innovate -> Quantify -> Orchestrate -> Innovate again.

---

## Automation Trigger Points

### When to Automate

| Signal | Action |
|--------|--------|
| Process runs 3+ times/week | Document as SOP |
| Process runs daily AND is rule-based | Automate (Zapier, Make, custom scripts) |
| Process volume doubled this quarter | Automate before it triples |
| Errors are caused by human inconsistency | Automate the error-prone steps |
| You're the bottleneck on something repetitive | Automate or delegate immediately |

### Automation Stack (Bootstrap-Friendly)

| Layer | Tools | Cost |
|-------|-------|------|
| Email sequences | ConvertKit, Mailchimp, Loops | Free-$30/mo |
| Workflow automation | Zapier, Make (Integromat) | Free-$20/mo |
| CRM | HubSpot (free), Pipedrive | Free-$15/mo |
| Support | Intercom, Crisp, Help Scout | Free-$30/mo |
| Billing | Stripe, Paddle, LemonSqueezy | Per transaction |
| Scheduling | Calendly, Cal.com | Free-$12/mo |
| Project management | Linear, Notion, GitHub Issues | Free-$10/mo |

### What NOT to Automate (Yet)
- Customer calls where empathy matters
- Strategic decisions
- Creative work
- Anything you haven't done manually at least 10 times
- Processes that change frequently (automate once stable)

---

## Delegation Readiness Assessment

Before delegating a process:

- [ ] Is it documented as an SOP?
- [ ] Can you explain it in under 10 minutes?
- [ ] Are the quality criteria clear and measurable?
- [ ] Can you verify the output without redoing the work?
- [ ] Is the person trained (or is the SOP clear enough)?

### Delegation Framework
```
1. Do it yourself (learn the process)
2. Document it (create SOP)
3. Do it together (train the person)
4. Watch them do it (verify quality)
5. Let them do it (check output only)
6. They own it (they improve the SOP)
```

---

## The Seven-Step Business Development Program (Gerber)

The strategic architecture for building a mature business:

1. **Primary Aim** — What do you want your LIFE to look like? (The business serves this.)
2. **Strategic Objective** — Revenue targets, business type, "is this worth doing?" criteria
3. **Organizational Strategy** — Org chart for the FUTURE business (not today's)
4. **Management Strategy** — Systems manage; people run systems
5. **People Strategy** — Environment where doing the right thing is automatic
6. **Marketing Strategy** — What does the CUSTOMER want? (Not what you want)
7. **Systems Strategy** — Three types: Hard (tools), Soft (procedures), Information (data flow)

---

## Build-Measure-Learn for Operations (Ries)

Apply the same loop to operational improvements:

1. **Hypothesis:** "Automating onboarding emails will reduce time-to-activation by 40%"
2. **Build:** Set up the automation (smallest version)
3. **Measure:** Track activation rate before and after
4. **Learn:** Did it work? If yes, orchestrate. If no, try different approach.

### The Five Whys (Root Cause Analysis)

When something goes wrong:
1. Why did the deployment break? -> A feature had a bug
2. Why wasn't it caught? -> No test was written
3. Why no test? -> Developer was rushing
4. Why rushing? -> Sprint was overscheduled
5. Why? -> Planning doesn't account for testing time

**Fix proportionally at each level.** Small problems = small fixes. Big problems = structural changes.

---

*Sources: The E-Myth Revisited (Gerber), The Lean Startup (Ries), The SaaS Playbook (Walling)*
