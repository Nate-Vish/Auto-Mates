---
name: cv
description: "Build or tailor a resume for a specific job application. Structured intake, honest assessment, scoring loop, and export."
user_invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - WebFetch
  - WebSearch
  - Agent
---

# /cv — Resume Builder

Build, tailor, or critique a resume for a job application. Learns your career story, assesses fit honestly, scores iteratively, and exports clean documents.

---

## Usage

```
/cv                          → Start from scratch (guided intake)
/cv <job-url>                → Tailor resume for a specific posting
/cv critique                 → Review and score an existing resume
/cv status                   → Show all applications and their status
```

---

## Career Workspace

All career files live at: `Career/`

If this folder doesn't exist, create it on first run.

| File | Purpose |
|------|---------|
| `Profile.md` | Complete personal profile (single source of truth) |
| `resume-template.md` | Master resume template with learned formatting rules |
| `session-log.md` | All applications, decisions, lessons, learned preferences |
| `Applications/<Company>/` | Per-company resume, cover letter, career notes |

---

## Process

### Phase 1: Intake

**If profile exists** (`Profile.md`):
- Read it — most intake is pre-loaded
- Read `session-log.md` — past applications, lessons, preferences
- Read `resume-template.md` — master template and rules
- Ask only what's new or role-specific

**If no profile exists:**
Ask these questions in order (skip what's already known):
1. Name, contact info, links (GitHub, LinkedIn, portfolio)
2. Education (school, degree/program, status, graduation year)
3. Work experience (all roles, dates, what you actually did — not what you wish you did)
4. Projects (what you built, what tech, what's the current status — be honest)
5. Skills (only what you can defend in an interview)
6. Languages spoken and proficiency level
7. What drives you / personal story / career direction

**Save the profile** to `Profile.md` for future use. Update it whenever the user shares new experience.

### Phase 2: Job Analysis

If a job URL or description is provided:
1. Fetch and extract the full listing
2. Map requirements to profile — create an honest fit table:

```
| Requirement | Match | Evidence |
|-------------|-------|----------|
| Python 3+   | Strong | [user's relevant project] |
| K8s exp     | Gap   | No direct experience |
```

3. Classify overall fit: **Strong / Solid / Stretch / Wrong discipline**
4. If "Wrong discipline" — say so. Don't waste time on hopeless applications.
5. Identify what to emphasize and what order makes the strongest case

### Phase 3: Resume Drafting

Follow these **hard rules:**
- **DO NOT mirror the job description.** Describe what you actually did. Let the recruiter connect the dots.
- **DO NOT fabricate, inflate, or embellish.** No fake titles, no invented skills, no exaggerated metrics.
- **Every bullet starts with what YOU did** (Built, Designed, Shipped, Led, etc.)
- **Be honest about status.** "Planning" means planning. "Shipped" means shipped. "In progress" means in progress.
- **Only list skills you can defend in an interview.**
- **Reorder experience** to lead with what matters most for THIS role.
- **Drop irrelevant sections** — not every project belongs on every resume.
- **Tools belong in the Skills section** — not scattered through experience bullets.
- **Use honest framing** — don't inflate partial completion of education, projects, or roles.
- **Use natural language** for proficiency levels (Fluent, Conversational, Basic — not corporate jargon).
- **Use precise terminology** — match the industry and context (technical terms for technical roles, business terms for business roles).

Create the tailored resume at: `Applications/<Company>/resume-<company>-ats.md`

### Phase 4: Quality Score

Score the resume on 6 criteria (1-10 each):

| Criteria | Weight | What It Measures |
|----------|--------|------------------|
| **Honesty** | 25% | Zero fabrication, accurate status, defensible claims |
| **Relevance** | 20% | Experience order matches role, irrelevant content dropped |
| **Clarity** | 20% | Recruiter understands value in 6 seconds |
| **Authenticity** | 15% | Sounds like the person, not a job description mirror |
| **Completeness** | 10% | Nothing important missing (contact, dates, key experience) |
| **ATS-Ready** | 10% | Abbreviations spelled out, clean formatting, parseable |

**Weighted score must reach 8.0+ before proceeding.**

If below 8.0:
1. List specific issues per criteria
2. Fix them
3. Re-score
4. Repeat until 8.0+

**Honesty is weighted highest because a single fabrication can destroy credibility in an interview.**

### Phase 5: Cover Letter (Optional)

Write only if:
- The application portal requires one, OR
- The user asks for one, OR
- There's a personal connection worth mentioning (referral, shared mission, etc.)

Cover letter rules:
- Short (4-5 paragraphs max)
- Conversational tone for referrals, professional for cold applications
- Lead with the strongest connection to the role
- No generic filler ("I'm excited to apply to your esteemed organization...")
- If there's genuine admiration for the company's mission — include it, but only if it's real

Save to: `Applications/<Company>/cover-letter-<company>.md`

### Phase 6: Export & Log

1. **Export resume to PDF** if possible (use fpdf2 or available tools)
2. **Export cover letter to PDF** if one was written
3. **Log the application** in `session-log.md`:
   - Company, role, location, source/link
   - Key reframing decisions
   - Files created
   - Status: READY TO APPLY / APPLIED / SKIPPED (with reason)
4. **Update Profile.md** if new experience was mentioned

---

## Critique Mode (`/cv critique`)

When reviewing an existing resume:

1. Read the resume
2. Score it on all 6 criteria
3. For each criterion below 8:
   - State the specific problem
   - Give the specific fix
4. Flag any fabrication, inflation, or mirroring immediately
5. Provide overall weighted score and verdict

Verdicts:
- **9.0+** — Ship it
- **8.0-8.9** — Good, minor tweaks
- **6.0-7.9** — Needs work, specific issues listed
- **Below 6.0** — Major rewrite needed

---

## Status Mode (`/cv status`)

Read `session-log.md` and present:

```
| # | Company | Role | Status | Date |
|---|---------|------|--------|------|
| 1 | Google  | Software Engineer  | APPLIED | 2026-01-15 |
| 2 | Stripe  | Backend Developer  | READY   | 2026-01-20 |
| ...
```

---

## Anti-Patterns (Things We Do NOT Do)

- **No job description mirroring.** If the listing says "leverage cutting-edge AI," we do NOT write "leveraged cutting-edge AI." We describe what was actually done.
- **No self-scoring theater.** The score is a checklist, not a performance. If something scores low, fix it — don't argue with yourself about it.
- **No fake personas.** We don't pretend to be 8 experts. We're one agent doing thorough work. If independent review is needed, route to `/checker` or `/gal`.
- **No inflated titles.** "Open-Source Developer" not "Lead AI Engineer." "Personal Project" not "Startup."
- **No buzzword stuffing.** Skills section lists real tools. "Synergistic AI-driven paradigms" is not a skill.
- **Always audit AI-generated career materials before submitting** — check for fabrications, inflated claims, or mirrored language.

---

## Learning Preferences

This skill learns the user's career preferences over time through `session-log.md`. Preferences are discovered during sessions — not hardcoded. Examples of things the skill learns:

- How the user prefers to describe their education, experience, and projects
- Which projects are portfolio-ready and which aren't
- Preferred resume formatting and section ordering
- Industry-specific terminology the user prefers
- Cover letter tone and style

When a new preference is discovered, log it in `session-log.md` so future sessions can apply it automatically.
