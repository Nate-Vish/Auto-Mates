# Code Review & Smells

**When to use:** During any code review. Apply the Google 8-area framework as your baseline, then layer on Checker's adversarial lens. Use the smells checklist to catch hidden bugs.

---

## Google Code Review: 8 Areas

Google's framework is the baseline. Checker reviews BEYOND this — adding the adversarial layer on top.

### 1. Design
- Does this code belong in this part of the system?
- Does it integrate well with existing architecture?
- Is now the right time for this change?

### 2. Functionality
- Does it work as intended?
- Does it serve end users AND developers who will maintain it?
- Consider edge cases, concurrency issues, potential bugs
- For UI changes: ask for a demo

### 3. Complexity
- Could it be simpler?
- Is the developer solving problems that don't exist yet? (over-engineering)
- Can another developer understand it easily?
- Rule: "Solve today's problem today, tomorrow's problem tomorrow"

### 4. Tests
- Are there unit, integration, or e2e tests?
- Are tests correct and meaningful?
- Would tests fail when code breaks? (no false positives)
- Treat test code as production code — review with equal rigor

### 5. Naming
- Do names communicate purpose?
- Are they clear without being unwieldy?
- Is naming consistent across the codebase?

### 6. Comments
- Do comments explain WHY, not WHAT? (the diff shows what)
- Are complex algorithms/regex explained?
- Any outdated TODOs that should be resolved?

### 7. Style
- Does it follow the project's style guide?
- Mark minor style issues as "Nit:" (not blocking)
- Don't mix style changes with functional changes

### 8. Documentation
- If behavior changed, is documentation updated?
- Are READMEs and reference guides current?
- Is deprecated code documentation removed?

### Reviewer Standards
- Review EVERY line assigned to you — no skimming
- If code is hard to understand, that IS a bug — ask for simplification
- Pair programming counts as review if the partner was qualified

---

## 7 Code Smells That Hide Real Bugs

These are not just style issues. These patterns actively **conceal** bugs, making them harder to find and more dangerous when they surface in production.

### 1. Error Swallowing

```js
try {
  riskyOperation()
} catch (e) {
  // TODO: handle this later
}
```

Code continues assuming success after failure. Research found empty catch blocks appear as often as proper error logging in real codebases.

**Test:** Search for empty catch blocks. Search for catches that only log but don't rethrow or handle.

### 2. Race Conditions

Bugs that only appear under load, disappear during debugging ("Heisenbugs").

Patterns that create hidden races:
- Shared mutable state without synchronization
- Read-modify-write without atomic operations
- Event handlers that assume ordering
- Async code with shared closures

**Test:** Look for shared state modified from multiple async paths. Ask: "What happens if these execute in reverse order?"

### 3. Stale Closures (React/JavaScript)

```js
function Counter() {
  const [count, setCount] = useState(0)
  useEffect(() => {
    const interval = setInterval(() => {
      setCount(count + 1)  // BUG: count is always 0 here (stale closure)
    }, 1000)
    return () => clearInterval(interval)
  }, [])  // empty deps = stale closure
}
```

**Test:** Look for closures over state variables with empty or incorrect dependency arrays.

### 4. Type Coercion Gotchas (JavaScript)

```js
"" == false     // true
0 == ""         // true
null == undefined // true
[] == false     // true
"0" == false    // true
```

**Test:** Search for `==` instead of `===`. Check boolean checks on potentially falsy values (0, "", null, undefined).

### 5. Missing Return Statements

```js
function findUser(id) {
  users.forEach(user => {
    if (user.id === id) return user  // BUG: returns from forEach callback, not findUser
  })
  // implicitly returns undefined
}
```

**Test:** Check functions that should return values. Are all code paths covered?

### 6. Off-by-One Errors

Fencepost problems in loops, array bounds, pagination.

**Test:** For every loop/range: what happens with 0 items? 1 item? Maximum items? Is the boundary inclusive or exclusive?

### 7. Silent LLM Failures

LLMs don't crash — they generate code that "runs but is wrong." They may remove safety checks, create fake output matching the expected format.

**Test:** Don't trust "it runs." Verify the OUTPUT is correct, not just that there is no error.

---

## Checker's Smell Detection Checklist

- [ ] Empty catch blocks or catch-and-log-only patterns?
- [ ] Shared mutable state accessed from multiple async paths?
- [ ] `==` instead of `===` in JavaScript?
- [ ] Closures over variables with stale references?
- [ ] Functions with implicit return paths?
- [ ] Loops with potential off-by-one at boundaries?
- [ ] Boolean checks on potentially falsy values?
- [ ] Assignments in conditionals (`=` vs `==`)?
- [ ] Code that is hard to understand? (that IS a bug)
- [ ] Over-engineering? (solving tomorrow's problem today)

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
