---
title: "Communication & Keeping Teams In Sync"
category: "Team Communication & Coordination"
tags:
  - communication
  - team-coordination
  - documentation
  - code-review
  - onboarding
  - incident-response
  - async-work
  - decision-making
  - knowledge-management
source_type: professional-knowledge
audience: senior-developers
---

# Communication & Keeping Teams In Sync

Everything that goes wrong on a software team eventually traces back to a communication failure.
Not a technical failure. Not a skill failure. Someone didn't tell someone something, or told
them too late, or told them in a way they couldn't absorb.

This file covers the patterns that destroy team velocity and the practices that keep
teams moving together, even when they're distributed across timezones.

---

## 1. Knowledge Silos

A knowledge silo exists when critical information lives in exactly one person's head.

### The Bus Factor Problem

| Bus Factor | Risk Level | What It Looks Like |
|------------|------------|-------------------|
| 1 | Critical | One person knows the deploy process. They go on vacation. Deploys stop. |
| 2 | High | Two people understand the billing system. One quits. The other is now a single point of failure. |
| 3 | Moderate | Knowledge exists but isn't written down. People can explain it verbally. |
| 4+ | Manageable | Multiple people know the system AND documentation exists. |

### Symptoms of Knowledge Silos

```
SYMPTOM: "Only Sarah knows how that works"
REALITY: The team has a bus factor of 1 for a critical system.

SYMPTOM: "Let's wait for Mike to get back from PTO"
REALITY: Work stops because knowledge wasn't shared.

SYMPTOM: "That's just how we've always done it"
REALITY: Tribal knowledge with no documented rationale.

SYMPTOM: "I'll just do it myself, it's faster"
REALITY: Perpetuating the silo instead of teaching.
```

### Types of Dangerous Tribal Knowledge

| Type | Example | Why It's Dangerous |
|------|---------|-------------------|
| Deployment quirks | "You have to restart the cache after deploying service X" | Missed step causes outage |
| Business rules | "Orders over $10K need manual review because of the 2019 fraud incident" | Rule gets removed, fraud returns |
| Infrastructure secrets | "The staging DB is actually shared with QA, don't drop tables" | Data loss from reasonable action |
| Workarounds | "The API returns 200 even on failure, check the body for error_code" | New dev trusts the status code |
| Historical context | "We tried microservices for payments in 2021, it failed because..." | Team repeats a costly mistake |

### Breaking Silos: Practical Actions

1. **Pair rotations** -- Rotate who works on what system every quarter. Nobody "owns" a service forever.
2. **Document the "why"** -- Not just what the code does, but why this approach was chosen over alternatives.
3. **Record walkthroughs** -- A 15-minute video of someone explaining a system is worth more than 50 pages of docs nobody reads.
4. **Shadow on-call** -- Junior engineers shadow senior engineers during on-call before taking it solo.
5. **Enforce PR reviews from non-experts** -- If only the "expert" reviews changes to their system, the silo deepens.

---

## 2. Handoff Failures

Every handoff is a place where information dies. Between shifts, between teams,
between sprints, between phases of a project.

### The Handoff Anti-Pattern Catalog

| Anti-Pattern | What Happens | Fix |
|-------------|-------------|-----|
| The Verbal Handoff | "I told them in standup" -- no written record, details lost | Written handoff document, always |
| The Assumption Handoff | "They'll figure it out from the code" -- they won't | Explicit context: what's done, what's not, what's tricky |
| The Hero Handoff | "I'll just finish it myself" -- person burns out, no one else learns | Structured transition with overlap period |
| The Email Dump | 47 forwarded emails with "see below" -- impossible to parse | Summarize into a single handoff doc |
| The Ghost Handoff | Person leaves the company, no transition at all | Exit interview + knowledge capture sprint |

### Handoff Document Template

