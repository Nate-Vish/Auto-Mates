# AutoMates.AI 👾

**Your AI Engineering Team in a Box.**

> *"We believe everyone's imagination deserves to become their creation."*

---

## 🚀 Quick Start

### 1. Clone & Open
```bash
git clone https://github.com/Nate-Vish/Auto-Mates.git
cd Auto-Mates
```
Open the folder in Claude Code.

### 2. Describe Your Project
Edit `Dashboard/Project_Description.md` with your vision.
Edit `Library/Rules.md` with any constraints (tech stack, style, etc.).

### 3. Summon an Agent
```
/summon brainstorm
```
A color-coded terminal opens. The agent reads its identity, memory, and dashboard. Ready to rumble.

### 4. Run Multiple Agents
```
/summon builder,checker       # Launch two agents
/summon team                  # Launch Planner + Builder + Checker
/summon all                   # Launch all 9
```
Each agent gets its own terminal. They collaborate through files in `Dashboard/Work_Space/`.

### 5. Switch Agents In-Session
```
/handoff checker              # Save context, become Checker
/brief                        # See project state and team status
/memorize                     # Save agent memory + update dashboard
```

---

**💡 Tip:** Use Fetcher to collect educational material for the agents. Let them read it before they start working on a task (they'll find it in Library, don't worry).

**💡 Hint:** Every agent can create a file for other agents to read and work by.

**📖 Example:** Fetcher can read a Blueprint that Planner made, go fetch some sources and create `Builder_Study.md`, then Builder learns like a pro and starts writing some fine code.

**🧠 Try this:** Got a quick idea while working? Just tell BrainStorm `💡 IDEA: [your idea]` — he'll log it instantly and keep working. No flow disruption, ideas never lost.

---

## ⚙️ How It Works

### 👥 The Team (9 Agents)

| Agent | Role | What They Do |
|-------|------|--------------|
| 🧠 **BrainStorm** | Ideator | Explores ideas, solves creative blocks |
| 📐 **Planner** | Architect | Creates technical blueprints |
| 🔨 **Builder** | Engineer | Writes code following blueprints |
| 🕵️ **Checker** | Auditor | Reviews for bugs, security, quality |
| ⚖️ **Legal** | Compliance | Checks licenses, privacy, governance |
| 📦 **GitDude** | Release Manager | Version control, security scanning |
| 📚 **Fetcher** | Librarian | Gathers knowledge, organizes sources |
| 🎼 **Orca** | Orchestrator | Modifies agents, creates new ones, manages team structure |
| 🧑‍💻 **Gal** | User Advocate | Skeptical senior dev persona, evaluates from user perspective |

### 📂 The Three Zones

```
AutoMates/
├── AgenTeam/                    # Where agents live
│   ├── BrainStorm/
│   ├── Planner/
│   ├── Builder/
│   ├── Checker/
│   ├── Gal/
│   ├── Legal/
│   ├── GitDude/
│   └── Orca/
│
├── Library/                   # Where information is stored
│   ├── Fetcher/              # He lives here near his Sources
│   ├── Rules.md              # Project constraints
│   └── Sources/              # Organized knowledge base
│
└── Dashboard/                 # Where agents work together
    ├── Project_Description.md
    ├── Brief.md              # Project state + team status
    ├── Work_Space/           # The fun happens here
    └── Version_Control/
```

**AgenTeam/** — Where the agents live, including their identity and memory.

**Library/** — Where information is stored and organized by Fetcher (he lives there near his Sources).

**Dashboard/** — The place where all agents work together on your tasks and manage the versions for you (the fun happens there).

### 🧠 Agent Memory

Each agent remembers past sessions at `AgenTeam/[Name]/Memory_Logs/`:
- `Lessons.md` — Patterns that worked, mistakes to avoid
- `Preferences.md` — How you like things done
- `Sessions/` — Conversation history
- `Checkpoint.md` — Save/resume complex tasks

### 📋 Agent Wake-Up Protocol

When an agent starts a session, they follow a 3-step protocol:

```
Step 1: Read My Memory
  → Sessions, Notes, Lessons, Preferences, Checkpoint

Step 2: Read the Dashboard
  → Project_Description.md  (vision & structure)
  → Rules.md               (principles & constraints)
  → Brief.md               (project state, team status, recent activity)

Step 3: Prepare for Work
  → Library/Sources/ as needed
  → If not enough sources: create a Knowledge Request in Work_Space for Fetcher
```

This ensures every agent wakes up with full context — your project vision, current priorities, and what other agents have been doing. If they need more knowledge, they leave a request for Fetcher instead of working blind.

---

## 🔮 Roadmap

**Current (v1.3):**
- 9 specialized agents with persistent memory
- CLAUDE.md shared context (auto-loaded every session)
- 9 slash commands (`/summon`, `/handoff`, `/brief`, `/memorize`, `/compact`, `/summon-team-build`, `/summon-team-research`, `/summon-team-review`, `/watch-summary`)
- Agent Teams for parallel work
- Library/Knowledge/ per-agent curated reading lists
- Brief.md for project-wide synchronization

**Coming:**
- Orchestrator Automation (Orca managing workflows automatically)
- Agent Factory (generate specialized teams)
- CLI Package (`automates` command)

---

## ⚖️ Legal, License & Links

### 🛡️ You Are the Pilot-in-Command

- **Your Responsibility:** You control what agents do. You are responsible for URLs fetched and code generated.
- **Third-Party Tools:** AutoMates uses `r.jina.ai` as a free utility. Users engaging in high-volume or commercial use are responsible for obtaining their own API key to comply with Jina AI's terms.
- **AI Disclaimer:** AI-generated content can contain errors. Always review and test all output.
- **Copyright:** Respect intellectual property when using Fetcher.

### 🔒 Privacy

- **Third-Party APIs:** Prompts are sent to AI providers (Anthropic, OpenAI, Google). See their privacy policies.
- **Local Storage:** AutoMates works locally. We do not store your code or data.
- **No Telemetry:** Everything stays on your machine.

### 🐋 Docker Recommended

We recommend running each project in its own Docker container for isolation and safety.

### 📄 License

MIT License © 2026 AutoMates.AI — See [LICENSE](LICENSE)

### 🔗 Links

- [GitHub Repository](https://github.com/Nate-Vish/Auto-Mates) — Source & releases
