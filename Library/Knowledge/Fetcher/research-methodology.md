# Research Methodology — Deep Dive

*Last updated: 2026-03-23*

The systematic process for conducting research, synthesizing multiple sources, and delivering actionable knowledge. How to go from a knowledge request to a high-quality study file.

---

## The Research Process

### Phase 1: Understand the Request

Before searching, answer these questions:
- **Who** is requesting? (Which agent — this determines depth and framing)
- **What** do they need to accomplish? (The task, not just the topic)
- **What depth** is appropriate? (Quick fact, standard research, or deep investigation)
- **What do I already have?** (Check Library/Sources/ and Library/Knowledge/ first)

### Phase 2: Search Strategy

**Start broad, then narrow.** First search gets the landscape; follow-up searches target gaps.

| Strategy | When to Use | Example |
|----------|-------------|---------|
| **Multiple query angles** | Always | "React state management" + "React global state patterns" + "Redux vs Zustand comparison" |
| **Authority-first search** | When official docs exist | Search official docs, RFCs, and standards first |
| **Recency-filtered search** | Fast-moving domains | Filter to last 12 months for AI/frameworks |
| **Lateral search** | When direct searches yield thin results | Search related concepts, prerequisite topics, adjacent domains |
| **Citation chasing** | When you find one good source | Follow its references to find more primary sources |

### Phase 3: Evaluate and Select

Apply the CRAAP test (see `source-evaluation.md`) to every candidate source. Then:

- **Quick fetch (1-2 sources):** Agent needs a fact or reference. Find the most authoritative source and deliver.
- **Standard research (5-8 sources):** Agent needs to learn a domain. Cover the topic from multiple angles.
- **Deep investigation (10-15+ sources):** Building a knowledge section or study file. Cross-reference and synthesize.

### Phase 4: Synthesize and Deliver

Raw sources are not research. The value is in synthesis — connecting sources, identifying patterns, resolving contradictions, and framing for the requesting agent.

### Phase 5: Organize and Archive

Save sources with proper metadata. Update indexes. Deliver the study file. Check if the requesting agent's Knowledge README needs updating.

---

## Source Triangulation

The practice of verifying information by confirming it across multiple independent sources. This is what separates research from link-collecting.

### How to Triangulate

1. **Find the claim** in the first source
2. **Search for the same claim** in at least 2 more independent sources
3. **Compare details** — do they agree on specifics, not just the general idea?
4. **Check for independence** — are the sources actually independent, or do they all cite the same origin?

### Triangulation Outcomes

| Result | Meaning | Action |
|--------|---------|--------|
| 3+ sources agree on details | High confidence — this is established knowledge | Record as fact |
| Sources agree in general but differ on specifics | Moderate confidence — nuances exist | Record the consensus, note the variations |
| Sources directly contradict each other | Conflict — needs resolution | Flag the contradiction, include both perspectives, let requesting agent decide |
| Only 1 source covers the claim | Unverified — single-source information | Flag as unverified, note the limitation |

### Independence Check

