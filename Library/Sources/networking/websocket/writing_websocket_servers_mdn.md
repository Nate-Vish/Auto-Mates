---
title: Writing WebSocket Servers
source_url: https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
category: networking
subcategory: websocket
tags: websocket, server, handshake, framing, protocol, MDN, TCP
relevant_agents: builder, checker
fetched_date: 2026-01-11
last_updated: 2026-01-11
content_type: guide
difficulty: intermediate
description: MDN guide on implementing WebSocket servers, covering the handshake process, data frame structure, masking, and control frames.
keywords: WebSocket, handshake, Sec-WebSocket-Key, frame, opcode, masking, ping, pong, close, fragmentation
---

# Writing WebSocket Servers

## Overview

A WebSocket server listens on a TCP port and follows a specific protocol to enable real-time bidirectional communication. According to MDN, "A WebSocket server can be written in any server-side programming language that is capable of Berkeley sockets, such as C(++), Python, PHP, or server-side JavaScript."

## The WebSocket Handshake

### Client Request

The client initiates the connection with an HTTP upgrade request. The handshake must use HTTP/1.1 or higher with a GET method. Key headers include:

- **Upgrade & Connection**: Signals protocol switching
- **Sec-WebSocket-Key**: A base64-encoded random value used for validation
- **Sec-WebSocket-Version**: Indicates protocol version (typically 13)

### Server Response

The server responds with a 101 Switching Protocols status and must compute the `Sec-WebSocket-Accept` header by:

1. Concatenating the client's key with the magic string `"258EAFA5-E914-47DA-95CA-C5AB0DC85B11"`
2. Computing the SHA-1 hash
3. Base64-encoding the result

This process "makes it obvious to the client whether the server supports WebSockets" and prevents security issues.

## Data Frame Exchange

### Frame Structure

Frames contain:
- **FIN bit**: Indicates if this is the final frame
- **Opcode**: Defines payload type (0x1 for text, 0x2 for binary, 0x0 for continuation)
- **MASK bit**: Client-to-server messages must always be masked
- **Payload length**: May use extended fields for lengths over 125 bytes
- **Masking key**: 4-byte key for XOR encryption (client messages only)
- **Payload data**: The actual message content

### Unmasking Data

To decode client messages, XOR each payload byte with the corresponding masking key byte using modulo arithmetic: `decoded_byte = encoded_byte XOR mask[i % 4]`

### Message Fragmentation

Long messages can be split across multiple frames. The FIN bit and opcode work together—continuation frames use opcode 0x0 until the final frame sets FIN=1.

## Control Frames

**Ping/Pong**: Either party can send a ping (opcode 0x9); recipients must respond with a pong (opcode 0xA) containing identical payload data. Maximum payload for control frames is 125 bytes.

**Closing**: Either side initiates closure by sending a close control frame; the other responds with a close frame, then both parties disconnect.

## Extensions and Subprotocols

Extensions modify frame structure and payload, like compression. Subprotocols structure the payload itself without modification. Both are negotiated during the handshake via headers. If multiple subprotocols are offered, the server selects one (or none).

## Security Considerations

MDN emphasizes consulting "RFC 6455, particularly section 10" for security guidance. The specification recommends checking the Origin header to defend against Cross-Site WebSocket Hijacking attacks, though non-browser clients can forge this header.
