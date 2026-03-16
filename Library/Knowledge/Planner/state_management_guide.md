# State Management Guide for Modern Web Apps
**Category:** Frontend
**Sources:**
- https://www.developerway.com/posts/react-state-management-2025
- https://javascript.plainenglish.io/zustand-and-tanstack-query-the-dynamic-duo-that-simplified-my-react-state-management-e71b924efb90
- https://www.alexisdata.com/2025/12/30/tanstack-query-vs-redux-complete-comparison-guide-for-state-management/
- https://inhaq.com/blog/react-state-management-2026-redux-vs-zustand-vs-jotai.html
- https://www.nucamp.co/blog/state-management-in-2026-redux-context-api-and-modern-patterns
- https://dev.to/saswatapal/do-you-need-state-management-in-2025-react-context-vs-zustand-vs-jotai-vs-redux-1ho
- https://www.it-labs.com/stop-using-redux-for-server-state-why-tanstack-query-is-the-better-choice-in-2025/
- https://digiscorp.com/react-state-management-libraries-which-one-should-you-choose-in-2025/
- https://www.c-sharpcorner.com/article/state-management-in-react-2026-best-practices-tools-real-world-patterns/
- https://oneuptime.com/blog/post/2026-01-24-react-context-performance-issues/view
- https://www.developerway.com/posts/how-to-write-performant-react-apps-with-context
- https://www.tenxdeveloper.com/blog/optimizing-react-context-performance
- https://jotai.org/docs/basics/comparison
- https://dev.to/hijazi313/state-management-in-2025-when-to-use-context-redux-zustand-or-jotai-2d2k
- https://www.reactlibraries.com/blog/zustand-vs-jotai-vs-valtio-performance-guide-2025
- https://betterstack.com/community/guides/scaling-nodejs/zustand-vs-redux-toolkit-vs-jotai/
- https://nuqs.dev/
- https://github.com/47ng/nuqs
- https://www.infoq.com/news/2025/12/nuqs-react-advanced/

**Last updated:** 2026-03-01

---

## The Fundamental Insight

The era of putting everything into one state management library is over. In 2025-2026, state management is a hybrid game. Different types of state require different tools.

**The five categories of state:**

| State Type | Description | Best Tool |
|-----------|-------------|-----------|
| **Local state** | Component-specific data (toggles, input values, modal open/close) | `useState`, `useReducer` |
| **Shared client state** | Client-side data needed by multiple components (shopping cart, UI preferences) | Zustand, Jotai, or Redux Toolkit |
| **Server state** | Data owned by the server (API responses, database records) | TanStack Query or SWR |
| **URL state** | State that should be in the URL (filters, search, pagination, selected tab) | nuqs, or `useSearchParams` |
| **Global/environment state** | Rarely-changing app-wide data (theme, locale, auth user, feature flags) | React Context |

**The default recommended stack for new projects (2025-2026):**
```
TanStack Query (server state) + nuqs (URL state) + Zustand (client state if needed)
```

---

## Local State: useState and useReducer

### useState -- The Default

Most state should be local. If only one component needs it, keep it there.

```typescript
// This is perfectly fine. No need for a state library.
function Modal() {
  const [isOpen, setIsOpen] = useState(false);
  return (/* ... */);
}
```

**When useState is enough:**
- Toggle states (open/close, show/hide, enabled/disabled)
- Form input values (for simple forms)
- Selected items in a list
- Loading/error states for component-specific operations
- Any state that no other component needs to know about

**Common mistake:** Reaching for Redux or Zustand for state that belongs in useState. If only one component uses it, keep it local.

---

### useReducer -- When State Logic Gets Complex

**Use instead of useState when:**
- Multiple related state values change together
- Next state depends on previous state in complex ways
- State transitions follow business rules (state machine-like behavior)
- You want to centralize state update logic for testability

```typescript
type CartAction =
  | { type: 'ADD_ITEM'; item: Product; quantity: number }
  | { type: 'REMOVE_ITEM'; itemId: string }
  | { type: 'UPDATE_QUANTITY'; itemId: string; quantity: number }
  | { type: 'CLEAR' };

function cartReducer(state: CartState, action: CartAction): CartState {
  switch (action.type) {
    case 'ADD_ITEM':
      // Complex logic: check if item exists, merge quantities, recalculate totals
      const existing = state.items.find(i => i.id === action.item.id);
      if (existing) {
        return {
          ...state,
          items: state.items.map(i =>
            i.id === action.item.id
              ? { ...i, quantity: i.quantity + action.quantity }
              : i
          ),
        };
      }
      return { ...state, items: [...state.items, { ...action.item, quantity: action.quantity }] };
    // ... other cases
  }
}
```

