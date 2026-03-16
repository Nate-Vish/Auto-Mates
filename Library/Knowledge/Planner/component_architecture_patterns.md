# Component Architecture Patterns
**Category:** Architecture
**Sources:**
- https://blog.bytebytego.com/p/monolith-vs-microservices-vs-modular
- https://www.javacodegeeks.com/2025/12/microservices-vs-modular-monoliths-in-2025-when-each-approach-wins.html
- https://www.fullstack.com/labs/resources/blog/modular-monolithic-vs-microservices
- https://getdx.com/blog/monolithic-vs-microservices/
- https://www.scalosoft.com/blog/monolithic-vs-microservices-architecture-pros-and-cons-for-2025/
- https://musesofareticenttechie.blog/2025/08/25/breaking-the-monolith-in-2025-microservices-vs-modular-monolith/
- https://www.sayonetech.com/blog/domain-driven-design-microservices/
- https://www.aalpha.net/blog/hexagonal-architecture/
- https://www.geeksforgeeks.org/system-design/domain-driven-design-ddd/
- https://www.growin.com/blog/event-driven-architecture-scale-systems-2025/
- https://dev.to/rajkundalia/demystifying-domain-driven-design-ddd-principles-practice-relevance-in-modern-software-1k60
- https://sensiolabs.com/blog/2024/understanding-domain-driven-design
- https://profy.dev/article/react-folder-structure
- https://www.robinwieruch.de/react-folder-structure/
- https://github.com/alan2207/bulletproof-react/blob/master/docs/project-structure.md
- https://asrulkadir.medium.com/3-folder-structures-in-react-ive-used-and-why-feature-based-is-my-favorite-e1af7c8e91ec

**Last updated:** 2026-03-01

---

## System Architecture Tiers

The first architectural decision for any project is the deployment architecture -- monolith, modular monolith, or microservices. This decision impacts everything downstream: team structure, deployment pipeline, database strategy, and development velocity.

---

## Monolith vs. Modular Monolith vs. Microservices

### The Decision Matrix

| Factor | Monolith | Modular Monolith | Microservices |
|--------|----------|------------------|---------------|
| **Team size** | 1-10 developers | 5-30 developers | 10+ developers |
| **Project stage** | MVP / early startup | Growing product | Mature, scaled product |
| **Deployment** | Single unit | Single unit | Independent per service |
| **Database** | Single shared DB | Single DB, module-scoped schemas | DB per service |
| **Scalability** | Scale the whole app | Scale the whole app (targeted via modules later) | Scale individual services |
| **Operational complexity** | Low | Low-Medium | High |
| **DevOps required** | Minimal | Minimal | Robust (service discovery, tracing, monitoring) |
| **Communication** | Function calls | Function calls within process | Network calls (HTTP, gRPC, messages) |
| **Time to first feature** | Fastest | Fast | Slowest |
| **Cost** | Lowest | Low | Highest |

---

### Monolith -- When Simplicity Wins

**Choose when:**
- Building an MVP or early-stage startup
- Team is fewer than 10 developers
- The problem domain is well-understood and straightforward
- Speed to market matters more than architectural purity
- You are building a simple CRUD system, admin panel, or internal tool

**Strengths:**
- Single codebase, single deployment, single database
- Easy debugging -- everything is in one process
- No network latency between components
- Simple end-to-end testing
- New developer onboarding is fast

**Weaknesses:**
- Any small change requires redeploying the entire app
- As the codebase grows, build times increase and code becomes tangled
- Scaling means scaling everything, even parts that do not need it
- A single bug can bring down the entire application

**Real-world example:** GitHub's core application remains a Ruby on Rails monolith, serving millions of developers daily.

---

### Modular Monolith -- The Sweet Spot for Most Teams (2025)

**Choose when:**
- Your product is growing beyond MVP
- You want microservice-like modularity without the operational overhead
- Your team is 5-30 developers and growing
- You might migrate to microservices later but do not need to now
- You want clear domain boundaries without network complexity

