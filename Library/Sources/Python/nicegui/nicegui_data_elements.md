---
title: NiceGUI Data Elements Documentation
source_url: https://nicegui.io/documentation/section_data_elements
category: Python
subcategory: nicegui
tags: nicegui, data, tables, charts, graphs, visualization, 3d, maps
relevant_agents: builder, planner, brainstorm
fetched_date: 2025-01-09
last_updated: 2025-01-09
content_type: reference
difficulty: intermediate
description: Complete reference for NiceGUI data visualization components including tables, charts, graphs, and 3D scenes
keywords: nicegui data, tables, charts, graphs, plotly, matplotlib, highcharts, echart, 3d scene, leaflet maps
---

# NiceGUI Data Elements Documentation

## Overview

NiceGUI provides comprehensive data visualization and display components for creating interactive web applications. These elements range from simple tables to complex 3D visualizations.

---

## Table

A table component based on Quasar's QTable for displaying structured data.

**Key Parameters:**
- `rows`: List of row objects
- `columns`: List of column objects (defaults to first row columns since v2.0.0)
- `column_defaults`: Optional default column properties
- `row_key`: Unique identifier column name (default: "id")
- `title`: Table title
- `selection`: Selection type ("single", "multiple", or None)
- `pagination`: Dictionary or row count (None hides pagination, 0 means infinite)
- `on_select`: Callback when selection changes
- `on_pagination_change`: Callback for pagination changes

**Important Note:** Cells in rows must not contain lists because they can cause the browser to crash.

```python
from nicegui import ui

columns = [
    {'name': 'name', 'label': 'Name', 'field': 'name', 'required': True, 'align': 'left'},
    {'name': 'age', 'label': 'Age', 'field': 'age', 'sortable': True},
]
rows = [
    {'name': 'Alice', 'age': 18},
    {'name': 'Bob', 'age': 21},
]
ui.table(columns=columns, rows=rows, row_key='name')
```

---

## AG Grid

Advanced grid component using AG Grid library for enterprise-level data display.

**Key Parameters:**
- `options`: Dictionary of AG Grid options
- `html_columns`: List of columns rendered as HTML (default: [])
- `theme`: AG Grid theme ("quartz", "balham", "material", "alpine"; default: "quartz")
- `auto_size_columns`: Auto-resize columns (default: True)

**Methods:**
- `run_grid_method()`: Execute AG Grid methods
- `run_row_method()`: Execute row-specific methods

```python
from nicegui import ui

grid = ui.aggrid({
    'columnDefs': [
        {'headerName': 'Name', 'field': 'name'},
        {'headerName': 'Age', 'field': 'age'},
    ],
    'rowData': [
        {'name': 'Alice', 'age': 18},
        {'name': 'Bob', 'age': 21},
    ],
    'rowSelection': {'mode': 'multiRow'},
})

def update():
    grid.options['rowData'][0]['age'] += 1

ui.button('Update', on_click=update)
ui.button('Select all', on_click=lambda: grid.run_grid_method('selectAll'))
```

---

## Highcharts Chart

Chart visualization using Highcharts library.

**Note:** Requires separate installation: `pip install nicegui[highcharts]`

**Key Parameters:**
- `options`: Highcharts configuration dictionary
- `type`: Chart type ("chart", "stockChart", "mapChart"; default: "chart")
- `extras`: Additional dependencies (e.g., "annotations", "solid-gauge")
- `on_point_click`: Click callback
- `on_point_drag_start`, `on_point_drag`, `on_point_drop`: Drag callbacks

```python
from nicegui import ui
from random import random

chart = ui.highchart({
    'title': False,
    'chart': {'type': 'bar'},
    'xAxis': {'categories': ['A', 'B']},
    'series': [
        {'name': 'Alpha', 'data': [0.1, 0.2]},
        {'name': 'Beta', 'data': [0.3, 0.4]},
    ],
}).classes('w-full h-64')

def update():
    chart.options['series'][0]['data'][0] = random()

ui.button('Update', on_click=update)
```

---

## Apache EChart

Interactive charting library with extensive customization options.

**Key Parameters:**
- `options`: EChart configuration dictionary
- `on_point_click`: Point click callback
- `on_click`: Component click callback (v3.5.0+)
- `enable_3d`: Force 3D library import
- `renderer`: "canvas" or "svg" (v2.7.0+)
- `theme`: EChart theme configuration (v2.15.0+)

```python
from nicegui import ui
from random import random

echart = ui.echart({
    'xAxis': {'type': 'value'},
    'yAxis': {'type': 'category', 'data': ['A', 'B'], 'inverse': True},
    'series': [
        {'type': 'bar', 'name': 'Alpha', 'data': [0.1, 0.2]},
        {'type': 'bar', 'name': 'Beta', 'data': [0.3, 0.4]},
    ],
})

def update():
    echart.options['series'][0]['data'][0] = random()

ui.button('Update', on_click=update)
```

