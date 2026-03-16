# React Patterns & Best Practices (2025-2026)
**Category:** Frontend
**Sources:**
- https://react.dev/learn/you-might-not-need-an-effect
- https://react.dev/reference/react/memo
- https://www.patterns.dev/react/react-2026/
- https://www.sayonetech.com/blog/react-design-patterns/
- https://www.designrush.com/best-designs/websites/trends/react-design-patterns
- https://www.uxpin.com/studio/blog/react-design-patterns/
- https://www.telerik.com/blogs/react-design-patterns-best-practices
- https://www.perssondennis.com/articles/21-fantastic-react-design-patterns-and-when-to-use-them
- https://technostacks.com/blog/react-best-practices/
- https://kentcdodds.com/blog/usememo-and-usecallback
- https://isitdev.com/react-19-compiler-usememo-usecallback-dead-2025/
- https://www.joshwcomeau.com/react/usememo-and-usecallback/
- https://www.debugbear.com/blog/react-usememo-usecallback
- https://itnext.io/6-common-react-anti-patterns-that-are-hurting-your-code-quality-904b9c32e933
- https://blog.logrocket.com/15-common-useeffect-mistakes-react/
- https://www.perssondennis.com/articles/react-anti-patterns-and-best-practices-dos-and-donts
- https://4markdown.com/everything-about-barrel-exports-in-javascript/
- https://tkdodo.eu/blog/please-stop-using-barrel-files
- https://www.atlassian.com/blog/atlassian-engineering/faster-builds-when-removing-barrel-files
- https://www.robinwieruch.de/react-folder-structure/
- https://github.com/alan2207/bulletproof-react/blob/master/docs/project-structure.md

**Last updated:** 2026-03-01

---

## Component Patterns

### Custom Hooks -- The Foundation of Modern React

Custom hooks extract stateful logic into reusable functions. They are the primary mechanism for code reuse in React.

**When to use:**
- Reusable stateful logic (data fetching, form handling, local storage, event listeners)
- When a component has too much logic mixed with rendering
- When the same useState/useEffect pattern appears in multiple components
- To make component tests simpler (mock the hook, not its internals)

**When NOT to use:**
- For logic that has no state or effects (use a plain utility function instead)
- When the hook would only be used by one component and the component is already simple
- For trivial state (a single boolean toggle does not need its own hook)

**Example:**
```typescript
// Custom hook for debounced search
function useDebounceSearch(searchFn: (query: string) => Promise<Results>, delay = 300) {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<Results | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (!query.trim()) { setResults(null); return; }
    const timer = setTimeout(async () => {
      setIsLoading(true);
      const data = await searchFn(query);
      setResults(data);
      setIsLoading(false);
    }, delay);
    return () => clearTimeout(timer);
  }, [query, delay, searchFn]);

  return { query, setQuery, results, isLoading };
}

// Component is now clean
function SearchBar() {
  const { query, setQuery, results, isLoading } = useDebounceSearch(api.search);
  return (/* just rendering logic */);
}
```

**Key benefit for testing:** Once you extract logic into a hook, you test the hook once and mock its return value in component tests. The component test becomes purely about rendering, not about logic.

---

### Compound Components

Multiple components that work together as a single unit, sharing state internally.

**When to use:**
- Complex UI elements: tabs, accordions, dropdowns, menus, form field groups
- When consumers need to customize the structure but the components need shared state
- Building a component library or design system

**When NOT to use:**
- Simple components where a single component with props is sufficient
- When the API surface area becomes too large (too many sub-components)
- When consumers do not need structural flexibility

