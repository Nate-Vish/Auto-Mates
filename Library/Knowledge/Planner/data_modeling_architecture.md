---
title: "Data Modeling & Data Architecture for Software Architects"
category: "Architecture"
tags:
  - data-modeling
  - database-design
  - schema-design
  - data-flow
  - normalization
  - database-selection
  - architecture-patterns
  - blueprints
audience: "Software Architect / Solutions Architect"
scope: "Universal — stack-agnostic, platform-agnostic"
last_reviewed: 2026-03-05
---

# Data Modeling & Data Architecture for Software Architects

Data modeling is the architect's most consequential design decision. APIs change, UIs get rebuilt, deployment targets migrate — but the data model is the skeleton that everything else wraps around. Get it wrong and every team member fights the schema for the lifetime of the project. Get it right and the system almost designs itself.

This document covers universal principles. No specific ORM, no specific cloud provider, no specific framework.

---

## 1. Data Modeling Fundamentals

### What Data Modeling Is

Data modeling answers three questions:

1. **What data does the system store?** (entities and attributes)
2. **How does that data relate?** (relationships and constraints)
3. **How does that data flow?** (input, transformation, storage, retrieval, output)

A data model is not a database diagram. It is a precise description of the information the system knows, the rules that govern that information, and the paths that information travels.

### Three Levels of Data Modeling

#### Conceptual Model (For Stakeholders)

- **Purpose:** Communicate the domain in business language
- **Contains:** Entities, high-level relationships, business rules in plain language
- **Omits:** Data types, keys, indexes, platform details

```
Example — E-Commerce Conceptual Model:

  [Customer] ---places---> [Order]
  [Order] ---contains---> [Line Item]
  [Line Item] ---refers to---> [Product]
  [Product] ---belongs to---> [Category]
```

If a stakeholder cannot read it in under two minutes, it is too detailed.

#### Logical Model (For Blueprints)

- **Purpose:** Define the precise structure the system will implement
- **Contains:** Entities with attributes, abstract data types, PKs, FKs, cardinality, constraints, enumerations
- **Omits:** Index strategies, partition schemes, vendor-specific types

```
Example — Order Logical Model:

  Customer
    - customer_id (PK, UUID)
    - email (string, unique, required)
    - display_name (string, required)
    - status (enum: active, suspended, deleted)
    - created_at (timestamp)

  Order
    - order_id (PK, UUID)
    - customer_id (FK -> Customer, required)
    - status (enum: draft, placed, paid, shipped, delivered, cancelled)
    - total_amount (decimal, precision 2)
    - currency (string, ISO 4217)
    - placed_at (timestamp, nullable)
    - created_at (timestamp)

  Relationship: Customer 1 --- N Order
```

This is the model that belongs in the blueprint — implementation-agnostic but precise enough to build from.

#### Physical Model (For Builder)

- **Purpose:** Specify exact implementation on a specific platform
- **Contains:** Table names, vendor-specific column types, indexes, constraints, triggers, partitioning
- **Artifact:** DDL scripts or migration files

The architect produces conceptual and logical models. The physical model is either produced by the architect for critical tables or delegated to the builder.

### Entity-Relationship Basics

**Entities** are things the system knows about, each with an identity and attributes. Test: "Can I point to a specific instance and say 'this one, not that one'?" If yes, it is an entity.

**Attributes** describe an entity. Each has a name, type, constraints (required? unique? default?), and sensitivity classification (PII? financial? medical?).

**Relationships and Cardinality:**

| Type | Notation | Example | Implementation |
|------|----------|---------|----------------|
| One-to-One | 1:1 | User has one Profile | FK on either side, unique constraint |
| One-to-Many | 1:N | Customer has many Orders | FK on the "many" side |
| Many-to-Many | M:N | Student enrolls in Courses | Join table with FKs to both sides |

Always specify minimum cardinality (0 = optional, 1 = required) and maximum (1 or N).

---

## 2. Normalization Decisions

