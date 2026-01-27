# WebSocket Standards

Official protocol specifications for WebSocket.

## Sources

| File | Type | Description |
|------|------|-------------|
| [rfc6455_websocket_protocol.md](rfc6455_websocket_protocol.md) | Standard | RFC 6455 - The WebSocket Protocol (IETF) |

## Key Topics
- Opening handshake mechanism
- Data framing format
- Client-to-server masking (security)
- Frame types: text, binary, close, ping, pong
- Connection lifecycle (OPEN, CLOSING, CLOSED)
- Subprotocols and extensions negotiation
- URI schemes: `ws://` and `wss://`
- Close status codes (1000-1011)

## Security Features
- Mandatory client masking to prevent proxy cache poisoning
- Origin header validation for CSRF protection
- TLS support via `wss://`

## Related Sources
- [Writing WebSocket Servers](../../networking/websocket/writing_websocket_servers_mdn.md) - Practical implementation
- [WebSocket API](../../networking/websocket/websocket_api_mdn.md) - Client-side usage
