# Software Contracts & Agreements

**Deep-dive reference.** Pull this file when drafting or reviewing contracts, engaging contractors, negotiating IP terms, or evaluating indemnification clauses.

---

## Contract Types

### Master Service Agreement (MSA)

**What:** Umbrella contract governing an ongoing business relationship. Specific engagements are defined in Statements of Work (SOWs) or Order Forms that reference the MSA.

**Key Clauses:**
- **Service scope** — high-level description of what is provided
- **Payment terms** — pricing model, invoicing, net terms (net 30/60), late fees
- **IP ownership** — pre-existing IP stays with its owner; newly developed IP ownership must be explicitly defined
- **Confidentiality** — mutual obligations, definition of confidential information, exclusions, duration
- **Indemnification** — mutual or one-way, scope of covered claims, caps
- **Limitation of liability** — aggregate cap (typically 12 months of fees), exclusion of consequential damages
- **Term and renewal** — initial term, auto-renewal, notice periods for non-renewal
- **Termination** — for cause (material breach + cure period), for convenience (with notice)
- **Governing law** — jurisdiction for dispute resolution

**Best Practice:** MSA handles the "always true" terms. SOWs handle the "this project" terms (deliverables, timeline, project-specific pricing). Never renegotiate the MSA for each new engagement.

---

### Software License Agreement

**What:** Grants rights to use software without transferring ownership. The licensor retains IP.

**Key Terms:**

| Term | Options | Notes |
|------|---------|-------|
| **Grant type** | Exclusive / Non-exclusive | Exclusive = only the licensee can use it |
| **Scope** | Internal use / Redistribution / SaaS | Define exactly what the licensee can do |
| **Territory** | Global / Regional | Where the license applies |
| **Duration** | Perpetual / Term / Subscription | How long rights last |
| **Sublicensing** | Allowed / Prohibited | Can the licensee grant rights to others? |
| **Modification** | Allowed / Prohibited | Can the licensee modify the software? |
| **Source code** | Provided / Withheld / Escrow | Source code escrow protects licensee if licensor fails |

**Revenue Models:**
- Perpetual license + maintenance fee
- Annual subscription
- Per-seat / per-user
- Usage-based
- Freemium with premium tiers

---

### IP Assignment Agreement

**What:** Transfers ownership of intellectual property from one party to another. Unlike a license, the original creator gives up all rights.

**Critical Use Case:** Contractor and employee work product.

**Must Include:**
- **Scope of assignment** — all IP created during engagement, or specific deliverables only
- **Work-for-hire declaration** — if applicable (US: work made for hire under copyright law)
- **Moral rights waiver** — where applicable (some jurisdictions recognize non-transferable moral rights)
- **Representations** — assignor represents they are the rightful owner, no encumbrances
- **Consideration** — something of value (payment, employment) in exchange for the assignment
- **Future cooperation** — assignor agrees to sign additional documents if needed to perfect the assignment

### The IP Assignment Trap

**In most jurisdictions, independent contractors retain IP rights by default.** Without an explicit assignment clause:
- The contractor owns the code they wrote
- You have an implied license to use it for the purpose it was commissioned, but the contractor can use it elsewhere
- This is the single most common legal mistake in software development

**Fix:** Every contractor agreement must contain an explicit IP assignment or work-for-hire clause. Review by Legal before engagement begins.

---

### Contractor / Freelancer Agreement

**What:** Governs the relationship with an independent contractor for software development.

**Must Include:**
- **IP assignment** — explicit clause transferring all work product IP to the company
- **Work-for-hire** — where applicable under local law
- **Confidentiality / NDA** — protecting company information the contractor accesses
- **Deliverables** — specific, measurable, with acceptance criteria
- **Payment terms** — milestones, hourly, fixed-price, payment schedule
- **Non-compete** — where enforceable (increasingly restricted in many jurisdictions)
- **Non-solicitation** — preventing contractor from poaching employees/clients
- **Termination** — notice period, payment for work completed, IP assignment survives termination
- **Representations** — contractor represents work is original, not infringing
- **Insurance** — professional liability/errors & omissions if applicable

