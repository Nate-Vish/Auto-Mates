# Patent Strategy

**Domain:** Software patents, international filing (PCT), patent vs trade secret decisions, AI patents, defensive strategies against patent trolls.

**Last Updated:** 2026-03-24

---

## 1. Software Patentability (Post-Alice)

### The Alice/Mayo Two-Step Test

The Supreme Court's **Alice Corp. v. CLS Bank (2014)** controls software patent eligibility under 35 U.S.C. Section 101:

**Step 1:** Does the claim fall within a statutory category (process, machine, manufacture, composition)?

**Step 2:** Does the claim recite an abstract idea? If yes, does it integrate into a **practical application** or add **"significantly more"** (an inventive concept)?

### Three Categories of Abstract Ideas

1. **Mathematical concepts** — formulas, equations, calculations
2. **Methods of organizing human activity** — economics, contracts, marketing, managing behavior
3. **Mental processes** — concepts performable in the human mind or with pen and paper

### What IS Patentable

Software claims survive Alice when they demonstrate a **specific technical improvement**:

- Novel data structures solving technical problems unconventionally
- Specific improvements to computer functionality (faster processing, reduced memory, improved network efficiency)
- Novel neural network training methods with particular transformations
- Hardware-software co-optimization for AI inference
- Novel loss functions or optimization algorithms with demonstrated technical advantages

**Key principle:** The claim must improve how the computer works, not merely use a computer to implement an abstract idea.

### What is NOT Patentable

- Generic business methods on a computer
- "Apply it on a computer" claims
- "Use ML model to predict [outcome]" — too abstract
- Generic application of known ML to new data domains
- "Use AI to optimize [business process]" — per **Recentive Analytics v. Fox Corp. (2025)**

### Recentive Analytics v. Fox Corp. (Fed. Cir. 2025)

First major AI/ML ruling in Alice context. All four patents on ML-optimized TV scheduling held patent-ineligible. **AI algorithms receive no special treatment under Section 101.** Claims must demonstrate specific technological improvement to the AI system itself.

---

## 2. Filing Process

### Provisional vs Non-Provisional

| Feature | Provisional | Non-Provisional |
|---------|------------|-----------------|
| **Purpose** | Establish priority date; buy time | Seek enforceable rights |
| **Examined?** | No | Yes |
| **Duration** | 12 months (auto-abandoned) | Up to 20 years |
| **Fee (micro-entity)** | ~$65 | ~$1,090+ |
| **Attorney cost** | $4,000-$10,000 | $8,000-$15,000+ |

### Timeline

```
Month 0:   File provisional → priority date + "Patent Pending"
Month 12:  HARD DEADLINE — file non-provisional or PCT (or lose priority)
Month 12-36: USPTO examination (~24 months average)
Month 36+:  Patent granted (or final rejection)
            Maintenance fees at 3.5, 7.5, 11.5 years
```

### Total Cost Through Grant

| Entity Size | Total |
|-------------|-------|
| Micro-entity | $13,000-$30,000 |
| Small entity | $18,000-$36,000 |
| Large entity | $22,000-$43,000 |

### Entity Definitions

- **Micro-entity:** <4 prior US applications; income <~$225,000; no obligation to assign to entity exceeding threshold
- **Small entity:** <500 employees
- **Large entity:** Everyone else

---

## 3. International Protection (PCT)

The Patent Cooperation Treaty provides unified filing in **158 member states**.

### PCT Timeline

```
Month 0:   File national/provisional
Month 12:  File PCT (single application = effect in all 158 states)
Month 16:  International Search Report + Written Opinion
Month 22:  Optional: International Preliminary Examination
Month 30:  NATIONAL PHASE ENTRY DEADLINE — choose countries, file translations, pay fees
```

### Key Jurisdictions for Software

| Office | Patentability | Timeline | Cost Through Grant |
|--------|--------------|----------|-------------------|
| **USPTO** | Post-Alice; specific technical improvement required | ~24 months | $15K-$30K |
| **EPO** | Software "as such" not patentable; "technical effect" required | 3-5 years | EUR 30K-50K+ |
| **China (CNIPA)** | Technical solution to technical problem; 2024 guidelines broadened AI eligibility | 18-24 months | $5K-$12K |
| **Japan (JPO)** | More permissive than EPO; hardware resource use focus | 14-20 months | $8K-$15K |
| **Israel (ILPO)** | Follows EPO approach; strong tech ecosystem | 2-4 years | $8K-$15K |

### Cost-Effective International Strategy

1. **Year 1:** US provisional ($2K-$6K)
2. **Month 12:** PCT application (~$4K-$6K)
3. **Month 18-22:** Receive ISR — assess patentability before spending more
4. **Month 30:** Enter national phase ONLY in commercially important jurisdictions
5. **Budget:** Minimum $50K-$100K for US + 2-3 additional jurisdictions

---

## 4. Patent vs Trade Secret