Normalization organizes data to reduce redundancy and protect integrity. The architect must understand it deeply — not to apply it dogmatically, but to make informed trade-offs.

### Normal Forms — The Practical Version

#### First Normal Form (1NF): Atomic Values, No Repeating Groups

Every column holds a single value. No arrays, no comma-separated lists, no "phone1, phone2, phone3" columns.

**Violation:**
```
| customer_id | name  | phone_numbers          |
|-------------|-------|------------------------|
| 1           | Alice | 555-0100, 555-0101     |
```

**Fixed (1NF):**
```
Customer:
| customer_id | name  |
|-------------|-------|
| 1           | Alice |

Phone:
| phone_id | customer_id | number   | type   |
|----------|-------------|----------|--------|
| 1        | 1           | 555-0100 | mobile |
| 2        | 1           | 555-0101 | work   |
```

1NF violations are the most common data modeling mistake. They seem harmless ("it's just a comma-separated list") but they make querying, updating, and validating that data progressively harder over time.

#### Second Normal Form (2NF): No Partial Dependencies

Every non-key attribute depends on the *entire* primary key. Only matters for composite keys.

**Violation (composite key: order_id + product_id):**
```
| order_id | product_id | quantity | product_name | product_price |
```

`product_name` and `product_price` depend only on `product_id`, not on the full key. If you update a product's name, you must update every row in every order that contains it.

**Fix:** Separate Product table for product attributes.

#### Third Normal Form (3NF): No Transitive Dependencies

Non-key attributes do not depend on other non-key attributes.

**Violation:**
```
| employee_id | department_id | department_name | department_budget |
```

`department_name` and `department_budget` depend on `department_id`, not on `employee_id`. A change to a department's budget requires updating every employee row in that department.

**Fix:** Move department attributes to a Department table. The employee table holds only `department_id` as a foreign key.

### When to Normalize vs Denormalize

**Normalize when:** Data integrity is critical (financial, healthcare). Write-heavy system. Complex domain with many relationships. Multiple apps share the database. Schema will live for years.

**Denormalize when:** Read performance dominates (dashboards, analytics). Data is a materialized view. Storage is a document store. Data is immutable (event logs, audit trails). The use case is a cache.

### The Core Trade-Off

```
Normalization buys:               Denormalization buys:
  - Data integrity                  - Read performance
  - Write efficiency                - Query simplicity
  - Storage efficiency              - Fewer joins
  - Flexibility for new queries     - Predictable latency
  - Single source of truth          - Self-contained documents
```

**Decision rule:** Normalize by default. Denormalize specific read paths when you have measured evidence. Never denormalize speculatively.

---

## 3. Database Selection for Architects

Choose based on access patterns, not popularity.

### Database Types at a Glance

| Type | Examples | Choose When | Strengths | Watch Out For |
|------|----------|-------------|-----------|---------------|
| **Relational** | PostgreSQL, MySQL, SQLite | Structured data, complex queries, ACID needed, diverse query patterns | Decades of optimization, rich SQL, strong consistency | Horizontal scaling needs engineering, schema changes on large tables are slow |
| **Document** | MongoDB, Firestore, CouchDB | Flexible/nested data, schema evolves often, self-contained documents | Flexible schema, maps to app objects, horizontal scaling | No joins, weak consistency by default, app must enforce referential integrity |
| **Key-Value** | Redis, DynamoDB, Memcached | Simple get/set by key, caching, sessions, sub-ms latency | Fastest reads/writes, predictable performance | No complex queries, no relationships, no aggregations |
| **Graph** | Neo4j, Neptune, ArangoDB | Highly connected data, relationship traversal, social/recommendation | O(1) per hop traversal, intuitive for connected data | Not for tabular data, smaller ecosystem, learning curve |
| **Time-Series** | InfluxDB, TimescaleDB, QuestDB | Timestamped append-only data, time-range queries, metrics/IoT | Optimized for time queries, built-in retention, high write throughput | Poor at random access by non-time keys |
| **Vector** | Pinecone, pgvector, Weaviate | AI/ML embeddings, similarity search, RAG systems | Efficient nearest-neighbor search, high-dimensional data | Young ecosystem, limited querying beyond similarity |

