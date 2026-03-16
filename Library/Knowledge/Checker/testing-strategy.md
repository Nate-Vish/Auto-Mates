# Testing Strategy: Pyramid, Frameworks & Regression

**When to use:** Reviewing test suite structure, setting up test frameworks, evaluating test coverage quality, or ensuring bug fixes have regression tests.

---

## The Testing Pyramid

```
         /\
        /  \    Few: End-to-End Tests (slow, expensive, brittle)
       /    \
      /------\
     /        \   Some: Integration + Contract Tests
    /          \
   /------------\
  /              \  Many: Unit Tests (fast, cheap, reliable)
 /________________\
```

**Principle:** Write many small fast unit tests. Some integration tests. Very few high-level E2E tests.

---

## Each Layer Defined

### Unit Tests (Foundation — MANY)
- Test individual functions/classes in isolation
- Execute in milliseconds (thousands in minutes)
- Use mocks/stubs for external dependencies only
- Follow "arrange, act, assert" pattern
- Test observable **BEHAVIOR**, not implementation details
- Skip trivial code (getters, setters)
- If you need to test a private method, extract it to its own class

### Integration Tests (Middle — SOME)
- Test ONE external integration at a time (DB, API, filesystem)
- Use test doubles (WireMock for HTTP, in-memory DB for storage)
- Slower than unit tests but catch real integration bugs
- Do not duplicate what unit tests already cover

### Contract Tests (Cross-Service)
- Consumer defines expectations via automated tests
- Provider verifies it satisfies all consumer contracts
- Enables autonomous team development with confidence
- Use Pact or similar tools

### End-to-End Tests (Apex — FEW)
- Test complete user workflows through the deployed system
- High maintenance, often flaky
- Only test core user journeys (login → key action → outcome)
- Lower-level tests should already cover edge cases

---

## Anti-Patterns

### Test Ice-Cream Cone
Mostly E2E tests with few unit tests = slow, brittle, expensive. If you see this on a project, **invert it.**

### Test Duplication
If a unit test already covers a case, don't also test it in integration. Push tests DOWN the pyramid.

### Testing Implementation Details
Tests coupled to internal structure break on refactoring. Test behavior, not internals.

---

## Checker's Test Suite Review

When reviewing a test suite:
1. Count tests per level — does it look like a pyramid or an ice cream cone?
2. Are unit tests testing behavior or internal implementation?
3. Are integration tests testing ONE integration point each?
4. Are E2E tests limited to critical paths only?
5. Is the test framework appropriate for the stack?
6. Can all tests be run with a single command?
7. Do tests clean up after themselves (no state leaking between tests)?
8. Are mocks used appropriately (not mocking the thing being tested)?

---

## Regression Testing Rule

**Every bug fix MUST include a regression test. No exceptions.**

The workflow:
```
Bug reported
    |
    v
Write test that REPRODUCES the bug (it must FAIL first)
    |
    v
Verify test fails (confirms the test is valid)
    |
    v
Fix the bug
    |
    v
Verify test now passes (confirms the fix works)
    |
    v
Commit test + fix together
    |
    v
Test runs in CI forever (permanent guard against regression)
```

### Regression Best Practices
1. **Name tests after the bug:** `test_fix_issue_123_null_pointer_on_empty_list`
2. **Test the exact scenario:** Don't generalize. Test the specific input that caused the bug.
3. **Include in CI:** Must run on every PR, not just nightly.
4. **Never delete:** Regression tests are permanent guards. Deleting them removes the protection.
5. **Group by feature:** Keep regression tests alongside the feature code they protect.

### Checker's Regression Audit (for bug fixes)
- [ ] Is there a test that reproduces the original bug?
- [ ] Does the test FAIL without the fix? (verify it is not a false pass)
- [ ] Does the test PASS with the fix?
- [ ] Is the test in CI? Will it run on every commit?
- [ ] Is the ROOT CAUSE fixed, not just the symptom?

---

## Framework Quick Reference

### JavaScript/TypeScript

**Vitest (preferred for Vite projects):**
```js
import { describe, it, expect, vi } from 'vitest'

describe('myFunction', () => {
  it('handles valid input', () => {
    expect(myFunction('hello')).toBe('HELLO')
  })

  it('throws on null input', () => {
    expect(() => myFunction(null)).toThrow('Input required')
  })

  it('calls external service', () => {
    const mockService = vi.fn().mockResolvedValue({ data: 'ok' })
    // test with mock
  })
})
```
Run: `npx vitest` or `npx vitest run` (CI mode)

**Jest:** Same syntax as Vitest. Run: `npx jest`

### Python

**Pytest:**
```python
import pytest

def test_valid_input():
    assert my_function("hello") == "HELLO"

def test_null_input():
    with pytest.raises(ValueError, match="Input required"):
        my_function(None)

@pytest.fixture
def mock_service(mocker):
    return mocker.patch("module.service", return_value={"data": "ok"})
```
Run: `pytest` or `pytest -v`

### Shell Scripts

**BATS (Bash Automated Testing System):**
```bash
@test "script exits 0 on valid input" {
  run ./myscript.sh valid
  [ "$status" -eq 0 ]
}

@test "script fails on missing arg" {
  run ./myscript.sh
  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage:"* ]]
}
```
Run: `bats tests/`

---

Deep-dive sources can be regenerated by Fetcher — run `/fetcher` with a knowledge request.
