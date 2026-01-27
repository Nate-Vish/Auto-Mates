# Library Sources

*The knowledge base for all agents*

---

## What Is This?

This folder contains documentation, guides, and reference materials that agents study before making decisions. It's populated by **Fetcher** based on project needs.

## How It Works

1. **Agent identifies knowledge gap** - "I need to learn about X"
2. **Agent requests from Fetcher** - Provides URLs or search terms
3. **Fetcher fetches and organizes** - Downloads, summarizes, categorizes
4. **Agent studies sources** - Reads relevant files before proceeding

## Folder Structure

Sources are organized by category:

```
Sources/
├── INDEX.md           # Master index of all sources
├── [Category]/        # Topic-based folders
│   ├── source1.md
│   └── source2.md
└── ...
```

## Categories (Examples)

- `Python/` - Python documentation and guides
- `Security/` - Security standards and best practices
- `Legal/` - Licensing, privacy, compliance
- `[Your Topic]/` - Project-specific research

---

*Fetcher maintains this library. See `Library/Fetcher/HOW_TO_USE.md` for instructions.*
