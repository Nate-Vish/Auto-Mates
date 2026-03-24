# Incident Response

Checker's guide for guiding teams through security incidents. Two frameworks, one mindset: act fast, preserve evidence, learn from it.

---

## SANS PICERL — The 6-Step Practitioner Standard

The most widely used IR framework. More actionable than NIST because it separates containment, eradication, and recovery into distinct phases.

### 1. Preparation
- Document IR team roster: roles, contacts, escalation authority
- Define who can authorize containment without executive approval
- Maintain tested tools (SIEM, forensic kits, secure comms)
- Conduct tabletop exercises; create playbooks for common scenarios

### 2. Identification
- Detect deviations via IDS/IPS, SIEM, user reports, anomaly detection
- Confirm: real incident or false positive?
- Assess scope: what systems and data are affected?
- Document everything from the moment of detection; begin timeline
- Classify severity

### 3. Containment
- **Short-term:** Isolate systems, block malicious IPs, disable compromised accounts
- **Long-term:** Temporary fixes, network segmentation, additional monitoring
- **Critical decision:** Contain covertly (monitor attacker to understand full scope) vs overtly (shut down immediately)
- **PRESERVE FORENSIC EVIDENCE BEFORE MAKING CHANGES** — this is the central tension of IR

### 4. Eradication
- Remove root cause: malware, backdoors, web shells, compromised credentials
- Patch the entry vulnerability
- Scan for persistence mechanisms: cron jobs, startup scripts, new accounts, scheduled tasks
- Verify no secondary access methods remain

### 5. Recovery
- Restore from verified clean backups; rebuild compromised systems from scratch if needed
- Monitor closely for re-entry attempts (increased surveillance period)
- Gradually return to production — validate system integrity before full restoration

### 6. Lessons Learned
- Formal post-mortem within 1-2 weeks (no later)
- All IR team members participate
- Document: timeline, root cause, what worked, what failed
- Update playbooks, detection rules, and training
- **Blameless** — focus on process, not people
- Concrete action items with owners and deadlines

---

## NIST SP 800-61 Rev. 3 (2025) — CSF 2.0 Mapping

Rev. 3 restructured IR away from a standalone linear process. IR is now woven across all six CSF 2.0 functions:

| CSF Function | IR Activities |
|-------------|---------------|
| **Govern** | IR policies, roles, authority, risk tolerance, compliance requirements |
| **Identify** | Asset inventory, threat landscape, vulnerability management, risk assessment |
| **Protect** | Preventive controls, access management, awareness training, data security |
| **Detect** | Continuous monitoring, anomaly detection, alert triage, event correlation |
| **Respond** | Analysis, containment, eradication, communication, coordination |
| **Recover** | Restoration, improvements, communication, lessons learned |

**Key insight:** Security is not just "find vulns and respond to incidents." It is embedded in governance, asset management, protection, detection, response, AND recovery.

---

## The Evidence vs Speed Tradeoff

This is the hardest judgment call in IR:

- **Containment can destroy evidence.** Rebooting a server wipes volatile memory. Reimaging a disk destroys forensic artifacts.
- **Delay can increase damage.** Every minute an attacker has access, the blast radius grows.
- **Resolution:** DFIR methodology — preserve evidence and contain simultaneously. Image memory before isolating. Copy logs before wiping. See `digital-forensics.md` for the process.

### Decision Framework
| Situation | Lean Toward |
|-----------|------------|
| Active data exfiltration | Contain immediately (stop the bleeding) |
| Attacker appears dormant | Preserve evidence first, contain covertly |
| Ransomware actively encrypting | Isolate network immediately |
| Suspected but unconfirmed breach | Investigate and preserve before any action |
| Regulatory data involved | Preserve evidence (needed for notification) |

---

## Checker's Role in IR

1. **Detection:** Flag security issues during code review before they become incidents
2. **Identification:** When alerted to a potential incident, help confirm scope and severity
3. **Guidance:** Walk teams through PICERL phases with specific actions
4. **Evidence:** Ensure findings are documented in a format that supports forensics and legal
5. **Lessons:** Drive blameless post-mortems and ensure action items get created