### Decision Framework

Ask these questions, in order:

1. **What are the primary access patterns?** (CRUD? Aggregation? Graph traversal? Time-range? Similarity?)
2. **What consistency guarantees are required?** (Strong? Eventual? Per-operation choice?)
3. **What are the latency requirements?** (Sub-millisecond? Under 100ms? Seconds are fine?)
4. **What is the expected data volume?** (Megabytes to petabytes?)
5. **What is the write vs read ratio?**
6. **How structured is the data?** (Rigid schema? Semi-structured? Unstructured?)
7. **What is the team's expertise?** (A database nobody understands is a liability.)

### Multi-Database Architectures

| Primary | Secondary | Use Case |
|---------|-----------|----------|
| PostgreSQL | Redis | Relational storage + caching |
| PostgreSQL | Elasticsearch | Transactional data + full-text search |
| PostgreSQL | InfluxDB | Application data + metrics/monitoring |
| PostgreSQL | pgvector (extension) | Application data + AI embeddings in one system |

Every additional database adds operational complexity (backups, monitoring, failover, expertise). Add one only when the primary provably cannot handle a specific access pattern.

### The "Start with PostgreSQL" Rule

PostgreSQL handles relational data, JSON documents (jsonb), full-text search (tsvector), time-series (TimescaleDB extension), vector embeddings (pgvector extension), and key-value patterns (hstore/jsonb). It covers 90% of use cases. Only add a second database when you can articulate a specific, measured limitation PostgreSQL cannot overcome.

This is not advocacy — it is pragmatism: reduce moving parts until complexity is justified.

---

## 4. Data Flow Architecture

A data model is static. Data flow describes how data moves through the system over time.

### The Data Lifecycle

```
Input --> Validation --> Processing --> Storage --> Retrieval --> Output
  |           |             |            |            |           |
  Sources   Reject if    Transform,   Persist to   Query,      Format
            invalid      enrich,      durable      filter,     and
                         derive       store        aggregate   deliver
```

The architect defines this flow for each major entity: where it enters, what validation occurs, what transformations happen, where it is stored, how it is retrieved, and in what format it leaves.

### Synchronous vs Asynchronous

**Synchronous:** The caller waits for the operation to complete.

```
Client --> API --> Validate --> Write to DB --> Return response
                                                (caller waited)
```

Use when the caller needs confirmation that the operation succeeded, for user-facing operations where feedback is expected immediately, and for simple request-response patterns.

**Asynchronous:** The caller submits work and receives an acknowledgment. Processing happens later.

```
Client --> API --> Enqueue message --> Return "accepted" immediately
                        |
                        v
               Worker picks up message --> Process --> Write to DB
```

Use when processing is slow (email, reports, image processing), the caller does not need the result immediately, you need to absorb traffic spikes (queue acts as buffer), or operations should be retried on failure.

### Event-Driven Architecture

#### Event Sourcing

Instead of storing the current state, store the sequence of events that produced that state.

```
Traditional:  Account balance = $500  (current state)

Event Sourced:
  1. AccountOpened   { amount: $0 }
  2. MoneyDeposited  { amount: $1000 }
  3. MoneyWithdrawn  { amount: $300 }
  4. MoneyWithdrawn  { amount: $200 }
  Current balance derived by replaying: $0 + $1000 - $300 - $200 = $500
```

**Benefits:** Complete audit trail, ability to reconstruct state at any point in time, temporal queries ("what was the balance on March 1st?").

**Costs:** Increased complexity, eventually consistent read models, event schema evolution is tricky.

**Use when:** Audit trails are mandatory, you need temporal queries, the domain naturally fits (financial transactions, order lifecycle, document editing).

#### CQRS (Command Query Responsibility Segregation)

Separate the write model (commands) from the read model (queries). Write to a normalized transactional store, read from a denormalized read-optimized store.

