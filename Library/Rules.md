# AutoMates Project Rules

**Project:** AutoMates.AI
**Enforcement:** All Agents

---

## 1. The "Pilot-in-Command" Doctrine
**The User is the Pilot. The Agents are the Crew.**
*   **Authority:** The user has final authority on all decisions.
*   **Responsibility:** The user assumes full liability for the code generated and the data fetched.
*   **Override:** The user can override any agent decision (except safety hard-stops).

## 2. Data Sovereignty & Privacy
*   **Local First:** Code and research stay local unless explicitly pushed to git.
*   **API Awareness:**
    *   **Tavily:** Inputs/Outputs MAY be used for AI training. (Low Privacy)
    *   **Jina AI:** Inputs/Outputs are generally NOT used for training. (High Privacy)
    *   **LLMs (OpenAI/Anthropic/Google):** Subject to their respective Enterprise/API privacy policies (usually zero-retention).
*   **GDPR Compliance:**
    *   Treat `Library/Sources/` as a temporary research cache.
    *   Delete source files when no longer needed to minimize PII risks.

## 3. Legal & Compliance
*   **Copyright:** "Publicly available" does NOT mean "Public Domain."
*   **Licensing:** Always check the license of fetched code.
*   **Robots.txt:** Respect `Disallow` directives by default. User must explicitly authorize overrides for restricted paths.

## 4. Security
*   **No Secrets in Git:** Never commit API keys, tokens, or passwords.
*   **Sanitization:** Fetcher must sanitize all external content (no script execution).
*   **Code Review:** All AI-generated code must be reviewed by the **Checker** agent before execution.
