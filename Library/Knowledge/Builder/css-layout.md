# CSS Layout & Styling
**When to use:** Read when implementing CSS layouts, animations, responsive design, or design systems.

---

## Flexbox — One-Dimensional Layout

| Property | Values | Default | Applies To |
|----------|--------|---------|-----------|
| `display` | `flex`, `inline-flex` | — | Container |
| `flex-direction` | `row`, `column`, `row-reverse`, `column-reverse` | `row` | Container |
| `justify-content` | `flex-start`, `center`, `flex-end`, `space-between`, `space-around`, `space-evenly` | `flex-start` | Container (main axis) |
| `align-items` | `flex-start`, `center`, `flex-end`, `stretch`, `baseline` | `stretch` | Container (cross axis) |
| `gap` | `<length>` | `0` | Container |
| `flex-wrap` | `nowrap`, `wrap` | `nowrap` | Container |
| `flex` | `<grow> <shrink> <basis>` | `0 1 auto` | Item |

### Common Flexbox Patterns
```css
.center  { display: flex; justify-content: center; align-items: center; }
.navbar  { display: flex; justify-content: space-between; align-items: center; gap: 1rem; }
.push-right { display: flex; gap: 1rem; }
.push-right .last { margin-inline-start: auto; }  /* push to end */
.columns > * { flex: 1; }                          /* equal-width columns */
.wrap > * { flex: 1 1 300px; }                     /* wrap with minimum width */
```

---

## CSS Grid — Two-Dimensional Layout

```css
.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); /* responsive, no media queries */
  gap: 1rem;
}

/* Named areas — visual layout */
.layout {
  display: grid;
  grid-template-areas:
    "header  header  header"
    "sidebar content content"
    "footer  footer  footer";
  grid-template-columns: 250px 1fr 1fr;
}
.header  { grid-area: header; }
.sidebar { grid-area: sidebar; }

/* auto-fit vs auto-fill */
/* auto-fit: stretches items to fill space (use for most cases) */
/* auto-fill: creates empty columns if space available */
```

### Subgrid
```css
.parent { display: grid; grid-template-columns: repeat(3, 1fr); }
.child  { display: grid; grid-template-columns: subgrid; grid-column: span 3; }
```

---

## Responsive Without Media Queries

```css
font-size: clamp(1rem, 2.5vw, 2rem);     /* fluid typography */
padding: clamp(1rem, 5vw, 3rem);
width: min(90%, 1200px);                  /* max-width alternative */
padding: max(1rem, 3vw);                  /* at least 1rem */
```

---

## Container Queries

```css
.card-container { container-type: inline-size; container-name: card; }

@container card (min-width: 400px) {
  .card { flex-direction: row; }
}
```
Use container queries for component-level responsiveness. Use media queries for page-level layout.

---

## Animation Rules

**Only animate `transform` and `opacity`** — they run on the GPU compositor. Animating `width`, `height`, `top`, `margin`, `padding` triggers layout recalculation (expensive).

```css
/* Transitions — for state changes */
.button {
  transition: transform 150ms ease-out, opacity 150ms ease-out;
}
.button:hover { transform: translateY(-2px); }

/* Keyframes */
@keyframes fadeSlideIn {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* ALWAYS respect reduced motion */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}

/* Scroll-snap for carousels */
.carousel {
  scroll-snap-type: x mandatory;
  overflow-x: auto;
  display: flex;
  gap: 1rem;
}
.carousel > * { scroll-snap-align: start; flex: 0 0 80%; }
```

---

## Modern Selectors

```css
/* :has() — parent selector */
.card:has(img) { padding-top: 0; }
.form:has(:invalid) .submit { opacity: 0.5; }

/* :is() — matches any, takes HIGHEST specificity */
:is(h1, h2, h3) { line-height: 1.2; }

/* :where() — ZERO specificity (easy to override) */
:where(.defaults) p { margin-bottom: 1rem; }

/* :not() */
.list > :not(:last-child) { margin-bottom: 0.5rem; }
```

---

## Custom Properties (CSS Variables)

```css
:root {
  --color-primary: oklch(65% 0.25 265);  /* oklch = perceptually uniform */
  --space-md: 1rem;
  --font-sans: system-ui, -apple-system, sans-serif;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-surface: oklch(15% 0.02 265);
    --color-text: oklch(90% 0.01 265);
  }
}

/* Color functions */
background: color-mix(in oklch, var(--color-primary), white 20%);
--hover: oklch(from var(--color-primary) calc(l - 0.1) c h);
```

---

## CSS Nesting (Native)

```css
.card {
  padding: 1rem;
  & h2 { font-size: 1.25rem; }
  &:hover { box-shadow: 0 4px 12px oklch(0% 0 0 / 0.1); }
  @media (width >= 768px) { padding: 2rem; }
}
```

---

## @layer — Specificity Management

```css
@layer reset, base, components, utilities;

@layer reset { *, *::before, *::after { box-sizing: border-box; margin: 0; } }
@layer utilities { .sr-only { position: absolute; clip: rect(0,0,0,0); } }
/* Utilities layer has highest priority because declared last */
```

---

## Logical Properties (RTL Support)

```css
/* Physical (old) → Logical (modern, supports RTL) */
margin-left    → margin-inline-start
margin-right   → margin-inline-end
margin-top     → margin-block-start
margin-bottom  → margin-block-end
padding-left   → padding-inline-start
width          → inline-size
height         → block-size
text-align: left → text-align: start
```

---

## CSS Approach Comparison

| Approach | Pros | Cons | Use When |
|----------|------|------|----------|
| **CSS Modules** | Zero runtime, scoped, standard CSS | Separate files | Component libraries, performance-critical |
| **Tailwind** | Fast prototyping, consistent design system | Verbose HTML | Rapid development, utility-first teams |
| **CSS-in-JS** | Dynamic styles, TypeScript | Runtime cost, SSR complexity | Styles depend heavily on JS state |

---

## Daily Rules

1. Start with Flexbox, reach for Grid when you need 2D control
2. `auto-fit` + `minmax()` for responsive grids without media queries
3. Only animate `transform` and `opacity`
4. Custom properties for theming — define tokens at `:root`
5. Container queries for components, media queries for page layout
6. Respect `prefers-reduced-motion` and `prefers-color-scheme`
7. Logical properties over physical — future-proof for RTL support
