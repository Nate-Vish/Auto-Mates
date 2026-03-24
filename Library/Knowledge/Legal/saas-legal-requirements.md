# SaaS Legal Requirements

**Deep-dive reference.** Pull this file when reviewing launch readiness, drafting legal documents, or preparing for enterprise sales.

---

## The 7 Required Documents

No SaaS product launches without these. Legal is the gatekeeper.

---

### 1. Terms of Service (ToS)

**Purpose:** Defines the legal relationship between the company and its users. Protects the service and reduces conflict risk.

**Must Include:**
- **Acceptable use policy** — what users can and cannot do
- **Account terms** — registration, responsibilities, suspension/termination conditions
- **Intellectual property** — who owns what (the service, user content, generated outputs)
- **Limitation of liability** — caps on damages, disclaimer of warranties
- **Indemnification** — user agrees to hold company harmless for their misuse
- **Termination** — how either party can end the relationship, data handling post-termination
- **Governing law & jurisdiction** — which law applies, where disputes are resolved
- **Dispute resolution** — arbitration clause, class action waiver (if applicable)
- **Modification clause** — how ToS changes are communicated and when they take effect

**Common Mistakes:**
- Copy-pasting from another company without adapting to your actual service
- Not updating when features change
- Overly broad IP claims that scare away users
- Missing arbitration/dispute clause

---

### 2. Privacy Policy

**Purpose:** Legally required disclosure of data practices. Not optional if you collect any personal data.

**Must Include:**
- **What data is collected** — categories with specifics (name, email, usage data, cookies, device info)
- **How data is collected** — directly from user, automatically, from third parties
- **Purpose of collection** — why each category is collected
- **Legal basis** — consent, contract, legitimate interest (required by GDPR)
- **Data sharing** — which third parties receive data and why
- **Data retention** — how long each category is kept
- **User rights** — access, deletion, correction, portability, objection (per applicable law)
- **Cookie policy** — what cookies/trackers are used, opt-out mechanism
- **Children's privacy** — COPPA compliance if applicable (under-13 users)
- **International transfers** — if data crosses borders, what safeguards are in place
- **Contact information** — how to reach the DPO or privacy team

**The cardinal rule:** The privacy policy must reflect **actual** data practices. Not aspirational. Not boilerplate. What you actually do.

**Update triggers:** New feature collecting data, new third-party integration, new target market/jurisdiction, change in data retention, change in data processor.

---

### 3. Data Processing Addendum (DPA)

**Purpose:** Defines how personal data is handled when processing it on behalf of customers. Required by GDPR Article 28.

**Must Include:**
- **Roles** — who is controller, who is processor
- **Processing scope** — what data, what operations, what purposes
- **Sub-processors** — list of sub-processors, notification/approval process for changes
- **Data location** — where data is stored and processed
- **Security measures** — technical and organizational measures in place
- **Audit rights** — customer's right to audit or inspect compliance
- **Data return/deletion** — what happens to data when the relationship ends
- **Breach notification** — processor's obligations to notify controller
- **International transfers** — SCCs or other transfer mechanisms if applicable

**When it matters:** Enterprise clients will not sign without a DPA. B2B SaaS handling customer data always needs one. If you process EU personal data for someone else, it is legally required.

---

### 4. Service Level Agreement (SLA)

**Purpose:** Sets measurable performance standards and defines remedies when they are not met.

**Must Include:**
- **Uptime guarantee** — typically 99.9% (8.76 hours downtime/year) or 99.95%
- **How uptime is measured** — monitoring methodology, exclusions (scheduled maintenance, force majeure)
- **Scheduled maintenance windows** — when and how users are notified
- **Support response times** — by severity level (critical, high, medium, low)
- **Remedies** — service credits, refunds, or termination rights for SLA breaches
- **Reporting** — how uptime/performance is reported to customers
- **Exclusions** — what does NOT count as downtime (customer-caused, third-party, force majeure)

**Enterprise expectation:** Enterprise buyers compare SLAs. Weak SLAs lose deals. Credits are standard remedy (5-30% of monthly fee per breach).

---