Sources are NOT independent if:
- They cite the same original study/post
- They are written by the same author or organization
- One is clearly derived from the other
- They all come from the same content ecosystem (e.g., all from the same company's blog network)

---

## Literature Review Techniques

Borrowed from academic research methodology, adapted for technical research:

### Systematic Search

1. Define search terms and synonyms
2. Search across multiple platforms (web search, official docs, GitHub, academic papers)
3. Apply inclusion/exclusion criteria (CRAAP test + relevance to task)
4. Document what was searched, where, and what was found/excluded

### Snowball Technique

Start with one strong source, then:
- **Forward snowball:** Who has cited this source? (Find newer work building on it)
- **Backward snowball:** What does this source cite? (Find the foundational work)

Particularly effective for academic and standards-based research.

### Gap Analysis

After collecting sources, ask:
- What aspects of the topic are NOT covered by my sources?
- Are there perspectives missing? (e.g., only have the "pro" side, not the "con")
- Are there practical examples missing alongside the theory?
- Does the requesting agent have enough to do their job?

---

## Synthesis Methods

How to combine multiple sources into coherent, actionable knowledge:

### Thematic Synthesis

1. Read all sources and identify recurring themes
2. Group findings by theme (not by source)
3. For each theme: what do the sources collectively say?
4. Note where sources agree, where they add unique value, where they conflict

### Comparative Matrix

For tool/technology comparisons:

| Criterion | Source A says | Source B says | Source C says | Synthesis |
|-----------|-------------|-------------|-------------|-----------|
| Performance | Fast | Fast | Moderate | Generally fast, with caveats |
| Learning curve | Steep | Moderate | Steep | Steep consensus |

### Progressive Distillation

For building knowledge files from raw research:

1. **Raw sources** — full fetched content with metadata (Library/Sources/)
2. **Study file** — curated selection with reading order and key concepts
3. **Knowledge README** — distilled cheat sheet with inline key knowledge
4. **Topic files** — deep-dive references organized by subject

Each level is more condensed and more actionable than the previous.

---

## Multi-Criteria Source Ranking

When you have more sources than needed, rank them using weighted criteria:

| Criterion | Weight | Rationale |
|-----------|--------|-----------|
| **Relevance to task** | 50% | Does it directly answer the requesting agent's need? |
| **Currency** | 20% | Is it current enough for the domain? |
| **Authority** | 15% | How credible is the source? |
| **Uniqueness of contribution** | 15% | Does it add something the other sources don't? |

Keep the top-ranked sources. Archive or discard the rest.

---

## Knowing When You're Done

### Coverage Check

Can you explain the topic's:
- Key concepts?
- Common patterns and best practices?
- Major pitfalls and anti-patterns?
- Tradeoffs between approaches?

If yes for all four, you have sufficient coverage.

### Diminishing Returns Signal

New sources repeat what earlier ones said, with no new insights. This is the signal to stop searching and start synthesizing.

### Agent Sufficiency Test

Does the requesting agent have enough to do their job? Not everything ever written — just enough to be competent and informed. Over-researching wastes time and floods context.

---

## Research Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **Link collecting without reading** | Fetching 20 URLs and dumping links is not research | Read, evaluate, then save |
| **Single-source dependency** | One blog post is an opinion, not knowledge | Cross-reference with 2+ additional sources |
| **Recency bias** | Newest isn't always best | A 2020 architecture guide may beat a 2026 hot take |
| **Depth without breadth** | 10 sources on one subtopic, ignoring the rest | Map the full topic first, then go deep where needed |
| **Breadth without depth** | Surface-level coverage of everything | Better to deeply cover what matters than shallowly cover everything |
| **Research as procrastination** | Endless searching to avoid delivering | Set a source count target and stick to it |

---

## Research Output Organization

### Study File Structure

Every knowledge request gets a study file with this structure:

```markdown
# [Agent]_Study.md
**Prepared by:** Fetcher
**For task:** [what the agent is working on]
**Date:** YYYY-MM-DD

## Existing Sources (already in Library)
1. `Library/Sources/[path]` — [why relevant, key insight]

## Newly Fetched Sources
1. `Library/Sources/[path]` — [why relevant, key insight]

## Key Concepts to Understand
- [Concept — one-line explanation]

## Recommended Reading Order
1. Start with [source] — foundation
2. Then [source] — practical patterns
3. Deep-dive [source] — specific questions

## Task Reference
See: `Dashboard/Work_Space/[relevant file]`
```

### Quality Standards for Study Files

- Every source pointer includes WHY it's relevant and WHAT key insight it contains
- Reading order: foundational first, specialized last
- Key concepts section: 3-5 concepts the agent must understand before starting
- Context connection: tie research back to the specific task

---

*For source evaluation criteria, see `source-evaluation.md`. For organizing saved sources, see `information-architecture.md`. For legal/ethical constraints on fetching, see `web-research-ethics.md`.*
