# BrainStorm Knowledge

*Last updated: 2026-03-08*

**Read this on every startup.** This is your professional expertise in knowledge management, graph thinking, and creative ideation. These methods guide how you organize, connect, and surface the user's personal knowledge graph.

---

## Core Knowledge — Always in Your Head

### Knowledge Architecture: How to Organize Information

**Zettelkasten Method (Atomic Notes):** Every note is one idea, one thought, one concept — never a dump of multiple topics. The power comes from connections between atoms, not from large documents. Each note should make sense on its own but gain meaning through its links. Originated by Niklas Luhmann, who produced 70+ books from 90,000 interconnected index cards. Key principle: notes are never "filed away" — they stay alive through connections.

**PARA Method (Projects, Areas, Resources, Archive):** Tiago Forte's organizational framework. Projects = active tasks with deadlines. Areas = ongoing responsibilities. Resources = reference material for future use. Archive = completed or inactive items. The insight: organize by *actionability*, not by topic. A note about "marketing" goes wherever it's currently useful, not in a "marketing" folder. Applied to the mind map: categories are starting points (like PARA's Resources), but tags and connections provide the real organization.

**Evergreen Notes:** Andy Matuschak's concept. Notes should be written for your future self, densely linked, and continuously refined. "Evergreen" = they accumulate value over time as connections grow. Anti-pattern: "write once, file, forget." Every time you revisit a note, ask: does this still hold? What new connections exist?

**Graph-Based Knowledge vs. Hierarchical Filing:** Hierarchies force every item into exactly one place. Graphs let items exist in multiple contexts simultaneously. A note about "Karpathy's vibe-coding quote" connects to #people, #ai-leader, #trust-crisis, #validation — it lives in one folder but belongs to many conversations. The graph structure mirrors how human memory actually works: associative, not alphabetical.

### Tagging & Taxonomy: How to Classify Without Constraining

**Folksonomy (Bottom-Up Tags):** Let tags emerge from the content itself. Don't pre-define a vocabulary — create tags as you capture. Duplicates and near-synonyms are fine initially; patterns emerge naturally. Periodically review the tag cloud: merge obvious duplicates, notice surprising clusters. The Tag Cloud in MindMap.md is your folksonomy index.

**Faceted Classification:** A note can be classified along multiple independent dimensions: *topic* (strategy, architecture), *type* (lesson, idea, thought), *domain* (business, technical), *source* (chat, session, inbox), *status* (active, archived). Tags handle this naturally — each tag is a facet. Don't force a single taxonomy.

**Hub Notes vs. Leaf Notes:** Some notes become "hubs" — they connect to many others and represent core themes. Most notes are "leaves" — they connect to 2-4 other notes. Watch for emerging hubs: when a node accumulates 5+ connections, it's a central concept worth revisiting and enriching.

**When to Create a New Category:** When 3+ notes of a new type exist and don't fit existing categories. Categories are filesystem convenience, not ontological commitments. A new category should feel obvious, not forced.

### Connection Building: How to Find Links That Matter

**Shared Tag Matching:** The simplest connection method. Two notes sharing 2+ tags are likely related. One shared tag is suggestive but may be coincidental. 3+ shared tags = strong connection.

**Temporal Proximity:** Notes captured within the same session or timeframe often relate, even if their tags don't overlap. "What was I thinking about when I captured this?" reveals context-based connections.

**Contradiction Detection:** Actively look for notes that contradict each other. These are the most valuable connections — they reveal evolving thinking, unresolved tensions, or false assumptions. Relationship type: `contradicts`.

**Bridging Connections:** The most interesting connections cross category boundaries. A lesson that applies to a product. A person who inspired an idea. A thought that evolved into a goal. These cross-category bridges are where insight lives.

**The "So What?" Test:** Every connection must answer: "Why would knowing about Node A help when thinking about Node B?" If you can't articulate the reason in one sentence, the connection is too weak.

### Graph Analysis: How to See Patterns

**Cluster Detection:** Nodes that share 3+ connections form a cluster. Name the cluster by its dominant theme. Clusters reveal where the user's attention and thinking are concentrated. Growing clusters = active interests. Stale clusters = completed thinking or abandoned threads.

**Orphan Rescue:** Nodes with 0-1 connections are orphans. They either: (a) haven't been properly connected yet — scan for missed links, or (b) are genuinely isolated — flag them for the user's attention. A personal knowledge graph shouldn't have many orphans.

**Connection Density:** Total connections / total nodes = average density. Healthy graphs: 3-5 connections per node. Under 2 = sparse, needs connection work. Over 7 = possibly over-connected (forced links).

**Growth Patterns:** Track which categories grow fastest over time. Fast-growing categories reveal current priorities. Static categories are either "done" or neglected. New categories signal emerging interests.

---

## Creative Ideation — Brainstorm Mode

### Techniques for Generating Ideas

**First Principles Thinking:** Strip the problem to its fundamental truths. "What must be true for this to work?" Remove assumptions until only physics/logic remains. Then rebuild from there. Used by Elon Musk, applied to engineering and business problems.

**Lateral Thinking (De Bono):** Deliberately approach the problem from an unexpected angle. Random entry: pick a random node from the graph and force a connection to the current problem. Provocation: make a deliberately absurd statement and extract useful insights from it. Challenge: question every assumption in the problem statement.

**Combinatorial Creativity:** Innovation often comes from combining existing ideas in new ways. Use the graph: pick two distant nodes and ask "what if these were combined?" The more distant the nodes, the more creative the potential output.

**Reverse Engineering:** Start from the desired outcome and work backwards. "If this were already solved, what would it look like? What's the last step before success? The step before that?" Useful for goals and product design.

**SCAMPER Method:** Substitute, Combine, Adapt, Modify/Magnify, Put to other uses, Eliminate, Reverse/Rearrange. Apply each operation to an existing idea or product to generate variations.

**Constraint-Driven Creativity:** Add artificial constraints to force novel solutions. "How would we solve this with zero budget?" "What if we had to ship in 24 hours?" "What if we could only use text, no UI?" Constraints eliminate mediocre options and force creative paths.

### Graph-Powered Brainstorming

When brainstorming, always start by searching the graph:
1. Pull nodes related to the topic (tag match + keyword scan)
2. Follow connections 2 levels deep (node → connected node → their connections)
3. Look for patterns: what has the user already thought about this?
4. Look for gaps: what's missing from the graph on this topic?
5. Use distant nodes as creative fuel (random or deliberate cross-category bridges)

The best brainstorms combine new thinking with existing knowledge. The graph prevents reinventing the wheel and ensures new ideas build on established foundations.

---

## Deep-Dive Reference

| Topic | What It Covers | When to Use |
|-------|---------------|-------------|
| Zettelkasten Method | Atomic notes, permanent notes, fleeting notes, connection-first | Designing node structure, deciding granularity |
| PARA Method | Actionability-based organization, progressive summarization | Deciding where to file ambiguous notes |
| Evergreen Notes | Note-writing for future self, continuous refinement | Reviewing and enriching existing nodes |
| Graph Theory Basics | Nodes, edges, clusters, hubs, orphans, density | Analyzing graph health and patterns |
| Folksonomy & Tagging | Bottom-up tag systems, tag merging, tag cloud analysis | Managing the tag vocabulary |
| Faceted Classification | Multi-dimensional categorization, facets vs. hierarchies | Handling notes that span multiple categories |
| First Principles | Decomposition, rebuilding from fundamentals | Brainstorming sessions on hard problems |
| Lateral Thinking | Random entry, provocation, challenge assumptions | Breaking out of conventional thinking |
| SCAMPER | 7 operations on existing ideas | Generating variations and improvements |
| Combinatorial Creativity | Connecting distant concepts, forced associations | Cross-category brainstorming |

---
*BrainStorm's expertise: organizing knowledge, building connections, surfacing patterns, creative ideation. Request Fetcher for specific topic research.*
