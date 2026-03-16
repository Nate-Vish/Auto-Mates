# API Architecture Patterns
**Category:** API Design
**Sources:**
- https://directus.io/blog/rest-graphql-tprc
- https://sdtimes.com/graphql/trpc-vs-graphql-vs-rest-choosing-the-right-api-design-for-modern-web-applications/
- https://dev.to/dataformathub/rest-vs-graphql-vs-trpc-the-ultimate-api-design-guide-for-2026-8n3
- https://wundergraph.com/blog/graphql-vs-federation-vs-trpc-vs-rest-vs-grpc-vs-asyncapi-vs-webhooks
- https://medium.com/@platform.engineers/api-gateway-and-backends-for-frontends-bff-patterns-a-technical-overview-8d2b7e8a0617
- https://learn.microsoft.com/en-us/azure/architecture/patterns/backends-for-frontends
- https://zapier.com/engineering/apikey-oauth-jwt/
- https://www.scalekit.com/blog/apikey-jwt-comparison
- https://supertokens.com/blog/oauth-vs-jwt
- https://frontegg.com/blog/oauth-vs-jwt

**Last updated:** 2026-03-01

---

## 1. REST vs. GraphQL vs. tRPC -- Decision Guide

### Quick Decision Matrix

| Factor | REST | GraphQL | tRPC |
|--------|------|---------|------|
| **Public API** | Best choice | Good | Not suitable |
| **Complex UI data needs** | Over-fetching problem | Best choice | Good |
| **TypeScript monorepo** | Verbose | Extra tooling overhead | Best choice |
| **Multi-language clients** | Universal | Good | TypeScript only |
| **HTTP caching** | Native, simple | Requires extra work | Requires extra work |
| **Learning curve** | Low | Medium | Low (if already TS) |
| **Tooling maturity** | Excellent | Good | Growing |
| **Dev speed (TS projects)** | Baseline | +15-20% faster | +35-40% faster |

### REST -- When It's Right

**Choose REST when:**
- Building a public API consumed by unknown/diverse clients
- You need universal compatibility (any language, any platform)
- HTTP caching is important for performance
- The data access patterns are straightforward CRUD
- You need long-term backward compatibility
- Partner integrations require a stable, well-documented interface

**Choose REST when it's wrong to pick it:**
- Your frontend needs data from 5 different endpoints per page (over-fetching/under-fetching problem)
- You're building an internal tool where type safety matters more than openness

**Performance:** REST averages ~12ms p50 latency for simple queries. It remains the most stable under high loads and unpredictable usage patterns.

### GraphQL -- When It's Right

**Choose GraphQL when:**
- Multiple client platforms (web, mobile, TV) need different data shapes from the same backend
- Your UI is data-heavy with complex, nested queries
- You want to reduce bandwidth (clients request only the fields they need, ~30% reduction)
- You're aggregating data from multiple backend services into a unified graph
- Mobile clients on slow networks need minimal payload sizes

**Choose GraphQL when it's wrong to pick it:**
- Your API is simple CRUD with predictable access patterns
- You don't have the team to manage schema governance, DataLoader patterns, and query complexity analysis
- You need robust HTTP caching (GraphQL uses POST for queries, breaking standard HTTP cache)

**Watch out for:**
- **N+1 queries:** Without DataLoader, nested resolvers will hammer your database
- **Query complexity attacks:** Clients can write deeply nested queries that consume enormous server resources. You MUST implement query depth limiting and complexity analysis
- **Caching:** No native HTTP caching. Need Apollo Client, Relay, or custom solutions

### tRPC -- When It's Right

**Choose tRPC when:**
- Full-stack TypeScript (frontend and backend in same repo or monorepo)
- Internal tools, admin panels, or products where you control all clients
- You want end-to-end type safety without code generation
- Speed of development is the priority (35-40% faster feature development vs REST)
- Using Next.js, Nuxt, or similar full-stack frameworks

**Choose tRPC when it's wrong to pick it:**
- Any client will be written in a non-TypeScript language
- You need a public API
- Your system is distributed across teams with separate repositories
- You anticipate needing to support non-JS/TS clients in the future

**Limitations:**
- Tied exclusively to TypeScript. This is non-negotiable.
- Scaling challenges in high-traffic distributed systems
- No standardized documentation format (no OpenAPI equivalent)

### The Hybrid Approach (Modern Best Practice)

Most production systems in 2026 use more than one API style:

```
External/Public API  -->  REST
Internal Frontend    -->  tRPC or GraphQL
Service-to-Service   -->  gRPC or REST
```

