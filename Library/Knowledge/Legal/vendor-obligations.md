# Vendor Obligations

**Domain:** Third-party SaaS vendor obligations (what you owe vendors, what they owe you) and evaluating inbound Terms of Service before you click "I Agree."

**Last Updated:** 2026-03-24

---

## Part 1 — Obligations When Using Third-Party SaaS

### Three Categories of Obligation

**Contractual:** ToS compliance, Acceptable Use Policy, payment obligations, data handling per vendor terms.

**Regulatory:** Data protection laws (GDPR, CCPA, 24+ US state privacy laws), industry rules (HIPAA, PCI-DSS, SOX, FERPA), cross-border transfer rules (SCCs).

**Operational:** Shared responsibility model (you own access control, credentials, configuration), incident response procedures, audit and documentation.

---

## Part 2 — Data Processing Agreements (DPAs)

### When Required

A DPA is **legally required under GDPR (Article 28)** whenever a third party processes personal data on your behalf. This includes virtually every SaaS vendor that touches user data — CRMs, analytics, cloud infra, AI APIs, email services.

**Even if you are not EU-based**, if you have any EU users, GDPR applies and DPAs are required.

### Mandatory DPA Elements (Article 28)

1. Processing instructions — what data, what purpose, whose instructions
2. Confidentiality obligations for staff
3. Appropriate technical and organizational security measures
4. Subprocessor management — prior authorization required
5. Assistance with data subject rights (access, deletion, portability)
6. Breach notification timeline (typically 24-72 hours)
7. Data return or deletion upon termination
8. Audit rights

### Penalties for Missing DPAs

Up to **20M EUR or 4% of global annual turnover**. The GDPR Enforcement Tracker documents 1.1M EUR+ in fines across 14 enforcement actions specifically for inadequate DPAs.

### Practical Tips

- Most major vendors (AWS, Google, Microsoft, Anthropic, Stripe) have pre-signed DPAs — accept through account settings
- Maintain a centralized DPA register — vendor, DPA status, expiration, subprocessor list
- If a vendor refuses to sign a DPA or doesn't have one, **do not send them personal data**

---

## Part 3 — The Liability Chain

**If your vendor suffers a data breach, you are still responsible to your users.**

1. Your users sue/complain to **you** — you are the data controller
2. Regulators fine **you** — GDPR holds controllers primarily accountable
3. You seek indemnification from the vendor — but capped at 12 months of fees (typically)
4. **The gap is yours** — fines, settlements, and business losses almost always exceed the vendor's cap

### Reducing Exposure

- Negotiate breach notification timelines — faster knowledge = faster response
- Require cyber insurance from critical vendors (or carry your own)
- Limit data sharing — minimum necessary personal data per vendor
- Maintain your own backups
- Document due diligence — regulators look favorably on demonstrated vendor assessment
- Have a tested playbook for vendor breach scenarios

---

## Part 4 — AI Vendor Specifics

### IP Ownership of AI Outputs

| Platform | Output Ownership | Commercial Use | IP Indemnification |
|----------|-----------------|----------------|-------------------|
| **OpenAI** | Assigned to user | All tiers | Enterprise only (Copyright Shield, $60K+/yr) |
| **Anthropic** | Assigned to user | Business/Enterprise | Enterprise tier only |
| **Google (Gemini)** | Not claimed | Workspace/Enterprise | None |
| **Microsoft (Copilot)** | Assigned to user | All business tiers | Full for eligible business customers |
| **Midjourney** | User owns (paid only) | Paid tiers | None |
| **Perplexity** | Silent on ownership | Ambiguous | None |

**Critical caveat:** Pure AI-generated content cannot be copyrighted under current US law. You own the output contractually, but may not enforce copyright on purely AI-generated work.

### Data Training Policies

| Platform | Consumer Tier | API Tier | Enterprise Tier |
|----------|--------------|----------|-----------------|
| **OpenAI** | Used for training (opt-out available) | NOT used | NOT used + guarantee |
| **Anthropic** | Used (opt-out in settings; retained up to 5 years) | NOT used | NOT used + guarantee |
| **Google** | May be used | NOT used (Workspace) | NOT used + guarantee |
| **Microsoft** | Varies | NOT used | NOT used + guarantee |

**Key rule:** If sending sensitive or proprietary data to an AI API, **use API or enterprise tier, never consumer chat**.

### AI Vendor Contract Statistics (TermScout Data)