```markdown
## Handoff: [Feature/System Name]
Date: [YYYY-MM-DD]
From: [Name] -> To: [Name]

### Current State
- What's done: [list completed items]
- What's in progress: [list with % complete]
- What's blocked: [list with blocking reasons]

### Key Decisions Made
- [Decision]: [Why this choice, what alternatives were rejected]

### Known Issues & Gotchas
- [Issue]: [Workaround or plan]

### Where Things Live
- Code: [repo/branch]
- Docs: [links]
- Related tickets: [links]

### Open Questions
- [Question]: [Who might know the answer]

### First Thing To Do
- [The single most important next action]
```

### Handoff Timing Rules

| Situation | Minimum Overlap | Why |
|-----------|----------------|-----|
| Team member leaving company | 2 weeks | Knowledge transfer, document everything |
| Shift handoff (ops) | 30-minute overlap | Verbal + written, confirm understanding |
| Sprint-to-sprint | Same team, carry context | Don't reset context every 2 weeks |
| Cross-team project transfer | 1 week of joint work | Receiving team must do real work while handing-off team is still available |

---

## 3. Documentation That Actually Works

Most documentation is dead the moment it's written. The goal is living documentation
that stays accurate because it's tied to workflows people already use.

### The Documentation Spectrum

```
DEAD DOCS                                          LIVING DOCS
    |                                                   |
    v                                                   v
Confluence page     Word doc in      README in     ADRs in     Runbook tested    Code comments
from 2019,          SharePoint,      repo root,    repo,       monthly in        that explain
never updated       no owner         updated on    reviewed    incident drills   "why" not "what"
                                     every PR      quarterly
```

### Architecture Decision Records (ADRs)

ADRs are the single most valuable documentation practice. They capture the "why"
behind decisions so future developers don't reverse good choices or repeat bad ones.

```markdown
# ADR-0042: Use PostgreSQL Instead of MongoDB for Order Data

## Status: Accepted

## Date: 2024-03-15

## Context
We need a database for order data. Orders have complex relationships
(order -> items -> inventory -> suppliers) and we need ACID transactions
for payment processing.

## Decision
Use PostgreSQL with JSONB columns for flexible metadata.

## Consequences
- Positive: ACID compliance, mature tooling, team expertise
- Negative: Schema migrations needed, less flexibility than document store
- Neutral: Need to manage connection pooling at scale

## Alternatives Considered
- MongoDB: Better write performance but no multi-document transactions
  at the time of evaluation. Team had limited MongoDB experience.
- DynamoDB: Lock-in to AWS, complex query patterns for relational data.
```

### README-Driven Development

Write the README before writing the code. It forces you to think about:

| README Section | What It Forces You To Think About |
|---------------|----------------------------------|
| Project description | What problem does this solve? For whom? |
| Quick start | Is this actually easy to set up? |
| API overview | Is the interface intuitive? |
| Examples | Can someone understand this without reading all the code? |
| Contributing | Can someone else actually work on this? |

### Runbooks vs. Documentation

| | Documentation | Runbook |
|---|---|---|
| **Audience** | Developers learning the system | On-call engineer at 3 AM |
| **Tone** | Explanatory | Step-by-step commands |
| **Detail level** | Conceptual + detailed | Exact commands to copy-paste |
| **Update trigger** | When system changes | After every incident |
| **Example** | "The payment system uses event sourcing..." | "If payment queue backs up: 1. Check consumer lag: `kafka-consumer-groups --describe...`" |

### Documentation Ownership Rules

```
Rule 1: Every document has exactly one owner.
        No owner = dead document. Delete it or assign one.

Rule 2: Review dates are mandatory.
        If a doc hasn't been reviewed in 6 months, it's suspect.

Rule 3: Docs live next to the code.
        /docs in the repo, not a separate wiki nobody visits.

Rule 4: Delete aggressively.
        Wrong docs are worse than no docs. If it's stale, remove it.

Rule 5: Automate what you can.
        API docs from code comments. Diagrams from infrastructure-as-code.
        Architecture diagrams generated from dependency graphs.
```

---

