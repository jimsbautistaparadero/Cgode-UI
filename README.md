# Cgode UI 3.1 Modular

Cgode UI is **modular internally** but has a **single public loader**.

The user experience is exactly:

<<<<<<< HEAD
`load -> use -> render`

## Load

```lua
local lib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/Cgode/init.lua"
))()
```
=======
## Example
See `CgodeUI/Examples/Basic.client.lua`.
>>>>>>> FETCH_HEAD

The loader fetches the internal modules from the repository and returns the public `Cgode` facade.

## Use

```lua
local window = lib.createWindow("This Is A Window", "TestWindow", true)

local tab = window.createTab("Main")
local section = tab.createSection("Test Section", false)

section.createText("Hello World")

section.createButton("Test Button", function()
    print("Button Pressed!")
end)

section.createToggle("Test Toggle", false, function(value)
    print(value)
end)

section.createSlider("Test Slider", {
    default = 50,
    min = 1,
    max = 100,
    precise = true,
    step = 0.1
}, function(value)
    print(value)
end)

local textbox = section.createTextBox("Test TextBox", "Test", function(value)
    print(value)
end)

section.createDropdown(
    "Test Dropdown",
    {"Option 1","Option 2","Option 3"},
    "Option 1",
    function(value)
        print(value)
    end
)

section.createKeyBind("KeyBind", Enum.KeyCode.K, function()
    print("Key pressed")
end)

window.notification("Cgode UI", "Loaded!")
```

## Architecture

```text
Cgode/
├── init.lua
├── Core/
│   ├── Cgode.lua
│   ├── WindowManager.lua
│   ├── Controls.lua
│   ├── ThemeManager.lua
│   ├── AnimationManager.lua
│   ├── InputManager.lua
│   ├── StateManager.lua
│   ├── DeviceManager.lua
│   └── ConfigManager.lua
├── Components/
│   ├── Basic/
│   ├── Advanced/
│   ├── Feedback/
│   ├── DataDisplay/
│   └── Layout/
├── Platforms/
├── Themes/
└── Utils/
```

`Cgode/init.lua` is the public entry point. The consumer never has to know the internal module layout.
