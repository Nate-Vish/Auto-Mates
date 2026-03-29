---
name: video
description: Create videos — session recaps, explainers, comparisons, demos, marketing. Powered by Remotion.
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash
  - WebFetch
  - WebSearch
---

# /video — Create Any Video

One skill for all video needs. Describe what you want, get a Remotion-rendered video.

## Usage

```
/video recap                          # Recap this session as a video
/video recap <agent>                  # Recap from a specific agent's perspective
/video explain <topic>                # Explainer video on a topic
/video compare <option A> vs <B>      # Side-by-side comparison to help decide
/video demo <product or feature>      # Product/feature walkthrough
/video market <product>               # Promotional / marketing video
/video <free description>             # Anything else — describe and it gets made
```

---

## Video Types

### 1. Recap — `/video recap`

Summarize the latest session visually. Good for catching up without reading.

**What it produces:**
- Narration script (always — saved to file + printed in chat)
- Remotion video with title card, animated key points, closing next-steps card

**Script rules:**
- Conversational tone — as if briefing the user over coffee
- Second person ("You installed gcloud" not "gcloud was installed")
- ~300 words max, 1-2 minute video
- Lead with impact, skip internal mechanics
- Be specific ("updated 3 Knowledge files" not "made some updates")

**Script file location:** `[ProjectFolder]/Recap_[YYYY-MM-DD].md`
- If no specific project: `Recap_[YYYY-MM-DD].md`
- Do NOT create subfolders for recaps

**Script format:**

```markdown
# Session Recap — [YYYY-MM-DD]

**Agent:** [who was active]
**Generated:** [timestamp]

---

## Narration Script

[Narration text here]

---

## Quick Reference

### Changes
| What | Where |
|------|-------|
| [change] | [location] |

### Decisions
- [decision]: [reasoning]

### Next Steps
- [next action]
```

### 2. Explain — `/video explain <topic>`

Break down a concept visually. Good for learning, onboarding, knowledge sharing.

**Approach:**
1. Research the topic (read relevant files, web search if needed)
2. Structure as: What is it → Why it matters → How it works → Key takeaways
3. Write narration script (~300-500 words, 2-3 minutes)
4. Create Remotion composition: title → concept cards → diagrams/flow → summary

**Examples:**
- `/video explain OAuth vs API keys` — security concepts compared
- `/video explain LEARN FIRST protocol` — how our research workflow works
- `/video explain MCP servers` — what they are and why we use them

### 3. Compare — `/video compare <A> vs <B>`

Visual side-by-side to help make a decision. Good for tool selection, architecture choices.

**Approach:**
1. Research both options
2. Structure as: Overview of each → Key differences (table) → Pros/cons → Recommendation
3. Write narration script (~300-500 words, 2-3 minutes)
4. Create Remotion composition: split-screen cards, animated comparison table, verdict card

**Examples:**
- `/video compare Vercel vs Cloudflare Pages` — hosting decision
- `/video compare React vs Svelte` — framework choice
- `/video compare top 5 plate carriers` — product comparison

### 4. Demo — `/video demo <target>`

Walk through a product or feature. Good for showcasing what you built.

**Approach:**
1. Read the product code/docs to understand the flow
2. If Stitch screens exist, pull them as visual assets
3. Structure as: What it does → Live walkthrough → Key features → Try it
4. Write narration script (~200-400 words, 1-2 minutes)
5. Create Remotion composition: intro card → screen captures/recordings → feature callouts → CTA

**Examples:**
- `/video demo FinCat` — show the financial categorization tool
- `/video demo /forge` — walk through agent creation
- `/video demo AutoMates landing page` — showcase the site

### 5. Market — `/video market <product>`

Promotional video. Good for social media, GitHub, landing pages.

**Approach:**
1. Read brand guidelines and product context
2. Structure as: Problem → Solution → Proof → Call to action (Duarte Sparkline)
3. Write narration script (~200-300 words, 1-2 minutes)
4. Create Remotion composition: hook → pain point → product reveal → features → CTA
5. Use AutoMates brand colors (Deep Blue #1a1a2e, Purple #6b21a8, Gold #f59e0b)

**Examples:**
- `/video market AutoMates` — open-source promo
- `/video market Madko` — SaaS product teaser
- `/video market Sunny` — personal AI assistant intro

---

## Remotion Production

All video types follow the same production pipeline:

### Setup (first time only)

```bash
cd video-studio && npm create video@latest -- --blank
npm install @remotion/transitions @remotion/animated-emoji
```

The `video-studio/` folder is reused across all video renders.

### Composition Architecture

Every video is built from modular components:

- **TitleCard** — video title, date, branding
- **TextSlide** — narrated bullet points with fade-in animations
- **ComparisonSlide** — split-screen for compare videos
- **ScreenSlide** — product screenshots with zoom/pan
- **CalloutOverlay** — highlight specific elements
- **ClosingCard** — next steps, CTA, branding

Use `@remotion/transitions` for smooth fades and slides between sections.

### Rendering

```bash
npx remotion render <CompositionId> <output-filename>.mp4
```

Options:
- `--quality` for quality level
- `--codec h264` for compatibility
- `--concurrency` for parallel rendering

### Visual Standards

- **Brand colors:** Deep Blue #1a1a2e (background), Purple #6b21a8 (accent), Gold #f59e0b (CTA/highlight)
- **Typography:** Max 2 font families, clear hierarchy
- **Duration:** 1-3 minutes per video (don't overstay)
- **Frame rate:** 30fps default
- **Resolution:** 1920x1080 (landscape) or 1080x1920 (social/vertical)

### Stitch Integration

If a Stitch project exists with relevant screens:
1. List screens via `list_screens`
2. Download screenshots as visual assets
3. Use in ScreenSlide components with zoom/pan effects
4. Reference the `remotion` global skill for Stitch-to-Remotion patterns

---

## Report

After every `/video` invocation:

```
=== VIDEO ===
Type:    [recap / explain / compare / demo / market]
Topic:   [what the video is about]
Script:  [path to narration file, if applicable]
Video:   [path to .mp4]
Duration: [~minutes]
=============
```

Always print the narration script in chat so the user can read it immediately.

---

*One command. Any video. Describe what you need.*
