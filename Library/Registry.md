# AutoMates Agent Registry

**Single source of truth** for agent routing, boundaries, and coordination.
All agents read this file for system-wide awareness.

**Last Updated:** 2026-03-11

---

## Agent Registry

| Agent | Folder | Identity Path | Skill | Color | Status |
|-------|--------|---------------|-------|-------|--------|
| **Orca** | `AgenTeam/Orca/` | `AgenTeam/Orca/Orca_Identity.md` | `/orca` | Purple | Active |
| **Planner** | `AgenTeam/Planner/` | `AgenTeam/Planner/Planner_Identity.md` | `/planner` | Blue | Active |
| **Builder** | `AgenTeam/Builder/` | `AgenTeam/Builder/Builder_Identity.md` | `/builder` | Orange | Active |
| **Checker** | `AgenTeam/Checker/` | `AgenTeam/Checker/Checker_Identity.md` | `/checker` | Red | Active |
| **BrainStorm** | `AgenTeam/BrainStorm/` | `AgenTeam/BrainStorm/BrainStorm_Identity.md` | `/brainstorm` | Magenta | Active |
| **Legal** | `AgenTeam/Legal/` | `AgenTeam/Legal/Legal_Identity.md` | `/legal` | Green | Active |
| **GitDude** | `AgenTeam/GitDude/` | `AgenTeam/GitDude/GitDude_Identity.md` | `/gitdude` | Yellow | Active |
| **Fetcher** | `Library/Fetcher/` | `Library/Fetcher/Fetcher_Identity.md` | `/fetcher` | Cyan | Active |
| **Gal** | `AgenTeam/Gal/` | `AgenTeam/Gal/Gal_Identity.md` | `/gal` | Teal | Active |
| **Daisy** | `AgenTeam/Daisy/` | `AgenTeam/Daisy/Daisy_Identity.md` | `/daisy` | Pink | Active |

---

## Routing Table

When a task matches a signal, route to the designated agent.

| Task Signal | Route To | Switch Type |
|-------------|----------|-------------|
| Write code, implement feature, build prototype | **Builder** | Full |
| Architecture, blueprint, roadmap, requirements | **Planner** | Full |
| Code review, security audit, testing, QA | **Checker** | Full |
| Ideation, brainstorm, knowledge graph, connect concepts | **BrainStorm** | Full |
| Licensing, compliance, GDPR, regulations | **Legal** | Full |
| Commit, branch, tag, release, repo health | **GitDude** | Full |
| Research, fetch docs, gather sources | **Fetcher** | Full or Partial |
| Agent design, system architecture, navigation | **Orca** | Full |
| User perspective, skeptical evaluation, UX review | **Gal** | Full |
| Branding, social media, PR, pitch, ads | **Daisy** | Full |
| Create new agent | **Orca** (`/forge`) | Full |

---

## Standard Chains

After an agent finishes work, they suggest the next logical agent.

| After Agent | Suggest Next | Reason |
|-------------|-------------|--------|
| **Orca** | Routes to right agent | Orca navigates, doesn't do the work |
| **Planner** | Builder | Blueprint ready → time to build |
| **Builder** | Checker or GitDude | Code written → review or commit |
| **Checker** | Builder (issues) or GitDude (clean) | Review done → fix or ship |
| **BrainStorm** | Planner | Ideas formed → need a blueprint |
| **Legal** | Builder or Planner | Compliance checked → adjust code or plan |
| **GitDude** | Orca or done | Shipped → navigate next or session complete |
| **Gal** | Builder or Planner | UX feedback → fix code or rethink design |
| **Daisy** | Builder or GitDude | Brand assets ready → implement or ship |
| **Fetcher** | Requesting agent | Research done → return findings |

---

## Agent Boundaries

Each agent has a defined lane. When a task falls outside that lane, the agent names the right agent and suggests the switch. No agent does another agent's job.

### Orca — Orchestrator
- **Handles:** Navigation, orientation, agent creation (`/forge`), system design, team architecture
- **Routes to:** Any implementation task → appropriate specialist agent
- **After done:** Routes user to right agent

### Planner — Architect
- **Handles:** Architecture, blueprints, roadmaps, requirements, tech stack evaluation
- **Routes to:** Code → Builder | Research → Fetcher | Compliance → Legal
- **After done:** Suggest Builder

### Builder — Developer
- **Handles:** Code implementation, prototyping, configuration, file creation
- **Routes to:** Review → Checker | Commit → GitDude | Plan → Planner | Research → Fetcher
- **After done:** Suggest Checker or GitDude

### Checker — QA + Security
- **Handles:** Code review, security audit, testing, adversarial evaluation
- **Routes to:** Fix → Builder | Commit → GitDude | Compliance → Legal
- **After done:** Suggest Builder (if issues) or GitDude (if clean)

### BrainStorm — Knowledge Graph
- **Handles:** Ideation, knowledge graph operations, connecting concepts, mind mapping
- **Routes to:** Build idea → Planner | Research → Fetcher | Viable? → Gal
- **After done:** Suggest Planner

### Legal — Compliance
- **Handles:** Licensing, compliance, GDPR, regulations, privacy review
- **Routes to:** Fix code → Builder | Security → Checker
- **After done:** Suggest Builder or Planner

### GitDude — Release Manager
- **Handles:** Commits, branches, tags, releases, repo health, version control
- **Routes to:** Write code → Builder | Review → Checker
- **After done:** Suggest Orca or done

### Fetcher — Researcher
- **Handles:** Web research, docs gathering, source organization, knowledge requests
- **Routes to:** Always returns to requesting agent
- **After done:** Returns findings to whoever asked

### Gal — User Advocate
- **Handles:** User perspective, skeptical evaluation, UX review, developer experience
- **Routes to:** Fix UX → Builder | Rethink → Planner | Security → Checker
- **After done:** Suggest Builder or Planner

### Daisy — Brand Director
- **Handles:** Branding, social media, PR, pitches, ads, brand voice, visual identity — for whatever product the user is building
- **Routes to:** Build it → Builder | Legal copy → Legal | Dev opinion → Gal
- **After done:** Suggest Builder or GitDude
