# Legal Knowledge

**Domain:** Software licensing, intellectual property, privacy & data protection, SaaS compliance, contracts, and regulatory governance.

**Read this on every startup.** This cheat sheet gives you working knowledge for 90% of decisions. Pull topic files for deep-dive situations.

---

## Knowledge Files

| File | Topic | Read When... |
|------|-------|--------------|
| `open-source-licensing.md` | Open Source Licensing & Compliance | Auditing dependencies, choosing a project license, reviewing license compatibility, responding to copyleft questions |
| `ai-copyright-ip.md` | AI & Copyright / Intellectual Property | Advising on AI-generated code ownership, copyright registration, disclosure requirements, infringement liability |
| `privacy-data-protection.md` | Privacy & Data Protection | GDPR/CCPA compliance, privacy by design review, breach response, DPIA, cross-border data transfers |
| `saas-legal-requirements.md` | SaaS Legal Requirements | Pre-launch legal checklist, reviewing ToS/Privacy Policy/DPA/SLA, enterprise contract readiness |
| `software-contracts.md` | Software Contracts & Agreements | Drafting or reviewing MSAs, IP assignment, contractor agreements, licensing terms, indemnification |
| `regulatory-compliance.md` | Regulatory Compliance & AI Governance | EU AI Act, industry-specific regulations (HIPAA, PCI DSS), export controls, SOC 2/ISO 27001, AI governance frameworks |
| `us-ai-regulation.md` | US AI Regulation | Federal AI bills, state AI laws (CO, CA, TX, IL, NY), compliance deadlines, US vs EU comparison |
| `vendor-obligations.md` | Vendor & ToS Obligations | Third-party SaaS obligations, DPAs, AI vendor data/IP policies, inbound ToS red flags, clickwrap enforceability |
| `patent-strategy.md` | Patent Strategy | Software patents (Alice doctrine), PCT international filing, patent vs trade secret, AI patents, defensive strategies |
| `employment-law.md` | Employment Law | Employee vs contractor classification, IP via employment, non-competes, remote/international hiring, EOR |
| `customer-obligations.md` | Customer Obligations | Consumer protection, warranties, refunds, product liability (EU Directive 2026), auto-renewal, dark patterns |
| `digital-accessibility.md` | Digital Accessibility | ADA Title III, WCAG 2.2, EU EAA, Section 508, lawsuit trends, VPAT, compliance checklist |
| `copyright-fundamentals.md` | Copyright Fundamentals | Registration, ownership, fair use, DMCA, international (Berne Convention), content licensing, infringement remedies |

---

## Pillar 1 — Open Source Licensing

**The two families:** Permissive (use freely, keep notice) vs Copyleft (derivatives must share source under same license).

- **MIT** — Most permissive. Keep copyright notice. No patent grant. Can relicense to anything, including proprietary.
- **Apache 2.0** — Permissive + explicit patent grant + must mark modifications. Best permissive choice when patents matter.
- **GPL v2/v3** — Strong copyleft. Entire linked program must be GPL. Distribution triggers source disclosure.
- **AGPL** — GPL + network trigger. Even SaaS usage (no distribution) requires source disclosure. The "SaaS trap."
- **LGPL** — Weak copyleft. Library boundary — linking does not infect, but modifying the LGPL library itself does.

**The compatibility rule that matters most:** Permissive code CAN flow into copyleft projects. Copyleft code CANNOT flow into permissive or proprietary projects. MIT + GPL = GPL. This is one-way.

**The 56% statistic:** 56% of audited applications had license conflicts (2025 OSSRA Report). Non-compliance consequences: license termination, injunctions, damages, forced source publication.

**Compliance checklist (every release):**
1. Inventory all dependencies and their licenses
2. Flag any copyleft licenses (GPL, AGPL, LGPL, MPL)
3. Verify no copyleft-to-permissive/proprietary conflicts
4. Confirm attribution notices are included in distribution
5. For Apache 2.0 deps: verify modification notices exist

> **Pull `open-source-licensing.md`** when: auditing a dependency tree, choosing a project license, or a copyleft question arises.

---

## Pillar 2 — AI & Copyright / Intellectual Property

**The human authorship rule:** US copyright law requires human authorship. Purely AI-generated works are uncopyrightable. Supreme Court declined certiorari on *Thaler v. Perlmutter* (March 2, 2026) — this is settled law.

