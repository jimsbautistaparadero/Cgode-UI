# Cgode UI 4.1 Visual Polish

Cgode UI is a Roblox/Luau UI library with a polished, responsive visual system built around one stable public loader and a modular internal architecture.

**Public source / loader**

```text
https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua
```

## Install

```lua
local Cgode = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua"
))()
```

The public `init.lua` resolves the internal modules from the same repository, caches modules per load, and returns the `Cgode` facade.

## Quick start

```lua
local lib = Cgode
local window = lib:CreateWindow("Cgode UI", "Demo", true, {
    Resizable = true,
    Size = UDim2.fromOffset(640, 480),
})

local tab = window:CreateTab("Main")
local section = tab:CreateSection("Controls")

section:CreateButton("Run", function()
    print("clicked")
end)

local toggle = section:CreateToggle("Enabled", true, function(value)
    print("enabled", value)
end)

local slider = section:CreateSlider("Amount", {
    min = 0,
    max = 100,
    default = 50,
    precise = true,
    step = 0.5,
}, function(value)
    print("amount", value)
end)

section:CreateDropdown("Mode", {"Safe", "Fast", "Custom"}, "Safe", function(mode)
    print("mode", mode)
end)

window:Notify("Cgode UI", "Library loaded")
```

## Visual design system

The 4.1 pass focuses only on presentation and interaction feel. Windows now use layered depth, a polished header, accent glow, richer navigation, animated controls, responsive density, stronger typography hierarchy, and cleaner modal/toast surfaces.

```lua
local window = lib:CreateWindow("My App", "MyApp", true, {
    Icon = "✦",
    Subtitle = "CONTROL CENTER",
    StatusText = "READY",
    SidebarHeader = "NAVIGATION",
    SidebarFooter = "v4.1 • polished",
    SidebarWidth = 168,
    CornerRadius = 14,
    Responsive = true,
})

local tab = window:CreateTab("Overview", {
    Icon = "◈",
    Badge = "1",
    Description = "Clean dashboard content with visual hierarchy.",
})

local section = tab:CreateSection("Appearance", false, {
    Description = "Presentation",
})
```

### UI polish highlights

The visual layer includes elevated window shadows, dual border treatment, header gradients, accent rails, brand marks, status pills, animated tab selection, active-tab indicators, tab badges, scroll styling, section accent rails, section chevrons, hover states, press states, hover scaling, focus states for text fields, richer button surfaces, stronger heading typography, muted secondary text, responsive sidebar widths, mobile window fitting, modal elevation, animated modal entry, animated toast entry/exit, semantic toast stripes, redesigned command palette presentation, redesigned context menus, a visible resize grip, improved spacing, consistent corner radii, softer borders, visual depth between surfaces, accent-aware progress bars, persistent color-picker swatches, theme-refresh UI callbacks, and polished feedback surfaces.

## What is included

### UI controls

Buttons, icon buttons, toggles, checkboxes, radio groups, sliders, number inputs, text boxes, dropdowns, multi-select dropdowns, keybinds, color pickers, badges, links, images, code blocks, search boxes, combo boxes, command palettes, context menus, accordions, segmented controls, tag inputs, steppers, range sliders, XY pads, tree views, date/time fields, autocomplete, pagination, ratings, breadcrumbs, popovers.

### Data and visualization

Lists, virtual lists, tables, data grids, statistics cards, activity feeds, timelines, sparklines, bar charts, and log viewers.

### Feedback

Notifications, toasts, dialogs, confirm dialogs, loading indicators, progress bars, spinners, skeleton states, tooltips, empty states, error states, and banners.

### Layout

Container, Stack, Row, Column, Grid, ResponsiveGrid, SplitPane, ScrollContainer, Overlay, Card, and Panel primitives are exposed through the same section API.

### Significant library-level features

1. Modular public loader with deterministic GitHub source.
2. Module fetch caching.
3. Component registry and component metadata.
4. Theme presets and custom theme registration.
5. Live theme refresh across every open window.
6. Animation/Tween manager.
7. Pulse feedback helper.
8. Global keyboard bindings.
9. Key capture mode.
10. Input binding cleanup.
11. Central reactive state store.
12. State subscriptions.
13. State snapshots.
14. Persistent config files when `writefile/readfile` are available.
15. In-memory config fallback.
16. JSON encode/decode helpers.
17. Device detection.
18. Device capability reporting.
19. Device change observation.
20. Touch-aware input paths.
21. Responsive window sizing.
22. Minimum and maximum window bounds.
23. Dragging support.
24. Resizing support.
25. Window centering.
26. Window position getters/setters.
27. Window size getters/setters.
28. Window visibility control.
29. RightShift window toggle shortcut.
30. Active-window focus management.
31. Multiple windows.
32. Global destroy-all support.
33. Window destruction cleanup.
34. Per-window connection tracking.
35. Collapsible sections.
36. Scrollable tab pages.
37. Scrollable tab navigation.
38. Tab selection API.
39. Popup/dropdown teardown.
40. Modal dialogs.
41. Confirmation dialogs.
42. Command palette presentation.
43. Context-menu presentation.
44. Toast stacking.
45. Theme-role attributes for safe repainting.
46. Component capability discovery with `IsAvailable`.
47. Direct component lookup with `GetComponent`.
48. Component version metadata.
49. Compatibility aliases (`CreateMain`, `CreateWindow`, title-case control names).
50. Slider support for legacy `defualt`.
51. Slider snapping and precision.
52. Range-slider value normalization.
53. Pagination with clamped bounds.
54. Rating control.
55. Tree data rendering.
56. List refresh APIs.
57. Table/data-grid rendering.
58. Lightweight chart primitives.
59. Code/log presentation.
60. Utility modules for signals, maids, colors, math, text, instances, validation, dragging, and resizing.

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

`Cgode/init.lua` is the only file consumers need to load.

## Compatibility notes

The library targets Roblox/Luau environments that expose `loadstring` and `game:HttpGet`, as expected by common script-loader environments. Persistent configuration is opportunistic: standard Roblox environments do not expose `writefile/readfile`, so the config manager transparently falls back to memory.

See [API.md](API.md) for the public API and [GUIDE.md](GUIDE.md) for patterns.
