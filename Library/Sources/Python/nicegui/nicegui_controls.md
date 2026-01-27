---
title: NiceGUI Controls & UI Components
source_url: https://nicegui.io/documentation/section_controls
category: Python
subcategory: nicegui
tags: nicegui, controls, buttons, inputs, sliders, forms, ui-components
relevant_agents: builder, planner
fetched_date: 2025-01-09
last_updated: 2025-01-09
content_type: reference
difficulty: intermediate
description: Complete reference for NiceGUI UI controls including buttons, inputs, sliders, and form elements
keywords: nicegui controls, buttons, inputs, sliders, checkboxes, text fields, form elements
---

# NiceGUI Controls & UI Components

## Button Components

### Button
Standard clickable button element based on Quasar's QBtn component.

**Parameters:**
- `text`: The label displayed on the button
- `on_click`: Callback invoked when button is pressed
- `color`: Button color (Quasar, Tailwind, or CSS color; default: 'primary')
- `icon`: Icon name to display on button (default: None)

**Note:** If a Quasar color is used, the button will be styled according to the Quasar theme including the color of the text.

```python
ui.button('Click me', on_click=lambda: ui.notify('Clicked!'))
ui.button('With Icon', icon='thumb_up', on_click=lambda: ui.notify('Liked!'))
```

### Button Group
Element based on Quasar's QBtnGroup component. Design props must match between parent and child buttons.

### Button Dropdown
Dropdown button based on Quasar's QBtnDropDown component.

**Parameters:**
- `text`: Button label
- `value`: Dropdown open state (default: False)
- `on_value_change`: Callback when dropdown opens/closes
- `on_click`: Callback when button is pressed
- `color`: Button color (default: 'primary')
- `icon`: Icon name (default: None)
- `auto_close`: Auto-close on item click (default: False)
- `split`: Split dropdown icon into separate button (default: False)

### Floating Action Button (FAB)
Triggers actions via floating button. Based on Quasar's QFab component.

**Parameters:**
- `icon`: Icon displayed on FAB
- `value`: Whether FAB is open (default: False)
- `label`: Optional FAB label
- `color`: Background color (default: "primary")
- `direction`: Direction ("up", "down", "left", "right"; default: "right")

---

## Badge & Chip

### Badge
Element wrapping Quasar's QBadge component.

**Parameters:**
- `text`: Initial text value
- `color`: Color name (default: "primary")
- `text_color`: Text color (default: None)
- `outline`: Use outline design (default: False)

### Chip
Element wrapping Quasar's QChip component. Supports clickable, selectable, and removable variants.

**Parameters:**
- `text`: Initial text (default: "")
- `icon`: Icon name (default: None)
- `color`: Color name (default: "primary")
- `text_color`: Text color (default: None)
- `on_click`: Callback when chip clicked
- `selectable`: Whether chip is selectable (default: False)
- `selected`: Whether chip is selected (default: False)
- `on_selection_change`: Callback on selection state change
- `removable`: Show remove button (default: False)
- `on_value_change`: Callback when chip removed/unremoved

---

## Selection Controls

### Button Toggle
Based on Quasar's QBtnToggle component.

**Parameters:**
- `options`: List of values or dictionary mapping values to labels
- `value`: Initial value
- `on_change`: Callback on selection change
- `clearable`: Allow clearing by clicking selected option

**Note:** Call `update()` after manipulating options to refresh UI.

### Option Group
Based on Quasar's QOptionGroup component.

**Parameters:**
- `options`: List or dictionary of options
- `value`: Initial value
- `on_change`: Callback on selection change

### Select
Based on Quasar's QSelect component.

**Parameters:**
- `options`: List or dictionary of options
- `label`: Label above selection
- `value`: Initial value
- `on_change`: Callback on selection change
- `with_input`: Show filter input field
- `new_value_mode`: Handle new user-entered values (default: None)
- `multiple`: Allow multiple selections
- `clearable`: Add clear button
- `validation`: Validation rules dictionary or callable
- `key_generator`: Callback/iterator for generating dictionary keys

