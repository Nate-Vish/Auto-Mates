---
title: "Classic Backend Mistakes Every Developer Makes"
category: "Backend Engineering"
tags: [database, api-design, authentication, error-handling, concurrency, caching, performance, configuration, anti-patterns]
author: "Gal — Skeptical Senior Developer"
version: 1.0
last_updated: "2026-03-03"
purpose: "Universal reference for catching and preventing the backend mistakes that have caused outages, data loss, and security breaches since the first server went live."
---

# Classic Backend Mistakes Every Developer Makes

> "Every backend looks fine until it meets real traffic, real users, and real attackers — usually all at once."

---

## 1. Database Anti-Patterns

### 1.1 N+1 Queries

```python
# BAD: 1 query for orders + N queries for customers
orders = db.query("SELECT * FROM orders WHERE status = 'pending'")
for order in orders:
    customer = db.query("SELECT * FROM customers WHERE id = %s", order.customer_id)
    # 100 orders = 101 queries

# GOOD: JOIN or eager load — 100 orders = 1 query
orders = db.query("""
    SELECT o.*, c.name, c.email FROM orders o
    JOIN customers c ON c.id = o.customer_id WHERE o.status = 'pending'
""")
```

**Detection:** Enable query logging in development. Same query repeated with different parameters = N+1.

### 1.2 Missing Indexes

| Symptom | Fix |
|---|---|
| Queries slow as data grows, `EXPLAIN` shows sequential scan | Add index on `WHERE`, `JOIN`, `ORDER BY` columns |
| Multi-column filter without composite index | Create composite index matching query column order |
| Common filter on subset of data | Use partial index: `CREATE INDEX ... WHERE status = 'pending'` |

**Rule:** If `EXPLAIN ANALYZE` shows Seq Scan on a table with >1000 rows, investigate.

### 1.3 Over-Indexing

Every index speeds reads but slows writes. Find unused indexes:

```sql
SELECT indexname, idx_scan FROM pg_stat_user_indexes
WHERE idx_scan = 0 AND indexname NOT LIKE '%pkey%'
ORDER BY pg_relation_size(indexrelid) DESC;
```

### 1.4 SELECT *

| Why It Hurts | Detail |
|---|---|
| Wastes bandwidth | Transfers columns you discard |
| Prevents covering indexes | Index must include all columns |
| Breaks on schema changes | New column may hold sensitive data or large blobs |

Always: `SELECT id, name, email FROM users WHERE active = true;`

### 1.5 No Connection Pooling

| Pool Setting | Guidance |
|---|---|
| Min connections | Match baseline concurrency (5-10 for small apps) |
| Max connections | `DB max_connections / app_instances` |
| Connection timeout | 5-30s; fail fast over queue forever |
| Idle timeout | Close after 5-10 minutes |

Without pooling, each request pays 50-200ms for TCP + auth handshake.

### 1.6 ORM Misuse

| Anti-Pattern | Fix |
|---|---|
| Loading full objects for one field | Use projections/DTOs |
| ORM for complex reports | Write raw SQL for analytics |
| Ignoring lazy vs eager loading | Configure loading strategy explicitly |
| Trusting ORM migrations blindly | Review generated SQL before running |
| Never reading the generated SQL | Enable SQL logging in development |

**Rule:** The ORM is a convenience, not an abstraction. Log it. Read it. `EXPLAIN` it.

### 1.7 Schema Migration Disasters

| Disaster | Prevention |
|---|---|
| Dropping column while old code runs | Two-phase: (1) deploy code without column use, (2) drop column |
| Adding NOT NULL to million-row table | Add nullable, backfill in batches, then constrain |
| Renaming a column | Add new, copy data, update code, drop old |
| No rollback plan | Write and test both `up` and `down` migrations |
| Locking table during ALTER | Test on production-size copy; measure lock time |

---

## 2. API Design Mistakes

### 2.1 Inconsistent Naming

| Anti-Pattern | Fix |
|---|---|
| Mixed: `/getUsers`, `/user_list`, `/fetch-orders` | Noun, plural, lowercase: `/users`, `/orders` |
| Verbs in URLs: `POST /createUser` | HTTP method IS the verb: `POST /users` |
| Mixed case in responses | Pick one convention (camelCase or snake_case), enforce globally |

