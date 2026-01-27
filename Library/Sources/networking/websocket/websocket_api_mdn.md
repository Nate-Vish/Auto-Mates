---
title: WebSocket API Reference
source_url: https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
category: networking
subcategory: websocket
tags: websocket, API, JavaScript, client, browser, MDN, real-time
relevant_agents: builder
fetched_date: 2026-01-11
last_updated: 2026-01-11
content_type: reference
difficulty: beginner
description: MDN reference for the browser WebSocket API enabling real-time bidirectional client-server communication.
keywords: WebSocket, send, close, onopen, onmessage, onerror, onclose, readyState, binaryType
---

# WebSocket API Documentation

## Overview

The `WebSocket` object enables real-time bidirectional communication between a client and server. As MDN explains, it "provides the API for creating and managing a WebSocket connection to a server, as well as for sending and receiving data."

## Key Components

### Constructor
- **`WebSocket()`** - Creates a new WebSocket instance

### Instance Properties
- **`binaryType`** - Specifies the binary data format for the connection
- **`bufferedAmount`** (read-only) - Shows queued data in bytes
- **`extensions`** (read-only) - Contains server-selected extensions
- **`protocol`** (read-only) - Identifies the server-chosen sub-protocol
- **`readyState`** (read-only) - Reflects the current connection state
- **`url`** (read-only) - The absolute WebSocket URL

### Instance Methods
- **`close()`** - Terminates the connection
- **`send()`** - Queues data for transmission

### Events
- **`open`** - Fired when connection establishes
- **`message`** - Fired when data arrives
- **`error`** - Fired on transmission failures
- **`close`** - Fired when connection closes

## Basic Example

```javascript
const socket = new WebSocket("ws://localhost:8080");

socket.addEventListener("open", (event) => {
  socket.send("Hello Server!");
});

socket.addEventListener("message", (event) => {
  console.log("Message from server ", event.data);
});
```

## Important Note

MDN cautions that "The `WebSocket` API has no way to apply backpressure," which can cause memory issues or performance degradation under high message volumes. For automatic backpressure handling, consider using `WebSocketStream` instead.

## Browser Support

WebSocket is widely supported across browsers since July 2015.
