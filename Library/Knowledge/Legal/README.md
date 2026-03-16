# Legal Knowledge Section

*Last updated: 2026-03-17*

Legal's professional knowledge for compliance review. Self-contained — no external dependencies. Request Fetcher to research specific topics and add source files when needed.

---

## API Terms & Liability

- **Data Ownership:** Most API terms (Tavily, Jina AI, etc.) grant users ownership of their output but retain rights to input data for model improvement. Read the specific ToS before integrating.
- **Indemnification:** API providers typically require users to indemnify against claims arising from user-generated content passed through the API. Pass-through liability means YOUR app inherits the API's limitations.
- **Open Source AI Disclaimers:** MIT/Apache licenses include "AS IS" warranty disclaimers. AI-generated output carries no warranty — the user assumes all risk of using generated code.
- **OWASP Top 10 for LLM Apps:** Prompt injection, insecure output handling, training data poisoning, model DoS, supply chain vulnerabilities, sensitive info disclosure, insecure plugin design, excessive agency, overreliance, model theft.

## Copyright

- **NYT v. OpenAI (ongoing):** Landmark case on whether AI training on copyrighted content constitutes fair use. No final ruling yet — implications for all AI-generated content.
- **US Copyright Office AI Initiative:** AI-generated content with no human authorship is not copyrightable. Human-directed AI output MAY be registrable if human selection/arrangement is substantial.

## Web Scraping

- **hiQ v. LinkedIn (2022):** Scraping publicly accessible data does not violate the CFAA. Key precedent for web scraping legality — but does NOT override ToS, copyright, or privacy law.
- **robots.txt:** Not legally binding in most jurisdictions, but violating it weakens your legal position. Courts consider it evidence of intent. Always respect robots.txt.

## Privacy & GDPR

- **GDPR Article 5 (Data Minimization):** Collect only what's necessary. Process only what's relevant. Delete when no longer needed. Applies to any processing of EU personal data.
- **GDPR Scraping:** Scraping personal data requires a lawful basis (usually legitimate interest + balancing test). Must provide notice, honor opt-out, minimize data collected.
- **Right to Be Forgotten (Article 17):** Data subjects can request erasure. Applies when data is no longer necessary, consent is withdrawn, or processing is unlawful.

## International AI Law

- **Israel MOJ AI Opinion:** Machine learning training on copyrighted works likely qualifies as fair use under Israeli law (Section 19 of Copyright Act).
- **EU AI Act:** Risk-based classification (unacceptable → high → limited → minimal). General-purpose AI models (GPAI) must document training data, comply with copyright, publish summaries. Transparency requirements for all AI-generated content.

---

*Request Fetcher to add detailed source files when you identify knowledge gaps. Sources populate in `Library/Sources/Legal/` after Fetcher researches them.*
