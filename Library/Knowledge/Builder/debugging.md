# Debugging & DevTools
**When to use:** Read when investigating bugs, profiling performance, using Chrome DevTools, or debugging React components.

---

## Chrome DevTools — Essential Panels

### Elements Panel
- Inspect and edit DOM in real-time
- Computed styles — see final resolved values after cascade
- Event Listeners tab — see all listeners on an element
- Accessibility tab — ARIA tree, computed role, contrast ratio
- **Tip:** Right-click element → Force State → `:hover`, `:focus`, `:active`

### Console Toolkit
```javascript
console.log("basic");
console.table([{ name: "A", score: 10 }]);    // Table format for arrays/objects
console.group("Auth Flow");                    // Collapsible group
  console.log("Step 1: validate");
console.groupEnd();
console.time("fetch");                         // Timer start
await fetch(url);
console.timeEnd("fetch");                      // → "fetch: 245ms"
console.trace("Where am I called from?");      // Stack trace
console.assert(x > 0, "x should be positive");// Only logs if false
console.count("render");                       // Count how many times called
console.dir(domElement);                       // Object properties view

// Styled output
console.log("%c Important!", "color: red; font-size: 20px; font-weight: bold");
```

### Sources Panel — Breakpoints

| Type | How to Set | Use Case |
|------|-----------|----------|
| Line breakpoint | Click line number | Pause at specific line |
| Conditional breakpoint | Right-click line → "Add conditional" | Pause only when condition is true |
| Logpoint | Right-click line → "Add logpoint" | Log without modifying code |
| DOM breakpoint | Elements panel → right-click → "Break on..." | Pause when DOM changes |
| XHR/Fetch breakpoint | Sources → XHR/Fetch Breakpoints | Pause on network requests |
| Exception breakpoint | Sources → Pause icon | Pause on thrown exceptions |

**Tip:** Use conditional breakpoints and logpoints instead of littering code with `console.log`.

### Network Panel

| Feature | What to Look For |
|---------|-----------------|
| Status codes | Red rows = errors (4xx, 5xx) |
| Timing | TTFB, download time, DNS, SSL handshake |
| Throttling | Simulate slow 3G, offline |
| Filter by type | XHR/Fetch, JS, CSS, Img, Media |
| Copy as cURL | Right-click → Copy → Copy as cURL |
| Block request URL | Right-click → Block (test failure handling) |

### Performance Panel
1. Click Record → interact with app → Stop
2. Key metrics:
   - **FPS** — should stay near 60 (16.6ms per frame)
   - **Long tasks** — red flag bars (tasks > 50ms block main thread)
   - **Flame chart** — wider bars = slower functions

### Memory Panel

| Analysis Type | Use Case |
|--------------|----------|
| Heap snapshot | Compare memory at two points in time |
| Allocation timeline | Track memory allocations over time |
| Allocation sampling | Low-overhead profiling |

---

## React DevTools

### Components Tab
- Inspect component tree, props, state, hooks
- Click to select, then `$r` in console to access the component instance
- Click any value to edit it live

### Profiler Tab
1. Click Record → interact → Stop
2. **Flamegraph** — Gray = didn't render. Colored = rendered.
3. **Ranked** — sorted by render time (longest first)
4. **"Why did this render?"** — Enable in Settings → Profiler → Record why each component rendered
5. **Highlight Updates** — Settings → "Highlight updates when components render"

### Common React Findings

| Problem | DevTools Signal | Fix |
|---------|----------------|-----|
| Unnecessary re-renders | Profiler shows colored on unrelated actions | `React.memo`, split state, move state closer |
| Expensive renders | Component taking >16ms | Memoize calculations, virtualize lists |
| Context cascade | Everything re-renders on context change | Split contexts, use Zustand |
| Missing keys | Warning in console | Add stable unique keys from data |

---

## Debugging Strategies

### 1. Binary Search (Most Underrated Technique)
When something breaks and you don't know where:
1. Comment out half the code
2. Does it still break? Bug is in the remaining half
3. Comment out half of that
4. Repeat until you find the exact line
5. This is O(log n) — much faster than reading every line

### 2. Read the Error Message (Seriously)
```
TypeError: Cannot read properties of undefined (reading 'map')
    at UserList (UserList.tsx:15:23)
```
- **Error type:** TypeError
- **What's undefined:** The thing before `.map`
- **Where:** `UserList.tsx`, line 15, column 23
- **Action:** Check what variable is at line 15, trace where it should be defined

