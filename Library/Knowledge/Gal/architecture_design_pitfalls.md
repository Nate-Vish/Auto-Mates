---
title: "Architecture & Design Pitfalls: A Senior Developer's Field Guide"
category: software-architecture
tags:
  - architecture
  - design-patterns
  - anti-patterns
  - over-engineering
  - microservices
  - data-modeling
  - api-design
  - scaling
  - dependencies
  - separation-of-concerns
source_type: professional-knowledge
audience: all-developers
---

# Architecture & Design Pitfalls

Hard-won lessons from systems that shipped, systems that failed, and systems that should never have been built the way they were. Every section here represents a pattern that has cost real teams real time and real money.

---

## 1. Over-Engineering

The most expensive code is code that solves problems you do not have.

### 1.1 Premature Abstraction

Abstraction should emerge from duplication, not from speculation.

| Symptom | What It Looks Like | Why It Hurts |
|---------|-------------------|--------------|
| Interface with one implementation | `IUserService` with only `UserService` | Adds indirection with zero benefit |
| Generic framework for one use case | `AbstractDataProcessorFactory<T, R>` used once | Harder to read, harder to change |
| "Just in case" parameters | Functions with 8 parameters, 6 always default | Cognitive overload, testing burden |
| Premature plugin architecture | Extension points nobody extends | Maintenance cost for phantom flexibility |

**The Rule of Three:** Do not abstract until you have three concrete, distinct cases. Two is a coincidence; three is a pattern.

```python
# OVER-ENGINEERED: Abstracting on the first use
class DataProcessor(ABC):
    @abstractmethod
    def validate(self, data): ...
    @abstractmethod
    def transform(self, data): ...
    @abstractmethod
    def load(self, data): ...

class UserDataProcessor(DataProcessor):
    # The only implementation. Ever.
    def validate(self, data): ...
    def transform(self, data): ...
    def load(self, data): ...

# PRAGMATIC: Just write the function
def process_user_data(data):
    validated = validate_user_fields(data)
    transformed = normalize_user_names(validated)
    save_users(transformed)
```

### 1.2 Unnecessary Design Patterns

Design patterns are tools, not goals. Using a pattern where a simple function suffices is a net negative.

| Pattern | When It Is Overkill | Simpler Alternative |
|---------|--------------------|--------------------|
| Strategy | Only one algorithm ever used | Direct function call |
| Observer | Two components, one event | Simple callback or direct call |
| Factory | Only one product type exists | Constructor or `create()` function |
| Builder | Object has 3 fields | Constructor with named parameters |
| Decorator | One layer of wrapping | Modify the function directly |
| Mediator | Two components talking | Direct reference |

```java
// OVER-ENGINEERED: Factory pattern for a single type
public interface NotificationFactory {
    Notification create(String message);
}
public class EmailNotificationFactory implements NotificationFactory {
    public Notification create(String message) {
        return new EmailNotification(message);
    }
}
// Used exactly once: factory.create("Hello");

// PRAGMATIC: Just construct it
var notification = new EmailNotification("Hello");
```

### 1.3 Building for Hypothetical Requirements

The most damaging phrase in software: "We might need this later."

**Signs you are building for ghosts:**
- "What if we need to support multiple databases?" (You have one.)
- "What if we need to internationalize?" (You serve one country.)
- "What if we need real-time?" (Your data changes daily.)
- "What if traffic grows 100x?" (You have 50 users.)

**Cost of hypothetical code:**
- Written today, debugged today, tested today, maintained forever
- Often wrong when the real requirement arrives (because you guessed)
- Makes the actual needed change harder (wrong abstraction in the way)

### 1.4 Gold Plating

Adding polish, features, or sophistication beyond what was asked for or needed.

| Gold Plating | Pragmatic Version |
|-------------|-------------------|
| Custom ORM with query builder | Use the standard ORM for your language |
| Hand-rolled authentication system | Use a battle-tested auth library |
| Custom logging framework | Use structured logging with a standard library |
| Bespoke deployment pipeline | Use standard CI/CD tooling |
| Custom component library from day one | Use an existing design system, extract later |

**Litmus test:** If removing this feature or abstraction would not change the user experience or developer experience, it is gold plating.

---

## 2. Under-Engineering

The opposite failure: not enough structure, not enough thought, not enough investment in code organization.

