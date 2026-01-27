# NiceGUI Documentation

*Last updated: 2025-01-09*

NiceGUI is an open-source Python library to write graphical user interfaces that run in the browser. It uses Vue.js, Quasar, FastAPI, and Tailwind CSS under the hood.

## Contents

### Core Documentation

| File | Description | Difficulty |
|------|-------------|------------|
| [nicegui_overview.md](nicegui_overview.md) | Library overview, features, and quick start | Beginner |
| [nicegui_controls.md](nicegui_controls.md) | UI controls: buttons, inputs, sliders, forms | Intermediate |
| [nicegui_page_layout.md](nicegui_page_layout.md) | Layout components: cards, grids, tabs, navigation | Intermediate |
| [nicegui_styling.md](nicegui_styling.md) | Styling with CSS, Tailwind, theming, dark mode | Intermediate |
| [nicegui_data_elements.md](nicegui_data_elements.md) | Data visualization: tables, charts, 3D, maps | Intermediate |
| [nicegui_data_binding.md](nicegui_data_binding.md) | Reactive data binding and state management | Intermediate |
| [nicegui_examples.md](nicegui_examples.md) | 57 example applications with source code | Beginner |

## Relevant Agents

- **Builder** - Primary user for implementing NiceGUI interfaces
- **Planner** - For designing application architecture
- **BrainStorm** - For exploring UI/UX possibilities

## Quick Reference

### Installation
```bash
pip install nicegui
```

### Hello World
```python
from nicegui import ui

ui.label('Hello NiceGUI!')
ui.button('Click me', on_click=lambda: ui.notify('Clicked!'))

ui.run()
```

### Key Concepts
- **Declarative UI** - Use Python's `with` statement for layouts
- **100+ Components** - Buttons, inputs, charts, tables, 3D scenes
- **Data Binding** - Automatic sync between UI and data models
- **Styling** - Tailwind CSS, Quasar props, custom CSS
- **Async Support** - Built on FastAPI with async/await

## External Resources

- Official Site: https://nicegui.io/
- Documentation: https://nicegui.io/documentation
- Examples: https://nicegui.io/examples
- GitHub: https://github.com/zauberzeug/nicegui/
- Discord: https://discord.gg/TEpFeAaF4f
