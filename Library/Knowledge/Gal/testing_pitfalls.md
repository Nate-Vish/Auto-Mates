---
title: "Testing Pitfalls"
category: "Software Engineering / Testing"
tags:
  - testing
  - unit-tests
  - integration-tests
  - flaky-tests
  - mocking
  - test-data
  - performance-testing
  - ci-cd
source_type: professional-knowledge
audience: senior-developer
---

# Testing Pitfalls

A catalog of testing mistakes that turn test suites from safety nets into
maintenance nightmares — or worse, into false confidence machines that
green-light broken code for production.

---

## 1. Testing the Wrong Things

### Testing Implementation Details

```python
# BAD: Testing HOW it works (implementation)
def test_sort_uses_quicksort():
    sorter = Sorter()
    sorter.sort([3, 1, 2])
    assert sorter._algorithm_used == "quicksort"
    assert sorter._partition_count == 2

# GOOD: Testing WHAT it produces (behavior)
def test_sort_returns_elements_in_ascending_order():
    assert Sorter().sort([3, 1, 2]) == [1, 2, 3]

def test_sort_handles_empty_list():
    assert Sorter().sort([]) == []
```

When you test implementation details, every refactor breaks tests even when
behavior is preserved. Developers stop trusting tests and start ignoring failures.

### Testing Getters/Setters and Framework Code

```java
// POINTLESS: You are testing the language, not your code
@Test void testGetName() {
    user.setName("Alice");
    assertEquals("Alice", user.getName()); // Will never fail unless Java is broken
}

// WORTHWHILE: Test behavior that uses those properties
@Test void testDisplayNameFallsBackToEmail() {
    user.setName(null);
    user.setEmail("alice@example.com");
    assertEquals("alice@example.com", user.getDisplayName());
}
```

Same principle applies to framework tests — don't test that Express returns 200
when you tell it to return 200. Test YOUR logic inside the framework.

### The 100% Coverage Myth

```
Coverage measures lines EXECUTED, not behavior VERIFIED.

    def divide(a, b):
        return a / b

    def test_divide():
        divide(10, 2)  # 100% coverage! No assertion. No edge cases. Zero value.

Coverage is a NEGATIVE indicator:
  - Low coverage (< 50%) = definitely under-tested
  - High coverage (> 90%) = might still be poorly tested

Better metrics: mutation testing score, branch coverage, defect escape rate.
```

---

## 2. Flaky Tests

### The Flaky Test Taxonomy

| Type | Cause | Fix |
|------|-------|-----|
| **Timing** | Assumes operation completes in X ms | Use polling/await with timeout, not `sleep()` |
| **Shared State** | Test A modifies state Test B reads | Isolate state per test; transactions + rollback |
| **External Dep** | Calls real network service | Mock external services; contract tests separately |
| **Non-deterministic** | UUIDs, timestamps in assertions | Assert structure not values; freeze time |
| **Order-dependent** | Tests must run in specific sequence | Each test sets up its own data |
| **Resource leak** | Doesn't close connections/files | Use cleanup hooks (afterEach/tearDown) |
| **Race condition** | Multi-threaded timing assumptions | Synchronization primitives; await completion |

### Timing Flakiness — The #1 Offender

```javascript
// FLAKY: Fixed sleep assumes operation takes < 500ms
test('message is delivered', async () => {
    sendMessage('hello');
    await sleep(500);
    expect(inbox.messages).toContain('hello');
});

// SOLID: Poll with timeout — works on slow CI, fails fast on quick machines
test('message is delivered', async () => {
    sendMessage('hello');
    await waitFor(() => {
        expect(inbox.messages).toContain('hello');
    }, { timeout: 5000, interval: 100 });
});
```

### Shared State — The Silent Killer

```python
# FLAKY: Tests share database state
class TestUserService:
    def test_create_user(self):
        service.create_user("alice@test.com")
        assert service.count_users() == 1  # Fails if another test created users

# SOLID: Each test gets clean state
class TestUserService:
    def setup_method(self):
        self.db = create_test_database()
        self.service = UserService(self.db)

    def teardown_method(self):
        self.db.drop()
```

### The Flaky Test Protocol

```
1. QUARANTINE immediately — move to "flaky" suite, don't block CI
2. DIAGNOSE — run 100x in a loop, collect failure patterns
3. FIX the root cause (not the symptom — no retry logic, no longer sleeps)
4. RETURN to main suite only after 100/100 passes
5. TRACK flaky rate: >5% = losing trust, >15% = failures are ignored
```

---

