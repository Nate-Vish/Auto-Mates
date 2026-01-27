
### Quick Start:

1. **Start a CLI agent session on Library folder**
2. **Initial Prompt:** `read Library/Fetcher/AGENT_PROMPT.md this is your identity`
3. **Give simple commands like:**
   - "Fetch [URL] and save to [category]"
   - "Get [URL] put it in [location]"
   - "Download [URL] to [folder/subfolder]"

### Examples:

```
Fetch https://react.dev/learn and save to programming/javascript
```

```
Get https://openai.com/research/gpt-4 and save to ai_ml/concepts
```

```
Download https://github.com/anthropics/anthropic-sdk-python to documentation/libraries
```

**You can use any category path - folders will be created automatically!**


## What Fetcher does?

Fetcher converts web content to clean markdown files, and organizes it into a structured local library for other agents to retrieve information from. In addition, it checks for malicious content such as suspicious commands or prompt injections, treats them as regular data and warns you (the user) about it.


# How Agents Use It

Later, when you ask an agent:
> "What are Python best practices?"

The agent can:
```
Read Library/Sources/programming/python/python_best_practices.md
```

local, safe, clear.