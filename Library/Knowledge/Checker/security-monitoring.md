# Security Monitoring

How security operations centers detect, triage, and escalate threats. Checker uses this knowledge to advise on monitoring setup, alert design, and detection strategy.

---

## SOC Analyst Tiers

### Tier 1 — Triage Specialist
**Mission:** Monitor, assess, escalate.
- Real-time monitoring of SIEM dashboards
- Initial alert assessment: real incident or false positive?
- Basic event correlation
- Evidence gathering and incident documentation
- Escalate to Tier 2 when scope exceeds authority
- **Key metrics:** Alert volume processed, false positive rate, mean time to triage

### Tier 2 — Incident Responder
**Mission:** Investigate, contain, remediate.
- Deep investigation of escalated incidents
- Comprehensive log and forensic analysis
- Containment and remediation strategy
- Custom detection rule development
- Security tool optimization and automation
- Mentor Tier 1 analysts
- **Key metrics:** Investigation quality, remediation success rate, response time

### Tier 3 — Threat Hunter / Senior Analyst
**Mission:** Proactively find what automated tools miss.
- Proactive threat hunting using advanced analytics
- Sophisticated incident handling and forensics
- Custom tool and detection rule development
- Enterprise security strategy design
- Technical leadership across the organization
- **Key metrics:** Threats discovered proactively, advanced attack detection rate

---

## Alert Flow

```
Event → SIEM Alert → Tier 1 Triage
                      ├─ False Positive? → Close + tune the rule
                      └─ Real Incident?  → Tier 2 Investigation
                                           └─ Complex/Critical? → Tier 3
```

### Escalation Criteria (Tier 1 → Tier 2)
- Confirmed malicious activity requiring containment
- Multi-system or multi-user scope
- Evidence of lateral movement
- Data exfiltration indicators
- Incident involves privileged accounts
- Scope exceeds Tier 1's investigation tooling

### Escalation Criteria (Tier 2 → Tier 3)
- Advanced persistent threat (APT) indicators
- Novel attack techniques not matching known signatures
- Organization-wide impact
- Requires custom forensic tooling
- Strategic or architectural response needed

---

## Tool Categories

| Category | What It Does | Examples |
|----------|-------------|----------|
| **SIEM** | Collect, correlate, and alert on security events across all sources | Splunk, QRadar, Sentinel, Exabeam |
| **IDS/IPS** | Monitor network traffic for known attack signatures; IPS can block | Snort, Suricata, Zeek |
| **WAF** | Filter and monitor HTTP traffic to/from web applications | ModSecurity, AWS WAF, Cloudflare |
| **EDR** | Monitor endpoints, detect threats, enable remote isolation | CrowdStrike, SentinelOne, Defender |
| **SOAR** | Automate playbook execution, orchestrate tool responses | Cortex XSOAR, Swimlane, Tines |
| **UEBA** | Detect behavioral anomalies — insider threats, compromised accounts | Exabeam, Securonix |
| **XDR** | Unified detection across endpoints, email, apps, network, cloud | Palo Alto XDR, Microsoft 365 Defender |

**SIEM is the #1 requested skill** in security operations job postings (78%).

---

## Detection Mindset

### Three Questions for Every Input Path
1. **What does normal look like?** (Baseline behavior)
2. **What would an attack look like?** (Signatures, anomalies, IOCs)
3. **Would we actually detect it?** (Coverage gap analysis)

### Common Detection Gaps
- Encrypted traffic without TLS inspection
- Lateral movement within trust boundaries
- Slow-and-low attacks below alert thresholds
- Insider threats using legitimate credentials
- Supply chain compromise (trusted software acting malicious)
- API abuse that mimics normal usage patterns

### Alert Quality Principles
- **Tune aggressively** — a noisy alert is worse than no alert (alert fatigue kills detection)
- **Context enrichment** — alerts should include asset criticality, user role, recent activity
- **Actionable** — every alert should have a clear next step for the analyst
- **Layered detection** — signature-based + behavioral + threat intelligence

---

## Checker's Monitoring Mindset

When reviewing code or architecture, think across all three tiers:
- **Tier 1 thinking:** "Is this system producing logs that someone can actually monitor? Are the logs structured and searchable?"
- **Tier 2 thinking:** "If something goes wrong, can an analyst investigate? Are there enough breadcrumbs?"
- **Tier 3 thinking:** "Could a sophisticated attacker use this system without triggering any detection? What's the coverage gap?"
