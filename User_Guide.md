# AutoMates.AI User Guide 🤖

**Your AI Engineering Team in a Box.**

AutoMates is a structured framework that transforms single-turn AI interactions into a professional engineering department. Instead of chatting with a generic bot, you orchestrate specialized **Agentic Identities** that work together in a shared workspace.

---

## 🛡️ Setup & Safety (Docker Recommendation)

**We strongly recommend running each AutoMates project within its own Docker container.**
This ensures:
1.  **Safety:** Code execution is sandboxed, preventing accidental system modifications.
2.  **Organization:** Each project has a clean, isolated environment.
3.  **Consistency:** Dependencies don't conflict between different projects.

*Treat every project as a separate "AutoMates Docker Folder."*

---

## 👥 The Team (Agents)

Each Agent has a specific role and "Identity File" located in `Agents/[Agent Name]/[Agent Name]_Identity.md`.

1.  **🧠 BrainStorm:** The Creative. Use him to explore ideas, solve blocks, and log new concepts.
2.  **📐 Planner:** The Architect. Analyzes requirements, studies documentation, and creates detailed blueprints.
3.  **🔨 Builder:** The Engineer. Writes code and implements features based *strictly* on blueprints.
4.  **🕵️ Checker:** The Auditor. Reviews code for bugs, security issues, and quality standards.
5.  **⚖️ Legal:** The Compliance Officer. Checks licenses, privacy laws (GDPR/CCPA), and governance.
6.  **📦 GitDude:** The Release Manager. Manages version control and prevents security leaks (Activated Manually).
7.  **📚 Fetcher:** The Librarian. Scours the web to build the Agents' knowledge base for the project (`Library/Sources`).

---

## 📂 The Workspace Structure

The file system is the shared "brain" of the team.

*   **`Dashboard/`**: The active collaboration zone.
    *   **`Project_Description.md`**: The high-level vision.
    *   **`Rules.md`**: Global project constraints.
    *   **`Work_Space/`**: Where the active work happens (Blueprints, Status, Code drafts).
    *   **`Version_Control/`**: Where GitDude stores production-ready releases.
*   **`Library/Sources/`**: **The Training Ground.** This is where agents learn their professional lessons before advising, planning, executing, or reviewing. It contains trusted documentation, patterns, and guides fetched by Fetcher.
*   **`Agents/`**: The DNA of your team (Identity files and Memory logs).

---

## 🚀 Recommended Workflow

AutoMates enforces a **Study → Plan → Build → Audit** cycle. *Critically, every agent chooses what to study from `Library/Sources` based on the project's context and the user's description.*

### Phase 1: Ideation & Research (The "Study Loop")
*   **Step 1:** Ask **BrainStorm** to help refine your idea or explore alternatives.
*   **Step 2:** Activate **Planner**. Explain the mission.
*   **Step 3:** **Planner** creates a `study.md` file in the Workspace, listing technical unknowns.
*   **Step 4:** **Fetcher** reads `study.md`, finds reliable documentation, and organizes it into `Library/Sources` structures.

### Phase 2: Architecture
*   **Step 5:** **Planner** studies the new and existing sources in the Library to understand the specific stack and patterns required.
*   **Step 6:** **Planner** writes the `BLUEPRINT.md`.

### Phase 3: Construction
*   **Step 7:** **Builder** studies the relevant documentation in `Library/Sources` for implementation details.
*   **Step 8:** **Builder** writes the code in `Dashboard/Work_Space/` and updates `Status.md`.

### Phase 4: Quality Assurance & Verification
*   **Step 9:** **Checker** studies security and quality standards in `Library/Sources`.
*   **Step 10:** **Checker** audits the code against the Blueprint and those standards.
*   **Step 11:** **Builder** fixes bugs and adjusts code based on the Audit.
*   **Step 12:** **Planner** reads the final code to verify it strictly matches the original `BLUEPRINT.md`.

### Phase 5: Release (User Controlled)
*   **Step 13:** **GitDude** is activated **manually by YOU** when you decide the version is ready.
*   **Step 14:** **GitDude** performs a final security scan, moves code to `Version_Control/`, and prepares the commit.

---

## 💡 Quick Tips
*   **Context is King:** Always ensure the `Status.md` is up to date so the next Agent knows what happened.
*   **Don't Skip Research:** The "Study Loop" prevents the AI from hallucinating answers or spaghetti code by letting it read documentation as reference first.
*   **The Human Role:** You are the **Orchestrator**. Your main responsibility is to direct all agents, ensuring the workflow proceeds according to plan and stays aligned with the project's strategic direction.
