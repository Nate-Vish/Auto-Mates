# Lessons Learned - Gal

*Mistakes to avoid, patterns that worked*

---

## [2026-03-28] - Playwright Static Captures Miss Scroll-Triggered Content
- **Context:** kelet.ai review — initial full-page screenshots showed ~1500px of "whitespace" that was actually scroll-triggered animation content. User corrected: the page looks fine to real visitors.
- **Lesson:** Playwright CLI `--full-page` doesn't trigger IntersectionObserver animations. Always capture AFTER scrolling programmatically (Node API with incremental `window.scrollTo`). Never trust a single static capture for UX conclusions.
- **Apply when:** Reviewing any modern website with scroll animations.

## [2026-03-28] - External Product Reviews Need Dual Perspective
- **Context:** kelet.ai review — running Gal (developer) + Daisy (brand) in parallel produced a much richer assessment than either alone.
- **Lesson:** For external product reviews, launch Daisy as a background agent for design/brand review while writing the developer review. Combine into single PDF with Part 1 (Dev) / Part 2 (Brand).
- **Apply when:** Any time the user asks for a product/site review for someone outside the team.

## [2026-03-28] - Research Agents Mix Current and Cached Web Content
- **Context:** kelet.ai review — research agent found "Request access" CTA and `docs.kelet.ai` references that Almog had already removed 2 days prior. Agent scraped cached/indexed content without distinguishing freshness.
- **Lesson:** When a research agent returns web findings, always verify critical claims against LIVE site using Playwright. Research agents treat cached/indexed content as current. For any finding that could be stale (UI elements, nav links, CTAs), confirm with a live DOM extraction before including in the review.
- **Apply when:** Any external product review that uses a research agent for web data. Always cross-check with live Playwright captures.

---

<!-- Template for new entries:

## [YYYY-MM-DD] - [Brief title]
- **Context:** [what happened]
- **Lesson:** [what to remember]
- **Apply when:** [future trigger]

-->