**RESTful pattern:** `GET /users` (list), `POST /users` (create), `GET /users/{id}` (read), `PUT /users/{id}` (replace), `PATCH /users/{id}` (partial), `DELETE /users/{id}`.

### 2.2 No Pagination

| Style | Best For | Weakness |
|---|---|---|
| Offset/limit (`?page=3&per_page=50`) | Simple UIs, small data | Slow at high offsets; duplicates on change |
| Cursor-based (`?cursor=abc&limit=50`) | Large datasets, feeds | Cannot jump to page N |
| Keyset (`?after_id=100&limit=50`) | Sorted by unique key | Requires stable sort column |

**Rule:** Every list endpoint MUST paginate. Default 20-100, max 1000. No unbounded results.

### 2.3 Breaking Changes Without Versioning

| Breaking Change | Non-Breaking Alternative |
|---|---|
| Removing a response field | Deprecate; remove in next major version |
| Changing field type | Add new field; keep old |
| Renaming a field | Add new name; keep old as alias |
| Changing error format | Support both via version header |

**Rule:** Additions are safe. Removals and renames are breaking. When in doubt, add a new field.

### 2.4 Missing Rate Limiting

```python
RATE_LIMITS = {
    'anonymous': '60/hour',     'authenticated': '1000/hour',
    'login_attempts': '5/min',  'password_reset': '3/hour per email',
    'file_upload': '10/min',    'api_write': '100/hour',
}
```

Include headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`, `Retry-After` (on 429).

| Algorithm | Best For |
|---|---|
| Fixed window | Simple; allows burst at boundary |
| Sliding window | Smooth limiting |
| Token bucket | Controlled bursts |
| Leaky bucket | Steady throughput |

### 2.5 Overfetching / Underfetching

| Strategy | How |
|---|---|
| Sparse fieldsets | `GET /users/123?fields=name,email` |
| Expand/embed | `GET /users/123?expand=orders` |
| GraphQL | Client specifies exact shape |
| Backend-for-Frontend | Aggregation layer per client type |

---

## 3. Authentication & Authorization Failures

### 3.1 JWT Misuse

| Anti-Pattern | Fix |
|---|---|
| Sensitive data in payload | JWTs are base64, not encrypted. Store only ID, role, expiry |
| No `exp` claim | Set 15-60 min expiry |
| JWT sessions without revocation | Short-lived access + refresh tokens; maintain revocation list |
| Stored in localStorage | httpOnly, Secure, SameSite cookies |
| HS256 with weak secret | RS256/ES256, or 256+ bit secret |
| Not validating `alg` header | Explicitly: `jwt.decode(token, key, algorithms=["RS256"])` |

### 3.2 Token Expiry Guide

| Token Type | Expiry | Storage |
|---|---|---|
| Access token | 15-60 min | Memory or httpOnly cookie |
| Refresh token | 7-30 days | httpOnly cookie; hashed server-side |
| Password reset | 15-60 min | Hashed in DB, single-use |
| Email verification | 24-72 hours | Hashed in DB, single-use |

**Rule:** Every token expires. Every token is revocable. Single-use tokens invalidated after use.

### 3.3 Authorization Failures

```python
# BAD: authenticated but not authorized
@login_required
def delete_user(id):
    db.session.delete(User.query.get(id))  # any user can delete anyone!

# GOOD: check authorization
@login_required
@require_role('admin')
def delete_user(id):
    db.session.delete(User.query.get(id))
```

| Mistake | Fix |
|---|---|
| Checking role on frontend only | ALWAYS enforce on backend |
| IDOR: user 456 sees user 123's orders | Verify `request.user.id == resource.owner_id` |
| Admin endpoint with no auth | Every endpoint: explicit auth + authz |
| Accepting `role=admin` from client body | Never accept privilege changes from client |

### 3.4 Session Fixation

Regenerate session ID on every privilege change: login, logout, role change, password change.

### 3.5 Password Storage

| Anti-Pattern | Fix |
|---|---|
| Plaintext storage | Hash with bcrypt (work factor >= 12), scrypt, or Argon2 |
| MD5 or SHA-256 | These are fast hashes; use slow, salted hashes |
| Homegrown scheme | Use battle-tested libraries only |
| Logging passwords | Never log request bodies containing passwords |

---

## 4. Error Handling Anti-Patterns

### 4.1 Swallowing Exceptions

```python
# BAD: silent failure
try:
    process_payment(order)
