---
title: "Code Quality & Review Wisdom"
category: "Software Engineering / Code Quality"
tags:
  - code-review
  - naming
  - abstraction
  - refactoring
  - code-smells
  - documentation
  - error-handling
  - technical-debt
source_type: professional-knowledge
audience: senior-developer
---

# Code Quality & Review Wisdom

Hard-won lessons from decades of collective industry experience. Every anti-pattern
listed here has burned real teams, shipped real bugs, and cost real money. This is
not theory — this is the scar tissue of professional software development.

---

## 1. Code Review Best Practices

### What to Actually Look For

| Priority | Focus Area | Why It Matters |
|----------|-----------|----------------|
| **Critical** | Correctness — does it do what it claims? | Bugs in production cost 100x more than bugs caught in review |
| **Critical** | Security — injection, auth bypass, data leaks | One missed vulnerability can end a company |
| **High** | Error handling — what happens when things fail? | Happy path works; sad path crashes at 3 AM |
| **High** | Edge cases — nulls, empty collections, boundaries | The data users send is never what you expect |
| **Medium** | Performance — O(n^2) loops, N+1 queries, memory leaks | Fine with 10 rows, disaster with 10 million |
| **Medium** | Testability — can this be tested without heroics? | Untestable code is untrustworthy code |
| **Low** | Style — formatting, naming minutiae | Automate this; humans should not argue about tabs |

### What NOT to Bikeshed

Stop wasting review cycles on these — automate them instead:

- **Formatting and whitespace** — use a formatter (Prettier, Black, gofmt, clang-format)
- **Import ordering** — use an import sorter
- **Trailing commas** — configure your linter
- **Brace placement** — pick a style, enforce it with tooling, never discuss again
- **Line length** — set a limit in your linter and move on

### Review Speed vs. Thoroughness

```
Rule of thumb:
- Reviews > 400 lines: defect detection drops by 70%
- Reviews > 60 minutes: reviewer fatigue causes missed bugs
- Ideal review size: 200-400 lines
- Ideal review time: 30-60 minutes

If someone submits a 2000-line PR, the right response is:
"Please break this into smaller PRs," not a heroic multi-hour review.
```

### The Review Tone Checklist

| Instead of... | Say... |
|---------------|--------|
| "This is wrong." | "I think this might not handle the case where X is null — what do you think?" |
| "Why did you do it this way?" | "I'm curious about the reasoning here — was there a constraint I'm missing?" |
| "This is obviously bad." | "I've seen this pattern cause issues with X in the past. Consider Y instead?" |
| "You should know better." | Never say this. Ever. |
| "Nit:" (20 times) | Pick 2-3 nits max. The rest go into a linter rule. |

### Review Checklist Template

```markdown
## Before Approving, Verify:
- [ ] I understand what this change does and why
- [ ] Happy path works correctly
- [ ] Error/failure paths are handled
- [ ] No obvious security issues (injection, auth, data exposure)
- [ ] Edge cases considered (null, empty, boundary values)
- [ ] No unintended side effects on existing behavior
- [ ] Tests cover the new/changed behavior
- [ ] No secrets, credentials, or PII in the diff
- [ ] Breaking changes are documented or versioned
```

---

## 2. Naming Traps

### Misleading Names — The Silent Bug Generator

```python
# DANGEROUS: Name says one thing, code does another
def get_user(user_id):
    """This actually creates a user if not found."""
    user = db.find(user_id)
    if not user:
        user = db.create(User(id=user_id))  # SURPRISE!
    return user

# HONEST:
def get_or_create_user(user_id):
    user = db.find(user_id)
    if not user:
        user = db.create(User(id=user_id))
    return user
```

### Abbreviation Hall of Shame

