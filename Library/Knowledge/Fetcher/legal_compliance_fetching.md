# Legal Compliance for Web Fetching

*Last updated: 2026-03-16*

Deep-dive reference for legal and ethical constraints on web fetching. Read before heavy fetch sessions, when a site's robots.txt blocks AI crawlers, or when handling sensitive data.

---

## robots.txt — Compliance Protocol

### What to Check

Before fetching any domain, check `[domain]/robots.txt`. Look for blocks on:

| User-agent string | What it represents |
|------------------|--------------------|
| `GPTBot` | OpenAI's crawler |
| `anthropic-ai` | Anthropic's crawler |
| `ClaudeBot` | Anthropic's Claude-specific crawler |
| `*` | All crawlers (universal block) |

A `Disallow: /` or `Disallow: /docs` under any of these agents means the site owner prefers that content is not crawled.

### Legal Status of robots.txt

robots.txt is not legally binding. Key precedent: **hiQ Labs v. LinkedIn (9th Circuit, 2022)** established that scraping publicly accessible data does not constitute a violation of the Computer Fraud and Abuse Act (CFAA). Public data on a publicly accessible site is not "unauthorized access."

However:
- It remains a clear expression of site owner preference
- Ignoring it exposes the project to potential ToS violation claims (civil, not criminal)
- Some jurisdictions and courts may weigh it differently

### Fetcher's Rule

1. Check robots.txt before every fetch session on a new domain
2. If blocked: inform user, describe what was blocked and which agent strings
3. Suggest alternatives: different source, official API, user manually copies content
4. User decides whether to proceed — Fetcher does not override site preferences unilaterally
5. Log the decision in the session notes

---

## GDPR — Data Minimization Rules

### Relevant Principle: Article 5(1)(c) — Data Minimization

GDPR requires that personal data be "adequate, relevant and limited to what is necessary in relation to the purposes for which they are processed."

### Application to Web Fetching

| Situation | Rule |
|-----------|------|
| Fetching technical documentation | No GDPR concern — no personal data |
| Fetching a page that contains user reviews, profiles, or names | Apply data minimization — extract the technical content, not the personal data |
| Fetching API responses that include user data | Do not save raw responses — strip personal fields before storing |
| Fetching content about a specific individual | Treat carefully — is this necessary for the task? Get user confirmation. |

### GDPR Web Scraping Best Practices

- **Lawful basis:** Research and legitimate interest can provide lawful basis, but only when the data subject's interests don't override it. For public technical documentation, this is a non-issue.
- **Transparency:** Sources are logged with URLs and fetch dates — this creates a transparent record.
- **Data retention limits:** Library/Sources/ is a temporary research cache. Sources that are no longer needed should be cleaned up (see `README.md` Section 8).
- **No special category data:** Never fetch or save data about health, biometrics, religion, or political opinions.

---

## API Terms Awareness

Before heavy use of any third-party API (including Jina, AI services, data providers), review the provider's Terms of Service. Key questions:

| Question | Why It Matters |
|----------|---------------|
| Do they claim rights to inputs? | Submitting queries may grant them a license to that content |
| Do they claim rights to outputs? | Generated/extracted content ownership may be contested |
| Do they use data for training? | Queries may improve their models — consider sensitivity of content |
| What is their data retention policy? | How long do they keep request/response logs? |
| What indemnification exists? | If their output causes a legal problem, who is liable? |
| Is commercial use permitted on the plan you're using? | Free tiers often restrict commercial use |

### Jina AI — Verified

- Jina Reader/Search: "claims no rights" to outputs
- Safe for research and knowledge base use
- Attribution of original sources still required

---

## Copyright — Fetching for Research

### The Core Distinction

**Public does not equal free use.**

Copyright applies to most web content by default, regardless of whether it is publicly accessible. The ongoing litigation landscape (notably **The New York Times v. OpenAI, 2023**) has made this a live legal question for AI systems.

### Fetcher's Copyright Rules

| Action | Allowed | Notes |
|--------|---------|-------|
| Fetch and save for internal research reference | Yes | Research / fair use basis. Include attribution. |
| Reproduce entire copyrighted article verbatim | No | Summarize and cite instead |
| Quote brief passages with attribution | Generally yes | Standard fair use principle |
| Save official documentation (Apache, MIT, etc.) | Yes | Permissively licensed |
| Save paywalled content bypassed through automation | No | CFAA / ToS violation territory |
| Reproduce a creative work in a deliverable | No | Get user confirmation, consult Legal agent |

### Attribution Standard

Every source file must include:
- `source_url` field with the original URL
- `fetched_date` field
- `copyright_notice` pointing to `FETCHING_DISCLAIMER.md`

This creates an auditable record of provenance for every piece of content in the library.

---

## FETCHING_DISCLAIMER.md

**Location:** `Library/Sources/Legal/FETCHING_DISCLAIMER.md`

This file contains the standard disclaimer applied to all fetched content. Every source file references it via the `copyright_notice` metadata field.

All source files must include:
```yaml
copyright_notice: "See Library/Sources/Legal/FETCHING_DISCLAIMER.md"
```

Do not inline the disclaimer text in individual source files — always reference the central file. This ensures consistent legal language across the entire library and allows the disclaimer to be updated in one place.

---

## Quick Reference: Decision Table

| Situation | Action |
|-----------|--------|
| robots.txt blocks ClaudeBot or * | Inform user, suggest alternatives, await user decision |
| Page contains personal data (names, profiles) | Extract technical content only, strip personal data |
| API ToS is unclear on commercial use | Flag the ambiguity in session notes, ask user if relevant |
| Content is from a news/media site | Summarize and cite — do not reproduce full articles |
| Content is official technical documentation | Fetch and save with attribution |
| Content is behind a paywall | Note limitation, do not bypass |
| User explicitly authorizes overriding robots.txt | Proceed, log the decision and the authorization |

---

*All fetching activity is governed by the standard disclaimer at `Library/Sources/Legal/FETCHING_DISCLAIMER.md`. For detailed IP questions, summon the Legal agent.*