## 3. Over-Mocking

### When Mocking Goes Wrong

```python
# Mock setup is longer than the test — a red flag
def test_process_order(self):
    mock_db = Mock()
    mock_db.find_user.return_value = User(id=1, name="Alice")
    mock_db.find_product.return_value = Product(id=2, price=10.0)
    mock_db.save_order.return_value = Order(id=3)
    mock_payment = Mock()
    mock_payment.charge.return_value = PaymentResult(success=True)
    mock_email, mock_inventory, mock_tax, mock_shipping = Mock(), Mock(), Mock(), Mock()
    mock_inventory.check_stock.return_value = True

    service = OrderService(mock_db, mock_payment, mock_email,
                          mock_inventory, mock_tax, mock_shipping)
    result = service.process_order(user_id=1, product_id=2, quantity=1)
    assert result.success
    # What did we test? That our mocks return what we told them to.
```

### Testing Mocks Instead of Code

```python
# BAD: Verifies mock calls, not outcomes
def test_order_processing():
    mock_payment = Mock()
    OrderService(payment=mock_payment).process(order)
    mock_payment.charge.assert_called_once_with(order.total)
    # If charge() is renamed, this FAILS even though the system works.

# GOOD: Test observable outcomes via fakes
def test_order_processing():
    fake_payment = FakePaymentGateway()
    result = OrderService(payment=fake_payment).process(order)
    assert result.status == "paid"
    assert fake_payment.total_charged == order.total
```

### The Mocking Guideline

```
- Own code with no I/O: Use real objects (no mocking needed)
- Own code with fast I/O: Use in-memory implementations (fakes)
- External services: Mock at the boundary, use contract tests
- Databases: Real DB for integration tests, in-memory for unit
- Time/randomness: Always mock (inject clock/random source)

Signs of over-mocking:
  - Mock setup > 10 lines -> class has too many dependencies
  - Mocking concrete classes -> testing implementation, not contracts
  - Renaming internal method breaks 50 tests -> coupled to internals
  - Tests pass but production fails -> mocks don't match reality
```

---

## 4. Missing Test Levels

### What Each Level Catches

| Level | Catches | Misses | Speed |
|-------|---------|--------|-------|
| **Static Analysis** | Type errors, unused vars | Everything else | Instant |
| **Unit Tests** | Logic errors in isolation | Integration bugs, config | ms/test |
| **Integration Tests** | Wiring, API contracts, DB queries | UI, real infra problems | 100ms-5s/test |
| **E2E Tests** | User-visible bugs, full workflows | Internal state, edge cases | 10-60s/test |
| **Contract Tests** | API compatibility between services | Internal logic | ms-100ms/test |

### The Integration Test Gap

```
The most common gap:
  Unit tests:   "Each function works in isolation."      PASS
  E2E tests:    "The whole system works end-to-end."     TOO SLOW / FLAKY
  Integration:  [nothing]

What's missing: Does the service talk to the DB correctly? Does the API
parse request bodies? Does the cache invalidate on writes? Do two services
agree on message format?

These bugs reach production because units pass in isolation and E2E tests
are too coarse to catch specific wiring failures.
```

### Contract Testing

```javascript
// Service A sends:    { "userId": 123, "amount": "10.50" }
// Service B expects:  { "userId": 123, "amount": 10.50 }
// Bug: string vs number. Unit tests for BOTH pass. Production fails.

// FIX: Both services test against the SAME schema
test('order event matches schema', () => {
    expect(createOrderEvent(order)).toMatchSchema(ORDER_EVENT_SCHEMA);
});
test('can parse order event from schema', () => {
    expect(() => parseOrderEvent(generateFromSchema(ORDER_EVENT_SCHEMA))).not.toThrow();
});
```

---

## 5. Test Data Mistakes

### Hardcoded Data and Magic Numbers

```python
# BAD: Where did 142.49 come from?
def test_calculate_tax():
    assert calculate_tax(1499.99, "CA", "electronics") == 142.49

# GOOD: Math is auditable
def test_calculate_tax():
    price = Decimal("1499.99")
    rate = Decimal("0.095")  # 9.5% CA electronics rate
    expected = (price * rate).quantize(Decimal("0.01"))
    assert calculate_tax(price, state="CA", category="electronics") == expected
```

### Shared Test Database Chaos