- **Uncopyrightable:** Code generated entirely by AI with no substantial human creative input. Anyone can use it freely.
- **Potentially copyrightable:** Human iteratively prompts, edits, selects, arranges, and refines AI output. The human contribution must be "perceptible in the output."
- **NOT enough for copyright:** Merely writing prompts. Prompts alone do not constitute authorship.
- **Registration requirement:** Works containing AI-generated material must disclose which elements are AI-generated vs human-authored.

**Three liability risks of AI-generated code:**

| Risk | Exposure | Mitigation |
|------|----------|------------|
| **Infringement** | AI may reproduce licensed code without attribution. *Doe v. GitHub* ongoing. Anthropic settled for $1.5B (2026). | Review AI output for copied code. Run license scanners. |
| **Product defects** | AI vendors disclaim liability. Due diligence obligation falls on user. | Rigorous code review before deployment. |
| **Security flaws** | AI can introduce vulnerabilities. No clear liability framework yet. | Security audit all AI-generated code. |

**Protection strategies:** Document human contributions meticulously (prompt logs, editing records, design decisions). Consider trade secret protection as alternative to copyright. Establish clear organizational AI usage policies.

> **Pull `ai-copyright-ip.md`** when: advising on ownership of AI-assisted work, copyright registration, or assessing infringement risk.

---

## Pillar 3 — Privacy & Data Protection

**GDPR essentials (EU — the global baseline):**

- **Scope:** Any entity processing EU residents' data, regardless of company location.
- **Penalties:** Up to 20M EUR or 4% of global annual turnover, whichever is higher.
- **Breach notification:** 72 hours to supervisory authority. "Without undue delay" to affected individuals if high risk.
- **Privacy by Design (Art. 25):** Not optional. Build privacy into architecture from day one. Default settings must be the most privacy-protective.
- **Data minimization:** Collect only what is necessary for a specific, documented purpose. No "just in case" data.
- **Lawful basis:** Every processing activity needs one: consent, contract, legitimate interest, legal obligation, vital interest, or public interest.

**User rights you MUST implement:**

| Right | What It Means |
|-------|---------------|
| **Access** | Users can request all their data |
| **Rectification** | Users can correct inaccurate data |
| **Erasure** | "Right to be forgotten" — users can request deletion |
| **Portability** | Users can export data in machine-readable format |
| **Objection** | Users can opt out of certain processing |

**Consent rules:** Must be freely given, specific, informed, unambiguous. Pre-ticked boxes are invalid. Must be as easy to withdraw as to give.

**CCPA/CPRA essentials (California):**
- Applies to businesses meeting revenue/data thresholds with CA residents' data.
- Rights: know, delete, opt-out of sale/sharing, correct, limit sensitive data use.
- Enforced by California Privacy Protection Agency (CPPA).
- No private right of action except for data breaches.

**The expanding landscape (2025-2026):** 8 new US state privacy laws in 2025 alone (Delaware, Iowa, New Hampshire, New Jersey, Tennessee + 3 more). Brazil (LGPD), Canada (PIPEDA), South Africa (POPIA), China (PIPL), Thailand/Singapore (PDPA). **Every project must answer: "Where are our users, what data do we collect, and which laws apply?"**

> **Pull `privacy-data-protection.md`** when: designing data architecture, handling a breach, performing a DPIA, or assessing cross-border data transfers.

---

## Pillar 4 — SaaS Legal Requirements

**The 7 documents required before any SaaS launch:**

| # | Document | Purpose | Non-Negotiable Contents |
|---|----------|---------|------------------------|
| 1 | **Terms of Service** | Defines user relationship | Acceptable use, IP ownership, limitation of liability, termination, governing law, dispute resolution |
| 2 | **Privacy Policy** | Discloses data practices | Data types, purposes, retention, third-party sharing, user rights. Must reflect ACTUAL practices. |
| 3 | **DPA** | Data processing terms | Controller/processor roles, data storage, vendor responsibilities, security controls. Required by GDPR. |
| 4 | **SLA** | Performance guarantees | Uptime targets, maintenance windows, support response times, remedies (credits/refunds) |
| 5 | **MSA** | Enterprise contract | Payment, IP rights, service scope, renewals, termination. Enables multi-order relationships. |
| 6 | **Third-Party Contracts** | Vendor governance | Data flows, storage, rights allocation, liability for vendor breaches |
| 7 | **Security Disclosures** | Trust & transparency | Data protection approach, certifications (SOC 2, ISO 27001), incident response |

**The golden rule:** "Legal documents must grow with the product." Update when adding features, changing data flows, entering new regions, or integrating new tools.

**Enterprise readiness signal:** SOC 2 certification is the de facto gate for enterprise SaaS sales. ISO 27001 for international markets.

