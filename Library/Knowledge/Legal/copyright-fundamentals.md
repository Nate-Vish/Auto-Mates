# Copyright Fundamentals

**Domain:** General copyright law for software — registration, ownership, fair use, DMCA safe harbor, international protection (Berne Convention), infringement remedies, content licensing. Complements `ai-copyright-ip.md` which covers AI-specific copyright.

**Last Updated:** 2026-03-24

---

## 1. What Copyright Protects in Software

### Protected

- Source code and object code (classified as literary works since 1980)
- User interfaces (original visual layouts, icons — but not functional elements)
- Documentation, API docs, inline comments
- Database structures (original selection/arrangement, not the data)
- Website content, audio/visual elements

### NOT Protected (Idea-Expression Dichotomy)

- Ideas, concepts, principles
- Methods, processes, systems, algorithms (may be patentable)
- Facts and data
- Names, titles, slogans (may be trademarkable)
- Functional elements dictated by efficiency/hardware (merger doctrine)
- Standard programming techniques, common UI patterns (scenes a faire)

### Copyright vs Patent vs Trade Secret

| Protection | Covers | Duration | Registration |
|-----------|--------|----------|-------------|
| **Copyright** | Creative expression in code | Life + 70 yrs (95 yrs for work-for-hire) | Automatic; registration recommended |
| **Patent** | Novel inventions (algorithms, methods) | 20 years | Required |
| **Trade Secret** | Confidential business info | Indefinite (while secret) | None |

---

## 2. Registration

Copyright attaches **automatically** on creation. But registration provides critical advantages:

1. **Prerequisite for lawsuit** — US authors must register before suing
2. **Statutory damages** — only if registered before infringement (or within 3 months of publication)
3. **Attorney's fees** — recoverable only with timely registration
4. **Prima facie evidence** — registration within 5 years = presumption of validity
5. **Customs protection** — block infringing imports

### Fees (2025-2026)

| Type | Fee |
|------|-----|
| Single work, single author (online) | $45 |
| Standard (multiple authors, work-for-hire) | $65 |
| Group of unpublished works (up to 10) | $85 |
| Expedited (Special Handling) | +$800 (5 business days) |

### Timeline

Online: 3-8 months. Paper: 10-15 months. Expedited: 5 business days.

### What to Register (Priority Order)

1. Core product source code
2. Major version releases
3. Documentation and user manuals
4. Original graphic assets and UI designs
5. Marketing materials and website content

**Critical:** The 3-month grace period for statutory damages starts from first publication. Miss it and you lose your most powerful remedies.

---

## 3. Ownership

### Default Rule

The **author** is the initial copyright owner.

### Work-for-Hire

**Employees:** Works created within scope of employment = automatically owned by employer.

**Contractors:** Work-for-hire applies ONLY if: (1) specially commissioned, (2) written agreement, (3) falls into one of 9 statutory categories. **Software is NOT in the 9 categories.** Always use IP assignment as fallback.

### Joint Authorship

Two+ authors intending contributions merge into inseparable work = co-owners of the entire work. Each can independently grant non-exclusive licenses (must account for profits). ALL must consent to exclusive license/assignment.

**Risk:** A contractor without proper agreements could claim joint authorship and license your software to competitors.

### Transfer Requirements

- Ownership transfers MUST be in writing and signed
- Non-exclusive licenses can be oral/implied
- Authors have **termination right** after 35 years (does NOT apply to work-for-hire)

---

## 4. Fair Use (17 U.S.C. 107)

Fair use is a **defense**, not a right. Four factors:

1. **Purpose and character** — Transformative? Commercial (weighs against)? Educational/commentary (favors)?
2. **Nature of the work** — Factual/functional (more fair use) vs creative (less)?
3. **Amount used** — Less favors fair use. But using the "heart" weighs against even if small portion.
4. **Market effect** — Does it substitute for the original? Different market favors fair use.

### Key Software Cases

**Google v. Oracle (2021):** Landmark. Google copied 11,500 lines of Java API declarations (0.4%) for Android. Supreme Court 6-2: **fair use.** Functional code, needed for programmers' existing skills, different market (mobile vs desktop), transformative reimplementation.

**Sega v. Accolade (1992):** Reverse engineering for interoperability = fair use.

**Sony v. Connectix (2000):** Reverse engineering console BIOS for emulation = fair use.

### Practical Guidelines

**Likely fair use:** Reverse engineering for interoperability, reimplementing APIs for new platform, compatibility testing, small snippets for education, clean room implementation.

**Likely NOT fair use:** Copying substantial competitor code, reusing proprietary UI wholesale, distributing copyrighted software, using copyrighted assets without license.

---

## 5. DMCA Safe Harbor

### Requirements for Platforms Hosting User Content (Section 512(c))

1. **Designate a DMCA agent** — register with Copyright Office ($6 fee)
2. **Adopt repeat infringer policy** — written, inform users, enforce (terminate repeat infringers)
3. **No actual knowledge** of infringement — or remove expeditiously upon learning
4. **No financial benefit** directly from infringement where you have control
5. **Respond expeditiously** to proper takedown notices

