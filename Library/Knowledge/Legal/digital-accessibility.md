# Digital Accessibility

**Domain:** ADA Title III, WCAG 2.2, EU European Accessibility Act, Section 508, lawsuit trends, VPAT/ACR, compliance checklist.

**Last Updated:** 2026-03-24

---

## 1. ADA Title III (US — Private Businesses)

### Current Status

- **No formal web regulation exists** under Title III. The DOJ has never published a final rule for private business websites.
- Courts routinely apply **WCAG 2.0/2.1 AA as the de facto standard** in lawsuits.
- **Title II rule (April 2024):** State/local government websites must meet WCAG 2.1 AA by April 24, 2026 (50K+ population) or April 24, 2027 (smaller).
- October 2025: DOJ announced it will "re-examine all" ADA regulations — less DOJ-initiated enforcement, but **private lawsuits continue unabated**.

### DOJ Guidance (January 2025)

- Adopt WCAG 2.1 AA as baseline
- Regular audits (manual + automated)
- Accessibility policies + developer training
- Alternative access during remediation
- Document efforts (useful as litigation defense)

---

## 2. WCAG 2.2 (The Standard)

Published October 2023. Now ISO/IEC 40500:2025.

### Four Principles (POUR)

1. **Perceivable** — alt text, captions, contrast, text resize
2. **Operable** — keyboard access, enough time, no seizures, navigable
3. **Understandable** — readable, predictable, input assistance
4. **Robust** — compatible with assistive technologies

### Conformance Levels

| Level | What | Legal Status |
|-------|------|-------------|
| **A** | Minimum — removes worst barriers (~30 criteria) | Necessary but insufficient |
| **AA** | Major barriers for most users (~50 criteria) | **The legal standard worldwide** |
| **AAA** | Enhanced, specialized (~80 criteria) | Aspirational; not required anywhere |

### Key New Criteria in WCAG 2.2

| Criterion | Level | Requirement |
|-----------|-------|------------|
| Focus Not Obscured | AA | Focused element not entirely hidden by sticky headers/modals |
| Dragging Movements | AA | Single-pointer alternative for all drag operations |
| Target Size (Minimum) | AA | Interactive targets at least 24x24 CSS pixels |
| Consistent Help | A | Help in consistent location across pages |
| Redundant Entry | A | Auto-populate previously entered info |
| Accessible Authentication | AA | No cognitive function test; allow paste/assistive tech |

---

## 3. EU European Accessibility Act (EAA)

**Effective June 28, 2025** — now in force.

### Who Must Comply

- **All businesses selling products or services in the EU** regardless of headquarters
- Micro-enterprise exemption: <10 employees AND <EUR 2M turnover (services only)
- **No exemption for non-EU companies** selling into EU market

### Covered Services

E-commerce websites/apps, banking, electronic communications, audiovisual media, e-books, passenger transport booking.

### Technical Standard

**EN 301 549** (incorporates WCAG 2.1 AA for web content + additional requirements for software, hardware, documentation).

### Penalties

Set by each member state — fines up to **EUR 500,000+**, daily penalties, product removal from market.

---

## 4. Section 508 (US Government Sales)

Federal agencies must make ICT accessible. **Extends to government contractors** — any company selling digital products to federal government.

- Current standard: WCAG 2.0 AA (via 2017 Section 508 Refresh)
- **VPAT/ACR effectively mandatory** — agencies may not purchase without one
- GSA (March 2026) recommends procurement as "primary lever" for enforcement
- **FAR 39.2** includes accessibility in procurement requirements

---

## 5. Lawsuit Trends

### Volume

| Year | Total ADA Title III | Web-Specific |
|------|---------------------|-------------|
| 2024 | ~8,800 | ~4,500 |
| 2025 | **8,667** | **5,000+** |

Pro se filings up 40% in 2025.

### Geographic Hotspots

California (3,252), Florida (1,823), New York (1,471), Illinois (fastest growing). Four states = 74%+ of all ADA web lawsuits.

### Most Targeted: E-commerce (~70% of lawsuits)

