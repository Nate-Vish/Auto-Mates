# US AI Regulation

**Domain:** Federal and state AI legislation in the United States — enacted laws, pending bills, compliance deadlines, and US vs EU comparison.

**Last Updated:** 2026-03-24

---

## The Landscape

As of March 2026, the US has **no comprehensive federal AI law**. The regulatory environment is defined by:

- One enacted federal statute: the **TAKE IT DOWN Act** (May 2025) — targets non-consensual deepfakes
- A December 2025 Executive Order signaling intent to preempt state laws (but EOs cannot override state law — only Congress or courts can)
- **27+ enacted state laws across 14 states** (2023-2025), with 1,000+ bills introduced in 2025 alone
- The EU AI Act entering high-risk enforcement August 2, 2026 — setting the global benchmark

---

## Federal Legislation

### TAKE IT DOWN Act (Enacted May 19, 2025)

The first standalone federal AI harm statute.

- **Scope:** Platforms hosting user-generated content
- **Compliance deadline:** May 19, 2026
- **Requires:** Platforms remove flagged non-consensual intimate images (including AI-generated deepfakes) within **48 hours** of valid complaints
- **Penalties:** Up to 3 years imprisonment (criminal); platforms must demonstrate compliance through infrastructure, not just policy
- **Developer obligations:** Build systems to identify AI-generated content, evaluate takedown requests, execute removal, document the process; maintain audit trails (model selection, inputs, outputs, verification, approval chains)

### Executive Order: National AI Policy Framework (Dec 11, 2025)

- Establishes AI Litigation Task Force (DOJ) to challenge "onerous" state AI laws
- Commerce Department must evaluate state AI laws by **March 11, 2026**
- Specifically cited Colorado's AI Act as excessive
- **Critical limitation:** An EO cannot directly overturn state laws — state laws remain enforceable until Congress acts or courts rule
- **Excluded from preemption:** Child safety laws, AI infrastructure regulations, government procurement rules

### Proposed Federal Bills

| Bill | Status | What It Does |
|------|--------|-------------|
| **TRUMP AMERICA AI Act** | Proposed (Jan 2026) | Would codify Dec 2025 EO into statute; comprehensive federal framework; preempt some state laws |
| **AI LEAD Act** | Pending | Product liability framework for AI systems — developer/deployer liability standards |

### Failed: 10-Year State Preemption

Congress **rejected** a budget provision that would have blocked state AI enforcement for ten years (May 2025), leaving state authority intact.

---

## Key State Laws

### Colorado SB 24-205 (Colorado AI Act)

**Effective June 30, 2026** — First US statute comprehensively targeting "high-risk" AI systems.

- **Scope:** Developers and deployers of AI making "consequential decisions" (employment, housing, credit, healthcare, insurance, education, legal services)
- **Applies by impact, not company size** — a small company deploying AI in healthcare is in scope
- **Developer duties:** Documentation to deployers, impact assessments, public website notices
- **Deployer duties:** Risk management (NIST AI RMF recommended), consumer notices, opt-out rights, appeal mechanisms, anti-discrimination safeguards
- **Penalties:** Up to $20,000 per violation (Colorado AG enforcement)

### Texas HB 149 (TRAIGA)

**Effective January 1, 2026**

- Clear AI interaction disclosure required
- Prohibits: self-harm encouragement, unlawful discrimination, constitutional rights infringement, CSAM, biometric ID, social scoring
- **Affirmative defense** for following NIST AI Risk Management Framework
- Penalties: $10K-$200K per violation; $2K-$40K/day for continuing violations

### New York RAISE Act

**Effective January 1, 2027** — Targets frontier model developers with >$500M annual revenue.

- Written safety protocols, AI impact assessments, 72-hour incident reporting
- Penalties: $1M first violation; $3M subsequent

### Other Enacted State Laws

| State | Law | Effective | Key Provision |
|-------|-----|-----------|--------------|
| **Utah** | SB 226 | May 2025 | Disclose AI use on consumer request; $5K/violation |
| **Montana** | SB 212 | Oct 2025 | Right to Compute — cannot restrict lawful computing activities |
| **California** | SB 53 | Jan 2026 | Frontier model transparency (>10^26 FLOPS); $1M/violation |
| **California** | AB 2013 | Jan 2026 | AI training data transparency (under legal challenge by xAI) |
| **California** | SB 243 | Jan 2026 | AI companion chatbot safety; self-harm detection; $1K+/violation with private right of action |
| **California** | AB 853 (CAITA) | Phased Aug 2026+ | AI content watermarking; $5K/violation/day |
| **Illinois** | HB 3773 | Jan 2026 | AI in employment without notice = civil rights violation; private right of action |

---

## Employment & Automated Decision-Making

### NYC Local Law 144 (AEDTs) — Effective Since July 2023

