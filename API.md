# Cgode UI API

## Public loader
`Cgode/init.lua`

## Factory
- `createWindow(title, name, draggable, options)`
- `CreateWindow`
- `CreateMain`

## Window
- `createTab(name)`
- `CreateTab`
- `notification(title, message, duration)`
- `Notify`
- `SelectTab`
- `SetTheme`
- `Destroy`

## Section
- `createText`
- `createButton`
- `createToggle`
- `createSlider`
- `createDropdown`
- `createTextBox`
- `createKeyBind`
- `createColorPicker`

Slider options support `min`, `max`, `default`, legacy `defualt`, `precise`, and `step`.

TextBox returns `getText`, `GetText`, `setText`, `SetText`, `clearText`, and `ClearText`.

## Design
The repository is modular. The public API is intentionally simple and resembles the AquaLib-style usage pattern: load one entry point, call the library, create controls, and render.
