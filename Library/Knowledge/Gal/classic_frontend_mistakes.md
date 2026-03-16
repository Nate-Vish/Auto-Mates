---
title: "Classic Frontend Mistakes Every Developer Makes"
category: "Frontend Engineering"
tags: [performance, accessibility, state-management, css, browser-compat, forms, routing, assets, anti-patterns]
author: "Gal — Skeptical Senior Developer"
version: 1.0
last_updated: "2026-03-03"
purpose: "Universal reference for catching and preventing the frontend mistakes that have burned teams since the dawn of the browser."
---

# Classic Frontend Mistakes Every Developer Makes

> "The frontend is where optimism meets the browser engine — and the browser engine always wins."

---

## 1. Performance Pitfalls

### 1.1 Unnecessary Re-renders

| Anti-Pattern | Why It Hurts | Fix |
|---|---|---|
| Creating new objects/arrays in render | Every render produces a new reference, triggering child re-renders | Memoize with `useMemo`, define constants outside render |
| Inline function props | New function reference each render | `useCallback` or extract to a stable reference |
| Updating parent state from child on every keystroke | Entire subtree re-renders per character | Debounce or localize state to the input component |
| Not splitting large context providers | One value change re-renders every consumer | Split contexts by update frequency |

```jsx
// BAD: new object every render
function Dashboard() {
  return <Chart options={{ animate: true, color: "blue" }} />;
}

// GOOD: stable reference
const CHART_OPTIONS = { animate: true, color: "blue" };
function Dashboard() {
  return <Chart options={CHART_OPTIONS} />;
}
```

```jsx
// BAD: inline handler causes child re-render
function List({ items }) {
  return items.map(item => (
    <Row key={item.id} onClick={() => selectItem(item.id)} />
  ));
}

// GOOD: stable callback
function List({ items }) {
  const handleClick = useCallback((id) => selectItem(id), []);
  return items.map(item => (
    <Row key={item.id} id={item.id} onClick={handleClick} />
  ));
}
```

### 1.2 Bundle Bloat

| Anti-Pattern | Fix |
|---|---|
| Importing entire utility library (`import _ from 'lodash'`) | Tree-shakeable import (`import debounce from 'lodash/debounce'`) |
| No code splitting | Route-based lazy loading (`React.lazy`, dynamic `import()`) |
| Shipping dev dependencies to production | Audit with `bundleanalyzer`; check `devDependencies` vs `dependencies` |
| Multiple copies of the same library (e.g., two versions of `moment`) | `npm ls <package>`, deduplicate, or alias |
| Including polyfills everyone already has | Use `browserslist` and `useBuiltIns: 'usage'` |

**Rule of thumb:** If your JavaScript bundle exceeds 200KB gzipped for an initial page load, something is wrong. Audit before you optimize.

### 1.3 Unoptimized Images

| Mistake | Impact | Fix |
|---|---|---|
| Serving 4000px originals for 400px thumbnails | Massive bandwidth waste, slow LCP | Serve responsive sizes via `srcset` and `sizes` |
| Using PNG for photographs | 5-10x larger than JPEG/WebP | Use WebP with JPEG fallback |
| No lazy loading for below-fold images | Blocks initial paint with unnecessary downloads | `loading="lazy"` on `<img>`, or Intersection Observer |
| Missing `width` and `height` attributes | Causes layout shift (CLS) | Always set explicit dimensions or aspect-ratio |
| No CDN for static assets | Slow TTFB from origin server | Serve images from CDN with proper cache headers |

### 1.4 Layout Thrashing

```javascript
// BAD: read-write interleave forces reflow per iteration
elements.forEach(el => {
  const h = el.offsetHeight;         // READ  (forces layout)
  el.style.height = (h * 2) + 'px'; // WRITE (invalidates layout)
});

// GOOD: batch all reads, then all writes
const heights = elements.map(el => el.offsetHeight);
elements.forEach((el, i) => { el.style.height = (heights[i] * 2) + 'px'; });
```

