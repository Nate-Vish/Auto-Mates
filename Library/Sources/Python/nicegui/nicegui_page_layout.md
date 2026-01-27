---
title: NiceGUI Page Layout Components
source_url: https://nicegui.io/documentation/section_page_layout
category: Python
subcategory: nicegui
tags: nicegui, layout, containers, cards, grids, columns, rows, tabs, navigation
relevant_agents: builder, planner
fetched_date: 2025-01-09
last_updated: 2025-01-09
content_type: reference
difficulty: intermediate
description: Complete reference for NiceGUI layout components including cards, grids, columns, tabs, and navigation elements
keywords: nicegui layout, containers, cards, grids, columns, rows, tabs, splitter, stepper
---

# NiceGUI Page Layout Components

## Overview

NiceGUI provides a comprehensive set of layout components for building responsive, modular user interfaces. The framework uses Python's `with` statement context managers to establish parent-child relationships without explicit parameters.

## Core Layout Elements

### Auto-Context

NiceGUI automatically tracks the context in which elements are created through `with` statements, allowing intuitive UI composition. Event handlers and timers inherit the parent context automatically.

### Card

A container with drop shadow based on Quasar's QCard component.

**Key features:**
- Optional `align_items` parameter for content alignment
- `.tight()` method for original QCard behavior (no padding, hidden borders)
- Useful for organizing related content

```python
with ui.card().tight():
    ui.image('https://picsum.photos/id/684/640/360')
    with ui.card_section():
        ui.label('Card content here')
```

### Column Element

Arranges child elements vertically with customizable wrapping and alignment.

**Parameters:** `wrap` (bool), `align_items` (str for alignment options)

```python
with ui.column():
    ui.label('label 1')
    ui.label('label 2')
    ui.label('label 3')
```

### Row Element

Arranges child elements horizontally. Default wrapping enabled.

```python
with ui.row():
    ui.label('label 1')
    ui.label('label 2')
    ui.label('label 3')
```

### Grid Element

Creates grid-based layouts with customizable rows and columns using CSS properties.

**Parameters:** Numeric values or CSS strings like `'auto 1fr'`

```python
with ui.grid(columns=2):
    ui.label('Name:')
    ui.label('Tom')
    ui.label('Age:')
    ui.label('42')
```

### List

Container for list items based on Quasar's QList. Supports dense and separator properties.

```python
with ui.list().props('dense separator'):
    ui.item('3 Apples')
    ui.item('5 Bananas')
```

### Slide Item

Expandable list item with configurable left/right/top/bottom actions.

**Features:** text parameter, on_slide callback, `.reset()` method

```python
with ui.slide_item('Slide me left or right') as slide_item:
    slide_item.left('Left', color='green')
    slide_item.right('Right', color='red')
```

### Fullscreen Control

Manages fullscreen mode with user interaction requirements.

**Parameters:** `require_escape_hold` for long-press escape requirement

```python
fullscreen = ui.fullscreen()
ui.button('Enter', on_click=fullscreen.enter)
ui.button('Exit', on_click=fullscreen.exit)
ui.button('Toggle', on_click=fullscreen.toggle)
```

---

## Container Management

### Clear Containers

Remove all elements using `.clear()`, remove individual elements via `.remove()` with index or element reference, or delete with `.delete()`.

```python
container.clear()
container.remove(0)
element.delete()
```

### Teleport

Transmits content to any location on the page using CSS selectors or element references.

```python
with ui.teleport(f'#{markdown.html_id} strong'):
    ui.input('name').classes('inline-flex')
```

---

## Expandable & Collapsible Elements

### Expansion Element

Based on Quasar's QExpansionItem for expandable content containers.

**Parameters:** `text`, `caption`, `icon`, `group` (accordion mode), `value`, `on_value_change`

```python
with ui.expansion('Expand!', icon='work').classes('w-full'):
    ui.label('inside the expansion')
```

### Scroll Area

Customizable scrollbar encapsulation using Quasar's ScrollArea.

```python
with ui.scroll_area().classes('w-32 h-32 border'):
    ui.label('I scroll. ' * 20)
```

### Separator

Horizontal divider similar to HTML `<hr>` tag, based on Quasar's QSeparator.

```python
ui.label('text above')
ui.separator()
ui.label('text below')
```

### Space

Fills available space in flexbox containers.

```python
with ui.row().classes('w-full border'):
    ui.label('Left')
    ui.space()
    ui.label('Right')
```

### Skeleton

Loading placeholder component based on Quasar's QSkeleton with wave animations.

**Parameters:** `type`, `tag`, `animation`, `animation_speed`, `square`, `bordered`, `size`, `width`, `height`

```python
ui.skeleton().classes('w-full')
```

---

## Advanced Layout Components

### Splitter

Divides screen space into resizable sections with customizable slots.

**Parameters:** `horizontal`, `limits`, `value`, `reverse`, `on_change`

```python
with ui.splitter() as splitter:
    with splitter.before:
        ui.label('Left content')
    with splitter.after:
        ui.label('Right content')
```

### Tabs

Multi-tab interface with associated panels.

```python
with ui.tabs().classes('w-full') as tabs:
    one = ui.tab('One')
    two = ui.tab('Two')
with ui.tab_panels(tabs, value=two).classes('w-full'):
    with ui.tab_panel(one):
        ui.label('First tab')
```

### Stepper

Step-by-step navigation component with keep-alive support.

```python
with ui.stepper() as stepper:
    with ui.step('Step 1'):
        ui.label('Content')
        with ui.stepper_navigation():
            ui.button('Next', on_click=stepper.next)
```

### Timeline

Chronological event display based on Quasar's QTimeline.

```python
with ui.timeline(side='right'):
    ui.timeline_entry('Description', title='Title', subtitle='Date')
```

### Carousel

Image/content carousel with animations and navigation.

```python
with ui.carousel(animated=True, arrows=True, navigation=True):
    with ui.carousel_slide():
        ui.image('https://picsum.photos/id/30/270/180')
```

### Pagination

Page navigation component wrapping Quasar's QPagination.

```python
p = ui.pagination(1, 5, direction_links=True)
ui.label().bind_text_from(p, 'value', lambda v: f'Page {v}')
```

---

## Interactive & Overlay Components

### Menu

Popup menu based on Quasar's QMenu with auto-close capability.

```python
with ui.button(icon='menu'):
    with ui.menu() as menu:
        ui.menu_item('Item 1', lambda: result.set_text('Selected'))
```

### Context Menu

Right-click menu positioned at cursor.

```python
with ui.image('url'):
    with ui.context_menu():
        ui.menu_item('Flip horizontally')
```

### Tooltip

Hover-activated information display.

```python
with ui.button(icon='thumb_up'):
    ui.tooltip('I like this').classes('bg-green')
```

### Notification

Temporary notification messages with multiple display options.

**Parameters:** `position`, `type` (positive/negative/warning/info), `color`, `multi_line`

```python
ui.notify('Hi!', close_button='OK')
```

### Notification Element

Persistent notification allowing updates and dismissal.

```python
n = ui.notification(timeout=None)
n.message = 'Updated message'
n.dismiss()
```

### Dialog

Modal dialog based on Quasar's QDialog.

Use `.props('persistent')` for non-dismissible dialogs.

```python
with ui.dialog() as dialog, ui.card():
    ui.label('Dialog content')
    ui.button('Close', on_click=dialog.close)
ui.button('Open', on_click=dialog.open)
```

---

All examples demonstrate NiceGUI's declarative Python syntax for building modern, responsive web interfaces with minimal JavaScript knowledge required.
