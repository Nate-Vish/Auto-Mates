# Source Evaluation — Deep Dive

*Last updated: 2026-03-23*

How to determine whether a source is worth keeping, citing, or discarding. The professional standard for information quality assessment.

---

## The CRAAP Test

Developed by Sarah Blakeslee at California State University, Chico (2004). The most widely used source evaluation framework in academia. Five criteria, applied in order:

### 1. Currency (Timeliness)

- When was it published or last updated?
- Are links functional? (Dead links = neglected content)
- Is it current enough for the domain?

**Domain-specific currency rules:**

| Domain | Shelf Life | Examples |
|--------|-----------|----------|
| AI / ML frameworks | 6-12 months | Model architectures, library APIs, prompt engineering |
| Web frameworks | 12-18 months | React, Next.js, Svelte — API changes frequently |
| Security vulnerabilities | Immediate | CVEs, OWASP updates — stale = dangerous |
| Regulations / law | Until superseded | GDPR, CCPA — check for amendments |
| Algorithms / CS fundamentals | Decades | Sorting, graph theory, design patterns — timeless |
| Legal precedent | Until overruled | Court rulings — check if still good law |

### 2. Relevance (Importance)

- Does it answer the requesting agent's actual question?
- Is the depth appropriate? (Not too basic, not too advanced for the audience)
- Does it cover the specific aspect needed, or just the general topic?

**Relevance calibration by agent:**
- **Builder** needs implementation detail, code examples, version-specific APIs
- **Planner** needs architecture overview, tradeoffs, decision frameworks
- **Checker** needs attack vectors, vulnerability details, defense patterns
- **Legal** needs authoritative legal text, not summaries or opinions

### 3. Authority (Source Credibility)

**Authority hierarchy (strongest to weakest):**

1. Official documentation (language docs, framework docs, RFC specs)
2. Standards bodies (OWASP, W3C, IETF, ISO, NIST)
3. Recognized institutions (.edu, .gov, established research labs)
4. Established tech publications (with editorial review)
5. Named expert authors with verifiable credentials
6. Community-vetted content (high-score Stack Overflow, well-maintained GitHub repos)
7. General blog posts by unknown authors
8. AI-generated listicles, SEO-optimized filler, content farms

**Domain signals:**
- `.edu`, `.gov`, `.org` (established) — generally stronger than `.com`
- URL alone is not sufficient — evaluate the actual author and publisher

### 4. Accuracy (Reliability)

- Is the information supported by evidence, references, or data?
- Can you verify claims against other sources?
- Has it been peer-reviewed or technically reviewed?
- Is the tone measured and unbiased, or promotional?
- Are there factual errors in areas you can independently verify?

**Cross-reference rule:** One blog post is an opinion. Confirmed by 3+ independent sources = knowledge. Always flag contradictions between sources.

### 5. Purpose (Intention)

- Why does this content exist? Inform? Teach? Sell? Persuade?
- Is it fact, opinion, or marketing?
- Does the author or publisher have a financial interest in the reader's decision?

**Common disguises to detect:**
- Affiliate listicles disguised as objective guides ("Best X in 2026")
- Vendor whitepapers disguised as independent research
- Self-promotion disguised as best practices or case studies
- Content marketing disguised as tutorials

---

## CRAAP Test Limitations and Extensions

The CRAAP test was designed in 2004 for evaluating traditional sources. Modern extensions needed:

### AI-Generated Content Detection

Since 2023, a significant portion of web content is AI-generated. Red flags:
- Generic language with no specific, verifiable examples
- Circular reasoning (restates the question as the answer)
- Suspiciously comprehensive coverage with no depth on any point
- No author attribution or author has no verifiable identity
- Perfect grammar but no distinctive voice or perspective

### Contradiction Check

- Does this source contradict well-established, authoritative sources?
- If yes: is the contradiction explained and evidence-backed, or just asserted?
- Contradiction without explanation = red flag
- Contradiction with evidence = potentially valuable (new finding, updated understanding)

### Primary vs Secondary Source Check

| Type | Definition | Examples | Trust Level |
|------|-----------|----------|-------------|
| **Primary** | Original source of the information | Official docs, RFCs, court rulings, original research papers, specifications | Highest |
| **Secondary** | Interprets or analyzes primary sources | Tutorials, blog analyses, guides, textbooks | Good (verify against primary) |
| **Tertiary** | Compiles from secondary sources | Wikipedia, listicles, aggregator sites | Starting point only (follow to primary) |

**Rule:** Always prefer primary when available. Use secondary for practical application and context. Tertiary for initial orientation only.

---

## Practical Scoring

When evaluating a source, mentally score each CRAAP criterion:

| Score | Meaning | Action |
|-------|---------|--------|
| **Strong on all 5** | High-confidence source | Save with clean metadata |
| **Weak on 1 criterion** | Usable with caveat | Save with `quality_note` explaining the weakness |
| **Weak on 2+ criteria** | Questionable | Look for a better source; only save if nothing else covers the topic |
| **Fails on Authority + Accuracy** | Unreliable | Do not save. Find an alternative. |

---

## When to Flag vs Discard

| Situation | Action |
|-----------|--------|
| Source quality is questionable but content may be useful | Save with `quality_note: "[UNVERIFIED]"` |
| Source contradicts other saved sources | Flag the conflict in `quality_note`, let requesting agent decide |
| Source is authoritative but outdated | Save with `quality_note: "[REVIEW - verify current status]"` |
| Source fails Authority + Accuracy | Discard. Find a better source. |
| Source is the only one covering a needed topic | Save with caveats. Note it is unverified single-source information. |

---

*The CRAAP test is a starting framework, not a formula. Professional judgment — informed by domain knowledge and cross-referencing — is the final arbiter.*
