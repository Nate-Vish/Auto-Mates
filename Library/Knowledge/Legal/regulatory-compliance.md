# Regulatory Compliance & AI Governance

**Deep-dive reference.** Pull this file when entering a regulated industry, deploying AI systems, pursuing certifications, or assessing export control implications.

---

## EU AI Act

**Status:** Entered into force August 1, 2025. Enforcement phased through 2027.

### Risk-Based Classification

| Risk Level | Treatment | Examples |
|------------|-----------|---------|
| **Unacceptable** | **Banned** | Social scoring by governments, real-time biometric identification in public spaces (with exceptions), manipulation of vulnerable persons, emotion recognition in workplace/education |
| **High-Risk** | Strict requirements | Critical infrastructure, education/employment decisions, law enforcement, migration/asylum, credit scoring, insurance |
| **Limited Risk** | Transparency obligations | Chatbots (must disclose AI), deepfakes (must label), emotion recognition systems |
| **Minimal Risk** | No restrictions | Spam filters, AI in video games, most general-purpose software |

### High-Risk AI Requirements

Systems classified as high-risk must implement:
- **Risk management system** — continuous identification and mitigation of risks
- **Data governance** — training data must be relevant, representative, free of errors
- **Technical documentation** — detailed description of the system, its purpose, limitations
- **Record-keeping** — automatic logging of system operation for traceability
- **Transparency** — users must be informed they are interacting with AI
- **Human oversight** — humans must be able to intervene and override
- **Accuracy, robustness, cybersecurity** — appropriate levels for the risk

### General Purpose AI (GPAI) Obligations

| GPAI Type | Requirements |
|-----------|-------------|
| **All GPAI** | Technical documentation, training data transparency (copyright compliance), downstream provider information |
| **GPAI with systemic risk** | Model evaluation, adversarial testing, incident reporting, cybersecurity measures |

### Penalties

| Violation | Maximum Fine |
|-----------|-------------|
| Prohibited AI practices | 35M EUR or 7% global turnover |
| High-risk non-compliance | 15M EUR or 3% global turnover |
| Incorrect information | 7.5M EUR or 1.5% global turnover |

### Timeline

| Date | Milestone |
|------|-----------|
| August 2025 | Act enters into force; prohibited practices enforced |
| February 2026 | GPAI obligations apply |
| August 2026 | High-risk AI system requirements apply |
| August 2027 | Full enforcement of all provisions |

---

## Industry-Specific Regulations

### HIPAA (US Healthcare)

**Applies to:** Covered entities (healthcare providers, health plans, clearinghouses) and their business associates.

**Key Requirements:**
- **Protected Health Information (PHI)** — any individually identifiable health data
- **Business Associate Agreements (BAAs)** — required with every vendor handling PHI
- **Minimum Necessary Rule** — access only the minimum PHI needed for the task
- **Breach notification** — notify HHS, affected individuals, and media (if 500+ affected)
- **Security Rule** — administrative, physical, and technical safeguards

**For Software:** If your product touches health data in the US, HIPAA likely applies. Even analytics on health-related data can trigger compliance obligations.

### PCI DSS (Payment Cards)

**Applies to:** Any entity that stores, processes, or transmits cardholder data.

**Key Requirements:**
- Encryption of cardholder data in transit and at rest
- Access controls and authentication
- Regular vulnerability scans and penetration tests
- Network segmentation
- Incident response plan
- Quarterly ASV (Approved Scanning Vendor) scans
- Annual compliance validation (SAQ or ROC depending on volume)

**For Software:** Use established payment processors (Stripe, etc.) to minimize PCI scope. Never store raw card numbers if avoidable.

### ASC 606 (Revenue Recognition)

**Applies to:** Software companies recognizing revenue from contracts with customers.

**Key Principles:**
- Identify performance obligations in the contract
- Determine the transaction price
- Allocate price to performance obligations
- Recognize revenue when obligations are satisfied
- Software subscriptions: recognize ratably over the subscription period
- Perpetual licenses: recognize at delivery (if distinct)

---

## Compliance Certifications

### SOC 2

**What:** Trust service criteria audit for service organizations. Developed by AICPA.

**Five Trust Principles:**