```
Commands --> Write Model (normalized, transactional)
                |
                v (project events or changes)
Queries  <-- Read Model (denormalized, optimized for specific queries)
```

**Use when:** Read and write patterns are dramatically different. Read-heavy systems where write normalization and read denormalization both matter. Often paired with event sourcing.

### Message Queues and Event Buses

| Pattern | Use Case |
|---------|----------|
| Point-to-point queue | One producer, one consumer, guaranteed delivery |
| Publish-subscribe | One producer, many consumers, broadcast |
| Fan-out | One event triggers multiple independent workflows |

Introduce a queue when: producers and consumers must deploy independently, processing should not block the caller, you need retry logic, traffic is spiky, or multiple consumers react to the same event.

**Warning:** Queues add operational complexity and eventual consistency. Add one when synchronous processing demonstrably cannot meet requirements.

### Data Pipeline Patterns

**ETL (Extract, Transform, Load):** Transform before loading. Use when the destination has a strict schema or transformation is complex.

**ELT (Extract, Load, Transform):** Load raw, transform in place. Use when the destination has powerful processing (modern data warehouses) or transformation logic changes frequently.

**Batch vs Streaming:** Batch has minutes-to-hours latency, lower complexity and cost. Streaming has seconds-to-milliseconds latency, higher complexity and cost. Choose streaming only when real-time is a genuine requirement.

### Caching Strategies

| Strategy | How It Works | Trade-Off |
|----------|-------------|-----------|
| **Cache-Aside** | Check cache; on miss, read DB, populate cache | First request after miss is slow; stale if invalidation fails |
| **Write-Through** | Write to cache AND DB simultaneously | Higher write latency; cache always fresh |
| **Write-Behind** | Write to cache, flush to DB asynchronously | Fastest writes; risk of data loss if cache fails |

**Cache Invalidation** (the hardest problem):
1. **Time-based (TTL):** Expires after N seconds. Simple, but stale for up to TTL.
2. **Event-based:** Invalidate on data change. Precise, but requires coordination.
3. **Version-based:** Cache key includes version number. Old entries naturally abandoned.

**Rule:** If you cannot clearly explain the invalidation strategy, do not add the cache.

---

## 5. Schema Design Patterns

Recurring patterns the architect should know and specify in blueprints.

### Soft Deletes vs Hard Deletes

**Soft delete** (`deleted_at` timestamp): Recovery is trivial, audit trail preserved, but every query must filter `WHERE deleted_at IS NULL` and the database grows forever.

**Hard delete** (row removed): Clean data, simpler queries, but data is gone and foreign key cascades must be handled.

**Recommendation:** Soft deletes for business-critical entities (users, orders, documents). Hard deletes for transient data (sessions, temp files, expired tokens). Specify per entity in the blueprint.

### Audit Trail Columns

Every mutable entity needs at minimum:

```
created_at   TIMESTAMP  NOT NULL  DEFAULT now()
updated_at   TIMESTAMP  NOT NULL  DEFAULT now()  -- updated on every write
```

For systems where accountability matters, add:

```
created_by   UUID       NOT NULL  -- FK to user who created
updated_by   UUID       NOT NULL  -- FK to user who last modified
```

For full audit history, consider a separate audit log table:

```
audit_log:
  - id (PK)
  - entity_type (string: "order", "customer")
  - entity_id (UUID)
  - action (enum: created, updated, deleted)
  - changed_fields (JSON: { "status": { "from": "draft", "to": "placed" } })
  - performed_by (FK -> User)
  - performed_at (timestamp)
```

### Polymorphic Associations

When multiple entity types relate to the same child (e.g., both Users and Organizations can have Comments):

| Approach | Pro | Con |
|----------|-----|-----|
| **Type + ID columns** (`commentable_type`, `commentable_id`) | Single table, simple queries | No FK enforcement; app must enforce integrity |
| **Separate FK columns** (nullable `user_id`, `organization_id` with CHECK) | Real FKs, DB-enforced integrity | Columns grow with parent types; sparse NULLs |
| **Separate join tables** (`user_comments`, `org_comments`) | Full referential integrity, clean schema | More tables, more joins |