> **Pull `saas-legal-requirements.md`** when: reviewing launch readiness, drafting legal documents, or preparing for enterprise sales.

---

## Pillar 5 — Software Contracts & Agreements

**Key contract types and when they matter:**

- **MSA (Master Service Agreement)** — Umbrella contract for ongoing relationships. Covers payment, IP, scope, liability. Individual projects governed by SOWs/Orders under the MSA.
- **IP Assignment** — Transfer of intellectual property ownership. Critical for contractor/employee work. Without explicit assignment, creator may retain rights.
- **Licensing Agreement** — Grants rights to use IP without transferring ownership. Define scope (exclusive/non-exclusive), territory, duration, sublicensing.
- **NDA** — Mutual or one-way confidentiality. Standard before sharing proprietary information. Define what is confidential, exclusions, duration, remedies.
- **Contractor Agreement** — Must include: IP assignment clause, work-for-hire language, confidentiality, non-compete (where enforceable), deliverables, payment terms.

**The IP assignment trap:** In many jurisdictions, independent contractors retain IP rights by default. Without an explicit "work made for hire" or assignment clause, the contractor owns what they built. This is the single most common legal mistake in software development.

**Indemnification basics:** Know who bears the cost if something goes wrong. Mutual indemnification is standard. Uncapped indemnification is dangerous — always negotiate caps.

> **Pull `software-contracts.md`** when: drafting or reviewing any agreement, engaging contractors, or negotiating IP terms.

---

## Pillar 6 — Regulatory Compliance & AI Governance

**EU AI Act (effective August 2025, enforcement phased through 2027):**
- **Risk-based classification:** Unacceptable (banned) > High-risk (strict rules) > Limited (transparency) > Minimal (free use).
- **GPAI (General Purpose AI) obligations:** Transparency about training data, technical documentation, copyright compliance.
- **Penalties:** Up to 35M EUR or 7% of global turnover for prohibited practices.

**Industry-specific regulations:**

| Regulation | Scope | Key Requirement |
|------------|-------|-----------------|
| **HIPAA** | US healthcare data | PHI protection, BAAs with vendors, breach notification |
| **PCI DSS** | Payment card data | Encryption, access controls, regular audits, network segmentation |
| **SOC 2** | SaaS/cloud services | Trust principles: security, availability, processing integrity, confidentiality, privacy |
| **ISO 27001** | International info security | ISMS implementation, risk assessment, continuous improvement |
| **ASC 606** | Software revenue | Revenue recognition rules for subscription/license models |

**AI governance essentials:**
- Document AI system capabilities, limitations, and intended use
- Maintain human oversight for high-risk AI decisions
- Test for bias, fairness, and accuracy before deployment
- Establish clear accountability for AI system outcomes
- Export controls may apply to AI models and training data

**The compliance priority matrix:** GDPR/privacy laws first (broadest applicability, highest penalties). Then industry-specific (HIPAA, PCI DSS). Then AI-specific (EU AI Act). Then certifications (SOC 2, ISO 27001) based on market requirements.

> **Pull `regulatory-compliance.md`** when: entering a regulated industry, deploying AI systems, pursuing certifications, or assessing export control implications.

---

## Pillar 7 — US AI Regulation

**No comprehensive federal AI law.** The US is a state patchwork: 27+ enacted laws across 14 states, 1,000+ bills introduced in 2025 alone.

- **TAKE IT DOWN Act (May 2025)** — only enacted federal AI statute. Platforms must remove non-consensual deepfakes within 48 hours. Compliance deadline: May 19, 2026.
- **Colorado AI Act (June 30, 2026)** — first comprehensive state "high-risk" AI law. Applies by impact, not company size. Risk assessments, consumer notices, opt-out, appeal mechanisms. $20K/violation.
- **Design to the strictest standard:** If you serve CA, CO, TX, IL, or NY users, you have obligations. Use NIST AI RMF as baseline (Texas gives affirmative defense).
- **US vs EU:** EU AI Act is far more prescriptive, with penalties up to 7% global turnover. Companies in both markets should design to EU standard as floor, then layer US state requirements.
- **Federal preemption attempt (Dec 2025 EO)** signals intent but EOs cannot override state laws. State laws remain enforceable until Congress acts.

> **Pull `us-ai-regulation.md`** when: evaluating AI compliance obligations, mapping applicable jurisdictions, building disclosure/transparency systems, or tracking deadlines.

---

## Pillar 8 — Vendor & ToS Obligations

**You are responsible for your vendors' failures.** If a vendor breaches, your users sue you, regulators fine you, and the vendor's liability cap (12 months of fees) rarely covers the gap.

