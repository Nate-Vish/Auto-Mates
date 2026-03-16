---
title: "DevOps & Deployment Mistakes: A Senior Developer's Field Guide"
category: devops
tags:
  - devops
  - ci-cd
  - deployment
  - containers
  - monitoring
  - observability
  - secrets
  - infrastructure
  - logging
  - configuration-management
  - disaster-recovery
source_type: professional-knowledge
audience: all-developers
---

# DevOps & Deployment Mistakes

Production is where software meets reality. Every mistake in this document has caused real outages, real data loss, or real security breaches. DevOps is not a team or a title --- it is the discipline of building systems that can be deployed, monitored, and recovered reliably.

---

## 1. CI/CD Anti-Patterns

### 1.1 No CI at All

If code is not built and tested automatically on every change, you are relying on human discipline. Human discipline does not scale.

**What "no CI" actually means:**
- Bugs are discovered by customers, not by automated tests
- "It works on my machine" becomes the team's motto
- Integration happens once, painfully, right before release
- Nobody knows if the main branch is broken until they pull it

**Minimum viable CI pipeline:**

```yaml
# This is the floor, not the ceiling
on: [push, pull_request]
steps:
  - checkout code
  - install dependencies
  - run linter
  - run unit tests
  - run integration tests
  - build artifact
  - report results
```

### 1.2 The 45-Minute Build

A build that takes longer than 10 minutes actively discourages developers from pushing, from running tests, and from integrating frequently.

| Build Time | Developer Behavior |
|-----------|-------------------|
| < 5 min | Runs it constantly, catches issues early |
| 5-15 min | Runs it before pushing, reasonable feedback loop |
| 15-30 min | Batches changes, pushes less often, integration pain |
| 30-60 min | Context-switches away, forgets what was being tested |
| > 60 min | Only runs CI before merge, bugs accumulate for days |

**Common causes and fixes:**

| Cause | Fix |
|-------|-----|
| Running all tests on every push | Parallelize tests, run only affected tests |
| Building from scratch every time | Cache dependencies, use incremental builds |
| End-to-end tests in CI | Move heavy E2E tests to a nightly or staging pipeline |
| Downloading large dependencies every run | Use a dependency cache or local mirror |
| Sequential steps that could be parallel | Run lint, unit tests, and build concurrently |
| Compiling unused code | Trim the build graph, remove dead code |

### 1.3 Flaky Tests Blocking Deploys

A flaky test is a test that sometimes passes and sometimes fails without any code change. Flaky tests destroy trust in the test suite.

**The flaky test death spiral:**
1. Tests occasionally fail for no reason
2. Developers start ignoring test failures
3. Real failures get ignored alongside flaky ones
4. Bugs ship to production
5. Team loses all confidence in CI

**Common causes of flakiness:**

| Cause | Symptom | Fix |
|-------|---------|-----|
| Test order dependency | Passes alone, fails in suite | Isolate test state, reset between tests |
| Timing/race conditions | Fails under load, passes when slow | Use explicit waits, avoid `sleep()` |
| External service dependency | Fails when API is down | Mock external services in tests |
| Shared test database | Fails when another test modifies data | Use transactions, reset DB per test |
| Non-deterministic data | Fails on certain dates, locales | Use fixed seeds, deterministic test data |
| Resource exhaustion | Fails after many tests run | Clean up resources, check for leaks |

**Policy:** Quarantine flaky tests immediately. Do not let them block the pipeline. Fix or delete within one week.

### 1.4 No Staging Environment

Deploying directly from development to production is deploying without a safety net.

```
WRONG:
  Developer laptop -> Production
  "I tested it locally, ship it"

MINIMUM:
  Developer laptop -> CI -> Staging -> Production

BETTER:
  Developer laptop -> CI -> Dev -> Staging -> Production
  Each environment mirrors production configuration more closely.
```

**What staging must have:**
- Same infrastructure configuration as production (not a laptop running Docker)
- Realistic data (anonymized production data or representative synthetic data)
- Same network topology (load balancers, service mesh, DNS)
- Same secrets management approach (different secrets, same mechanism)
- Automated deployment identical to the production deployment process

### 1.5 "It Works on My Machine"