**Recommendation:** 2-3 parent types: separate FK columns. Many parent types: join tables. Avoid type + ID in relational databases unless the team has strong conventions for app-level integrity.

### JSON Columns

**Good uses:** Configuration blobs, user preferences, variable metadata, integration payloads stored for debugging.

**Bad uses:** Data you query/filter by regularly, data you aggregate/report on, data with consistent structure across all rows, relationships.

**Test:** If you would put a WHERE clause on it, it should be a column. If you would never filter or aggregate by it, JSON is fine.

### Primary Key Strategy

| Strategy | Advantages | Disadvantages | Use When |
|----------|-----------|---------------|----------|
| **Auto-increment** | Small, fast, human-readable, ordered | Exposes count/order, unsafe for distributed, enumeration risk in URLs | Single DB, internal-only IDs |
| **UUID v4** | Globally unique, safe in URLs, reveals nothing | Larger (16 bytes), random causes index fragmentation | IDs in URLs/APIs, distributed systems |
| **UUID v7** | All UUID benefits + time-ordered | Larger than integers | High-insert performance + distributed |

### Multi-Tenancy Patterns

| Factor | Shared schema + tenant_id | Separate schemas | Separate databases |
|--------|--------------------------|------------------|--------------------|
| Tenant count | Hundreds to millions | Tens to hundreds | Tens |
| Isolation | Low-medium | Medium-high | Maximum |
| Operational cost | Low | Medium | High |
| Custom schema/tenant | No | Yes | Yes |
| Regulatory compliance | May not suffice | Often sufficient | Always sufficient |

**Shared + tenant_id** is simplest. Mitigate data leakage risk with row-level security (e.g., PostgreSQL RLS). **Separate schemas** give strong isolation but schema management scales poorly. **Separate databases** give maximum isolation at highest operational cost.

### Pagination Patterns

**Offset-based** (`LIMIT 20 OFFSET 40`): Simple, supports "jump to page N." Performance degrades for large offsets; inconsistent if data changes between requests.

**Cursor-based** (`WHERE created_at < ?cursor? LIMIT 20`): Consistent performance at any depth, stable results. Cannot jump to arbitrary page; requires stable sort key.

**Recommendation:** Cursor-based for APIs and feeds. Offset-based only for admin interfaces with bounded datasets.

---

## 6. Data Modeling in Blueprints

The data model section is the most referenced part of a blueprint. It must be precise and complete.

### Entity List with Attributes

For each entity, specify:

```
## Entity: Order

Description: A customer's request to purchase products.

| Attribute    | Type          | Constraints              | Notes                       |
|-------------|---------------|--------------------------|------------------------------|
| order_id    | UUID          | PK                       | Generated on creation        |
| customer_id | UUID          | FK -> Customer, required | The buyer                    |
| status      | enum          | required                 | draft, placed, paid, shipped, delivered, cancelled |
| total       | decimal(10,2) | required, >= 0           | Calculated from line items   |
| currency    | string(3)     | required                 | ISO 4217 code                |
| placed_at   | timestamp     | nullable                 | Set when status -> placed    |
| created_at  | timestamp     | required, auto           |                              |
| updated_at  | timestamp     | required, auto           |                              |
| deleted_at  | timestamp     | nullable                 | Soft delete                  |

Relationships:
- belongs to Customer (required, 1:N)
- has many LineItem (required, at least 1 when placed)

Indexes:
- customer_id (for "my orders" queries)
- status + created_at (for order management dashboard)
```

### Data Flow Diagram

Show how data enters, moves through, and exits the system:

```
Data Flow: Order Placement

  Customer (UI) --> POST /orders --> API validates request
                                         |
                                   Writes to: orders, line_items tables
                                         |
                                   Publishes: OrderPlaced event
                                         |
                          +--------------+--------------+
                          |                             |
                   Inventory Service             Notification Service
                   (reserves stock)              (sends confirmation)
```

