# React Ecosystem
**When to use:** Read when choosing state management libraries, setting up routing, forms, data fetching, testing, animation, or meta-frameworks.

---

## State Management

### Decision Tree

| State Type | Solution | Example |
|---|---|---|
| Component-local | `useState` / `useReducer` | Form inputs, toggles, modals |
| Shared UI state | Zustand | Theme, sidebar, app-wide UI |
| Server/async state | TanStack Query | API data, pagination, cache |
| URL state | Search params / Router | Filters, pagination, sort |
| Low-frequency shared | React Context | Theme, locale, auth status |

### Library Comparison

| Library | Bundle Size | Best For |
|---------|-------------|----------|
| **Zustand** | ~3KB | Default — most apps, quick setup |
| **Redux Toolkit** | ~15KB | Enterprise, large teams, time-travel debugging |
| **Jotai** | ~2KB | Fine-grained atomic reactivity, Suspense-native |
| **React Context** | 0KB | Low-frequency updates only (theme, locale, auth) |

### Zustand (Recommended Default)
```typescript
const useCartStore = create<CartStore>()(
  devtools(
    persist(
      (set, get) => ({
        items: [],
        addItem: (item) => set((s) => ({ items: [...s.items, item] })),
        removeItem: (id) => set((s) => ({ items: s.items.filter(i => i.id !== id) })),
        total: () => get().items.reduce((sum, i) => sum + i.price * i.qty, 0),
      }),
      { name: 'cart-storage' },
    ),
  ),
);

// Component — only re-renders when `items` changes
const count = useCartStore((s) => s.items.length);
```

---

## React Router v7

```typescript
const router = createBrowserRouter([
  {
    path: '/',
    element: <RootLayout />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Home /> },
      {
        path: 'dashboard',
        element: <DashboardLayout />,
        loader: dashboardLoader,   // Fetch data BEFORE render
        children: [
          { index: true, element: <Overview /> },
          { path: 'settings', element: <Settings />, action: settingsAction },
        ],
      },
    ],
  },
]);

// Loader — runs before route component renders
export async function dashboardLoader({ params }: LoaderFunctionArgs) {
  const data = await fetchDashboardData(params.orgId);
  if (!data) throw new Response('Not Found', { status: 404 });
  return data;
}

// Protected route via loader
{
  path: 'admin',
  loader: async () => {
    const user = await getUser();
    if (!user?.isAdmin) throw redirect('/login');
    return user;
  },
}
```

Key patterns: `<Outlet />` in layouts, `useNavigation()` for pending state, v7 generates TypeScript types for routes.

---

## Forms: React Hook Form + Zod

```typescript
const signupSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'Must be at least 8 characters'),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: 'Passwords must match',
  path: ['confirmPassword'],
});

type SignupForm = z.infer<typeof signupSchema>;

function SignupPage() {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<SignupForm>({
    resolver: zodResolver(signupSchema),
  });

  const onSubmit = async (data: SignupForm) => { await createAccount(data); };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
      <button type="submit" disabled={isSubmitting}>Sign Up</button>
    </form>
  );
}
```

**Multi-step forms:**
```typescript
const { trigger } = useForm<FormData>({ resolver: zodResolver(schema) });
const handleNext = async () => {
  const valid = await trigger(['firstName', 'lastName']);
  if (valid) setStep(step + 1);
};
```

---

## TanStack Query (Server State)

```typescript
// Basic query
const { data, isPending, error } = useQuery({
  queryKey: ['users'],
  queryFn: () => fetch('/api/users').then((r) => r.json()),
  staleTime: 5 * 60 * 1000,  // 5 minutes fresh
});

// Mutation with cache invalidation
const mutation = useMutation({
  mutationFn: (newUser: NewUser) => fetch('/api/users', { method: 'POST', body: JSON.stringify(newUser) }),
  onSuccess: () => queryClient.invalidateQueries({ queryKey: ['users'] }),
});

// Optimistic update
const mutation = useMutation({
  mutationFn: updateTodo,
  onMutate: async (newTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] });
    const previous = queryClient.getQueryData(['todos']);
    queryClient.setQueryData(['todos'], (old) => [...old, newTodo]);
    return { previous };
  },
  onError: (err, newTodo, context) => {
    queryClient.setQueryData(['todos'], context.previous);  // Rollback
  },
  onSettled: () => queryClient.invalidateQueries({ queryKey: ['todos'] }),
});

// Infinite queries
const { data, fetchNextPage, hasNextPage } = useInfiniteQuery({
  queryKey: ['posts'],
  queryFn: ({ pageParam }) => fetchPosts(pageParam),
  initialPageParam: 0,
  getNextPageParam: (lastPage) => lastPage.nextCursor,
});
```