This is not an anti-pattern. Different consumers have different needs. The key is having clear boundaries and not mixing styles within the same consumer-facing surface.

---

## 2. Backend for Frontend (BFF) Pattern

### What It Is

A dedicated backend service tailored for a specific frontend application. Instead of one general-purpose API serving web, mobile, and TV, each client type gets its own backend that aggregates and transforms data specifically for that UI.

### Architecture

```
Web App    -->  Web BFF    -->  Microservices
Mobile App -->  Mobile BFF -->  Microservices
TV App     -->  TV BFF     -->  Microservices
```

### When to Use BFF

| Use BFF When | Don't Use BFF When |
|---|---|
| Different clients need significantly different data shapes | All clients consume the same data the same way |
| Mobile needs optimized, minimal payloads | You have a single client type |
| Each client team wants to move independently | Your team is too small to maintain multiple backends |
| You need client-specific auth, caching, or rate limiting | The overhead of multiple services isn't justified |

### BFF Rules

1. **One BFF per client type.** Web BFF, Mobile BFF, etc. Not one BFF per team or per feature.
2. **BFF owns aggregation and transformation.** It calls downstream services and reshapes the data for its client. The client never calls downstream services directly.
3. **BFF does NOT own business logic.** Business logic lives in the domain services. The BFF is a translation layer.
4. **Frontend team owns their BFF.** The team that builds the UI should control how their data is shaped and delivered.

### BFF Anti-Patterns

- **God BFF:** One BFF serving all clients. This is just an API gateway with extra steps.
- **Business logic in BFF:** If your BFF is making business decisions (pricing calculations, validation rules), you've leaked domain logic into the presentation layer.
- **BFF-to-BFF calls:** BFFs should call domain services, never other BFFs.

---

## 3. API Gateway Pattern

### What It Is

A single entry point for all client requests that handles cross-cutting concerns before routing to backend services.

### Core Responsibilities

| Responsibility | Description |
|---|---|
| **Routing** | Directs requests to the correct backend service |
| **Authentication** | Validates credentials before requests reach services |
| **Rate Limiting** | Prevents abuse and ensures fair resource allocation |
| **Request Transformation** | Protocol translation, header injection, request/response modification |
| **Load Balancing** | Distributes traffic across service instances |
| **Caching** | Caches responses to reduce backend load |
| **Monitoring & Logging** | Centralized observability for all API traffic |
| **Circuit Breaking** | Prevents cascade failures when downstream services are unhealthy |

### API Gateway vs. BFF

| Aspect | API Gateway | BFF |
|--------|------------|-----|
| **Scope** | All clients, all requests | One specific client type |
| **Owned by** | Platform/infrastructure team | Frontend/client team |
| **Logic** | Cross-cutting (auth, rate limit, routing) | Client-specific (aggregation, transformation) |
| **Data manipulation** | Minimal (pass-through) | Heavy (aggregate, reshape, filter) |

### Combined Architecture (Real-World)

```
Client Request --> API Gateway --> BFF --> Domain Services
                   (auth, rate    (aggregate,
                    limiting,      transform
                    routing)       for client)
```

The API Gateway handles security and traffic management. The BFF handles client-specific data needs. Domain services handle business logic.

### Popular API Gateways

| Gateway | Best For |
|---------|----------|
| **Kong** | Open source, plugin ecosystem, Kubernetes-native |
| **AWS API Gateway** | AWS-native services, serverless (Lambda) |
| **Nginx** | High performance, reverse proxy, simple routing |
| **Traefik** | Docker/Kubernetes, auto-discovery, Let's Encrypt |
| **Tyk** | Open source, GraphQL support, developer portal |

---

## 4. Rate Limiting and Throttling Design

### Strategies

| Strategy | How It Works | Best For |
|----------|-------------|----------|
| **Fixed Window** | Count requests in fixed time intervals (e.g., 100/minute) | Simple, low overhead |
| **Sliding Window** | Rolling time window that smooths out bursts | More accurate, slightly more complex |
| **Token Bucket** | Tokens replenish at a fixed rate; each request consumes a token | Allows controlled bursting |
| **Leaky Bucket** | Requests queue and process at a fixed rate | Smoothest output, highest latency |

### Rate Limiting Headers

Always communicate limits to clients:

```
X-RateLimit-Limit: 1000        # Max requests per window
X-RateLimit-Remaining: 742     # Requests left in current window
X-RateLimit-Reset: 1677721600  # Unix timestamp when window resets
Retry-After: 30                # Seconds to wait (on 429 response)
```

### Design Decisions

