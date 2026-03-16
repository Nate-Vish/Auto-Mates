# System Design Principles for Software Architects
**Category:** Architecture
**Sources:**
- https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design
- https://www.baeldung.com/solid-principles
- https://stackoverflow.blog/2021/11/01/why-solid-principles-are-still-the-foundation-for-modern-software-architecture/
- https://levelup.gitconnected.com/software-architecture-mastering-s-o-l-i-d-principles-with-practical-examples-in-typescript-b4932f772920
- https://www.geeksforgeeks.org/system-design/solid-principle-in-programming-understand-with-real-life-examples/
- https://martinfowler.com/bliki/LayeringPrinciples.html
- https://www.martinfowler.com/ieeeSoftware/coupling.pdf
- https://martinfowler.com/tags/design.html
- https://medium.com/@hlfdev/kiss-dry-solid-yagni-a-simple-guide-to-some-principles-of-software-engineering-and-clean-code-05e60233c79f
- https://mattilehtinen.com/articles/4-most-important-software-development-principles-dry-yagni-kiss-and-sine/
- https://dev.to/juniourrau/clean-code-essentials-yagni-kiss-and-dry-in-software-engineering-4i3j
- https://thefullstack.xyz/dry-yagni-kiss-tdd-soc-bdfu

**Last updated:** 2026-03-01

---

## SOLID Principles

SOLID was introduced by Robert C. Martin ("Uncle Bob") and remains the foundation for modern software architecture. These principles apply beyond OOP -- they are relevant to functions, modules, microservices, and entire system designs.

---

### S -- Single Responsibility Principle (SRP)

**Definition:** A class/module should have only one reason to change.

**Practical example:**
```typescript
// BAD: One class does two things
class UserService {
  createUser(data: UserData) { /* save to DB */ }
  sendWelcomeEmail(email: string) { /* send email */ }
}

// GOOD: Each class has one responsibility
class UserService {
  createUser(data: UserData) { /* save to DB */ }
}

class EmailService {
  sendWelcomeEmail(email: string) { /* send email */ }
}
```

**When it applies:**
- A module handles both data access and business logic -- split them
- A React component fetches data AND renders UI -- extract a custom hook
- An API route validates, processes, and responds -- use middleware layers

**When it is wrong:**
- Splitting code so aggressively that related logic is scattered across 10 files
- Creating a separate class for every tiny responsibility (over-decomposition)
- SRP does not mean "one function per class" -- it means "one reason to change"

**How to evaluate:** Ask "If requirement X changes, how many files do I need to modify?" If the answer is "many, across different concerns," SRP is violated. If the answer is "many, but they are all related to the same concern," that is fine.

---

### O -- Open/Closed Principle (OCP)

**Definition:** Software entities should be open for extension but closed for modification.

**Practical example:**
```typescript
// BAD: Adding a new payment method requires modifying existing code
function processPayment(type: string, amount: number) {
  if (type === 'credit') { /* credit logic */ }
  else if (type === 'paypal') { /* paypal logic */ }
  // Adding 'crypto' means modifying this function
}

// GOOD: New payment methods extend without modifying existing code
interface PaymentProcessor {
  process(amount: number): Promise<PaymentResult>;
}

class CreditCardProcessor implements PaymentProcessor { /* ... */ }
class PayPalProcessor implements PaymentProcessor { /* ... */ }
class CryptoProcessor implements PaymentProcessor { /* ... */ } // New, no changes needed
```

**When it applies:**
- Systems where new variants are frequently added (payment methods, auth strategies, report formats)
- Plugin architectures
- Feature flag systems

**When it is wrong:**
- Early-stage code where you do not yet know what will vary -- premature abstraction
- When there are only 2 variants and unlikely to be more -- a simple if/else is clearer
- When the abstraction makes the code harder to understand than the modification would

---

### L -- Liskov Substitution Principle (LSP)

**Definition:** Objects of a superclass should be replaceable with objects of a subclass without breaking the program.

**Practical example:**
```typescript
// BAD: Square violates LSP because setWidth changes height
class Rectangle {
  setWidth(w: number) { this.width = w; }
  setHeight(h: number) { this.height = h; }
}
class Square extends Rectangle {
  setWidth(w: number) { this.width = w; this.height = w; } // Surprise!
}

// GOOD: Use composition or separate types
interface Shape {
  area(): number;
}
class Rectangle implements Shape { /* width and height */ }
class Square implements Shape { /* side length */ }
```

**When it applies:**
- Any inheritance hierarchy -- subclasses must honor the parent contract
- API versioning -- v2 endpoints should be backward-compatible with v1 consumers
- Database migrations -- new schema should not break existing queries

**When it is wrong:**
- When you do not use inheritance at all (functional/compositional styles)
- LSP is about behavioral contracts, not just type signatures

---

### I -- Interface Segregation Principle (ISP)

**Definition:** No client should be forced to depend on interfaces it does not use. Prefer many small, specific interfaces over one large, general one.