### 3. Rubber Duck Debugging
Explain the problem out loud (or in writing). The act of articulating forces you to examine assumptions.

### 4. Git Bisect — Find Which Commit Broke It
```bash
git bisect start
git bisect bad                    # Current commit is broken
git bisect good abc123            # This older commit was working
# Git checks out middle commit — test it
git bisect good                   # or git bisect bad
# Repeat until git identifies exact breaking commit
git bisect reset                  # Return to original state
```

---

## Common Error Patterns

| Error | Cause | Fix |
|-------|-------|-----|
| `Cannot read properties of undefined` | Accessing property on undefined | Optional chaining `?.`, check data is loaded |
| `Maximum call stack exceeded` | Infinite recursion or re-render | Check useEffect deps, check recursive calls |
| `Objects are not valid as React child` | Rendering `{...}` object directly | Stringify or extract the field to display |
| `CORS error` | Backend missing CORS headers | Add CORS headers on server, or use Vite proxy |
| `Module not found` | Import path wrong | Check casing, extension, path aliases |
| `key` warning | Missing/non-unique key on list items | Use unique ID from data, never array index if list changes |
| `Hydration mismatch` | SSR HTML differs from client render | Ensure server/client render same initial state |

---

## Performance Debugging

### Web Vitals Targets

| Metric | Target | What It Measures |
|--------|--------|-----------------|
| **LCP** (Largest Contentful Paint) | < 2.5s | When main content is visible |
| **INP** (Interaction to Next Paint) | < 200ms | Responsiveness to user input |
| **CLS** (Cumulative Layout Shift) | < 0.1 | Visual stability (elements jumping) |
| **FCP** (First Contentful Paint) | < 1.8s | When first content appears |
| **TTFB** (Time to First Byte) | < 800ms | Server response time |

### Memory Leak Patterns

| Leak Source | How to Detect | Fix |
|-------------|--------------|-----|
| Event listeners not removed | Memory grows on navigate | Return cleanup from useEffect |
| Timers not cleared | Memory grows over time | `clearInterval`/`clearTimeout` in cleanup |
| Closures holding references | Heap snapshot shows detached DOM | Break reference in cleanup |
| Stale subscriptions | WebSocket handlers accumulate | Unsubscribe in cleanup |
| Unmounted state updates | "Can't perform state update on unmounted" | AbortController or cleanup flag |

```typescript
// Proper cleanup pattern
useEffect(() => {
  const controller = new AbortController();
  const timer = setInterval(() => { /* ... */ }, 1000);
  const handler = (e: Event) => { /* ... */ };

  window.addEventListener("resize", handler);

  return () => {
    controller.abort();
    clearInterval(timer);
    window.removeEventListener("resize", handler);
  };
}, []);
```

---

## Source Maps

- Vite generates source maps automatically in dev
- Production: enable with `build: { sourcemap: true }` in vite.config
- Upload to Sentry for production debugging
- **Never serve source maps publicly** — use `sourcemap: "hidden"` and Sentry's artifact upload

---

## VS Code Debugging

```jsonc
// .vscode/launch.json
{
  "configurations": [
    {
      "name": "Chrome Debug",
      "type": "chrome",
      "request": "launch",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}/src",
      "sourceMaps": true
    }
  ]
}
```

Set breakpoints directly in VS Code — stepping through code, watching variables, and inspecting the call stack all work in the editor.

---

## Bundle Analysis

```bash
npm install -D rollup-plugin-visualizer
```

```typescript
import { visualizer } from "rollup-plugin-visualizer";
plugins: [react(), visualizer({ open: true, gzipSize: true })]
```

Run `npm run build` — opens interactive treemap showing exact size of every module. Largest modules = biggest optimization opportunities.

---

## Daily Rules

1. Read the error message first — file, line, column, stack trace
2. Conditional breakpoints > `console.log` — don't litter code with logs
3. React Profiler to find render bottlenecks — enable "Why did this render?"
4. Binary search when bug is hard to locate — O(log n) beats reading every line
5. `console.table` for arrays/objects, `console.time` for performance
6. Network panel to debug API issues — check request/response headers
7. Clean up effects — every addEventListener, setInterval, subscription needs cleanup
