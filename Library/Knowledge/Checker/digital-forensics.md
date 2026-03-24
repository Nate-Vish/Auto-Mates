# Digital Forensics

How to preserve, collect, and analyze digital evidence during and after a security incident. The DFIR discipline exists because traditional IR can destroy evidence while removing threats.

---

## NIST 4-Step Forensic Process

### 1. Data Collection
Gather evidence from all relevant sources:
- **File system forensics** — files, folders, deleted data on endpoints
- **Memory forensics** — RAM contents (volatile — disappears on reboot)
- **Network forensics** — packet captures, web activity, device communications
- **Application forensics** — software logs, database records, API logs

**Golden rule:** Make forensic copies BEFORE processing. Investigate copies, preserve originals untouched.

### 2. Examination
Search collected data for indicators of compromise:
- Phishing emails and malicious attachments
- Altered files and modified timestamps
- Suspicious network connections
- New or modified user accounts
- Unauthorized configuration changes
- Malware artifacts, web shells, backdoors

### 3. Analysis
Process, correlate, and extract insights:
- Cross-reference findings with threat intelligence feeds
- Reconstruct the attack timeline (entry → lateral movement → objective)
- Identify all affected systems and data
- Determine the attacker's tools, techniques, and procedures (TTPs)
- Assess full scope of damage

### 4. Reporting
Document for multiple audiences:
- Incident details and attack vector
- Complete timeline with evidence citations
- Damage assessment
- Remediation recommendations
- Reports must support: law enforcement, insurance claims, regulatory compliance

---

## Chain of Custody

A formal process tracking evidence from collection through analysis and disposition. Proves evidence was not tampered with.

**Required for:**
- Legal proceedings and prosecution
- Regulatory audits
- Insurance claims
- Law enforcement cooperation

**Chain of custody documentation must record:**
- What was collected (device, file, image hash)
- When it was collected (timestamp)
- Who collected it
- How it was stored and protected
- Every person who accessed it and why

---

## What NOT To Do During an Incident

These mistakes destroy evidence and are irreversible:

| Do NOT | Why |
|--------|-----|
| **Reboot compromised systems** | Destroys volatile memory (RAM) — malware, encryption keys, active connections |
| **Wipe or rotate logs** | Eliminates the primary record of attacker activity |
| **Modify files on compromised systems** | Changes timestamps and file hashes, corrupting evidence |
| **Alert the attacker** | They will destroy evidence, deploy additional persistence, or accelerate damage |
| **Prioritize speed over evidence** | You may need this evidence for legal action, regulatory reporting, or understanding the full scope |
| **Use compromised systems for investigation** | Attacker may observe your response and adapt |
| **Install new tools on compromised systems** | Modifies disk state and may trigger attacker tripwires |

---

## Evidence Volatility Order

Collect in order from most volatile to least volatile:

1. **CPU registers and cache** (nanoseconds)
2. **RAM / running processes** (lost on reboot)
3. **Network connections** (active sessions disappear)
4. **Temporary files** (may be overwritten)
5. **Disk storage** (persistent but can be wiped)
6. **Remote logs** (SIEM, cloud logs — most durable)
7. **Physical evidence** (hardware, notes)

---

## Forensic Tools by Category

| Category | Purpose |
|----------|---------|
| **SIEM** | Collect and correlate security events from multiple sources |
| **SOAR** | Automate evidence collection and analysis workflows |
| **EDR** | Real-time endpoint analytics, isolation, and historical telemetry |
| **XDR** | Unified detection across users, endpoints, email, apps, networks, cloud |
| **Disk imaging** | Bit-for-bit copies of storage media |
| **Memory capture** | Dump RAM contents for offline analysis |
| **Network capture** | Record packet-level network traffic |

---

## Checker's Forensic Mindset

1. **Preserve first, contain second** — always ask "will this action destroy evidence?" before taking it
2. **Document everything** — timestamps, observations, decisions, and rationale
3. **Hash everything** — cryptographic hashes prove evidence integrity
4. **Assume legal proceedings** — treat every incident as if it may go to court
5. **Think chain of custody** — your security findings should be traceable and verifiable