## 4. Decision-Making Traps

Bad decisions are often not bad ideas -- they're bad processes.

### The Anti-Pattern Zoo

| Trap | Description | Consequence | Fix |
|------|------------|-------------|-----|
| Design by Committee | Everyone must agree on everything | Lowest common denominator solutions, months of meetings | Assign a decision owner. Others advise, one person decides. |
| Analysis Paralysis | Endlessly researching before acting | Nothing ships, competitors move ahead | Set a decision deadline. "We decide by Friday with whatever info we have." |
| HiPPO | Highest Paid Person's Opinion wins | Best ideas ignored because they came from junior engineers | Anonymous proposal reviews. Data-driven decisions. |
| Undocumented "Why" | Decision made but rationale lost | Next team reverses it, hits the same problems | ADRs for every significant technical decision. |
| Reversibility Blindness | Treating every decision as permanent | Overcautious, slow progress | Classify: one-way door (irreversible) vs two-way door (easily reversed). Move fast on two-way doors. |
| Consensus Theater | Pretending everyone agrees when they don't | Passive resistance, sabotage, "I told you so" later | Disagree and commit. Record dissenting opinions in the ADR. |

### Decision Framework

```
Step 1: Is this a one-way or two-way door?
        One-way: Careful analysis, broad input, ADR required.
        Two-way: Quick decision, try it, reverse if wrong.

Step 2: Who is the decision owner?
        ONE person. Not a committee. They gather input but they decide.

Step 3: What's the deadline?
        Every decision has a deadline. No open-ended deliberation.

Step 4: What information do we need?
        List it. Go get it. Don't research beyond what's listed.

Step 5: Document the decision.
        ADR format. Include alternatives considered and why they lost.

Step 6: Communicate the decision.
        Everyone affected knows. Written, not just verbal.
```

### The RACI for Technical Decisions

| | Responsible | Accountable | Consulted | Informed |
|---|---|---|---|---|
| API design | Backend lead | Tech lead | Frontend team, SRE | All engineers |
| Database choice | Tech lead | Engineering manager | DBA, SRE | All engineers |
| Dependency addition | Implementing dev | Tech lead | Security, team | All engineers |
| Architecture change | Tech lead | CTO/VP Eng | All senior devs | Whole org |

---

## 5. Async Communication

Most teams default to synchronous communication (meetings, Slack pings) when async
would be more effective and more inclusive across timezones.

### When to Use What

| Medium | Best For | Worst For |
|--------|---------|----------|
| **Chat (Slack/Teams)** | Quick questions, social, urgent alerts | Decisions, complex discussions, anything needing a record |
| **Document (RFC/ADR)** | Decisions, proposals, technical designs | Quick questions, time-sensitive issues |
| **Meeting** | Relationship building, brainstorming, conflict resolution | Status updates, information broadcast, decisions (unless time-boxed) |
| **Email** | External communication, formal records | Internal team discussion, anything needing quick response |
| **Video recording** | Demos, walkthroughs, complex explanations | Two-way discussions, quick updates |
| **Issue tracker** | Task tracking, bug reports, feature specs | Conversations, brainstorming |

### Writing Clear Async Updates

Bad async update:
```
"Made some progress on the auth thing. Hit a few issues but
working through them. Should be done soonish."
```

Good async update:
```
"Auth migration: 3 of 5 endpoints migrated to OAuth2.
Blocked on: token refresh endpoint -- existing tokens use
a non-standard expiry format. Need input from @backend-team
on whether to migrate existing tokens or support both formats.
ETA if unblocked: Wednesday. If we need to support both: Friday."
```

### The Async Update Formula

```
[WHAT] -- factual progress, with numbers if possible
[BLOCKED] -- what's stopping you, who can unblock
[NEED] -- specific ask, not vague "thoughts?"
[WHEN] -- realistic timeline with conditions stated
```

### Timezone-Aware Practices

