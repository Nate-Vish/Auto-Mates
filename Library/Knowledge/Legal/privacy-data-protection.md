# Privacy & Data Protection

**Deep-dive reference.** Pull this file when designing data architecture, handling a breach, performing a DPIA, assessing cross-border transfers, or determining which privacy laws apply.

---

## GDPR (General Data Protection Regulation)

**Jurisdiction:** Any entity processing personal data of EU/EEA residents, regardless of where the entity is located.

### 7 Core Principles (Article 5)

| Principle | Meaning |
|-----------|---------|
| **Lawfulness, fairness, transparency** | Process data legally, fairly, and with clear communication to the data subject |
| **Purpose limitation** | Collect for specified, explicit, legitimate purposes only |
| **Data minimization** | Collect only what is necessary — no "just in case" data |
| **Accuracy** | Keep data accurate and up to date |
| **Storage limitation** | Retain only as long as necessary for the purpose |
| **Integrity and confidentiality** | Protect against unauthorized access, loss, or destruction |
| **Accountability** | Controller must demonstrate compliance |

### Lawful Bases for Processing (Article 6)

You must have at least one for every processing activity:

| Basis | When to Use | Notes |
|-------|-------------|-------|
| **Consent** | User explicitly agrees | Must be freely given, specific, informed, unambiguous. Pre-ticked boxes invalid. |
| **Contract** | Processing necessary to fulfill a contract | e.g., processing payment data for a purchase |
| **Legitimate interest** | Business has a justified reason | Requires balancing test against data subject rights |
| **Legal obligation** | Required by law | e.g., tax records, regulatory reporting |
| **Vital interest** | Protect someone's life | Rarely applicable in software context |
| **Public interest** | Public authority tasks | Government/public sector |

### Data Subject Rights

Every system processing EU personal data must support these:

| Right | Article | Requirement | Response Time |
|-------|---------|-------------|--------------|
| **Access** | Art. 15 | Provide copy of all personal data held | 30 days |
| **Rectification** | Art. 16 | Correct inaccurate data | 30 days |
| **Erasure** | Art. 17 | Delete data ("right to be forgotten") | 30 days |
| **Portability** | Art. 20 | Export data in machine-readable format | 30 days |
| **Restriction** | Art. 18 | Stop processing (but keep data) | 30 days |
| **Objection** | Art. 21 | Opt out of processing based on legitimate interest | Without undue delay |
| **Automated decisions** | Art. 22 | Right not to be subject to solely automated decisions with legal effects | 30 days |

### Privacy by Design & Default (Article 25)

This is a legal requirement, not a best practice:
- Integrate privacy at every stage of development — architecture, design, implementation, testing
- Default settings must be the most privacy-protective option
- Only process data necessary for each specific purpose
- Pseudonymize or anonymize where possible

### Data Protection Impact Assessment (DPIA) — Article 35

**Required when processing is "likely to result in a high risk" to individuals:**
- Systematic profiling with significant effects
- Large-scale processing of sensitive data (health, biometrics, criminal records)
- Systematic monitoring of publicly accessible areas
- New technologies with unknown privacy risks

**DPIA must contain:** Description of processing, necessity assessment, risk assessment, mitigation measures.

### Breach Notification

| Who | Timeline | Condition |
|-----|----------|-----------|
| **Supervisory authority** | Within **72 hours** of awareness | Unless breach unlikely to result in risk to individuals |
| **Affected individuals** | "Without undue delay" | When breach likely to result in **high risk** to their rights |

### Penalties

| Tier | Maximum | Violations |
|------|---------|------------|
| **Lower** | 10M EUR or 2% global turnover | Technical/organizational failures, record-keeping |
| **Higher** | 20M EUR or 4% global turnover | Principles violations, consent failures, data subject rights violations, international transfers |

### Cross-Border Data Transfers

EU personal data cannot be transferred outside the EU/EEA unless:
- **Adequacy decision** — destination country deemed adequate by EC (e.g., Japan, UK, South Korea)
- **Standard Contractual Clauses (SCCs)** — approved contract terms between exporter and importer
- **Binding Corporate Rules (BCRs)** — for intra-group transfers in multinationals
- **Explicit consent** — data subject explicitly agrees (limited use)

### Third-Party Processing