| Abbreviation | What author meant | What reader thinks |
|-------------|-------------------|-------------------|
| `mgr` | Manager | Manager? Merger? |
| `ctx` | Context | Acceptable in Go; confusing elsewhere |
| `proc` | Process | Procedure? Processor? |
| `val` | Value | Validate? Valid? Value? |
| `tmp` | Temporary | Every "temporary" variable lives forever |
| `str` | String | Structure? Stream? Strategy? |
| `res` | Response | Result? Resource? Resolution? |
| `req` | Request | Requirement? Requisition? |
| `cnt` | Count | Content? Continue? (Looks like a profanity) |
| `e` | Event/Error/Element | Nobody knows; everyone guesses differently |

**Rule:** If the abbreviation saves fewer than 5 characters, spell it out.

### Boolean Naming Confusion

```java
// BAD: Is this a question or a command?
boolean close;        // Close what? Is it closed? Should we close it?
boolean read;         // Has it been read? Should we read it?
boolean disable;      // Is it disabled? Should we disable it?

// GOOD: Booleans should read as true/false questions
boolean isClosed;
boolean hasBeenRead;
boolean isDisabled;

// ALSO GOOD: Predicates for methods
boolean canRetry();
boolean shouldNotify();
boolean hasPermission();
```

### Inconsistent Convention Catalog

```javascript
// All of these exist in the same codebase (seen in real projects):
getUserData()
fetch_user_info()
retrieveUserDetails()
loadUserRecord()
findUserById()
queryUser()

// Pick ONE verb for ONE concept. Document the convention:
// "We use 'get' for synchronous lookups, 'fetch' for async/remote calls."
```

---

## 3. Abstraction Failures

### Premature Abstraction

```python
# Developer sees two similar functions and immediately abstracts:

# BEFORE (two simple, clear functions):
def send_welcome_email(user):
    send_email(user.email, "Welcome!", welcome_template(user.name))

def send_reset_email(user):
    send_email(user.email, "Reset Password", reset_template(user.token))

# AFTER "abstraction" (one confusing function):
def send_email_by_type(user, email_type, **kwargs):
    templates = {
        'welcome': lambda: welcome_template(kwargs.get('name', user.name)),
        'reset': lambda: reset_template(kwargs.get('token')),
        'verify': lambda: verify_template(kwargs.get('code')),
        # ... 15 more types added over 2 years
    }
    subjects = {
        'welcome': 'Welcome!',
        'reset': 'Reset Password',
        # ...
    }
    template_fn = templates.get(email_type)
    if not template_fn:
        raise ValueError(f"Unknown email type: {email_type}")
    send_email(user.email, subjects[email_type], template_fn())

# The "abstraction" is now a god function that everyone is afraid to touch.
```

**The Rule of Three:** Don't abstract until you have three concrete instances, and
even then, only if the shared pattern is stable.

### Wrong Abstraction Is Worse Than Duplication

```
Sandi Metz's Law:
"Duplication is far cheaper than the wrong abstraction."

Signs you have the wrong abstraction:
- The abstraction has more parameters than the original code had lines
- You pass boolean flags to toggle behavior inside the abstraction
- New use cases require modifying the abstraction itself
- You find yourself working around the abstraction more than using it
- The abstraction's name no longer describes what it does
```

### Leaky Abstractions

```typescript
// This database abstraction "hides" the database:
class UserRepository {
    findAll(): User[] { /* ... */ }
}

// But callers still need to know about database concerns:
const users = repo.findAll();
// Caller must know: Does this load everything into memory?
// Caller must know: Is this paginated? Do I need to close a cursor?
// Caller must know: Are relations lazy-loaded or eager?

// The abstraction leaks. Fix it by making constraints explicit:
class UserRepository {
    findAll(options: { limit: number; offset: number }): PagedResult<User> {
        /* ... */
    }
}
```

### Abstraction Layers That Add Complexity

```
Layer count vs. value (real pattern from codebases):

Controller -> Service -> Manager -> Handler -> Provider -> Repository -> DAO -> DB

That is 7 layers between an HTTP request and a database query.
Each layer adds:
- Another file to navigate
- Another place for bugs to hide
- Another thing to mock in tests
- Another name to remember

Ask: "If I removed this layer, would anything break or become unclear?"
If the answer is no, remove it.
```