| Practice | Why It Matters |
|----------|---------------|
| Include timezone in meeting invites | "3pm" means nothing without a timezone |
| Use a shared world clock | Know when colleagues are sleeping |
| Record every meeting | So async team members don't miss decisions |
| Set "response expected by" on messages | Removes anxiety about reply speed |
| Rotate meeting times | Don't always punish the same timezone |
| Default to async, escalate to sync | Meeting is the last resort, not the first |

---

## 6. Code Review Communication

Code review is where technical feedback meets human emotion. Get the
communication wrong and you destroy trust, morale, and velocity.

### Feedback Classification System

| Tag | Meaning | Blocks Merge? | Example |
|-----|---------|--------------|---------|
| `[BLOCKING]` | Must fix before merge | Yes | `[BLOCKING] SQL injection vulnerability in user input handling` |
| `[SUGGESTION]` | Would improve the code | No | `[SUGGESTION] Extract this into a helper function for reuse` |
| `[QUESTION]` | Need to understand before approving | Maybe | `[QUESTION] Is this N+1 query intentional? What's the expected data size?` |
| `[NIT]` | Style/preference, take it or leave it | No | `[NIT] I'd name this `userCount` instead of `cnt`` |
| `[PRAISE]` | Something done well | No | `[PRAISE] Great error handling here, covers all the edge cases` |

### Constructive Feedback Patterns

```
BAD:  "This is wrong."
GOOD: "[BLOCKING] This query runs without an index on user_id.
       On our current data size (~2M rows) this will cause
       full table scans. Add an index or use the existing
       users_by_email index instead."

BAD:  "Why did you do it this way?"
GOOD: "[QUESTION] I see you chose recursive descent here instead
       of the visitor pattern we use elsewhere. Was there a
       specific reason? Happy to discuss tradeoffs."

BAD:  "This function is too long."
GOOD: "[SUGGESTION] This function handles validation, transformation,
       and persistence. Consider splitting into three functions --
       it would make testing each concern easier."
```

### Review Request Etiquette

| Do | Don't |
|----|-------|
| Keep PRs under 400 lines when possible | Drop a 2000-line PR and expect same-day review |
| Write a PR description explaining the "why" | Title the PR "fixes stuff" |
| Self-review before requesting others | Leave TODOs and debug logs for reviewers to find |
| Tag the right reviewers | Tag the whole team on every PR |
| Respond to all comments, even with "Done" | Leave comments unresolved and merge |
| Link to the ticket/issue | Assume reviewer knows the context |

### Common Review Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Rubber stamping | Approving without reading | Require substantive comment before approval |
| Gatekeeper hoarding | Only one person can approve | Rotate review duties, trust the team |
| Nitpick avalanche | 40 comments about variable names | Use a linter. Save human review for logic. |
| Drive-by disapproval | "Looks wrong" with no explanation | Every rejection requires a specific, actionable reason |
| Review starvation | PRs sit for days unreviewed | SLA: first review within 24 hours |
| Scope creep in review | "While you're here, also refactor..." | File a separate issue. Don't block the current PR. |

---

## 7. Incident Communication

How you communicate during and after incidents determines whether your team
learns and improves or just panics and blames.

### During the Incident: Status Update Template

```markdown
## Incident Update: [Title]
Severity: [SEV1/SEV2/SEV3]
Time: [HH:MM UTC]
Status: [Investigating / Identified / Monitoring / Resolved]

### Impact
[Who is affected and how. Be specific. "Some users" is not specific.
"~15% of users in EU region cannot complete checkout" is specific.]

### Current Understanding
[What we know happened. Facts only, no speculation.]

### Actions Being Taken
[What we're doing right now. Who is doing it.]

### Next Update
[When the next update will be posted. Never leave this open-ended.]
```

### Stakeholder Communication Tiers

