# WebSocket Sources

WebSocket protocol implementation guides and client APIs.

## Sources

| File | Type | Description |
|------|------|-------------|
| [writing_websocket_servers_mdn.md](writing_websocket_servers_mdn.md) | Guide | MDN guide on implementing WebSocket servers |
| [websocket_api_mdn.md](websocket_api_mdn.md) | Reference | Browser WebSocket client API |

## Key Topics

### Server Implementation
- HTTP upgrade handshake
- `Sec-WebSocket-Key` and `Sec-WebSocket-Accept` headers
- Frame structure (FIN, opcode, mask, payload)
- Masking/unmasking client messages
- Control frames (ping/pong/close)
- Message fragmentation

### Client API
- `WebSocket()` constructor
- `send()` and `close()` methods
- Event handlers: `open`, `message`, `error`, `close`
- `readyState` and `bufferedAmount` properties

## Related Sources
- [RFC 6455](../../standards/websocket/rfc6455_websocket_protocol.md) - Official protocol specification
- [Python socket](../../Python/networking/python_socket_library.md) - Low-level socket for server implementation