### Most Common Violations

| Violation | % of Homepages |
|-----------|---------------|
| Low contrast text | 79.1% |
| Missing alt text | 55.5% |
| Missing form labels | 48.2% |
| Empty links | 45.7% |
| Missing document language | 26.9% |
| Empty buttons | 23.5% |

### Overlays Do NOT Protect You

**22.6% of lawsuits (456 cases)** targeted sites with accessibility widgets installed. Courts reject overlays as a defense. **Do not rely on overlays — implement native accessibility.**

---

## 6. VPAT/ACR

### When You Need One

- Selling to US federal government (effectively mandatory)
- Selling to state/local government (increasingly required)
- Enterprise B2B sales (many large orgs require)
- Higher education procurement

### Editions

| Edition | Use When |
|---------|----------|
| **INT (International)** | **Recommended — covers all markets** |
| Revised Section 508 | US federal government only |
| EN 301 549 | EU/UK markets only |
| WCAG | International, web content only |

### Conformance Terms

- **Supports** — meets criterion without known defects
- **Partially Supports** — some functionality doesn't meet
- **Does Not Support** — majority doesn't meet
- **Not Applicable** — irrelevant to product

Update with every major release. Be honest — "Partially Supports" with explanations is better than false "Supports."

---

## 7. Jurisdiction Comparison

| Jurisdiction | Law | Standard | Enforcement |
|-------------|-----|----------|-------------|
| **US (Private)** | ADA Title III | WCAG 2.1 AA (de facto) | Private lawsuits |
| **US (Federal)** | Section 508 | WCAG 2.0 AA | Procurement denial |
| **EU** | EAA | EN 301 549 / WCAG 2.1 AA | Market surveillance, fines |
| **UK** | Equality Act 2010 | WCAG 2.1 AA | EHRC, lawsuits |
| **Canada** | ACA + AODA | WCAG 2.0-2.1 AA | Fines up to CAD 250K/day |
| **Australia** | DDA 1992 | WCAG 2.0 AA | Complaints, compensation |
| **Israel** | IS 5568 | WCAG 2.0 AA | Government enforcement |

**WCAG 2.1 Level AA is the global baseline.** Building to WCAG 2.2 AA future-proofs your product.

---

## 8. Developer Compliance Checklist

### Core Requirements (WCAG 2.1/2.2 AA)

**Perceivable:**
- [ ] Alt text on all meaningful images
- [ ] Video captions + audio descriptions
- [ ] Color contrast: 4.5:1 normal text, 3:1 large text, 3:1 UI components
- [ ] Content works at 200% zoom and 320px width (reflow)

**Operable:**
- [ ] Full keyboard access, no traps
- [ ] Visible focus indicators, not obscured by sticky elements
- [ ] Skip navigation links
- [ ] Target size minimum 24x24 CSS pixels (WCAG 2.2)
- [ ] Dragging alternatives (WCAG 2.2)

**Understandable:**
- [ ] `lang` attribute on `<html>`
- [ ] Consistent navigation and help placement
- [ ] Form error identification + labels
- [ ] Accessible authentication — no cognitive tests, allow paste

**Robust:**
- [ ] Semantic HTML, proper ARIA
- [ ] Status messages via ARIA live regions

### Testing Cadence

| When | What |
|------|------|
| Every commit | Automated axe-core in CI/CD |
| Every sprint | Manual keyboard + screen reader of changed features |
| Quarterly | Full WCAG audit (automated + manual) |
| Annually | Third-party audit with disabled user testing |
| Before launch | Complete WCAG 2.2 AA conformance review |

### What Legal Must Verify

1. Accessibility statement published
2. VPAT/ACR current and accurate
3. Conformance target documented (WCAG 2.1 AA minimum)
4. Testing evidence maintained
5. Remediation roadmap for known issues
6. Third-party components assessed
7. Complaint/feedback mechanism exists

---

*Distilled from Fetcher research (2026-03-23). Sources: W3C, DOJ, European Commission, Section508.gov, ADA Title III Blog, UsableNet, Level Access.*