except Exception:
    pass  # money lost, nobody knows

# GOOD: catch specific, handle each
try:
    process_payment(order)
except PaymentDeclinedError as e:
    logger.warning(f"Declined order {order.id}: {e}")
    order.set_status('payment_failed')
    return error_response("Payment declined. Try another method.", 402)
except PaymentGatewayError as e:
    logger.error(f"Gateway error order {order.id}: {e}", exc_info=True)
    order.set_status('payment_pending')
    return error_response("Payment system unavailable. Please retry.", 503)
```

**Rule:** Every catch block must recover, propagate, or fail explicitly. Never `except: pass`.

### 4.2 Generic Error Messages

```json
// BAD                              // GOOD
{ "error": "Something went wrong" } { "error": {
                                        "code": "VALIDATION_FAILED",
                                        "message": "Invalid fields.",
                                        "details": [{"field": "email", "issue": "Must be valid email"}],
                                        "request_id": "req_abc123"
                                      }}
```

| Must Include | Must NOT Include |
|---|---|
| Machine-readable error code | Stack traces |
| Human-readable message | Database error messages |
| Request ID / correlation ID | File paths or internal service names |
| Field-level details (validation) | Schema or query structure |

### 4.3 No Structured Logging

```python
# BAD: unparseable at scale
logger.info(f"User {user_id} placed order {order_id} for ${amount}")

# GOOD: structured JSON
logger.info("order_placed", extra={
    "user_id": user_id, "order_id": order_id,
    "amount": amount, "request_id": request.id,
})
```

| Level | When | Examples |
|---|---|---|
| DEBUG | Diagnostic (dev only) | Cache hit/miss, query params |
| INFO | Normal operations | Login, order placed, job done |
| WARNING | Handled but unexpected | Rate limit approached, deprecated API called |
| ERROR | Requires attention | Payment failed, service down |
| CRITICAL | System failure | Database unreachable, disk full |

### 4.4 Missing Correlation IDs

Assign a UUID to every request at the edge. Propagate via `X-Correlation-ID` header to every downstream call and every log entry. Without this, debugging distributed systems is archaeology.

### 4.5 Undocumented Error Codes

Maintain an error code registry:

| Code | HTTP | Meaning | Client Action |
|---|---|---|---|
| AUTH_EXPIRED | 401 | Token expired | Refresh and retry |
| VALIDATION_FAILED | 400 | Body invalid | Show field errors |
| RATE_LIMITED | 429 | Too many requests | Backoff per Retry-After |
| CONFLICT | 409 | State conflict | Reload and retry |
| INTERNAL_ERROR | 500 | Server error | Show generic error, log request_id |

**Rule:** Every error code documented with meaning and expected client action. Same commit.

---

## 5. Concurrency Issues

### 5.1 Race Conditions

```python
# BAD: check-then-act (two threads both see balance=100)
account = db.get(account_id)
if account.balance >= amount:
    account.balance -= amount
    db.save(account)  # double withdrawal!

# GOOD: atomic operation
db.execute("UPDATE accounts SET balance = balance - %s WHERE id = %s AND balance >= %s",
           (amount, account_id, amount))
```

**Optimistic locking:** Include a `version` column. `UPDATE ... SET version = version + 1 WHERE id = ? AND version = ?`. Zero rows updated = conflict.

### 5.2 Deadlocks

| Strategy | How |
|---|---|
| Consistent lock ordering | Always lock by ID ascending |
| Lock timeout | `lock_timeout = '5s'` — fail fast |
| Reduce transaction scope | Hold locks minimum time |
| Retry with backoff | Catch deadlock, retry up to N times |

### 5.3 Double-Submit / Idempotency

```python
# GOOD: idempotency key prevents duplicate charges
idempotency_key = request.headers.get('Idempotency-Key')
existing = db.get_by_idempotency_key(idempotency_key)
if existing:
    return existing.response  # same result as first time