---

## React Context API

### When Context Works Well

Context is designed for data that is "global" for a component tree -- values that rarely change and are needed by many components at different nesting levels.

**Good candidates for Context:**
- Theme (light/dark mode)
- Locale/language
- Authenticated user object
- Feature flags
- App-level configuration

**Pattern -- separate state and dispatch:**
```typescript
// Create two contexts to prevent unnecessary re-renders
const UserStateContext = createContext<UserState | null>(null);
const UserDispatchContext = createContext<Dispatch<UserAction> | null>(null);

function UserProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(userReducer, initialState);

  const memoizedState = useMemo(() => state, [state]);

  return (
    <UserStateContext.Provider value={memoizedState}>
      <UserDispatchContext.Provider value={dispatch}>
        {children}
      </UserDispatchContext.Provider>
    </UserStateContext.Provider>
  );
}

// Components that only dispatch actions don't re-render when state changes
function LogoutButton() {
  const dispatch = useContext(UserDispatchContext);  // Only dispatch, no state
  return <button onClick={() => dispatch({ type: 'LOGOUT' })}>Logout</button>;
}
```

---

### When Context Kills Performance

**The problem:** When a context value changes, React re-renders EVERY component that consumes it, regardless of whether the specific data that component uses actually changed.

**Example of the problem:**
```typescript
// BAD: One context with everything
const AppContext = createContext({
  user: null,
  theme: 'light',
  notifications: [],
  sidebarOpen: false,
});

// Updating sidebarOpen re-renders every component that reads user, theme, or notifications
```

**Solutions (in order of preference):**

1. **Split contexts by update frequency:**
   ```typescript
   <ThemeContext.Provider>       {/* Changes rarely */}
   <AuthContext.Provider>        {/* Changes on login/logout */}
   <NotificationContext.Provider> {/* Changes frequently */}
   ```

2. **Memoize context values:**
   ```typescript
   const value = useMemo(() => ({ user, preferences }), [user, preferences]);
   return <UserContext.Provider value={value}>{children}</UserContext.Provider>;
   ```

3. **Selector pattern with use-context-selector:**
   ```typescript
   import { useContextSelector } from 'use-context-selector';
   const userName = useContextSelector(UserContext, (ctx) => ctx.name);
   // Only re-renders when ctx.name changes, not when ctx.email changes
   ```

4. **Isolate heavy children with React.memo:**
   ```typescript
   const HeavyChart = React.memo(function HeavyChart({ data }: { data: ChartData }) {
     // Will not re-render when the parent's context changes, only when data changes
     return <Chart data={data} />;
   });
   ```

5. **Move state to external store for high-frequency updates:**
   If the state changes on every keystroke, mouse move, or scroll event, Context is the wrong tool. Use Zustand or Jotai instead.

**Performance comparison:** Zustand's selective subscriptions prevent 40-70% more re-renders compared to Context API. Redux with proper selectors performs similarly.

---

## Zustand -- The Pragmatic Choice

Zustand (German for "state") is a lightweight (1.16KB gzipped) state management library with a hook-based API. No providers needed. No boilerplate.

### When to Choose Zustand
- Most React apps that need shared client state
- Teams that want simplicity without sacrificing capability
- When migrating from Redux (Zustand requires 70-90% less code)
- When you need middleware (persistence, DevTools, immer)
- When you need to access state outside React (e.g., in utility functions)

### When NOT to Choose Zustand
- When local state or Context is sufficient (do not add libraries you do not need)
- When you need atomic, bottom-up state composition (consider Jotai)
- When enterprise-grade tooling and strict patterns are required (consider Redux Toolkit)

### How It Works