---

## 4. Refactoring Mistakes

### Refactoring Without Tests

```
The refactoring death spiral:
1. "This code is messy, I'll clean it up."
2. No tests exist for the messy code.
3. Refactor introduces subtle behavior change.
4. Nobody notices until production breaks.
5. Team loses trust in refactoring.
6. Code gets messier because nobody dares touch it.

The rule: Write characterization tests BEFORE refactoring.
Characterization tests capture CURRENT behavior, warts and all.
They are your safety net — refactor with confidence, not hope.
```

### Big-Bang Refactors

| Approach | Risk | Success Rate |
|----------|------|-------------|
| Rewrite everything at once | Catastrophic | ~10% |
| Strangler fig (incremental replacement) | Low | ~80% |
| Branch-by-abstraction | Low-Medium | ~75% |
| Parallel run (old + new, compare outputs) | Low | ~85% |

**Big-bang rewrites fail because:**
- You must maintain two systems during the transition
- The old system keeps getting new requirements
- The rewrite team underestimates the original's hidden complexity
- By the time the rewrite is "done," requirements have changed

### Refactoring During Feature Work

```
DON'T:
  git commit -m "Add user notifications and refactor database layer"

This is two unrelated changes. If the refactor breaks something,
you cannot revert it without losing the feature.

DO:
  git commit -m "Refactor database layer for clarity"
  git commit -m "Add user notifications"

Separate commits. Separate PRs if possible. Separate risk profiles.
```

### Not Knowing When to Stop

```
The refactoring rabbit hole:

"I'll just rename this variable."
  -> "While I'm here, this function is too long."
    -> "This class has too many responsibilities."
      -> "Actually the whole module needs restructuring."
        -> "This architecture doesn't support what we need."
          -> [3 weeks later, nothing works, nothing is merged]

Set a timebox. If a refactoring grows beyond its original scope,
stop, commit what you have, and create a ticket for the rest.
```

---

## 5. Code Smell Catalog

### Quick Reference

| Smell | Symptom | Typical Fix |
|-------|---------|-------------|
| **Long Method** | Method > 20-30 lines, multiple indent levels | Extract methods with meaningful names |
| **God Class** | Class with 50+ methods or 1000+ lines | Split by responsibility (SRP) |
| **Feature Envy** | Method uses more data from another class than its own | Move method to the class it envies |
| **Shotgun Surgery** | One change requires editing 10+ files | Consolidate related logic |
| **Primitive Obsession** | Using `string` for email, `int` for money, `string` for phone | Create value objects / domain types |
| **Data Clumps** | Same 3-4 parameters always travel together | Create a parameter object |
| **Dead Code** | Unreachable code, unused variables, commented-out blocks | Delete it. Version control remembers. |
| **Message Chains** | `a.getB().getC().getD().doThing()` | Law of Demeter — introduce delegate methods |
| **Speculative Generality** | Interfaces with one implementation, "just in case" params | YAGNI — remove until actually needed |
| **Parallel Inheritance** | Every time you add a subclass in one hierarchy, you must add one in another | Merge hierarchies or use composition |

### Primitive Obsession in Detail

```java
// BAD: Primitives everywhere
public void createOrder(String customerId, String productId,
    int quantity, double price, String currency,
    String street, String city, String zip, String country) {
    // Which string is which? Easy to swap arguments.
}

// GOOD: Domain types
public void createOrder(CustomerId customer, ProductId product,
    Quantity quantity, Money price, Address shippingAddress) {
    // Compiler catches mistakes. Code is self-documenting.
}
```

### Dead Code: Delete It

```
"But what if we need it later?"

You won't. And if you do, it's in git history.

Types of dead code to hunt:
- Commented-out code blocks (just delete them)
- Functions that nothing calls (IDE can find these)
- Feature flags that have been 100% on for 6+ months
- TODO comments older than 1 year (they're never getting done)
- Catch blocks that just log and re-throw identically
- Configuration for removed features
- Unused imports/dependencies
```