The gap between a developer's local environment and production is where bugs hide.

| Local Environment | Production | Bug Hiding In |
|------------------|------------|---------------|
| macOS | Linux | Path handling, case sensitivity, line endings |
| SQLite | PostgreSQL | Query syntax, transaction behavior, types |
| 1 instance | 10 instances | Race conditions, session affinity, state |
| SSD, 32GB RAM | Network storage, 2GB RAM | Performance, memory limits, I/O patterns |
| Admin privileges | Restricted user | File permissions, port binding, capabilities |
| Latest versions of everything | Pinned, possibly older versions | API differences, deprecated features |

**Fix:** Standardize development environments. Use containers, dev environment specifications, or at minimum a documented setup with version pinning.

---

## 2. Configuration Drift

### 2.1 Manual Server Changes

Every manual change to a server is undocumented, unreproducible, and will be forgotten.

```bash
# THE MIDNIGHT FIX: SSH in, change a config, restart
ssh production-server
sudo vim /etc/nginx/nginx.conf  # "just a small tweak"
sudo systemctl restart nginx
# Works! Ship it! Go to bed!
# Three weeks later: new server deployed from base image. The fix is gone.
# Three months later: nobody remembers the fix existed.
```

**Rule:** If it is not in code, it does not exist. Every configuration change must go through version control and automated deployment.

### 2.2 Snowflake Servers

A snowflake server is a server that has been manually configured over time until it is unique and irreproducible. No one knows exactly what is on it. No one can rebuild it.

**Snowflake test:** Can you destroy this server right now and rebuild it from scratch in under an hour? If no, it is a snowflake.

| Snowflake | Cattle |
|-----------|--------|
| Named servers (production-db-01) | Numbered instances (i-a1b2c3d4) |
| SSH in to fix things | Destroy and redeploy |
| Manual package installation | Automated provisioning |
| Uptime measured in years | Uptime measured in days/weeks |
| Cannot be rebuilt | Can be rebuilt from code in minutes |

### 2.3 No Infrastructure as Code

Infrastructure that exists only as clicks in a web console is infrastructure that cannot be reviewed, versioned, tested, or reproduced.

**What should be in code:**
- Server/instance configuration
- Network topology (VPCs, subnets, security groups)
- Load balancer configuration
- DNS records
- Database configuration (not the data, the schema and settings)
- Monitoring and alerting rules
- CI/CD pipeline definitions

```hcl
# INFRASTRUCTURE AS CODE: Reviewable, versionable, reproducible
resource "server" "web" {
  count         = 3
  image         = "ubuntu-22.04"
  size          = "medium"
  region        = "us-east-1"

  provisioner "remote-exec" {
    inline = ["apt-get update && apt-get install -y nginx"]
  }
}

resource "load_balancer" "web" {
  name    = "web-lb"
  servers = server.web[*].id
  health_check {
    path     = "/health"
    interval = 30
  }
}
```

### 2.4 Environment Mismatches

When staging does not match production, testing in staging proves nothing.

| Mismatch | Consequence |
|----------|-------------|
| Different OS version | System library differences cause crashes |
| Different database version | Query behavior differences, missing features |
| Different resource limits | Performance issues only appear in production |
| Different network topology | Latency and timeout issues invisible in staging |
| Different config values | Feature flags, limits, and thresholds differ |
| HTTP in staging, HTTPS in production | Mixed content, redirect loops, cookie issues |

**Fix:** Use the same infrastructure-as-code templates for all environments. Parameterize only what must differ (domain names, instance counts, credentials).

---

## 3. Missing Monitoring & Observability

### 3.1 No Alerts Until Customers Complain

If your users discover outages before your team does, your monitoring has failed.

**The three pillars of observability (all required):**
- **Traces:** Follow a single request across services (distributed tracing, span correlation)
- **Metrics:** Aggregate numerical measurements (request rate, error rate, latency, saturation)
- **Logs:** Detailed event records (structured, correlated, searchable)

**Minimum alerts for any production service:**