**Strengths:**
- Deployed as one unit (simple ops) but organized as independent modules
- Each module has clear boundaries, its own models, services, and API
- Communication happens within the same process (no network overhead)
- Individual modules can be extracted into microservices when needed
- Enforces architectural discipline without distributed systems complexity

**Weaknesses:**
- Requires strict discipline to maintain module boundaries
- Without enforcement (linting rules, architecture tests), boundaries erode over time
- Still scales as a single unit (cannot scale modules independently)
- All modules share the same runtime -- one module's memory leak affects all

**Real-world example:** Shopify runs as a modular monolith, extracting microservices only for specific needs like checkout and fraud detection.

**Implementation structure:**
```
src/
  modules/
    orders/
      models/
      services/
      routes/
      events/
      index.ts        # Public API for this module
    payments/
      models/
      services/
      routes/
      events/
      index.ts
    users/
      models/
      services/
      routes/
      events/
      index.ts
  shared/              # Truly shared utilities, types, middleware
  infrastructure/      # Database, messaging, external service clients
```

**Critical rule:** Modules communicate only through their public APIs (the `index.ts` exports), never by importing internal files. This is what makes future extraction possible.

---

### Microservices -- When Scale Demands It

**Choose when:**
- Team is 10+ developers across multiple squads
- Different parts of the system need different scaling profiles
- Fault isolation is critical (one service crashing cannot take down others)
- Different services benefit from different technology stacks
- You need independent deployment cycles for different teams
- You have robust DevOps capabilities (CI/CD, monitoring, distributed tracing)

**Strengths:**
- Independent deployment -- teams ship without coordinating
- Independent scaling -- scale the hot path, not everything
- Technology flexibility -- use the best tool for each service
- Fault isolation -- one service failure does not cascade
- Team autonomy -- each team owns their service end-to-end

**Weaknesses:**
- Massive operational complexity (service discovery, load balancing, circuit breakers)
- Distributed debugging is hard (need distributed tracing: Jaeger, Zipkin)
- Data consistency across services requires eventual consistency patterns
- Network latency between services impacts performance
- Integration testing across services is challenging

**Key insight from 2025:** Microservices benefits only appear with teams larger than 10 developers. Below this threshold, monoliths consistently perform better. The overhead of managing distributed systems does not justify itself for small teams.

**Real-world examples:**
- Uber operates thousands of microservices (necessary for global scale)
- Amazon Prime Video moved back from microservices to a monolith for their video monitoring tool (the overhead was not justified for that use case)

---

### The Evolution Path

The recommended progression for most startups:

```
Monolith (MVP) --> Modular Monolith (growth) --> Selective Microservices (scale)
```

Do not start with microservices. Start with the simplest thing that works and evolve when real constraints demand it.

---

## Folder Structure Patterns

How you organize files within an application has a significant impact on developer productivity, onboarding speed, and maintenance cost.

### Layer-Based (Type-Based) Structure

Files grouped by technical role.

```
src/
  components/         # All UI components
  hooks/              # All custom hooks
  services/           # All API/business logic
  utils/              # All utility functions
  types/              # All TypeScript types
  pages/              # All page components
```

**Best for:** Small projects (<30 components), prototypes, or projects where the domain is simple and features are few.

**Breaks down when:** The `components/` folder has 50+ files, finding related code requires jumping across 5 directories, and changes to one feature touch 6 different folders.

**Scales effectively until:** Approximately 30-50 components. Beyond that, adopt feature-based structure.

---

### Feature-Based Structure

Files grouped by business domain or feature. Each feature is self-contained.

```
src/
  features/
    auth/
      components/     # Auth-specific components
      hooks/          # Auth-specific hooks
      api/            # Auth API calls
      types/          # Auth types
      utils/          # Auth utilities
      index.ts        # Public exports
    dashboard/
      components/
      hooks/
      api/
      types/
      index.ts
    billing/
      components/
      hooks/
      api/
      types/
      index.ts
  shared/
    components/       # Truly shared components (Button, Modal, etc.)
    hooks/            # Truly shared hooks
    utils/            # Truly shared utilities
    types/            # Truly shared types
```

