---
title: "AI-Assisted Development Pitfalls"
category: "AI & Development Practices"
tags:
  - ai-development
  - code-generation
  - llm-pitfalls
  - code-review
  - security
  - testing
  - developer-productivity
  - team-dynamics
  - trust-calibration
source_type: professional-knowledge
audience: senior-developers
---

# AI-Assisted Development Pitfalls

AI code generation is the fastest way to write bugs you don't understand.

That's not anti-AI. I use AI tools every day. But I've also spent months watching
teams adopt AI assistants and repeat the same mistakes. The tool isn't the problem.
The problem is how people use it -- and more importantly, what they stop doing
once the tool is available.

This file is a catalog of every pitfall I've seen, with concrete detection
strategies and fixes.

---

## 1. Over-Reliance on AI

The most dangerous failure mode isn't that AI generates bad code. It's that
developers stop thinking critically because they assume the AI already did.

### The Over-Reliance Spectrum

```
HEALTHY                                                    DANGEROUS
   |                                                          |
   v                                                          v
AI suggests,         AI drafts,         AI generates,      AI generates,
human decides        human reviews      human skims        human ships
and understands      and modifies       and approves       without reading
```

### Cargo Cult Prompting

| Anti-Pattern | What It Looks Like | The Reality |
|-------------|-------------------|-------------|
| Prompt copying | Copying prompts from Twitter/blogs without understanding them | Different contexts need different prompts |
| Magic phrase belief | "Think step by step" appended to everything | Works sometimes, not a universal fix |
| Template worship | Using the same prompt template for every task | A database migration prompt shouldn't look like a UI prompt |
| Prompt accumulation | Adding more and more instructions hoping it fixes output | More instructions often confuse, not clarify |

### Skill Atrophy Indicators

```
WARNING SIGN: Developer can't write a basic function without AI assistance.
WARNING SIGN: Developer can't explain what their own code does.
WARNING SIGN: Developer can't debug without pasting the error into AI.
WARNING SIGN: Developer defaults to "let me ask the AI" instead of
              reading documentation or source code.
WARNING SIGN: Developer's code style changes completely between AI-assisted
              and non-AI-assisted work -- suggesting they don't understand
              the AI-generated patterns.
```

### Maintaining Fundamental Skills

| Practice | Why It Matters |
|----------|---------------|
| Write some code without AI weekly | Keep your core skills sharp through regular exercise |
| Read source code of dependencies | Understanding libraries you use beats asking AI about them |
| Debug with a debugger, not just AI | Step-through debugging builds deep understanding |
| Whiteboard before prompting | If you can't explain the design, AI can't implement it correctly |
| Review AI output as if a junior wrote it | Apply the same scrutiny you'd give to an intern's code |

---

## 2. Hallucination Patterns

AI doesn't know what it doesn't know. It generates plausible text, not correct text.
Hallucinations are not bugs -- they're a fundamental property of how language models work.

### Common Hallucination Categories

| Category | Example | Detection Strategy |
|----------|---------|-------------------|
| Fake APIs | `response.data.unwrapOrThrow()` -- method doesn't exist | Check official docs for every API call |
| Non-existent methods | `list.sortedByDescending { it.date }` in a language that doesn't have it | Run the code. Read the compiler errors. |
| Plausible wrong logic | Off-by-one in loop that "looks right" at a glance | Trace through with actual test data |
| Outdated library versions | "Use `left_join` from pandas 1.3" when API has changed | Check current library docs and changelogs |
| Fabricated documentation | "According to the React docs, useEffect runs synchronously" -- it doesn't | Always verify claims against official sources |
| Invented configuration | `server.ssl.auto-renew: true` -- config key doesn't exist | Check actual config schema/documentation |
| Fake error messages | "This error means X" when the error actually means Y | Read the actual error source, not the AI's interpretation |
| Ghost dependencies | "Install `fast-xml-parser-utils`" -- package doesn't exist or is malware | Verify package exists on official registry. Check download counts. |