- **Data Processing Agreement (DPA)** required with every processor (Article 28)
- Controller responsible for processor compliance
- Processor must only act on controller's documented instructions
- Sub-processor engagement requires controller authorization

---

## CCPA / CPRA (California)

**Jurisdiction:** Businesses meeting ANY threshold that handle California residents' personal information:
- Annual gross revenue > $25 million, OR
- Buy/sell/share personal information of 100,000+ consumers/households, OR
- Derive 50%+ revenue from selling/sharing personal information

### Consumer Rights

| Right | Description |
|-------|-------------|
| **Right to Know** | What personal information is collected, used, shared |
| **Right to Delete** | Request deletion of personal information |
| **Right to Opt-Out** | Opt out of sale or sharing of personal information |
| **Right to Non-Discrimination** | No penalty for exercising privacy rights |
| **Right to Correct** | (CPRA) Correct inaccurate personal information |
| **Right to Limit** | (CPRA) Limit use of sensitive personal information |

### Key Differences from GDPR

| Aspect | GDPR | CCPA/CPRA |
|--------|------|-----------|
| **Scope** | All data processors of EU residents | Businesses meeting thresholds |
| **Opt-in vs Opt-out** | Opt-in consent required | Opt-out model (consumers must act) |
| **Private right of action** | Limited | Only for data breaches |
| **Enforcement** | Supervisory authorities | California AG + CPPA |
| **Penalties** | Up to 4% turnover | $2,500/violation, $7,500/intentional |

---

## US State Privacy Laws (2025-2026)

The US has no federal privacy law. States are passing their own:

| State | Law | Key Feature |
|-------|-----|-------------|
| California | CCPA/CPRA | Most comprehensive, broadest scope |
| Virginia | VCDPA | Sensitive data opt-in, no private right of action |
| Colorado | CPA | Universal opt-out mechanism |
| Connecticut | CTDPA | Similar to Virginia |
| Utah | UCPA | Business-friendly, narrow scope |
| Delaware | DPDPA | Effective 2025 |
| Iowa | ICDPA | Effective 2025 |
| New Hampshire | SB255 | Effective 2025 |
| New Jersey | SB332 | Effective 2025 |
| Tennessee | TIPA | Effective 2025 |

**Trend:** Converging toward GDPR-like rights but with opt-out models. No signs of federal preemption.

---

## International Frameworks

| Framework | Jurisdiction | GDPR-Similar? | Key Difference |
|-----------|-------------|---------------|----------------|
| **LGPD** | Brazil | Very similar | Independent authority (ANPD) |
| **PIPEDA** | Canada | Moderate | "Reasonable person" standard |
| **POPIA** | South Africa | Similar | Consent-focused |
| **PIPL** | China | Structural similarity | Government access provisions, data localization |
| **PDPA** | Thailand, Singapore | Similar | Varying enforcement maturity |

---

## Privacy Compliance Implementation

### For Every New Project

1. **Data mapping** — What personal data? Where stored? Who processes? Where transferred?
2. **Legal basis inventory** — Document lawful basis for every processing activity
3. **Privacy policy** — Accurate, current, covering all applicable laws
4. **Consent mechanism** — If relying on consent: opt-in, specific, withdrawable
5. **Rights infrastructure** — Technical ability to fulfill access, deletion, portability requests
6. **Retention schedule** — Define and enforce data retention periods
7. **Vendor assessment** — DPAs with all processors, due diligence on their practices
8. **DPIA** — If high-risk processing is involved
9. **Breach response plan** — Detection, assessment, notification procedures ready

### Privacy by Design Checklist (For Builder)

- [ ] Minimize data collection to what is strictly necessary
- [ ] Default settings are most privacy-protective
- [ ] Data encrypted at rest and in transit
- [ ] Access controls enforce least privilege
- [ ] User consent is explicit and granular
- [ ] Data deletion mechanisms are functional and tested
- [ ] Data export (portability) is available in standard format
- [ ] Logs do not contain unnecessary personal data
- [ ] Third-party SDKs/services assessed for privacy compliance
- [ ] Retention policies enforced automatically

---

*Sources: Fetcher research — gdpr_software_development.md (Codific), privacy_law_landscape_2025.md (SecurePrivacy). Updated 2026-03-23.*
