# Essential Design Patterns for Web Application Architecture
**Category:** Architecture
**Sources:**
- https://refactoring.guru/design-patterns/catalog
- https://sourcemaking.com/design_patterns
- https://www.patterns.dev/
- https://dev.to/frontendtoolstech/javascript-design-patterns-explained-2025-guide-3j4a
- https://www.technologyandstrategy.com/news/design-patterns-the-complete-guide-2025
- https://www.sencha.com/blog/comprehensive-guide-javascript-design-pattern/
- https://www.geeksforgeeks.org/system-design/latest-design-patterns-for-web-development/
- https://shakuro.com/blog/mvc-vs-mvvm
- https://www.techtarget.com/searchapparchitecture/tip/MVC-vs-MVVM-2-architecture-patterns-for-modularity

**Last updated:** 2026-03-01

---

## Why Patterns Matter

Design patterns are reusable solutions to commonly occurring problems in software design. They are not code you copy-paste -- they are blueprints for structuring code that has been tested and proven across decades of software development. For web applications in 2025-2026, patterns remain critical because system complexity continues to grow, cross-domain integration is standard, and teams need shared vocabulary to communicate architectural decisions.

The Gang of Four (GoF) defined three categories:
- **Creational** -- how objects are instantiated
- **Structural** -- how classes/objects are composed
- **Behavioral** -- how objects communicate and distribute responsibility

---

## Creational Patterns

### Singleton

**What it does:** Ensures a class has only one instance and provides a global access point to it.

**When to use:**
- Database connection pools
- Configuration managers
- Logger instances
- Application-wide caches
- Service registries

**When NOT to use:**
- When you need testability (singletons make mocking hard)
- When multiple instances might be needed later (scaling concerns)
- As a glorified global variable -- if you are using it just for convenience, you are doing it wrong

**Common mistakes:**
- Using Singleton as a dumping ground for unrelated global state
- Creating hidden dependencies that make code untestable
- Thread-safety issues in concurrent environments
- Overuse -- most "singletons" should be dependency-injected services instead

**Modern equivalent in JS/TS:** Module-scoped variables (ES modules are singletons by default). A simple `export const config = {...}` is often sufficient.

---

### Factory Method / Abstract Factory

**What it does:** Defines an interface for creating objects but lets subclasses/implementations decide which class to instantiate. Decouples object creation from usage.

**When to use:**
- When the exact type of object needed is determined at runtime
- When you want to centralize complex creation logic
- API response parsing (different response shapes -> different handler objects)
- UI component libraries (render different components based on config)
- Plugin systems

**When NOT to use:**
- When simple constructor calls are sufficient
- When there is only one type to create (unnecessary abstraction)
- When it adds a layer of indirection with no benefit

**Common mistakes:**
- Over-engineering: creating factories for trivial object creation
- Factory classes that grow into god objects containing all creation logic
- Not using TypeScript generics to keep factories type-safe

**Modern equivalent in JS/TS:** Factory functions (plain functions that return objects), React component factories, or configuration-driven component rendering.

```typescript
// Simple factory function
function createNotification(type: 'success' | 'error' | 'warning') {
  const config = {
    success: { color: 'green', icon: 'check', duration: 3000 },
    error: { color: 'red', icon: 'alert', duration: 0 },
    warning: { color: 'yellow', icon: 'warn', duration: 5000 },
  };
  return { ...config[type], type };
}
```

---

## Structural Patterns

### Adapter

**What it does:** Converts the interface of one class/module into an interface that another expects. Makes incompatible interfaces work together.

**When to use:**
- Integrating third-party APIs with different response formats
- Wrapping legacy code to work with new systems
- Normalizing data from multiple sources into a unified shape
- Swapping out libraries (e.g., switching from Axios to Fetch) without changing consumer code

**When NOT to use:**
- When you can modify the original interface directly
- When the adaptation is trivial (a simple mapping function suffices)
- When it hides important differences between systems that consumers should know about

**Common mistakes:**
- Creating adapters that leak the adapted interface's quirks
- Too many layers of adaptation (adapter wrapping adapter)
- Not handling edge cases from the adapted interface

```typescript
// Adapting a third-party payment API to your interface
interface PaymentGateway {
  charge(amount: number, currency: string): Promise<PaymentResult>;
}

class StripeAdapter implements PaymentGateway {
  constructor(private stripe: StripeClient) {}

  async charge(amount: number, currency: string): Promise<PaymentResult> {
    const result = await this.stripe.paymentIntents.create({
      amount: amount * 100, // Stripe uses cents
      currency: currency.toLowerCase(),
    });
    return { id: result.id, status: result.status === 'succeeded' ? 'ok' : 'failed' };
  }
}
```