**Layout triggers:** `offsetHeight`, `offsetWidth`, `scrollTop`, `getBoundingClientRect()`, `getComputedStyle()`. Never interleave reads and writes in a loop.

### 1.5 Memory Leaks

| Leak Source | Symptom | Fix |
|---|---|---|
| Event listeners not removed on unmount | Growing memory over time, duplicate handlers | Remove in cleanup (`removeEventListener`, `return () => {}` in `useEffect`) |
| Timers (`setInterval`) not cleared | Callbacks fire after component gone | `clearInterval` in cleanup |
| Closures holding stale DOM references | Detached DOM nodes stay in memory | Nullify references; use WeakRef where appropriate |
| WebSocket connections not closed | Connections pile up on navigation | Close in cleanup; reconnect only when mounted |
| Growing arrays stored in module scope | Unbounded growth over session lifetime | Bound the size; use LRU or ring buffer |

```javascript
// BAD: leak on unmount
useEffect(() => {
  const id = setInterval(fetchData, 5000);
  // no cleanup!
}, []);

// GOOD: clean up
useEffect(() => {
  const id = setInterval(fetchData, 5000);
  return () => clearInterval(id);
}, []);
```

### 1.6 Blocking the Main Thread

| Anti-Pattern | Fix |
|---|---|
| Parsing large JSON synchronously | Use streaming JSON parser or Web Worker |
| Complex sorting/filtering of 10,000+ items on render | Move to Web Worker; virtualize the list |
| Synchronous `localStorage` reads on every render | Read once on mount, cache in state |
| Heavy computation in event handlers without yielding | Use `requestIdleCallback` or `scheduler.postTask` |

**Benchmark:** If any single task takes >50ms, the user perceives jank. Profile with DevTools Performance tab. Break long tasks with `yield` patterns or Web Workers.

---

## 2. Accessibility Failures

### 2.1 Missing Alt Text

```html
<!-- BAD -->  <img src="chart.png" />
<!-- BAD -->  <img src="logo.png" alt="Company logo image photo" />
<!-- GOOD --> <img src="chart.png" alt="Monthly revenue showing 15% growth in Q3" />
<!-- GOOD --> <img src="border.png" alt="" role="presentation" />  <!-- decorative -->
```

**Rule:** Every `<img>` gets `alt`. Decorative images get `alt=""`. Never prefix with "image of".

### 2.2 No Keyboard Navigation

| Element | Keyboard Expectation | Common Failure |
|---|---|---|
| Custom dropdown | Arrow keys navigate, Enter selects, Escape closes | Only works with mouse click |
| Modal dialog | Tab trapped inside, Escape closes, focus returns on close | Tab escapes behind the modal |
| Tab component | Arrow keys switch tabs, Tab moves to panel | No arrow key support |
| Carousel | Arrow keys navigate slides | Only swipe/click works |
| Custom checkbox/toggle | Space toggles | Only click handler, no `role`, no `tabindex` |

```html
<!-- BAD: div pretending to be a button -->
<div class="btn" onclick="submit()">Submit</div>

<!-- GOOD: use a real button -->
<button type="submit">Submit</button>

<!-- ACCEPTABLE: when you must use a div, add full semantics -->
<div role="button" tabindex="0"
     onclick="submit()"
     onkeydown="if(event.key==='Enter'||event.key===' ')submit()">
  Submit
</div>
```

### 2.3 Poor Color Contrast

| WCAG Level | Minimum Contrast Ratio (normal text) | Minimum (large text) |
|---|---|---|
| AA | 4.5:1 | 3:1 |
| AAA | 7:1 | 4.5:1 |

**Common failures:** Light gray on white (~2:1 ratio), placeholder text too faint, error states using only red (color-blind users miss it), links differing only by color (add underline).

