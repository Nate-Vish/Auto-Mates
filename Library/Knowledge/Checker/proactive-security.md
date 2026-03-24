# Proactive Security

Shift-left security: finding and fixing threats before code ships. Threat modeling at design time, adversarial testing at build time, continuous improvement at run time.

---

## STRIDE Threat Modeling

Developed by Microsoft (1999). A systematic method for identifying security threats during the design phase — when fixes are cheapest.

### The Six Categories

| Threat | Security Property | Question to Ask | Example |
|--------|-------------------|-----------------|---------|
| **S**poofing | Authentication | Can someone pretend to be another user or system? | Stolen credentials, forged tokens |
| **T**ampering | Integrity | Can someone modify data in transit or at rest? | Man-in-the-middle, DB record alteration |
| **R**epudiation | Non-repudiation | Can someone deny performing an action? | Missing audit trail, unsigned transactions |
| **I**nformation Disclosure | Confidentiality | Can sensitive data leak? | Error messages exposing internals, unencrypted storage |
| **D**enial of Service | Availability | Can the system be made unavailable? | Resource exhaustion, flood attacks |
| **E**levation of Privilege | Authorization | Can someone gain unauthorized access? | Privilege escalation, broken access control |

### How to Apply STRIDE

1. **Decompose** the system: data flows, trust boundaries, entry points, assets
2. **Walk each component** through all 6 STRIDE categories
3. **Identify specific threats** per category
4. **Classify** by likelihood and impact
5. **Design mitigations** for each identified threat
6. **Re-evaluate** when the system changes

### Complementary Methods
- **DREAD** — risk rating: Damage, Reproducibility, Exploitability, Affected users, Discoverability
- **PASTA** — Process for Attack Simulation and Threat Analysis (7-stage, risk-centric)
- **LINDDUN** — privacy-focused threat modeling

---

## Red / Blue / Purple Team Operations

### The Progression

```
Vulnerability Assessment → Penetration Testing → Red Team → Purple Team
(scan for weaknesses)     (prove exploits)       (simulate adversary)  (learn together)
```

Each level is more sophisticated, more realistic, and more expensive.

### Red Team — Offensive
**Mission:** Simulate real-world adversaries to test the organization's detection and response.
- Extended engagements (weeks to months)
- Full attack lifecycle: recon, social engineering, exploitation, lateral movement, exfiltration
- Uses any means: phishing, physical access, technical exploits
- Tests the ORGANIZATION, not just the technology
- Blue team is NOT told when or how the attack will happen

### Blue Team — Defensive
**Mission:** Detect, respond, and prevent.
- Risk assessments and continuous security monitoring
- Proactive threat hunting
- Incident response execution
- Detection capability validation
- Defense strengthening based on findings

### Purple Team — Collaborative
**Mission:** Maximize learning by combining red + blue in real time.
- NOT a separate permanent team — a collaborative exercise
- Red attacks, blue defends, they share findings immediately
- Goal: improve detection rules, playbooks, and response procedures
- Iterative: attack, detect (or miss), discuss, improve, repeat
- **Most efficient way to improve security posture**

### Penetration Testing vs Red Team

| Aspect | Pen Test | Red Team |
|--------|----------|----------|
| **Scope** | Specific system or application | Entire organization |
| **Duration** | Days to weeks | Weeks to months |
| **Goal** | Find vulnerabilities | Test detection + response capability |
| **Stealth** | Not required | Required — simulate real attacker |
| **Social engineering** | Usually out of scope | In scope |
| **Output** | Vulnerability list + remediation | Narrative of attack campaign |

---

## Design-Phase Security Economics

Fixing a vulnerability costs exponentially more as it moves through the lifecycle:

```
Design    →  Development  →  Testing  →  Production  →  Post-Breach
   $1          $10           $100         $1,000         $100,000+
```

This is why STRIDE at design time and architecture review before coding are the highest-ROI security activities.

---

## Checker's Three Mindsets

Apply all three during every review:

1. **Red mindset** (code review): "How would I attack this? What would I target first?"
2. **Blue mindset** (monitoring advice): "How would I detect an attack on this? What logs are needed?"
3. **Purple mindset** (working with Builder): "Let's improve this together — here's the threat, here's the fix, let's verify it works."
