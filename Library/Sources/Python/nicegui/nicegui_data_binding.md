---
title: NiceGUI Data Binding and Properties
source_url: https://nicegui.io/documentation/section_binding_properties
category: Python
subcategory: nicegui
tags: nicegui, data-binding, reactive, properties, state-management
relevant_agents: builder, planner
fetched_date: 2025-01-09
last_updated: 2025-01-09
content_type: guide
difficulty: intermediate
description: Complete guide to NiceGUI data binding system for connecting UI elements to data models
keywords: nicegui binding, data binding, reactive, bindable properties, state management, two-way binding
---

# NiceGUI Data Binding and Properties

## Overview

NiceGUI enables developers to establish direct connections between UI elements and data models through a binding system. This mechanism creates automatic synchronization between interface components and underlying data.

## Core Binding Concepts

### Basic Binding Methods

NiceGUI is able to directly bind UI elements to models. Binding is possible for UI element properties like text, value or visibility and for model properties that are (nested) class attributes.

The framework provides dedicated binding methods:
- **Two-way bindings** (e.g., `bind_value()`)
- **One-way bindings** using `_from` and `_to` variants
- Immediate value updates when either side changes

### Simple Example

```python
from nicegui import ui

class Demo:
    def __init__(self):
        self.number = 1

demo = Demo()
v = ui.checkbox('visible', value=True)
with ui.column().bind_visibility_from(v, 'value'):
    ui.slider(min=1, max=3).bind_value(demo, 'number')
    ui.toggle({1: 'A', 2: 'B', 3: 'C'}).bind_value(demo, 'number')
    ui.number().bind_value(demo, 'number')

ui.run()
```

---

## Transformation Functions

Developers can apply conversion logic during value propagation using `forward` and `backward` transformation parameters. Transformation functions are called whenever the source attribute changes.

**Example with text transformation:**

```python
from nicegui import ui

i = ui.input(value='Lorem ipsum')
ui.label().bind_text_from(i, 'value',
                          backward=lambda text: f'{len(text)} characters')

ui.run()
```

---

## Binding to Different Data Structures

### Dictionary Binding

Bindings work seamlessly with dictionary objects:

```python
from nicegui import ui

data = {'name': 'Bob', 'age': 17}

ui.label().bind_text_from(data, 'name', backward=lambda n: f'Name: {n}')
ui.label().bind_text_from(data, 'age', backward=lambda a: f'Age: {a}')

ui.button('Turn 18', on_click=lambda: data.update(age=18))

ui.run()
```

### Variable Binding

To bind to global variables, use the `globals()` dictionary:

```python
from nicegui import ui

date = '2023-01-01'

with ui.input('Date').bind_value(globals(), 'date') as date_input:
    with ui.menu() as menu:
        ui.date(on_change=lambda: ui.notify(f'Date: {date}')).bind_value(date_input)
    with date_input.add_slot('append'):
        ui.icon('edit_calendar').on('click', menu.open).classes('cursor-pointer')

ui.run()
```

### Storage Binding

The binding system integrates with application storage for persistence across sessions:

```python
from nicegui import app, ui

ui.textarea('This note is kept between visits').classes('w-full') \
    .bind_value(app.storage.user, 'note')

ui.run()
```

---

## Advanced Binding Features

### Bindable Properties for Performance

For optimal efficiency, use `BindableProperty` to enable automatic write-access detection:

```python
from nicegui import binding, ui

class Demo:
    number = binding.BindableProperty()

    def __init__(self):
        self.number = 1

demo = Demo()
ui.slider(min=1, max=3).bind_value(demo, 'number')
ui.toggle({1: 'A', 2: 'B', 3: 'C'}).bind_value(demo, 'number')
ui.number(min=1, max=3).bind_value(demo, 'number')

ui.run()
```

### Bindable Dataclass Decorator

The framework provides a decorator for streamlined bindable class creation:

```python
from nicegui import binding, ui

@binding.bindable_dataclass
class Demo:
    number: int = 1

demo = Demo()
ui.slider(min=1, max=3).bind_value(demo, 'number')
ui.toggle({1: 'A', 2: 'B', 3: 'C'}).bind_value(demo, 'number')
ui.number(min=1, max=3).bind_value(demo, 'number')

ui.run()
```

---

## Binding Types and Performance

The framework distinguishes between two binding approaches:

1. **Bindable properties**: Automatically detect write access and trigger propagation with no overhead when values remain unchanged
2. **Active links**: Require continuous checking (approximately 10 times per second) for attribute changes in custom objects

For complex data structures or high-frequency bindings, bindable properties provide superior performance.

---

## Attribute Existence Checking

The `strict` parameter controls validation behavior when binding creates properties. By default, object attributes are validated while dictionary keys are not. Developers can customize this behavior to prevent silent failures during refactoring.

---

## Common Binding Methods

| Method | Direction | Purpose |
|--------|-----------|---------|
| `bind_value()` | Two-way | Sync element value with model |
| `bind_value_from()` | Model → UI | Read from model |
| `bind_value_to()` | UI → Model | Write to model |
| `bind_text()` | Two-way | Sync text content |
| `bind_text_from()` | Model → UI | Read text from model |
| `bind_visibility()` | Two-way | Sync visibility |
| `bind_visibility_from()` | Model → UI | Control visibility from model |

---

## Best Practices

1. **Use `BindableProperty`** for classes with frequently updated properties
2. **Use `@bindable_dataclass`** for simple data models
3. **Use transformation functions** to format display values
4. **Bind to `app.storage`** for persistent user data
5. **Use one-way bindings** when updates should only flow in one direction