**Example:**
```tsx
// Compound component pattern
function Tabs({ children, defaultTab }: TabsProps) {
  const [activeTab, setActiveTab] = useState(defaultTab);
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div className="tabs">{children}</div>
    </TabsContext.Provider>
  );
}

Tabs.List = function TabList({ children }: { children: React.ReactNode }) {
  return <div className="tab-list" role="tablist">{children}</div>;
};

Tabs.Tab = function Tab({ id, children }: { id: string; children: React.ReactNode }) {
  const { activeTab, setActiveTab } = useTabsContext();
  return (
    <button role="tab" aria-selected={activeTab === id} onClick={() => setActiveTab(id)}>
      {children}
    </button>
  );
};

Tabs.Panel = function TabPanel({ id, children }: { id: string; children: React.ReactNode }) {
  const { activeTab } = useTabsContext();
  return activeTab === id ? <div role="tabpanel">{children}</div> : null;
};

// Usage -- consumer controls structure
<Tabs defaultTab="settings">
  <Tabs.List>
    <Tabs.Tab id="profile">Profile</Tabs.Tab>
    <Tabs.Tab id="settings">Settings</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel id="profile"><ProfileForm /></Tabs.Panel>
  <Tabs.Panel id="settings"><SettingsForm /></Tabs.Panel>
</Tabs>
```

---

### Higher-Order Components (HOCs)

Functions that take a component and return a new component with additional behavior.

**When to use (rarely in 2025):**
- Cross-cutting concerns that need to wrap many components (auth gates, error boundaries)
- When integrating with class-based codebases or third-party libraries that expect HOCs

**When NOT to use:**
- When a custom hook can achieve the same result (almost always)
- When the HOC nesting creates "wrapper hell" in the component tree
- When props collide between multiple HOCs

**Status in 2025:** HOCs are largely replaced by custom hooks. Use hooks first. Reach for HOCs only when you need to wrap the component itself (e.g., error boundaries cannot be hooks).

---

### Render Props

Components that accept a function as a child (or prop) to control what is rendered.

**When to use (rarely in 2025):**
- When a library exposes this API (some older libraries still do)
- When you need to share rendering logic with structural flexibility

**When NOT to use:**
- When a custom hook achieves the same result more cleanly
- When render prop nesting creates deeply nested JSX

**Status in 2025:** Like HOCs, render props are largely replaced by custom hooks for most use cases.

---

## State Management Patterns

### Local State (useState / useReducer)

**Use when:**
- State is used by only one component or a small component tree
- The state is simple (toggle, input value, selected item)
- No other part of the app needs to know about this state

**useReducer over useState when:**
- State transitions follow complex rules
- Next state depends on previous state in non-trivial ways
- Multiple related state values change together

**Common mistake:** Reaching for global state management (Redux, Zustand) for state that should be local. If only one component uses it, keep it local.

---

### Context API

**Use when:**
- Sharing state that rarely changes: theme, locale, auth status, feature flags
- Avoiding prop drilling for truly global data
- Only a few values are truly global (most apps have fewer than 5)

**Do NOT use when:**
- The value changes frequently (input values, scroll position, mouse coordinates)
- Many consumers need to read different parts of the context (every change re-renders all consumers)
- You need fine-grained re-render control

**See `state_management_guide.md` for detailed Context performance solutions.**

---

### Server State (TanStack Query)

**Use when:**
- Data comes from a server and needs caching, deduplication, background refetching
- Multiple components need the same server data
- You need loading/error states, optimistic updates, infinite scrolling

**This is NOT the same as client state.** Server state is: owned by the server, asynchronous, potentially stale, and shared across components. TanStack Query manages this category. See `state_management_guide.md` for full comparison.

---

## Performance Optimization

### React.memo

**What it does:** Wraps a component so it skips re-rendering if its props have not changed (shallow comparison).

**Use when:**
- The component renders often with the same props
- The component's render is expensive (large lists, complex calculations, many DOM nodes)
- The component is a child of a frequently updating parent

**Do NOT use when:**
- There is no perceptible lag (do not optimize what is not slow)
- Props change on every render (memo is wasted work)
- The component is already fast

---

### useMemo

**What it does:** Caches the result of an expensive computation between renders.

**Use when:**
- Expensive calculations (sorting large arrays, complex data transformations)
- Creating objects/arrays passed as props to memoized children (prevents reference changes)
- Derived data that should not be recalculated on every render