| Alert | Condition | Severity |
|-------|-----------|----------|
| Service down | Health check fails for > 1 minute | Critical |
| Error rate spike | Error rate > 5% for > 5 minutes | Critical |
| Latency spike | p99 latency > 2x baseline for > 5 minutes | Warning |
| Disk space low | < 20% free | Warning |
| Disk space critical | < 5% free | Critical |
| Memory usage high | > 90% for > 10 minutes | Warning |
| Certificate expiring | < 14 days until expiry | Warning |
| Queue depth growing | Backlog increasing for > 15 minutes | Warning |

### 3.2 Too Many Alerts (Alert Fatigue)

When everything is an alert, nothing is an alert. Alert fatigue is when the team ignores pages because most of them are noise.

**Signs of alert fatigue:**
- Alerts firing daily that nobody investigates
- Alerts auto-acknowledged without action
- On-call engineers sleep through pages
- "Known issue, ignore" becomes a common response
- Real incidents missed because they looked like noise

**Alert hygiene rules:**
1. Every alert must be actionable. If the response is "do nothing," delete the alert.
2. Every alert must require human judgment. If the response is always the same, automate it.
3. Review alerts monthly. Delete alerts that have not required action.
4. Distinguish between pages (wake someone up) and notifications (check tomorrow).
5. Group related alerts. Five symptoms of one problem should be one alert, not five.

### 3.3 No Distributed Tracing

In a system with multiple services, a single user request may touch 5-20 services. Without distributed tracing, debugging is guesswork. Without tracing: check each service's logs manually, correlate by timestamp, hope you find the right request. Time to diagnose: hours. With tracing: search by trace ID, see the full request path with timing and the exact failure point. Time to diagnose: minutes.

**Tracing essentials:**
- Generate a unique trace ID at the entry point
- Propagate it through all service calls (HTTP headers, message metadata)
- Each service records spans (start time, end time, status, metadata)
- Spans collected centrally; anyone can search by trace ID

### 3.4 Missing SLOs

Without Service Level Objectives, you have no definition of "good enough" and no framework for prioritization.

| Term | Definition | Example |
|------|-----------|---------|
| SLI (Service Level Indicator) | The metric you measure | Request latency p99 |
| SLO (Service Level Objective) | The target for the metric | p99 latency < 500ms |
| SLA (Service Level Agreement) | The contractual promise | 99.9% uptime or credits issued |
| Error Budget | How much failure the SLO permits | 0.1% of requests can be slow |

**Why SLOs matter:** They answer the question "Should we focus on reliability or features?" If you are within your error budget, ship features. If you are burning through your error budget, fix reliability.

---

## 4. Deployment Failures

### 4.1 No Rollback Plan

Every deployment must have a tested, documented, fast rollback procedure. Before deploying, answer: How do we detect failure? (health checks, error rate monitoring, smoke tests). How do we rollback? (redeploy previous version, revert migration, restore config). How long does rollback take? (target: under 5 minutes). Who triggers rollback? (any on-call engineer, no approval needed). What about database changes? (must be backward-compatible; old code must work with new schema).

### 4.2 Big Bang Deploys

Deploying all changes to all users at once maximizes blast radius.

| Strategy | Risk | Recovery Time | Complexity |
|----------|------|---------------|------------|
| Big bang (all at once) | Maximum | Slow (full rollback) | Low |
| Rolling update | Medium | Medium (finish rollback) | Medium |
| Blue-green | Low | Fast (switch back) | Medium |
| Canary | Lowest | Fastest (route away) | Higher |
| Feature flags | Lowest | Instant (toggle off) | Highest |

**Blue-green:** Deploy new version to idle environment, smoke test, switch traffic. If problems, switch back instantly. **Canary:** Deploy to a small slice (5%), monitor, gradually increase to 100%. If problems at any stage, route all traffic back.

### 4.3 Friday Deploys

Deploying on Friday afternoon means any issues will be discovered over the weekend when the team is unavailable, response times are slow, and fixes are rushed.

**Deployment timing rules:**
- Deploy early in the week (Tuesday-Wednesday ideal)
- Deploy early in the day (morning, not evening)
- Never deploy before a holiday or long weekend
- Never deploy during peak traffic hours
- Always have the deploying engineer available for at least 2 hours post-deploy

### 4.4 Database Migration During Deploy