**Best for:** Medium-to-large applications, teams with 3+ developers, long-lived products with many features.

**Key benefits:**
- Related code is co-located -- changes to a feature touch one directory
- Teams can work on features independently with minimal conflicts
- New developers find code faster (look in the feature folder, not 6 technical folders)
- Features are easier to delete (remove the whole folder)
- Natural alignment with domain-driven design bounded contexts

**Guidelines:**
- Limit directory nesting to 3-4 levels maximum to avoid import path nightmares
- Shared code goes in `shared/`, not duplicated across features
- Each feature folder has an `index.ts` that defines its public API
- If a component is used by only one feature, it belongs in that feature folder

---

## Domain-Driven Design (DDD) Basics

DDD is a methodology for structuring complex software around the problem domain rather than technical layers. For web applications, DDD provides the intellectual framework for drawing boundaries between modules and services.

### Core Concepts

#### Ubiquitous Language
A shared vocabulary between developers and domain experts. If the business calls it an "Order," the code calls it an `Order` -- not a `Transaction`, `Purchase`, or `Record`.

**Why it matters for Planner:** Blueprints should use the same terms that the user and business stakeholders use. This prevents miscommunication between Planner, Builder, and the user.

#### Bounded Contexts
A semantic boundary within which a specific domain model is valid and consistent. Each bounded context has its own definition of entities.

**Example:** In an e-commerce system:
- **Order Context:** An `Order` has line items, shipping info, and payment status
- **Inventory Context:** An `Order` is just a reference ID that decrements stock
- **Shipping Context:** An `Order` is a package with dimensions, weight, and destination

Each context has its own `Order` -- and that is correct. Forcing them to share one `Order` model creates coupling.

#### Aggregates
A cluster of domain objects treated as a single unit for data changes. The aggregate root is the entry point.

**Example:** An `Order` aggregate contains `OrderLineItems`. You never modify a line item directly -- you go through the `Order` aggregate root:
```typescript
// GOOD: Through the aggregate root
order.addItem(product, quantity);
order.removeItem(lineItemId);

// BAD: Direct manipulation
lineItem.setQuantity(5); // Bypasses business rules
```

#### Domain Events
Immutable events that broadcast state transitions. They enable decoupled communication between bounded contexts.

**Example:** When an order is placed:
```
OrderPlacedEvent { orderId, items, timestamp }
  --> Inventory listens: decrements stock
  --> Shipping listens: creates shipment
  --> Email listens: sends confirmation
  --> Analytics listens: tracks conversion
```

Each listener is independent. Adding a new listener (e.g., loyalty points) requires no changes to the order module.

---

### Context Mapping

When bounded contexts need to interact, the relationship type matters:

| Relationship | Description | When to use |
|-------------|-------------|-------------|
| **Shared Kernel** | Contexts share a small common model | When two contexts are closely related and managed by one team |
| **Customer/Supplier** | One context provides what another needs | When one team depends on another's output |
| **Conformist** | Downstream context accepts upstream's model as-is | When you consume a third-party API |
| **Anti-Corruption Layer** | Downstream translates upstream's model to its own | When upstream's model would pollute your domain |
| **Published Language** | Contexts communicate through a shared protocol | REST APIs, event schemas, GraphQL |

---

## Event-Driven Architecture

Event-driven architecture (EDA) decouples components by having them communicate through events rather than direct calls. It pairs naturally with DDD's domain events.

### When to use EDA:
- Multiple consumers need to react to the same event
- Producer should not know about (or wait for) consumers
- Real-time features (notifications, live updates, collaborative editing)
- Audit trails and event sourcing
- Cross-service communication in microservices

### When NOT to use EDA:
- Simple request/response workflows where synchronous calls are clearer
- When you need immediate consistency (financial transactions)
- When the team does not have experience debugging async flows
- When there are only 1-2 consumers and direct calls are simpler

### Key Patterns:

