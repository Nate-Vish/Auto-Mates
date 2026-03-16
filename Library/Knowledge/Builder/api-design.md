# API Design & Integration
**When to use:** Read when designing REST/GraphQL APIs, implementing auth, configuring CORS, or integrating with external services.

---

## REST API Design

### HTTP Methods
| Method | Purpose | Idempotent | Response |
|--------|---------|-----------|----------|
| GET | Read resource(s) | Yes | 200 with data |
| POST | Create resource | No | 201 + Location header |
| PUT | Full update (replace) | Yes | 200 or 204 |
| PATCH | Partial update | No* | 200 or 204 |
| DELETE | Remove resource | Yes | 204 (no body) |

### URL Design — Nouns, not Verbs
```
GOOD                              BAD
GET    /api/v1/users              GET    /api/getUsers
POST   /api/v1/users              POST   /api/createUser
PATCH  /api/v1/users/42           POST   /api/updateUser
DELETE /api/v1/users/42           POST   /api/deleteUser

Nested resources:
GET /api/v1/users/42/orders           # Orders for user 42
GET /api/v1/users/42/orders/7         # Specific order

Filtering/sorting/pagination:
GET /api/v1/users?role=admin&sort=-created_at&page=2&limit=20
```

**Rules:** Plural nouns (`/users`). kebab-case for multi-word paths. Consistent casing for field names. ISO 8601 dates. String IDs to avoid JS integer overflow.

### Status Codes
| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 | OK | Successful GET, PUT, PATCH with response body |
| 201 | Created | Successful POST creating a resource |
| 204 | No Content | Successful DELETE, or PUT/PATCH with no response body |
| 400 | Bad Request | Malformed syntax, invalid parameters |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Authenticated but insufficient permissions |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Duplicate resource, state conflict |
| 422 | Unprocessable Entity | Semantic validation failures |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unhandled server failure |

### Pagination
- **Cursor-based** (for real-time data, large datasets): consistent, fast regardless of position
- **Offset-based** (for simple admin panels): allows jumping to any page, but inaccurate with changing data

```typescript
// Cursor response
{ "data": [...], "pagination": { "has_next": true, "next_cursor": "eyJ...", "has_previous": true, "previous_cursor": "eyJ..." } }
```

### Standard Error Format
```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Request validation failed",
    "details": [
      { "field": "email", "message": "Must be a valid email address" }
    ]
  }
}
```
Never expose stack traces in production. Always include machine-readable `code` and human-readable `message`.

### Versioning
Use URL path versioning: `/api/v1/users` — most tooling-friendly and widely understood.

---

## GraphQL vs REST Decision Guide

| Factor | REST | GraphQL |
|--------|------|---------|
| Data fetching | Multiple endpoints, fixed response shapes | Single endpoint, client specifies shape |
| Over/under-fetching | Common problem | Eliminated by design |
| Caching | Built-in HTTP caching | Requires client-side (Apollo) or custom |
| Best for | CRUD apps, public APIs, microservices | Complex UIs, mobile apps, aggregation layers |

**Rule:** Default to REST. Consider GraphQL when frontend needs flexible, nested data from multiple sources in a single request.

---

## WebSockets & Real-Time

Use WebSockets for: chat, live notifications, collaborative editing, real-time dashboards, multiplayer.
Use SSE (Server-Sent Events) for server-only push. Use HTTP for request-response.

```typescript
// Server (ws library)
const wss = new WebSocketServer({ port: 8080 });
wss.on("connection", (ws: WebSocket) => {
  ws.on("message", (data: Buffer) => {
    const message = JSON.parse(data.toString());
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) client.send(JSON.stringify(message));
    });
  });
});

// Client — implement reconnection on close
const ws = new WebSocket("wss://api.example.com/ws");
ws.onclose = () => setTimeout(() => reconnect(), 1000);
```

**Socket.IO** adds reconnection, rooms, fallbacks — use for rapid development.
**Native WebSocket** for latency-critical, high-throughput systems.