**Practical example:**
```typescript
// BAD: Forcing all users to implement everything
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
}

// GOOD: Separate interfaces for separate concerns
interface Workable { work(): void; }
interface Eatable { eat(): void; }

class HumanWorker implements Workable, Eatable { /* ... */ }
class RobotWorker implements Workable { /* robots don't eat */ }
```

**When it applies:**
- API design -- do not force clients to send/receive data they do not need
- Component props -- do not pass 20 props when the component only uses 3
- Service interfaces -- microservices should expose focused endpoints

**When it is wrong:**
- When splitting interfaces creates too many tiny contracts that are always used together
- When the overhead of managing many interfaces exceeds the benefit

---

### D -- Dependency Inversion Principle (DIP)

**Definition:** High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Practical example:**
```typescript
// BAD: Business logic directly depends on PostgreSQL
class OrderService {
  private db = new PostgresClient(); // Tightly coupled
  async createOrder(data: OrderData) {
    await this.db.query('INSERT INTO orders...');
  }
}

// GOOD: Business logic depends on an abstraction
interface OrderRepository {
  save(order: Order): Promise<void>;
}

class OrderService {
  constructor(private repo: OrderRepository) {} // Injected
  async createOrder(data: OrderData) {
    await this.repo.save(new Order(data));
  }
}

// Implementations can be swapped
class PostgresOrderRepo implements OrderRepository { /* ... */ }
class InMemoryOrderRepo implements OrderRepository { /* for testing */ }
```

**When it applies:**
- Any time you want testability (swap real DB for in-memory mock)
- When you might change infrastructure later (switch from Postgres to MongoDB)
- Hexagonal/clean architecture -- the domain should never import from infrastructure

**When it is wrong:**
- Trivial scripts or one-off tools where abstraction adds zero value
- When the abstraction layer becomes so generic it hides what is actually happening

---

## DRY, KISS, YAGNI

These three principles complement SOLID but operate at a different level. They guide day-to-day coding decisions rather than architectural structure.

---

### DRY -- Don't Repeat Yourself

**What it means:** Every piece of knowledge should have a single, authoritative representation in your codebase.

**When it applies:**
- Business logic duplicated across multiple files
- Validation rules copied between frontend and backend
- Configuration values hardcoded in multiple places
- Database queries that appear in 5 different services

**When DRY is WRONG:**
- **When two pieces of code look similar but serve different purposes.** Forcing them into a shared abstraction creates coupling between unrelated concerns. If one changes, the other breaks.
- **Martin Fowler's Rule of Three:** Do not abstract until you have at least 3 duplications. Two similar blocks might diverge later.
- **Premature DRY creates wrong abstractions.** A wrong abstraction is more expensive than duplication. Duplication is far cheaper than the wrong abstraction.
- **Cross-boundary DRY is dangerous.** Sharing types or validation between frontend and backend creates deployment coupling. Sometimes deliberate duplication keeps systems independent.

**Evaluation question:** "If I change this logic, should the other place change too?" If yes -> DRY it. If no -> leave the duplication.

---

### KISS -- Keep It Simple, Stupid

**What it means:** Prefer simple, straightforward solutions. Avoid unnecessary complexity.

**When it applies:**
- Choosing a simple function over a class hierarchy
- Using a flat data structure instead of deeply nested objects
- Writing readable code over clever code
- Picking well-known tools over custom solutions

**When KISS is WRONG:**
- **Simple is not the same as easy.** Simple means fewer moving parts, not less effort. A well-designed system can be simple but hard to build.
- **Some problems are inherently complex.** Distributed systems, real-time collaboration, financial calculations -- these require sophisticated solutions. Oversimplifying them creates bugs.
- **KISS does not mean "avoid all abstractions."** The right abstraction simplifies the system. No abstractions means everything is concrete and tightly coupled.

**Evaluation question:** "Does this complexity earn its keep?" If the complexity solves a real problem or prevents a real failure mode, it is justified. If it is there "just in case" or "because it is the proper way," question it.

---

### YAGNI -- You Ain't Gonna Need It

**What it means:** Do not build features or infrastructure until you actually need them. Do not code for hypothetical future requirements.

**When it applies:**
- Adding a caching layer before you have performance problems
- Building a plugin system before anyone has asked for plugins
- Creating an abstraction "in case we switch databases"
- Adding configuration options that nobody has requested

**When YAGNI is WRONG:**
- **Security and observability are not optional.** Authentication, logging, and error handling are needed from day one -- do not defer them.
- **Some architectural decisions are expensive to change later.** Database schema design, API versioning strategy, and deployment topology should be thought through early.
- **YAGNI can stifle necessary foundations.** If you build an MVP with zero modularity, adding features later becomes exponentially harder. Basic structure is not premature.

**Evaluation question:** "Is there a concrete, current requirement for this?" If yes, build it. If "we might need it someday," do not build it yet.

---

## Separation of Concerns (SoC)

**Definition:** Divide a complex system into smaller modules with clear responsibilities and interfaces. Each module should address a single concern.

### How SoC manifests at different levels:

