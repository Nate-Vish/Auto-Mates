# Post-Incident

What happens after containment and recovery: regulatory notification, lessons learned, and making sure it does not happen again.

---

## Breach Notification Timelines

The clock starts at **awareness** (reasonable certainty of compromise), NOT when the breach actually occurred.

| Regulation | Timeline | Clock Starts At | Who Gets Notified |
|-----------|----------|----------------|-------------------|
| **GDPR** | **72 hours** | Awareness that personal data was compromised | Supervisory authority + affected individuals (if high risk) |
| **HIPAA (current)** | **60 days** | Discovery of breach | HHS + affected individuals (+ media if 500+ affected) |
| **HIPAA (proposed 2025)** | **72 hours** | For breaches affecting 500+ individuals | HHS |
| **SEC** | **4 business days** | Determination of MATERIALITY (not discovery) | Public disclosure via Form 8-K |
| **CCPA** | "Most expedient time possible" | Without unreasonable delay | Affected California residents |
| **PCI DSS** | Varies by card brand | Per card brand requirements | Payment card brands + acquiring banks |

### GDPR Specifics
- "Awareness" = reasonable certainty, not absolute confirmation
- High-risk breaches require **individual notification** "without undue delay"
- Notification must include: nature of breach, categories affected, approximate numbers, DPO contact, likely consequences, mitigation measures taken
- Late notification must explain the reason for delay
- Phased reporting is allowed for complex incidents
- **Penalty for failure:** Up to 10M EUR or 2% of global annual turnover
- Individual notification waived if: data was encrypted (key not compromised), risk eliminated by subsequent measures, or disproportionate effort (public announcement instead)

### SEC Specifics
- Focuses on **materiality** — not every incident, only material ones
- "Material" = would a reasonable investor consider it important?
- Materiality determination must happen "without unreasonable delay"
- No fixed timeframe for making the materiality determination itself — but regulators scrutinize delays

---

## Lessons Learned Process

The most important phase of incident response. Without it, you are guaranteed to repeat the same failures.

### Post-Mortem Structure

**Timing:** Within 1-2 weeks of incident resolution. Never later — memory fades.

**Participants:** All IR team members, affected system owners, management stakeholders.

**Agenda:**
1. **Timeline reconstruction** — what happened, when, in what order
2. **Root cause analysis** — what vulnerability or failure enabled the incident
3. **Detection review** — how was it discovered? How long was the attacker present before detection?
4. **Response review** — what went well? What failed? Where were delays?
5. **Impact assessment** — data compromised, systems affected, business cost, customer impact
6. **Action items** — specific, measurable, with owners and deadlines

### Post-Mortem Principles
- **Blameless** — focus on process and systems, not individuals
- **Evidence-based** — reference logs, timelines, and forensic findings
- **Forward-looking** — every finding must produce an action item
- **Tracked to completion** — action items without follow-up are worthless

### What to Update After Every Incident
- Detection rules (close the gap that allowed the attacker to operate undetected)
- IR playbooks (incorporate lessons from this response)
- Training materials (if human error was a factor)
- Architecture (if a design flaw was exploited)
- Access controls (if privilege abuse was involved)
- Backup and recovery procedures (if restoration was problematic)

---

## Regulatory Reporting

### When Checker Confirms a Breach Involving Personal Data
1. **Immediately** flag to Legal agent — the notification clock has started
2. **Document** the scope: what data, how many records, which jurisdictions
3. **Preserve** all evidence (see `digital-forensics.md`)
4. **Determine** which regulations apply based on:
   - Where affected individuals reside (GDPR, CCPA, etc.)
   - What type of data was compromised (health = HIPAA, financial = SEC/PCI)
   - Whether the organization is publicly traded (SEC)
5. **Support** Legal in preparing notification content

### Jurisdictional Complexity
A single breach can trigger multiple overlapping notification requirements:
- EU customers = GDPR 72hr
- US health data = HIPAA 60d
- Publicly traded company = SEC 4 business days
- California residents = CCPA "most expedient"

Each has different content requirements, different recipients, and different penalties.

---

## Checker's Post-Incident Role

1. **Drive the post-mortem** — ensure it happens, ensure it is blameless, ensure action items are created
2. **Review detection gaps** — why was the attacker not caught sooner?
3. **Validate fixes** — verify that eradication was complete and vulnerabilities are patched
4. **Update knowledge** — capture lessons in Checker's own memory for future reviews
5. **Flag to Legal immediately** when personal data is confirmed compromised — every hour counts for GDPR
