---
title: NiceGUI Overview
source_url: https://nicegui.io/
category: Python
subcategory: nicegui
tags: nicegui, python, gui, web-ui, quasar, vue, fastapi, tailwind
relevant_agents: builder, planner, brainstorm
fetched_date: 2025-01-09
last_updated: 2025-01-09
content_type: reference
difficulty: beginner
description: Open-source Python library to write graphical user interfaces that run in the browser
keywords: nicegui, python gui, web ui, quasar framework, vue.js, fastapi, tailwind css
---

# NiceGUI Overview

NiceGUI is an open-source Python library to write graphical user interfaces which run in the browser. It emphasizes a backend-first philosophy where developers focus on Python code while the framework handles web development complexities.

## Core Concepts

**UI Building Blocks:**
- Elements (buttons, sliders, text, images, charts)
- Pages that assemble components
- Events triggered by user interactions
- Models for data binding with automatic UI updates

**Layout Approach:**
NiceGUI uses declarative UI with Python's `with` statement for code-based layouts, making structure visually resemble the final interface.

## Key Features

**Styling Options:**
- Optional element arguments for common styling
- CSS customization capabilities
- Tailwind CSS and Quasar properties via `.classes()` and `.props()` methods

**Async/Await Architecture:**
The framework employs async/await for efficient concurrency without thread-safety concerns, requiring all UI updates on the main event loop.

**Deployment Flexibility:**
- Local web browser (default)
- Native windows separate from browsers
- Server deployments handling multiple clients

## Component Categories

The framework provides 100+ UI elements including:
- Input controls (buttons, sliders, checkboxes, text fields)
- Data visualization (charts, tables, graphs)
- Layout containers (cards, grids, tabs, carousels)
- Media elements (audio, video, images)
- Advanced widgets (code editors, JSON editors, interactive maps)

## Testing & Customization

**Testing Options:**
- `Screen` fixture for headless browser testing
- `User` fixture for Python-level simulation (faster)

**Advanced Customization:**
- Tailwind and Quasar integration
- Component subclassing
- Custom Quasar component imports

## Storage & Lifecycle

The `app` object manages:
- Multiple storage layers (tab, client, user, general, browser)
- Lifecycle hooks (connect, disconnect, startup, shutdown)
- Static and media file serving

## Installation

```bash
pip install nicegui
```

## Quick Start

```python
from nicegui import ui

ui.label('Hello NiceGUI!')
ui.button('Click me', on_click=lambda: ui.notify('Button clicked!'))

ui.run()
```

## Technology Stack

- **Vue.js** - Frontend framework
- **Quasar** - UI component library
- **FastAPI** - Backend server
- **Tailwind CSS** - Utility-first CSS
- **Uvicorn** - ASGI server

## Resources

- Documentation: https://nicegui.io/documentation
- Examples: https://nicegui.io/examples
- GitHub: https://github.com/zauberzeug/nicegui/
- Discord: https://discord.gg/TEpFeAaF4f
- Reddit: https://www.reddit.com/r/nicegui/