```
10:01  Dev A creates user "test@test.com"
10:02  Dev B creates "test@test.com" -> UNIQUE VIOLATION
10:03  Dev A's cleanup deletes all users
10:03  Dev B's lookup -> NOT FOUND

Solutions:
1. Transaction rollback per test (fast, clean)
2. Unique data per run: f"user-{uuid4()}@test.com" (no collisions)
3. Containerized DB per CI job (most reliable)
4. In-memory DB for unit tests (fastest, may have dialect diffs)
```

### Fixture Hell vs. Factory Functions

```python
# BAD: Deeply nested fixtures that mutate shared objects
@pytest.fixture
def admin_user(base_user):
    base_user.role = "admin"  # MUTATES shared fixture
    return base_user

# GOOD: Factory functions — each test builds exactly what it needs
def make_user(**overrides):
    defaults = {"name": "Test", "email": "test@test.com", "role": "user"}
    return User(**{**defaults, **overrides})

def test_admin_can_delete():
    assert make_user(role="admin").can_delete(make_user(email="other@test.com"))
```

### Missing Edge Cases

| Category | Test Cases |
|----------|-----------|
| Empty/zero | `[]`, `""`, `0`, `None`, `{}` |
| Boundaries | MAX_INT, MIN_INT, 0, -1, max length |
| Unicode | Emojis, RTL text, null bytes, BOM |
| Whitespace | Leading, trailing, only spaces, tabs |
| Injection | `<script>`, `' OR 1=1`, `../../../etc/passwd` |
| Type confusion | `"123"` vs `123`, `"true"` vs `true`, `"null"` vs `null` |
| Time zones | UTC, local, DST boundaries, epoch 0 |
| Scale | 10x expected max, memory limits |

The edge case you skip is the edge case that breaks in production.

---

## 6. Test Organization

### Unclear Test Names

```python
# BAD: What does this verify?
def test_user():        # What about user?
def test_error():       # Which error?
def test_bug_fix():     # Which bug?

# GOOD: Names that explain scenario + expected outcome
def test_expired_user_cannot_access_premium_content():
def test_zero_quantity_raises_validation_error():
def test_regression_4523_duplicate_charge_on_timeout():
# Pattern: test_[scenario]_[expected_outcome]
```

### Arrange-Act-Assert (AAA)

```python
# BAD: Assertions interleaved with actions (5 tests in one)
def test_shopping_cart():
    cart = Cart()
    cart.add(Product("A", 10))
    assert cart.total == 10
    cart.add(Product("B", 20))
    assert cart.total == 30
    cart.apply_discount(0.1)
    assert cart.total == 27

# GOOD: One scenario, one assertion group
def test_cart_total_reflects_added_items():
    cart = Cart()                              # ARRANGE
    cart.add(Product("A", 10))                 # ACT
    cart.add(Product("B", 20))
    assert cart.total == 30                    # ASSERT
    assert cart.item_count == 2
```

### File Organization and Setup Bloat

```
ANTI-PATTERN: Mirror source structure -> one 2000-line test file per service

BETTER: Organize by behavior
  tests/user/test_registration.py
  tests/user/test_authentication.py
  tests/user/test_permissions.py
  tests/orders/test_creation.py
  tests/orders/test_payment.py

SETUP BLOAT FIX: Use factory helpers instead of monolithic setUp()

  # Instead of 50-line setUp creating everything:
  def make_order(self, **overrides):
      defaults = {"user": make_user(), "items": [make_item()]}
      return OrderService(**{**defaults, **overrides})

  def test_empty_order_rejected(self):
      service = self.make_order(items=[])
      assert service.process().error == "Order must have at least one item"
```

---

## 7. Performance Testing Gaps

### No Load Testing Before Launch

```
Dev:   10 users, 100 records    -> "Ship it!"
Prod:  5000 users, 500K records -> Database melts.

Minimum load test checklist:
[ ] API endpoints at expected concurrent users
[ ] DB queries at expected data volume
[ ] Memory usage under sustained load
[ ] Error rate at peak traffic
[ ] Recovery after overload
```

### Wrong Baselines and P99 Latency

```
Baseline mistakes:
  - Testing against empty DB (real DBs have millions of rows)
  - Testing from localhost (real latency is 50-200ms)
  - Testing with single user (concurrency causes contention)
  - Testing best case only (real traffic is mixed and bursty)

Why P99 matters more than average:
  1M requests/day, P99 = 2s -> 10,000 users wait 2+ seconds DAILY
  At 20 requests/page load -> every user hits a slow request every 5 pages

  Common P99 killers: GC pauses, connection pool exhaustion, cache misses,
  lock contention, external timeouts, DNS hiccups.

  Fix P99 before optimizing P50.
```