**Features:** If with_input is True, an input field is shown to filter the options.

```python
ui.select(['Option 1', 'Option 2', 'Option 3'],
          label='Choose one',
          on_change=lambda e: ui.notify(f'Selected: {e.value}'))
```

### Chips Input
Input field managing values as visual chips/tags. Based on Quasar's QSelect.

**Parameters:**
- `label`: Display label
- `value`: Initial value
- `on_change`: Callback on change
- `new_value_mode`: Handle new values (default: "toggle")
- `clearable`: Add clear button
- `validation`: Validation rules

*(Added in version 2.22.0)*

---

## Boolean Controls

### Checkbox
Based on Quasar's QCheckbox component.

**Parameters:**
- `text`: Label next to checkbox
- `value`: Initial checked state (default: False)
- `on_change`: Callback on value change

```python
ui.checkbox('I agree', on_change=lambda e: ui.notify(f'Agreed: {e.value}'))
```

### Toggle
Based on Quasar's QToggle component.

**Parameters:**
- `text`: Label next to switch
- `value`: Initial active state (default: False)
- `on_change`: Callback when state changes

---

## Slider & Range Controls

### Slider
Based on Quasar's QSlider component.

**Parameters:**
- `min`: Lower bound
- `max`: Upper bound
- `step`: Step size
- `value`: Initial slider position
- `on_change`: Callback when user releases slider

```python
ui.slider(min=0, max=100, value=50, on_change=lambda e: ui.notify(f'Value: {e.value}'))
```

### Range
Based on Quasar's QRange component.

**Parameters:**
- `min`: Lower bound
- `max`: Upper bound
- `step`: Step size
- `value`: Initial min/max positions (default: min to max)
- `on_change`: Callback when user releases range

### Rating
Based on Quasar's QRating component. *(Added in version 2.12.0)*

**Parameters:**
- `value`: Initial value (default: None)
- `max`: Maximum rating/icon count (default: 5)
- `icon`: Icon name (default: star)
- `icon_selected`: Selected icon name
- `icon_half`: Half-selected icon name
- `color`: Icon color(s) (default: "primary")
- `size`: Size in CSS units or standard names (xs|sm|md|lg|xl)
- `on_change`: Callback on selection change

### Knob
Based on Quasar's QKnob component. Takes number input via mouse/touch panning.

**Parameters:**
- `value`: Initial value (default: 0.0)
- `min`: Minimum value (default: 0.0)
- `max`: Maximum value (default: 1.0)
- `step`: Step size (default: 0.01)
- `color`: Knob color (default: "primary")
- `center_color`: Center part color
- `track_color`: Track color
- `size`: Size in CSS units
- `show_value`: Display value as text
- `on_change`: Callback on value change

### Joystick
Joystick element based on nipple.js library.

**Parameters:**
- `on_start`: Callback when user touches joystick
- `on_move`: Callback when joystick moves
- `on_end`: Callback when user releases joystick
- `throttle`: Move event throttle interval in seconds (default: 0.05)
- `options`: Arguments passed to nipple.js library

---

## Text Input Controls

### Input
Based on Quasar's QInput component.

**Parameters:**
- `label`: Displayed label
- `placeholder`: Text when empty
- `value`: Current value
- `password`: Hide input (default: False)
- `password_toggle_button`: Show password visibility toggle (default: False)
- `prefix`: Prepend to displayed value *(Added in version 3.5.0)*
- `suffix`: Append to displayed value *(Added in version 3.5.0)*
- `on_change`: Callback on value change
- `autocomplete`: List of autocomplete strings
- `validation`: Validation rules dictionary or callable

**Note:** The on_change event is called on every keystroke and the value updates accordingly.

```python
ui.input('Name', placeholder='Enter your name',
         on_change=lambda e: ui.notify(f'Hello {e.value}'))
```

### Textarea
Multi-line text input based on Quasar's QInput (textarea type).

**Parameters:**
- `label`: Textarea name
- `placeholder`: Text when empty
- `value`: Initial value
- `on_change`: Callback on value change
- `validation`: Validation rules