### The Hallucination Detection Checklist

```
For every AI-generated code block, verify:

[ ] Does this API/method actually exist? (Check official docs)
[ ] Is this the correct syntax for the language version we use?
[ ] Are the library versions compatible with our project?
[ ] Do the imports resolve to real modules?
[ ] Does this logic handle edge cases? (null, empty, overflow, negative)
[ ] Are the configuration keys real? (Check schema docs)
[ ] If it cites documentation, does that documentation actually say that?
[ ] Do the package names map to legitimate packages in the registry?
```

### Why "It Compiles" Isn't Enough

```python
# AI-generated code that compiles and runs but is WRONG:

def calculate_average(numbers):
    return sum(numbers) / len(numbers)

# Looks correct. Compiles. Runs.
# Fails on: empty list (ZeroDivisionError)
# Fails on: integer overflow with large lists in some languages
# Fails on: mixed types (strings in the list)
# The AI generated the "obvious" implementation,
# not the robust one.
```

---

## 3. AI Code Review Gaps

AI is excellent at catching syntax errors, style violations, and common patterns.
It is poor at catching problems that require understanding context, intent,
business rules, and system-wide implications.

### What AI Code Review Catches Well

| Category | Example |
|----------|---------|
| Syntax and formatting | Missing semicolons, inconsistent indentation |
| Common vulnerability patterns | SQL injection via string concatenation |
| Simple logic errors | Comparing wrong variables, off-by-one on known patterns |
| Style violations | Naming conventions, line length, import order |
| Documentation gaps | Missing docstrings, incomplete parameter descriptions |

### What AI Code Review Misses

| Category | Example | Why AI Misses It |
|----------|---------|-----------------|
| Business logic correctness | Discount applied before tax when it should be after | Requires domain knowledge AI doesn't have |
| Architecture fit | New service duplicates logic that exists elsewhere | Requires codebase-wide understanding |
| Performance at scale | O(n^2) query that works on 100 rows, dies on 1M | Requires knowing production data characteristics |
| Security edge cases | TOCTOU race condition in auth check | Requires understanding concurrent execution context |
| Organizational context | Using a library the security team banned last month | Requires org-specific knowledge |
| Data migration safety | Schema change that breaks 3 downstream consumers | Requires understanding the full data pipeline |
| Operational concerns | Change that makes debugging in production impossible | Requires on-call experience |
| Implicit requirements | Feature works but violates unwritten accessibility standard | Requires understanding user needs beyond the spec |

### The False Confidence Problem

```
DANGEROUS THOUGHT PATTERN:

"The AI reviewed it and found no issues"
        |
        v
"So the code must be correct"
        |
        v
"I don't need to review it as carefully"
        |
        v
Bug ships to production
        |
        v
"But the AI said it was fine!"

REALITY: AI approval is not a substitute for human review.
         It's a supplement. The human reviewer is still accountable.
```

---

## 4. Copy-Paste from AI

The most common AI workflow: generate code, copy it, paste it, see if it works,
ship it. This creates a codebase of code nobody understands.

### The Copy-Paste Anti-Pattern Catalog