### 2.1 No Separation of Concerns

When business logic, presentation, data access, and configuration all live together.

```python
# EVERYTHING IN ONE FUNCTION
def handle_order(request):
    # Parse input (presentation concern)
    data = json.loads(request.body)
    name = data['name'].strip().title()

    # Validate (business logic)
    if len(name) < 2:
        return HttpResponse('{"error": "bad name"}', status=400)

    # Query database (data access)
    cursor = db.execute("SELECT balance FROM accounts WHERE name = ?", [name])
    row = cursor.fetchone()

    # Business rule
    if row['balance'] < data['amount']:
        # Send email (infrastructure)
        smtp = smtplib.SMTP('mail.server.com')
        smtp.send_message(f"Insufficient funds for {name}")
        return HttpResponse('{"error": "insufficient funds"}', status=400)

    # More data access mixed with business logic
    db.execute("UPDATE accounts SET balance = balance - ? WHERE name = ?",
               [data['amount'], name])
    db.execute("INSERT INTO orders ...", [...])

    return HttpResponse('{"status": "ok"}')
```

**Why this fails:**
- Cannot test business logic without a database and SMTP server
- Cannot reuse the business rule in a different context (CLI, queue worker)
- Cannot change the database without touching business logic
- Every change risks breaking unrelated functionality

### 2.2 God Objects

A class or module that knows too much and does too much.

**Warning signs of a god object:**
- File exceeds 1000 lines
- Class has more than 20 methods
- Class name includes "Manager", "Handler", "Processor", "Service", or "Utils" and does everything
- Constructor takes more than 8 dependencies
- Changing any feature requires modifying this file

```typescript
// GOD OBJECT
class ApplicationManager {
    handleUserLogin() { ... }
    handleUserLogout() { ... }
    processPayment() { ... }
    sendEmail() { ... }
    generateReport() { ... }
    syncInventory() { ... }
    validateAddress() { ... }
    calculateShipping() { ... }
    applyDiscount() { ... }
    exportToCSV() { ... }
    // 40 more methods...
}
```

**Fix:** Split by domain responsibility. Each class should have one reason to change.

### 2.3 Copy-Paste Over Abstraction

Duplication is the root of divergence. When logic is copied, it will inevitably be updated in one place and not the other.

**When to abstract duplicated code:**

| Copies | Action |
|--------|--------|
| 2 | Note it. Consider if they will diverge. |
| 3 | Abstract it. The pattern is confirmed. |
| 4+ | You waited too long. Abstract immediately. |

**What to watch for:**
- Same validation logic in multiple endpoints
- Same error handling pattern in every function
- Same data transformation in multiple places
- Same query with minor variations across files

---

## 3. Monolith vs. Microservices Traps

### 3.1 The Distributed Monolith

The worst of both worlds: you pay the operational cost of microservices but get none of the benefits because your services cannot be deployed independently.

**Signs you have a distributed monolith:**
- Deploying service A requires simultaneously deploying service B
- Services share a database
- Services call each other synchronously in long chains
- A change to a shared data format requires updating multiple services at once
- You have a "common" library that every service depends on and it changes frequently

```
# DISTRIBUTED MONOLITH: Synchronous chain
User -> API Gateway -> Auth Service -> User Service -> Order Service -> Inventory Service -> Payment Service
# If ANY service in this chain is down, the entire operation fails.
# You now have 6 points of failure instead of 1.
```

### 3.2 The Network Is Not Reliable

Every network call can fail. Every network call adds latency. Every network call can return stale data.

| Monolith | Microservice |
|----------|-------------|
| Function call: ~nanoseconds | Network call: ~milliseconds |
| Function call: always succeeds | Network call: can timeout, fail, return errors |
| In-process data: consistent | Cross-service data: eventually consistent |
| One deploy: atomic | Multi-service deploy: coordination required |

**The 8 fallacies of distributed computing (all will bite you):** The network is reliable. Latency is zero. Bandwidth is infinite. The network is secure. Topology does not change. There is one administrator. Transport cost is zero. The network is homogeneous.

### 3.3 Data Consistency Across Services

The moment you split a monolith's database, you lose transactions.

