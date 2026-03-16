# Frontend Architecture
**When to use:** Read when making browser API choices, planning rendering strategy, implementing PWA features, i18n, or frontend security.

---

## Browser APIs Worth Knowing

### IntersectionObserver — Replaces scroll listeners
```typescript
const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target as HTMLImageElement;
        img.src = img.dataset.src!;
        observer.unobserve(img);
      }
    });
  },
  { rootMargin: '200px', threshold: 0.1 },
);
document.querySelectorAll<HTMLImageElement>('img[data-src]').forEach(img => observer.observe(img));
```

### ResizeObserver — Element-level responsive
```typescript
const observer = new ResizeObserver((entries) => {
  for (const entry of entries) {
    const { width } = entry.contentRect;
    entry.target.classList.toggle('compact', width < 400);
  }
});
observer.observe(document.querySelector('.sidebar')!);
```

### Web Workers — Offload CPU-heavy work
```typescript
// worker.ts
self.onmessage = (e: MessageEvent) => {
  const result = e.data.data.reduce((sum: number, n: number) => sum + n, 0);
  self.postMessage({ result });
};
// main.ts
const worker = new Worker(new URL('./worker.ts', import.meta.url), { type: 'module' });
worker.postMessage({ data: largeArray });
worker.onmessage = (e) => console.log('Result:', e.data.result);
```

### Web Storage
| API | Capacity | Persistence | Scope |
|---|---|---|---|
| `localStorage` | ~5-10 MB | Until cleared | Per origin |
| `sessionStorage` | ~5-10 MB | Until tab closes | Per tab + origin |
| `IndexedDB` | Large (GBs) | Until cleared | Per origin |

**Rule:** Never store sensitive data (tokens, secrets) in localStorage. Use httpOnly cookies for auth tokens.

---

## Rendering Strategies

| Pattern | Data Freshness | SEO | Performance | Best For |
|---|---|---|---|---|
| **CSR** | Real-time | Poor | Slow initial, fast after | Dashboards, internal tools |
| **SSR** | Per-request | Excellent | Depends on server | Personalized pages, search results |
| **SSG** | Build-time | Excellent | Fastest (CDN-served) | Blogs, docs, marketing pages |
| **ISR** | Periodic | Excellent | Fast (CDN + revalidation) | Product pages, news, catalogs |

### Real-World Hybrid Strategy
```
Homepage           → SSG + ISR (revalidate every 60s)
Product listings   → SSG + ISR (revalidate every hour)
Shopping cart      → CSR (real-time, client state)
Checkout           → SSR (security, fresh pricing)
User dashboard     → CSR (authenticated, interactive)
Blog               → SSG (rarely changes)
```

### Emerging Patterns (2026)
- **React Server Components:** Zero client JS for server-rendered components. Mix in same tree (Next.js App Router).
- **Partial Hydration/Islands:** Only hydrate interactive parts (Astro, Fresh).
- **Partial Prerendering (PPR):** Static shell + dynamic slots. Combines SSG speed with SSR flexibility.

---

## Performance Optimization

### Image Optimization
```html
<picture>
  <source srcset="/hero.avif" type="image/avif" />
  <source srcset="/hero.webp" type="image/webp" />
  <img src="/hero.jpg" alt="Hero" loading="lazy" decoding="async" width="1200" height="600" />
</picture>
```

| Format | Compression | Use When |
|---|---|---|
| **AVIF** | Best (~50% smaller than JPEG) | Primary format where supported |
| **WebP** | Great (~30% smaller) | Universal fallback |
| **JPEG** | Baseline | Legacy fallback |

### Resource Hints
```html
<link rel="preconnect" href="https://api.example.com" />    <!-- DNS + TCP + TLS early -->
<link rel="dns-prefetch" href="https://cdn.example.com" />  <!-- DNS only -->
<link rel="preload" href="/critical.css" as="style" />
<link rel="prefetch" href="/next-page.js" />                 <!-- Low-priority future navigation -->
```

### Font Loading
```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter.woff2') format('woff2');
  font-display: swap;
}
```
```html
<link rel="preload" href="/fonts/Inter.woff2" as="font" type="font/woff2" crossorigin />
```

### Performance Checklist
- Route-based code splitting with `React.lazy`
- WebP/AVIF images with `srcset`
- Preconnect to API origins
- Inline critical CSS
- `loading="lazy"` on below-fold images
- Font `display: swap` + preload

