# Cgode UI 4.1 Guide

Canonical loader/source:

`https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua`

## Recommended project pattern

Keep UI construction inside one setup function, retain references to stateful controls, and use the library state/config managers for values that need to survive UI rebuilds.

```lua
local UI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua"
))()

local window = UI:CreateWindow("My App", "MyApp", true, {
    Resizable = true,
    Size = UDim2.fromOffset(700, 520),
})

local main = window:CreateTab("Main")
local settings = main:CreateSection("Settings")

local enabled = settings:CreateToggle("Enabled", true)
local amount = settings:CreateSlider("Amount", {min=0,max=100,default=25,step=1})

local state = UI:CreateState("settings", {
    enabled = enabled:Get(),
    amount = amount:Get(),
})

enabled:OnChanged(function(v)
    state:Get().enabled = v
end)

amount:OnChanged(function(v)
    state:Get().amount = v
end)
```

## Visual-first windows

Use the presentation options to build a cleaner dashboard without touching the underlying state/config architecture.

```lua
local window = UI:CreateWindow("Dashboard", "Dashboard", true, {
    Icon = "✦",
    Subtitle = "LIVE CONSOLE",
    StatusText = "READY",
    SidebarHeader = "WORKSPACE",
    SidebarFooter = "v4.1 • polished",
    Responsive = true,
})

local home = window:CreateTab("Home", {
    Icon = "⌂",
    Badge = "NEW",
    Description = "Primary controls and status.",
})

local section = home:CreateSection("Quick Controls", false, {
    Description = "Frequently used actions",
})
section:CreateButton("Run", function()
    print("run")
end)
```

Buttons, tabs, sections, text inputs, dialogs, toasts, progress bars, and feedback components automatically inherit the active theme and visual interaction states.

## Themes

Use a preset:

```lua
UI:SetTheme("Dark")
UI:SetTheme("Light")
```

Register a custom theme:

```lua
UI:RegisterTheme("Ocean", {
    Accent = Color3.fromRGB(70, 180, 255),
    AccentSoft = Color3.fromRGB(35, 80, 125),
})
UI:SetTheme("Ocean")
```

All live windows repaint through theme-role attributes.

## Config persistence

```lua
UI:SaveConfig("myapp", {
    enabled = enabled:Get(),
    amount = amount:Get(),
})

local saved = UI:LoadConfig("myapp", {
    enabled = true,
    amount = 25,
})
```

In environments exposing `writefile/readfile`, JSON config is stored as `Cgode_<name>.json`; otherwise the in-memory cache is used.

## Cleanup

Destroy controls when you no longer need them and destroy windows when the feature is unloaded:

```lua
window:Destroy()
-- or
UI:DestroyAll()
```

The window tracks input/toggle/drag/resize connections it creates so destruction can disconnect them.

## Responsive UI

`UI:GetDevice()` returns `Mobile`, `Tablet`, `Desktop`, or `Gamepad`. `UI:GetViewport()` gives the current `Vector2` viewport size. `UI.DeviceManager:Observe(callback)` can be used when layouts must adapt dynamically.

## Command palette / context menu

```lua
section:CreateCommandPalette({
    {name="Refresh", callback=function() print("refresh") end},
    {name="Reset", callback=function() print("reset") end},
}, function(selected)
    print(selected)
end)
```

```lua
section:CreateContextMenu({
    {Text="Edit"},
    {Text="Delete"},
}, function(item)
    print(item.Text)
end)
```

## Data components

Tables/data grids accept `headers, rows` arrays. Lists expose `Refresh(newItems)`. Sparklines/bar charts accept normalized numeric arrays (0 to 1) for the lightweight built-in renderer.
