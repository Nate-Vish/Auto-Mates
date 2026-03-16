# HTML Semantics & Accessibility
**When to use:** Read when building UI components, forms, or any user-facing HTML — accessibility is non-negotiable.

---

## Semantic Elements

| Element | Purpose | NOT For |
|---------|---------|---------|
| `<header>` | Introductory content, nav, logo | Every `<div>` at the top |
| `<nav>` | Major navigation blocks | Every list of links |
| `<main>` | Primary content (one per page) | Wrappers |
| `<section>` | Thematic grouping WITH a heading | Generic container (use `<div>`) |
| `<article>` | Self-contained, independently distributable | Any block of content |
| `<aside>` | Tangentially related content | Sidebars that ARE the main content |
| `<footer>` | Footer for nearest sectioning ancestor | Only page footer |
| `<dialog>` | Modal/non-modal dialogs | Custom modal `<div>` |
| `<details>` / `<summary>` | Disclosure widget (accordion) | — |
| `<figure>` / `<figcaption>` | Self-contained content with caption | Every image |
| `<time>` | Machine-readable date/time | — |

> **Rule:** If there's a semantic element for it, use it. Use `<div>` only when there isn't.

---

## ARIA — Use It Correctly

### The First Rule of ARIA
Don't use ARIA if native HTML can do the job. ARIA is a repair tool.

```html
<!-- BAD -->
<div role="button" tabindex="0" aria-label="Submit">Submit</div>

<!-- GOOD -->
<button type="submit">Submit</button>
```

### When You DO Need ARIA

| Pattern | ARIA | Example |
|---------|------|---------|
| Custom widget with no HTML equivalent | `role`, states, properties | Tab panels, tree views, comboboxes |
| Dynamic content updates | `aria-live` | Toast notifications, chat messages |
| Relationships not in DOM | `aria-describedby`, `aria-labelledby` | Error messages linked to inputs |
| Current page/step indicator | `aria-current` | Navigation, stepper, breadcrumbs |
| Loading states | `aria-busy` | Content being fetched |
| Expanded/collapsed | `aria-expanded` | Accordions, dropdowns, menus |
| Hidden from assistive tech | `aria-hidden="true"` | Decorative icons |

### Common ARIA Patterns
```html
<!-- Live region — announces dynamic updates -->
<div aria-live="polite" aria-atomic="true">3 items in cart</div>

<!-- Error message linked to input -->
<label for="email">Email</label>
<input id="email" type="email" aria-describedby="email-error" aria-invalid="true" />
<p id="email-error" role="alert">Please enter a valid email</p>

<!-- Tab panel -->
<div role="tablist" aria-label="Settings">
  <button role="tab" aria-selected="true" aria-controls="panel-1">General</button>
  <button role="tab" aria-selected="false" aria-controls="panel-2">Privacy</button>
</div>
<div role="tabpanel" id="panel-1">General settings...</div>
<div role="tabpanel" id="panel-2" hidden>Privacy settings...</div>

<!-- Skip link -->
<a href="#main-content" class="sr-only focus:not-sr-only">Skip to content</a>
```

---

## Forms — The Right Way

```html
<form novalidate>
  <!-- ALWAYS associate label with input -->
  <label for="name">Full Name</label>
  <input id="name" type="text" required autocomplete="name" />

  <!-- Group related inputs -->
  <fieldset>
    <legend>Notification preferences</legend>
    <label><input type="checkbox" name="notify" value="email" /> Email</label>
    <label><input type="checkbox" name="notify" value="sms" /> SMS</label>
  </fieldset>

  <!-- Input types for mobile keyboards -->
  <input type="email" autocomplete="email" />    <!-- @ key on mobile -->
  <input type="tel" autocomplete="tel" />        <!-- number pad -->
  <input type="url" />                           <!-- .com key -->
  <input type="date" />                          <!-- native date picker -->
</form>
```

---

## Keyboard Navigation

| Rule | Implementation |
|------|---------------|
| All interactive elements must be focusable | Use semantic elements |
| Focus order must match visual order | Don't use `tabindex > 0` |
| Focus must be visible | Never `outline: none` without replacement |
| Custom widgets need keyboard support | Enter/Space to activate, Arrow keys to navigate |

| tabindex Value | Behavior |
|----------------|----------|
| `tabindex="0"` | Element joins natural tab order |
| `tabindex="-1"` | Focusable via JS only (for programmatic focus) |
| `tabindex="1+"` | **NEVER USE** — breaks natural order |

```javascript
// After route change — focus the main heading
useEffect(() => {
  document.querySelector("h1")?.focus();
}, [location.pathname]);
```

---

## WCAG 2.2 Contrast Requirements

| Level | Normal Text | Large Text (18px+ bold or 24px+) |
|-------|-------------|----------------------------------|
| AA (minimum) | 4.5:1 | 3:1 |
| AAA (enhanced) | 7:1 | 4.5:1 |
| Non-text (icons, borders) | 3:1 | 3:1 |

Other requirements: 24x24px minimum target size, focus visible, respect `prefers-reduced-motion`, reflows at 400% zoom.

---

## Image Patterns

```html
<!-- Content image — descriptive alt -->
<img src="chart.png" alt="Sales grew 40% in Q3 2025" />

<!-- Decorative image — empty alt (don't omit alt!) -->
<img src="swoosh.svg" alt="" />

<!-- Responsive images -->
<picture>
  <source media="(min-width: 800px)" srcset="hero-wide.webp" type="image/webp" />
  <img src="hero-narrow.jpg" alt="Product hero" loading="lazy" />
</picture>

<!-- srcset for resolution switching -->
<img
  src="photo-400.jpg"
  srcset="photo-400.jpg 400w, photo-800.jpg 800w, photo-1200.jpg 1200w"
  sizes="(min-width: 800px) 50vw, 100vw"
  alt="Description"
  loading="lazy"
  decoding="async"
  width="800" height="600"
/>
```

---

## Meta Tags

```html
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="Page description for SEO (150-160 chars)" />
  <meta property="og:title" content="Page Title" />
  <meta property="og:image" content="https://example.com/og-image.png" />
  <meta name="twitter:card" content="summary_large_image" />
  <link rel="icon" href="/favicon.svg" type="image/svg+xml" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
</head>
```

---

## Screen Reader Tips

1. Alt text — describe the image's PURPOSE, not its appearance
2. Heading hierarchy — don't skip levels (h1 → h3). Screen readers navigate by headings
3. Link text — descriptive ("View order details"), never "Click here" or "Read more"
4. Tables — use `<thead>`, `<th>`, `scope="col"/"row"` for data tables
5. Lists — use `<ul>`/`<ol>` for actual lists
6. Language — `<html lang="en">` so screen readers use correct pronunciation

---

## Daily Rules

1. Semantic HTML first, ARIA only when needed
2. Always associate `<label>` with `<input>` — no exceptions
3. Never `outline: none` without a visible replacement
4. Alt text on every `<img>` — empty `alt=""` for decorative only
5. Test with keyboard — if you can't tab to it, it's broken
6. Check contrast — 4.5:1 for text, 3:1 for non-text
7. Respect `prefers-reduced-motion`