---

## PWA Basics

### Web App Manifest
```json
{
  "name": "My Application",
  "short_name": "MyApp",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#0066ff",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### Service Worker Caching Strategies
| Strategy | How It Works | Best For |
|---|---|---|
| **Cache-First** | Check cache, fall back to network | Static assets (CSS, JS, images) |
| **Network-First** | Try network, fall back to cache | API responses, dynamic content |
| **Stale-While-Revalidate** | Serve from cache, update in background | Content where staleness is OK |
| **Network-Only** | Always fetch | Real-time data, auth endpoints |

Use Workbox for service worker lifecycle management.

---

## Web Security

### XSS Prevention
```typescript
import DOMPurify from 'dompurify';
function UserContent({ html }: { html: string }) {
  return <div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(html) }} />;
}
```

### Content Security Policy (CSP)
```
Content-Security-Policy:
  default-src 'self';
  script-src 'nonce-{random}' 'strict-dynamic';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  object-src 'none';
```
Start with `Content-Security-Policy-Report-Only` to identify issues before enforcing.

### Secure Cookies
```typescript
res.cookie('refreshToken', token, {
  httpOnly: true,   // Not accessible via JavaScript
  secure: true,     // HTTPS only
  sameSite: 'lax',  // CSRF protection
  maxAge: 7 * 24 * 60 * 60 * 1000,
  path: '/api/auth',
});
```

---

## Internationalization (i18n)

```typescript
import i18n from 'i18next';
import { initReactI18next, useTranslation } from 'react-i18next';

i18n.use(initReactI18next).init({
  resources: {
    en: { translation: { greeting: 'Hello, {{name}}!' } },
    es: { translation: { greeting: 'Hola, {{name}}!' } },
  },
  lng: 'en', fallbackLng: 'en',
});

function Welcome({ name }: { name: string }) {
  const { t } = useTranslation();
  return <h1>{t('greeting', { name })}</h1>;
}
```

**RTL support:** Use CSS logical properties (`margin-inline-start` not `margin-left`). Set `dir="rtl"` on `<html>`.

---

## Design System Integration

### Design Tokens
```typescript
export const tokens = {
  color: { primary: { 50: '#eff6ff', 500: '#3b82f6', 900: '#1e3a8a' } },
  spacing: { xs: '0.25rem', sm: '0.5rem', md: '1rem', lg: '1.5rem', xl: '2rem' },
  font: { sans: 'Inter, system-ui, sans-serif' },
} as const;
```

### Theming with CSS Variables
```css
:root { --color-primary: #3b82f6; --color-bg: #ffffff; }
[data-theme='dark'] { --color-primary: #60a5fa; --color-bg: #0a0a0a; }
```

---

## Frontend Testing Pyramid

```
         /  E2E  \          ← Few (Playwright) — critical user journeys
        / Component \       ← Some (Vitest + Testing Library) — UI behavior
       /    Unit     \      ← Many (Vitest) — logic, hooks, utilities
```

| Layer | Tool | What to Test |
|---|---|---|
| **Unit** | Vitest | Pure functions, hooks, utilities |
| **Component** | Vitest + Testing Library | UI rendering, interactions, a11y |
| **E2E** | Playwright | Critical user paths, cross-browser |

---

## Micro-Frontend Awareness

Use only when multiple autonomous teams need independent deployment cycles. For most apps, a well-structured monolith is simpler and better.

| Approach | Trade-off |
|---|---|
| Module Federation | Complex config, good DX |
| iframes | Strong isolation, poor UX |
| Web Components | Framework-agnostic, limited tooling |

---

## Daily Rules

1. `useState` for local state, Zustand for shared client state, TanStack Query for server state
2. Lazy-load routes; WebP/AVIF images with srcset; preconnect to API origins
3. Default to SSG + ISR for public pages, CSR for authenticated sections
4. Strict CSP with nonces; sanitize user HTML with DOMPurify; httpOnly cookies for auth
5. Vitest for unit + component tests; Playwright for E2E critical paths
6. Prefer IntersectionObserver over scroll listeners, ResizeObserver over window.resize
7. Add manifest + service worker for apps that benefit from offline access
8. Design tokens as source of truth; CSS custom properties for theming
9. i18n from the start — use CSS logical properties for RTL support
