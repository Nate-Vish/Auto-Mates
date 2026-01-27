{
  "mcpServers": {
    "jina-mcp-server": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://mcp.jina.ai/v1"
        "--header",
        "Authorization: Bearer ${JINA_API_KEY}"
        ]
    }
  }
}

