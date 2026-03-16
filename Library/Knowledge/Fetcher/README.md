# Fetcher Knowledge Section

*Last updated: 2026-03-17*

Fetcher's professional knowledge for research and content gathering. Core tool references are self-contained files in this directory. Legal and API source files populate in `Library/Sources/` after Fetcher researches them.

---

## Core Tools (Self-Contained References)

| File | What It Covers |
|------|---------------|
| [jina_tools_reference.md](jina_tools_reference.md) | Jina Reader, Search, Embeddings — URL-to-markdown extraction, API reference |
| [legal_compliance_fetching.md](legal_compliance_fetching.md) | CFAA, robots.txt, GDPR, copyright — legal rules for web fetching |
| [metadata_format_guide.md](metadata_format_guide.md) | YAML metadata format for source files, citation standards |
| [playwright_cli_reference.md](playwright_cli_reference.md) | Browser automation via CLI — open, snapshot, click, fill commands |

## Tool Selection

| Scenario | Tool | Why |
|----------|------|-----|
| Simple static page | Jina Reader (`r.jina.ai`) | Fast, no browser needed |
| Dynamic/JS page | Playwright CLI | Renders JavaScript |
| Cookie consent / auth walls | Playwright CLI | Can interact with page |
| Search for sources | Jina Search (`s.jina.ai`) | AI-powered web search |
| Quick web search | WebSearch tool | Built-in, no API key |

## Browser Automation (Playwright CLI)

- **CLI Commands:** `playwright-cli open`, `playwright-cli snapshot`, `playwright-cli click`, `playwright-cli fill`, `playwright-cli type`
- **When to use:** Dynamic/JS pages, cookie consent walls, auth-required docs, interactive widgets
- **Fallback:** Use Jina (`r.jina.ai`) for simple static pages (faster, no browser needed)
- **Why CLI over MCP:** 4x fewer tokens — snapshots/screenshots save to disk, not context window

## Legal Compliance (Always Check Before Fetching)

- Respect `robots.txt` — always check before scraping
- GDPR: minimize personal data collection, honor opt-out
- CFAA: public data is generally fair game (hiQ v. LinkedIn), but respect ToS
- Copyright: fair use for research/analysis, not wholesale reproduction
- API terms: check data ownership and indemnification clauses

See [legal_compliance_fetching.md](legal_compliance_fetching.md) for the full compliance checklist.

## Knowledge Delivery Pattern

When fulfilling a knowledge request:
1. Research the topic (Jina, Playwright, WebSearch)
2. Create source file in `Library/Sources/[Category]/`
3. Update the requesting agent's `Library/Knowledge/[Agent]/README.md` with the new source link
4. Deliver summary to the requesting agent

---

*Fetcher's 4 core knowledge files are self-contained and ship with the repo. Additional sources populate in `Library/Sources/` during active research sessions.*
