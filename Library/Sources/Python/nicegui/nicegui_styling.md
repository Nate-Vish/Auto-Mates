---
title: NiceGUI Styling & Appearance Guide
source_url: https://nicegui.io/documentation/section_styling_appearance
category: Python
subcategory: nicegui
tags: nicegui, styling, css, tailwind, theming, dark-mode, quasar
relevant_agents: builder, planner
fetched_date: 2025-01-09
last_updated: 2025-01-09
content_type: guide
difficulty: intermediate
description: Complete guide to styling NiceGUI applications with CSS, Tailwind, theming, and dark mode
keywords: nicegui styling, css, tailwind css, theming, dark mode, quasar props, color themes
---

# NiceGUI Styling & Appearance Guide

## Overview

NiceGUI leverages the Quasar Framework for design capabilities, offering multiple styling approaches through props, CSS classes, and direct style methods.

## Core Styling Methods

### Props
Each NiceGUI element includes a `props` method that passes parameters to underlying Quasar components. Props with a leading `:` can contain JavaScript expressions that are evaluated on the client.

```python
ui.radio(['x', 'y', 'z'], value='x').props('inline color=green')
```

### Tailwind CSS Classes
Apply utility classes via the `classes` method:

```python
ui.button(icon='touch_app').props('outline round').classes('shadow-lg')
```

### Direct CSS Styling
Use the `style` method with semicolon delimiters:

```python
ui.label('Stylish!').style('color: #6E93D6; font-size: 200%; font-weight: 300')
```

---

## CSS Layers

NiceGUI defines a cascade of CSS layers in increasing priority order:
1. theme
2. base
3. quasar
4. nicegui
5. components
6. utilities
7. overrides
8. quasar_importants

To override Quasar's `!important` rules, define custom CSS in the "components" or "utilities" layer with `!important`:

```python
ui.add_css('''
    @layer utilities {
       .red-background {
           background-color: red !important;
        }
    }
''')
```

---

## Tailwind CSS Layers

Define custom classes using Tailwind's `@layer` directive with `text/tailwindcss` style tags:

```python
ui.add_head_html('''
    <style type="text/tailwindcss">
        @layer components {
            .blue-box {
                @apply bg-blue-500 p-12 text-center shadow-lg rounded-lg text-white;
            }
        }
    </style>
''')
```

---

## ElementFilter

Search and style elements based on kind, markers, or content:

```python
ElementFilter(kind=ui.label).within(marker='important').classes('text-xl')
```

**Filtering supports:**
- Element type specification
- Marker-based filtering
- Content matching
- Scope limitations
- Ancestor-based conditions

---

## Query Selector

Manipulate DOM elements like `body` using CSS selectors:

```python
def set_background(color: str) -> None:
    ui.query('body').style(f'background-color: {color}')
```

---

## Color Theming

Configure primary colors and theme palette:

```python
ui.colors(primary='#555')
```

**Available parameters:**
- **primary**: Default "#5898d4"
- **secondary**: Default "#26a69a"
- **accent**: Default "#9c27b0"
- **dark**: Default "#1d1d1d"
- **positive**: Default "#21ba45"
- **negative**: Default "#c10015"
- **info**, **warning**, and **custom_colors**

---

## CSS Variables

Customize spacing defaults:

```python
ui.add_css('''
    :root {
        --nicegui-default-padding: 0.5rem;
        --nicegui-default-gap: 3rem;
    }
''')
```

**Available variables:**
- `--nicegui-default-padding: 1rem`
- `--nicegui-default-gap: 1rem`

---

## Dark Mode

Control dark mode with the dark mode element:

```python
dark = ui.dark_mode()
ui.button('Dark', on_click=dark.enable)
ui.button('Light', on_click=dark.disable)
```

Setting value to `None` enables auto mode based on system preferences.

---

## Adding CSS to Pages

Use `ui.add_css()` to inject styles into the document head:

```python
ui.add_css('''
    .red {
        color: red;
    }
''')
```

The `shared` parameter (added in version 2.14.0) applies CSS across all pages when set to `True`.

---

## Tailwind Default Style Overrides

Override Tailwind's element resets using `text/tailwindcss` style tags:

```python
ui.add_head_html('''
    <style type="text/tailwindcss">
        h2 {
            font-size: 150%;
        }
    </style>
''')
```

---

## Alternative Vue Frameworks

NiceGUI supports experimental integration with frameworks like Element Plus and Vuetify through custom Vue configuration:

```python
ui.add_body_html('''
    <link rel="stylesheet" href="//unpkg.com/element-plus/dist/index.css" />
    <script defer src="https://unpkg.com/element-plus"></script>
''')
app.config.vue_config_script += 'app.use(ElementPlus);'
```

**Note**: This feature is experimental and may cause compatibility issues with standard NiceGUI elements.

---

## Quick Reference

| Method | Purpose | Example |
|--------|---------|---------|
| `.props()` | Quasar component properties | `.props('outlined dense')` |
| `.classes()` | Tailwind/CSS classes | `.classes('bg-blue-500 p-4')` |
| `.style()` | Inline CSS styles | `.style('color: red')` |
| `ui.colors()` | Global color theme | `ui.colors(primary='#333')` |
| `ui.add_css()` | Custom CSS rules | `ui.add_css('.my-class {...}')` |
| `ui.dark_mode()` | Dark/light mode toggle | `dark.enable()` |
| `ui.query()` | DOM element manipulation | `ui.query('body').style(...)` |