**Pub/Sub (Publish/Subscribe):**
```
Publisher --> Event Bus --> Subscriber A
                       --> Subscriber B
                       --> Subscriber C
```

**Event Sourcing:**
Instead of storing current state, store all events that led to the current state. Rebuild state by replaying events.

**CQRS (Command Query Responsibility Segregation):**
Separate the write model (commands) from the read model (queries). Each is optimized for its purpose.

| Aspect | Commands | Queries |
|--------|----------|---------|
| Purpose | Change state | Read state |
| Optimization | Write throughput, consistency | Read performance, denormalization |
| Model | Normalized, validated | Denormalized, fast |
| Scale | Scale writes independently | Scale reads independently |

**When CQRS is justified:**
- Read and write workloads have dramatically different scaling needs
- Complex queries that are expensive on the write-optimized schema
- When you need different views of the same data for different consumers

**When CQRS is overkill:**
- Simple CRUD applications
- When reads and writes are balanced
- Small teams that do not want to maintain two models

---

## Hexagonal Architecture (Ports & Adapters)

Hexagonal architecture places the domain at the center, with all external concerns (database, APIs, UI) pushed to the edges through ports (interfaces) and adapters (implementations).

```
            [Web API Adapter]
                   |
                   v
            +-- PORT (in) --+
            |               |
            |   DOMAIN      |
            |   (business   |
            |    logic)     |
            |               |
            +-- PORT (out) -+
                   |
                   v
            [Database Adapter]
```

**When to use:**
- When testability is a priority (the domain has no infrastructure dependencies)
- When you anticipate changing infrastructure (database, message queue, etc.)
- When business logic is complex enough to justify the extra structure

**When NOT to use:**
- Simple CRUD apps where the domain logic is trivial
- Prototypes where speed matters more than architecture
- When the team is unfamiliar with the pattern (it has a learning curve)

---

## Architecture Decision Guide

Use this flowchart for selecting the right architecture:

```
Start
  |
  v
Is the team > 10 developers?
  YES --> Do you have robust DevOps?
            YES --> Microservices
            NO  --> Modular Monolith + invest in DevOps
  NO  --> Is the product beyond MVP?
            YES --> Modular Monolith
            NO  --> Monolith
  |
  v
Is the domain complex (many business rules)?
  YES --> Apply DDD (bounded contexts, aggregates)
  NO  --> Simple service/module separation is enough
  |
  v
Do multiple consumers react to the same events?
  YES --> Event-driven architecture
  NO  --> Direct calls are fine
  |
  v
Are read/write workloads dramatically different?
  YES --> Consider CQRS
  NO  --> Single model is fine
```

---

## Planner's Application

When writing blueprints, Planner uses this knowledge to:

1. **Choose the deployment architecture early and justify it.** The blueprint should state "Modular Monolith because the team is 4 developers and we need to ship in 8 weeks" -- not just "use a monolith." The reasoning matters for future decisions.

2. **Define module/service boundaries using DDD thinking.** Even if the project is a monolith, identify the bounded contexts. Name them. Define their responsibilities. This makes future decomposition possible.

3. **Specify folder structure in the blueprint.** Builder should not have to guess. For projects with 3+ features, specify feature-based structure. For simple tools, layer-based is fine.

4. **Choose communication patterns explicitly.** The blueprint should state whether modules communicate through direct function calls, events, or API calls -- and why.

5. **Plan the evolution path.** Every blueprint should include a "Future Architecture" section: "Phase 1: Monolith. Phase 2: Extract payment module as a service when we add more payment providers. Phase 3: Extract notifications when real-time becomes critical."

6. **Apply DDD language to the blueprint.** Use the business domain's language in the blueprint. If the user says "customers," the blueprint says "customers" -- not "users." This prevents the whole team from miscommunicating.

7. **Specify event contracts when using EDA.** If the blueprint calls for event-driven communication, define the event schemas: `OrderPlacedEvent { orderId: string, items: Item[], timestamp: Date }`. Builder needs this to implement correctly.
