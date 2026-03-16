# Playwright CLI Reference

*Last updated: 2026-03-16*

Deep-dive reference for Playwright CLI browser automation. Read when fetching JS-rendered pages, auth-required documentation, or content that Jina Reader failed to extract.

---

## When to Use Playwright CLI

| Situation | Use Playwright | Notes |
|-----------|---------------|-------|
| JS-rendered SPA (React, Angular, Vue apps) | Yes | Jina gets the shell, not the content |
| Cookie consent / GDPR walls | Yes | Can click through dialogs |
| Auth-required documentation | Yes | Can handle login flows |
| Interactive widgets (tabs, accordions) | Yes | Can click to reveal content |
| Jina returned CSS-only content | Yes | Fallback path |
| Static HTML page | No | Use Jina — faster and lighter |
| Public markdown / plain HTML | No | Use Jina |

**Rule:** Jina first. Playwright only when Jina fails or the situation demands a browser.

---

## Why CLI Over MCP

| Factor | Playwright CLI | Browser MCP Tool |
|--------|---------------|-----------------|
| Token cost | Low — snapshots/screenshots saved to disk | High — content returned directly to context window |
| Context window impact | Minimal | Large (can flood context with HTML) |
| Relative efficiency | ~4x fewer tokens consumed | Baseline |
| Setup | Already installed in AutoMates | Depends on configuration |

Playwright CLI saves output to disk. Fetcher reads what it needs from the saved file. This preserves context window space.

---

## Core Commands

### Open a URL
```bash
playwright-cli open [url]
```
Opens a browser and navigates to the URL. Useful for verifying a page loads before further commands.

### Take a Snapshot (Accessibility Tree)
```bash
playwright-cli snapshot [url]
```
Captures the accessibility tree of the page as structured text. Faster than a screenshot, more parseable. Use this for content extraction.

### Take a Screenshot
```bash
playwright-cli screenshot [url] [output-path]
```
Saves a PNG screenshot to disk. Use when visual layout matters or when snapshot does not capture the content.

### Click an Element
```bash
playwright-cli click [selector]
```
Clicks a CSS selector or ARIA label. Use for: cookie consent buttons, tab navigation, "Load more" buttons.

### Fill a Form Field
```bash
playwright-cli fill [selector] [value]
```
Types a value into an input field. Use for: search boxes, login forms.

### Type Text
```bash
playwright-cli type [text]
```
Types text at the current cursor position.

---

## Common Workflows

### Fetch a JS-Rendered Page
```bash
playwright-cli snapshot https://example.com/docs/page
# Read the saved snapshot file
# Extract relevant sections
# Save to Library/Sources/[category]/[filename].md with metadata
```

### Handle Cookie Consent Wall
```bash
playwright-cli open https://example.com/page
playwright-cli click "button[aria-label='Accept cookies']"
playwright-cli snapshot https://example.com/page
```

### Navigate Through Tabs/Sections
```bash
playwright-cli open https://example.com/docs
playwright-cli click "#tab-api-reference"
playwright-cli snapshot https://example.com/docs
```

### Auth-Required Documentation
```bash
playwright-cli open https://platform.example.com/docs
playwright-cli fill "#email" "user@example.com"
playwright-cli fill "#password" "password"
playwright-cli click "button[type='submit']"
playwright-cli snapshot https://platform.example.com/docs/target-page
# Note: auth credentials come from user — never store in Library
```

---

## Installation

Playwright CLI is already installed in AutoMates. No setup needed.

To verify:
```bash
npx playwright --version
```

To install browsers if needed:
```bash
npx playwright install
```

---

## Fallback Decision Tree

```
Jina returns clean content?
  Yes → save, done
  No (CSS only / blank / truncated) →

    Is the page JS-rendered?
      Yes → playwright-cli snapshot [url]
        Success → extract, save
        Requires login → ask user for credentials or ask user to fetch manually

    Is the page paywalled?
      Yes → note the limitation, save URL only, do not bypass

    Is the page rate-limited?
      Yes → space requests, retry after delay
```

---

## Output Handling

Playwright CLI saves files to disk. After capture:

1. Read the snapshot/screenshot file
2. Extract the relevant sections (do not save entire DOM dumps)
3. Clean up: remove navigation chrome, repeated boilerplate, ad slots
4. Write to `Library/Sources/[category]/[filename].md` with full YAML metadata
5. Delete the raw snapshot/screenshot file (it has served its purpose)

---

*Read `jina_tools_reference.md` for the primary fetch method. Read `legal_compliance_fetching.md` for compliance rules before using Playwright on any site.*