Schema changes that lock tables, rewrite data, or break backward compatibility during a deployment are the leading cause of deployment-related outages.

**Safe migration strategy (multi-phase):** (1) Deploy new code that works with BOTH old and new schema. (2) Add the new column. (3) Backfill data. (4) Deploy code that only uses the new column. (5) Drop the old column. Never combine a breaking schema change with a code deploy.

**Rules for safe migrations:**
- Never drop a column or table until no running code references it
- Never rename a column in place; add new, migrate data, drop old
- Never add a NOT NULL column without a default value to a populated table
- Always test migrations against a copy of production data
- Always have a rollback migration script ready

---

## 5. Container Mistakes

### 5.1 Running as Root

Running containers as root means a container escape gives the attacker root on the host.

```dockerfile
# DANGEROUS: Running as root (the default)
FROM node:18
COPY . /app
CMD ["node", "server.js"]
# Process runs as root inside the container.

# SECURE: Non-root user
FROM node:18
RUN groupadd -r appuser && useradd -r -g appuser appuser
COPY --chown=appuser:appuser . /app
USER appuser
CMD ["node", "server.js"]
```

### 5.2 No Resource Limits

A container without resource limits can consume all host resources, starving other containers.

```yaml
# WITHOUT LIMITS: One misbehaving container kills the host
services:
  web:
    image: myapp:latest
    # No limits. Memory leak? OOM kills random containers.

# WITH LIMITS: Contained blast radius
services:
  web:
    image: myapp:latest
    deploy:
      resources:
        limits:
          cpus: "1.0"
          memory: 512M
        reservations:
          cpus: "0.25"
          memory: 128M
```

### 5.3 Huge Images

Large images mean slow pulls, slow deploys, and a larger attack surface.

| Image | Size | Problem |
|-------|------|---------|
| `ubuntu:22.04` + app + dev tools | ~1.5 GB | Dev tools in production, huge attack surface |
| `node:18` | ~900 MB | Full OS, unnecessary for running Node |
| `node:18-slim` | ~200 MB | Trimmed OS, much better |
| `node:18-alpine` | ~120 MB | Minimal OS, smallest standard option |
| Multi-stage build | ~50-100 MB | Only runtime dependencies included |

```dockerfile
# MULTI-STAGE BUILD: Small, secure production image
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production (only runtime, no build tools)
FROM node:18-alpine
WORKDIR /app
RUN addgroup -S appuser && adduser -S appuser -G appuser
COPY --from=builder --chown=appuser:appuser /app/dist ./dist
COPY --from=builder --chown=appuser:appuser /app/node_modules ./node_modules
USER appuser
EXPOSE 3000
HEALTHCHECK CMD wget -q --spider http://localhost:3000/health || exit 1
CMD ["node", "dist/server.js"]
```

### 5.4 No Health Checks

Without health checks, the orchestrator cannot detect when a container is running but not serving requests (zombie container).

```dockerfile
# Health check in Dockerfile
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=40s \
  CMD curl -f http://localhost:3000/health || exit 1
```

**Health check endpoint requirements:**
- Returns 200 when the service is ready to accept requests
- Checks critical dependencies (database connectivity, essential services)
- Responds quickly (< 1 second)
- Does not cause side effects
- Does not require authentication

### 5.5 Volume Mount Confusion

Misunderstanding container volume semantics leads to data loss and permission errors.

| Scenario | Problem |
|----------|---------|
| Named volume with database data | Container rebuilt, volume persists -- good |
| Bind mount overrides container directory | Container's files are hidden by host's directory |
| No volume for database container | Data lost when container is removed |
| Volume owned by root, app runs as non-root | Permission denied errors |
| Bind mount of host path that does not exist | Docker creates it as root-owned empty directory |

---

## 6. Secret Management Failures

### 6.1 Secrets Committed to Version Control

Once a secret is in a git commit, it is in the repository history forever, even if you remove it in the next commit.

```bash
# THE DAMAGE IS DONE
git add .env  # Contains DATABASE_URL=postgres://admin:SuperSecret123@db:5432
git commit -m "add config"
git push

# "Oh no, let me remove it"
git rm .env
git commit -m "remove secrets"
git push
# SECRET IS STILL IN COMMIT HISTORY. Anyone with repo access can see it.
```