```
# MONOLITH: One transaction, guaranteed consistency
BEGIN TRANSACTION;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  INSERT INTO orders (account_id, amount) VALUES (1, 100);
  UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 42;
COMMIT;

# MICROSERVICES: Three services, three databases, no shared transaction
# Account Service: deducts balance (succeeds)
# Order Service: creates order (succeeds)
# Inventory Service: decrements stock (FAILS — now what?)
# You need a saga, compensation logic, and eventual consistency handling.
```

**Before splitting:** Ask yourself whether the data that needs to be consistent actually belongs in separate services. If two datasets must always be consistent, they probably belong together.

### 3.4 Operational Complexity

| Concern | Monolith | Microservices |
|---------|----------|---------------|
| Deployment | One artifact | N artifacts, orchestration needed |
| Debugging | One log, one stack trace | Distributed tracing across services |
| Testing | Integration tests run locally | Need service mesh or contract tests |
| Monitoring | One dashboard | N dashboards, correlated metrics |
| Data migration | One database migration | Coordinated migrations across services |
| Team onboarding | Learn one codebase | Learn the service map, protocols, and contracts |

**Start with a well-structured monolith.** Extract services only when you have a proven need: independent scaling, independent deployment cadence, or team autonomy boundaries.

---

## 4. Wrong Pattern for the Job

### 4.1 Pattern Misapplication Table

| Pattern | Correct Use | Misuse | Consequence |
|---------|------------|--------|-------------|
| Singleton | Truly global, stateless resource (logger) | Database connection, configuration | Hidden dependencies, untestable code |
| Observer | Many consumers, decoupled, async-friendly | Two components passing one event | Debugging nightmare, event spaghetti |
| Factory | Multiple types determined at runtime | One type, known at compile time | Useless indirection |
| Strategy | Algorithm varies by context at runtime | One algorithm, never changes | Unnecessary interface and class |
| Repository | Complex query logic, multiple data sources | Simple CRUD with an ORM | Duplicate layer over the ORM |
| Event Sourcing | Audit trail critical, temporal queries needed | Simple CRUD application | 10x complexity for no benefit |
| CQRS | Read and write models genuinely differ | Simple app with matching read/write | Two models to maintain instead of one |

### 4.2 Singleton Overuse

Singletons are global state in disguise. Every singleton is a hidden dependency that makes testing harder and makes the code lie about what it needs.

```java
// SINGLETON ABUSE: Hidden dependency
public class OrderProcessor {
    public void process(Order order) {
        // Where does the database connection come from? Who configures it?
        // How do I test this with a different database?
        Database.getInstance().save(order);
        EmailService.getInstance().send(order.getCustomerEmail(), "Order confirmed");
        Logger.getInstance().log("Order processed: " + order.getId());
    }
}

// EXPLICIT DEPENDENCIES: Testable, clear, honest
public class OrderProcessor {
    private final OrderRepository repository;
    private final NotificationService notifications;
    private final Logger logger;

    public OrderProcessor(OrderRepository repo, NotificationService notif, Logger log) {
        this.repository = repo;
        this.notifications = notif;
        this.logger = log;
    }

    public void process(Order order) {
        repository.save(order);
        notifications.orderConfirmed(order);
        logger.info("Order processed: {}", order.getId());
    }
}
```

### 4.3 Event-Driven Where It Is Not Needed

Events add indirection. Only use them when decoupling is genuinely valuable.

```python
# OVER-ENGINEERED: Event system for two components
event_bus.emit("user_created", user)
# ...somewhere else, hard to find...
@event_bus.on("user_created")
def send_welcome_email(user):
    mailer.send(user.email, "Welcome!")

# PRAGMATIC: Direct call when there is one consumer
def create_user(data):
    user = save_user(data)
    send_welcome_email(user)  # Clear, traceable, debuggable
    return user
```

**Use events when:** multiple independent consumers, cross-service communication, async processing needed, or you need to decouple deployment.

**Avoid events when:** one producer, one consumer, same service, synchronous flow is fine.

---

## 5. Scaling Mistakes

### 5.1 Premature Optimization

Optimizing before you have measured is guessing. And guessing is usually wrong.

| Premature Optimization | Pragmatic Approach |
|-----------------------|--------------------|
| Custom memory allocator before profiling | Use the default allocator, profile under load |
| Hand-rolled cache before measuring latency | Add caching after identifying slow queries |
| Denormalized database schema before load testing | Normalize first, denormalize specific hot paths |
| Microservices "for scale" with 100 users | Monolith until you prove a bottleneck |
| NoSQL "for performance" without benchmarking | Start with a relational database, migrate if proven |

