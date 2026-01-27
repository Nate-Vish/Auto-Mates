---
title: Python socket Library Reference
source_url: https://docs.python.org/3/library/socket.html
category: Python
subcategory: networking
tags: python, socket, networking, TCP, UDP, API, reference, library
relevant_agents: builder
fetched_date: 2026-01-11
last_updated: 2026-01-11
content_type: reference
difficulty: intermediate
description: Official Python documentation for the socket module providing low-level networking interface with BSD sockets.
keywords: socket, AF_INET, SOCK_STREAM, SOCK_DGRAM, bind, listen, accept, connect, send, recv, getaddrinfo
---

# Python Socket Library Documentation

## Overview

The `socket` module provides low-level networking capabilities through Python's object-oriented interface to BSD sockets. It's available on Unix systems, Windows, macOS, and other modern platforms.

## Key Components

### Socket Families

The module supports multiple address families including:

- **AF_INET/AF_INET6**: IPv4 and IPv6 internet sockets
- **AF_UNIX**: Unix domain sockets
- **AF_CAN**: Controller Area Network sockets
- **AF_PACKET**: Low-level network device access
- **AF_BLUETOOTH**: Bluetooth protocol support
- **AF_VSOCK**: Virtual machine communication
- **AF_HYPERV**: Hyper-V host/guest communication (Windows)

### Socket Types

Common socket types include `SOCK_STREAM` (TCP), `SOCK_DGRAM` (UDP), and `SOCK_RAW` for raw protocol access.

## Core Functions

**Creating Sockets:**
- `socket()`: Creates a socket object with specified family, type, and protocol
- `socketpair()`: Builds connected socket pairs
- `create_connection()`: Higher-level TCP connection helper
- `create_server()`: Convenience function for server socket setup

**Address Operations:**
- `getaddrinfo()`: Translates host/port to socket addresses
- `gethostbyname()`, `gethostbyaddr()`: Hostname resolution
- `inet_pton()`, `inet_ntop()`: IP address conversion
- `getservbyname()`, `getprotobyname()`: Service/protocol lookups

## Socket Object Methods

**Connection Management:**
- `bind()`: Associates socket with an address
- `listen()`: Enables server mode
- `accept()`: Accepts incoming connections
- `connect()`, `connect_ex()`: Client-side connection

**Data Transfer:**
- `send()`, `sendall()`: Transmit data
- `recv()`, `recvfrom()`: Receive data
- `sendmsg()`, `recvmsg()`: Advanced messaging with ancillary data
- `sendfile()`: Efficient file transmission

**Configuration:**
- `setsockopt()`, `getsockopt()`: Manage socket options
- `setblocking()`, `settimeout()`: Control blocking behavior
- `shutdown()`: Half-close connections

## Timeout Modes

Sockets support three operational modes:

1. **Blocking**: Operations block until complete
2. **Non-blocking**: Operations fail immediately if unavailable
3. **Timeout**: Operations raise `timeout` exception if deadline exceeded

The library handles signal interruption automatically (PEP 475), retrying system calls when appropriate rather than raising exceptions.

## Error Handling

The module defines specialized exceptions:
- `socket.error`: Deprecated alias for `OSError`
- `socket.herror`: Address-related errors
- `socket.gaierror`: `getaddrinfo()` errors
- `socket.timeout`: Timeout exceptions

## Platform Considerations

Some features are platform-specific. The documentation notes availability for Linux, Windows, BSD variants, and other systems. WebAssembly (WASI) has limited support with several functions unavailable.