| Principle | What It Covers |
|-----------|---------------|
| **Security** | Protection against unauthorized access (required) |
| **Availability** | System uptime and accessibility |
| **Processing Integrity** | Accurate, timely, authorized processing |
| **Confidentiality** | Protection of confidential information |
| **Privacy** | Personal information handling |

**Types:**
- **Type I** — controls are suitably designed at a point in time
- **Type II** — controls are operating effectively over a period (typically 6-12 months)

**Why it matters:** Type II is the de facto requirement for enterprise SaaS sales in the US. Enterprise procurement teams ask for it early. Budget 3-6 months and $20K-100K+ for initial audit.

### ISO 27001

**What:** International standard for Information Security Management Systems (ISMS).

**Key Requirements:**
- Risk assessment and treatment methodology
- Statement of Applicability (which controls apply)
- Implementation of Annex A controls (93 controls across 4 themes)
- Internal audit program
- Management review
- Continuous improvement

**Why it matters:** International standard recognized globally. Expected by EU enterprise customers. Demonstrates systematic approach to information security.

### SOC 2 vs ISO 27001

| Aspect | SOC 2 | ISO 27001 |
|--------|-------|-----------|
| **Origin** | US (AICPA) | International (ISO/IEC) |
| **Focus** | Service organization controls | Information security management system |
| **Market** | Dominant in US | Dominant internationally |
| **Output** | Audit report | Certification |
| **Duration** | Annual report | 3-year certificate with surveillance audits |
| **Cost** | $20K-100K+ | $15K-50K+ |

---

## AI Governance Framework

### Documentation Requirements

For any AI system deployed in production:
- **System description** — what it does, how it works, intended use cases
- **Training data** — sources, preprocessing, known limitations and biases
- **Performance metrics** — accuracy, precision, recall, fairness metrics across demographics
- **Limitations** — known failure modes, edge cases, out-of-scope uses
- **Human oversight** — how humans monitor and override the system
- **Update/retraining policy** — when and how the model is updated

### Bias and Fairness

- Test for disparate impact across protected categories (race, gender, age, disability)
- Document fairness metrics chosen and their values
- Establish monitoring for drift in fairness metrics over time
- Maintain audit trail of model versions and performance changes

### Accountability

- Designate responsible person(s) for each AI system
- Clear escalation path for AI-related incidents
- Regular review cycle (at minimum annually)
- Incident response plan specific to AI failures (hallucinations, biased outputs, safety failures)

---

## Export Controls

### When They Apply

- AI models and certain algorithms may be classified as controlled technology
- Dual-use items (civilian/military application) are subject to export control
- Training data derived from controlled sources may inherit restrictions
- Cloud services processing controlled data must comply

### Key Frameworks

| Framework | Jurisdiction | Scope |
|-----------|-------------|-------|
| **EAR** (Export Administration Regulations) | US | Dual-use items, commercial technology |
| **ITAR** (International Traffic in Arms Regulations) | US | Defense articles and services |
| **Wassenaar Arrangement** | 42 member states | Conventional arms and dual-use technologies |
| **EU Dual-Use Regulation** | EU | Dual-use items including cyber-surveillance |

### Practical Implications

- Certain encryption algorithms require export classification
- AI models trained on satellite imagery or geospatial data may be controlled
- Providing AI services to sanctioned countries/entities is prohibited
- Open-source publication may qualify for exclusions (but not always)
- **When in doubt, get a formal export classification before distributing internationally**

---

## Compliance Priority Matrix

When starting compliance work, prioritize based on risk and applicability:

| Priority | Domain | Trigger |
|----------|--------|---------|
| **1 (Immediate)** | Privacy laws (GDPR, CCPA) | Handling any personal data |
| **2 (Before launch)** | SaaS legal documents | Launching a product/service |
| **3 (Industry-driven)** | HIPAA, PCI DSS | Entering healthcare or payments |
| **4 (Market-driven)** | SOC 2 / ISO 27001 | Enterprise sales pipeline |
| **5 (AI-specific)** | EU AI Act, AI governance | Deploying AI systems |
| **6 (International)** | Export controls | Distributing technology across borders |

---

*Knowledge distilled from EU AI Act text, industry compliance standards, and professional regulatory counsel expertise. Updated 2026-03-23.*