**Fix:** Test with a contrast checker. Never rely on color alone — add icons, patterns, or text labels.

### 2.4 ARIA Misuse

| Mistake | Fix |
|---|---|
| `role="button"` on an `<a>` tag that navigates | Use `<a>` for navigation, `<button>` for actions |
| `aria-label` that duplicates visible text | Remove it; screen readers already read visible text |
| `aria-hidden="true"` on focusable elements | Hidden elements must not be focusable |
| Using `aria-live="assertive"` for routine updates | Use `"polite"` unless it is truly urgent |
| Inventing roles like `role="card"` | Only use WAI-ARIA defined roles |

**First rule of ARIA:** Don't use ARIA if a native HTML element does the job. `<button>` beats `<div role="button">` every time.

### 2.5 Focus Management

**Checklist:**
- [ ] On open: focus moves into modal (`modalEl.querySelector('[autofocus], button').focus()`)
- [ ] While open: focus is trapped inside modal (Tab cycles within)
- [ ] On close: focus returns to the trigger element
- [ ] Skip-to-content link exists for keyboard users
- [ ] Focus order follows visual order (no `tabindex` > 0)

### 2.6 Screen Reader Testing

**Minimum testing matrix:**

| Platform | Screen Reader | Browser |
|---|---|---|
| Windows | NVDA | Firefox |
| Windows | JAWS | Chrome |
| macOS | VoiceOver | Safari |
| iOS | VoiceOver | Safari |
| Android | TalkBack | Chrome |

**What to test:** Page landmarks, heading hierarchy, form labels, dynamic content updates, error announcements, table reading order.

---

## 3. State Management Anti-Patterns

### 3.1 Prop Drilling Hell

```jsx
// BAD: user passed through 5 levels (App > Layout > Sidebar > UserMenu > Avatar)

// GOOD: context for cross-cutting data
const UserContext = createContext(null);
function App() {
  return (
    <UserContext.Provider value={user}>
      <Layout><Sidebar><UserMenu><Avatar /></UserMenu></Sidebar></Layout>
    </UserContext.Provider>
  );
}
function Avatar() {
  const user = useContext(UserContext);
  return <img src={user.avatar} alt={user.name} />;
}
```

**When prop drilling is fine:** 1-2 levels, or the intermediate components genuinely use the prop. Don't reach for context just to skip one level.

### 3.2 Global State for Local Data

| Belongs in Global State | Belongs in Local State |
|---|---|
| Authenticated user, permissions | Form input values |
| Theme / locale | Dropdown open/closed |
| Feature flags | Hover state |
| Shopping cart | Scroll position |
| WebSocket connection status | Animation state |

**Rule:** If only one component (or its close children) care about the data, keep it local. Global state is for data multiple unrelated components need.

### 3.3 Stale Closures

```javascript
// BAD: count captured at 0, stays 0 forever (empty deps = stale closure)
useEffect(() => {
  const id = setInterval(() => console.log(count), 1000); // always 0
  return () => clearInterval(id);
}, []);

// FIX 1: ref to always read current value
const countRef = useRef(count);
countRef.current = count;
useEffect(() => {
  const id = setInterval(() => console.log(countRef.current), 1000);
  return () => clearInterval(id);
}, []);

// FIX 2: functional updater (avoids reading stale state)
useEffect(() => {
  const id = setInterval(() => setCount(prev => prev + 1), 1000);
  return () => clearInterval(id);
}, []);
```

### 3.4 Derived State Stored Separately

```javascript
// BAD: storing derived state and trying to keep it in sync
const [items, setItems] = useState([]);
const [filteredItems, setFilteredItems] = useState([]);
const [itemCount, setItemCount] = useState(0);

// Every time items changes, you must remember to update the others
// This WILL go out of sync.

// GOOD: compute derived values inline or with memoization
const [items, setItems] = useState([]);
const [filter, setFilter] = useState('');

const filteredItems = useMemo(
  () => items.filter(i => i.name.includes(filter)),
  [items, filter]
);
const itemCount = filteredItems.length; // just compute it
```