---

## Testing: Vitest + Testing Library

```typescript
describe('Counter', () => {
  it('increments when button is clicked', async () => {
    const user = userEvent.setup();
    render(<Counter />);
    expect(screen.getByText('Count: 0')).toBeInTheDocument();
    await user.click(screen.getByRole('button', { name: /increment/i }));
    expect(screen.getByText('Count: 1')).toBeInTheDocument();
  });
});

// Mock a module
vi.mock('./api', () => ({
  fetchUsers: vi.fn().mockResolvedValue([{ id: 1, name: 'Alice' }]),
}));
```

**Key testing principles:**
- Test behavior, not implementation
- Use `getByRole`, `getByLabelText`, `getByText` — not `getByTestId`
- Co-locate tests next to components
- E2E with Playwright for critical user flows

---

## Animation: Framer Motion

```tsx
import { motion, AnimatePresence } from 'motion/react';

// Animate on mount
<motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.3 }}>
  Content
</motion.div>

// Animate on mount/unmount
<AnimatePresence>
  {isVisible && (
    <motion.div key="modal" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
      <Modal />
    </motion.div>
  )}
</AnimatePresence>

// Staggered children
const container = { hidden: {}, show: { transition: { staggerChildren: 0.1 } } };
const item = { hidden: { opacity: 0, y: 20 }, show: { opacity: 1, y: 0 } };
<motion.ul variants={container} initial="hidden" animate="show">
  {items.map((i) => <motion.li key={i.id} variants={item}>{i.name}</motion.li>)}
</motion.ul>
```

Use Framer Motion for mount/unmount animations, gesture handling, orchestration. CSS transitions for simple hover/color changes.

---

## Meta-Frameworks

| Framework | Best For | Key Feature |
|-----------|----------|-------------|
| **Next.js** | Full-stack SaaS, dashboards, e-commerce | RSC, Server Actions, largest ecosystem |
| **Remix** | Data-heavy, complex forms | Superior data mutation patterns, web standards |
| **Astro** | Content sites, marketing, blogs | Zero JS by default, fastest builds |
| **Vite + React** | Simple SPA, no SSR needed | No framework overhead |

---

## Component Libraries

| Library | Philosophy | Best For |
|---------|------------|----------|
| **shadcn/ui** | Copy-paste components (own the code) | Full control, Tailwind projects |
| **Radix UI** | Unstyled primitives with a11y built in | Custom design systems |
| **Mantine** | Batteries-included | Rapid prototyping |
| **MUI** | Material Design | Enterprise, Material Design |

```bash
npx shadcn-ui@latest init
npx shadcn-ui@latest add button dialog
# Components land in components/ui/ as editable source code
```

---

## Monorepo: Turborepo

```
monorepo/
├── apps/
│   ├── web/          # Next.js or Vite
│   └── admin/
├── packages/
│   ├── ui/           # Shared component library
│   ├── hooks/        # Shared React hooks
│   ├── types/        # Shared TypeScript types
│   └── eslint-config/
├── turbo.json
└── pnpm-workspace.yaml
```

```json
// turbo.json
{ "tasks": { "build": { "dependsOn": ["^build"], "outputs": ["dist/**"] }, "dev": { "persistent": true } } }
```

---

## Daily Rules

1. Zustand for state — use Redux Toolkit only for enterprise patterns
2. TanStack Query for all server data — separate from client state
3. React Router v7 loaders to fetch data at the route level
4. React Hook Form + Zod for every form — define schemas in separate files
5. Default to Server Components — add `"use client"` only when needed
6. Test behavior, not implementation — `getByRole` queries
7. shadcn/ui for component libraries — copy-paste, own the code
8. Next.js for full-stack apps, Astro for content sites, Vite for simple SPAs