### Number Input
Based on Quasar's QInput component for numeric values.

**Parameters:**
- `label`: Displayed name
- `placeholder`: Text when empty
- `value`: Initial value
- `min`: Minimum allowed value
- `max`: Maximum allowed value
- `precision`: Decimal places allowed (default: no limit)
- `step`: Stepper button step size
- `prefix`: Prepend to displayed value
- `suffix`: Append to displayed value
- `format`: Format string like "%.2f"
- `on_change`: Callback on value change
- `validation`: Validation rules

### Color Input
Extends Quasar's QInput with color picker.

**Parameters:**
- `label`: Display label
- `placeholder`: Text when no color selected
- `value`: Current color value
- `on_change`: Callback on value change
- `preview`: Change button background to selected color (default: False)

### Color Picker
Based on Quasar's QMenu and QColor components.

**Parameters:**
- `on_pick`: Callback when color is picked
- `value`: Whether menu is open (default: False)

---

## Date & Time Controls

### Date Input
Extends Quasar's QInput with date picker. *(Added in version 3.3.0)*

**Parameters:**
- `label`: Display label
- `range_input`: Allow selecting date range (default: False)
- `placeholder`: Text when no date selected
- `value`: Current date value
- `on_change`: Callback on value change

### Date
Based on Quasar's QDate component. Date string format defined by mask parameter.

**Parameters:**
- `value`: Initial date
- `mask`: Date string format (default: 'YYYY-MM-DD')
- `on_change`: Callback on date change

**Features:** Supports range and multiple date selection via `.props()` method.

### Time Input
Extends Quasar's QInput with time picker. *(Added in version 3.3.0)*

**Parameters:**
- `label`: Display label
- `placeholder`: Text when no time selected
- `value`: Current time value
- `on_change`: Callback on value change

### Time
Based on Quasar's QTime component. Time string format defined by mask parameter.

**Parameters:**
- `value`: Initial time
- `mask`: Time string format (default: 'HH:mm')
- `on_change`: Callback on time change

---

## Advanced Controls

### Code Editor
Element using CodeMirror for code editing. Supports syntax highlighting for 140+ languages, 30+ themes, line numbers, code folding, and limited auto-completion.

**Parameters:**
- `value`: Initial editor value (default: "")
- `on_change`: Callback on value change
- `language`: Initial language (case-insensitive; default: None)
- `theme`: Initial theme (default: "basicLight")
- `indent`: Indentation string (default: " ")
- `line_wrapping`: Wrap lines (default: False)
- `highlight_whitespace`: Highlight whitespace (default: False)

**Methods:** `supported_languages()` and `supported_themes()` return available options.

### Terminal
Wrapper around xterm.js to emulate a terminal. *(Added in version 3.1.0)*

**Parameters:**
- `options`: Dictionary of xterm.js configuration options

**Note:** This provides only a front-end component without underlying shell.

### File Uploader
Based on Quasar's QUploader component.

**Parameters:**
- `multiple`: Allow multiple files (default: False)
- `max_file_size`: Maximum file size in bytes (default: 0)
- `max_total_size`: Maximum total size in bytes (default: 0)
- `max_files`: Maximum number of files (default: 0)
- `on_begin_upload`: Callback when upload begins *(Added in version 2.14.0)*
- `on_upload`: Callback for each uploaded file
- `on_multi_upload`: Callback after all files uploaded
- `on_rejected`: Callback when files rejected during selection
- `label`: Uploader label (default: '')
- `auto_upload`: Auto-upload on selection (default: False)

**Event Order:** Upload event handlers are called in order: on_begin_upload, on_upload (per file), on_multi_upload.

---

## Validation

Many input controls support validation via a `validation` parameter. Validation can be defined as:
- Dictionary of rules: `{'Too long!': lambda value: len(value) < 3}`
- Callable returning optional error message

Use `.without_auto_validation()` method to disable automatic validation on every value change.

```python
ui.input('Email', validation={'Invalid email': lambda v: '@' in v})
```