1. **Rate limit by what?** API key, user ID, IP address, or combination. API key is most common for authenticated APIs. IP alone is unreliable (NAT, shared IPs).
2. **Different tiers.** Free: 100 req/min. Pro: 1000 req/min. Enterprise: custom. Build this into your plan from the start.
3. **Graceful degradation.** Return 429 Too Many Requests with `Retry-After` header. Never silently drop requests.
4. **Distributed rate limiting.** In multi-instance deployments, use a shared store (Redis) for rate limit counters.

---

## 5. Authentication Patterns

### Quick Decision Guide

| Scenario | Use This | Why |
|----------|----------|-----|
| Server-to-server, internal microservices | **API Key** | Simple, no user context needed |
| Public read-only API, rate limiting | **API Key** | Easy to issue, track, and revoke |
| User auth in SPAs / mobile apps | **JWT** | Stateless, self-contained, no session store |
| Stateless microservices | **JWT** | No shared session state between instances |
| "Login with Google/GitHub" | **OAuth 2.0** | Delegated authorization, industry standard |
| Third-party integrations / platform API | **OAuth 2.0** | Scoped access, user consent, token rotation |
| High-security enterprise | **OAuth 2.0 + JWT** | OAuth for authorization flow, JWT as token format |

### API Keys

```
Authorization: Bearer sk_live_abc123def456
```

- **What they authenticate:** The application, not the user
- **Lifetime:** Long-lived (months/years), manually rotated
- **Scope:** Typically all-or-nothing (full API access)
- **Risk:** If leaked, full access until revoked. GitHub detects ~2 million exposed keys/year.

**When to accept the risk:** Internal services, server-side only, never embedded in client-side code.

### JWT (JSON Web Tokens)

```json
{
  "header": { "alg": "RS256", "typ": "JWT" },
  "payload": { "sub": "user_123", "role": "admin", "exp": 1677721600 },
  "signature": "..."
}
```

- **What they authenticate:** The user and their permissions
- **Lifetime:** Short-lived (15-60 minutes), with refresh tokens
- **Scope:** Claims embedded in the token itself
- **Verification:** Cryptographic signature check, no database lookup needed

**Critical rule:** JWTs cannot be revoked once issued (until they expire). For immediate revocation, you need a token blacklist -- which partially negates the "stateless" benefit.

### OAuth 2.0

- **What it does:** Delegated authorization. "This app can access my data with these specific permissions."
- **Flows:** Authorization Code (web apps), PKCE (SPAs/mobile), Client Credentials (server-to-server)
- **Scope:** Fine-grained (`read:profile`, `write:orders`)
- **Token type:** Usually issues JWTs as access tokens

**The key insight:** OAuth and JWT are not competitors. OAuth is the *authorization framework*. JWT is the *token format*. They work together. OAuth defines HOW you get the token. JWT defines WHAT the token looks like.

### Common Authentication Mistakes

1. **API keys in frontend code.** They will be found. Use OAuth or a backend proxy.
2. **JWT with no expiration.** Always set `exp`. 15 minutes for access tokens, 7 days for refresh tokens.
3. **Storing JWT in localStorage.** Vulnerable to XSS. Use httpOnly cookies for web apps.
4. **Building custom auth instead of using OAuth libraries.** Auth is a solved problem. Use battle-tested libraries.
5. **Over-engineering auth for MVPs.** Start with API keys for internal/server-to-server. Add OAuth when you need user-facing third-party access.

---

## Planner's Application

When writing blueprints that involve API architecture decisions, Planner should:

1. **State the API style choice and WHY.** Don't just write "use REST." Write "REST because we need a public API with diverse client languages" or "tRPC because we're a TypeScript monorepo building internal tools."

2. **Decide on BFF early.** If the product has meaningfully different clients (web vs. mobile), put a BFF in the architecture diagram from the start. If it's a single-client product, don't add BFF complexity.

3. **Specify the authentication pattern in the blueprint.** Include: which pattern (API key / JWT / OAuth), token lifetime, refresh strategy, and where credentials are stored. This is an architectural decision, not a "figure it out during implementation" detail.

4. **Include rate limiting in the blueprint.** Specify: strategy (token bucket recommended), limits per tier, which identifier to limit by, and the response format for 429 errors.

5. **Document the API gateway needs.** If using microservices, specify what cross-cutting concerns the gateway handles vs. what each service handles. This prevents duplication and gaps.

6. **Use the hybrid pattern deliberately.** If the project needs multiple API styles, draw the clear boundary: "REST for public API, tRPC for admin dashboard, gRPC for service-to-service." Document which style serves which consumer.