---

### Decorator

**What it does:** Attaches new behavior to objects dynamically by wrapping them, without altering the original object's code.

**When to use:**
- Adding logging, caching, or retry logic to existing functions/services
- Composing features incrementally (middleware pipelines)
- When inheritance would create an explosion of subclasses
- React Higher-Order Components (HOCs) are decorators

**When NOT to use:**
- When the behavior is core to the object (just put it in the class)
- When the decoration order matters but is not enforced
- When wrapping creates confusing debugging stacks

**Common mistakes:**
- Deep nesting of decorators making the call stack unreadable
- Performance degradation from too many wrapper layers
- Not preserving the original interface contract

**Modern equivalent in JS/TS:** Higher-order functions, middleware chains (Express/Koa), TypeScript decorators, React HOCs (though custom hooks are now preferred).

```typescript
// Function decorator for caching
function withCache<T extends (...args: any[]) => Promise<any>>(fn: T, ttl: number): T {
  const cache = new Map<string, { data: any; expiry: number }>();
  return (async (...args: any[]) => {
    const key = JSON.stringify(args);
    const cached = cache.get(key);
    if (cached && cached.expiry > Date.now()) return cached.data;
    const result = await fn(...args);
    cache.set(key, { data: result, expiry: Date.now() + ttl });
    return result;
  }) as any as T;
}
```

---

### Facade

**What it does:** Provides a simplified interface to a complex subsystem. Hides complexity behind a clean API.

**When to use:**
- Wrapping complex third-party libraries
- Creating SDK-like interfaces for internal services
- Simplifying multi-step processes into single calls
- API route handlers that orchestrate multiple services

**When NOT to use:**
- When the simplified interface hides critical details consumers need
- When it becomes a god object that does everything
- When consumers need fine-grained control over the subsystem

**Common mistakes:**
- Facade becoming a bottleneck for all changes
- Hiding errors or edge cases that consumers should handle
- Creating a facade that is just as complex as the subsystem

```typescript
// Facade for user onboarding (hides 4 services behind 1 call)
class OnboardingFacade {
  async onboardUser(data: SignupData): Promise<OnboardingResult> {
    const user = await this.userService.create(data);
    await this.emailService.sendWelcome(user.email);
    await this.billingService.createFreeAccount(user.id);
    await this.analyticsService.trackSignup(user.id);
    return { userId: user.id, status: 'complete' };
  }
}
```

---

## Behavioral Patterns

### Observer

**What it does:** Defines a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

**When to use:**
- Event systems (DOM events, custom events, WebSocket messages)
- Real-time notifications and chat systems
- State management (Redux, Zustand -- all are Observer under the hood)
- Reactive data flows
- Pub/sub messaging between decoupled components

**When NOT to use:**
- When there is a simple 1:1 relationship (just call the function directly)
- When the notification chain can create circular dependencies
- When debugging event flows becomes impossible (too many observers)

**Common mistakes:**
- Memory leaks from not unsubscribing (especially in React useEffect)
- Cascading updates causing infinite loops
- No way to trace which observer caused a side effect
- Event ordering assumptions that break under concurrency

**Modern equivalent in JS/TS:** EventEmitter, RxJS Observables, browser CustomEvents, React's useState/useEffect (component-level observer), Zustand subscriptions.

---

### Strategy

**What it does:** Defines a family of algorithms, encapsulates each one, and makes them interchangeable. The algorithm varies independently from the clients that use it.

**When to use:**
- Multiple sorting/filtering/validation algorithms
- Payment processing (different providers, same interface)
- Authentication strategies (OAuth, JWT, API key)
- Feature flags that swap implementations at runtime

**When NOT to use:**
- When there is only one algorithm and unlikely to be more
- When the algorithms share almost no common interface
- When a simple if/else or switch is clearer

**Common mistakes:**
- Over-abstracting: creating strategy interfaces for code that never varies
- Strategies that depend on each other (violates the pattern)
- Not making the strategy selection mechanism clear

```typescript
// Validation strategy
type ValidationStrategy = (value: string) => string | null;

const required: ValidationStrategy = (v) => v.trim() ? null : 'Required';
const minLength = (n: number): ValidationStrategy =>
  (v) => v.length >= n ? null : `Min ${n} characters`;
const email: ValidationStrategy = (v) =>
  /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) ? null : 'Invalid email';

function validate(value: string, strategies: ValidationStrategy[]): string[] {
  return strategies.map(s => s(value)).filter(Boolean) as string[];
}
```

---

### Command

**What it does:** Encapsulates a request as an object, letting you parameterize clients with different requests, queue or log requests, and support undo/redo operations.