- **DPAs are legally required** under GDPR Article 28 for any vendor processing personal data. Missing DPA = fines up to 20M EUR or 4% global turnover.
- **AI vendor data training:** Consumer tier almost certainly feeds training. Use API/enterprise tier for any business data. Anthropic retains opted-in data up to 5 years.
- **Clickwrap vs browsewrap:** 70% vs 14% court enforcement rate. Browsewrap ToS may not bind you. Clickwrap almost certainly does — read before clicking.
- **AI vendor contracts are worse than traditional SaaS:** 92% claim broad data usage (vs 63% traditional), only 17% include compliance warranties (vs 42%), only 38% cap customer liability (vs 44%).
- **Before clicking "I Agree":** Check data training, liability caps, indemnification symmetry, termination/export rights, unilateral change clauses.

> **Pull `vendor-obligations.md`** when: onboarding a new vendor, reviewing AI API terms, negotiating contracts, or responding to a vendor breach.

---

## Pillar 9 — Patent Strategy

**The Alice test controls software patentability.** Claims must demonstrate a specific technical improvement — not just "do [business thing] on a computer" or "use ML to predict [outcome]."

- **File a provisional first** — establishes priority at minimal cost ($2K-$6K). Use the 12-month window to validate market demand before committing $15K-$30K+ for non-provisional.
- **PCT buys time internationally** — single filing = legal effect in 158 countries; delays major costs to month 30. Enter national phase only in commercially important jurisdictions.
- **Patent vs trade secret is not either/or.** Patent user-visible innovations; trade-secret backend implementations. Copyright the code. Trademark the brand.
- **AI cannot be listed as inventor** in any major jurisdiction (DABUS rejected everywhere). But AI-assisted inventions ARE patentable if a human made a "significant contribution."
- **Defensive strategies:** Defensive publications ($200-$500 vs $15K+ for patents), LOT Network, Unified Patents AI Zone, Open Invention Network. NPE litigation up 15-20% in 2025.

> **Pull `patent-strategy.md`** when: deciding whether to patent, filing a provisional, evaluating international protection, responding to a patent troll, or assessing AI inventorship.

---

## Pillar 10 — Employment Law

**Misclassification is the #1 employment law violation for tech startups.** A single $100K misclassified worker can trigger $205K+ in penalties.

- **ABC test (33 states including CA, MA, NJ):** Presumed employee unless ALL three prongs met — autonomy, outside usual business, independently established trade. Failure on ANY prong = employee.
- **IP trap for contractors:** Contractors own what they create by default. Software is NOT in the 9 statutory work-for-hire categories. You MUST use IP assignment clauses. Every contractor agreement needs work-for-hire AND assignment language.
- **Non-competes:** FTC rule is dead (vacated Sept 2025). 6 states ban outright (CA, MN, MT, ND, OK, WY). 12+ states have wage thresholds. Use NDAs + non-solicitation as alternatives.
- **Remote employees = multi-state compliance.** One hire in a new state triggers tax nexus, registration, employment law obligations, and workers' comp requirements.
- **International hiring:** Most countries outside US require cause for termination + mandatory severance. Use an EOR for 1-10 employees per country; local entity for 10+.

> **Pull `employment-law.md`** when: hiring employees or contractors, classifying workers, drafting PIIAs, expanding to new states/countries, or evaluating non-competes.

---

## Pillar 11 — Customer Obligations

**Software IS a product now (EU).** The EU Product Liability Directive 2024/2853 (effective Dec 9, 2026) makes software subject to strict liability — no-fault, cannot contractually exclude, cybersecurity vulnerabilities = defects.

- **ROSCA is fully enforceable** despite FTC Click-to-Cancel vacatur. Three requirements: clear disclosure, express consent, simple cancellation (as easy as signup). Recent enforcement: $2.5B settlement, Uber (23 screens to cancel), Chegg ($7.5M).
- **Warranty disclaimers fail for 6 reasons:** buried in fine print, contradict marketing, unconscionable, violate Magnuson-Moss, fraud/concealment, no mutual assent. If you provide ANY written warranty, Magnuson-Moss prevents full disclaimer of implied warranties.
- **All 50 states** have breach notification laws. GDPR requires 72-hour notification. You must be able to notify customers of breaches, material service changes, and price increases.
- **Dark patterns are enforcement targets.** Confirmshaming, hidden costs, misdirection in cancellation flows — FTC and state AGs actively pursuing.

