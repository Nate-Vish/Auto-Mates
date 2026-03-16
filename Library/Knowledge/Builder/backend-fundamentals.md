# Backend Fundamentals
**When to use:** Read when building Node.js servers, designing database schemas, implementing auth, or setting up caching.

---

## Node.js Core

### Event Loop Priority
Synchronous > `process.nextTick` > Promises (microtasks) > Timers > Check phase (`setImmediate`)

**Rules:**
- Never block the event loop with synchronous computation
- Use `Promise.all()` for independent async operations (not sequential await)
- Offload CPU-heavy work to worker threads

```typescript
// GOOD — concurrent
const [users, posts] = await Promise.all([db.user.findMany(), db.post.findMany()]);

// BAD — sequential when they could be parallel
const users = await db.user.findMany();
const posts = await db.post.findMany();
```

---

## Express Setup

```typescript
import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import { rateLimit } from 'express-rate-limit';

const app = express();

// Middleware ORDER MATTERS — security first
app.use(helmet());                          // HTTP security headers
app.use(cors({ origin: process.env.ALLOWED_ORIGINS?.split(',') }));
app.use(compression());
app.use(express.json({ limit: '10kb' }));
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }));
```

### Router Organization
```typescript
// Feature-based routers
router.get('/', controller.listUsers);
router.get('/:id', controller.getUser);
router.post('/', validate(createUserSchema), controller.createUser);
router.patch('/:id', validate(updateUserSchema), controller.updateUser);
router.delete('/:id', controller.deleteUser);

// Rule: Routes define paths. Controllers handle HTTP. Services contain business logic.
```

### Error Handling — 4 Parameters
```typescript
export function errorHandler(err: Error, req: Request, res: Response, _next: NextFunction) {
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({ status: 'error', message: err.message });
  }
  logger.error('Unhandled error', { error: err, path: req.path });
  return res.status(500).json({ status: 'error', message: 'Internal server error' });
}

// Async error wrapper (pre-Express v5)
export const catchAsync = (fn: AsyncHandler) =>
  (req: Request, res: Response, next: NextFunction) => { fn(req, res, next).catch(next); };
```

---

## Database Choice

| Criteria | PostgreSQL | MongoDB |
|---|---|---|
| **Data shape** | Structured, relational | Flexible, document-based |
| **Relationships** | Strong (JOINs, foreign keys) | Weak (embedded docs or manual refs) |
| **Transactions** | ACID by default | Multi-doc transactions (slower) |
| **Best for** | Finance, e-commerce, relational data | CMS, IoT, rapid prototyping |

**Default to PostgreSQL.** Use MongoDB when schema is genuinely flexible and you need rapid iteration.

### ORM: Prisma vs Drizzle

| Feature | Prisma | Drizzle |
|---|---|---|
| Approach | Schema-first (.prisma file) | Code-first (TypeScript) |
| Bundle size | ~2MB | ~7.4KB |
| Edge/serverless | Improved in v7 | Excellent |
| Choose when | Team projects, broad DB support | Serverless/edge, SQL-level control |

---

## Authentication

### Password Hashing
```typescript
const SALT_ROUNDS = 12; // Increase over time as hardware improves
const hash = await bcrypt.hash(plainPassword, SALT_ROUNDS);
const isValid = await bcrypt.compare(plainPassword, user.passwordHash);
// Consider argon2 for new projects (winner of Password Hashing Competition)
```

### JWT Flow
```typescript
function signTokens(userId: string, role: string) {
  const accessToken = jwt.sign({ sub: userId, role }, ACCESS_SECRET, { expiresIn: '15m' });
  const refreshToken = jwt.sign({ sub: userId }, REFRESH_SECRET, { expiresIn: '7d' });
  return { accessToken, refreshToken };
}

// Verify middleware
function authenticate(req: Request, _res: Response, next: NextFunction) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) throw new AppError('No token provided', 401);
  const payload = jwt.verify(token, ACCESS_SECRET) as JwtPayload;
  req.user = payload;
  next();
}
```

### RBAC Middleware
```typescript
export function authorize(...allowedRoles: string[]) {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.user || !allowedRoles.includes(req.user.role)) throw new AppError('Forbidden', 403);
    next();
  };
}
router.delete('/:id', authenticate, authorize('admin'), controller.deleteUser);
```

---

## 3-Layer Architecture

```
Request → Controller → Service → Repository → Database
```