| Tier | Who | What They Need | Update Frequency |
|------|-----|---------------|-----------------|
| Tier 1 | Incident responders | Full technical detail | Real-time in war room |
| Tier 2 | Engineering leadership | Impact, ETA, resources needed | Every 30 minutes |
| Tier 3 | Customer-facing teams | What to tell customers | Every update change |
| Tier 4 | Executives | Business impact, timeline | Major status changes only |
| Tier 5 | Customers | Plain language status | Status page, email if major |

### Blameless Postmortem Structure

```markdown
## Postmortem: [Incident Title]
Date: [YYYY-MM-DD]
Duration: [Start time - End time]
Severity: [SEV level]
Authors: [Names]

### Summary
[2-3 sentences. What happened, who was affected, how long.]

### Impact
- Users affected: [number]
- Revenue impact: [if applicable]
- Duration: [time]

### Timeline
[Minute-by-minute: what happened, what was detected, what actions were taken]

### Root Cause
[Technical root cause. NO BLAME. Systems fail, not people.]

### What Went Well
[Things that worked during the response]

### What Went Poorly
[Things that didn't work -- process failures, not people failures]

### Action Items
| Action | Owner | Priority | Deadline |
|--------|-------|----------|----------|
| [Specific fix] | [Name] | [P0/P1/P2] | [Date] |

### Lessons Learned
[What the organization should take away from this]
```

### Communication Anti-Patterns During Incidents

| Anti-Pattern | Why It's Harmful | Do This Instead |
|-------------|-----------------|----------------|
| Blame in the moment | People stop reporting issues and hide mistakes | Focus on fixing. Analyze causes later. |
| Radio silence | Stakeholders panic, make assumptions, escalate | Update on a schedule, even if update is "no change" |
| Speculation as fact | Wrong information spreads, bad decisions follow | Clearly separate "we know" from "we think" |
| Hero worship | "Sarah saved us again!" normalizes single-point dependency | Credit the process and the team |
| Skipping the postmortem | Same incident recurs because nothing was learned | Postmortem within 5 business days. Non-negotiable. |

---

## 8. Onboarding & Mentoring

A new team member's first 90 days determine whether they become productive
or become a flight risk. Onboarding is not optional -- it's an investment.

### First-Week Plan Template

| Day | Focus | Activities |
|-----|-------|-----------|
| Day 1 | Environment | Machine setup, access grants, meet the team, building tour/virtual intro |
| Day 2 | Context | Read team docs, architecture overview, product demo from PM |
| Day 3 | Code | Clone repos, run the app locally, read through one feature end-to-end |
| Day 4 | First contribution | Pair with a buddy on a small, well-scoped ticket |
| Day 5 | Reflection | 1:1 with manager, what's clear, what's confusing, adjust plan |

### The Buddy System

Every new hire gets a buddy. The buddy is NOT their manager.

| Buddy Responsibility | Why |
|---------------------|-----|
| Answer "stupid" questions | New hires won't ask their manager things they think they should know |
| Pair on first few PRs | Learn codebase patterns through practice, not just reading |
| Explain unwritten rules | "We don't deploy on Fridays" is nowhere in docs |
| Check in daily for first 2 weeks | Catch confusion early before it compounds |
| Introduce to key people | Navigate the org, not just the code |

### Progressive Responsibility Ladder

```
Week 1-2:   Bug fixes and small improvements (guided)
Week 3-4:   Small features with clear specs (reviewed closely)
Month 2:    Medium features, participate in design discussions
Month 3:    Own a feature end-to-end, review others' PRs
Month 4-6:  Lead a small project, mentor newer team members
Month 6+:   Full autonomy, contribute to architectural decisions
```

### Onboarding Anti-Patterns

| Anti-Pattern | What It Looks Like | The Fix |
|-------------|-------------------|---------|
| Sink or swim | "Here's the repo, figure it out" | Structured first week, assigned buddy |
| Firehose | 8 hours of meetings on day 1 | Spread context over 2 weeks, mix learning with doing |
| Production on day 1 | "Deploy this to prod!" as first task | Start with low-risk changes in staging |
| No real work | Weeks of "training" with no actual coding | First real PR by end of week 1 |
| Assuming expertise | "You're senior, you don't need onboarding" | Everyone needs context on THIS team's systems |
| Ignoring feedback | New hire says "this is confusing" and nothing changes | New hire perspective is gold -- document and fix gaps |

