# Information Architecture — Deep Dive

*Last updated: 2026-03-23*

How professional librarians and information architects organize knowledge systems. The principles that keep Library/Sources/ navigable, findable, and useful as it scales.

---

## The Librarian Model

Librarians have evolved from book custodians to knowledge architects who design systems for "creation, dissemination, and sharing of knowledge across various platforms." Fetcher IS the librarian of AutoMates.

**Five core competencies of the information architect:**

| Competency | What It Means | Fetcher Equivalent |
|-----------|---------------|-------------------|
| **Metadata management** | Create schemas that describe content (author, subject, format, date, tags) | YAML frontmatter on every source file |
| **Taxonomy design** | Structure information hierarchically with controlled vocabularies | Library/Sources/ category structure + INDEX.md |
| **Digital library management** | Preservation, migration, long-term accessibility | Sources/ lifecycle, cleanup, freshness tracking |
| **User-centered design** | Design around how users search, not how content was created | Agent-specific research profiles, tailored study files |
| **Collaborative framework** | Coordinate with specialists across domains | Knowledge requests from 9 agents with different needs |

---

## 10 Taxonomy Principles

Professional taxonomy design distilled from information science best practices:

### Principle 1: Start with User Research, Not Existing Content

Design taxonomy around how users (agents) think and search, not how content happens to be structured. Analyze search patterns. Identify vocabulary mismatches between what users call things and what the taxonomy calls them.

### Principle 2: Keep Top-Level Categories to 5-9

The "5-second test" — a new user should understand where to go within 5 seconds. More than 9 top-level categories creates decision paralysis. Use task-oriented names that describe what you'll find, not abstract labels.

### Principle 3: Limit Hierarchy Depth to 3-4 Levels Maximum

**Every additional hierarchy level reduces discoverability by approximately 50%.** This is the single most important structural constraint.

The 3-level rule:
```
Category/          (Level 1 — broad topic)
├── README.md      (Level 2 — category index with descriptions)
└── source.md      (Level 3 — individual content)
```

If you need more granularity, use faceted filtering (tags, metadata fields) instead of deeper nesting.

### Principle 4: Choose Clear, Searchable Category Names

Names serve dual purposes: navigation labels AND search terms. Rules:
- Use user vocabulary, not internal jargon
- Lowercase, hyphenated: `agentic-ai`, not `AgenticAI`
- Specific over broad: `llm-security` not `security`
- Plural for collections: `design-patterns`, `testing-strategies`
- Build controlled vocabulary mapping synonyms to preferred terms

### Principle 5: Balance Single-Select and Multi-Select

- **One primary category per content piece** — determines file location, keeps hierarchy clean
- **Multiple facets** via metadata — `relevant_agents`, `tags`, `content_type`, `difficulty`
- Never duplicate files across categories. One copy, multiple metadata pointers.

### Principle 6: Maintain Consistency While Enabling Flexibility

- **Required fields:** primary category, content type, audience (difficulty), description
- **Optional fields:** tags, secondary categories, quality notes
- Establish governance: who can create new categories, who reviews taxonomy changes

### Principle 7: Implement Governance and Auditing

- Periodic audits: remove empty categories, archive outdated content, update vocabulary
- Style guides documenting categorization rules with examples (see `metadata_format_guide.md`)
- New categories require user approval before creating folders

### Principle 8: Optimize for Both Browsing and Searching

Two user types exist:
- **Browsers** navigate hierarchically — serve them with INDEX.md, README.md per category
- **Searchers** use keywords — serve them with rich metadata, tags, keyword fields

Design for both. Structured metadata enables faceted refinement for searchers while hierarchy serves browsers.

### Principle 9: Use AI for Categorization Assistance

AI can suggest categories, tags, and metadata — reducing manual burden while maintaining consistency. Can also discover terminology gaps and identify missing content topics. But human (or agent) review remains essential.

### Principle 10: Monitor and Continuously Optimize

Key health metrics for a knowledge taxonomy:

| Metric | Target | Problem Signal |
|--------|--------|----------------|
| Search success rate | 80%+ | Below 60% = taxonomy failure |
| Category distribution | Roughly even | Giant categories + empty ones = restructure needed |
| Navigation depth | Average 3 or fewer clicks | Deeper = users give up |
| Empty category rate | 0% | Empty folders = consolidate or remove |
| Miscategorization rate | Low | High = unclear category definitions |
| Orphaned files | 0 | Files not in any index = lost knowledge |

---

## Metadata Standards

The foundation of findability. Metadata is the data that describes other data — it is what makes content discoverable.

### Key Metadata Standards in Professional Practice

| Standard | Domain | Our Implementation |
|----------|--------|-------------------|
| Dublin Core | General metadata (15 elements) | Adapted into YAML frontmatter fields |
| MODS | Library/archival metadata | Informed our `content_type` and `category` fields |
| YAML Frontmatter | Markdown file metadata | Our standard — see `metadata_format_guide.md` |

### Controlled Vocabulary

A controlled vocabulary maps multiple terms to a single preferred term. This prevents the same concept from being tagged differently across files.

Example:
- "machine learning", "ML", "deep learning" all map to tag `machine-learning`
- "JavaScript", "JS", "ECMAScript" all map to tag `javascript`
- "user interface", "UI", "frontend" all map to tag `ui`

Maintain this mapping informally now; formalize if Library/Sources/ exceeds 300 files.

---

## User-Centered Design for Information Retrieval

The information architecture exists to serve the agents who consume it. Design principles:

1. **Match the user's mental model** — organize by how agents think about topics, not by how sources were created
2. **Reduce cognitive load** — clear names, shallow hierarchies, consistent patterns
3. **Multiple access paths** — browsable hierarchy AND searchable metadata AND agent-specific index sections
4. **Progressive disclosure** — INDEX.md gives the overview; README.md per category gives detail; source files give depth
5. **Feedback-driven improvement** — if agents can't find what they need, the architecture is wrong (not the agent)

---

*For the specific YAML fields and formatting rules, see `metadata_format_guide.md`. For category naming conventions, see README.md Section 4.*