| Layer | Responsibility | Knows About |
|---|---|---|
| **Controller** | Parse request, return response | Service layer only |
| **Service** | Business rules, orchestration | Repository layer only |
| **Repository** | Data access (queries, ORM calls) | Database/ORM |

**Rules:** Controllers never touch the database. Services never access `req`/`res`. Repositories own the ORM.

### Feature-Based File Structure
```
src/
├── features/
│   ├── users/
│   │   ├── users.router.ts
│   │   ├── users.controller.ts
│   │   ├── users.service.ts
│   │   ├── users.repository.ts
│   │   ├── users.schema.ts    # Zod schemas
│   │   └── users.types.ts
│   └── auth/
├── middleware/
│   ├── authenticate.ts
│   ├── authorize.ts
│   ├── validate.ts
│   └── errorHandler.ts
├── utils/
│   ├── AppError.ts
│   └── logger.ts
├── app.ts           # Express setup
└── server.ts        # HTTP server + graceful shutdown
```

---

## Input Validation with Zod

```typescript
export const createUserSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email'),
    name: z.string().min(2).max(100),
    password: z.string().min(8).max(128),
    role: z.enum(['user', 'admin']).default('user'),
  }),
});

export function validate(schema: AnyZodObject) {
  return (req: Request, _res: Response, next: NextFunction) => {
    try {
      schema.parse({ body: req.body, query: req.query, params: req.params });
      next();
    } catch (err) {
      if (err instanceof ZodError) {
        return res.status(400).json({ errors: err.errors.map(e => ({ path: e.path.join('.'), message: e.message })) });
      }
      next(err);
    }
  };
}
```

---

## Configuration Validation

```typescript
const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  JWT_ACCESS_SECRET: z.string().min(32),
});

export const config = envSchema.parse(process.env);
// Validate at startup — fail fast if config is missing
```

---

## Logging

```typescript
// Pino (performance-first)
export const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: process.env.NODE_ENV === 'development' ? { target: 'pino-pretty' } : undefined,
});
logger.info({ userId: user.id, action: 'login' }, 'User logged in');
logger.error({ err, requestId: req.id }, 'Payment processing failed');
```

| Choose | When |
|---|---|
| **Pino** | High-throughput APIs, microservices |
| **Winston** | Multiple transports, complex formatting, enterprise |

Rules: Structured JSON in production. Never log passwords, tokens, or PII. Log levels: debug (dev), info (normal), warn (recoverable), error (failures).

---

## Custom Error Classes

```typescript
export class AppError extends Error {
  constructor(message: string, public readonly statusCode: number, public readonly isOperational = true) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
  }
}
export class NotFoundError extends AppError { constructor(resource: string) { super(`${resource} not found`, 404); } }
export class ValidationError extends AppError { constructor(message: string) { super(message, 400); } }
export class UnauthorizedError extends AppError { constructor(message = 'Unauthorized') { super(message, 401); } }
```

---

## Caching with Redis

```typescript
import { Redis } from 'ioredis';
const redis = new Redis(process.env.REDIS_URL);

// Cache-Aside pattern (default)
export async function cacheAside<T>(key: string, fetcher: () => Promise<T>, ttlSeconds = 300): Promise<T> {
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached) as T;
  const data = await fetcher();
  await redis.set(key, JSON.stringify(data), 'EX', ttlSeconds);
  return data;
}

// Cache invalidation
export async function invalidateCache(pattern: string) {
  const keys = await redis.keys(pattern);
  if (keys.length > 0) await redis.del(...keys);
}
```

**Rules:** Always set TTL — unbounded caches cause memory leaks. Use meaningful cache keys: `users:${id}`. In-memory for single-instance; Redis for multi-instance/distributed.

---

## Daily Rules

1. Start every backend with: Express + Helmet + CORS + rate limiter + Zod validation + global error handler
2. 3-layer architecture: Route → Controller → Service → Repository
3. Validate environment at startup with Zod — fail fast
4. Default to PostgreSQL + Prisma; use Drizzle for serverless/edge
5. Hash passwords with bcrypt (12+ rounds); JWT access tokens 15 min + refresh in httpOnly cookie
6. Structured JSON logging with Pino or Winston — never log secrets
7. Cache with Redis (cache-aside pattern); always set TTL
8. Feature-based file organization
9. Custom error classes with `isOperational` flag
10. Never trust client input — validate with Zod, parameterize SQL, sanitize HTML