charge = payment_gateway.charge(request.json['amount'])
db.save_idempotent_response(idempotency_key, charge)
```

| Operation | Naturally Idempotent? | Fix |
|---|---|---|
| GET | Yes | N/A |
| PUT (full replace) | Yes | Same input = same state |
| DELETE | Yes (after first) | Return 204 even if already gone |
| POST (create) | NO | Idempotency key or unique constraint |
| PATCH | Depends | Conditional update (If-Match / version) |

**Rule:** Every write endpoint clients might retry MUST be idempotent.

---

## 6. Caching Mistakes

### 6.1 Cache Invalidation Failures

| Strategy | Risk |
|---|---|
| TTL only | Stale during TTL window |
| Event-based invalidation only | Miss an event = stale forever |
| Write-through | Complexity; partial failure |
| Cache-aside | Thundering herd on cold cache |

**Best practice:** Event-based invalidation WITH a TTL safety net.

```python
def update_user_profile(user_id, data):
    db.update_user(user_id, data)
    cache.delete(f"user:{user_id}")  # explicit invalidation

def get_user_profile(user_id):
    cached = cache.get(f"user:{user_id}")
    if cached: return cached
    profile = db.get_user(user_id)
    cache.set(f"user:{user_id}", profile, ttl=300)  # TTL safety net
    return profile
```

### 6.2 Thundering Herd

When a popular cache entry expires, hundreds of requests hammer the DB simultaneously.

**Mitigations:**
- **Locking:** Only one request rebuilds; others wait or get stale
- **Stale-while-revalidate:** Serve stale immediately, refresh in background
- **Pre-warming:** Refresh before expiry
- **Jittered TTL:** Random offset prevents simultaneous expiry

### 6.3 HTTP Cache Headers

```
# Immutable static assets (bust via filename hash)
Cache-Control: public, max-age=31536000, immutable

# User-specific API responses
Cache-Control: private, max-age=60

# Public, rarely changing
Cache-Control: public, max-age=300, s-maxage=600

# Sensitive data — never cache
Cache-Control: no-store

# Validation-based
Cache-Control: no-cache
ETag: "abc123"
```

### 6.4 Over-Caching

| Sign | Fix |
|---|---|
| Users see other users' data | `Vary: Authorization` or `Cache-Control: private` |
| Stale data after updates | Shorter TTL or explicit invalidation |
| Cache larger than DB | Cache only hot data; LRU eviction |
| Cache hides DB bugs | Add bypass header for debugging |

---

## 7. Performance Traps

### 7.1 Synchronous Where Async Needed

```python
# BAD: 450ms response (blocking on non-critical work)
def handle_order(order):
    send_email(order.customer.email)  # 200ms
    notify_warehouse(order)           # 150ms
    update_analytics(order)           # 100ms
    return {"status": "confirmed"}

# GOOD: ~50ms response (defer non-critical)
def handle_order(order):
    db.save_order(order)                              # critical — sync
    queue.enqueue('send_order_email', order.id)       # async
    queue.enqueue('notify_warehouse', order.id)       # async
    return {"status": "confirmed"}
```

| Synchronous | Asynchronous |
|---|---|
| DB save (critical path) | Email / push notifications |
| Input validation | Report generation |
| Auth checks | Upload processing |
| Payment capture | Analytics events |

### 7.2 Unbounded Queries

```python
# GOOD: enforce bounds on every list query
MAX_PAGE_SIZE = 100
DEFAULT_PAGE_SIZE = 20

def search(query, limit=DEFAULT_PAGE_SIZE):
    limit = min(limit, MAX_PAGE_SIZE)
    return db.query("SELECT id, name FROM products WHERE name LIKE %s LIMIT %s",
                    (f"%{query}%", limit))