### Storage Estimates

```
| Entity    | Avg Row Size | Rows/Year  | Storage/Year |
|-----------|-------------|------------|--------------|
| Customer  | 500 bytes   | 120,000    | 60 MB        |
| Order     | 300 bytes   | 600,000    | 180 MB       |
| LineItem  | 200 bytes   | 1,800,000  | 360 MB       |
| AuditLog  | 400 bytes   | 2,400,000  | 960 MB       |
```

Formula: `rows_per_year x avg_row_bytes x index_overhead_multiplier (typically 1.3-1.5x) = storage_per_year`

### Migration Strategy

Every blueprint should specify:

1. **Migration tool:** What will manage schema changes? (Framework migrations, raw SQL scripts, a specific library)
2. **Versioning:** How are migrations versioned? (Timestamp-based, sequential numbering)
3. **Rollback policy:** Can migrations be rolled back? Under what conditions?
4. **Zero-downtime requirements:** Must migrations run without taking the application offline?
5. **Data migration:** When schema changes require data transformation, how is that handled?

```
Migration Strategy Example:
- Tool: Framework-provided migration system
- Versioning: Timestamp-based (YYYYMMDDHHMMSS_description)
- Rollback: All migrations must include a rollback step
- Zero-downtime: Required for production
  - No DROP COLUMN in a single migration (deprecate, then remove)
  - No table renames (create new, migrate, drop old)
  - Add columns as nullable first, backfill, then add NOT NULL constraint
- Data migration: Separate files for schema changes and data changes
```

### Seed Data and Test Data

```
Seed Data:
- Default roles: admin, manager, member, viewer
- Default currencies: USD, EUR, GBP
- System user for automated actions

Test Data Strategy:
- Factory/fixture definitions for each entity
- Realistic data (not "test123", "foo", "bar")
- Minimum: 3 customers, 10 orders, 30 line items
- Performance: 100K customers, 1M orders (load testing)
```

---

## 7. Common Data Modeling Mistakes

### Designing the Database Around the UI

**The mistake:** Looking at wireframes and creating one table per screen, with columns matching form fields.

**Why it is wrong:** UIs change constantly. The data model should reflect the domain, not the current interface. A "profile page" is not a database table. A "user" is a database entity whose attributes might appear on many different screens.

**The fix:** Model the domain first. Map UI to the data model second. Multiple screens can read from and write to the same entities.

### No Foreign Keys

**The mistake:** Storing related IDs as plain integers or strings without foreign key constraints, in the name of "flexibility" or "performance."

**Why it is wrong:** Without foreign keys, the database cannot prevent orphaned records. A line item can reference an order that does not exist. A comment can reference a user that was deleted. The application must enforce integrity perfectly, forever, across all code paths. It will not.

**The fix:** Use foreign keys. The performance overhead is negligible for nearly all workloads. If you genuinely need to skip foreign keys (multi-database architectures, extreme write throughput), document the alternative integrity strategy in the blueprint.

### God Tables

**The mistake:** One table with 50+ columns that represents multiple concepts. An "events" table that stores user signups, purchases, page views, and system errors with most columns NULL for most rows.

**Why it is wrong:** Queries become complex, indexes become enormous, each row wastes storage on NULL columns, and no developer can understand the table without tribal knowledge.

**The fix:** Separate entities into their own tables. If a group of columns is only populated for a subset of rows, that subset is a different entity.

### Storing Computed Data as Source of Truth

**The mistake:** Storing a value that can be derived from other data and treating it as authoritative. Example: storing `order_total` as a column that is manually set, rather than computing it from `SUM(line_items.price * line_items.quantity)`.

**Why it is wrong:** The computed value and its source data will inevitably diverge. Someone will update a line item without updating the total. Now you have two different answers to "what is the order total?"

**The fix:** Compute derived values at query time, in a view, or in the application layer. If you must store a computed value for performance (denormalization), document it as a cache and define the refresh/invalidation strategy. The source of truth must always be the underlying data.