### Takedown Process

1. Copyright owner sends notice (identify work, infringing material, location, good faith statement, perjury statement, signature)
2. Service provider removes/disables; notifies user
3. User may send counter-notice (claiming non-infringement)
4. Restore in 10-14 business days unless copyright owner files suit

### Anti-Circumvention (Section 1201)

Prohibits circumventing DRM/access controls and distributing circumvention tools. Your protection mechanisms are protected by law.

---

## 6. International Protection

### Berne Convention (181 Member Countries)

1. **National treatment** — foreign works get same protection as domestic
2. **Automatic protection** — no registration required (copyright on creation)
3. **Minimum standards** — life + 50 years (US/EU provide life + 70)
4. **Independence** — protection in each country is independent

### TRIPS Agreement (1994)

Incorporated Berne into WTO obligations. Explicitly covers computer programs as literary works. Required criminal penalties for commercial-scale piracy.

### WIPO Copyright Treaty (1996)

Updated Berne for digital age. Covers computer programs/databases explicitly, DRM protection, right of making available (on-demand distribution).

### Practical Implications

- Your software is **automatically protected in 181 countries** — no foreign registration needed
- But enforcement is territorial — must enforce under local law in each country
- Moral rights vary widely: strong in France/Germany, minimal in US
- Moral rights cannot be waived in some jurisdictions regardless of contract

---

## 7. Infringement & Remedies

### Types

- **Direct:** Unauthorized reproduction, distribution, display, derivative works, public performance. Intent not required.
- **Contributory:** Knowingly inducing or materially contributing to another's infringement.
- **Vicarious:** Right/ability to control + direct financial benefit. Knowledge NOT required.

### Remedies

| Remedy | Details |
|--------|---------|
| **Injunctions** | TRO, preliminary, permanent — stop ongoing infringement |
| **Actual damages** | Losses + infringer's profits |
| **Statutory damages** | $750-$30,000/work (standard); up to $150,000 (willful); as low as $200 (innocent) |
| **Attorney's fees** | Discretionary, only for timely-registered works |
| **Criminal** | Willful + commercial: fines + up to 5 years (10 for repeat) |

**Statutory damages are per work infringed**, not per copy. Available ONLY if registered before infringement or within 3 months of publication.

---

## 8. Content Licensing

### Creative Commons

| License | Commercial | Derivatives | Share-Alike |
|---------|-----------|-------------|-------------|
| CC BY | Yes | Yes | No |
| CC BY-SA | Yes | Yes | Yes (copyleft) |
| CC BY-ND | Yes | No | N/A |
| CC BY-NC | No | Yes | No |
| CC BY-NC-SA | No | Yes | Yes |
| CC BY-NC-ND | No | No | N/A |
| CC0 | Yes (public domain) | Yes | No |

**CC licenses are NOT for software** — use OSI-approved licenses.

### Stock Assets

- **Royalty-free:** One-time fee, multiple uses, some restrictions
- **Rights-managed:** Specific use, duration, geography; more exclusive
- **Editorial only:** Cannot use for commercial/advertising
- Watch: scope, exclusivity, model/property releases, sublicensing, AI training restrictions

### User-Generated Content (UGC)

ToS should address: license grant (worldwide, non-exclusive, royalty-free, sublicensable), duration (perpetual or until deleted), ownership (users retain copyright, you get license), right to remove, indemnification (users warrant they have rights), DMCA process.

---

## 9. How Copyright Enables Open Source

Open source licenses **rely on copyright** to function:

1. Author holds copyright
2. Author grants license with permissions and conditions
3. Violation terminates the license
4. Without license, any use = copyright infringement
5. Copyright provides enforcement teeth

**Copyleft mechanism:** GPL requires derivative works to be GPL. Distribute under proprietary license = violate GPL = no license = copyright infringement.

---

## Action Items

### Must-Do

- [ ] Register core software with US Copyright Office (preserve statutory damages)
- [ ] Work-for-hire + IP assignment in ALL employment and contractor agreements
- [ ] Fallback assignment in contractor agreements (work-for-hire fails for software)
- [ ] DMCA agent + takedown process if hosting user content
- [ ] Repeat infringer policy adopted and enforced
- [ ] Track open source dependencies and licenses
- [ ] Copyright notices in source code and published works

### Should-Do

- [ ] Register major releases within 3 months of publication
- [ ] Audit contractor/employee agreements for IP gaps
- [ ] Open source license compliance workflows
- [ ] Document fair use analyses before relying on them
- [ ] Train teams on what they can and cannot copy

---

*Distilled from Fetcher research (2026-03-23). Sources: US Copyright Office, Title 17, BitLaw, Google v. Oracle (Supreme Court), DMCA Section 512, WIPO, Berne Convention, Copyright Alliance, EFF.*