---

## Authentication Patterns

| Method | Stateless | Best For |
|--------|-----------|----------|
| API Keys | Yes | Server-to-server, public APIs |
| JWT | Yes | SPAs, mobile apps, microservices |
| OAuth 2.0 | Yes | Third-party access, social login |
| Session cookies | No | Traditional server-rendered apps |

### JWT Implementation
```typescript
// Login returns:
{ "access_token": "eyJ...", "refresh_token": "eyJ...", "expires_in": 1800 }

// Client sends:
Authorization: Bearer eyJ...
```

**Security rules:**
- Access tokens: 15-30 min expiry. Store in-memory.
- Refresh tokens: 7-30 day expiry. Store in httpOnly cookie.
- Use RS256 or ES256, not HS256 with weak secrets.
- Never store sensitive data in JWT payload (it's base64-encoded, NOT encrypted).
- Validate: `iss`, `aud`, `exp`, signature.

### OAuth 2.0 Authorization Code Flow with PKCE
```
1. App generates code_verifier + code_challenge
2. Redirect user to: /authorize?response_type=code&client_id=X&code_challenge=Y
3. User authenticates and consents
4. Auth server redirects: /callback?code=AUTH_CODE
5. App exchanges code for tokens: POST /token { code, code_verifier, client_id }
```

---

## CORS Configuration

```typescript
app.use(cors({
  origin: ["https://app.example.com", "https://admin.example.com"],
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,   // Allow cookies — CANNOT use origin: "*" with this
  maxAge: 600,         // Cache preflight for 10 minutes
}));
```

**Rules:** Specific `origin` whitelist. Never `*` in production with credentials. CORS is browser-only — always validate/authenticate server-side.

---

## Rate Limiting

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 47
X-RateLimit-Reset: 1709420400
Retry-After: 30
```
Return 429 with `Retry-After` when limits exceeded. Apply stricter limits to auth endpoints.

---

## Security — OWASP API Top 10

| # | Risk | Prevention |
|---|------|-----------|
| 1 | Broken Object Level Authorization | Check ownership on every object access |
| 2 | Broken Authentication | Use proven auth libraries; rate limit login attempts |
| 4 | Unrestricted Resource Consumption | Rate limiting, pagination limits, request size limits |
| 5 | Broken Function Level Authorization | Enforce role checks on every endpoint; deny by default |
| 7 | SSRF | Validate and sanitize URLs; use allowlists for external calls |
| 10 | Unsafe API Consumption | Validate all data from third-party APIs |

---

## Fetch vs Axios

| Feature | Fetch | Axios |
|---------|-------|-------|
| Built-in | Yes (browser + Node 18+) | No |
| Request/response interceptors | Manual | Built-in |
| Automatic JSON parsing | Manual | Automatic |
| Timeout | Via AbortController | Built-in config |
| Error handling | Must check `response.ok` | Throws on non-2xx |
| Bundle size | Zero | ~13KB gzipped |

### Axios with Interceptors
```typescript
const api = axios.create({ baseURL: "https://api.example.com/v1", timeout: 10_000 });

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      const newToken = await refreshAccessToken();
      error.config.headers.Authorization = `Bearer ${newToken}`;
      return api.request(error.config); // Retry with new token
    }
    return Promise.reject(error);
  }
);
```

---

## Daily Rules

1. Design URLs as nouns — the HTTP method is the verb
2. Return proper status codes — 201 for created, 204 for deleted, 422 for validation errors
3. Standardize error responses — same shape everywhere
4. Validate all input with Zod at the API boundary
5. Use JWT with short expiry (15-30 min) + refresh tokens in httpOnly cookies
6. Configure CORS explicitly — list specific origins, never `*` with credentials
7. Rate limit everything — apply stricter limits to auth endpoints
8. Paginate all list endpoints — never return unbounded results
9. Version from day one — `/api/v1/` costs nothing now, prevents painful migrations later
