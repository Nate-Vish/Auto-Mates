# React Patterns
**When to use:** Read when building React components, custom hooks, or implementing React-specific patterns like Suspense, error boundaries, or virtualization.

---

## Custom Hooks — Extract Reusable Logic

Rules of Hooks: top level only, React components/hooks only, must start with `use`.

```typescript
// useLocalStorage
function useLocalStorage<T>(key: string, initial: T) {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key);
    return stored ? JSON.parse(stored) : initial;
  });
  useEffect(() => { localStorage.setItem(key, JSON.stringify(value)); }, [key, value]);
  return [value, setValue] as const;
}

// useDebounce
function useDebounce<T>(value: T, delay: number): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}

// useOnClickOutside
function useOnClickOutside(ref: RefObject<HTMLElement>, handler: () => void) {
  useEffect(() => {
    const listener = (e: MouseEvent | TouchEvent) => {
      if (!ref.current || ref.current.contains(e.target as Node)) return;
      handler();
    };
    document.addEventListener("mousedown", listener);
    document.addEventListener("touchstart", listener);
    return () => {
      document.removeEventListener("mousedown", listener);
      document.removeEventListener("touchstart", listener);
    };
  }, [ref, handler]);
}
```

---

## Compound Components — Shared Implicit State

```typescript
const TabsContext = createContext<{ active: string; setActive: (id: string) => void } | null>(null);

function Tabs({ defaultValue, children }: { defaultValue: string; children: React.ReactNode }) {
  const [active, setActive] = useState(defaultValue);
  return <TabsContext.Provider value={{ active, setActive }}>{children}</TabsContext.Provider>;
}

function Tab({ value, children }: { value: string; children: React.ReactNode }) {
  const ctx = useContext(TabsContext)!;
  return (
    <button role="tab" aria-selected={ctx.active === value} onClick={() => ctx.setActive(value)}>
      {children}
    </button>
  );
}

// Usage
<Tabs defaultValue="general">
  <TabList>
    <Tab value="general">General</Tab>
    <Tab value="privacy">Privacy</Tab>
  </TabList>
  <TabPanel value="general">General settings...</TabPanel>
  <TabPanel value="privacy">Privacy settings...</TabPanel>
</Tabs>
```

---

## Error Boundaries

```typescript
class ErrorBoundary extends Component<
  { fallback: ReactNode; children: ReactNode },
  { hasError: boolean; error: Error | null }
> {
  state = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error) { return { hasError: true, error }; }

  componentDidCatch(error: Error, info: ErrorInfo) {
    // Report to Sentry or similar
  }

  render() {
    if (this.state.hasError) return this.props.fallback;
    return this.props.children;
  }
}
// Place at route/feature boundaries, NOT around every component
```

---

## Suspense & Lazy Loading

```typescript
const Dashboard = lazy(() => import("./pages/Dashboard"));
const Settings = lazy(() => import("./pages/Settings"));

function App() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/settings" element={<Settings />} />
      </Routes>
    </Suspense>
  );
}
```

---

## useEffect — Do You Actually Need It?

Decision tree:
1. Syncing with external system (WebSocket, DOM API, timer)? → YES, use useEffect
2. Transforming data for render? → NO, do it during render
3. Responding to user event? → NO, use event handler
4. Fetching data? → Use TanStack Query, not raw useEffect
5. Initializing something once? → Consider module-level code

```typescript
// Proper cleanup pattern
useEffect(() => {
  const controller = new AbortController();
  fetch(url, { signal: controller.signal })
    .then(res => res.json())
    .then(setData)
    .catch(err => { if (err.name !== "AbortError") setError(err); });
  return () => controller.abort();
}, [url]);
```

---

## useRef Patterns

```typescript
// DOM ref
const inputRef = useRef<HTMLInputElement>(null);
const focusInput = () => inputRef.current?.focus();

// Mutable value — persists WITHOUT causing re-render
const renderCount = useRef(0);
useEffect(() => { renderCount.current += 1; });

// Previous value
function usePrevious<T>(value: T): T | undefined {
  const ref = useRef<T>();
  useEffect(() => { ref.current = value; });
  return ref.current;
}
```

---

## Virtualization — Lists Over 100 Items

```typescript
import { useVirtualizer } from "@tanstack/react-virtual";

function VirtualList({ items }: { items: Item[] }) {
  const parentRef = useRef<HTMLDivElement>(null);
  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50,
  });

  return (
    <div ref={parentRef} style={{ height: 400, overflow: "auto" }}>
      <div style={{ height: virtualizer.getTotalSize() }}>
        {virtualizer.getVirtualItems().map(vItem => (
          <div key={vItem.key} style={{ transform: `translateY(${vItem.start}px)` }}>
            {items[vItem.index].name}
          </div>
        ))}
      </div>
    </div>
  );
}
```

---

## Performance

```typescript
// React.memo — ONLY when profiler shows expensive re-renders with same props
const ExpensiveChart = memo(function Chart({ data }: { data: Point[] }) { /* */ });

// useMemo — for expensive calculations
const sorted = useMemo(() => items.sort((a, b) => a.score - b.score), [items]);

// useCallback — for stable references passed to memoized children
const handleClick = useCallback((id: string) => { setSelected(id); }, []);
```

**React 19 Compiler** automatically memoizes — manual `memo`, `useMemo`, `useCallback` become less necessary. Profile first, optimize only when needed.

---

## Portals — Escape the DOM Hierarchy

```typescript
function Modal({ isOpen, children }: { isOpen: boolean; children: ReactNode }) {
  if (!isOpen) return null;
  return createPortal(
    <div className="modal-overlay"><div className="modal-content">{children}</div></div>,
    document.getElementById("modal-root")!
  );
}
```

---

## React 19 Features

| Feature | What It Does |
|---------|-------------|
| `use()` hook | Read promises/context in render (replaces some useEffect) |
| `useActionState` | Form submissions with pending state, errors, optimistic updates |
| `useOptimistic` | Optimistic UI updates while async action runs |
| Server Components | Render on server only (no client JS) |
| `ref` as prop | No more `forwardRef` |
| `<form action>` | Progressive enhancement for form submissions |

```typescript
// useOptimistic
function MessageList({ messages }: { messages: Message[] }) {
  const [optimisticMessages, addOptimistic] = useOptimistic(
    messages,
    (state, newMessage: string) => [...state, { id: 'temp', text: newMessage, sending: true }]
  );
  async function sendMessage(formData: FormData) {
    const text = formData.get('text') as string;
    addOptimistic(text);
    await postMessage(text);
  }
  // ...
}
```

---

## List Rendering Keys

```typescript
{items.map(item => <ItemCard key={item.id} item={item} />)}
// NEVER use array index as key if list can reorder/filter/insert
```

---

## Daily Rules

1. Custom hooks for reusable logic — if two components share behavior, extract a hook
2. Compound components for related UI (tabs, accordions, dropdowns)
3. Question every `useEffect` — most aren't needed
4. Virtualize lists over 100 items — `@tanstack/react-virtual`
5. Error boundaries at route boundaries — not around every component
6. Lazy load routes — `React.lazy` + `Suspense`
7. Don't memoize by default — profile first