```typescript
import { create } from 'zustand';

interface CartStore {
  items: CartItem[];
  addItem: (item: Product, quantity: number) => void;
  removeItem: (itemId: string) => void;
  clearCart: () => void;
  totalPrice: () => number;
}

const useCartStore = create<CartStore>((set, get) => ({
  items: [],

  addItem: (item, quantity) => set((state) => ({
    items: [...state.items, { ...item, quantity }],
  })),

  removeItem: (itemId) => set((state) => ({
    items: state.items.filter(i => i.id !== itemId),
  })),

  clearCart: () => set({ items: [] }),

  totalPrice: () => get().items.reduce((sum, i) => sum + i.price * i.quantity, 0),
}));

// Usage in components -- only re-renders when selected state changes
function CartCount() {
  const count = useCartStore((state) => state.items.length);
  return <span>{count}</span>;
}

function CartTotal() {
  const total = useCartStore((state) => state.totalPrice());
  return <span>${total}</span>;
}
```

### Key Features
- **No Provider required** -- works anywhere, including outside React
- **Selective subscriptions** -- components only re-render when their selected state changes
- **Middleware** -- persist to localStorage, integrate with Redux DevTools, use immer for immutable updates
- **TypeScript-first** -- excellent type inference out of the box
- **Tiny bundle** -- 1.16KB gzipped

---

## Jotai -- The Atomic Alternative

Jotai (Japanese for "state") takes an atomic, bottom-up approach. State is broken into minimal units (atoms) that compose together.

### When to Choose Jotai
- Complex interdependent state where derived values are critical
- Fine-grained reactivity needed (many independent pieces of state)
- Real-time collaborative features (each field can be an atom)
- When you need Suspense integration for async atoms
- When coming from Recoil (similar mental model, better maintained)

### When NOT to Choose Jotai
- Simple apps where useState and Context are sufficient
- When the team prefers a centralized store model (Zustand/Redux)
- When you need Redux DevTools integration (Zustand has better support)

### How It Works

```typescript
import { atom, useAtom } from 'jotai';

// Primitive atoms
const darkModeAtom = atom(false);
const fontSizeAtom = atom(16);

// Derived atom -- recomputes when dependencies change
const themeAtom = atom((get) => ({
  dark: get(darkModeAtom),
  fontSize: get(fontSizeAtom),
  backgroundColor: get(darkModeAtom) ? '#1a1a1a' : '#ffffff',
}));

// Writable derived atom
const toggleDarkModeAtom = atom(
  (get) => get(darkModeAtom),
  (get, set) => set(darkModeAtom, !get(darkModeAtom))
);

// Components only re-render when their specific atoms change
function FontSizeControl() {
  const [fontSize, setFontSize] = useAtom(fontSizeAtom);
  // Does NOT re-render when darkMode changes
  return <input type="range" value={fontSize} onChange={(e) => setFontSize(+e.target.value)} />;
}
```

### Key Difference from Zustand
- **Zustand:** Top-down. One store, select what you need.
- **Jotai:** Bottom-up. Many atoms, compose what you need.

**Rule of thumb:** If you think in "stores with selectors," use Zustand. If you think in "individual reactive values," use Jotai.

---

## Redux Toolkit -- The Enterprise Standard

Redux Toolkit (RTK) is the official, opinionated toolset for Redux. It reduces boilerplate significantly compared to vanilla Redux.

### When to Choose Redux Toolkit
- Large enterprise applications with 5+ developers
- Teams that need strict architectural patterns and conventions
- Complex state with many interconnected slices
- When Redux DevTools and time-travel debugging are essential
- When the team already knows Redux
- When you need RTK Query for data fetching within the Redux ecosystem

### When NOT to Choose Redux Toolkit
- New projects with small teams (Zustand is simpler)
- When most state is server state (TanStack Query handles it better)
- When the boilerplate-to-value ratio does not justify it
- Rapid prototyping or MVPs

### Adoption in 2025
- Hand-written Redux is down to roughly 10% of new projects
- Redux Toolkit remains common in enterprises
- RTK Query competes with TanStack Query for data fetching

---

## Library Comparison Matrix

