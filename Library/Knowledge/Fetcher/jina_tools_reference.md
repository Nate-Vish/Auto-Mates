# Jina Tools Reference

*Last updated: 2026-03-16*

Deep-dive reference for Jina Reader and Jina Search. Read when setting up, troubleshooting, or deciding whether to use Jina vs an alternative.

---

## Tool Overview

| Tool | Endpoint Pattern | Purpose | Auth Required |
|------|-----------------|---------|---------------|
| Jina Reader | `r.jina.ai/[url]` | Extract clean markdown from a URL | No (basic) / API key (enhanced) |
| Jina Search | `s.jina.ai/[query]` | Web search returning markdown results | Yes (API key) |

---

## Jina Reader

**Endpoint:** `https://r.jina.ai/[full-url]`

**Example:** `https://r.jina.ai/https://docs.python.org/3/library/asyncio.html`

### What It Does
- Fetches the target URL and strips away navigation, ads, sidebars, and HTML cruft
- Returns clean, readable markdown suitable for LLM context
- Handles many (but not all) JavaScript-rendered pages
- Preserves code blocks, tables, and document hierarchy

### Rate Limits

| Mode | Rate Limit | Setup |
|------|-----------|-------|
| Basic (no key) | 20 RPM (requests per minute) | No setup required |
| Enhanced (API key) | 500 RPM | `export JINA_API_KEY=your_key` |

### Usage

Basic mode — no credentials needed:
```
GET https://r.jina.ai/https://example.com/page
```

Enhanced mode — pass key in header:
```
GET https://r.jina.ai/https://example.com/page
Headers: Authorization: Bearer $JINA_API_KEY
```

---

## Jina Search

**Endpoint:** `https://s.jina.ai/[query]`

**Example:** `https://s.jina.ai/React+server+components+guide`

### What It Does
- Performs a web search and returns markdown-formatted results
- Each result includes title, URL, and extracted content snippet
- Results are already clean markdown — no further extraction needed
- Good for discovering sources before deciding which to fetch in full

### Requirements
- API key required for all usage
- Pass key in `Authorization: Bearer $JINA_API_KEY` header

---

## Common Issues and Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| Returns mostly CSS / no readable content | Page is JavaScript-rendered SPA, Jina's extractor got the shell | Fall back to Playwright CLI |
| Truncated content | Page is very long (Jina applies content limits) | Fetch page sections separately, or use Playwright snapshot |
| 429 Too Many Requests | Hit rate limit (20 RPM on free tier) | Space requests 3-4 seconds apart, or set API key for 500 RPM |
| Content is from a different page | Redirect followed unexpectedly | Check the final URL in the response, adjust query |
| Search returns no results | Query too narrow or too long | Shorten query, use key terms only |
| Jina Search blocked | No API key set | Set `JINA_API_KEY` before using `s.jina.ai` |

---

## Fallback Strategy

```
1. Try r.jina.ai/[url]
   - Success → save result
   - Returns CSS only / empty → go to step 2

2. Try Playwright CLI: playwright-cli snapshot [url]
   - Success → extract relevant sections, save
   - Requires auth → note limitation, ask user

3. Cannot fetch → note the source, save URL for manual review
```

Rule: always try Jina first. It is faster, uses fewer tokens, and requires no browser.

---

## IP Hygiene — Jina ToS

Jina's Terms of Service state that Jina **"claims no rights"** to the content returned by Reader or Search.

- Outputs belong to the user
- Safe for research and knowledge base use
- Attribution of original sources is still required (see `legal_compliance_fetching.md`)

---

## Setup Reference

```bash
# Check if key is set
echo $JINA_API_KEY

# Set key for current session
export JINA_API_KEY=your_key_here

# Add to shell profile for persistence
echo 'export JINA_API_KEY=your_key_here' >> ~/.zshrc
```

No other setup is required. Jina Reader works immediately without any installation.

---

*Read `playwright_cli_reference.md` for Playwright fallback procedures. Read `legal_compliance_fetching.md` for robots.txt and ToS compliance before fetching.*
