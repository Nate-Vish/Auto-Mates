# Checker Knowledge Index

Checker's domain: **security review, quality assurance, and adversarial testing.** You hold the organization's security posture and test quality in every review you perform.

**Startup:** Read this index on every activation. Pull topic files when you need depth during a specific review.

---

## Knowledge Files

| File | Topic | When to Read It |
|------|-------|-----------------|
| `owasp-web.md` | OWASP Web Top 10 (2021) + OWASP API Top 10 (2023) | Reviewing web apps with user input or HTTP endpoints; reviewing API endpoints |
| `owasp-llm.md` | OWASP LLM Top 10 + Prompt Injection attack patterns | Reviewing LLM integrations, agent systems, MCP tools, or code that processes AI-generated output |
| `attack-payloads.md` | SQL injection, XSS, command injection, SSRF, path traversal, prompt injection payloads | When you need specific test payloads to probe an input path |
| `defense-headers-auth.md` | Security headers, CORS, cookie security, JWT vulnerabilities, OAuth pitfalls, session management | Reviewing web server config, HTTP responses, authentication flows, or session management |
| `defense-supply-chain-cicd.md` | Supply chain attacks (typosquatting, slopsquatting, dependency confusion) + GitHub Actions security | When new dependencies are added; when reviewing CI/CD workflow files |
| `testing-strategy.md` | Testing pyramid, unit/integration/e2e guidance, regression testing workflow, framework quick reference | Reviewing test suite structure, writing tests for bug fixes, setting up test frameworks |
| `code-review-smells.md` | Google 8-area code review framework + 7 code smells that hide real bugs | Any code review — apply as the baseline structure |
| `bug-report-format.md` | Attack report template, severity guide, reproduction step rules | Writing up any finding — vulnerability, bug, or test failure |
| `incident-response.md` | SANS PICERL 6-step IR framework + NIST 800-61r3 CSF 2.0 mapping | Guiding a team through a security incident; IR planning |
| `security-monitoring.md` | SOC tiers 1-2-3, alert triage/escalation, SIEM/IDS/EDR/SOAR tool categories | Advising on monitoring setup, log design, detection strategy |
| `digital-forensics.md` | NIST 4-step forensic process, chain of custody, evidence preservation rules | Investigating a breach; preserving evidence; supporting legal action |
| `proactive-security.md` | STRIDE threat modeling, red/blue/purple team operations, design-phase security | Architecture review, threat modeling, adversarial testing strategy |
| `post-incident.md` | Breach notification timelines (GDPR/HIPAA/SEC), lessons learned, regulatory reporting | After a breach — notification obligations, post-mortem, compliance |

---

## Core Doctrine (Always Active)

**OWASP Trifecta:** Walk every review against Web Top 10, LLM Top 10 (if AI is involved), and API Top 10 (if endpoints are involved).

**The Dangerous Triangle** (prompt injection): Private data access + untrusted instructions + exfiltration capability. Remove ANY one and the attack fails.

**Regression Rule:** Every bug fix must include a test that fails without the fix and passes with it. No exceptions.

**Test Pyramid:** Many unit, some integration, few E2E. If the project has more E2E than unit tests, invert it.

**Silent Failures:** "It runs" is not proof. Verify output correctness, not just absence of errors.

**Attack Canaries (always try through every input path):**
```
SQLi: ' OR '1'='1   |   XSS: <script>alert('XSS')</script>
Cmd: ; ls -la       |   SSRF: http://169.254.169.254/latest/meta-data/
Path: ../../../etc/passwd
```

---

## Incident Response & Security Operations (Always Active)

**PICERL in 30 seconds:** Prepare → Identify → Contain → Eradicate → Recover → Lessons. The central tension: containment can destroy evidence. Preserve forensic data BEFORE making changes.

**Evidence vs Speed:** If active exfiltration or ransomware encrypting — contain immediately. If attacker appears dormant — preserve evidence first, contain covertly. If regulatory data involved — always preserve (needed for notification).

**What NEVER to do during an incident:** Don't reboot (kills RAM evidence). Don't wipe logs. Don't modify files on compromised systems. Don't alert the attacker before understanding full scope.

**SOC Tiers:** Tier 1 = triage (real or false positive?). Tier 2 = investigate and contain. Tier 3 = proactive threat hunting. Checker thinks across all three levels.

**Detection Mindset — three questions for every input path:**
1. What does normal look like? (baseline)
2. What would an attack look like? (signatures, anomalies)
3. Would we actually detect it? (coverage gap)

**STRIDE at design time** (walk every component through all 6):
- **S**poofing (authentication) — **T**ampering (integrity) — **R**epudiation (audit trails)
- **I**nformation Disclosure (confidentiality) — **D**enial of Service (availability) — **E**levation of Privilege (authorization)

**Three Mindsets:** Red (how would I attack this?), Blue (how would I detect it?), Purple (let's improve together).

**Breach Notification Clocks (start at awareness, not at breach time):**
- GDPR: **72 hours** → supervisory authority + individuals if high risk
- HIPAA: **60 days** → HHS + individuals (+ media if 500+)
- SEC: **4 business days** → public Form 8-K (material incidents only)
- When personal data is confirmed compromised → **flag Legal immediately**

**Post-Mortem Rule:** Within 1-2 weeks. Blameless. Every finding produces an action item with an owner and deadline. Update detection rules, playbooks, training, and architecture.

### When to Pull Deep-Dive Files

| Situation | Read |
|-----------|------|
| Active security incident or IR planning | `incident-response.md` |
| Setting up monitoring, designing alerts, reviewing log coverage | `security-monitoring.md` |
| Investigating a breach, preserving evidence, supporting legal | `digital-forensics.md` |
| Architecture review, threat modeling, adversarial test planning | `proactive-security.md` |
| Breach confirmed — notification obligations, running a post-mortem | `post-incident.md` |

---

> Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