### Mentoring Principles

```
1. ASK BEFORE TELLING
   "What have you tried so far?" before launching into the answer.
   They learn more from their own debugging than your explanation.

2. EXPLAIN THE WHY
   "We use connection pooling because..." not just "use connection pooling."
   Understanding principles beats memorizing procedures.

3. MAKE MISTAKES SAFE
   "Good catch on that bug in staging" not "how did you miss that?"
   People who fear mistakes stop taking initiative.

4. CELEBRATE PROGRESS
   "Your PR reviews have gotten really thorough" -- specific praise
   for growth, not just generic "good job."

5. TRANSFER OWNERSHIP
   The goal is to make yourself unnecessary. If they still need you
   for everything after 6 months, you're mentoring wrong.

6. PAIR, DON'T TAKEOVER
   "Let me drive for a minute to show you" then hand back the keyboard.
   Watching someone else code teaches less than doing it yourself.

7. SHARE YOUR MISTAKES
   "I once took down production because..." normalizes learning from failure.
   Senior devs who pretend they never fail create impostor syndrome.
```

### Knowledge Transfer Sessions

| Format | Duration | Best For |
|--------|----------|---------|
| Architecture walkthrough | 60 min | New team members understanding the big picture |
| Code reading session | 45 min | Understanding a specific module or feature |
| Debugging together | 30 min | Learning the team's debugging tools and techniques |
| Design review participation | 60 min | Understanding how the team makes technical decisions |
| Shadow on-call | 1 shift | Learning incident response and operational knowledge |
| Whiteboard session | 30 min | Explaining complex flows, data models, system interactions |

---

## Gal's Application: 10 Daily Rules

These are the rules I apply every single day when reviewing how teams communicate.
Not theory. Practice.

```
RULE 1: IF ONLY ONE PERSON KNOWS IT, IT'S NOT DOCUMENTED
        Any knowledge that exists in only one head is a ticking time bomb.
        I flag every bus-factor-of-1 situation I find. Every time.

RULE 2: EVERY DECISION GETS A "WHY"
        Code tells you what. Comments tell you how. ADRs tell you why.
        If I can't find the "why" for a significant decision, I raise it.

RULE 3: HANDOFFS GET WRITTEN DOWN
        Verbal handoffs are information destruction events.
        If it wasn't written, it didn't happen.

RULE 4: DEFAULT TO ASYNC, ESCALATE TO SYNC
        Most meetings should have been a document. I push for
        written proposals first, meetings only when needed.

RULE 5: CODE REVIEW IS COMMUNICATION, NOT GATEKEEPING
        I label every comment: blocking, suggestion, question, nit, praise.
        Reviewers owe authors clarity on what must change vs what's optional.

RULE 6: STATUS UPDATES HAVE NUMBERS AND DATES
        "Making progress" is not an update. "3 of 5 endpoints migrated,
        ETA Wednesday" is an update. I reject vague status.

RULE 7: ONBOARDING IS THE TEAM'S RESPONSIBILITY, NOT THE NEW HIRE'S
        "Figure it out yourself" is a failure of the team, not the
        new hire. I advocate for structured onboarding every time.

RULE 8: INCIDENTS GET POSTMORTEMS, NOT BLAME
        "Who broke it?" is the wrong question.
        "What allowed this to happen?" is the right one.
        I insist on blameless analysis.

RULE 9: DEAD DOCS ARE WORSE THAN NO DOCS
        Documentation with no owner and no review date is dangerous.
        It gives false confidence. I'd rather delete it than leave it.

RULE 10: THE BEST COMMUNICATION IS THE SIMPLEST
         If your message needs a meeting to explain, rewrite the message.
         Clarity is a skill. Practice it.
```
