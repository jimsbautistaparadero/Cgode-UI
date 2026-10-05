-- Cgode UI public loader / facade
-- The repository stays modular. This file is the only URL users need.
local BASE = "https://raw.githubusercontent.com/YOUR_USERNAME/Cgode-UI/main/Cgode/"

local function fetch(path)
    local src = game:HttpGet(BASE .. path)
    local fn, err = loadstring(src, "@Cgode/" .. path)
    assert(fn, err)
    return fn()
end

local Cgode = fetch("Core/Cgode.lua")
Cgode._BASE = BASE
Cgode._fetch = fetch

-- Core systems
Cgode.ThemeManager = fetch("Core/ThemeManager.lua")(Cgode)
Cgode.AnimationManager = fetch("Core/AnimationManager.lua")(Cgode)
Cgode.InputManager = fetch("Core/InputManager.lua")(Cgode)
Cgode.StateManager = fetch("Core/StateManager.lua")(Cgode)
Cgode.DeviceManager = fetch("Core/DeviceManager.lua")(Cgode)
Cgode.ConfigManager = fetch("Core/ConfigManager.lua")(Cgode)
Cgode.WindowManager = fetch("Core/WindowManager.lua")(Cgode)

-- Component registry
Cgode.Components = Cgode.Components or {}
local componentFiles = {
    Basic = {
        "Button","Toggle","Slider","Dropdown","TextBox","KeyBind","ColorPicker",
        "Checkbox","Radio","NumberInput","Label","Paragraph","Divider","Spacer"
    },
    Advanced = {
        "SearchBox","ComboBox","CommandPalette","ContextMenu","Accordion",
        "SegmentedControl","TagInput","Stepper","RangeSlider","XYPad","TreeView"
    },
    Feedback = {
        "Notification","Toast","Dialog","ConfirmDialog","Loading","Progress",
        "Spinner","Skeleton","Tooltip","EmptyState","ErrorState"
    },
    DataDisplay = {
        "List","VirtualList","DataGrid","Table","Statistics","ActivityFeed","Timeline"
    },
    Layout = {
        "Container","Stack","Row","Column","Grid","ResponsiveGrid",
        "SplitPane","ScrollContainer","Overlay","Card","Panel"
    }
}

for group, names in pairs(componentFiles) do
    Cgode.Components[group] = {}
    for _, name in ipairs(names) do
        local path = "Components/" .. group .. "/" .. name .. ".lua"
        local ok, result = pcall(fetch, path)
        if ok then
            Cgode.Components[group][name] = result(Cgode)
        end
    end
end

-- Platform adapters
Cgode.Platforms = {}
for _, name in ipairs({"Universal","Mobile","Tablet","Desktop","Gamepad"}) do
    local ok, result = pcall(fetch, "Platforms/" .. name .. ".lua")
    if ok then Cgode.Platforms[name] = result(Cgode) end
end

-- Themes
Cgode.Themes = Cgode.Themes or {}
for _, name in ipairs({"Light","Dark","System","Presets"}) do
    local ok, result = pcall(fetch, "Themes/" .. name .. ".lua")
    if ok then Cgode.Themes[name] = result(Cgode) end
end

return Cgode
