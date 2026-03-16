# TypeScript
**When to use:** Read when writing TypeScript types, generics, utility types, or configuring tsconfig.

---

## Type System Fundamentals

### Primitive & Literal Types
```typescript
// Literal types — narrow a type to exact values
type Direction = "north" | "south" | "east" | "west";
type HttpStatus = 200 | 301 | 404 | 500;

// Template literal types — string pattern enforcement
type EventName = `on${string}`;        // "onClick", "onHover", etc.
type CSSUnit = `${number}px` | `${number}rem` | `${number}%`;
type Route = `/${string}`;
```

### Discriminated Unions — Most Useful Pattern
```typescript
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rect"; width: number; height: number }
  | { kind: "triangle"; base: number; height: number };

function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle": return Math.PI * shape.radius ** 2;
    case "rect": return shape.width * shape.height;
    case "triangle": return (shape.base * shape.height) / 2;
  }
}
```

### Intersection Types
```typescript
type WithId = { id: string };
type WithTimestamps = { createdAt: Date; updatedAt: Date };
type User = WithId & WithTimestamps & { name: string; email: string };
```

---

## Generics

### Basic Generics
```typescript
function first<T>(arr: T[]): T | undefined { return arr[0]; }
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] { return obj[key]; }

interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}
type UserResponse = ApiResponse<User>;
```

### Generic React Component
```typescript
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string;
}
function List<T>({ items, renderItem, keyExtractor }: ListProps<T>) {
  return <ul>{items.map(item => <li key={keyExtractor(item)}>{renderItem(item)}</li>)}</ul>;
}
```

---

## Utility Types — Daily Toolkit

| Utility | What It Does | Example |
|---------|-------------|---------|
| `Partial<T>` | All properties optional | `Partial<User>` — for update payloads |
| `Required<T>` | All properties required | `Required<Config>` |
| `Pick<T, K>` | Keep only listed keys | `Pick<User, "id" \| "name">` |
| `Omit<T, K>` | Remove listed keys | `Omit<User, "password">` |
| `Record<K, V>` | Object with typed keys/values | `Record<string, number>` |
| `Exclude<U, E>` | Remove members from union | `Exclude<Status, "deleted">` |
| `Extract<U, E>` | Keep only matching members | `Extract<Event, { type: "click" }>` |
| `ReturnType<F>` | Get function's return type | `ReturnType<typeof fetchUser>` |
| `Parameters<F>` | Get function's param types | `Parameters<typeof createUser>` |
| `Awaited<T>` | Unwrap Promise type | `Awaited<Promise<User>>` → `User` |
| `NonNullable<T>` | Remove null/undefined | `NonNullable<string \| null>` → `string` |

### Practical Combinations
```typescript
type UserUpdate = Pick<User, "id"> & Partial<Omit<User, "id">>;  // id required, rest optional
type UserCreate = Omit<User, "id" | "createdAt" | "updatedAt">;  // exclude auto-generated fields
type UserView = Readonly<Pick<User, "id" | "name" | "email">>;   // read-only display
```

---

## Type Guards & Narrowing

```typescript
// typeof — for primitives
function format(value: string | number): string {
  if (typeof value === "string") return value.toUpperCase();
  return value.toFixed(2);
}

// in — for object property checking
function handleResponse(res: SuccessResponse | ErrorResponse) {
  if ("error" in res) return console.error(res.error);
  return console.log(res.data);
}

// Custom type guard — most powerful pattern
function isUser(value: unknown): value is User {
  return typeof value === "object" && value !== null && "email" in value;
}

// Assertion function — throws if wrong type
function assertDefined<T>(val: T | undefined, msg: string): asserts val is T {
  if (val === undefined) throw new Error(msg);
}
```

---

## tsconfig Essentials

```jsonc
{
  "compilerOptions": {
    "strict": true,                    // ALWAYS enable
    "noUncheckedIndexedAccess": true,  // arr[0] is T | undefined, not T
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",     // For Vite/webpack projects
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"]
    },
    "jsx": "react-jsx",
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

---

## TypeScript 5.x Features

| Feature | Version | What It Does |
|---------|---------|-------------|
| `satisfies` | 5.0 | Validates type without widening: `const cfg = { port: 3000 } satisfies Config` |
| `const` type params | 5.0 | `function foo<const T>(arr: T)` — preserves literal types |
| Decorators | 5.0 | Stage 3 decorators (not experimental) |
| `using` keyword | 5.2 | Explicit resource management: `using file = openFile()` — auto-cleanup |
| `--isolatedDeclarations` | 5.5 | Faster declaration emit |

---

## Module Patterns

```typescript
// Named exports — PREFERRED (tree-shakeable)
export function createUser() { }
export const MAX_RETRIES = 3;

// Type-only imports — doesn't emit JS
import type { User } from "./types";
export type { User };

// Barrel files — USE SPARINGLY (can break tree-shaking)
export { createUser } from "./createUser";
```

---

## Anti-Patterns to Avoid

```typescript
// 1. any abuse → use unknown + type guards
const data: unknown = fetchData();
if (isUser(data)) { /* now it's User */ }

// 2. Type assertion over guards
// BAD: const user = response as User;
// GOOD: if (isUser(response)) { /* safe */ }

// 3. Enums → prefer unions (zero-cost, better DX)
// BAD: enum Status { Active, Inactive }
// GOOD: type Status = "active" | "inactive";
const STATUS = { Active: "active", Inactive: "inactive" } as const;
type Status = typeof STATUS[keyof typeof STATUS];

// 4. Over-typing → let inference work
// BAD: const name: string = "hello";
// GOOD: const name = "hello";
```

---

## Daily Rules

1. Always `strict: true` in tsconfig — no exceptions
2. Prefer unions over enums — zero-cost, better DX
3. Use discriminated unions for anything with variants
4. Let inference work — only annotate when it can't figure it out
5. Use utility types to derive types from existing ones — never duplicate
6. Custom type guards at system boundaries — validate external data properly
7. `unknown` over `any` — always narrow, never assume