| Feature | Context | Zustand | Jotai | Redux Toolkit |
|---------|---------|---------|-------|---------------|
| **Bundle size** | 0 KB (built-in) | 1.16 KB | ~4 KB | ~11 KB |
| **Boilerplate** | Low | Minimal | Minimal | Medium |
| **Learning curve** | Low | Low | Low-Medium | Medium-High |
| **Provider needed** | Yes | No | Optional | Yes |
| **Re-render control** | Poor (all consumers) | Good (selectors) | Excellent (atomic) | Good (selectors) |
| **DevTools** | React DevTools | Redux DevTools via middleware | Limited | Excellent (Redux DevTools) |
| **Middleware** | None | Yes (persist, immer, etc.) | Limited | Yes (thunk, saga, etc.) |
| **TypeScript** | Good | Excellent | Excellent | Excellent |
| **Outside React** | No | Yes | No | Yes |
| **Best for** | Theme, locale, auth | Most shared client state | Complex derived state | Enterprise apps |
| **2025 adoption trend** | Stable | Growing 30%+ YoY | Growing | Declining for new projects |

---

## Server State: TanStack Query

Server state is fundamentally different from client state. It is: asynchronous, owned by a remote source, potentially stale, shared across components, and requires caching strategy.

### Why TanStack Query Is the Default (2025)

TanStack Query (formerly React Query) manages approximately 80% of an app's data in modern setups. Applications using it show 40-60% fewer network requests compared to naive implementations.

### What It Provides

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => api.getUser(userId),
    staleTime: 5 * 60 * 1000,      // Data is fresh for 5 minutes
    gcTime: 30 * 60 * 1000,         // Keep in cache for 30 minutes
  });

  const queryClient = useQueryClient();

  const updateUser = useMutation({
    mutationFn: (data: UserUpdate) => api.updateUser(userId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['user', userId] });
    },
  });

  if (isLoading) return <Skeleton />;
  if (error) return <ErrorDisplay error={error} />;
  return <ProfileForm user={user} onSubmit={updateUser.mutate} />;
}
```

### Key Features
- **Automatic caching and deduplication** -- multiple components requesting the same data trigger only one network call
- **Background refetching** -- data stays fresh without manual intervention
- **Stale-while-revalidate** -- shows cached data immediately, updates in the background
- **Optimistic updates** -- update the UI before the server confirms
- **Infinite queries** -- built-in support for infinite scrolling
- **Prefetching** -- load data before the user needs it
- **Retry logic** -- automatic retries with exponential backoff
- **Window focus refetching** -- refetch when the user returns to the tab

### TanStack Query vs. RTK Query

| Criteria | TanStack Query | RTK Query |
|----------|---------------|-----------|
| Setup | Simple, standalone | Requires Redux store |
| Best for | Server state only | Server + global client state |
| Framework support | React, Vue, Svelte, Solid, Vanilla | React/Redux only |
| SSR/RSC support | Fully compatible | Possible with more setup |
| Community | Larger, more active | Redux ecosystem |
| Pick if... | Not using Redux | Already using Redux |

---

## URL State: nuqs

URL state is state that should survive page refreshes and be shareable via links. Examples: search queries, filters, pagination, sort order, selected tabs, date ranges.

### Why URL State Matters
- **Shareability:** A link captures the exact app state
- **Browser navigation:** Back/forward buttons navigate state changes
- **Bookmarkability:** Users can bookmark filtered views
- **SEO:** Search engines can index filtered/sorted pages

### nuqs -- The Type-Safe Solution

nuqs is a lightweight (6KB gzipped) library used by Sentry, Supabase, Vercel, and Clerk. It provides a `useState`-like API that syncs with URL query parameters.

```typescript
import { useQueryState, parseAsInteger, parseAsString } from 'nuqs';

function ProductList() {
  const [search, setSearch] = useQueryState('q', parseAsString.withDefault(''));
  const [page, setPage] = useQueryState('page', parseAsInteger.withDefault(1));
  const [sort, setSort] = useQueryState('sort', parseAsString.withDefault('newest'));

  // URL: /products?q=shoes&page=2&sort=price
  // Sharing this URL reproduces the exact state
}
```

### When to Use URL State
- Filters and search queries
- Pagination and sorting
- Selected tabs or navigation state
- Dashboard configuration (date range, selected metrics)
- Any state the user should be able to share or bookmark

### When NOT to Use URL State
- Sensitive data (passwords, tokens) -- never in the URL
- Very frequently changing values (mouse position, scroll offset) -- browsers rate-limit URL updates to ~50ms
- Large data structures -- URLs have size limits
- Temporary UI state (modal open/close, hover effects)

### Framework Support
nuqs works with: Next.js (app and pages routers), plain React SPAs, Remix, React Router, TanStack Router, and custom routers via adapters.

---

## Decision Flowchart: Choosing the Right State Tool

```
Is this state from the server (API data)?
  YES --> TanStack Query
  NO  --> Continue