**Gal's law:** If value B can be computed from value A, do NOT store B in state. Compute it.

### 3.5 State Sync Nightmares

| Anti-Pattern | What Happens | Fix |
|---|---|---|
| Duplicating server state in client state manually | Stale data, loading state bugs, refetch forgotten | Use a server-state library (React Query, SWR, Apollo) |
| Syncing state between sibling components via parent | Parent becomes a bloated state dump | Lift state only as high as needed, or use context |
| Two-way binding between URL params and state | URL and state drift apart | Treat URL as the source of truth, derive state from it |
| Copying props into state | State diverges when props update | Use props directly; use state only if you need local mutations |

---

## 4. CSS Traps

### 4.1 Specificity Wars

```css
/* BAD: escalating specificity battle */
.sidebar .nav .item { color: blue; }
.sidebar .nav .item.active { color: red; }
#sidebar .nav .item.active { color: green; }      /* desperation */
#sidebar .nav .item.active.highlight { color: orange !important; } /* defeat */

/* GOOD: flat, low-specificity selectors */
.nav-item { color: blue; }
.nav-item--active { color: red; }
```

**Specificity ranking:** `!important` > inline styles > `#id` > `.class` / `[attr]` / `:pseudo-class` > `element` > `*`. Stay in the `.class` lane. Never use `!important` in application code.

### 4.2 Z-Index Chaos

```css
/* BAD: z-index arms race */
.dropdown { z-index: 100; }
.modal { z-index: 9999; }
.tooltip { z-index: 99999; }
.toast { z-index: 999999; }  /* where does it end? */

/* GOOD: define a scale and document it */
:root {
  --z-dropdown: 100;
  --z-sticky: 200;
  --z-overlay: 300;
  --z-modal: 400;
  --z-toast: 500;
  --z-tooltip: 600;
}
.modal { z-index: var(--z-modal); }
```

**Key insight:** `z-index` only works within the same stacking context. A `z-index: 999999` inside a stacking context with `z-index: 1` will still appear behind a sibling with `z-index: 2`. Understand stacking contexts before adding z-index.

### 4.3 Magic Numbers

```css
/* BAD: what does 37px mean? */
.header { height: 37px; }
.content { margin-top: 37px; }
.sidebar { width: 247px; }

/* GOOD: use variables and explain */
:root {
  --header-height: 3rem;
  --sidebar-width: 16rem;
}
.header { height: var(--header-height); }
.content { margin-top: var(--header-height); }
```

### 4.4 Layout Shifts (CLS)

| Cause | Fix |
|---|---|
| Images without dimensions | Set `width` and `height` or `aspect-ratio` |
| Dynamically injected content above the fold | Reserve space with min-height or skeleton |
| Web fonts causing FOUT | `font-display: swap` + `size-adjust` or preload |
| Ads/embeds with unknown size | Contain in a fixed-size wrapper |
| Late-loading CSS changing layout | Inline critical CSS, defer non-critical |

**Target:** CLS score < 0.1 (Core Web Vitals "good" threshold).

### 4.5 Responsive Breakpoint Failures

```css
/* BAD: targeting specific devices */
@media (width: 768px) { } /* exactly 768px only */
@media (max-width: 1024px) and (min-width: 768px) { } /* iPad-only thinking */

/* GOOD: content-driven breakpoints */
/* Set breakpoints where YOUR layout breaks, not where devices happen to be */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  /* No breakpoints needed — the layout adapts to content */
}
```

**Rule:** Design for content, not for devices. Use `min-width` (mobile-first) over `max-width`. Test by resizing the browser, not by checking three device sizes.

### 4.6 CSS-in-JS Performance

