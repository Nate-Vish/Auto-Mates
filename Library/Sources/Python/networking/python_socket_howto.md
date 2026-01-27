---
title: Socket Programming HOWTO
source_url: https://docs.python.org/3/howto/sockets.html
category: Python
subcategory: networking
tags: python, sockets, networking, TCP, IP, client-server, howto
relevant_agents: builder, planner
fetched_date: 2026-01-11
last_updated: 2026-01-11
content_type: tutorial
difficulty: intermediate
description: Python tutorial on socket programming fundamentals covering client/server sockets, TCP communication patterns, and non-blocking operations.
keywords: socket, TCP, INET, STREAM, bind, listen, accept, send, recv, select, non-blocking
---

# Socket Programming HOWTO

## Overview

This Python documentation guide by Gordon McMillan explains socket fundamentals, focusing on IPv4 (INET) and TCP (STREAM) sockets, which comprise the vast majority of real-world socket usage.

## Key Concepts

**Client vs. Server Sockets**

The author distinguishes between two socket types: client sockets serve as conversation endpoints, while server sockets function like switchboard operators. A web browser uses only client sockets, whereas web servers utilize both types.

**Creating Connections**

The guide demonstrates how browsers create client sockets to connect to web servers on port 80. Meanwhile, servers establish listening sockets using `bind()` and `listen()`, then accept incoming connections via `accept()`.

## Communication Patterns

**The Core Challenge**

A fundamental issue emerges: "messages must either be fixed length (yuck), or be delimited (shrug), or indicate how long they are (much better), or end by shutting down the connection." Protocol designers must choose their messaging strategy deliberately.

**Send and Receive Operations**

The `send()` and `recv()` functions operate on network buffers, meaning they may not process all bytes in a single call. As the guide notes, developers must "call them again until your message has been completely dealt with."

## Advanced Topics

**Binary Data Considerations**

Network communication requires attention to byte order differences. The guide explains how "network byte order is big-endian, with the most significant byte first," while most processors are little-endian.

**Non-Blocking Sockets**

For sophisticated applications, the guide recommends using `select()` rather than manually checking return codes, describing it as avoiding "brain-dead solutions" and CPU waste.