**The process:**
1. Make it work
2. Make it correct
3. Measure it under realistic load
4. Identify the actual bottleneck
5. Optimize that specific bottleneck
6. Measure again to verify improvement

### 5.2 Vertical When Horizontal Is Needed (and Vice Versa)

| Scaling Type | When It Works | When It Fails |
|-------------|---------------|---------------|
| Vertical (bigger machine) | Database servers, memory-bound tasks, quick fix | Hits hardware ceiling, single point of failure |
| Horizontal (more machines) | Stateless web servers, read replicas, queue workers | Stateful services, strong consistency requirements |

**The stateful service trap:**

```python
# CANNOT SCALE HORIZONTALLY: State stored in process memory
class SessionStore:
    _sessions = {}  # In-memory — lost on restart, not shared across instances

    def set(self, session_id, data):
        self._sessions[session_id] = data

    def get(self, session_id):
        return self._sessions.get(session_id)

# Request hits Server A, session created on Server A.
# Next request hits Server B via load balancer — session not found.
```

**Fix:** Externalize state to a shared store (Redis, database). Make application servers stateless.

### 5.3 Shared Mutable State

The root cause of most concurrency bugs and most scaling walls.

```go
// SHARED MUTABLE STATE: Race condition
var counter int

func handleRequest(w http.ResponseWriter, r *http.Request) {
    counter++  // Not atomic. Two goroutines can read the same value.
    fmt.Fprintf(w, "Request #%d", counter)
}

// FIX: Use atomic operations or channels
var counter int64

func handleRequest(w http.ResponseWriter, r *http.Request) {
    count := atomic.AddInt64(&counter, 1)
    fmt.Fprintf(w, "Request #%d", count)
}
```

**Principle:** Prefer immutable data. When mutation is necessary, isolate it behind explicit synchronization.

---

## 6. Dependency Hell

### 6.1 Circular Dependencies

When A depends on B and B depends on A, you cannot change either without risking breakage in the other.

```
# CIRCULAR: Cannot deploy or test independently
UserService -> OrderService (to check order history)
OrderService -> UserService (to validate user exists)

# FIX: Introduce a shared interface or event
UserService -> UserRepository
OrderService -> OrderRepository + UserValidator (interface)
# UserService implements UserValidator
# OrderService depends on the interface, not the concrete service
```

**Detection:** If you cannot draw your dependency graph as a DAG (directed acyclic graph), you have circular dependencies.

### 6.2 Tight Coupling

Code is tightly coupled when changing one module requires changing another.

| Tight Coupling | Loose Coupling |
|---------------|----------------|
| Class A directly constructs Class B | Class A receives an interface |
| Module reads another module's internal fields | Module calls a public API |
| Service A parses Service B's database tables | Service A calls Service B's API |
| Frontend hardcodes backend URL paths | Frontend uses an API client with configurable base URL |
| Code checks `instanceof` for behavior | Code uses polymorphism |

### 6.3 Leaky Abstractions

An abstraction leaks when users must understand the underlying implementation to use it correctly.

```python
# LEAKY: ORM that forces you to think about SQL
users = User.objects.filter(orders__product__category="electronics")
# Generates N+1 queries unless you know to add:
users = User.objects.filter(
    orders__product__category="electronics"
).select_related('profile').prefetch_related('orders__product')
# You must understand the SQL join strategy to use this ORM correctly.
```

**Leaky abstraction checklist:**
- Can a user of this API be surprised by its behavior?
- Does the documentation say "but be careful about..."?
- Do users need to understand the implementation to avoid performance traps?
- Does error handling expose internal details?

### 6.4 Unstable Interfaces

An interface that changes frequently forces all consumers to change with it.

**Stability rules:**
- Public APIs should be versioned
- Internal interfaces between modules should have clear owners
- Breaking changes require a deprecation period
- Depend on stable abstractions, not volatile concretions

---

## 7. Data Modeling Mistakes

### 7.1 Premature Normalization

Normalizing everything to third normal form before understanding access patterns leads to queries that join 12 tables to display a single page.

