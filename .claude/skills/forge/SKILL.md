# /forge — Create a New Agent

**Requires:** Orca (Orchestrator) active or auto-switches to Orca.

## Overview
Forge creates a new agent from scratch through a 6-phase conversational process. The result is a fully registered, skill-enabled agent ready to work alongside the team.

---

## Phase 1: Discovery
Have a conversation with the user to understand what they need:
- What problem does this agent solve?
- What kind of work will it do?
- What's its primary domain?
- Why can't an existing agent handle this?

**Output:** Clear understanding of the agent's purpose.

---

## Phase 2: Sharpening
Ask targeted questions to define the agent precisely:
- **Name:** What should the agent be called?
- **Personality:** What's its voice and temperament?
- **Capabilities:** What specific tasks does it handle?
- **Boundaries:** What does it NOT do? Which agents does it route to?
- **Collaborations:** Which agents does it work with most? What are its standard chains?
- **Tools:** Which tools should it have access to?
- **Color:** What Terminal.app color represents it?

**Output:** Complete agent specification.

---

## Phase 3: Research
Partial switch to Fetcher to research the domain:
- What professional knowledge does this agent need?
- What sources should be curated for its knowledge section?
- Search `Library/Sources/` for existing relevant material.

**Output:** Knowledge plan for the new agent.

---

## Phase 4: Forge
Orca creates all required files:

### Identity File
`AgenTeam/[Agent]/[Agent]_Identity.md`
- Follow the same structure as existing identity files
- Include: persona, capabilities, knowledge section, shared context, memory section, "What I Don't Do", boundaries, closing tagline

### Icon Directory
`AgenTeam/[Agent]/Icon/`

### Memory Structure
```
AgenTeam/[Agent]/Memory_Logs/
├── README.md
├── Context.md
├── Checkpoint.md
├── Lessons.md
├── Preferences.md
├── Sessions/
├── Notes/
└── Archive/
```

### Knowledge Section
`Library/Knowledge/[Agent]/README.md`

### Agent Skill
`.claude/skills/[agent]/SKILL.md`
- Follow the same 5-step switch protocol as existing agent skills
- Include allowed tools, description

**Output:** All files created.

---

## Phase 5: Register
Update all sync points to acknowledge the new agent:

1. **`Library/Registry.md`** — Add to all 4 sections (registry, routing, chains, boundaries)
2. **`CLAUDE.md`** — Add to Agent Roster table + skills section + project structure
3. **`ANTIGRAVITY.md`** — Add to Agent Roster table
4. **`CODEX.md`** — Add to Agent Roster table
5. **`summon.sh`** — Add agent path + color mapping
6. **`Dashboard/Brief.md`** — Add to Team Status + Recent Activity
7. **All existing agent identity files** — Update boundaries to acknowledge new agent where relevant

**Output:** System-wide registration complete.

---

## Phase 6: Confirm
Present a summary to the user:
- Agent name, role, and personality
- Files created (list all)
- Files modified (list all)
- Routing rules added
- Standard chains defined
- Boundaries set

**Wait for user approval** before finalizing. If the user requests changes, loop back to the appropriate phase.

---

## Allowed Tools
Read, Write, Edit, Glob, Grep, Bash, Agent, WebFetch, WebSearch