---

## 6. Documentation Traps

### Comments That Lie

```python
# Increments counter by one    <-- This comment was true 3 years ago
counter = counter * multiplier + offset  # Now it does something completely different

# The most dangerous comment is the one that's ALMOST right.
# Developers trust comments. Wrong comments cause wrong assumptions.
# Wrong assumptions cause bugs that take days to find.
```

### "What" vs. "Why" Comments

```java
// BAD: Describes WHAT (the code already tells us what)
// Loop through users and check if active
for (User user : users) {
    if (user.isActive()) { ... }
}

// GOOD: Describes WHY (the code cannot tell us why)
// Filter to active users only — inactive users have stale payment
// methods that cause false positives in the fraud check (see INC-4523)
for (User user : users) {
    if (user.isActive()) { ... }
}

// ALSO GOOD: Describes WHY NOT (prevents future "improvements")
// We intentionally do NOT cache this result. User permissions can
// change mid-session via admin panel, and stale cache caused
// privilege escalation bug in v2.3 (see POST-MORTEM-2024-01).
Permission perm = permissionService.checkPermission(userId, resource);
```

### The Documentation Spectrum

```
Too little docs:                         Too many docs:
"Figure it out from the code"            Every line has a comment
No README at all                         500-page architecture doc nobody reads
No API documentation                     Comments restate the code in English
No onboarding guide                      Generated docs with no curation

The sweet spot:
- README: What is this, how to run it, how to contribute
- Architecture Decision Records (ADRs): WHY we chose X over Y
- API docs: Request/response contracts, error codes, auth
- Code comments: Only for non-obvious WHY and complex algorithms
- Runbooks: How to deploy, how to debug common issues
```

### Over-Documentation Anti-Pattern

```python
class UserService:
    """
    UserService class.

    This class provides services related to users.

    Attributes:
        db: The database connection.

    Methods:
        get_user: Gets a user.
        create_user: Creates a user.
        delete_user: Deletes a user.
    """

    def get_user(self, user_id: int) -> User:
        """
        Gets a user.

        Args:
            user_id: The ID of the user.

        Returns:
            User: The user object.

        Raises:
            UserNotFoundError: If the user is not found.
        """
        # This docstring adds ZERO information beyond the type signature.
        # The method name, parameter name, and return type already tell us
        # everything the docstring says.

        # Write docstrings when they add information the signature cannot:
        # - Side effects the caller should know about
        # - Performance characteristics
        # - Thread safety guarantees
        # - Non-obvious preconditions or postconditions
```

---

## 7. Error Handling Patterns

### Fail Fast vs. Fail Safe

| Strategy | When to Use | Example |
|----------|------------|---------|
| **Fail Fast** | Development, startup, configuration errors, data corruption | Invalid config file -> crash immediately with clear message |
| **Fail Safe** | User-facing features, degraded but functional service | Image thumbnail fails -> show placeholder, log error |

```python
# FAIL FAST: Configuration error at startup
def load_config(path):
    if not os.path.exists(path):
        raise SystemExit(f"FATAL: Config file not found: {path}")
    config = parse_config(path)
    if 'database_url' not in config:
        raise SystemExit("FATAL: 'database_url' missing from config")
    return config
    # Do NOT catch this and return defaults. Wrong config = wrong behavior.
    # Crash loudly at startup, not silently in production at 3 AM.

# FAIL SAFE: Non-critical feature in user-facing app
def get_user_avatar(user_id):
    try:
        return avatar_service.fetch(user_id)
    except AvatarServiceError as e:
        logger.warning(f"Avatar fetch failed for {user_id}: {e}")
        return DEFAULT_AVATAR
    # The page still loads. The user sees a default avatar.
    # The team gets a log alert if this spikes.
```

### Exception Handling Anti-Patterns