- Annual independent bias audit for automated employment decision tools
- 10-day notice to candidates before use; alternative process option
- Penalties: $500-$1,500 per day per violation

### California CPPA/CPRA (ADMT Rules)

- Phased: Jan 2026 through April 2028
- Risk assessments, pre-use notices, consumer opt-out, human review rights
- Penalties: $2,500/violation; $7,500 intentional or involving minors

### Illinois AIVIA — Video interview AI requires informed consent; restrict sharing; delete on request within 30 days

### Maryland HB 1202 — Written consent for facial recognition in job interviews

---

## Federal Agency Enforcement (Existing Authority)

Even without comprehensive AI law, agencies enforce AI rules under existing statutes:

| Agency | Focus | Authority |
|--------|-------|-----------|
| **FTC** | AI washing, misleading claims, privacy, fake reviews, algorithmic pricing | Section 5 unfair/deceptive practices |
| **SEC** | AI disclosures, conflicts of interest, investment AI washing | Securities laws |
| **EEOC** | AI hiring/promotion discrimination | Title VII, ADA, ADEA |
| **DOJ** | AI compliance in corporate programs; state preemption via EO | Federal criminal law |
| **FDA** | Medical device AI | Software-as-a-Medical-Device framework |

### Voluntary Frameworks

- **NIST AI Risk Management Framework (Jan 2023):** Non-binding but influential. Texas provides affirmative defense for compliance.
- **NIST Generative AI Profile (July 2024):** 400+ recommended actions for generative AI lifecycle.

---

## US vs EU Comparison

| Dimension | United States | EU AI Act |
|-----------|--------------|-----------|
| **Approach** | State patchwork + sector-specific federal enforcement | Single comprehensive regulation |
| **Binding law** | 1 federal statute + 27+ state laws | One regulation with direct effect in all EU countries |
| **Risk classification** | Varies by state | Mandatory 4-tier: unacceptable, high, limited, minimal |
| **Scope** | Varies by jurisdiction, often threshold-based | Any AI placed on EU market or affecting EU persons |
| **Maximum penalties** | $1M/violation (CA SB 53); 3 years prison (TAKE IT DOWN) | Up to 35M EUR or **7% global turnover** |
| **Preemption** | Federal attempting to preempt state (contested) | Harmonized across member states by design |

**Key takeaway:** Companies operating globally should design to the EU AI Act standard as the compliance floor, then layer US state-specific requirements on top.

---

## Critical Compliance Deadlines

| Date | Law | What Happens |
|------|-----|-------------|
| **Mar 11, 2026** | Trump EO | Commerce Dept. evaluation of state AI laws due |
| **May 19, 2026** | TAKE IT DOWN Act | Platforms must have takedown systems operational |
| **Jun 30, 2026** | Colorado AI Act | Takes effect |
| **Aug 2, 2026** | CA AB 853; EU AI Act high-risk | CA watermarking; EU high-risk obligations |
| **Jan 1, 2027** | NY RAISE Act; CA CPPA ADMT; CA SB 942 | Major enforcement wave |
| **Apr 1, 2028** | CA CPPA | Full ADMT attestations due |

---

## Practical Guidance

### Immediate Actions

1. **Map your AI systems** — inventory every AI/ML tool, model, and automated decision system; classify by risk and jurisdiction
2. **Identify applicable laws** — if you serve CA, CO, TX, IL, or NY users, you likely have obligations (scope is based on impact, not company size)
3. **Implement disclosures** — chatbot nature, employment AI use, pricing algorithms, AI-generated content labeling
4. **Document risk assessments** — use NIST AI RMF as baseline (Texas gives affirmative defense)
5. **Build bias testing** — annual independent audits for employment AI (NYC); ongoing monitoring (CA, CO)
6. **Build takedown infrastructure** — 48-hour removal for UGC platforms by May 2026

### Architecture Recommendations

- **Audit trails:** Log model selection, inputs, outputs, verification, approval chains
- **Human-in-the-loop:** Opt-out and human review paths for consequential decisions
- **Content provenance:** C2PA or similar watermarking (required by CA AB 853)
- **Modular compliance:** Jurisdiction-aware feature flags for state-specific disclosures

### What to Watch

- Commerce Dept. report (due March 11, 2026) on "onerous" state laws
- TRUMP AMERICA AI Act passage prospects
- xAI v. California (AB 2013 challenge) — could invalidate training data disclosure
- EU AI Act high-risk obligations (Aug 2, 2026) — global benchmark
- 2026 state legislative sessions — expect 1,000+ new AI bills

---

*Distilled from Fetcher research (2026-03-23). Sources: Gunderson Dettmer, Baker Botts, Drata, CleanAim, NCSL, White House, King & Spalding, Future of Privacy Forum, and others.*