```sql
-- OVER-NORMALIZED: Address split across 5 tables
SELECT a.line1, a.line2, c.name as city, s.name as state,
       co.name as country, z.code as zip
FROM addresses a
JOIN cities c ON a.city_id = c.id
JOIN states s ON c.state_id = s.id
JOIN countries co ON s.country_id = co.id
JOIN zip_codes z ON a.zip_id = z.id
WHERE a.user_id = 42;

-- PRAGMATIC: Address as a single row (for most applications)
SELECT line1, line2, city, state, country, zip_code
FROM addresses
WHERE user_id = 42;
```

**Normalize when:** Data integrity matters, updates happen frequently, storage is a concern.
**Denormalize when:** Read performance matters, data is read far more than written, join complexity is high.

### 7.2 No Normalization at All

The opposite problem: storing everything as flat JSON blobs or repeating data everywhere.

```json
// NO NORMALIZATION: Customer data duplicated in every order
{
  "order_id": 1,
  "customer_name": "Jane Smith",
  "customer_email": "jane@example.com",
  "customer_phone": "555-0123"
}
{
  "order_id": 2,
  "customer_name": "Jane Smith",
  "customer_email": "jane@NEW-EMAIL.com",  // Updated here but not in order 1
  "customer_phone": "555-0123"
}
// Now customer data is inconsistent across orders.
```

### 7.3 Wrong Relationship Types

| Mistake | Example | Consequence |
|---------|---------|-------------|
| Many-to-many modeled as one-to-many | User has one role (but needs multiple) | Schema migration later, data loss risk |
| One-to-one when one-to-many needed | User has one address (but has shipping + billing) | Breaking change when requirements clarify |
| No join table for M2M | Comma-separated IDs in a column | Cannot query, cannot enforce FK, data integrity gone |
| Self-referential not considered | Employee -> Manager (also an employee) | Recursive queries, ORM confusion |

```sql
-- ANTI-PATTERN: Comma-separated IDs
CREATE TABLE articles (
    id INT PRIMARY KEY,
    tag_ids VARCHAR(255)  -- "1,3,7,12" -- Cannot join, cannot index, cannot enforce
);

-- CORRECT: Join table
CREATE TABLE article_tags (
    article_id INT REFERENCES articles(id),
    tag_id INT REFERENCES tags(id),
    PRIMARY KEY (article_id, tag_id)
);
```

### 7.4 Ignoring Access Patterns

The schema should serve the queries, not the other way around.

**Questions to ask before modeling:**
- What are the most frequent queries?
- What are the most performance-sensitive queries?
- What is the read-to-write ratio?
- What data is accessed together?
- What are the growth projections for each table?

---

## 8. API Architecture Pitfalls

### 8.1 REST vs. GraphQL: Wrong Tool for the Job

| Scenario | Better Fit | Why |
|----------|-----------|-----|
| Simple CRUD, well-defined resources | REST | Cacheable, simple, well-understood |
| Mobile app needing flexible queries | GraphQL | Avoids over-fetching, one round trip |
| Public API for third parties | REST | Easier to document, version, rate-limit |
| Dashboard aggregating many data sources | GraphQL | Single query, client-driven selection |
| File upload/download | REST | Streaming support, simpler semantics |
| Real-time subscriptions | GraphQL (subscriptions) or WebSocket | Built-in subscription model |

**REST anti-patterns:**
- Deeply nested URLs: `/users/1/orders/2/items/3/reviews/4`
- Verbs in URLs: `/api/getUser`, `/api/createOrder` (use HTTP methods)
- Ignoring HTTP status codes: returning 200 with `{"error": "not found"}`
- No pagination on list endpoints

**GraphQL anti-patterns:**
- No query depth limiting (allows attackers to craft expensive queries)
- N+1 queries on the resolver level (use DataLoader)
- No persisted queries in production (allows arbitrary query execution)

### 8.2 Synchronous When Async Is Needed

```python
# SYNCHRONOUS BOTTLENECK: User waits while email sends
@app.route("/register", methods=["POST"])
def register():
    user = create_user(request.json)
    send_welcome_email(user.email)      # Takes 2-5 seconds
    send_admin_notification(user)        # Takes 1-3 seconds
    sync_to_crm(user)                   # Takes 3-10 seconds
    return jsonify(user.to_dict())       # User waited 6-18 seconds

# ASYNC: User gets immediate response
@app.route("/register", methods=["POST"])
def register():
    user = create_user(request.json)
    queue.enqueue("send_welcome_email", user.email)
    queue.enqueue("send_admin_notification", user.id)
    queue.enqueue("sync_to_crm", user.id)
    return jsonify(user.to_dict())       # User waited ~100ms
```