**When to use:**
- Undo/redo functionality (text editors, drawing apps)
- Task queues and job scheduling
- Macro recording (sequence of actions to replay)
- Transaction-like operations that can be rolled back
- CQRS (Command Query Responsibility Segregation) architectures

**When NOT to use:**
- Simple CRUD operations where direct calls are clearer
- When undo/redo is not needed and the extra object layer adds no value
- Real-time operations where the command overhead is unacceptable

**Common mistakes:**
- Commands that are too granular (one command per field change)
- Not implementing proper undo for each command
- Command objects that grow to contain business logic that belongs elsewhere

---

## Architectural Patterns

### MVC (Model-View-Controller)

**What it does:** Separates an application into three concerns: Model (data/business logic), View (presentation), and Controller (input handling and coordination).

**When to use:**
- Server-side web applications (Rails, Django, ASP.NET, Express)
- Applications where the backend controls rendering
- APIs with clear request/response cycles
- When simplicity and team familiarity matter

**When NOT to use:**
- Complex SPAs with heavy client-side state (MVVM or component-based is better)
- Real-time applications where the request/response cycle does not apply
- When you need two-way data binding

**Common mistakes:**
- Fat controllers that contain business logic (should be in services/models)
- Views that directly access models (bypassing controllers)
- Not separating the service layer from controller logic

---

### MVVM (Model-View-ViewModel)

**What it does:** Introduces a ViewModel between Model and View that prepares data for display and handles user interactions through data binding. The View binds directly to the ViewModel.

**When to use:**
- Single-page applications (React, Angular, Vue)
- Applications with complex, dynamic UIs
- When you want independent testability of UI logic
- When two-way data binding improves developer experience

**When NOT to use:**
- Simple server-rendered pages where MVC is sufficient
- When the overhead of ViewModels is not justified by UI complexity
- Small applications where the extra abstraction layer slows development

**Key difference from MVC:** In MVC, the Controller is the entry point and orchestrates sequential request/response flows. In MVVM, the View is the entry point, and data flows are reactive and bidirectional.

| Aspect | MVC | MVVM |
|--------|-----|------|
| Entry point | Controller | View |
| Data flow | Sequential request/response | Reactive, bidirectional |
| Data binding | Manual | Automatic (two-way) |
| Best for | Server-side apps | Client-side SPAs |
| Testing | Controllers testable separately | ViewModels testable without UI |
| Complexity | Simpler | More layers, more power |

**Modern reality:** React is not purely MVC or MVVM -- it is component-based with unidirectional data flow. But understanding both patterns helps Planner reason about separation of concerns in any architecture.

---

## Quick Reference: Pattern Selection Guide

| Problem | Pattern | Web Example |
|---------|---------|-------------|
| Need exactly one instance | Singleton | DB connection pool, app config |
| Create objects without specifying exact class | Factory | Component rendering from config |
| Make incompatible interfaces work together | Adapter | Third-party API integration |
| Add behavior without modifying original | Decorator | Middleware, logging, caching |
| Simplify a complex subsystem | Facade | Multi-service orchestration |
| Notify multiple objects of state change | Observer | Event systems, state management |
| Swap algorithms at runtime | Strategy | Payment methods, auth strategies |
| Encapsulate actions as objects | Command | Undo/redo, task queues |
| Separate data, display, and control | MVC | Server-side web apps |
| Bind data to UI with ViewModel | MVVM | SPAs with complex UIs |

---

## Planner's Application

When writing blueprints, Planner uses this knowledge to:

1. **Select the right patterns early.** The blueprint should name which patterns apply to each major component. Example: "Payment module uses Strategy pattern for provider selection, Adapter pattern for API normalization, and Facade for the public SDK."

2. **Prevent over-engineering.** If a blueprint calls for a Factory when simple constructor calls work, or a Singleton when a module export suffices, the design is overcomplicated. The simplest pattern that solves the problem is the right one.

3. **Communicate architecture to Builder.** Naming patterns in the blueprint gives Builder a shared vocabulary. Instead of describing "a thing that wraps another thing to add caching," write "Decorator pattern for caching layer."

4. **Choose the right architectural pattern.** For server-rendered apps, specify MVC. For SPAs with complex state, specify component-based with MVVM-inspired data binding. For APIs, specify clean separation of routes/controllers/services.

5. **Anticipate evolution.** Some patterns (Strategy, Observer) make systems extensible. If the blueprint anticipates growth (e.g., "more payment providers will be added"), specify the pattern that enables extension without modification (Open/Closed Principle + Strategy).

6. **Flag anti-patterns in reviews.** When reviewing Builder's code, Planner can identify: god objects that need Facade decomposition, duplicated creation logic that needs Factory extraction, tightly coupled components that need Observer/event-driven decoupling.