### 5. Master Service Agreement (MSA)

**Purpose:** Umbrella contract governing the overall business relationship. Individual orders/SOWs operate under it.

**Must Include:**
- **Service scope** — what is being provided at a high level
- **Payment terms** — pricing, invoicing, payment schedule, late payment
- **Intellectual property** — ownership of pre-existing IP, developed IP, customer data
- **Confidentiality** — mutual NDA provisions
- **Representations and warranties** — what each party guarantees
- **Indemnification** — who covers whom for what types of claims
- **Limitation of liability** — aggregate caps, exclusions of consequential damages
- **Term and renewal** — auto-renew, notice periods, pricing changes
- **Termination** — for cause, for convenience, notice requirements
- **Governing law** — jurisdiction and dispute resolution

**Why it matters:** Avoids renegotiating basic terms for every new order. The MSA stays constant; SOWs/Order Forms define specific engagements.

---

### 6. Third-Party Integration Contracts

**Purpose:** Governs relationships with external tools, APIs, and vendors integrated into the service.

**Must Address:**
- **Data flows** — what data goes to the third party, in what format, how often
- **Data storage** — where the third party stores data, retention policies
- **Rights allocation** — who owns data, who can use it, for what purposes
- **Security requirements** — minimum security standards the vendor must meet
- **Liability for breaches** — who is responsible if the vendor is breached
- **Termination/migration** — what happens to data if the integration ends
- **Sub-processing** — whether the vendor uses its own sub-processors

**The supply chain problem:** Your users don't care that a breach happened at your vendor. You are responsible to them. Contracts must allocate liability and require notification.

---

### 7. Security & Compliance Disclosures

**Purpose:** Builds trust by transparently communicating your security posture.

**Must Include:**
- **Security practices** — encryption, access controls, monitoring, incident response
- **Certifications** — SOC 2, ISO 27001, or progress toward them
- **Penetration testing** — frequency and methodology (without revealing vulnerabilities)
- **Data handling** — encryption at rest/in transit, backup procedures
- **Incident response** — how breaches are handled and communicated
- **Employee security** — background checks, security training, access provisioning

**"Simple and honest"** — don't overclaim. State what you actually do. If you don't have SOC 2 yet, say you're working toward it. Honesty builds more trust than exaggeration.

---

## Document Lifecycle

**The golden rule:** "Legal documents must grow with your product."

| Trigger | Action |
|---------|--------|
| New feature collecting data | Update Privacy Policy, possibly DPA |
| New third-party integration | Update Privacy Policy, create vendor contract |
| New target market/region | Review all 7 documents for jurisdiction compliance |
| Pricing change | Update MSA/ToS payment terms |
| Security incident | Review and update Security Disclosures |
| New certification (SOC 2) | Update Security Disclosures, marketing materials |
| Regulatory change | Review all affected documents |

---

## Pre-Launch Legal Checklist

- [ ] Terms of Service — drafted, reviewed, published
- [ ] Privacy Policy — reflects actual data practices, covers applicable jurisdictions
- [ ] DPA — ready for enterprise customers requesting one
- [ ] SLA — uptime targets defined, remedies specified
- [ ] MSA template — ready for enterprise negotiations
- [ ] Third-party contracts — all vendor relationships documented
- [ ] Security disclosures — honest, current, published
- [ ] Cookie consent mechanism — functional, compliant with ePrivacy/GDPR
- [ ] DSAR process — can fulfill data access/deletion requests within 30 days
- [ ] Breach response plan — documented, team trained, notification templates ready

---

## Enterprise Readiness Signals

| Signal | Why It Matters |
|--------|---------------|
| **SOC 2 Type II** | De facto requirement for enterprise SaaS sales in the US |
| **ISO 27001** | International information security certification — expected in EU/global markets |
| **DPA available** | Enterprise buyers ask for this early in the sales process |
| **SLA with credits** | Enterprise buyers compare SLAs across vendors |
| **Security page** | Public trust page with certifications, practices, contact for security inquiries |

---

*Source: Fetcher research — saas_legal_checklist.md (TOSLawyer). Updated 2026-03-23.*