**Prevention checklist:**
- `.gitignore` includes all secret files (`.env`, `*.pem`, `*.key`, `credentials.*`)
- Pre-commit hooks scan for secrets (patterns like API keys, passwords, tokens)
- CI pipeline fails if secrets are detected in code
- Use environment variables or a secrets manager, never hardcoded values
- Regular automated scanning of repository history for leaked secrets

### 6.2 No Secret Rotation

Secrets that never change are secrets that are compromised and you do not know it.

| Secret Type | Rotation Frequency | Why |
|-------------|-------------------|-----|
| Database passwords | Every 90 days | Limit exposure window |
| API keys | Every 90 days | Limit exposure if leaked |
| TLS certificates | Before expiry (automate) | Prevent outages |
| Session signing keys | Every 30 days | Limit session hijacking window |
| Encryption keys | Annually (with re-encryption) | Cryptographic best practice |

**Rotation must be automated.** Manual rotation means it will be forgotten, and an expired certificate or compromised key will cause an outage or a breach.

### 6.3 Shared Credentials

When multiple people or services share one credential, you cannot audit who did what, and revoking one user means regenerating for everyone.

| Anti-Pattern | Consequence | Fix |
|-------------|-------------|-----|
| Team shares one database password | Cannot track who made a change | Per-developer credentials |
| All services use same API key | Cannot revoke one service | Per-service credentials |
| SSH key shared via Slack | Cannot audit access | Individual SSH keys per person |
| Root/admin password known by team | No accountability | Named accounts with role-based access |
| CI/CD uses developer's personal token | Leaves when developer leaves | Machine/service account tokens |

### 6.4 Secrets in CI Logs

CI systems often print environment variables, command outputs, and build logs. Secrets in these locations are visible to anyone with CI access.

```yaml
# LEAKING SECRETS IN CI
steps:
  - name: Debug
    run: env  # Prints ALL environment variables including secrets

  - name: Deploy
    run: |
      echo "Deploying with key: $API_KEY"  # Secret printed to log
      curl -H "Authorization: Bearer $API_KEY" https://api.example.com/deploy

# SAFE: Never echo secrets, use masking
steps:
  - name: Deploy
    run: |
      # Secret is passed but never printed
      curl -s -H "Authorization: Bearer $API_KEY" https://api.example.com/deploy
    env:
      API_KEY: ${{ secrets.API_KEY }}  # Masked in logs by CI system
```

**Rules:**
- Never `echo` or `print` a secret
- Never pass secrets as command-line arguments (visible in process lists)
- Use your CI system's secret masking feature
- Audit CI logs periodically for accidental secret exposure
- Use short-lived tokens where possible (expire automatically)

---

## 7. Infrastructure Mistakes

### 7.1 No Auto-Scaling

Fixed infrastructure capacity means either wasting money (over-provisioned) or dropping traffic (under-provisioned). With fixed capacity, low-traffic days waste resources and peak days drop requests.

**Auto-scaling requirements:** Stateless application servers (state externalized), health checks for new instances, warm-up time accounted for (scale before you need it), minimum and maximum instance counts set, and gradual scale-down policy to avoid thrashing.

### 7.2 Single Points of Failure

Any component that, if it fails, takes down the entire system.

| Component | Single Point of Failure | Redundant Alternative |
|-----------|------------------------|----------------------|
| Database | One primary, no replica | Primary + read replica + failover |
| Load balancer | One load balancer | Pair with failover or managed service |
| DNS | One DNS provider | Dual DNS providers |
| Region | Everything in one datacenter | Multi-region or multi-zone |
| Deployment | One deploy server | Distributed CI/CD |
| Person | Only one person knows how it works | Documentation + cross-training |

**The bus factor:** If one person being unavailable can halt your project, that is a single point of failure.

### 7.3 No Disaster Recovery

Disaster recovery is not a plan you make after the disaster. It is a plan you test regularly before the disaster.

**Key definitions:**
- **RTO (Recovery Time Objective):** How long can the system be down? (e.g., 4 hours)
- **RPO (Recovery Point Objective):** How much data can you lose? (e.g., 1 hour of data)