**Do NOT use when:**
- The computation is trivial (basic math, string concatenation)
- The value is not passed to memoized children (the memoization does not prevent any re-render)
- You have not profiled first and confirmed a performance issue exists

---

### useCallback

**What it does:** Caches a function reference between renders.

**Use when:**
- The function is passed as a prop to a React.memo-wrapped child
- The function is used as a dependency in useEffect
- Creating the function is somehow expensive (rare)

**Do NOT use when:**
- The child is not memoized (useCallback has no effect if the child always re-renders anyway)
- You are memoizing every function "just in case" (adds memory overhead with no benefit)

---

### The React Compiler (React 19+, 2025)

**Major shift:** The React Compiler (released v1.0 in October 2025) automatically adds memoization to pure components and props. This makes manual React.memo, useMemo, and useCallback unnecessary in many cases.

**What this means:**
- Write simple, pure components. The compiler handles memoization automatically.
- Manual memoization hooks are still supported but often unnecessary.
- Use manual memo only for: third-party library interop, truly expensive calculations verified by profiling, and cases the compiler cannot optimize.

**Best practice going forward:** Profile first. If the profiler shows a problem, consider manual memoization. If the compiler is enabled, it is probably already handling it.

---

## Anti-Patterns to Avoid

### 1. useEffect Abuse

The React docs are explicit: "Effects are an escape hatch from the React paradigm. If there is no external system involved, you should not need an Effect."

**Common mistakes:**
- Using useEffect for data transformation (use derived state instead)
- Using useEffect for event handling (use event handlers instead)
- Missing dependency arrays (causes runs on every render)
- Forgetting cleanup functions (memory leaks from intervals, subscriptions)
- Creating infinite loops with unstable dependencies (objects/arrays in deps)

**Decision tree -- do you need useEffect?**
```
Is this synchronizing with an external system?
  (API, WebSocket, DOM element, timer, third-party library)
  YES --> useEffect is appropriate
  NO  --> You probably don't need it

Can this be computed from existing props/state?
  YES --> Derive it during render (const derived = transform(data))
  NO  --> Continue

Is this responding to a user event?
  YES --> Put it in the event handler, not useEffect
  NO  --> Continue

Does this need to run once on mount?
  YES --> useEffect with empty deps [], but consider if a data fetching
          library (TanStack Query) handles it better
  NO  --> Rethink whether you need it at all
```

---

### 2. Prop Drilling

Passing props through multiple intermediate components that do not use them.

**Symptoms:**
- Components accept props only to pass them to children
- Changing a prop type requires updating 5+ components in the chain
- Components are tightly coupled to their position in the tree

**Solutions (in order of preference):**
1. **Component composition:** Move the child component up, pass the data directly
2. **Custom hooks:** If multiple components need the same data, extract a hook
3. **Context API:** For truly global, rarely-changing data
4. **State management library:** For frequently-changing shared state

**Important:** Context is not a universal prop-drilling fix. Overusing Context creates its own problems (see performance section). Most apps need fewer than 5 truly global context values.

---

### 3. God Components

Components that handle too many responsibilities: fetching, transforming, validating, rendering.

**Symptoms:**
- Component is 300+ lines
- Component imports from 10+ unrelated modules
- Component has 5+ useState hooks
- Component has 3+ useEffect hooks
- Component is impossible to test in isolation

**Solution:** Decompose into:
```
GodComponent -->
  useFeatureData()        # Custom hook: fetching + transformation
  useFeatureValidation()  # Custom hook: validation logic
  FeatureHeader           # Presentational component
  FeatureBody             # Presentational component
  FeatureActions          # Event handlers + UI
```

---

### 4. Barrel Export Overuse

Barrel files (`index.ts` that re-exports everything) create hidden performance and maintainability costs.