**Key Risk:** Misclassification. If a contractor is treated as an employee (set hours, company equipment, exclusivity), they may be legally reclassified — triggering tax, benefits, and labor law obligations.

---

### Non-Disclosure Agreement (NDA)

**What:** Legally binding agreement to keep shared information confidential.

**Types:**
- **Mutual** — both parties share and protect confidential information (standard for partnerships, vendor evaluations)
- **One-way** — one party shares, the other protects (standard for employee/contractor onboarding)

**Key Clauses:**
- **Definition of confidential information** — be specific enough to be enforceable, broad enough to be useful
- **Exclusions** — publicly known, independently developed, legally obtained from third parties, required by law
- **Duration** — typically 2-5 years; trade secrets may be indefinite
- **Permitted disclosures** — employees/agents with need to know, legal requirements
- **Remedies** — injunctive relief (courts can order the breach to stop), damages
- **Return/destruction** — obligation to return or destroy confidential materials after the agreement ends

---

## Key Contract Concepts

### Indemnification

**What:** One party agrees to compensate the other for losses arising from specified events.

| Type | Meaning |
|------|---------|
| **Mutual** | Both parties indemnify each other for their own breaches/negligence |
| **One-way** | Only one party indemnifies (e.g., vendor indemnifies customer for IP infringement) |
| **Capped** | Indemnification limited to a dollar amount (e.g., total fees paid) |
| **Uncapped** | No limit — dangerous; avoid unless absolutely necessary |

**Standard approach:** Mutual indemnification for breaches of representations and warranties. Vendor indemnifies for IP infringement claims. Customer indemnifies for misuse. Both capped at 12 months of fees paid (with carve-outs for willful misconduct, confidentiality breach, IP infringement).

### Limitation of Liability

**Standard structure:**
- **Aggregate cap** — total liability limited to fees paid in prior 12 months
- **Consequential damages exclusion** — neither party liable for lost profits, lost data, indirect damages
- **Carve-outs** — certain obligations excluded from the cap (confidentiality breach, IP infringement, willful misconduct, indemnification obligations)

**Red flag:** Uncapped liability or no limitation clause at all. Always negotiate a cap.

### Representations and Warranties

**Common representations:**
- Authority to enter into the agreement
- Software does not infringe third-party IP
- Services will be performed in a professional manner
- Compliance with applicable laws
- No known defects that would prevent performance

**Warranty disclaimers:** "AS IS" disclaimers waive implied warranties (merchantability, fitness for purpose). Standard in software licenses. Cannot disclaim fraud or willful misconduct.

### Governing Law and Dispute Resolution

**Governing law** — which jurisdiction's laws interpret the contract. Choose a jurisdiction favorable to your position and consistent with your operations.

**Dispute resolution options:**
- **Litigation** — public courts. Slower, more expensive, but creates precedent.
- **Arbitration** — private, faster, binding. Preferred for commercial disputes. Specify rules (AAA, JAMS, ICC).
- **Mediation** — non-binding facilitated negotiation. Often required as first step before arbitration.

---

## Contract Review Checklist

When Legal reviews any software contract:

- [ ] **IP ownership** — clearly defined, assignment clauses present for work product
- [ ] **Confidentiality** — NDA provisions adequate, duration appropriate
- [ ] **Indemnification** — mutual, capped, carve-outs reasonable
- [ ] **Liability cap** — present, at an acceptable level
- [ ] **Termination** — clear trigger events, cure periods, post-termination obligations
- [ ] **Data handling** — DPA if personal data involved, data return/deletion on termination
- [ ] **Governing law** — acceptable jurisdiction
- [ ] **Dispute resolution** — arbitration clause if preferred
- [ ] **Non-compete** — enforceable in the relevant jurisdiction?
- [ ] **Auto-renewal** — notice period for non-renewal clearly stated
- [ ] **Force majeure** — appropriate scope (not too broad, not too narrow)
- [ ] **Assignment** — can rights/obligations be transferred? To whom?

---

*Knowledge distilled from professional legal counsel expertise and SaaS industry standards. Updated 2026-03-23.*
