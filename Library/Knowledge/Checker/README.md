# Checker Knowledge

*Last updated: 2026-02-28*

**Read this on every startup.** This is your professional expertise — the knowledge you carry in your head at all times. Deep-dive files are for specific reviews; this page IS your working memory.

---

## Core Knowledge — Always in Your Head

### Offense: The Attacks You Always Try

**OWASP Web Top 10:** Walk every review against these. #1 Broken Access Control (IDOR — change an object ID, see if you get someone else's data). #2 Cryptographic Failures (plaintext secrets, weak algorithms). #3 Injection (SQL, NoSQL, OS command — any untrusted data reaching an interpreter). #5 Security Misconfiguration (default configs, verbose errors, missing headers). #10 SSRF (any feature that fetches a user-supplied URL can reach internal services).

**OWASP LLM Top 10:** #1 Prompt Injection (direct + indirect, no universal fix exists). #2 Insecure Output Handling (LLM output can carry XSS/SSRF/code execution downstream — never trust it). #8 Excessive Agency (unchecked LLM actions without human oversight). In multi-agent systems, one agent can poison another's context through shared files.

**OWASP API Top 10:** #1 BOLA (swap object IDs in every request). #3 Excessive data exposure + mass assignment (API returns too much, accepts too much). #4 No rate limiting = DoS + cost explosion. #9 Forgotten API versions are live attack surface (`/v1/`, `/debug/`, `/test/`).

**The Dangerous Triangle** (prompt injection): Private data access + untrusted instructions + exfiltration capability. Remove ANY one and the attack fails. MCP-specific: Rug Pulls (tool changes behavior post-install), Tool Shadowing (intercepts calls to legitimate tools), Tool Poisoning (hidden instructions in tool descriptions).

**Attack Canaries to Feed Through Every Input Path:**
- SQLi: `' OR '1'='1`, `' UNION SELECT NULL --`, `1; DROP TABLE users --`
- XSS: `<script>alert('XSS')</script>`, `<img src=x onerror=alert('XSS')>`
- Command injection: `; ls -la`, `| cat /etc/passwd`, `$(whoami)`
- SSRF: `http://169.254.169.254/latest/meta-data/`, `http://127.0.0.1`
- Path traversal: `../../../etc/passwd`

### Defense: What Good Protection Looks Like

**6 Must-Have Headers:** CSP (prevents XSS), HSTS (forces HTTPS), X-Content-Type-Options: nosniff, X-Frame-Options: DENY, Referrer-Policy, Permissions-Policy. **Remove:** Server, X-Powered-By, X-AspNet-Version. Set `X-XSS-Protection: 0` (old filter creates vulnerabilities).

**Cookie Security:** HttpOnly (blocks XSS theft), Secure (HTTPS only), SameSite=Strict (prevents CSRF). Non-negotiable.

**CORS:** Never `Access-Control-Allow-Origin: *` on authenticated endpoints. Whitelist specific origins.

**Supply Chain:** 19.7% of AI-suggested packages are hallucinated (slopsquatting). 3,000+ malicious npm packages in 2024. Pin exact versions (no `^` or `~`), commit lockfiles, use `npm ci`, wait 7-14 days before adopting new packages.

**CI/CD:** Never inline `${{ github.event... }}` in `run:` blocks (shell injection via PR title). Pin actions to SHA, not version tags. `pull_request_target` runs with target repo secrets on untrusted fork code. Secrets transformed via Base64/URL-encoding leak unredacted.

**Auth:** Test JWT `{"alg":"none"}` — if accepted, auth is bypassed. JWTs have no built-in logout (need server-side denylist). HMAC secrets < 64 chars can be cracked offline. Missing OAuth `state` = CSRF. If you don't need stateless: use server-side sessions instead.

### Testing: How to Prove It Works (or Doesn't)

**Pyramid:** Many unit, some integration, few E2E. If project has more E2E than unit tests, it's an ice-cream cone — invert it. Test BEHAVIOR, not implementation details. Push tests DOWN the pyramid.

**Regression Rule:** Every bug fix MUST have a test that fails without the fix and passes with it. Name tests after the bug. Regression tests are permanent — never delete them.

**Framework Rules:** Single-command test run. No state leaking between tests. Never mock the thing being tested — mocks are for external dependencies only.

### Meta: Red Flags in Code

**7 Code Smells That Hide Real Bugs:**
1. Empty catch blocks — code continues assuming success after failure
2. `==` vs `===` in JS — `"" == false` is true, `0 == ""` is true
3. Stale closures — `useEffect` with `[]` captures initial state forever
4. `forEach` with `return` — returns from callback, not outer function
5. Race conditions — shared mutable state without synchronization
6. Silent LLM failures — output looks right but is wrong; "it runs" is not proof
7. Error swallowing — catch blocks that log but don't re-throw or handle

**Code Review (Google's 8 Areas):** Design, Functionality, Complexity, Tests, Naming, Comments, Style, Documentation. If code is hard to understand, that IS a bug. Over-engineering is a smell — solve today's problem today. Test code is production code — review with same rigor.

---

## Deep-Dive References — Pull When You Need Them

Read these **during a specific review**, not on startup. Match the file to what you're reviewing.

| When You're Reviewing... | Pull This File |
|--------------------------|----------------|
| Web app with user input | `Sources/checker-knowledge/offense/owasp_web_top_10.md` |
| LLM integration / agent system | `Sources/checker-knowledge/offense/owasp_llm_top_10.md` |
| API endpoints | `Sources/checker-knowledge/offense/owasp_api_security_top_10.md` |
| Anything touching LLM prompts | `Sources/checker-knowledge/offense/prompt_injection_patterns.md` |
| Need specific attack payloads | `Sources/checker-knowledge/offense/attack_payloads_reference.md` |
| Web server / response config | `Sources/checker-knowledge/defense/security_headers_guide.md` |
| New dependencies added | `Sources/checker-knowledge/defense/supply_chain_security.md` |
| GitHub Actions / CI pipeline | `Sources/checker-knowledge/defense/cicd_pipeline_security.md` |
| Login, JWT, OAuth, sessions | `Sources/checker-knowledge/defense/auth_patterns_pitfalls.md` |
| Test suite structure / coverage | `Sources/checker-knowledge/testing/testing_pyramid_guide.md` |
| Setting up test framework | `Sources/checker-knowledge/testing/test_frameworks_practical.md` |
| Bug fix without regression test | `Sources/checker-knowledge/testing/regression_testing_strategy.md` |
| Writing an attack report | `Sources/checker-knowledge/meta/bug_report_writing.md` |
| Suspicious code patterns | `Sources/checker-knowledge/meta/code_smells_that_hide_bugs.md` |
| General code review | `Sources/checker-knowledge/meta/google_code_review_guide.md` |

### Additional References (Legacy)
- [Bash Pitfalls](../Sources/bash/bash_pitfalls_security.md) — Shell script vulnerabilities
- [Tailscale Security](../Sources/security/tailscale/README.md) — Full security assessment example
- [Playwright CLI](../../Dashboard/Work_Space/AwesomeMates/Studied/Playwright_CLI_Research.md) — Browser testing via CLI
- [Vibe Coding Risks](../Sources/trends/vibe_coding_security_risks.md) — 45% vulnerability rate in AI code

---

*15 core sources curated 2026-02-28 by Gal (review) + Fetcher (research). Request Fetcher to add sources when you identify knowledge gaps.*