| Risk | Mitigation |
|---|---|
| Runtime style generation on every render | Use zero-runtime solutions (CSS Modules, vanilla-extract, Tailwind) |
| Large style objects re-created each render | Extract to constants outside component |
| SSR mismatch causing hydration flicker | Ensure style extraction during SSR |
| Bundle includes CSS generation runtime (~12-15KB) | Evaluate if the tradeoff is worth it for your project |

---

## 5. Browser Compatibility

### 5.1 Feature Detection vs User Agent Sniffing

```javascript
// BAD: user agent sniffing (breaks constantly)
if (navigator.userAgent.includes('Safari')) {
  // This also matches Chrome, Edge, and anything WebKit-based
}

// GOOD: feature detection
if ('IntersectionObserver' in window) {
  // Use IntersectionObserver
} else {
  // Fallback: scroll event listener with throttle
}

// GOOD: CSS feature detection
@supports (display: grid) {
  .layout { display: grid; }
}
@supports not (display: grid) {
  .layout { display: flex; flex-wrap: wrap; }
}
```

### 5.2 Polyfill Bloat

| Mistake | Fix |
|---|---|
| Loading all polyfills for all browsers | Use `useBuiltIns: 'usage'` to only include what's needed |
| Shipping polyfills to modern browsers | Differential serving: `<script type="module">` vs `<script nomodule>` |
| Manually maintaining a polyfill list | Let your build tool and `browserslist` handle it |
| Polyfilling features you don't actually use | Audit and remove |

### 5.3 Safari Quirks (A Non-Exhaustive Hall of Shame)

| Quirk | Workaround |
|---|---|
| 100vh includes the URL bar on mobile Safari | Use `100dvh` (dynamic viewport height) or JS fallback |
| Date constructor rejects `YYYY-MM-DD` (hyphens) | Use `YYYY/MM/DD` or explicitly parse |
| `position: sticky` fails in `overflow: auto` containers | Restructure DOM so sticky element is not inside overflow container |
| `gap` on flexbox not supported in older Safari | Use margins as fallback; check `@supports` |
| Service Worker scope issues | Ensure service worker is served from the correct path |

### 5.4 Mobile Viewport Issues

```html
<!-- REQUIRED: without this, mobile browsers zoom out and render desktop width -->
<meta name="viewport" content="width=device-width, initial-scale=1" />

<!-- BAD: disabling zoom (accessibility violation) -->
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
```

| Issue | Fix |
|---|---|
| Touch targets too small | Minimum 44x44px (WCAG), ideally 48x48px |
| Hover-only interactions | Provide tap alternatives; use `@media (hover: hover)` |
| Virtual keyboard obscuring inputs | Use `visualViewport` API or `scrollIntoView` |
| Horizontal scroll on mobile | Set `overflow-x: hidden` on body; audit for elements wider than viewport |

---

## 6. Form Mistakes

### 6.1 No Validation Feedback

```html
<!-- BAD: browser default validation (inconsistent, ugly, not screen-reader friendly) -->
<input type="email" required />

<!-- GOOD: custom validation with accessible error messages -->
<label for="email">Email</label>
<input type="email" id="email" aria-describedby="email-error" aria-invalid="true" />
<span id="email-error" role="alert">Please enter a valid email address.</span>
```

| Validation Mistake | Fix |
|---|---|
| Only server-side validation | Add client-side for UX, keep server-side for security |
| Only client-side validation | ALWAYS validate on server; client-side can be bypassed |
| Validating on every keystroke | Validate on blur for most fields, on submit for the form |
| Clearing the entire form on one error | Preserve all input; highlight only the error field |
| Error messages like "Invalid input" | Say what's wrong and how to fix it: "Password must be at least 8 characters" |

### 6.2 Submit on Enter Broken