Should this state be in the URL (shareable, bookmarkable)?
  YES --> nuqs (or useSearchParams)
  NO  --> Continue

Is this state used by only one component?
  YES --> useState (or useReducer if complex)
  NO  --> Continue

Does this state change rarely (theme, locale, auth)?
  YES --> React Context
  NO  --> Continue

Is this state needed by many components and changes frequently?
  YES --> Zustand (default choice)
         OR Jotai (if atomic/derived state is important)
         OR Redux Toolkit (if enterprise team with existing Redux)
  NO  --> Reconsider if it should be local state
```

---

## The Recommended Stack by Project Size

### Small Project (1-3 developers, MVP)
```
useState + useReducer (local state)
React Context (theme, auth)
TanStack Query (server data)
```
No additional state library needed. Start here.

### Medium Project (3-10 developers, growing product)
```
useState + useReducer (local state)
React Context (theme, auth, locale)
TanStack Query (server data)
Zustand (shared client state: cart, UI preferences)
nuqs (URL state: filters, search, pagination)
```

### Large Project (10+ developers, enterprise)
```
useState + useReducer (local state)
React Context (theme, auth, locale, feature flags)
TanStack Query (server data)
Redux Toolkit OR Zustand (shared client state)
nuqs (URL state)
```

---

## Common Mistakes

### 1. Using One Tool for Everything
"Put everything in Redux" was the 2018 approach. It is wrong in 2025. Server state belongs in TanStack Query. URL state belongs in the URL. Local state belongs in useState. Only shared client state needs a state library.

### 2. Premature State Library Adoption
Adding Zustand or Redux to a project with 3 components and one API call. Start with useState and Context. Add tools when you hit real pain points.

### 3. Storing Server Data in Client State
Fetching data with useEffect, storing it in Redux/Zustand, and manually managing loading/error/stale states. TanStack Query does this better with less code and handles caching, deduplication, and background refetching automatically.

### 4. Overusing Context for Frequently Changing State
Putting form input values, mouse positions, or real-time data in Context. Every change re-renders all consumers. Use Zustand or Jotai for frequently changing shared state.

### 5. Not Using URL State for Shareable State
Storing filters, search queries, and pagination in useState. When the user refreshes the page or shares the link, the state is lost. Use nuqs or useSearchParams.

---

## Planner's Application

When writing blueprints, Planner uses this knowledge to:

1. **Categorize state in the blueprint.** For each feature, explicitly name the state categories and their tools:
   ```
   ## Dashboard Feature
   - Server state: TanStack Query (metrics API, user data API)
   - URL state: nuqs (date range, selected metrics, comparison mode)
   - Local state: useState (tooltip visibility, expanded sections)
   - No shared client state needed for this feature
   ```

2. **Choose the state management stack and justify it.** The blueprint should state the stack explicitly: "TanStack Query + Zustand + nuqs. We chose Zustand over Redux because the team is 5 developers and simplicity is prioritized. We chose nuqs for all filter/search state so pages are shareable."

3. **Define data flow.** The blueprint should specify where data comes from, how it flows through the app, and which components own which state. This prevents Builder from guessing.

4. **Prevent over-engineering.** For MVPs, the blueprint should explicitly state: "No state management library for Phase 1. Use useState and Context. Re-evaluate if shared client state becomes a pain point." This saves the team from premature complexity.

5. **Specify caching strategy for server state.** The blueprint should define: "User profile: 5min stale time (rarely changes). Product list: 30s stale time (changes frequently). Real-time notifications: no caching (always fresh via WebSocket)."

6. **Define state persistence requirements.** Some state needs to survive page refreshes (URL state, persisted Zustand stores). Some state is ephemeral (modal open state). The blueprint should specify which is which.

7. **Plan for state debugging.** The blueprint should note: "Enable Redux DevTools middleware for Zustand in development. Use TanStack Query DevTools for server state inspection. Use React DevTools Profiler for re-render analysis."
