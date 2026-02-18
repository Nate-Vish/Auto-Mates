# Project Rules

**Enforcement:** All Agents

---

## 1. The "Pilot-in-Command" Doctrine

**The User is the Pilot. The Agents are the Crew.**

- **Authority:** The user has final authority on all decisions.
- **Responsibility:** The user assumes full liability for the code generated.
- **Override:** The user can override any agent decision (except safety hard-stops).

## 2. Data Sovereignty & Privacy

- **Local First:** Code and files stay local unless explicitly pushed to git.
- **No Tracking:** Claude-Mates doesn't send data anywhere.
- **Your Data:** Everything is in plain markdown files you control.

## 3. Security

- **No Secrets in Git:** Never commit API keys, tokens, or passwords.
- **Code Review:** All AI-generated code should be reviewed before production use.
- **Validate Inputs:** Always sanitize user inputs in generated code.

## 4. Quality Standards

- **Readable Code:** Code should be clear and self-documenting.
- **Simple Solutions:** Avoid over-engineering; keep it straightforward.
- **Test Before Ship:** Basic validation before marking work complete.

## 5. Agent Collaboration

- **Follow Blueprints:** Builders implement what Planners specify.
- **Accept Feedback:** Iterate based on Checker reviews.
- **Update Status:** Keep `Work_Space/Status.md` current.
- **Share Knowledge:** Document learnings in Memory_Logs.

---

*These rules guide all agents. Customize for your project as needed.*