```html
<!-- BAD: form with no submit button (Enter does nothing) -->
<form>
  <input type="text" />
  <div onclick="handleSubmit()">Submit</div>
</form>

<!-- GOOD: real submit button (Enter works automatically) -->
<form onsubmit="handleSubmit(event)">
  <input type="text" />
  <button type="submit">Submit</button>
</form>
```

### 6.3 Accessibility of Error Messages

**Checklist:**
- [ ] Error messages are programmatically associated with inputs (`aria-describedby`)
- [ ] Error messages are announced to screen readers (`role="alert"` or `aria-live="polite"`)
- [ ] Errors are not conveyed by color alone (add icon or text prefix)
- [ ] Focus moves to the first error field on form submission failure
- [ ] Error messages are adjacent to their input, not in a banner at the top only

### 6.4 Autofill Conflicts

| Issue | Fix |
|---|---|
| Custom-styled inputs break browser autofill (yellow background) | Style `input:-webkit-autofill` pseudo-element |
| Autofill puts data in wrong fields | Use proper `autocomplete` attributes (`autocomplete="email"`, `autocomplete="new-password"`) |
| Dynamic forms confuse autofill | Ensure consistent `name` and `id` attributes |
| Disabling autofill (`autocomplete="off"`) | Don't. Browsers ignore it anyway, and it hurts UX |

---

## 7. Client-Side Routing Pitfalls

### 7.1 Scroll Position Loss

```javascript
// BAD: navigating to a new page lands in the middle (previous scroll position)

// GOOD: scroll to top on route change
useEffect(() => {
  window.scrollTo(0, 0);
}, [pathname]);

// BETTER: restore position on back navigation, scroll to top on forward
// Use the browser's built-in scroll restoration:
if ('scrollRestoration' in history) {
  history.scrollRestoration = 'manual'; // take control
}
```

### 7.2 Back Button Breaks

| Anti-Pattern | Fix |
|---|---|
| Using `window.location.replace()` for all navigation | Use `pushState` so back button works |
| Multi-step wizard with no history entries | Push a history entry for each step |
| Modal/filter changes not reflected in URL | Add state to URL params so back button closes modal |
| Confirmation dialogs that don't prevent back | Use `beforeunload` event for unsaved changes |

### 7.3 Deep Link Failures

| Failure | Fix |
|---|---|
| App state only accessible through navigation flow | Every meaningful view must have a URL |
| Dynamic content that 404s on direct load | Server must serve `index.html` for all SPA routes (catch-all) |
| Authentication redirecting away from deep link | After login, redirect back to the original URL |
| Shared link loses query parameters | Persist filters/state in URL search params |

### 7.4 SEO for SPAs

| Problem | Fix |
|---|---|
| Search engines see blank page | Server-side rendering (SSR) or pre-rendering |
| Missing meta tags for social sharing | Dynamic `<head>` management per route |
| No semantic HTML structure | Use proper heading hierarchy, `<main>`, `<nav>`, `<article>` |
| Client-rendered content not indexed | Ensure critical content is in initial HTML payload |

---

## 8. Asset Loading Mistakes

### 8.1 Render-Blocking Scripts

```html
<!-- BAD: blocks HTML parsing until script downloads and executes -->
<head>
  <script src="analytics.js"></script>
  <script src="app.js"></script>
</head>

<!-- GOOD: defer non-critical scripts -->
<head>
  <script src="app.js" defer></script>
</head>
<body>
  <!-- content renders immediately -->
  <script src="analytics.js" async></script>
</body>
```

| Attribute | Behavior |
|---|---|
| (none) | Blocks parsing. Downloads and executes immediately. |
| `async` | Downloads in parallel. Executes as soon as ready (order not guaranteed). |
| `defer` | Downloads in parallel. Executes after HTML parsing, in order. |

**Rule:** Use `defer` for app scripts. Use `async` for independent scripts (analytics, ads). Never put blocking scripts in `<head>` unless absolutely required.

### 8.2 Flash of Unstyled Content (FOUC)