---

## Matplotlib Integration

### Pyplot Context

Context manager for Matplotlib plot configuration.

**Parameters:**
- `close`: Close figure after context exit (default: True)
- `kwargs`: Arguments passed to pyplot.figure (e.g., figsize)

```python
import numpy as np
from matplotlib import pyplot as plt
from nicegui import ui

with ui.pyplot(figsize=(3, 2)):
    x = np.linspace(0.0, 5.0)
    y = np.cos(2 * np.pi * x) * np.exp(-x)
    plt.plot(x, y, '-')
```

### Matplotlib Element

Renders a Matplotlib figure with automatic updates.

```python
import numpy as np
from nicegui import ui

with ui.matplotlib(figsize=(3, 2)).figure as fig:
    x = np.linspace(0.0, 5.0)
    y = np.cos(2 * np.pi * x) * np.exp(-x)
    ax = fig.gca()
    ax.plot(x, y, '-')
```

### Line Plot

Real-time line plotting with live data updates.

**Parameters:**
- `n`: Number of lines
- `limit`: Maximum datapoints per line
- `update_every`: Update frequency
- `close`: Close figure after context (default: True)
- `kwargs`: pyplot.figure arguments

```python
import math
from datetime import datetime
from nicegui import ui

line_plot = ui.line_plot(n=2, limit=20, figsize=(3, 2), update_every=5) \
    .with_legend(['sin', 'cos'], loc='upper center', ncol=2)

def update_line_plot():
    now = datetime.now()
    x = now.timestamp()
    y1 = math.sin(x)
    y2 = math.cos(x)
    line_plot.push([now], [[y1], [y2]], y_limits=(-1.5, 1.5))

line_updates = ui.timer(0.1, update_line_plot, active=False)
```

---

## Plotly Element

Renders Plotly charts with two configuration approaches.

**Parameters:**
- `figure`: Plotly go.Figure instance or dict with data/layout/config keys

```python
import plotly.graph_objects as go
from nicegui import ui

fig = go.Figure(go.Scatter(x=[1, 2, 3, 4], y=[1, 2, 3, 2.5]))
fig.update_layout(margin=dict(l=0, r=0, t=0, b=0))
ui.plotly(fig).classes('w-full h-40')
```

---

## Altair Chart

Interactive charting by wrapping altair.Chart in NiceGUI via anywidget. (v3.5.0+)

**Parameters:**
- `chart`: altair.Chart or altair.JupyterChart
- `throttle`: Minimum time between updates (default: 0.0)

```python
import altair as alt
from altair.datasets import data
from nicegui import ui

cars = data.cars()
chart = alt.Chart(cars).mark_point() \
    .encode(x='Horsepower', y='Miles_per_Gallon', color='Origin') \
    .interactive()

ui.altair(chart)
```

---

## Progress Indicators

### Linear Progress

Bar-based progress display from Quasar's QLinearProgress.

**Parameters:**
- `value`: Initial value (0.0 to 1.0)
- `size`: Height (default: "20px" with label, "4px" without)
- `show_value`: Display value label (default: True)
- `color`: Color name or CSS value

```python
from nicegui import ui

slider = ui.slider(min=0, max=1, step=0.01, value=0.5)
ui.linear_progress().bind_value_from(slider, 'value')
```

### Circular Progress

Circular progress display based on Quasar's QCircularProgress.

**Parameters:**
- `value`: Initial value
- `min`: Minimum value (default: 0.0)
- `max`: Maximum value (default: 1.0)
- `size`: Circle size (default: "xl")
- `show_value`: Display label (default: True)
- `color`: Color specification

### Spinner

Loading indicator based on Quasar's QSpinner.

**Parameters:**
- `type`: Spinner style ("audio", "ball", "bars", etc.; default: "default")
- `size`: Spinner size (default: "1em")
- `color`: Color specification (default: "primary")
- `thickness`: Line thickness for default spinner (default: 5.0)

```python
from nicegui import ui

with ui.row():
    ui.spinner(size='lg')
    ui.spinner('audio', size='lg', color='green')
    ui.spinner('dots', size='lg', color='red')
```

---

## 3D Visualization

### 3D Scene

Three.js-based 3D rendering with interactive objects.

