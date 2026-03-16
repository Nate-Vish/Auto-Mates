# REST API Design Guide
**Category:** API Design
**Sources:**
- https://learn.microsoft.com/en-us/azure/architecture/best-practices/api-design
- https://blog.postman.com/rest-api-best-practices/
- https://stackoverflow.blog/2020/03/02/best-practices-for-rest-api-design/
- https://www.rfc-editor.org/rfc/rfc9457.html
- https://restfulapi.net/resource-naming/
- https://www.speakeasy.com/api-design/pagination
- https://www.speakeasy.com/api-design/status-codes
- https://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api
- https://www.lonti.com/blog/api-versioning-url-vs-header-vs-media-type-versioning
- https://embedded.gusto.com/blog/api-pagination/
- https://www.milanjovanovic.tech/blog/understanding-cursor-pagination-and-why-its-so-fast-deep-dive

**Last updated:** 2026-03-01

---

## 1. Resource Naming Conventions

### The Rules

| Rule | Good | Bad | Why |
|------|------|-----|-----|
| Use plural nouns | `/users` | `/user` | Collections are plural; consistency with `/users/123` |
| Use nouns, not verbs | `/orders` | `/create-order` | HTTP methods already provide the verb |
| Use lowercase + hyphens | `/order-items` | `/orderItems`, `/Order_Items` | URL-safe, readable, consistent |
| Nest for relationships | `/users/123/orders` | `/getUserOrders?userId=123` | Models the resource hierarchy naturally |
| Limit nesting to 2 levels | `/users/123/orders` | `/users/123/orders/456/items/789/reviews` | Deep nesting becomes rigid and hard to maintain |
| No file extensions | `/users/123` | `/users/123.json` | Use `Content-Type` header instead |
| No trailing slashes | `/users` | `/users/` | Pick one convention and be consistent |

### Common Naming Mistakes

- **Verbs in URLs:** `/api/getUsers` or `/api/createOrder` -- the HTTP method already tells you the action. The URL should only describe the *resource*.
- **Singular vs. plural inconsistency:** Using `/user` in one place and `/orders` in another. Pick plural for collections, always.
- **Mirroring your database:** If your table is `tbl_user_accounts`, your endpoint should NOT be `/tbl-user-accounts`. The API is an abstraction, not a database explorer.
- **IDs in query params for single-resource access:** Use `/users/123`, not `/users?id=123`. Query params are for filtering collections.

---

## 2. HTTP Methods Mapping