**Problems:**
- **Bundle bloat:** Importing one component from a barrel can pull in all exports
- **Build slowdown:** TypeScript and Jest must process the entire barrel and all its dependencies
- **IDE confusion:** All tabs say "index.ts," jump-to-definition lands on re-exports
- **Tree-shaking interference:** Bundlers struggle to determine what is unused

**Real-world impact:**
- Atlassian achieved 75% faster builds by removing barrel files
- One Next.js project dropped from 11,000 loaded modules to 3,500 after removing barrels (68% reduction)

**Recommendations:**
- Use direct imports for app code: `import { Button } from '@/components/Button'`
- Reserve barrels for library entry points only (published packages need a single entry point)
- If you must use barrels, limit them to public API surfaces of feature modules
- Use `eslint-plugin-no-barrel-files` to enforce
- Next.js has `optimizePackageImports` to mitigate barrel bloat from third-party packages

---

## File Structure: The 2025 Recommendation

### For small projects (1-2 developers, <30 components):
```
src/
  components/
  hooks/
  pages/
  services/
  utils/
  types/
```

### For medium-to-large projects (3+ developers, 30+ components):
```
src/
  features/
    auth/
      components/
      hooks/
      api/
      types/
      utils/
    dashboard/
      components/
      hooks/
      api/
      types/
    billing/
      ...
  shared/
    components/    # Design system components (Button, Modal, Input)
    hooks/         # Shared hooks (useMediaQuery, useDebounce)
    utils/         # Shared utilities (formatDate, validateEmail)
    types/         # Shared types (User, ApiResponse)
  app/             # App-level: routing, providers, layout
```

**Guidelines:**
- Maximum 3-4 levels of nesting
- If a component is used by only one feature, it belongs in that feature
- If a component is used by 2+ features, it belongs in `shared/`
- Each feature folder should have clear boundaries; do not import between features
- Use absolute imports (`@/features/auth/hooks`) to avoid relative path confusion

---

## React 19 Highlights (2025-2026)

Key new features that affect patterns:

| Feature | What it does | Impact on patterns |
|---------|-------------|-------------------|
| **React Compiler** | Automatic memoization | Reduces need for manual React.memo/useMemo/useCallback |
| **useActionState** | Form action state management | Simplifies form handling patterns |
| **useFormStatus** | Pending state for forms | Replaces custom loading state in forms |
| **useOptimistic** | Optimistic UI updates | Built-in pattern for optimistic mutations |
| **use() API** | Read resources in render | New way to handle promises and context |
| **Server Components** | Components that run on the server | Changes data fetching patterns fundamentally |
| **React Hook Form** | Most popular form library (2025) | Pair with Zod for schema validation |

---

## Planner's Application

When writing blueprints, Planner uses this knowledge to:

1. **Specify component decomposition strategy.** The blueprint should indicate which pattern to use: "Dashboard uses compound component pattern for the tab/panel layout. Each widget extracts its data fetching into a custom hook."

2. **Define state management boundaries.** For each feature in the blueprint, specify: "Auth state: Context (changes rarely). Dashboard filters: URL state (shareable). Live data: TanStack Query. UI toggles: local useState."

3. **Flag performance-sensitive areas.** The blueprint should call out: "The data table will display 1000+ rows. Specify virtualization (react-window or TanStack Virtual). Use React.memo on row components. Profile during Checker review."

4. **Prescribe file structure.** Include the folder structure in the blueprint. For projects with 3+ features, always specify feature-based structure. Include the `shared/` convention.

5. **Ban anti-patterns explicitly.** The blueprint can state: "No barrel exports in app code. No god components over 200 lines. No useEffect for data that can be derived. Use TanStack Query for all server data, not raw useEffect + fetch."

6. **Account for React 19 features.** If the project uses React 19+, the blueprint should note: "React Compiler is enabled; do not add manual memoization unless profiling shows a need. Use useActionState for form submissions."

7. **Specify testing strategy per pattern.** Custom hooks are tested with `renderHook()`. Components are tested with React Testing Library. Compound components need integration tests that verify the sub-components work together.