| Metric | AI Vendors | Traditional SaaS |
|--------|-----------|------------------|
| Claim broad data usage rights | 92% | 63% |
| Cap vendor liability | 88% | 81% |
| Cap customer liability | 38% | 44% |
| Include compliance warranties | 17% | 42% |
| Provide IP indemnification | 33% | ~50% |

---

## Part 5 — Evaluating Inbound ToS

### The "Before You Click" Red Flags

- [ ] **Unilateral change rights** — vendor modifies at "sole discretion" without notice
- [ ] **Vague data usage** — "we may use data to improve our services" without specifics
- [ ] **Auto-renewal traps** — no clear cancellation window; unilateral rate increases
- [ ] **Missing audit rights** — no SOC 2, no compliance reports, no audit access
- [ ] **Broad IP assignment** — claims ownership or broad licenses over your inputs/outputs
- [ ] **No offboarding plan** — no data export, no transition assistance
- [ ] **Unlimited indemnification** — you indemnify vendor without caps or reciprocity
- [ ] **No SLA or performance warranties** — zero accountability for defects

### Clickwrap vs Browsewrap Enforceability

| Type | Court Enforcement Rate | Key Requirement |
|------|----------------------|-----------------|
| **Clickwrap** | ~70% | Clear display + affirmative action (click/check) |
| **Sign-in-wrap** | ~50% | Conspicuous notice near action button |
| **Browsewrap** | ~14% | Almost never enforced without proof of actual knowledge |

**Practical implication:** Browsewrap ToS may not bind you. Clickwrap ToS almost certainly do — which is why reading matters.

### Critical Clauses to Scrutinize

**Indemnification:** Push for mutual, capped, with carve-outs for vendor negligence and data breaches. One-way unlimited indemnification is a financial time bomb for startups.

**Limitation of Liability:** Vendor caps at 12 months of fees are standard, but negotiate uncapped or higher caps for data breaches, IP infringement, and gross negligence.

**Governing Law:** Prefer neutral jurisdiction. Non-exclusive jurisdiction (either party can file locally).

**Mandatory Arbitration:** Negotiate carve-outs for IP disputes and injunctive relief.

### Data Rights Questions

1. Who owns your input data and outputs?
2. What license do you grant the vendor? (watch for "worldwide, perpetual, sublicensable")
3. Can they train AI models on your data?
4. Can they share with third parties?
5. Where is data stored?
6. What happens to data after termination?

### Termination & Data Portability

- **EU Data Act (effective Sept 12, 2025):** Maximum 2-month termination notice; 30-day data transfer period; machine-readable export required; switching charges prohibited from Jan 2027; applies retroactively to pre-Sept 2025 contracts; extraterritorial reach
- Negotiate: data export format (standard, machine-readable), export timeline (30 days minimum), deletion confirmation in writing, transition assistance, API access during wind-down

### Negotiation Reality

| Spend Level | Negotiability | Your Leverage |
|-------------|--------------|---------------|
| Free/self-serve | None | Zero |
| $100-1K/mo | Minimal (maybe DPA) | Low |
| $1K-10K/mo | Moderate (DPA, SLA, some liability) | Medium |
| $10K+/mo | Substantial | High |
| $100K+/yr | Full custom MSA | Very High |

**Even if too small for custom terms:** Ask for a DPA, request security docs, toggle off data training, request subprocessor list, document conversations.

---

## Vendor Risk Management Checklist

### Before Signup

- [ ] Read ToS, Privacy Policy, AUP, DPA, and SLA
- [ ] Create vendor register: name, data accessed, legal basis, DPA status
- [ ] Sign/accept DPAs for all vendors processing personal data
- [ ] Configure privacy settings (opt out of AI training on consumer tiers)
- [ ] Set up MFA and SSO for all vendor accounts

### Quarterly

- [ ] Re-review vendor ToS for changes (especially AI vendors)
- [ ] Check subprocessor lists for changes
- [ ] Verify DPA coverage is current
- [ ] Test data export/portability from critical vendors
- [ ] Remove departed employees from vendor accounts

### Annually

- [ ] Full vendor risk reassessment
- [ ] Review cyber insurance coverage for third-party breach
- [ ] Update incident response playbook for vendor breach scenarios
- [ ] Evaluate concentration risk and identify alternatives

---

*Distilled from Fetcher research (2026-03-23). Sources: Stanford Law/CodeX, TermScout, ABA, EU Data Act, GDPR Article 28, AI platform policies comparison.*
