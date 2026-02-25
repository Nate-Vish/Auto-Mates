# Fetcher Knowledge Section

*Last updated: 2026-02-22*

## Core Tools
- [Jina AI Overview](../Sources/AI_Services/Jina_AI/jina_ai_overview.md) — Search foundation platform
- [Jina Reader](../Sources/AI_Services/Jina_AI/jina_reader.md) — URL to markdown extraction (primary tool)
- [Jina Documentation](../Sources/AI_Services/Jina_AI/jina_documentation.md) — API reference
- [Jina Embeddings](../Sources/AI_Services/Jina_AI/jina_embeddings.md) — Vector embeddings API
- [Tavily Overview](../Sources/AI_Services/Tavily/tavily_overview.md) — Web search for agents
- [Tavily Documentation](../Sources/AI_Services/Tavily/tavily_documentation.md) — Search/Extract APIs

## Legal Compliance (Read Before Fetching)
- [hiQ v. LinkedIn](../Sources/Legal/Web_Scraping/hiq_v_linkedin_case_summary.md) — CFAA and public data scraping
- [robots.txt Legal Status](../Sources/Legal/Web_Scraping/robots_txt_legal_status.md) — When to respect robots.txt
- [GDPR Article 5](../Sources/Legal/Privacy/gdpr_article_5_data_minimization.md) — Data minimization for scraping
- [GDPR Scraping Best Practices](../Sources/Legal/Privacy/gdpr_web_scraping_best_practices.md) — Compliance
- [Third-Party API Risks](../Sources/Legal/API_Terms/third_party_api_legal_risks_rag.md) — Content liability
- [Tavily Terms of Service](../Sources/Legal/API_Terms/tavily_terms_of_service.md) — Data usage terms
- [Jina AI Terms](../Sources/Legal/API_Terms/jina_ai_terms_and_conditions.md) — IP and data ownership

## Browser Automation (Playwright CLI)
- [Playwright CLI Research](../../Dashboard/Work_Space/AwesomeMates/Studied/Playwright_CLI_Research.md) — Token-efficient browser control via shell commands
- [Playwright MCP Research](../../Dashboard/Work_Space/AwesomeMates/Studied/Playwright_MCP_Research.md) — MCP alternative (reference only, we use CLI)
- **CLI Commands:** `playwright-cli open`, `playwright-cli snapshot`, `playwright-cli click`, `playwright-cli fill`, `playwright-cli type`
- **When to use:** Dynamic/JS pages, cookie consent walls, auth-required docs, interactive widgets
- **Fallback:** Use Jina (`r.jina.ai`) for simple static pages (faster, no browser needed)
- **Why CLI over MCP:** 4x fewer tokens — snapshots/screenshots save to disk, not context window

## Knowledge Management Patterns
- [Bedrock Knowledge Bases](../Sources/Cloud_AI/Amazon_Bedrock/bedrock_knowledge_bases.md) — RAG patterns

---
*When fulfilling knowledge requests, also update the requesting agent's Library/Knowledge/[Agent]/README.md with new source links.*