| Anti-Pattern | What Happens | Long-Term Cost |
|-------------|-------------|----------------|
| Style inconsistency | AI uses different patterns than your codebase | Code looks like 5 different people wrote it (they didn't even) |
| Duplicate logic | AI doesn't know you already have a utility for this | Same logic in 4 places, bugs fixed in 1 |
| Over-engineering | AI adds abstractions you don't need | Complexity without benefit, harder to maintain |
| Under-engineering | AI generates the simplest thing that works | Missing error handling, no edge cases, no logging |
| Framework mismatch | AI generates Express patterns in your Fastify project | Subtle runtime issues, confused maintainers |
| Dead code | AI generates helper functions you don't actually call | Codebase grows, signal-to-noise ratio drops |

### The Understanding Test

Before committing AI-generated code, you should be able to answer:

```
1. What does every line do?
   (Not "roughly" -- exactly.)

2. Why was this approach chosen over alternatives?
   (If you can't name alternatives, you don't understand the space.)

3. What are the edge cases?
   (Empty input, null, concurrent access, failure modes.)

4. How does this integrate with the existing codebase?
   (Does it follow our patterns? Use our utilities? Match our error handling?)

5. What are the performance characteristics?
   (Time complexity, memory usage, database queries, network calls.)

6. How would you debug this if it failed in production?
   (Can you trace through it? Are there logs? Meaningful errors?)

If you can't answer all six: you're not ready to commit this code.
```

### Making AI Code Your Own

| Step | Action |
|------|--------|
| 1. Read | Read every line of generated code. Understand it. |
| 2. Adapt | Modify to match your project's patterns, naming, error handling |
| 3. Integrate | Use existing utilities instead of AI-generated duplicates |
| 4. Test | Write tests that verify YOUR requirements, not the AI's assumptions |
| 5. Document | Add comments explaining the "why" -- AI doesn't know your context |
| 6. Own | You are now the author. You maintain this code. Act accordingly. |

---

## 5. Prompt Engineering Mistakes

The quality of AI output is directly proportional to the quality of the input.
Most developers treat prompting as "just asking a question" instead of as a skill.

### The Prompt Quality Ladder

| Level | Example | Typical Output Quality |
|-------|---------|----------------------|
| Vague | "Write a function to process data" | Generic, wrong assumptions, unusable |
| Basic | "Write a Python function that takes a list of orders and returns the total" | Works for happy path, misses edge cases |
| Contextual | "Write a Python 3.11 function that takes a list of Order dataclasses (with amount: Decimal, currency: str, status: str) and returns the total in USD. Only include orders with status='completed'. We use the `money` library for currency conversion." | Much better, still may miss project conventions |
| Expert | [Above] + "Follow our error handling pattern: raise ValueError for bad input, log warnings for skipped orders. Match the style of our existing `calculate_shipping_total` in `orders/calculations.py`. Include type hints and a docstring following Google style." | Close to production-ready |

### Common Prompt Mistakes

| Mistake | Example | Fix |
|---------|---------|-----|
| No context | "Fix this bug" + code dump | Explain what the code should do, what it actually does, and the environment |
| No constraints | "Build me an API" | Specify language, framework, patterns, scale requirements |
| Asking for too much | "Build my entire application" | Break into small, specific tasks |
| Not iterating | Accept first output or give up | Refine: "That's close, but change X and handle Y" |
| Ignoring failures | AI gives wrong answer, user re-asks same way | Change your approach. Add context. Be more specific. |
| Treating AI as oracle | "What's the best database?" | AI doesn't know your constraints. Specify them, ask for tradeoffs. |
| No examples | "Format the output nicely" | Provide a concrete example of desired output |
| Ambiguous language | "Make it fast" | "Reduce response time to under 200ms for 95th percentile" |

### Effective Prompt Patterns

```
PATTERN: Role + Context + Task + Constraints + Format

EXAMPLE:
"You are reviewing a Python backend service for a fintech company.
Context: We use FastAPI, SQLAlchemy, PostgreSQL. This service handles
payment processing and must be PCI-DSS compliant.
Task: Review this function for security issues.
Constraints: Focus on SQL injection, auth bypass, and data exposure.
Format: List each issue with severity (critical/high/medium/low),
the specific line, and a concrete fix."
```

---

## 6. Security Risks

AI tools introduce security risks that most teams don't consider until it's too late.

### AI-Suggested Vulnerable Patterns

| Vulnerability | How AI Introduces It | Example |
|-------------|---------------------|---------|
| SQL injection | AI generates string interpolation for queries | `f"SELECT * FROM users WHERE id = {user_id}"` |
| XSS | AI generates innerHTML without sanitization | `element.innerHTML = userInput` |
| Hardcoded secrets | AI generates example code with placeholder creds left in | `password = "admin123"` in config |
| Insecure deserialization | AI uses `pickle.loads()` or `eval()` for parsing | `data = pickle.loads(request.body)` |
| Path traversal | AI generates file operations without path validation | `open(f"/uploads/{filename}")` where filename is user input |
| Weak crypto | AI suggests outdated algorithms from training data | `hashlib.md5(password)` for password hashing |
| SSRF | AI generates URL fetching without validation | `requests.get(user_provided_url)` from server |
| Missing auth checks | AI generates endpoints without middleware | Route handler with no authentication decorator |

### Data Exposure Risks

```
RISK: Sending proprietary code to AI services

WHAT YOU'RE SENDING:
- Business logic that reveals competitive advantages
- Internal API structures
- Database schemas with field names revealing data model
- Security configurations
- Customer data patterns
- Infrastructure details

QUESTIONS TO ASK:
- Does the AI provider use our data for training?
- Where is the data processed? (jurisdiction matters)
- Is the data encrypted in transit and at rest?
- Can employees of the AI provider access our prompts?
- What's the data retention policy?
- Does this violate any customer data agreements?
```

### AI-Generated Configuration Dangers

| Config Type | Common AI Mistake | Consequence |
|------------|------------------|-------------|
| CORS | `Access-Control-Allow-Origin: *` | Any website can make requests to your API |
| Database | `sslmode=disable` for "simplicity" | Database traffic unencrypted |
| Auth | JWT with `none` algorithm | Authentication bypass |
| Firewall | Overly permissive rules for "development" | Exposed internal services |
| Logging | Logging request bodies that contain PII | Compliance violation |
| Docker | Running as root, latest tags | Security vulnerabilities, non-reproducible builds |

### Security Review Checklist for AI-Generated Code

```
[ ] No hardcoded credentials, tokens, or secrets
[ ] All user input is validated and sanitized
[ ] Database queries use parameterized statements
[ ] Authentication and authorization on every endpoint
[ ] Cryptographic functions use current best practices
[ ] File operations validate paths against traversal
[ ] HTTP clients validate URLs against SSRF
[ ] Error messages don't leak internal details
[ ] Dependencies are pinned to specific versions
[ ] Configuration doesn't disable security features
```

---

## 7. Testing with AI

AI-generated tests are often worse than no tests because they create false confidence.
A passing test suite that doesn't actually verify behavior is a liability.

### AI-Generated Test Anti-Patterns

| Anti-Pattern | Example | Why It's Harmful |
|-------------|---------|-----------------|
| Testing the mock | Test mocks the database, asserts mock returns what it was told to return | Proves nothing about actual behavior |
| Tautological tests | `assert calculate(2,3) == calculate(2,3)` | Passes regardless of correctness |
| Implementation testing | Tests break when refactoring even though behavior is unchanged | Discourages improvement, creates maintenance burden |
| Happy path only | Tests pass with valid input, no edge case coverage | Bugs live in edge cases, not happy paths |
| Snapshot worship | Snapshot test of entire component output, approved without reading | Any change breaks the test, real bugs hidden in noise |
| Over-mocking | Everything mocked, testing a shell of the actual system | Integration points are where bugs live |
| AI tests AI code | AI generates code, then AI generates tests for that code | Same blind spots in both. Bugs confirmed, not caught. |
| Copy-paste test names | `test_function_works`, `test_function_works_2` | No one knows what's being tested or why |

### Tests That Actually Verify Behavior

```python
# BAD: AI-generated test that tests nothing useful
def test_create_user():
    mock_db = Mock()
    mock_db.save.return_value = True
    service = UserService(mock_db)
    result = service.create_user("test@test.com")
    mock_db.save.assert_called_once()  # Only tests that save was called
    # NEVER tests: Was the user object correct? Was the email validated?
    # Was the password hashed? Was a duplicate check done?

# GOOD: Test that verifies actual behavior
def test_create_user_hashes_password():
    db = InMemoryUserDatabase()
    service = UserService(db)
    service.create_user("test@test.com", password="plain123")
    saved_user = db.find_by_email("test@test.com")
    assert saved_user is not None
    assert saved_user.password != "plain123"  # Password was hashed
    assert verify_hash("plain123", saved_user.password)  # Hash is correct

def test_create_user_rejects_duplicate_email():
    db = InMemoryUserDatabase()
    service = UserService(db)
    service.create_user("test@test.com", password="pass1")
    with pytest.raises(DuplicateEmailError):
        service.create_user("test@test.com", password="pass2")

def test_create_user_validates_email_format():
    db = InMemoryUserDatabase()
    service = UserService(db)
    with pytest.raises(InvalidEmailError):
        service.create_user("not-an-email", password="pass1")
```

### The Test Quality Checklist

```
For every AI-generated test, ask:

[ ] If the function under test had a bug, would this test catch it?
[ ] Does this test verify behavior or implementation?
[ ] What happens if I change the implementation but keep the behavior?
[ ] Are the assertions testing the right thing?
[ ] Is the test name descriptive of the scenario being tested?
[ ] Are edge cases covered? (null, empty, boundary, error, concurrent)
[ ] Does this test use realistic data, not trivial examples?
[ ] If all tests pass, am I confident the feature works correctly?
```

---

## 8. When AI Makes Things Worse

The assumption that AI always improves productivity is contradicted by research
and real-world experience.

### Research Findings

| Study | Finding | Key Insight |
|-------|---------|-------------|
| METR 2025 | Experienced developers 19% SLOWER with AI tools on real-world tasks | AI helped with easy parts but slowed down integration and debugging |
| JetBrains 2024 | AI-assisted code had 1.7x more bugs on average | Speed of generation doesn't equal quality of output |
| GitClear 2024 | "Moved" and "copy-pasted" code increased 2x with AI adoption | AI encourages duplication over reuse |
| Microsoft Research | Developers spent 50% of AI interaction time on prompt engineering | Time "saved" often consumed by prompt iteration |

### When AI Makes Things Worse: Pattern Recognition

```
PATTERN: Easy to Generate, Hard to Integrate

AI generates a perfect sorting algorithm in isolation.
But integrating it into your existing data pipeline requires
understanding 6 other systems, 3 data formats, and 2 edge
cases specific to your business. The generation was 30 seconds.
The integration is 3 hours. Without AI, you would have spent
45 minutes writing code that fits naturally.

NET RESULT: Slower, with code that doesn't quite fit.
```

```
PATTERN: Debug the AI's Code vs Write Your Own

AI generates 200 lines of code. It mostly works but has a
subtle bug. You spend 2 hours debugging code you didn't write
and don't fully understand. If you'd written it yourself,
you'd have written 150 lines in 1 hour with no bugs because
you understood every line.

NET RESULT: More time, less understanding, more fragile code.
```

```
PATTERN: The Complexity Ratchet

AI makes it easy to add features. So you add more features.
Each AI-generated feature adds complexity. Complexity compounds.
Soon the codebase is too complex for either the AI or the humans
to manage effectively.

NET RESULT: Faster feature velocity, slower overall velocity.
```

### The Productivity Illusion

| Metric | Looks Like AI Helps | Actually... |
|--------|-------------------|-------------|
| Lines of code | 3x more lines produced | Lines of code is not a productivity metric |
| PRs per week | 2x more PRs opened | PR volume doesn't equal value delivered |
| Time to first commit | 50% faster | First commit is easy; getting to production-ready is hard |
| Code completion acceptance | 30% of suggestions accepted | 30% acceptance means 70% was wrong or irrelevant |
| Features shipped | More features per sprint | More features + more bugs = more maintenance debt |

---

## 9. Team Dynamics with AI

AI tools change how teams work together, and not always for the better.

### Skill Atrophy in Junior Developers

```
THE CONCERN:

Before AI: Junior writes code -> struggles -> learns -> grows
After AI:  Junior prompts AI -> gets code -> ships -> learns nothing

Junior developers who use AI as a crutch skip the struggle that
builds fundamental understanding. They can produce code but they
can't debug it, optimize it, or explain it.

THE FIX:

1. Require AI-free coding for learning exercises
2. Ask juniors to explain AI-generated code line by line
3. Code review should assess UNDERSTANDING, not just correctness
4. Pair programming where the junior drives, not the AI
5. Gradually increase AI use as fundamentals solidify
```

### Code Review Fatigue for AI-Generated PRs

| Problem | Why It Happens | Fix |
|---------|---------------|-----|
| Volume overwhelm | AI generates code 3x faster, review queue grows 3x | Rate-limit AI PRs. Quality over quantity. |
| Pattern unfamiliarity | AI uses patterns the team doesn't normally use | Require AI-generated code to match team conventions |
| Trust calibration failure | Reviewer assumes "AI is probably right" and skims | Treat AI PRs with MORE scrutiny, not less |
| Bulk PRs | "AI wrote the whole feature in one shot" -- 2000 line PR | AI-generated code follows the same PR size rules as human code |
| Inconsistent quality | Some AI output is excellent, some is terrible | Every line needs review regardless of source |

### The "AI Wrote It" Accountability Gap

```
SCENARIO:
  Developer ships AI-generated code. Bug found in production.
  Developer says: "The AI generated that, not me."

REALITY:
  The developer who commits code is responsible for that code.
  "The AI wrote it" is not a defense. It's an admission that
  you shipped code you didn't understand.

  There is no practical difference between:
  - Code you wrote with a bug
  - Code a junior wrote that you reviewed and approved
  - Code AI generated that you committed

  In all three cases, the person who committed/approved is accountable.

TEAM RULE:
  If your name is on the commit, you own the code.
  Full stop. Regardless of origin.
```

### Healthy AI Team Norms

| Norm | Rationale |
|------|-----------|
| AI use is transparent | Mark AI-generated code in PR descriptions so reviewers calibrate |
| AI doesn't bypass process | Same PR size limits, same review requirements, same testing standards |
| Understanding is required | You must be able to explain any code you commit, AI-generated or not |
| Juniors learn fundamentals first | AI is a tool for the experienced, not a shortcut for beginners |
| AI output is a draft, not a final product | Always review, adapt, and integrate before committing |
| Track AI effectiveness honestly | Measure bugs, not just velocity. Measure understanding, not just output. |

---

## 10. Trust Calibration

The core skill of AI-assisted development isn't prompting. It's knowing
when to trust the output and when to verify.

### The Trust Matrix

| Confidence Level | AI Task Type | Verification Required |
|-----------------|-------------|----------------------|
| High trust | Boilerplate, formatting, simple transformations | Quick scan |
| Medium trust | Algorithm implementation, API usage, test generation | Line-by-line review, run tests |
| Low trust | Security-sensitive code, business logic, infrastructure | Full manual review + independent testing |
| No trust | Legal compliance, cryptography, medical/financial calculations | Human expert writes it, AI assists at most |

### Verification Strategies

| Strategy | When to Use | How |
|----------|------------|-----|
| Compile and run | Always | Minimum bar. If it doesn't run, don't even start reviewing |
| Read every line | Any code you'll commit | No exceptions. If you can't read it, you can't commit it |
| Test with edge cases | Logic and algorithms | Empty, null, negative, overflow, concurrent, malformed |
| Check against docs | API usage, library calls | Verify every method, parameter, and return type |
| Run security scanner | Any code handling user input | SAST tools catch what eyes miss |
| Benchmark | Performance-sensitive code | Don't trust "this is fast" -- measure it |
| Peer review | Complex or critical code | Another human who understands the domain |
| Compare alternatives | Architecture decisions | Don't accept the first suggestion. Ask for 3 approaches. |

### The Human-in-the-Loop Pattern

```
WRONG: Human -> Prompt -> AI Output -> Production

RIGHT: Human -> Prompt -> AI Output -> Human Review
                                       -> Human Testing
                                       -> Human Adaptation
                                       -> Peer Review
                                       -> Production

The AI is a tool in the middle of a human process.
It never replaces the beginning (understanding the problem)
or the end (verifying the solution).
```

### When to Stop Using AI and Write It Yourself

```
STOP USING AI WHEN:

1. You've prompted 3+ times and the output is still wrong.
   You clearly understand the problem better than the AI.
   Just write it.

2. The code requires deep understanding of your specific system.
   AI doesn't know your codebase. You do.
   Just write it.

3. You're debugging AI-generated code and not making progress.
   Debugging unfamiliar code is harder than writing familiar code.
   Just write it.

4. The task is security-critical or financially-critical.
   The cost of an AI error here exceeds the time saved.
   Just write it.

5. You're learning a new concept.
   AI-generated code teaches you syntax, not understanding.
   Just write it.

6. You can't explain the AI's output to a teammate.
   If you don't understand it, you can't maintain it.
   Just write it.
```

### Knowing Your Limits vs AI's Limits

| Your Limits (Accept Help) | AI's Limits (Don't Rely) |
|--------------------------|-------------------------|
| You forgot the syntax for regex | AI doesn't know your business rules |
| You need boilerplate you've written 100 times | AI doesn't understand your production environment |
| You want a starting point for an unfamiliar API | AI doesn't know about last week's incident |
| You need to convert between data formats | AI can't reason about concurrent system behavior |
| You want to explore approaches to a problem | AI doesn't understand organizational constraints |
| You need to refactor repetitive code | AI can't evaluate long-term maintenance cost |