| Level | Concern Separation |
|-------|-------------------|
| **Function** | Each function does one thing |
| **Module** | Each file/module owns one domain concept |
| **Layer** | Presentation / Business Logic / Data Access |
| **Service** | Each microservice owns one bounded context |
| **System** | Frontend / Backend / Database / Message Queue |

### Martin Fowler's Layering Principles (from the 2005 workshop):
1. Low coupling between layers, high cohesion within them
2. Layers should be agnostic of consumers (a layer should not know who is on top of it)
3. Inbound external interface modules should not contain business logic
4. Separation of concerns guides how systems are decomposed

### Practical application:
```
// Layered separation in a web app
src/
  routes/          # HTTP concern (parsing requests, sending responses)
  controllers/     # Orchestration concern (calling services, handling errors)
  services/        # Business logic concern (rules, calculations, workflows)
  repositories/    # Data access concern (queries, ORM calls)
  models/          # Data shape concern (types, schemas, validation)
```

---

## Coupling vs. Cohesion

These are the two most important metrics for evaluating any software design.

### Coupling (lower is better)

**Definition:** The degree of mutual interdependence between modules. Coupling is the probability that code unit "B" will break after an unknown change to code unit "A."

**Types of coupling (worst to best):**

| Type | Description | Example |
|------|-------------|---------|
| **Content coupling** | One module modifies another's internals | Direct global state mutation |
| **Common coupling** | Modules share global state | Multiple services reading/writing same DB table directly |
| **Control coupling** | One module controls another's behavior via flags | Passing `isAdmin` flag that changes function logic |
| **Stamp coupling** | Modules share a complex data structure | Passing an entire User object when only `name` is needed |
| **Data coupling** | Modules share only necessary data | Passing just the `userId` string |
| **Message coupling** | Modules communicate through messages | Event-driven with published events |

**How to reduce coupling:**
- Use interfaces/abstractions between modules (DIP)
- Communicate through events instead of direct calls
- Pass only the data needed, not entire objects
- Use dependency injection instead of direct imports of implementations

### Cohesion (higher is better)

**Definition:** The degree to which elements within a module belong together. A cohesive module has elements that are all related to a single, well-defined purpose.

**Types of cohesion (worst to best):**

| Type | Description | Example |
|------|-------------|---------|
| **Coincidental** | Elements grouped randomly | A "Utils" file with unrelated helpers |
| **Logical** | Elements do similar things but are unrelated | All validators in one file (user, payment, order) |
| **Temporal** | Elements are used at the same time | All initialization code in one function |
| **Procedural** | Elements follow a sequence | A function that validates, saves, then emails |
| **Communicational** | Elements operate on the same data | All functions that operate on a User |
| **Sequential** | Output of one is input to the next | Data pipeline stages |
| **Functional** | All elements contribute to a single task | A `calculateShippingCost()` function |

**How to evaluate cohesion:** Look at a module's imports. If it imports from many unrelated domains, its cohesion is low. If all its imports are from the same domain, cohesion is high.

---

## Principles Applied Together: A Decision Framework

When making architectural decisions, apply these principles in this order:

1. **SoC first:** What are the distinct concerns? How should they be separated?
2. **SOLID for structure:** How should each concern be organized internally?
3. **Coupling/cohesion for evaluation:** Does this design minimize coupling and maximize cohesion?
4. **KISS for implementation:** What is the simplest way to implement this design?
5. **YAGNI for scope:** Am I building more than what is currently needed?
6. **DRY for maintenance:** Where is knowledge duplicated that should not be?

---

## Planner's Application

When writing blueprints, Planner uses these principles to:

1. **Define module boundaries.** Every module in the blueprint should have a clear, single responsibility. If you cannot describe a module's purpose in one sentence, it needs splitting.

2. **Specify interfaces between modules.** The blueprint should define how modules communicate -- through interfaces, events, or direct calls -- and justify the choice based on coupling analysis.

3. **Apply SOLID at the architecture level:**
   - SRP: Each service/module owns one domain concept
   - OCP: The system should be extensible at planned extension points
   - LSP: API versions must be backward-compatible
   - ISP: APIs should expose focused endpoints, not monolithic ones
   - DIP: Business logic should not depend on infrastructure details

4. **Use YAGNI to scope the blueprint.** Only design what is needed now. Mark future considerations as "potential extensions" -- not "requirements." Annotate where the architecture allows future growth without specifying the growth.

5. **Evaluate the design with coupling/cohesion.** Before finalizing a blueprint, ask: "If Feature X changes, how many modules are affected?" If too many, the coupling is too high. Redesign the boundaries.

6. **Choose the right level of abstraction.** For an MVP, direct function calls with basic separation are fine. For a production system with multiple teams, interfaces, dependency injection, and event-driven communication are worth the upfront cost. The blueprint should match the abstraction level to the project's maturity and team size.

7. **Document the "why" not just the "what."** The blueprint should explain: "We use DIP here because we anticipate switching from PostgreSQL to DynamoDB in Phase 2" -- not just "use an interface for the repository."
