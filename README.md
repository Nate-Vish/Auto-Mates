# AutoMates.AI 👾

**Your AI Engineering Team in a Box.**

> *"We believe everyone's imagination deserves to become their creation."*

---

## 🚀 Quick Start

### 1. Describe Your Project
Edit `Dashboard/Project_Description.md` with your vision.

### 2. Set Your Rules
Edit `Dashboard/Rules.md` with any constraints (tech stack, style, etc.).

### 3. Activate an Agent

1. Open a terminal in the AutoMates folder
2. Activate an AI model (Claude Code, Gemini CLI, your local model, etc.)
3. Type `you are [Agent_Name]:` + drag the wanted identity file to terminal + Enter
4. Agent pops up after reading his identity, his memory, and the dashboard. Ready to rumble.

```
you are BrainStorm: [drag Agents/BrainStorm/BrainStorm_Identity.md here]
```

### 4. Run Multiple Agents
Open a few terminals, activate agents in each one. They collaborate through files in `Dashboard/Work_Space/`.

---

**💡 Tip:** Use Fetcher to collect educational material for the agents. Let them read it before they start working on a task (they'll find it in Library, don't worry).

**💡 Hint:** Every agent can create a file for other agents to read and work by.

**📖 Example:** Fetcher can read a Blueprint that Planner made, go fetch some sources and create `Builder_Study.md`, then Builder learns like a pro and starts writing some fine code.

**🧠 Try this:** Got a quick idea while working? Just tell BrainStorm `💡 IDEA: [your idea]` — he'll log it instantly and keep working. No flow disruption, ideas never lost.

---

## ⚙️ How It Works

### 👥 The Team (8 Agents)

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

### 📂 The Three Zones

```
AutoMates/
├── Agents/                    # Where agents live
│   ├── BrainStorm/
│   ├── Planner/
│   ├── Builder/
│   ├── Checker/
│   ├── Legal/
│   ├── GitDude/
│   └── Orca/
│
├── Library/                   # Where information is stored
│   ├── Fetcher/              # He lives here near his Sources
│   └── Sources/              # Organized knowledge base
│
└── Dashboard/                 # Where agents work together
    ├── Project_Description.md
    ├── Rules.md
    ├── Work_Space/           # The fun happens here
    └── Version_Control/
```

**Agents/** — Where the agents live, including their identity and memory.

**Library/** — Where information is stored and organized by Fetcher (he lives there near his Sources).

**Dashboard/** — The place where all agents work together on your tasks and manage the versions for you (the fun happens there).

### 🧠 Agent Memory

Each agent remembers past sessions at `Agents/[Name]/Memory_Logs/`:
- `Lessons.md` — Patterns that worked, mistakes to avoid
- `Preferences.md` — How you like things done
- `Sessions/` — Conversation history
- `Checkpoint.md` — Save/resume complex tasks

---

## 🔮 Roadmap

**Current (v1.x):**
- 8 specialized agents with persistent memory
- LEARN FIRST protocol with Study Files
- File-based coordination via Work_Space
- Orca for team customization and new agent creation

**Coming (v2.0+):**
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

- [CONTRIBUTING.md](CONTRIBUTING.md) — How to contribute
- [TRADEMARK.md](TRADEMARK.md) — Brand guidelines