### Not Testing with Realistic Data

```python
# Test: {"name": "John", "email": "john@test.com"}  (4-char name, simple ASCII)
# Real: {"name": "Konstantinos Papadimitriou-Alexandros",
#        "email": "user+tag@subdomain.example.co.uk"}

# Test list: 10 items
# Real list: 10,000,000 items (that O(n^2) hurts now)

# RULE: Test with 10x expected production size.
```

---

## 8. CI Testing Failures

### Slow Test Suites Blocking Deploys

```
The slow CI death spiral:
  45-min suite -> devs batch into bigger PRs -> harder reviews ->
  more bugs -> more tests -> 60-min suite -> devs skip local tests ->
  CI queue backs up -> 3-hour deploy cycles -> ship once/day not 10x

Speed targets:
  Unit: < 5 min | Integration: < 15 min | E2E: < 30 min | Full: < 30 min
```

### Test Parallelization Strategies

```
Level 1: Parallelize test files (pytest-xdist, Jest --workers)
Level 2: Parallel CI jobs for unit/integration/E2E
Level 3: Selective execution (only tests affected by changed files)
Level 4: Test impact analysis (coverage mapping to source files)

Pipeline: Lint + Security (fast fail) -> Unit -> Integration || E2E -> Deploy
```

### Missing Reports and Failure Analysis

```
Every CI pipeline should report:
  1. Pass/fail summary with duration
  2. Failure details: name, file, line, assertion, stack trace
  3. Flaky test tracking (failed-then-passed on retry)
  4. Coverage delta per PR
  5. Suite duration trend over 30 days

When a test fails:
  Step 1: Flaky? (passes on re-run -> quarantine + ticket)
  Step 2: Environment-specific? (passes locally -> fix isolation)
  Step 3: Real regression? (passed on base branch -> PR has a bug)
  Step 4: Test wrong? (outdated assertion -> update with justification)

  NEVER: comment out failing tests, retry-until-pass, disable "always fails"
```

### Test Quality Metrics

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Pipeline duration | < 15 min | < 30 min | > 30 min |
| Flaky test rate | < 1% | < 5% | > 5% |
| Defect escape rate | < 5% | < 15% | > 15% |
| Coverage trend | Stable/up | Dropping | Dropping fast |
| Time to fix red CI | < 1 hour | < 4 hours | > 1 day |
| Tests per feature | > 5 | 1-5 | 0 |
| Build success rate | > 95% | > 85% | < 85% |

If three or more metrics are in "Warning," stop feature work and invest
a sprint in test infrastructure.

---

## Gal's Application: 10 Daily Rules

```
1. TEST BEHAVIOR, NOT IMPLEMENTATION
   If a refactor breaks your tests but not your code, your tests
   are wrong. Tests should verify WHAT the code does, not HOW.

2. KILL FLAKY TESTS ON SIGHT
   A flaky test is worse than no test. It trains the team to
   ignore failures. Quarantine immediately, fix the root cause,
   never just add a retry.

3. MOCK THE BOUNDARY, NOT THE INTERNALS
   Mock external services, databases at the edge, and time/randomness.
   Your own classes? Use the real thing. If you can't, the design
   needs work, not more mocks.

4. NAME TESTS LIKE BUG REPORTS
   "test_user" tells you nothing at 2 AM. Use the pattern
   test_[scenario]_[expected_outcome] so failures self-document.

5. ASK "WHAT ABOUT 10x THE DATA?"
   Every list, search, query, and report — what happens when the
   data is 10 times bigger than today? If you haven't tested it,
   launch day will test it for you.

6. KEEP THE PIPELINE UNDER 30 MINUTES
   If CI takes longer, developers stop waiting. If they stop
   waiting, they stop caring about test results. Speed is a
   quality metric.

7. EVERY BUG GETS A REGRESSION TEST
   Before fixing a bug, write a test that reproduces it. Then
   fix the bug. The test ensures it never comes back.

8. CLEAN UP TEST DATA RELIGIOUSLY
   Every test creates its own state and destroys it after.
   Shared test state is shared suffering. Use transactions,
   factories, and teardown hooks.

9. CHECK ALL TEST LEVELS
   Unit tests alone miss wiring bugs. Integration tests alone
   miss logic bugs. E2E tests alone are too slow and flaky.
   You need all three. Check that all three exist.

10. READ THE FAILED TEST OUTPUT
    Do not re-run hoping it passes. Do not disable it. Read the
    output. Understand the failure. Fix the cause. A red test is
    a gift — it found a problem before users did.
```
