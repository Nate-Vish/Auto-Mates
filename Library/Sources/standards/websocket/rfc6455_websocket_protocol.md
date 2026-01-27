---
title: "RFC 6455: The WebSocket Protocol"
source_url: https://datatracker.ietf.org/doc/html/rfc6455
category: standards
subcategory: websocket
tags: RFC, websocket, protocol, IETF, standard, specification, framing
relevant_agents: builder, checker, planner
fetched_date: 2026-01-11
last_updated: 2026-01-11
content_type: standard
difficulty: advanced
description: The official IETF specification for the WebSocket Protocol, defining handshake, framing, security, and connection lifecycle.
keywords: RFC 6455, WebSocket, handshake, framing, masking, opcode, close, ping, pong, ws, wss, TLS
---

# RFC 6455: The WebSocket Protocol

## Overview

RFC 6455, published in December 2011, defines the WebSocket Protocol—a standardized mechanism for establishing persistent, bidirectional communication between clients and servers over a single TCP connection.

## Key Purpose

The protocol addresses limitations of HTTP-based polling by enabling two-way real-time communication without requiring multiple simultaneous connections. As the specification notes, it provides "a mechanism for browser-based applications that need two-way communication with servers that does not rely on opening multiple HTTP connections."

## Core Components

### Opening Handshake

The WebSocket connection begins with an HTTP Upgrade request. The client sends a GET request containing specific headers:

- **Sec-WebSocket-Key**: A base64-encoded random 16-byte value
- **Upgrade**: Must include "websocket"
- **Connection**: Must include "Upgrade"
- **Sec-WebSocket-Version**: Set to 13

The server responds with HTTP 101 status and validates the connection by computing a hash of the key concatenated with a predefined GUID.

### Data Framing

After the handshake, communication uses frames containing:

- **FIN bit**: Indicates message completion
- **Opcode**: Defines frame type (text, binary, continuation, or control)
- **Mask bit**: Requires client-to-server masking
- **Payload length**: Variable-length encoding
- **Masking key**: 4-byte random value (client frames only)

### Frame Types

- **Data frames**: Text (0x1) or binary (0x2)
- **Control frames**: Close (0x8), Ping (0x9), Pong (0xA)

## Security Features

### Client-to-Server Masking

All frames sent by clients must be masked with a randomly-selected 32-bit value. This prevents infrastructure attacks where malicious applications could craft frames resembling HTTP requests to poison caching proxies.

### Origin Validation

Browser clients must include an Origin header, allowing servers to restrict connections to specific origins and prevent cross-origin exploitation.

### URI Schemes

- **ws://**: Unencrypted WebSocket (default port 80)
- **wss://**: WebSocket over TLS (default port 443)

## Connection Lifecycle

### Establishment

1. Client initiates TCP connection (with optional TLS for wss://)
2. Client sends opening handshake
3. Server validates and responds with 101 status
4. Connection enters OPEN state

### Data Exchange

Messages consist of one or more frames. Fragmentation allows:

- Sending messages of unknown length without buffering
- Multiplexing by interleaving large messages
- Control frames can be injected between fragments

### Closure

Either endpoint can initiate a closing handshake by sending a Close frame (0x8) containing an optional status code and reason. Status codes range from 1000 (normal) to 1011 (server error), with reserved ranges for extensions and private use.

## Subprotocols and Extensions

The protocol supports:

- **Subprotocols**: Application-level protocols layered over WebSocket, negotiated via Sec-WebSocket-Protocol header
- **Extensions**: Protocol-level enhancements negotiated via Sec-WebSocket-Extensions header

## Implementation Considerations

### Validation Requirements

- Servers must reject unmasked frames from clients
- Clients must reject masked frames from servers
- All UTF-8 text data must be valid; invalid sequences trigger connection failure
- Implementations should enforce limits on frame and message sizes

### Abnormal Closure Recovery

When connections close unexpectedly, clients should implement exponential backoff with initial delays between 0-5 seconds to avoid overwhelming servers during recovery attempts.

## Standards Status

This specification represents IETF consensus and is classified as Standards Track. Version 13 is the current standard, with earlier draft versions (0-8) designated as interim, and versions 9-12 reserved.
