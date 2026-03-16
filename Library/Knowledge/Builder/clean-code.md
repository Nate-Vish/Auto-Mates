# Clean Code Principles
**When to use:** Read when naming things, designing functions, handling errors, organizing files, or before submitting code for review.

---

## Naming Conventions

### Variables & Constants
```typescript
// BAD — abbreviations, meaningless names
const d = new Date();
const u = getUser();
const tmp = items.filter(i => i.active);

// GOOD — descriptive, intention-revealing
const currentDate = new Date();
const authenticatedUser = getUser();
const activeItems = items.filter(item => item.active);

// Booleans — always is/has/should/can prefix
const isVisible = true;
const hasPermission = user.role === "admin";
const shouldRedirect = !isAuthenticated;
const canEdit = hasPermission && !isLocked;

// Constants — SCREAMING_SNAKE for true constants
const MAX_RETRIES = 3;
const API_BASE_URL = "https://api.example.com";
const DEFAULT_TIMEOUT_MS = 5000;
```

### Functions
```typescript
// Functions DO things — use verbs
function getUserById(id: string): User { }
function calculateTotal(items: CartItem[]): number { }
function isValidEmail(email: string): boolean { }    // predicate = is/has

// BAD — vague verbs
function handleData() { }    // handle HOW?
function processItems() { }  // process WHAT way?

// GOOD — specific verbs
function parseCSVToRows() { }
function filterExpiredTokens() { }
function formatCurrencyUSD() { }
```

### Files & Components
```
Components — PascalCase, match what they render
  UserProfile.tsx, AgentChatPanel.tsx, CommandBar.tsx

Hooks — camelCase, starts with use
  useLocalStorage.ts, useDebounce.ts, useAgentState.ts

Utilities — camelCase, descriptive
  formatDate.ts, validateEmail.ts, parseApiResponse.ts

Types — PascalCase, noun
  User.ts, ApiResponse.ts, AgentConfig.ts
```

**Rule:** If you need a comment to explain a name, rename it.

---

## Function Design

### Single Responsibility
```typescript
// BAD — does too many things
function processOrder(order: Order) {
  // validate, calculate, save, email all in one function
}

// GOOD — each function does ONE thing
function processOrder(order: Order) {
  validateOrder(order);
  const total = calculateOrderTotal(order);
  const savedOrder = saveOrder(order, total);
  notifyOrderConfirmed(savedOrder);
}
```

### Parameter Rules
```typescript
// Max 3 parameters — use object for more
// BAD
function createUser(name: string, email: string, age: number, role: string, team: string) { }

// GOOD
function createUser(params: CreateUserParams) { }
interface CreateUserParams { name: string; email: string; age: number; role: string; team: string; }
```

### Guard Clauses — Early Returns
```typescript
// BAD — deep nesting
function getDiscount(user: User) {
  if (user) {
    if (user.subscription) {
      if (user.subscription.type === "premium") {
        return 0.2;
      } else { return 0.1; }
    } else { return 0; }
  } else { return 0; }
}

// GOOD — guard clauses, flat
function getDiscount(user: User) {
  if (!user) return 0;
  if (!user.subscription) return 0;
  if (user.subscription.type === "premium") return 0.2;
  return 0.1;
}
```

---

## Error Handling

### Custom Error Classes
```typescript
class NotFoundError extends Error {
  constructor(resource: string, id: string) {
    super(`${resource} with id ${id} not found`);
    this.name = "NotFoundError";
  }
}

class ValidationError extends Error {
  constructor(public readonly fields: Record<string, string>) {
    super("Validation failed");
    this.name = "ValidationError";
  }
}

async function getUser(id: string): Promise<User> {
  const user = await db.users.findById(id);
  if (!user) throw new NotFoundError("User", id);
  return user;
}
```

### Result Type Pattern (Alternative to Throwing)
```typescript
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

function parseJSON<T>(json: string): Result<T> {
  try {
    return { ok: true, value: JSON.parse(json) };
  } catch (e) {
    return { ok: false, error: e as Error };
  }
}
```

### Anti-Patterns
```typescript
// NEVER swallow errors silently
try { doSomething(); } catch (e) { }  // BAD

// NEVER catch and log only
try { doSomething(); } catch (e) { console.log(e); }  // BAD

// DON'T throw strings (no stack trace)
throw "Something went wrong";  // BAD

// If you can't handle it, re-throw
try { criticalOperation(); } catch (e) { throw e; }
```

---

## Comments

### When to Comment
```typescript
// GOOD — explain WHY, not WHAT
// Offset by 1 because the API uses 1-based pagination
const pageIndex = page - 1;

// GOOD — explain complex business logic
// Users on "trial" plan get premium features for 14 days after signup.
// This was a product decision from Q3 2025.
if (isPremiumTrialActive(user)) { }

// GOOD — document non-obvious behavior
// setTimeout(0) defers focus until after React's commit phase
setTimeout(() => inputRef.current?.focus(), 0);

// BAD — restating the code
const total = price * quantity; // multiply price by quantity

// BAD — commented-out code (use git history)
// const oldFunction = () => { ... };
```