```

**Rule:** Every list query has a LIMIT. Default 20, max 100-1000. No exceptions.

### 7.3 Connection Pooling for Everything

| Resource | Without Pooling | With Pooling |
|---|---|---|
| Database | 50-200ms per TCP+auth handshake | ~0ms (reused) |
| HTTP clients | 100-300ms per TCP+TLS | Keep-alive reuse |
| Redis | 1-5ms per connection | ~0.1ms persistent |

Pool databases, HTTP sessions, Redis, gRPC channels. Every external connection reused.

### 7.4 No Pagination on Large Datasets

Paginate at every layer: DB queries, API responses, background job batches, CSV exports (stream), admin views. Loading 500K rows into memory is a crash waiting to happen.

---

## 8. Configuration Mistakes

### 8.1 Hardcoded Values

```python
# BAD
conn = psycopg2.connect(host="192.168.1.50", password="hunter2")

# GOOD
DATABASE_URL = os.environ['DATABASE_URL']
MAX_RETRIES = int(os.environ.get('MAX_RETRIES', '3'))
```

**Rule:** If it differs between environments, it belongs in configuration, not code.

### 8.2 Secrets in Code

| Where Secrets End Up (BAD) | Where They Belong (GOOD) |
|---|---|
| Source code | Environment variables |
| config.json in git | Secret manager (Vault, etc.) |
| CI/CD YAML unencrypted | CI/CD encrypted variables |
| Docker image layers | Mounted at runtime |
| Log output | Redacted by middleware |

Add pre-commit scanning for patterns like `AKIA`, `sk_live_`, `-----BEGIN PRIVATE KEY-----`.

### 8.3 Environment-Specific Config Mixed In

```python
# BAD: if/elif chains for each environment scattered through codebase
def get_api_url():
    if os.environ.get('ENV') == 'production': return "https://api.example.com"
    elif os.environ.get('ENV') == 'staging': return "https://staging-api.example.com"
    else: return "http://localhost:8000"

# GOOD: one variable per environment
API_URL = os.environ['API_URL']
```

**Priority:** env vars > env-specific file (gitignored) > shared defaults (committed) > hardcoded defaults.

### 8.4 Missing Health Checks

```python
@app.route('/health')
def health():
    return {"status": "ok"}, 200

@app.route('/health/ready')
def readiness():
    checks = {}
    try: db.execute("SELECT 1"); checks["database"] = "ok"
    except: checks["database"] = "error"
    try: cache.ping(); checks["cache"] = "ok"
    except: checks["cache"] = "error"
    all_ok = all(v == "ok" for v in checks.values())
    return {"status": "ok" if all_ok else "degraded", "checks": checks}, 200 if all_ok else 503
```

| Type | Purpose | Used By |
|---|---|---|
| Liveness (`/health`) | Process alive? | Orchestrator (restart if dead) |
| Readiness (`/health/ready`) | Can serve traffic? | Load balancer (remove if not ready) |
| Startup (`/health/startup`) | Finished initializing? | Orchestrator (hold traffic) |

**Include:** DB, cache, critical services. **Exclude:** Non-critical services, expensive operations.

---

## Gal's Application: 10 Daily Rules for Backend Development

1. **Log every query your ORM generates.** Enable SQL logging in dev. `EXPLAIN ANALYZE` any query on tables >10K rows. Sequential scan where index scan belongs = fix it now.

2. **Every list endpoint gets pagination, a default limit, and a max limit.** Unbounded results are a denial-of-service vulnerability masquerading as a feature.

3. **Validate and authorize on the server. Always.** Frontend validation is courtesy. Backend validation is security. Trust nothing from the client.

4. **Never store what you can look up, never expose what you can compute.** Tokens expire. Sessions rotate. Secrets live in secret managers, not in code, not in git, not in logs.

5. **Make every write operation idempotent.** Retries, redeliveries, double-clicks all happen. Same request twice = same result. Idempotency keys, unique constraints, conditional updates.

6. **Catch specific exceptions and handle each one.** Generic `catch(Exception)` hides bugs. Every type gets its own handling: right log level, right state, right error code.

7. **Set timeouts on every external call.** DB, HTTP, cache, queue. No timeout = one slow dependency cascades into full outage.

8. **Use connection pools for everything.** DB, HTTP sessions, Redis, gRPC. New TCP handshake per request is a performance bug.

9. **Add a correlation ID to every request and propagate it everywhere.** Edge to downstream to logs. Without this, distributed debugging is impossible.

10. **Ship a health check endpoint on day one.** Liveness for the orchestrator, readiness for the load balancer. If your service cannot report its own health, you are flying blind.