```python
# 1. Pokemon exception handling (gotta catch 'em all)
try:
    do_something()
except Exception:  # Catches EVERYTHING including KeyboardInterrupt
    pass           # And IGNORES it

# 2. Exception as flow control
try:
    value = dictionary[key]
except KeyError:
    value = default
# Use: value = dictionary.get(key, default)

# 3. Catch-log-rethrow (adds noise, no value)
try:
    do_something()
except SomeError as e:
    logger.error(f"Error: {e}")
    raise  # The caller will also log it. Now you have duplicate logs.

# 4. Swallowing exceptions with a generic message
try:
    process_payment(order)
except Exception:
    return {"error": "Something went wrong"}
    # The payment might have been charged. You don't know.
    # The user doesn't know. Nobody knows.
```

### Error Recovery Decision Tree

```
Error occurs:
  |
  +-> Is this a transient error (network timeout, rate limit)?
  |     YES -> Retry with exponential backoff (max 3-5 retries)
  |     NO  -> Continue below
  |
  +-> Can the operation be skipped without data loss?
  |     YES -> Skip, log warning, continue (degraded mode)
  |     NO  -> Continue below
  |
  +-> Is there a fallback (cache, default, secondary service)?
  |     YES -> Use fallback, log warning, alert if persistent
  |     NO  -> Continue below
  |
  +-> Is this a user-facing operation?
  |     YES -> Return clear error message, log full details internally
  |     NO  -> Fail fast, alert on-call, log full stack trace
```

### Error Boundaries

```
Layer          | What to Catch                    | What to Do
---------------|----------------------------------|---------------------------
HTTP Handler   | All unhandled exceptions         | Return 500, log, alert
Service Layer  | Domain-specific exceptions       | Translate to result types
Repository     | Database-specific exceptions     | Translate to domain errors
External API   | Network/timeout/parse errors     | Retry, fallback, or fail
Background Job | All exceptions                   | Log, retry queue, dead-letter

CRITICAL RULE:
Each layer catches exceptions from its OWN level of abstraction.
The HTTP handler should never see a "connection reset" error —
that should be translated to "UserService unavailable" by the service layer.
```

---

## 8. Technical Debt Management

### Identifying Debt

```
Symptoms that you're carrying technical debt:

- "Don't touch that file" — areas of the codebase nobody dares modify
- "It works, but..." — code that works by accident, not by design
- "We'll fix it later" — the #1 lie in software development
- Onboarding takes weeks — new devs can't understand the system
- Simple changes take days — because of hidden coupling
- The same bug keeps coming back — because the root cause is structural
- Fear of deploying — because nobody is confident the tests catch everything
```

### The Debt Quadrant (Martin Fowler)

```
                    Deliberate                    Inadvertent
            +---------------------------+---------------------------+
            |                           |                           |
  Reckless  | "We don't have time for   | "What's a design          |
            |  design."                 |  pattern?"                |
            |                           |                           |
            | -> Deadline pressure, but | -> Team lacks knowledge.  |
            |    team knows better.     |    Debt is invisible to   |
            |    Track it. Pay it back. |    them. Invest in        |
            |                           |    training.              |
            +---------------------------+---------------------------+
            |                           |                           |
  Prudent   | "We must ship now and     | "Now we know how we       |
            |  deal with consequences." |  should have done it."    |
            |                           |                           |
            | -> Conscious trade-off.   | -> Natural learning.      |
            |    Document it. Schedule  |    Refactor as you go.    |
            |    paydown. Acceptable.   |    This is healthy.       |
            +---------------------------+---------------------------+
```

### Debt Register Template