### Decision Framework

| Factor | Choose Patent | Choose Trade Secret |
|--------|--------------|-------------------|
| **Visibility** | Innovation visible in product (reverse-engineerable) | Hidden (backend, internal processes) |
| **Duration** | 20 years sufficient | Need indefinite protection |
| **Budget** | Can afford $15K-$100K+ | Limited budget |
| **Competition** | Likely independent development | Unlikely independent discovery |
| **Licensing** | Want to license to others | No licensing plans |
| **Turnover** | High (secret likely to leak) | Low, strong NDAs |
| **Investors** | Need tangible IP portfolio for valuation | Internal tech not visible to stakeholders |

### Hybrid Strategy (Recommended)

1. **Patent** user-visible innovations and genuinely novel technical solutions
2. **Trade secret** backend implementations, data pipelines, business logic
3. **Copyright** actual code (automatic)
4. **Trademark** brand and product names

### Trade Secret Legal Framework

- **DTSA (2016):** Federal cause of action for misappropriation
- **UTSA:** Adopted in 48 states
- **Requirements:** Independent economic value from secrecy + reasonable measures to maintain secrecy
- **Risk:** No protection if independently discovered or reverse-engineered

---

## 5. AI Patents

### Can AI Be Listed as Inventor?

**No, in every major jurisdiction (as of March 2026).** The DABUS project tested this worldwide:

| Jurisdiction | Result |
|-------------|--------|
| USPTO | Rejected — inventor must be natural person (Final) |
| EPO | Rejected (Final; divisional appeal Feb 2026) |
| UK Supreme Court | Rejected (Final) |
| Germany | Rejected (Final) |
| Japan | Rejected (Final) |
| Canada | Rejected (under appeal) |
| South Africa | Granted (anomaly — no substantive examination) |

### Practical Guidance

- List the human(s) who directed/oversaw the AI as inventor(s)
- Document human contribution: identified the problem, configured the AI, recognized the output, refined/adapted it
- **USPTO Feb 2024 guidance:** AI-assisted inventions ARE patentable if a natural person made a "significant contribution"
- Purely AI-generated inventions (no human contribution) cannot be patented anywhere

---

## 6. Defensive Strategies

### Patent Troll Landscape (2025-2026)

NPE litigation increased **15-20%** between Q1 and Q2 2025. Contributing factors: PTAB discretionary denials, growing AI patent acquisitions by NPEs, broad software patent claims.

### Defense Toolkit

**Defensive Publications:** Publish innovations to create prior art ($200-$500 vs $15K+ for a patent). Platforms: IP.com, Research Disclosure, arXiv, technical blogs.

**Defensive Alliances:**
- **Unified Patents:** Membership-based; challenges low-quality patents via IPR; launched AI Zone in 2025
- **LOT Network:** Members agree not to assert patents against each other if patents end up in NPE hands
- **Open Invention Network:** Free cross-licensing for Linux ecosystem

**When a Troll Contacts You:**
1. Don't ignore it — but don't panic
2. Analyze the patent — validity, scope, actual infringement
3. Search for invalidating prior art
4. Assess litigation risk — venue, judge, troll's track record
5. Consider early IPR filing ($300K-$500K, but far less than full litigation at $2-5M)
6. File strong non-infringement and Section 101 motions

### Open Source Patent Grants

| License | Express Patent Grant | Retaliation Clause |
|---------|--------------------|--------------------|
| **Apache 2.0** | Yes — royalty-free, irrevocable | Yes — terminates on patent litigation |
| **GPL v3** | Yes (implicit + explicit) | Yes (Section 11) |
| **MIT/BSD** | No | No |
| **MPL 2.0** | Yes | Yes |

**Apache 2.0 retaliation:** If you sue anyone alleging the Apache-licensed software infringes your patents, your patent license for that software **automatically terminates**. Defending yourself does NOT trigger retaliation.

---

## Action Items

### Before You Build
- [ ] Freedom-to-operate (FTO) search — are you infringing existing patents?
- [ ] Check open source license patent grants for all dependencies
- [ ] Establish trade secret protection (NDAs, access controls)

### While You Build
- [ ] Document inventive concepts with dates and inventor contributions
- [ ] File provisionals on key innovations ($2K-$6K each)
- [ ] Defensive publications for non-exclusive innovations
- [ ] Record AI involvement in inventive process

### Ongoing
- [ ] Monitor competitor patent filings
- [ ] Pay maintenance fees (3.5, 7.5, 11.5 years)
- [ ] Update trade secret inventory annually
- [ ] Review portfolio for licensing/cross-licensing
- [ ] Budget $50K-$100K+ annually for patent program (growing company)

---

*Distilled from Fetcher research (2026-03-23). Sources: USPTO MPEP 2106, WIPO PCT, Alice Corp. v. CLS Bank, Recentive Analytics v. Fox Corp., DABUS decisions, Unified Patents, IP.com.*