---

## Gal's Application: 10 Daily Rules

These are the rules I apply every single day when reviewing AI-assisted work.
Learned from watching teams stumble through the same mistakes over and over.

```
RULE 1: IF YOU CAN'T EXPLAIN IT, DON'T COMMIT IT
        Line by line. If someone asks "why does this work?"
        and your answer is "the AI wrote it," that code doesn't ship.

RULE 2: AI OUTPUT IS A DRAFT, NEVER A FINAL PRODUCT
        I treat every AI-generated code block as a first draft from
        a junior developer. Review it with that level of scrutiny.

RULE 3: VERIFY EVERY API CALL AGAINST OFFICIAL DOCS
        AI hallucinates methods, parameters, and behaviors constantly.
        I check official documentation for every unfamiliar API usage.

RULE 4: AI-GENERATED TESTS PROVE NOTHING UNTIL PROVEN USEFUL
        I mutation-test AI-generated test suites. If mutating the code
        under test doesn't fail the tests, the tests are theater.

RULE 5: SAME STANDARDS REGARDLESS OF ORIGIN
        AI-generated PRs get the same review rigor, the same size limits,
        and the same testing requirements as human-written code. No exceptions.

RULE 6: SECURITY CODE IS HUMAN-WRITTEN
        Authentication, authorization, cryptography, input validation --
        a human who understands the security model writes this. AI assists
        at most. I reject AI-generated security code that wasn't manually
        verified by someone who understands the threat model.

RULE 7: WATCH FOR SKILL ATROPHY
        I pay attention to whether junior developers are growing or just
        prompting. Can they debug without AI? Can they design without AI?
        If not, we adjust how AI tools are used in mentoring.

RULE 8: TRACK BUGS, NOT JUST VELOCITY
        "We shipped 3x more features" means nothing if bug reports also
        went up 3x. I push for honest measurement of AI's actual impact
        on quality, not just speed.

RULE 9: THREE STRIKES, WRITE IT YOURSELF
        If AI hasn't gotten it right in 3 attempts, the developer should
        write it manually. Continuing to prompt is wasting time and
        producing code that doesn't fit the codebase.

RULE 10: THE HUMAN IS ALWAYS ACCOUNTABLE
         "The AI wrote it" is never an excuse. The person who commits
         the code owns the code. I enforce this without exception.
         Your name on the commit means you understood, reviewed,
         tested, and approved every line.
```