> **Pull `customer-obligations.md`** when: drafting customer-facing terms, reviewing cancellation flows, evaluating product liability exposure, or handling breach notification.

---

## Pillar 12 — Digital Accessibility

**8,667+ lawsuits in 2025. Overlays don't protect.** 22.6% of lawsuits targeted sites WITH accessibility widgets installed. Courts reject overlays as a defense.

- **WCAG 2.1 Level AA is the global legal standard.** Every major jurisdiction requires or references it. Build to WCAG 2.2 AA to future-proof.
- **EU EAA is now in force (June 2025).** All businesses selling in the EU must comply — regardless of headquarters. Fines up to EUR 500K+. No exemption for non-EU companies.
- **VPAT/ACR is effectively mandatory** for selling to US federal government. Increasingly required for state/local government and enterprise B2B sales.
- **Most common violations** are the easiest to fix: low contrast (79%), missing alt text (56%), missing form labels (48%), empty links (46%). Automated testing catches 30-40%; manual testing catches 60-70%.
- **E-commerce is the #1 target** (~70% of lawsuits). CA, FL, NY, IL account for 74%+ of filings.

> **Pull `digital-accessibility.md`** when: assessing accessibility compliance, creating a VPAT, responding to a lawsuit, building a remediation roadmap, or selling to government.

---

## Pillar 13 — Copyright Fundamentals

**Copyright enables open source.** The copyleft mechanism only works because code IS copyrighted. Violate GPL = lose license = copyright infringement. Understanding copyright = understanding open source.

- **Registration unlocks power:** Statutory damages ($750-$150K per work), attorney's fees, and prima facie evidence are available ONLY for timely-registered works. Register within 3 months of publication. Fee: $45-$65.
- **Google v. Oracle (2021):** Landmark — reimplementing functional APIs for a new platform is fair use. But this does NOT mean all API copying is fair use; the transformative purpose and different market were key.
- **DMCA safe harbor is essential** for platforms hosting user content. Requirements: register DMCA agent ($6), adopt repeat infringer policy, respond to takedowns expeditiously, no actual knowledge of infringement.
- **Berne Convention:** Your software is automatically protected in 181 countries. No foreign registration needed. But enforcement is territorial — must enforce under local law.
- **Content licensing:** CC licenses are NOT for software (use OSI-approved). Stock licenses vary by scope, exclusivity, and AI training restrictions. UGC terms must grant you a license (users retain copyright).

> **Pull `copyright-fundamentals.md`** when: registering copyright, evaluating fair use, setting up DMCA processes, licensing content, or assessing international protection. Complements `ai-copyright-ip.md` for AI-specific copyright.

---

## Quick Decision Framework

When Legal is asked to evaluate something, run through this checklist:

1. **Licensing** — Does this project use open source? Are all licenses compatible? Is copyleft present?
2. **IP Ownership** — Who owns this code? Is AI-generated content involved? Are assignments in place?
3. **Privacy** — Does this touch personal data? Which jurisdictions? Which laws apply?
4. **Contracts** — Are the right agreements in place? IP assignment? Indemnification?
5. **Regulatory** — Is this a regulated industry? Does AI governance apply? Export controls?
6. **Launch Gate** — If SaaS: do all 7 legal documents exist and reflect current practices?
7. **AI Regulation** — Does this product use AI? Which states/countries are users in? Are disclosures, risk assessments, and bias testing required?
8. **Vendors** — What third-party SaaS/AI APIs are used? Are DPAs signed? Is data training opted out? Are ToS acceptable?
9. **Patents** — Is there a patentable innovation? Should we file a provisional? Is a freedom-to-operate search needed?
10. **Employment** — Are workers properly classified? Are PIIAs signed? Do non-competes comply with state law? Multi-state or international compliance issues?
11. **Customer Obligations** — Are warranties properly disclaimed? Is cancellation as easy as signup? Are breach notification procedures ready? EU product liability exposure?
12. **Accessibility** — Does the product meet WCAG 2.1 AA? Is a VPAT needed? Are we selling to government or in the EU?
13. **Copyright** — Is core code registered? Are DMCA processes in place? Fair use reliance documented? Content properly licensed?

---

*Knowledge curated 2026-03-24. Covers 13 pillars: open source licensing, AI copyright, privacy law, SaaS legal requirements, software contracts, regulatory compliance, US AI regulation, vendor/ToS obligations, patent strategy, employment law, customer obligations, digital accessibility, and copyright fundamentals — distilled from Fetcher research (14 sources) plus professional legal counsel knowledge. Request Fetcher to add sources when you identify knowledge gaps.*
