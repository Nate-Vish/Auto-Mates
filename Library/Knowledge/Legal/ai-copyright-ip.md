# AI & Copyright / Intellectual Property

**Deep-dive reference.** Pull this file when advising on AI-generated code ownership, copyright registration, infringement risk, or IP protection strategies.

---

## The Human Authorship Requirement

US copyright law requires human authorship for protection. This is settled law as of March 2026.

### Key Rulings

| Case / Event | Date | Outcome |
|--------------|------|---------|
| *Thaler v. Perlmutter* | 2023 | Court: AI cannot be an "author" under copyright law |
| Court of Appeals | 2025 | Affirmed: no copyright for AI-only works |
| Supreme Court declines certiorari | March 2, 2026 | Ruling stands. No further appeal. |
| *Theatre D'opera Spatial* | 2023 | Registration denied for AI-generated image |
| *Zarya of the Dawn* | 2023 | Partial registration: human selection/arrangement protected, AI-generated images not |

### What This Means

- **Purely AI-generated code = uncopyrightable.** Anyone can copy, modify, and distribute it freely. You have zero IP protection.
- **Human + AI collaboration = potentially copyrightable.** The human creative contribution must be "perceptible in the output."
- **Prompts alone are not enough.** Merely instructing an AI (even with detailed prompts) does not establish authorship of the output.

---

## The Copyright Spectrum

| Level of Human Involvement | Copyright Status | Example |
|---------------------------|-----------------|---------|
| **None** — AI generates code autonomously | Uncopyrightable | "Generate a REST API for user management" with no editing |
| **Minimal** — human provides prompts only | Likely uncopyrightable | Detailed prompt engineering but accepting output as-is |
| **Moderate** — human edits and refines | Gray area — case-by-case | Human modifies AI output, adds logic, fixes bugs |
| **Substantial** — human uses AI as a tool | Likely copyrightable | Human architects the design, uses AI for snippets, integrates and transforms |
| **Full** — human writes, AI assists minimally | Copyrightable | Autocomplete, syntax suggestions, code formatting |

---

## US Copyright Office Position

### Registration Requirements
- Works containing AI-generated material **must disclose** AI involvement during registration
- Applicant must identify which elements are AI-generated vs human-authored
- Failure to disclose can invalidate registration
- Policy statement issued March 16, 2023

### Fair Use and Training Data
- "Some uses of copyrighted works for generative AI training will qualify as fair use, and some will not" (Part 3, May 2025)
- No blanket rule — case-by-case analysis
- Factors: purpose of use, nature of copyrighted work, amount used, market effect

### Three-Part Report Series

| Part | Date | Topic |
|------|------|-------|
| Part 1 | July 31, 2024 | Digital replicas — recommends Federal Digital Replica Law |
| Part 2 | January 29, 2025 | Copyrightability of generative AI outputs |
| Part 3 | May 9, 2025 | Generative AI training and copyright |

---

## Liability Risks

### 1. Copyright Infringement
AI tools trained on copyrighted code may reproduce it in their output.

- *Doe v. GitHub* — class action alleging Copilot reproduces licensed code without attribution (ongoing)
- **Anthropic settlement (2026): $1.5 billion** — largest US copyright payout in history
- Risk: using AI-generated code that turns out to be a near-copy of copyrighted work
- **You are liable** even if you didn't know the AI copied something

### 2. Product Defects
- AI vendors universally disclaim liability ("AI can make mistakes")
- Due diligence obligation shifts entirely to the user
- If AI-generated code causes harm, the deploying organization bears responsibility
- No established case law yet on AI-code-specific product liability

### 3. Security Vulnerabilities
- AI can generate code with exploitable weaknesses
- No clear legal framework for liability when AI introduces security flaws
- Standard negligence principles likely apply — did you exercise reasonable care?

---

## Risk Mitigation Strategies

### Documentation (Critical)
1. **Maintain prompt logs** — record what you asked the AI and what it produced
2. **Track editing history** — document every human modification to AI output
3. **Record design decisions** — the architecture, algorithm choices, and creative decisions made by humans
4. **Version control** — git history showing human iterative development
5. **Meeting notes / design docs** — evidence of human creative planning

### Organizational Policies
1. **AI usage policy** — define when and how AI tools can be used for code generation
2. **Code review requirement** — all AI-generated code must pass human review before deployment
3. **License scanning** — run AI output through license/plagiarism scanners
4. **Security review** — security audit AI-generated code before production

### Alternative IP Protection
If copyright is weak or unavailable for AI-assisted code:
- **Trade secret** — keep source code confidential, enforce through NDAs and access controls
- **Patent** — if the invention (not just the code) is novel and non-obvious
- **Contractual protection** — licensing terms that restrict use regardless of copyright status

---

## Practical Guidance for the Team

**When Builder uses AI to generate code:**
1. Builder documents the human creative contribution (architecture decisions, algorithm design, integration logic)
2. Legal assesses whether the human contribution is sufficient for copyright
3. If not copyrightable: consider trade secret protection and contractual restrictions
4. If copyrightable: ensure registration discloses AI elements

**When publishing AI-assisted work:**
1. Disclose AI involvement (required for copyright registration, increasingly expected publicly)
2. Verify output against known codebases for similarity
3. Include appropriate licensing terms that account for mixed authorship

**When evaluating third-party AI-generated content:**
1. Assume it may be uncopyrightable — you may not be able to enforce exclusivity
2. Check if it contains elements copied from copyrighted sources
3. Use it as input/reference, not as protectable IP

---

*Sources: Fetcher research — ai_code_copyright_ownership.md (MBHB analysis), us_copyright_office_ai.md (USCO official position). Updated 2026-03-23.*
