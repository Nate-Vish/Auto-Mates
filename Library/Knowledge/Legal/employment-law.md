# Employment Law

**Domain:** Employee vs contractor classification, IP ownership via employment, non-compete agreements, remote/international hiring, EOR services, required employment documents.

**Last Updated:** 2026-03-24

---

## 1. Employee vs Independent Contractor Classification

Misclassification is the single most common employment law violation for tech startups.

### Three Tests

**IRS Common Law Test (Three-Factor):**
1. **Behavioral Control** — do you direct how, when, where work is done?
2. **Financial Control** — does worker have unreimbursed expenses, profit/loss opportunity, own equipment?
3. **Type of Relationship** — contracts, benefits, permanency, whether work is key aspect of business

No single factor decisive; IRS weighs totality.

**ABC Test (Stricter — 33 States including CA, MA, NJ):**
Worker is presumed employee unless ALL three prongs met:
- **A — Autonomy:** Free from control and direction
- **B — Business:** Work is outside the hiring entity's usual business
- **C — Custom:** Worker is customarily in an independently established trade

Failure on ANY prong = employee. Significantly stricter than IRS test.

**DOL Economic Reality Test (FLSA):** Six factors — profit/loss opportunity, investments, permanence, control, integral to business, skill/initiative.

### Red Flags for Tech Companies

**Likely employee:** Works 40+ hours exclusively for you, works on your core product, receives daily task direction, uses company equipment, has no other clients.

**Likely contractor:** Defined projects with deliverables, sets own schedule/methods, uses own equipment, serves multiple clients, invoices per-project, has own business entity.

### Misclassification Penalties

For a single $100,000 misclassified worker: audit penalties can reach **$205,000+** including back payroll taxes, FICA penalties (1.5% + 40% + 100%), interest, and state penalties.

**IRS VCSP:** Voluntary Classification Settlement Program — pay 10% of prior year's liability and reclassify. Must file before audit begins.

---

## 2. IP Ownership via Employment

### Work-for-Hire (Copyright)

**Employees:** Works created within scope of employment automatically owned by employer. No agreement required (but always get one).

**Contractors:** Work-for-hire applies ONLY if: (1) work falls into one of 9 statutory categories, (2) both parties sign written agreement. **Software does NOT fall into the 9 categories** — work-for-hire alone is insufficient for contractor code. **You MUST use an IP assignment clause.**

### Patent Ownership

The Patent Act has NO work-for-hire doctrine.
- **Employee inventions:** Employer owns if employee was "hired to invent" or written assignment exists. Otherwise employee owns.
- **Shop right:** Without agreement, employer gets non-exclusive, royalty-free license if employee used company resources (but not ownership).
- **Contractor inventions:** Contractor owns unless written assignment exists.

### PIIA (Proprietary Information and Inventions Assignment Agreement)

Every tech company should require. Must cover:
- Assignment of all inventions, works, copyrights, patents, trade secrets
- Disclosure obligations — employee reports inventions promptly
- Cooperation clause — assist with filings
- Prior inventions exclusion — list pre-existing IP employee retains
- DTSA immunity notice — required by Defend Trade Secrets Act (2016)

### State Limits on Assignment

California (Labor Code 2870), Delaware, Illinois, Kansas, Minnesota, North Carolina, Washington: cannot require assignment of inventions developed entirely on employee's own time without company resources, unless related to company business.

### International Variations

| Jurisdiction | Employee IP Default | Contractor IP Default | Notes |
|---|---|---|---|
| **US** | Employer owns copyright; patents need assignment | Contractor owns | Software not in statutory categories |
| **UK** | Employer owns if in course of employment | Contractor owns | Moral rights can be waived |
| **Germany** | Employer claims "service inventions"; extra compensation | Contractor owns | Moral rights inseparable |
| **China** | Employer owns "service inventions"; 1-year post-employment | Contractor owns | Inventor remuneration beyond salary |

---

## 3. Non-Compete Agreements (March 2026)

### FTC Rule is DEAD

The FTC's April 2024 nationwide non-compete ban was blocked (Aug 2024), then formally vacated (Sept 2025). **Not in effect.** Current approach: case-by-case Section 5 enforcement targeting abusive non-competes.

### State Landscape

**Total Bans (6 states):** California, Minnesota, Montana, North Dakota, Oklahoma, Wyoming. California voids them regardless of where/when signed. Hawaii bans for tech employees specifically.