**Parameters:**
- `width`, `height`: Canvas dimensions
- `grid`: Display grid (boolean or tuple for size/divisions)
- `camera`: perspective_camera or orthographic_camera
- `on_click`: Click callback
- `click_events`: JavaScript events ("click", "dblclick")
- `on_drag_start`, `on_drag_end`: Drag callbacks
- `drag_constraints`: Position constraints expression
- `background_color`: Scene background (default: "#eee")
- `fps`: Frame rate (default: 20, v3.2.0+)
- `show_stats`: Performance display (default: False, v3.2.0+)

**Supported Objects:** boxes, spheres, cylinders, cones, extrusions, lines, curves, textured meshes

```python
from nicegui import ui

with ui.scene().classes('w-full h-64') as scene:
    scene.axes_helper()
    scene.sphere().material('#4488ff').move(2, 2)
    scene.cylinder(1, 0.5, 2, 20).material('#ff8800', opacity=0.5).move(-2, 1)

    with scene.group().move(z=2):
        scene.box().move(x=2)
        scene.box().move(y=2).rotate(0.25, 0.5, 0.75)

    logo = 'https://avatars.githubusercontent.com/u/2843826'
    scene.texture(logo, [[[0.5, 2, 0], [2.5, 2, 0]],
                         [[0.5, 0, 0], [2.5, 0, 0]]]).move(1, -3)
```

---

## Map Visualization

### Leaflet Map

Interactive map using Leaflet JavaScript library.

**Parameters:**
- `center`: Initial coordinates (lat/lon; default: (0.0, 0.0))
- `zoom`: Initial zoom level (default: 13)
- `draw_control`: Show drawing toolbar (default: False)
- `options`: Additional Leaflet configuration
- `hide_drawn_items`: Hide drawing layer (default: False, v2.0.0+)
- `additional_resources`: CSS/JS files (v2.11.0+)

```python
from nicegui import ui

m = ui.leaflet(center=(51.505, -0.09))
ui.label().bind_text_from(m, 'center',
    lambda center: f'Center: {center[0]:.3f}, {center[1]:.3f}')
ui.label().bind_text_from(m, 'zoom', lambda zoom: f'Zoom: {zoom}')

with ui.grid(columns=2):
    ui.button('London', on_click=lambda: m.set_center((51.505, -0.090)))
    ui.button('Berlin', on_click=lambda: m.set_center((52.520, 13.405)))
```

---

## Tree Visualization

Hierarchical data display using Quasar's QTree component.

**Parameters:**
- `nodes`: List of node objects
- `node_key`: Property for unique ID (default: "id")
- `label_key`: Property for display label (default: "label")
- `children_key`: Property for child list (default: "children")
- `on_select`: Selection change callback
- `on_expand`: Expansion change callback
- `on_tick`: Checkbox toggle callback
- `tick_strategy`: Checkbox mode ("leaf", "leaf-filtered", "strict", or None)

```python
from nicegui import ui

ui.tree([
    {'id': 'numbers', 'children': [{'id': '1'}, {'id': '2'}]},
    {'id': 'letters', 'children': [{'id': 'A'}, {'id': 'B'}]},
], label_key='id', on_select=lambda e: ui.notify(e.value))
```

---

## Log Display

### Log View

Efficient log display with append-only updates.

**Parameters:**
- `max_lines`: Maximum lines before dropping oldest (default: None)

```python
from datetime import datetime
from nicegui import ui

log = ui.log(max_lines=10).classes('w-full h-20')
ui.button('Log time', on_click=lambda: log.push(datetime.now().strftime('%X.%f')[:-5]))
```

---

## Code and Data Editing

### Editor

WYSIWYG editor based on Quasar's QEditor producing HTML output.

```python
from nicegui import ui

editor = ui.editor(placeholder='Type something here')
ui.markdown().bind_content_from(editor, 'value',
    backward=lambda v: f'HTML code:\n```\n{v}\n```')
```

### Code

Syntax-highlighted code display with copy button (HTTPS/localhost only).

**Parameters:**
- `content`: Code string
- `language`: Language specification (default: "python")

```python
from nicegui import ui

ui.code('''
    from nicegui import ui
    ui.label('Code inception!')
    ui.run()
''').classes('w-full')
```

### JSONEditor

JSON editor with validation using JSONEditor library.

**Parameters:**
- `properties`: JSONEditor configuration dictionary
- `on_select`: Selection callback
- `on_change`: Change callback
- `schema`: JSON schema for validation (v2.8.0+)

```python
from nicegui import ui

json = {
    'array': [1, 2, 3],
    'boolean': True,
    'number': 123,
    'object': {'a': 'b', 'c': 'd'},
}
ui.json_editor({'content': {'json': json}},
               on_select=lambda e: ui.notify(f'Select: {e}'),
               on_change=lambda e: ui.notify(f'Change: {e}'))
```
