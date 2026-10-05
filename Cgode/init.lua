--[[]
    Cgode UI public loader / facade.
    Public source:
    https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua
]]
local SOURCE_URL = "https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua"
local BASE = "https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/Cgode/"

local cache = {}
local function fetch(path)
    if cache[path] then return cache[path] end
    local ok, src = pcall(function() return game:HttpGet(BASE .. path) end)
    assert(ok and type(src) == "string", "Cgode UI: failed to fetch " .. path .. ": " .. tostring(src))
    local fn, err = loadstring(src, "@Cgode/" .. path)
    assert(fn, "Cgode UI: failed to compile " .. path .. ": " .. tostring(err))
    local okRun, result = pcall(fn)
    assert(okRun, "Cgode UI: failed to load " .. path .. ": " .. tostring(result))
    cache[path] = result
    return result
end

local Cgode = fetch("Core/Cgode.lua")
Cgode._BASE = BASE
Cgode.Source = SOURCE_URL
Cgode._fetch = fetch
Cgode._LoadedModules = cache

local core = {
    ThemeManager = "Core/ThemeManager.lua",
    AnimationManager = "Core/AnimationManager.lua",
    InputManager = "Core/InputManager.lua",
    StateManager = "Core/StateManager.lua",
    DeviceManager = "Core/DeviceManager.lua",
    ConfigManager = "Core/ConfigManager.lua",
    WindowManager = "Core/WindowManager.lua",
}
for name, path in pairs(core) do
    Cgode[name] = fetch(path)(Cgode)
end

local componentFiles = {
    Basic = {
        "Button","Toggle","Slider","Dropdown","MultiDropdown","TextBox","KeyBind","ColorPicker",
        "Checkbox","Radio","RadioGroup","NumberInput","Label","Paragraph","Divider","Spacer",
        "IconButton","Badge","Link","Image","CodeBlock"
    },
    Advanced = {
        "SearchBox","ComboBox","CommandPalette","ContextMenu","Accordion","SegmentedControl",
        "TagInput","Stepper","RangeSlider","XYPad","TreeView","DatePicker","TimePicker",
        "Autocomplete","Pagination","Rating","Breadcrumbs","Popover"
    },
    Feedback = {
        "Notification","Toast","Dialog","ConfirmDialog","Loading","Progress","Spinner","Skeleton",
        "Tooltip","EmptyState","ErrorState","Banner"
    },
    DataDisplay = {
        "List","VirtualList","DataGrid","Table","Statistics","ActivityFeed","Timeline","Sparkline",
        "BarChart","LogViewer"
    },
    Layout = {
        "Container","Stack","Row","Column","Grid","ResponsiveGrid","SplitPane","ScrollContainer",
        "Overlay","Card","Panel"
    }
}
Cgode.Components = {}
Cgode.ComponentIndex = {}
for group, names in pairs(componentFiles) do
    Cgode.Components[group] = {}
    for _, name in ipairs(names) do
        local modulePath = "Components/" .. group .. "/" .. name .. ".lua"
        local ok, result = pcall(function() return fetch(modulePath) end)
        if ok and type(result) == "function" then
            local loaded = result(Cgode)
            Cgode.Components[group][name] = loaded
            Cgode.ComponentIndex[name] = loaded
        end
    end
end

Cgode.Platforms = {}
for _, name in ipairs({"Universal","Mobile","Tablet","Desktop","Gamepad"}) do
    local ok, result = pcall(function() return fetch("Platforms/" .. name .. ".lua") end)
    if ok then Cgode.Platforms[name] = result(Cgode) end
end

Cgode.Themes = {}
for _, name in ipairs({"Light","Dark","System","Presets"}) do
    local ok, result = pcall(function() return fetch("Themes/" .. name .. ".lua") end)
    if ok then Cgode.Themes[name] = result(Cgode) end
end

Cgode._componentFiles = componentFiles
return Cgode