### 8.3 Missing Circuit Breakers

When a downstream service is failing, continuing to send it requests makes everything worse.

```
Without circuit breaker:
  Service A -> Service B (down, 30s timeout)
  Every request to A now takes 30 seconds.
  A's thread pool fills up.
  A becomes unresponsive.
  Everything upstream from A also fails.
  CASCADE FAILURE.

With circuit breaker:
  Service A -> Service B (down, circuit OPEN)
  Requests to B fail fast (milliseconds, not 30 seconds).
  A returns a degraded response or cached data.
  A remains responsive.
  Circuit breaker periodically tests if B has recovered.
```

**Circuit breaker states:**
1. **Closed** (normal): Requests flow through. Failures are counted.
2. **Open** (tripped): Requests fail immediately. No calls to downstream.
3. **Half-Open** (testing): One request allowed through. If it succeeds, close. If it fails, open.

### 8.4 No Retry Strategy

Retrying without a strategy causes thundering herd problems when a service recovers.

| Strategy | Description | When to Use |
|----------|-------------|-------------|
| No retry | Fail immediately | Idempotency not guaranteed |
| Fixed delay | Wait N seconds between retries | Simple background tasks |
| Exponential backoff | 1s, 2s, 4s, 8s, 16s... | API calls, network requests |
| Exponential backoff + jitter | Random offset added to backoff | Multiple clients retrying simultaneously |
| Retry with budget | Max N retries per time window | Preventing retry storms |

```python
# DANGEROUS: Retry without backoff
for attempt in range(5):
    try:
        return call_service()
    except ServiceUnavailable:
        pass  # Immediate retry hammers the failing service

# SAFE: Exponential backoff with jitter
import random, time

for attempt in range(5):
    try:
        return call_service()
    except ServiceUnavailable:
        delay = (2 ** attempt) + random.uniform(0, 1)
        time.sleep(delay)
raise ServiceUnavailable("All retries exhausted")
```

---

## Quick-Reference: When to Split a Monolith

| Signal | Action |
|--------|--------|
| Different components need different scaling | Consider extracting the hot component |
| Teams stepping on each other in the same codebase | Consider team-aligned services |
| Component has genuinely different deployment cadence | Consider extracting it |
| "Microservices are trendy" or "We might scale someday" | Do nothing. Measure first. |

---

## Gal's Application: 10 Daily Architecture Rules

1. **Solve the problem in front of you.** Do not solve the problem you imagine having in two years. Requirements you do not have yet will change before they arrive.

2. **Every abstraction must earn its place.** If it does not remove duplication or decouple a genuine dependency, delete it. One concrete implementation behind an interface is a lie, not an abstraction.

3. **Draw the dependency graph before writing the code.** If you cannot draw a clean DAG on a whiteboard, the code will be a tangled mess. Circular dependencies are always a design failure.

4. **Start with a monolith, extract with evidence.** Microservices are an optimization for organizational scaling, not a starting architecture. Prove the bottleneck before paying the distributed systems tax.

5. **Make state explicit and minimize it.** Shared mutable state is the enemy of both correctness and scalability. Every piece of state should have exactly one owner and a clear lifecycle.

6. **Design APIs for the consumer, not the implementation.** The internal data model should not leak into the API. The API contract should be stable even when the internals change.

7. **Every network call is a liability.** It can fail, it can be slow, it can return stale data. Treat every network boundary as a failure point with timeouts, retries, and circuit breakers.

8. **Model data for how it is accessed, not how it looks on a whiteboard.** The entity-relationship diagram is a starting point, not a schema. Access patterns, read/write ratios, and query frequency determine the right model.

9. **Complexity is a cost you pay forever.** Every layer of indirection, every pattern, every abstraction is a line item on the maintenance budget. The simplest design that solves the problem is the best design.

10. **When in doubt, write less code.** The code you do not write has no bugs, needs no tests, requires no documentation, and never becomes technical debt. Delete mercilessly. Resist the urge to add.