```markdown
| ID | Description | Location | Impact | Effort | Priority | Created | Owner |
|----|-------------|----------|--------|--------|----------|---------|-------|
| TD-001 | No input validation on /api/users | UserController | High (security) | Medium (2d) | P1 | 2024-01-15 | Team |
| TD-002 | Monolithic OrderService (800 lines) | order/service.py | Medium (velocity) | High (1w) | P2 | 2024-02-01 | Team |
| TD-003 | No DB indexes on common queries | schema.sql | High (performance) | Low (2h) | P1 | 2024-03-01 | Team |

Priority formula:
  P1 = High impact + Low/Medium effort (fix immediately)
  P2 = High impact + High effort (schedule this quarter)
  P3 = Medium impact + any effort (do when convenient)
  P4 = Low impact (consider if it's even worth tracking)
```

### Paying Down Debt

```
Strategy 1: The Boy Scout Rule
  "Leave the code cleaner than you found it."
  Every PR improves one small thing beyond the feature.
  Low risk. Continuous improvement. Builds good habits.

Strategy 2: Dedicated Debt Sprints
  Reserve 20% of each sprint for debt paydown.
  Alternate: One full "debt sprint" every 5th sprint.
  Requires management buy-in. Worth fighting for.

Strategy 3: Strangler Fig for Legacy Modules
  Don't rewrite. Build new code alongside old code.
  Route traffic gradually to new code.
  Remove old code when traffic reaches zero.

Strategy 4: Opportunistic Paydown
  When a feature touches a debt-laden area, budget
  extra time to clean up that area as part of the feature.
  "We need 3 days for the feature + 2 days to untangle
   the module it depends on."

ANTI-STRATEGY: "We'll rewrite everything from scratch"
  This is almost always wrong. See: Netscape, Chandler, etc.
```

### Debt Conversations with Stakeholders

```
DON'T say: "The code is bad and we need to rewrite it."
DO say:    "Adding feature X currently takes 2 weeks because of
            coupling in module Y. A 1-week investment to decouple
            would reduce future feature time to 3 days."

DON'T say: "We have technical debt."
DO say:    "Our deployment failure rate has increased 40% this
            quarter. The root cause is untested integration points.
            Investing 2 sprints in test coverage would reduce
            incidents by an estimated 60%."

Speak in business terms:
  - Time to ship features (velocity)
  - Incident frequency and severity
  - Developer onboarding time
  - Customer-facing reliability
```

---

## Gal's Application: 10 Daily Rules

```
1. REVIEW FOR CORRECTNESS FIRST
   Stop nitpicking style. Ask: "Does this code do what it claims?"
   Formatting is the linter's job. Logic errors are yours.

2. READ THE NAMES OUT LOUD
   If a function name does not clearly tell you what it does,
   it is a bug waiting to happen. Flag every misleading name.

3. CHALLENGE EVERY ABSTRACTION
   Ask: "Does this abstraction earn its keep?" If removing a layer
   would make the code simpler and equally clear, it should go.

4. DEMAND TESTS BEFORE REFACTORS
   No tests, no refactoring. Period. If someone says "I'll add tests
   after," they won't. Characterization tests first, then refactor.

5. DELETE DEAD CODE ON SIGHT
   Commented-out blocks, unused functions, stale feature flags.
   Delete them. Git remembers. Living code should be live code.

6. ASK "WHY?" ON EVERY COMMENT
   If a comment describes WHAT the code does, it should be deleted
   or the code should be renamed. Comments exist to explain WHY.

7. CHECK ERROR PATHS HARDER THAN HAPPY PATHS
   The happy path is easy to test and easy to review. The error
   path is where production burns down. Review it twice.

8. TRACK DEBT OR IT COMPOUNDS
   Untracked debt is invisible debt. Invisible debt compounds until
   the codebase collapses. Maintain a debt register. Review it monthly.

9. KEEP REVIEWS SMALL AND FAST
   A 2000-line PR is not a PR — it is a dare. Push back. Insist on
   smaller, reviewable chunks. 200-400 lines, 30-60 minutes.

10. BE KIND, BE DIRECT, BE SPECIFIC
    "This might cause a null pointer on line 42 when user.address
    is missing" is useful. "This is bad code" is not. Review the
    code, not the person.
```