**Wage Threshold States (12+):**
| State | Threshold |
|-------|-----------|
| Oregon | $116,427+ (2025, adjusted annually) |
| Illinois | $75,000 (rising to $90K by 2037) |
| Washington | $116,593+ (2025, adjusted annually) |
| Colorado | Highly compensated only + notice |
| Massachusetts | Garden leave or other consideration required |

**Pro-Employer:** Florida CHOICE Act (July 2025) — permits up to 4-year non-competes for employees earning >2x county average wage.

### Practical Guidance

1. **California startups:** Do NOT use non-competes. Use NDAs + non-solicitation instead.
2. **Multi-state teams:** Review enforceability in each employee's state. Valid in FL may be void for remote worker in CA.
3. **Alternatives:** Non-solicitation (enforceable in most states), NDAs (enforceable everywhere), garden leave clauses, equity vesting schedules.

---

## 4. At-Will Employment

49 states + DC: either party can terminate at any time, for any legal reason. **Montana** is the sole exception (cause required after probationary period).

### Three Exceptions

1. **Public Policy (42+ states):** Cannot fire for filing workers' comp, whistleblowing, refusing illegal acts, exercising legal rights
2. **Implied Contract (41 states):** Verbal promises, handbook language, consistent past practice can defeat at-will
3. **Good Faith (11 states):** Cannot terminate in bad faith (e.g., to avoid paying earned commissions)

### Statutory Protections (Apply Everywhere)

Cannot fire for: race/color/religion/sex/national origin (Title VII), disability (ADA), age 40+ (ADEA), FMLA leave, wage complaints (FLSA), discussing wages/conditions (NLRA).

---

## 5. Remote & Multi-State Compliance

When an employee works from a state, **that state's employment laws govern** regardless of employer location.

Hiring even ONE remote employee in a new state can create:
- **Tax nexus** (corporate income, sales tax)
- State registration requirements
- New employment law obligations
- Unemployment insurance registration

### Key Obligations Per State

- Wage & hour (minimum wage $7.25 federal to $16+ in CA/WA; overtime; meal/rest breaks)
- Paid leave requirements (sick, family, PTO payout)
- Tax withholding (state income, SUI, local/municipal)
- Workers' compensation coverage
- Pay transparency (salary ranges in postings: CO, CA, NY, WA, others)

---

## 6. International Hiring

### Employer of Record (EOR)

An EOR acts as legal employer in a foreign country, handling contracts, payroll, tax, benefits, termination compliance, work permits. You retain day-to-day work management.

| Factor | EOR | Local Entity |
|---|---|---|
| Speed | Days to weeks | 3-12 months |
| Setup cost | Low (monthly per-employee) | $20K-$100K+ |
| Best for | 1-10 employees per country | 10+ employees, long-term |
| IP ownership | Careful contract structuring needed | Direct |

**Leading providers (2026):** Deel (150+ countries, startup-friendly), Remote (80+, owned entities), Oyster (180+), Atlas HXM (160+).

### Key International Issues

- **Termination protections:** Most countries outside US require cause + mandatory severance. Firing in Germany/France/Brazil without process can cost 6-24 months salary.
- **Mandatory benefits:** EU: 20+ days vacation, paid parental leave, social security, sometimes 13th/14th month salary.
- **IP ownership:** Some countries have mandatory inventor compensation or limit IP assignment scope. Use jurisdiction-specific clauses.
- **Permanent establishment risk:** Employees in a country may trigger corporate tax obligations.

### Rule of Thumb

If the person works 30+ hours/week exclusively for you, use an EOR. If defined project with clear deliverables, contractor may work — but get local legal review.

---

## Required Documents

### Employee (US)

| Document | Notes |
|----------|-------|
| Offer Letter | Title, salary, start date, at-will statement |
| PIIA/CIIAA | IP assignment + confidentiality — sign Day 1 |
| NDA | Trade secret protection |
| W-4 | Federal tax withholding (required) |
| I-9 | Employment eligibility (required) |
| State tax forms | Where applicable (required) |
| At-will acknowledgment | Recommended |

### Contractor (US)

| Document | Notes |
|----------|-------|
| Independent Contractor Agreement | IP assignment, scope, payment, autonomy clause |
| W-9 | Collect before first payment |
| 1099-NEC | Issue by Jan 31 if paid $600+ |

**Contractor IP clause must include:** Work-for-hire AND assignment language (work-for-hire alone fails for software), broad work product definition, pre-existing IP carve-out, open source disclosure requirement.

---

*Distilled from Fetcher research (2026-03-23). Sources: IRS, DOL, A&O Shearman, Katz Banks Kumin, Husch Blackwell, Cooley GO, US Chamber, Deel.*
