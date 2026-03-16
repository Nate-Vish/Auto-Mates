# Vite & Build Tooling
**When to use:** Read when configuring Vite, setting up path aliases, managing environment variables, or optimizing bundle size.

---

## Vite Config Essentials

```typescript
// vite.config.ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],

  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
      "@components": path.resolve(__dirname, "./src/components"),
      "@hooks": path.resolve(__dirname, "./src/hooks"),
      "@utils": path.resolve(__dirname, "./src/utils"),
    },
  },

  server: {
    port: 3000,
    open: true,
    proxy: {
      "/api": {
        target: "http://localhost:8080",
        changeOrigin: true,
      },
    },
  },

  build: {
    outDir: "dist",
    sourcemap: true,          // Enable for production debugging/Sentry
    target: "es2022",
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ["react", "react-dom"],
          three: ["three", "@react-three/fiber"],
        },
      },
    },
    chunkSizeWarningLimit: 500,
  },
});
```

### tsconfig Must Match Vite Aliases
```jsonc
// tsconfig.json — MUST align with vite.config resolve.alias
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"],
      "@hooks/*": ["./src/hooks/*"],
      "@utils/*": ["./src/utils/*"]
    }
  }
}
```

---

## Environment Variables

```bash
# .env               — default values (committed — no secrets!)
# .env.local         — local overrides (gitignored)
# .env.development   — dev server only
# .env.production    — build only

# Only VITE_ prefixed vars are exposed to client code
VITE_API_URL=https://api.example.com
VITE_APP_VERSION=1.0.0

# Server-only — NOT accessible to client JS
DATABASE_URL=postgres://localhost:5432/mydb
SECRET_KEY=never_in_client
```

```typescript
// Accessing in code
const apiUrl = import.meta.env.VITE_API_URL;
const isDev = import.meta.env.DEV;    // boolean
const isProd = import.meta.env.PROD;  // boolean
const mode = import.meta.env.MODE;    // "development" | "production"

// Type safety — src/vite-env.d.ts
interface ImportMetaEnv {
  readonly VITE_API_URL: string;
  readonly VITE_APP_VERSION: string;
}
interface ImportMeta { readonly env: ImportMetaEnv; }
```

**Build tool env var prefixes:**
| Build Tool | Client-Exposed Prefix | Access Pattern |
|-----------|----------------------|----------------|
| Vite | `VITE_` | `import.meta.env.VITE_*` |
| Create React App | `REACT_APP_` | `process.env.REACT_APP_*` |
| Next.js | `NEXT_PUBLIC_` | `process.env.NEXT_PUBLIC_*` |

---

## Code Splitting

```typescript
// Route-based splitting (most impactful — 40-60% initial bundle reduction)
const Dashboard = lazy(() => import("./pages/Dashboard"));
const Settings = lazy(() => import("./pages/Settings"));

// Named export splitting
const Chart = lazy(() => import("./components/Chart").then(m => ({ default: m.Chart })));

// Prefetch on hover
const prefetchSettings = () => import("./pages/Settings");
<Link to="/settings" onMouseEnter={prefetchSettings}>Settings</Link>
```

---

## Bundle Analysis

```bash
npm install -D rollup-plugin-visualizer
```

```typescript
import { visualizer } from "rollup-plugin-visualizer";
plugins: [react(), visualizer({ open: true, gzipSize: true })]
```

Run `npm run build` — opens interactive treemap showing exact size of every module.

---

## Manual Chunks Strategy

```typescript
rollupOptions: {
  output: {
    manualChunks(id) {
      if (id.includes("node_modules")) {
        if (id.includes("three") || id.includes("@react-three")) return "three";
        if (id.includes("react")) return "vendor-react";
        if (id.includes("monaco-editor")) return "vendor-monaco";
        return "vendor";
      }
    },
  },
},
```

Split vendor code so app code changes don't invalidate vendor cache.

---

## Tree Shaking Tips

- Use named exports (not default) for better tree shaking
- Avoid barrel files (`index.ts` re-exporting everything) — they prevent tree shaking
- Use `import { specific } from "library"` not `import * as lib from "library"`
- Check `"sideEffects": false` in library package.json

---

## Asset Handling

```typescript
import logo from "./assets/logo.svg";           // URL string
import styles from "./Button.module.css";        // CSS Module
import workerUrl from "./worker.js?url";         // URL without processing
import shaderSource from "./shader.glsl?raw";    // File content as string
import data from "./data.json";                  // Parsed as object

// public/ directory — served at root, no processing, no hashing
// Reference with absolute path: <img src="/favicon.ico" />
```

---

## HMR — When It Breaks

- Editing a file imported by many modules → Vite may do full reload
- Module-level side effects (code outside components) → state lost
- Non-React files (vanilla JS) → need manual HMR API

---

## Production Checklist

```bash
npx tsc --noEmit      # REQUIRED — Vite doesn't type-check, only transpiles
npx eslint src/
npm run build
npm run preview       # Test built files locally
```

---

## Plugin Ecosystem

| Plugin | Purpose |
|--------|---------|
| `@vitejs/plugin-react` | React Fast Refresh, JSX transform |
| `@vitejs/plugin-react-swc` | Same but uses SWC (faster) |
| `vite-plugin-svgr` | Import SVGs as React components |
| `vite-plugin-pwa` | Progressive Web App support |
| `rollup-plugin-visualizer` | Bundle size analysis |
| `vite-tsconfig-paths` | Auto-resolve tsconfig paths |

---

## Daily Rules

1. Path aliases in BOTH `vite.config.ts` AND `tsconfig.json` — they must match
2. Only `VITE_` prefixed env vars reach the client — never put secrets there
3. Route-based code splitting with `React.lazy` — split at page level minimum
4. Analyze bundle after major dependency changes
5. Manual chunks for large libraries (Three.js, Monaco) — separate vendor cache
6. `tsc --noEmit` before build — Vite doesn't catch type errors
