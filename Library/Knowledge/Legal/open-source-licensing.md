# Open Source Licensing & Compliance

**Deep-dive reference.** Pull this file when auditing dependencies, choosing a project license, or resolving license compatibility questions.

---

## License Families

### Permissive Licenses

Permissive licenses allow broad reuse with minimal restrictions. Code under a permissive license can be incorporated into proprietary software.

| License | Attribution | Patent Grant | Modification Notice | Copyleft | Notes |
|---------|-------------|-------------|-------------------|----------|-------|
| **MIT** | Copyright notice required | No | No | No | Simplest. Most popular on GitHub. |
| **Apache 2.0** | Copyright notice + license text | **Yes, explicit** | **Yes, must mark changes** | No | Best when patent protection matters. |
| **BSD 2-Clause** | Copyright notice + disclaimer | No | No | No | Functionally identical to MIT. |
| **BSD 3-Clause** | Copyright notice + disclaimer | No | No | No | Adds: cannot use contributor names for endorsement. |
| **ISC** | Copyright notice | No | No | No | Simplified BSD. |
| **Boost** | Copyright notice + disclaimer | No | No | No | Common in C++ ecosystem. |

### Weak Copyleft Licenses

Copyleft applies to modifications of the licensed code itself, but not to code that merely links to or uses it.

| License | Copyleft Scope | Patent Grant | Notes |
|---------|---------------|-------------|-------|
| **MPL 2.0** | File-level — modified files must stay MPL | Yes | Only the specific files you change are copyleft. New files you add are free. |
| **LGPL** | Library boundary — modifications to the library must be LGPL | No | Linking/using the library does NOT make your code LGPL. Modifying the library itself does. |
| **EPL** | Module-level | Yes | Common in Eclipse ecosystem. |

### Strong Copyleft Licenses

Copyleft applies to the entire combined work. Using copyleft code means your whole program must be released under the same license.

| License | Copyleft Scope | Trigger | Notes |
|---------|---------------|---------|-------|
| **GPL v2** | Entire program | Distribution of binary or source | The original copyleft. "Distribution" is the trigger. |
| **GPL v3** | Entire program | Distribution | Adds: anti-Tivoization, patent retaliation clause. |
| **AGPL v3** | Entire program | Distribution OR network interaction | **The SaaS trap.** If users interact with your AGPL software over a network, you must provide source. No distribution needed. |

---

## Compatibility Matrix

**The one-way rule:** Permissive code flows into copyleft projects. Copyleft code does NOT flow into permissive or proprietary projects.

| Combination | Result | Allowed? |
|-------------|--------|----------|
| MIT + MIT | MIT | Yes |
| MIT + Apache 2.0 | Apache 2.0 (or either) | Yes |
| MIT + GPL | **GPL** (entire project) | Yes, but project becomes GPL |
| Apache 2.0 + GPL v3 | **GPL v3** | Yes (Apache is GPL v3 compatible) |
| Apache 2.0 + GPL v2 | **Conflict** | No — Apache patent clause conflicts with GPL v2 |
| GPL + Proprietary | **Conflict** | No — cannot combine |
| AGPL + Proprietary | **Conflict** | No — cannot combine |
| LGPL + Proprietary | Proprietary (if only linking) | Yes, if you only link to the LGPL library |
| MPL 2.0 + Proprietary | Proprietary (for new files) | Yes, but modified MPL files stay MPL |

---

## Compliance Checklist

Run this for every release that includes third-party code:

### 1. Inventory
- [ ] List all direct dependencies and their licenses
- [ ] List all transitive dependencies and their licenses (use automated tooling)
- [ ] Identify any dependencies with no license (treat as "all rights reserved" — cannot use)

### 2. Compatibility Check
- [ ] Identify all copyleft licenses (GPL, AGPL, LGPL, MPL, EPL)
- [ ] Verify no copyleft code conflicts with the project's license
- [ ] Verify no AGPL code is present if shipping proprietary SaaS
- [ ] Check for Apache 2.0 + GPL v2 conflict

### 3. Attribution
- [ ] Include copyright notices for all dependencies in distribution
- [ ] Include full license texts where required (Apache 2.0, GPL)
- [ ] For Apache 2.0 deps: include NOTICE file if one exists
- [ ] For Apache 2.0 deps: mark any modifications made

### 4. Source Code Obligations
- [ ] If distributing GPL code: source code available or written offer included
- [ ] If using AGPL in network service: source code accessible to users
- [ ] If modifying LGPL library: modified library source available

### 5. No-License Dependencies
- [ ] Flag any dependency without an explicit license
- [ ] Contact maintainer to clarify, or replace the dependency
- [ ] "No license" means "all rights reserved" — you have no permission to use it

---

## Common Scenarios

**"Can I use this GPL library in my commercial product?"**
- If you distribute the product (binary or source): your entire product must be GPL.
- If you only use it internally (never distribute): GPL does not apply. But AGPL would.
- If the library is LGPL: you can link to it without your code becoming LGPL, but modifications to the library itself must be LGPL.

**"We're building a SaaS — does GPL apply?"**
- Standard GPL: No, because SaaS is not "distribution." You never give users a copy.
- AGPL: Yes. Network interaction triggers the same obligations as distribution.
- This is why AGPL is called "the SaaS trap."

**"A dependency has dual licensing (e.g., MIT/Apache). Which applies?"**
- You choose. Dual-license means you can pick either license. Choose the one most compatible with your project.

**"We found a dependency with no license file."**
- Legally: all rights reserved. You have no permission to use, copy, modify, or distribute.
- Practically: open an issue asking the maintainer to add a license. Replace the dependency if they don't.

---

## Tooling Recommendations

- **SPDX identifiers** — standard license notation (e.g., `MIT`, `Apache-2.0`, `GPL-3.0-only`)
- **SBOM (Software Bill of Materials)** — machine-readable dependency + license inventory
- **License scanners** — automated tools that detect licenses in dependency trees
- **NOTICE file** — aggregate attribution file included in distribution

---

*Source: Fetcher research — open_source_licensing_comparison.md (Endor Labs, 2025 OSSRA Report). Updated 2026-03-23.*
