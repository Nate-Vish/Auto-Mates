# Customer Obligations

**Domain:** What you legally owe your customers — consumer protection, warranties, refunds, product liability, auto-renewal compliance, dark patterns, breach notification.

**Last Updated:** 2026-03-24

---

## 1. Consumer Protection

### FTC Act Section 5

Prohibits "unfair or deceptive acts or practices." For software/SaaS:

- **Deceptive claims** about capabilities, security, or performance are actionable
- **Data security representations** must be accurate — claiming security you don't implement violates Section 5
- **AI claims** face increasing scrutiny — FTC expects more enforcement in 2026
- **COPPA amendments** (effective June 23, 2025) expand requirements for children under 13

### State Consumer Protection ("Mini-FTC Acts")

Every US state has one. Many provide:
- Private right of action (consumers can sue directly)
- Treble damages and attorney's fees
- California's UCL and CLRA are particularly aggressive
- State AGs actively enforce, especially for subscription practices

### EU Consumer Rights Directive

- **14-day withdrawal right** for online subscriptions (no justification required)
- **Pre-contractual information** requirements (characteristics, price, duration, termination)
- **Two-year statutory warranty** for digital content and services
- New harmonized notice requirements take effect September 27, 2026

---

## 2. Warranties

### Implied Warranties (US)

**Merchantability (UCC 2-314):** Software must be fit for ordinary purposes. Courts split on whether software is a "good" or "service."

**Fitness for Particular Purpose (UCC 2-315):** Arises when seller knows buyer's particular purpose and buyer relies on seller's expertise.

### Disclaiming Warranties

To effectively disclaim:
1. **Must mention "merchantability" and "fitness" by name** — generic "as-is" insufficient in many jurisdictions
2. **Must be conspicuous** — bold, uppercase, separate section
3. **Cannot contradict express warranties** — marketing says "99% uptime" but contract disclaims = express warranty upheld
4. **Cannot disclaim if SLA exists** — SLA creates express warranty

### Why Disclaimers Fail (6 Reasons)

1. Lack of conspicuousness — buried in fine print
2. Express warranty conflicts — marketing contradicts contract
3. Unconscionability — take-it-or-leave-it + overly one-sided
4. Consumer statute violations — Magnuson-Moss and Song-Beverly override
5. Fraud or concealment — known defects
6. No mutual assent — added post-purchase

### Magnuson-Moss Warranty Act

If you provide ANY written warranty for a consumer product, you **cannot disclaim implied warranties entirely**. Can only limit duration to match written warranty. Consumer-facing software (productivity apps, etc.) likely triggers the Act.

### EU: Two-Year Legal Guarantee

For digital content and services — seller liable for conformity defects appearing within two years. For continuous supply (SaaS), liable for defects during entire contract period.

---

## 3. Refunds

**US:** No federal law requires refund policies. But several states require conspicuous posting. California: no posted policy = consumers can return within 30 days for full refund.

**EU:** 14-day withdrawal right for online purchases. Exception for digital content if consumer consented to begin delivery and acknowledged losing withdrawal right. Refunds within 14 days.

**UK:** 30-day right to reject defective digital content (Consumer Rights Act 2015).

**Chargebacks:** Fair Credit Billing Act allows disputes for unauthorized transactions, goods not received, incorrect amounts. Maintain records of consent, delivery confirmation, communications, ToS acceptance.

---

## 4. Product Liability for Software

### US Current Framework

Software has traditionally been treated as service/intangible, limiting strict liability:
- **Negligence:** Duty of reasonable care; foreseeable harm + failure to exercise care = liability
- **Strict liability:** Traditionally limited to tangible products; more likely when software embedded in physical device
- **Breach of warranty:** When software fails to perform per specifications

### EU Product Liability Directive 2024/2853 (Effective December 9, 2026)

**THIS IS A GAME-CHANGER.** Software is now explicitly a "product" subject to strict liability:

- Covers embedded, standalone, AND SaaS software, AI systems, firmware, digital manufacturing files
- **No-fault liability** — strict liability for defects causing harm (no need to prove negligence)
- **Cannot contractually exclude or limit** liability for defects — traditional disclaimers eliminated
- **Cybersecurity vulnerabilities = product defects** — failure to provide security updates = defect
- **Evidentiary presumptions** — courts can presume defectiveness if claimants show "excessive difficulties" proving it
- **Mandatory disclosure** — companies may be compelled to reveal evidence
- **Class actions facilitated** via Representative Actions Directive

### AI LEAD Act (Proposed US)

Would establish product liability standards for AI: defective design, failure to warn, breach of express warranty, strict liability.

---

## 5. Auto-Renewal (ROSCA + State Laws)

### ROSCA (Restore Online Shoppers' Confidence Act)

Three mandatory conditions (fully enforceable despite FTC Click-to-Cancel vacatur):
1. **Clear disclosure** of all material terms before collecting billing info
2. **Express informed consent** before charges
3. **Simple cancellation** — at least as easy as signup, same medium

### FTC Click-to-Cancel Status (March 2026)

Vacated by 8th Circuit (July 2025). FTC submitted ANPRM (Jan 2026), comments due April 2026. **ROSCA remains fully enforceable.**

### Recent Enforcement

- **Uber (Dec 2025):** 23 screens and 32 actions to cancel Uber One; 28M+ consumers affected
- **Chegg (Sept 2025):** $7.5M settlement for buried cancellation, mandatory surveys, 200K+ post-cancellation billings
- **Major retailer:** $2.5 billion settlement
- Since Jan 2025: 5 new cases, 6 settlements for negative option misconduct

### State ARLs (2025-2026)

New/updated in: Arkansas, California, Colorado, Connecticut, Maryland, Massachusetts, Minnesota, Utah. State requirements may exceed ROSCA.

---

## 6. Dark Patterns

Manipulative UI design to trick consumers into purchases, subscriptions, or data sharing. FTC increasingly targets as deceptive practices.

Examples: confirmshaming, hidden costs at checkout, forced continuity, misdirection in cancellation flows.

---

## 7. Duty to Notify

### Data Breach (US)

- **All 50 states** have breach notification laws
- Typical: notify individuals within 30-90 days, notify state AG if breach exceeds threshold (500-1,000 residents), notify credit agencies for large breaches
- SaaS providers: contractual terms often require notifying data controllers, individuals, and regulators

### Data Breach (EU — GDPR)

- 72-hour notification to supervisory authority
- "Without undue delay" to individuals if high risk

### Material Changes to Service

- FTC: material ToS changes require clear advance communication
- EU: consumers must be informed before changes take effect; material adverse changes may give termination rights
- Best practice: 30+ days notice, affirmative consent for material changes

---

## Compliance Checklist

### Must Do

- [ ] No deceptive or unfair practices (FTC Section 5)
- [ ] Honor implied warranties or disclaim properly (conspicuously, by name)
- [ ] If written warranty exists, comply with Magnuson-Moss
- [ ] ROSCA compliance: clear disclosure, express consent, simple cancellation
- [ ] All 50 state breach notification laws if handling personal data
- [ ] EU: 14-day withdrawal right; two-year statutory warranty
- [ ] EU (by Dec 9, 2026): Prepare for strict product liability (Directive 2024/2853)
- [ ] GDPR: 72-hour breach notification

### Should Do

- [ ] Post clear refund policies before purchase
- [ ] 30+ day advance notice for material service/pricing changes
- [ ] Cancellation as easy as signup (channel parity)
- [ ] Audit cancellation flows for dark patterns
- [ ] Keep marketing consistent with contract terms
- [ ] Implement and document cybersecurity (CRA, NIS2 for EU)
- [ ] Timely security updates throughout product lifecycle

---

*Distilled from Fetcher research (2026-03-23). Sources: FTC, Reed Smith, NCSL, Perkins Coie, Goodwin, Gibson Dunn, Wiley, EU Consumer Rights Directive.*
