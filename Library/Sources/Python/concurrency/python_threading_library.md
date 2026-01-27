---
title: Python threading Library Reference
source_url: https://docs.python.org/3/library/threading.html
category: Python
subcategory: concurrency
tags: python, threading, concurrency, multithreading, synchronization, locks, GIL
relevant_agents: builder, planner
fetched_date: 2026-01-11
last_updated: 2026-01-11
content_type: reference
difficulty: intermediate
description: Official Python documentation for the threading module providing high-level thread-based concurrency primitives.
keywords: threading, Thread, Lock, RLock, Condition, Semaphore, Event, Barrier, GIL, daemon, synchronization
---

# Python Threading Module Documentation

## Overview

The `threading` module provides high-level interfaces for thread-based concurrency within a single process. As stated in the documentation, "The threading module provides a way to run multiple threads (smaller units of a process) concurrently within a single process."

## Key Concepts

### When to Use Threading

Threading excels with I/O-bound tasks where "much of the time is spent waiting for external resources" like file operations or network requests. However, the Global Interpreter Lock (GIL) limits performance for CPU-bound work, as "only one thread can execute Python bytecode at a time."

### Basic Thread Creation

Threads are created by instantiating the `Thread` class with a callable target:

```python
t = threading.Thread(target=function, args=(arg1,), kwargs={"key": value})
t.start()
t.join()  # Wait for completion
```

## Core Components

### Thread Objects
- **`start()`**: Initiates thread execution in separate control flow
- **`join(timeout=None)`**: Blocks until thread terminates
- **`is_alive()`**: Checks if thread is running
- **`daemon`**: Boolean flag controlling whether thread is daemonic
- **`name`**: String identifier for the thread

### Synchronization Primitives

**Lock**: Basic mutual exclusion
- `acquire(blocking=True, timeout=-1)`: Obtain lock
- `release()`: Release lock
- `locked()`: Check lock state

**RLock**: Reentrant lock allowing same thread to acquire multiple times
- Supports nested `acquire()`/`release()` pairs
- Requires equal release calls to fully unlock

**Condition**: Coordinate threads waiting for specific states
- `wait(timeout=None)`: Release lock and block until notified
- `notify(n=1)`: Wake n waiting threads
- `notify_all()`: Wake all waiting threads

**Semaphore**: Manages internal counter for resource access
- `acquire()`: Decrement counter, block if zero
- `release(n=1)`: Increment counter by n

**Event**: Simple signaling mechanism
- `set()`: Signal event
- `clear()`: Reset event
- `wait(timeout=None)`: Block until event is set

**Barrier**: Synchronize fixed number of threads
- `wait(timeout=None)`: Block until all parties arrive

### Thread-Local Data

The `local` class stores data isolated to each thread:

```python
mydata = threading.local()
mydata.value = 42  # Thread-specific storage
```

## Context Manager Support

Locks, conditions, and semaphores support Python's `with` statement for automatic acquisition and release, preventing resource leaks from unhandled exceptions.

## Important Limitations

- Daemon threads "are abruptly stopped at shutdown" without proper cleanup
- Free-threaded builds (Python 3.13+) can disable the GIL, but this isn't default
- For CPU-intensive work, consider `multiprocessing` or `concurrent.futures.ProcessPoolExecutor`

## Module Functions

- `active_count()`: Return count of alive threads
- `current_thread()`: Get current thread object
- `enumerate()`: List all active threads
- `get_ident()`: Return current thread's identifier
- `get_native_id()`: Return OS-assigned thread ID