| Method | On Collection (`/orders`) | On Item (`/orders/123`) | Idempotent? | Safe? |
|--------|---------------------------|-------------------------|-------------|-------|
| **GET** | List all orders | Get order 123 | Yes | Yes |
| **POST** | Create a new order | Error (don't POST to an item) | No | No |
| **PUT** | Bulk replace (rare) | Replace order 123 entirely | Yes | No |
| **PATCH** | Bulk partial update (rare) | Partially update order 123 | No* | No |
| **DELETE** | Delete all (dangerous, usually disabled) | Delete order 123 | Yes | No |

*PATCH can be made idempotent but the spec does not require it.

### PUT vs. PATCH -- The Distinction That Matters

| Aspect | PUT | PATCH |
|--------|-----|-------|
| Payload | Complete resource representation | Only the changed fields |
| Missing fields | Reset to default / null | Left unchanged |
| Use case | "Replace this resource" | "Update these specific fields" |
| Idempotency | Guaranteed | Not guaranteed |

**The common mistake:** Using PUT when you mean PATCH. If your client sends `{ "name": "New Name" }` to a PUT endpoint, every other field on that resource should be reset. Most teams actually want PATCH behavior.

### POST Is Not Just "Create"

POST can also be used for:
- **Processing operations** that don't map to CRUD (e.g., `/orders/123/cancel`)
- **Triggering async jobs** (return 202 Accepted)
- **Submitting search queries** with complex bodies too large for GET query strings

---

## 3. Status Codes: Which to Use When

### The Codes You Actually Need

Most APIs can get by with about 10 status codes. Here's the real-world set:

#### Success (2xx)

| Code | When to Use | Common Mistake |
|------|-------------|----------------|
| **200 OK** | GET succeeded; PUT/PATCH succeeded with response body | Using 200 for everything, including errors |
| **201 Created** | POST created a new resource. Include `Location` header | Returning 200 after creating a resource |
| **204 No Content** | DELETE succeeded; PUT/PATCH succeeded with no body | Returning 200 with empty body instead |
| **202 Accepted** | Async operation accepted but not yet completed | Not providing a status-check URL |

#### Client Errors (4xx)

| Code | When to Use | Common Mistake |
|------|-------------|----------------|
| **400 Bad Request** | Malformed request syntax, missing required fields | Using 500 for validation errors |
| **401 Unauthorized** | No credentials or invalid credentials | Confusing with 403 |
| **403 Forbidden** | Valid credentials, but not allowed to access this resource | Using 401 when you mean 403 |
| **404 Not Found** | Resource doesn't exist at this URI | Returning 200 with `{ "data": null }` |
| **409 Conflict** | Request conflicts with current state (duplicate, version mismatch) | Using 400 for business-logic conflicts |
| **422 Unprocessable Entity** | Request is syntactically valid but semantically wrong | Using 400 for everything |
| **429 Too Many Requests** | Rate limit exceeded | Returning 503 for rate limiting |

#### Server Errors (5xx)

| Code | When to Use | Common Mistake |
|------|-------------|----------------|
| **500 Internal Server Error** | Unhandled server-side exception | Using 500 for anything the client did wrong |
| **502 Bad Gateway** | Upstream service returned invalid response | |
| **503 Service Unavailable** | Server overloaded or in maintenance. Include `Retry-After` header | Using 500 for planned maintenance |

### The 401 vs. 403 Rule

This is the most commonly confused pair:
- **401:** "I don't know who you are." The client needs to authenticate.
- **403:** "I know who you are, and you're not allowed." The client is authenticated but lacks permission.

### The Golden Rule of Status Codes

Never return 200 with an error in the body. The HTTP status code IS the first piece of information about what happened. If a proxy, cache, or monitoring tool only sees status codes, a 200 with `{ "error": "Not found" }` is invisible failure.

---

## 4. Error Response Format (RFC 9457 / RFC 7807 Problem Details)

RFC 9457 (successor to RFC 7807) defines a standard error response format. Use it instead of inventing your own.

### The Five Standard Fields

```json
{
  "type": "https://api.example.com/errors/insufficient-funds",
  "title": "Insufficient Funds",
  "status": 403,
  "detail": "Your account balance is $30.00, but the transaction requires $50.00.",
  "instance": "/accounts/12345/transactions/67890"
}
```

| Field | Purpose | Required? |
|-------|---------|-----------|
| `type` | URI identifying the error type. Should resolve to documentation | Recommended |
| `title` | Short, human-readable summary | Recommended |
| `status` | HTTP status code (must match actual response) | Recommended |
| `detail` | Human-readable explanation to help the client fix the problem | Optional |
| `instance` | URI identifying the specific occurrence | Optional |

### Extension Fields

You can add custom fields. Common additions:

```json
{
  "type": "https://api.example.com/errors/validation-error",
  "title": "Validation Error",
  "status": 422,
  "detail": "One or more fields failed validation.",
  "instance": "/users",
  "errors": [
    { "field": "email", "message": "Must be a valid email address" },
    { "field": "age", "message": "Must be 18 or older" }
  ],
  "traceId": "abc-123-def-456",
  "timestamp": "2026-03-01T14:30:00Z"
}
```

### What NOT to Do

- **Don't expose stack traces** in production error responses. Security risk and useless to API consumers.
- **Don't use `detail` for debugging info.** Keep that in server logs. The `detail` field should help the *client* fix the problem.
- **Don't invent a custom format** when RFC 9457 already exists. Standardization means clients can handle errors consistently across multiple APIs.

### Content Type

Set `Content-Type: application/problem+json` for RFC 9457 responses.

---

## 5. Pagination Patterns

### Offset Pagination

```
GET /orders?limit=25&offset=50
```

| Pros | Cons |
|------|------|
| Simple to implement | Degrades with large offsets (DB must scan and skip rows) |
| Allows jumping to any page | Results shift when data is inserted/deleted between requests |
| Easy to parallelize | 10x+ latency increase at high offset values |

**Best for:** Small datasets, admin dashboards, internal tools, prototypes.

### Cursor Pagination

```
GET /orders?limit=25&after=eyJpZCI6MTIzfQ==
```

Response includes:
```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTQ4fQ==",
    "has_more": true
  }
}
```

| Pros | Cons |
|------|------|
| Consistent performance regardless of dataset size (up to 17x faster) | Cannot jump to arbitrary page |
| No duplicate/skipped results when data changes | Harder to implement |
| Naturally supports infinite scroll | Cannot parallelize easily |

**Best for:** Large datasets, feeds, timelines, mobile apps, any data that changes frequently.

### Pagination Response Metadata

Always include metadata. At minimum:

```json
{
  "data": [...],
  "pagination": {
    "total": 1234,
    "limit": 25,
    "offset": 50,
    "has_more": true
  }
}
```

### Pagination Rules

1. **Support pagination from day one.** Adding it later is a breaking change.
2. **Set sensible defaults.** `limit=25` if not specified.
3. **Enforce a maximum.** Cap at 100 or 200 to prevent resource abuse.
4. **Stable sort order.** If you don't sort consistently, paginated results will have duplicates and gaps.

---

## 6. Versioning Strategies

### Comparison

| Strategy | Example | Pros | Cons | Used By |
|----------|---------|------|------|---------|
| **URI Path** | `/v1/users` | Explicit, easy to test, simple routing | Violates REST (same resource, different URI), URLs get cluttered | Twitter, Facebook, Stripe |
| **Query Parameter** | `/users?version=2` | Base URL stays clean, easy to test | Confuses filtering purpose, caching issues | AWS, Google (some APIs) |
| **Custom Header** | `X-API-Version: 2` | Clean URLs, good separation of concerns | Invisible, harder to test in browser | Azure, some enterprise APIs |
| **Content Negotiation** | `Accept: application/vnd.api.v2+json` | Most RESTful, fine-grained | Complex, hard to test, caching challenges | GitHub |

### Practical Recommendation

**Use URI path versioning** (`/v1/`, `/v2/`) unless you have a specific reason not to:
- It's the most widely understood pattern
- It's immediately visible and testable
- Every tool, proxy, and CDN handles it natively
- The REST purity argument rarely outweighs developer experience

### Versioning Rules

1. **Version from the start.** `/v1/` on day one. Retrofitting is painful.
2. **Only bump major versions for breaking changes.** Adding fields is not breaking. Removing or renaming fields is.
3. **Support at least 2 versions simultaneously** during migration windows.
4. **Communicate deprecation** with `Sunset` and `Deprecation` headers plus documentation.
5. **Never remove a version without warning.** Give clients 6-12 months minimum.

---

## 7. Additional Best Practices

### Filtering, Sorting, Field Selection

```
GET /orders?status=shipped&sort=-created_at&fields=id,status,total
```

- Use query parameters for filtering: `?status=active&min_price=10`
- Use `-` prefix for descending sort: `?sort=-created_at`
- Support field selection for bandwidth optimization: `?fields=id,name,email`

### Async Operations

For long-running requests:
1. Return `202 Accepted` with a `Location` header pointing to a status endpoint
2. Client polls the status endpoint
3. When complete, status endpoint returns `303 See Other` with location of the result

### Rate Limiting Headers

Include rate limit info in response headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1677721600
```

### HATEOAS (When to Bother)

HATEOAS (Hypertext as the Engine of Application State) means including links in responses that tell the client what actions are available. In practice, most APIs skip it unless:
- You're building a truly discoverable public API
- Clients need to navigate without hardcoded URL knowledge
- You're at Richardson Maturity Model Level 3

For internal APIs and MVPs, don't overcomplicate things with HATEOAS.

---

## Planner's Application

When writing blueprints that include API design, Planner should:

1. **Define resource models first.** Before writing any endpoints, list the domain entities (Users, Orders, Products) and their relationships. The URL structure flows from this.

2. **Specify the endpoint table.** Include method, path, description, request body shape, response shape, and status codes. This becomes Builder's contract.

3. **Choose pagination strategy upfront.** Cursor for user-facing data feeds, offset for admin/internal tools. Document the choice in the blueprint.

4. **Mandate RFC 9457 error format.** Include this as a project-wide standard in the blueprint so Builder implements it consistently from the start.

5. **Set versioning strategy in the blueprint.** Default to URI path versioning (`/v1/`). Document the deprecation policy.

6. **Include a status code table.** Don't let Builder guess. Specify which status codes to use for each endpoint scenario.

7. **Call out non-obvious behaviors.** Async operations, bulk endpoints, search endpoints that use POST -- document anything that deviates from standard CRUD.