| Cause | Fix |
|---|---|
| CSS loaded with JavaScript | Inline critical CSS in `<head>`, load rest asynchronously |
| CSS-in-JS hydration mismatch | Extract critical CSS during SSR |
| `@import` in CSS files (serial loading) | Use `<link>` tags in HTML (parallel loading) |
| Dark mode flicker on load | Inline a script in `<head>` that reads preference and sets class before paint |

### 8.3 Lazy Loading Done Wrong

```html
<!-- BAD: lazy loading the hero image (delays LCP) -->
<img src="hero.jpg" loading="lazy" alt="Hero" />

<!-- GOOD: eagerly load above-fold content -->
<img src="hero.jpg" loading="eager" alt="Hero" fetchpriority="high" />

<!-- GOOD: lazy load below-fold content -->
<img src="footer-promo.jpg" loading="lazy" alt="Promotional offer" />
```

| Mistake | Fix |
|---|---|
| Lazy loading above-fold images | Only lazy load below-the-fold content |
| No placeholder during lazy load | Use blurred placeholder, solid color, or skeleton |
| Lazy loading small critical icons | Inline small SVGs or preload them |
| Setting `loading="lazy"` on everything | Be intentional: eager for critical, lazy for deferred |

### 8.4 Font Loading Flash (FOIT / FOUT)

```css
/* Option 1: swap — show fallback text immediately, swap when font loads (FOUT) */
@font-face {
  font-family: 'CustomFont';
  src: url('custom.woff2') format('woff2');
  font-display: swap;
}

/* Option 2: optional — use font if cached, skip if not (no flash at all) */
@font-face {
  font-family: 'CustomFont';
  src: url('custom.woff2') format('woff2');
  font-display: optional;
}
```

```html
<!-- Preload critical fonts to reduce swap delay -->
<link rel="preload" href="custom.woff2" as="font" type="font/woff2" crossorigin />
```

| Strategy | Best For |
|---|---|
| `font-display: swap` | Body text (readability first) |
| `font-display: optional` | Headings, decorative text (visual stability first) |
| Preloading | Any critical font used above the fold |
| `size-adjust` + `ascent-override` | Minimizing layout shift between fallback and custom font |

**Rule:** Limit custom fonts to 2-3 families maximum. Each weight/style is a separate file. Subset to only the characters you need.

---

## Gal's Application: 10 Daily Rules for Frontend Development

These are the rules Gal checks every single day. No exceptions.

1. **Profile before you optimize.** Open DevTools Performance tab. Measure. Then fix. Guessing at performance problems is a waste of everyone's time.

2. **Tab through every page.** If you cannot complete every user flow using only a keyboard, the feature is not done. Period.

3. **Check your bundle size on every PR.** Add a CI check that fails if the bundle grows beyond a threshold. Once bloat gets in, it never comes out voluntarily.

4. **Never store what you can compute.** If one piece of state can be derived from another, derive it. Duplicate state is a synchronization bug waiting to happen.

5. **Test on a real slow device.** Your M-series laptop lies to you. Throttle CPU 4x in DevTools, or use a real budget Android phone. What feels instant to you feels broken to them.

6. **Set explicit dimensions on every media element.** Images, videos, iframes, ads. If it does not have width and height (or aspect-ratio), it will cause layout shift.

7. **Run an accessibility audit weekly.** Automated tools catch about 30% of issues. Manual testing with a screen reader and keyboard catches the rest. Do both.

8. **Treat the URL as a source of truth.** Every meaningful view should be bookmarkable and shareable. If state is not in the URL, back button and deep links are broken.

9. **Keep specificity flat.** One class per selector. No IDs in CSS. No `!important` in application code. If you are fighting specificity, your architecture is wrong.

10. **Load critical resources first, everything else later.** Inline critical CSS. Defer scripts. Lazy load below-fold images. Preload fonts. Every millisecond of render-blocking resource costs you users.