**What must be tested regularly:** Automated backups (verify weekly). Backup restoration (test monthly). RTO and RPO definitions (review quarterly). Failover procedures (drill quarterly). Communication plan for outages (review annually). Post-incident review process (execute after every incident).

### 7.4 No Cost Monitoring

Cloud infrastructure costs grow silently until someone gets a bill that is 10x expected.

**Common cost surprises:**

| Surprise | Cause | Prevention |
|----------|-------|-----------|
| Idle resources | Dev environments running 24/7 | Auto-shutdown non-production after hours |
| Orphaned storage | Volumes from deleted instances | Regular audit of unattached resources |
| Data transfer | Cross-region or cross-AZ traffic | Architect for locality, monitor transfer |
| Over-provisioned instances | "Large just in case" | Right-size based on actual usage metrics |
| Logging costs | Debug logging in production | Log levels, sampling, retention policies |
| Forgotten experiments | Prototype clusters still running | Tagging policy, expiration dates |

**Rules:**
- Set billing alerts at 50%, 80%, and 100% of expected spend
- Tag all resources with owner, environment, and purpose
- Review costs weekly, not monthly
- Auto-terminate non-production resources outside business hours

---

## 8. Logging Anti-Patterns

### 8.1 Logging Sensitive Data

Logs are often stored in less-secure systems than the application database. Sensitive data in logs is a compliance violation and a breach waiting to happen.

```python
# DANGEROUS: Sensitive data in logs
logger.info(f"User login: email={email}, password={password}")
logger.info(f"Payment processed: card={card_number}, cvv={cvv}")
logger.debug(f"API request: headers={request.headers}")  # Contains auth tokens

# SAFE: Redact or omit sensitive fields
logger.info(f"User login: email={mask_email(email)}")
logger.info(f"Payment processed: card=****{card_number[-4:]}")
logger.debug(f"API request: method={request.method}, path={request.path}")
```

**Never log:**
- Passwords or password hashes
- Credit card numbers, CVVs, bank account numbers
- Social security numbers, government IDs
- Authentication tokens, API keys, session IDs
- Full request/response bodies (may contain any of the above)
- Personal health information
- Contents of encrypted fields

### 8.2 No Log Levels

When everything is logged at the same level, there is no way to filter signal from noise.

| Level | When to Use | Example |
|-------|------------|---------|
| FATAL | Application cannot continue | Database connection pool exhausted |
| ERROR | Operation failed, needs attention | Payment processing failed |
| WARN | Something unexpected, but handled | Retry succeeded on third attempt |
| INFO | Normal significant events | User registered, order placed |
| DEBUG | Detailed diagnostic information | SQL query executed, cache hit/miss |
| TRACE | Very detailed, step-by-step flow | Entering/exiting functions, variable values |

**Production log level:** INFO. Use DEBUG only for specific troubleshooting, then turn it off.

```python
# BAD: Everything is print() or logger.info()
print(f"Starting server")
print(f"Processing user {user_id}")
print(f"SQL: {query}")
print(f"Cache miss for key {key}")
print(f"ERROR: Payment failed for user {user_id}")
print(f"User {user_id} logged in")

# GOOD: Appropriate levels
logger.info("Server starting on port %d", port)
logger.debug("Processing user %s", user_id)
logger.debug("SQL: %s", query)
logger.debug("Cache miss for key %s", key)
logger.error("Payment failed for user %s: %s", user_id, error)
logger.info("User %s logged in", user_id)
```

### 8.3 Unstructured Logs

Unstructured text logs are impossible to parse, query, or aggregate at scale. Compare `[2024-01-15 14:32:01] INFO: User logged in from 192.168.1.1` (human-readable, machine-hostile) with `{"timestamp":"2024-01-15T14:32:01Z","level":"info","event":"user_login","ip":"192.168.1.1","request_id":"abc-123"}` (machine-parseable, queryable, alertable).

**Structured log requirements:** Consistent format (JSON is the standard). Timestamp in ISO 8601 / UTC. Log level, event type, and request/trace ID as fields. Relevant context fields (user ID, order ID). No sensitive data.

### 8.4 No Centralized Logging