### No Indexes on Frequently Queried Columns

**The mistake:** Creating tables without thinking about query patterns. Adding indexes only after performance problems emerge in production.

**Why it is wrong:** By the time performance problems are visible, the table may have millions of rows and adding an index will lock the table or take hours. Queries that should take milliseconds take seconds, and the team adds caching to work around a problem that an index would solve.

**The fix:** In the blueprint, list the expected queries for each entity and specify the indexes that support them. At minimum, index every foreign key column and every column used in WHERE or ORDER BY clauses of common queries.

### Not Planning for Schema Migration

**The mistake:** Treating the initial schema as permanent. Not choosing a migration tool, not establishing conventions, not thinking about how columns will be added, renamed, or removed.

**Why it is wrong:** The schema will change. If you do not have a migration strategy from day one, schema changes will be ad-hoc SQL scripts run manually against production, with no version history and no rollback plan.

**The fix:** Choose a migration approach before writing the first CREATE TABLE. Include the migration strategy in the blueprint. Every schema change is a versioned, reviewable, reversible migration file.

### Ignoring Data Lifecycle

**Mistake:** Storing all data forever without retention, archival, or deletion policies.
**Fix:** For each entity, specify:

```
| Entity      | Retention     | Archival                 | Deletion Trigger       |
|-------------|---------------|--------------------------|------------------------|
| Order       | 7 years       | Archive after 2y         | Legal retention expiry |
| Session     | 30 days       | None (delete)            | Age > 30 days         |
| AuditLog    | 5 years       | Cold storage after 1y    | Legal retention expiry |
| UserProfile | Until deleted | None                     | User requests deletion |
| TempUpload  | 24 hours      | None (delete)            | Age > 24 hours        |
```

Address GDPR/privacy explicitly: Which entities contain PII? What happens on a deletion request? Can PII be pseudonymized instead of deleted? Where does PII live (database, logs, backups, caches, third-party services)?

---

## Quick Reference: Data Model Blueprint Checklist

```
[ ] Conceptual model: entities and relationships (diagram)
[ ] Logical model: attributes, types, constraints, keys per entity
[ ] Relationship cardinality: 1:1, 1:N, M:N with minimums
[ ] Database selection: which database(s) and why
[ ] Normalization decisions: explicitly stated with rationale
[ ] Primary key strategy: auto-increment vs UUID, and why
[ ] Soft delete vs hard delete: specified per entity
[ ] Audit columns: created_at, updated_at, created_by, updated_by
[ ] Indexes: listed per entity based on expected queries
[ ] Multi-tenancy approach: if applicable, which pattern and why
[ ] Pagination strategy: cursor-based or offset-based, and why
[ ] Data flow: how data enters, moves through, and exits
[ ] Caching: what is cached, where, TTL, invalidation strategy
[ ] Storage estimates: rows/year, avg row size, total projection
[ ] Migration strategy: tool, versioning, rollback, zero-downtime plan
[ ] Seed data: what must exist on first deploy
[ ] Data lifecycle: retention, archival, deletion per entity
[ ] PII inventory: which fields contain personal data, GDPR strategy
[ ] JSON columns: if used, justification for each
[ ] Enumerations: all enum fields listed with allowed values
```

---

## Summary

1. **Model the domain, not the UI.** The data model outlives every interface built on top of it.
2. **Be explicit.** Every entity, attribute, constraint, and relationship documented.
3. **Normalize by default, denormalize with evidence.** Premature denormalization creates consistency bugs.
4. **Choose databases by access pattern.** Start with PostgreSQL. Add complexity only when measured needs demand it.
5. **Design for change.** Schema migration is a first-class architectural concern.
6. **Plan the data lifecycle.** Retention, archival, and deletion must be designed upfront.
7. **Think about flow, not just storage.** How data moves is as important as where it rests.

The data model is the foundation. Get it right and the Builder has a clear path. Get it wrong and every feature fights the schema.