### TODO/FIXME Conventions
```typescript
// TODO: feature or improvement to add later
// FIXME: known bug that needs fixing
// HACK: temporary workaround — explain why
// NOTE: important context for future readers
```

### JSDoc — For Exported APIs
```typescript
/** Calculates shipping cost based on weight and destination zone. */
function calculateShipping(weightKg: number, zone: ShippingZone): number { }
```

---

## Code Formatting

### ESLint + Prettier Setup
```jsonc
// .prettierrc
{
  "semi": true,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "all",
  "printWidth": 100
}

// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react-hooks/recommended",
    "prettier"  // MUST be last — disables conflicting rules
  ]
}
```

### Import Order Convention
```typescript
// 1. External libraries
import { useState } from "react";
import { useNavigate } from "react-router-dom";

// 2. Internal modules (aliases)
import { useAuthStore } from "@/stores/auth";
import { formatDate } from "@/utils/date";

// 3. Relative imports
import { Header } from "./Header";

// 4. Styles
import styles from "./Page.module.css";

// 5. Types (type-only imports)
import type { User } from "@/types";
```

---

## Refactoring Patterns

| Pattern | When | How |
|---------|------|-----|
| **Extract Function** | Block does a sub-task | Move to named function |
| **Extract Variable** | Complex expression | Assign to descriptive name |
| **Rename** | Name doesn't reveal intent | Change to descriptive name |
| **Introduce Parameter Object** | Function has 4+ params | Group into interface |
| **Replace Conditional with Map** | Long if/else or switch | Use object/Map lookup |

### Replace Conditional with Map
```typescript
// BAD — long switch
function getStatusColor(status: string): string {
  switch (status) {
    case "active": return "green";
    case "error": return "red";
    case "pending": return "yellow";
    default: return "gray";
  }
}

// GOOD — map lookup
const STATUS_COLORS: Record<string, string> = {
  active: "green",
  error: "red",
  pending: "yellow",
};
function getStatusColor(status: string): string {
  return STATUS_COLORS[status] ?? "gray";
}
```

---

## Code Smells

| Smell | Symptom | Fix |
|-------|---------|-----|
| **Long function** | > 30 lines | Extract sub-functions |
| **Deep nesting** | > 3 levels | Guard clauses, extract |
| **Magic numbers** | `if (retries > 3)` | Named constant: `MAX_RETRIES` |
| **Boolean parameters** | `createUser(true, false)` | Options object or separate functions |
| **Temporal coupling** | `init()` must be called before `use()` | Constructor/factory pattern |
| **Feature envy** | Function accesses another object's data heavily | Move logic to that object |
| **Shotgun surgery** | One change requires editing 10+ files | Consolidate related logic |
| **Primitive obsession** | Strings/numbers for domain concepts | Create domain types |

---

## File Organization

### Feature-Based (Recommended)
```
src/
├── features/
│   ├── auth/
│   │   ├── LoginForm.tsx
│   │   ├── useAuth.ts
│   │   ├── authStore.ts
│   │   ├── authApi.ts
│   │   └── auth.test.ts
│   └── agents/
│       ├── AgentCard.tsx
│       └── agentApi.ts
├── shared/
│   ├── components/    # Button, Modal, Input
│   ├── hooks/         # useDebounce, useLocalStorage
│   └── utils/         # formatDate, parseUrl
└── app/
    ├── App.tsx
    ├── router.tsx
    └── providers.tsx
```

**Colocation Principle:** Put code as close as possible to where it's used. Only move it up when it's shared by multiple features.

---

## Self-Review Checklist (Before Checker Gets It)

- [ ] Does every function have a clear, single purpose?
- [ ] Are names descriptive and consistent?
- [ ] Are there any magic numbers or strings?
- [ ] Is error handling appropriate (not swallowed, not over-caught)?
- [ ] Any unnecessary comments (code should explain itself)?
- [ ] Is there duplicated logic that should be extracted?
- [ ] Are imports organized and unused imports removed?
- [ ] Does the code handle edge cases (null, empty, undefined)?
- [ ] Are TypeScript types accurate (no `any`)?
- [ ] Would a teammate understand this without explanation?

---

## Daily Rules

1. Names reveal intent — if you need a comment to explain a name, rename it
2. Functions do one thing — max 30 lines, max 3 parameters
3. Guard clauses over nesting — early returns flatten code
4. Comments explain WHY — the code explains WHAT
5. Feature-based file organization — colocate related code
6. Self-review before Checker — run the checklist above
7. Wrong abstraction > duplication — don't DRY prematurely