When logs are only on individual servers, debugging requires SSH-ing into each server and running grep. This does not scale past two servers.

**What centralized logging provides:**

| Capability | Without Central Logging | With Central Logging |
|-----------|------------------------|---------------------|
| Search across all servers | SSH into each one, grep | One query |
| Correlate events across services | Manual timestamp matching | Filter by trace ID |
| Alerting on log patterns | Custom scripts per server | Built-in pattern alerting |
| Historical analysis | Logs rotated and deleted | Retained per policy |
| Access control | SSH access = full server access | Read-only log access |
| Compliance | Cannot prove what happened | Immutable audit trail |

### 8.5 Log Rotation Failures

Logs that grow without bound will fill the disk and crash the application --- or worse, crash the host and take down everything running on it. An application writing 100MB/day fills a 50GB disk in under two years. If the database is on the same disk, you get data corruption on top of the outage.

**Rules:** Configure log rotation for every application. Set maximum file size and maximum number of files. Compress rotated logs. Never put logs on the same disk as your database. Monitor disk usage with alerts. In containers, send logs to stdout/stderr and let the orchestrator handle rotation.

---

## Quick-Reference Checklists

### Pre-Deployment Checklist

Code reviewed and approved. All tests passing. Database migrations tested against production-like data and backward-compatible. Rollback procedure documented and tested. Monitoring dashboards and alert thresholds ready. Smoke test scripts prepared. On-call engineer identified. Deploy window is not Friday, not before holiday, not during peak. Feature flags configured. Resource limits set. Secrets are not in code or logs.

### New Service Checklist

Health check endpoint. Structured logging with centralized collection. Metrics exported (request rate, error rate, latency). Alerts configured. Resource limits and auto-scaling rules defined. Container runs as non-root with minimal image. Secrets via secrets manager. CI/CD pipeline configured. Staging mirrors production. Backup strategy and disaster recovery documented. Runbook written.

### Incident Response Checklist

Acknowledge the alert. Assess severity and impact. Communicate status. Identify root cause. Decide: rollback, fix forward, or mitigate. Execute. Verify the fix. Update status communication. Schedule post-incident review. Write post-mortem with action items. Implement action items. Update runbooks and alerts.

---

## Gal's Application: 10 Daily DevOps Rules

1. **If it is not automated, it will break.** Manual processes depend on memory, discipline, and availability. Automate everything that happens more than once: builds, tests, deployments, scaling, backups, and rotation.

2. **Every deployment must be reversible in under five minutes.** If you cannot roll back faster than you can fix forward, you do not have a deployment process --- you have a prayer. Test your rollback as often as you test your deployment.

3. **Monitor the four golden signals: traffic, errors, latency, saturation.** If you are not watching these four metrics for every service, you are blind. An outage you discover from a customer complaint is a monitoring failure, not a code failure.

4. **Secrets belong in a secrets manager, not in code, not in env files, not in CI logs.** Assume that every file in your repository will be public someday. Assume that every CI log will be read by someone who should not have your credentials. Rotate every secret on a schedule.

5. **Your staging environment must be a miniature production.** If staging does not match production in configuration, infrastructure, and data shape, testing in staging proves nothing. The bugs will wait for production.

6. **Treat infrastructure as code or accept that it will drift.** Every manual server change is a bug waiting to happen. If you cannot rebuild your entire infrastructure from a repository in under an hour, you have snowflake servers.

7. **Never deploy on Friday.** Never deploy before a holiday. Never deploy during peak traffic. The best time to deploy is Tuesday morning when the full team is available and alert. The worst time is any time you will not be around to fix it.

8. **Structure your logs or accept that they are useless at scale.** Unstructured text logs cannot be queried, aggregated, or alerted on. Use JSON, include timestamps and trace IDs, never log sensitive data, and rotate before the disk fills up.

9. **Containers are disposable. Data is not.** Run containers as non-root with resource limits, health checks, and minimal images. Externalize all state to durable storage. If you cannot destroy and recreate a container in seconds, you are doing containers wrong.

10. **Plan for failure before it happens.** Test your backups by restoring them. Test your failover by triggering it. Test your incident response by running drills. The first time you execute your disaster recovery plan should never be during an actual disaster.
