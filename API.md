# Cgode UI API 4.0

**Canonical source:** `https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua`

## Loader

```lua
local Cgode = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jimsbautistaparadero/Cgode-UI/main/init.lua"
))()
```

## Library

- `Cgode:CreateWindow(title, name, draggable?, options?)`
- `Cgode:CreateMain(...)`
- `Cgode:Notify(title, message, duration?, kind?)`
- `Cgode:SetTheme(theme)`
- `Cgode:GetTheme()`
- `Cgode:RegisterTheme(name, theme)`
- `Cgode:GetDevice()` / `IsTouch()` / `IsMobile()` / `IsTablet()` / `IsDesktop()` / `IsGamepad()`
- `Cgode:GetViewport()`
- `Cgode:GetWindows()` / `GetWindow(name)` / `DestroyAll()`
- `Cgode:CreateState(key, initial)` / `GetState` / `SetState`
- `Cgode:SaveConfig(name, data)` / `LoadConfig(name, defaults)`
- `Cgode:IsAvailable(name)` / `GetComponent(name)`

## Window

Creation options include:

```lua
{
    Size = UDim2.fromOffset(640, 480),
    Position = UDim2.fromScale(0.5, 0.5),
    Resizable = true,
    MinSize = UDim2.fromOffset(420, 320),
    MaxSize = UDim2.fromOffset(1100, 760),
    SidebarWidth = 155,
    DisplayOrder = 100,
    CornerRadius = 12,
}
```

Methods:

- `CreateTab(name, options?)`
- `SelectTab(tab)`
- `SetTitle(text)`
- `SetPosition(udim2)` / `GetPosition()`
- `SetSize(udim2)` / `GetSize()`
- `Center()`
- `SetVisible(boolean)` / `IsVisible()` / `Toggle()`
- `Focus()`
- `Minimize()` / `Maximize()` / `Restore()`
- `EnableDragging(handle, main)`
- `EnableResize(main)`
- `Notify(title, message, duration?, kind?)`
- `ShowDialog(title, message, buttons)`
- `ShowConfirm(title, message, onConfirm, onCancel)`
- `ShowCommandPalette(items, callback, commands)`
- `ShowContextMenu(items, callback)`
- `SetTheme(theme)` / `RefreshTheme()`
- `Destroy()`
- `Track(connection)` / `Connect(connection)`

## Tab / Section

Every component is available through a section. Common aliases use both camelCase and title-case names.

### Basic

`CreateText`, `CreateLabel`, `CreateParagraph`, `CreateDivider`, `CreateSpacer`, `CreateButton`, `CreateIconButton`, `CreateToggle`, `CreateCheckbox`, `CreateRadio`, `CreateRadioGroup`, `CreateSlider`, `CreateNumberInput`, `CreateTextBox`, `CreateDropdown`, `CreateMultiDropdown`, `CreateKeyBind`, `CreateColorPicker`, `CreateBadge`, `CreateLink`, `CreateImage`, `CreateCodeBlock`.

### Advanced

`CreateSearchBox`, `CreateComboBox`, `CreateCommandPalette`, `CreateContextMenu`, `CreateAccordion`, `CreateSegmentedControl`, `CreateTagInput`, `CreateStepper`, `CreateRangeSlider`, `CreateXYPad`, `CreateTreeView`, `CreateDatePicker`, `CreateTimePicker`, `CreateAutocomplete`, `CreatePagination`, `CreateRating`, `CreateBreadcrumbs`, `CreatePopover`.

### Data display

`CreateList`, `CreateVirtualList`, `CreateTable`, `CreateDataGrid`, `CreateStatistics`, `CreateActivityFeed`, `CreateTimeline`, `CreateSparkline`, `CreateBarChart`, `CreateLogViewer`.

### Feedback

`CreateNotification`, `CreateToast`, `CreateDialog`, `CreateConfirmDialog`, `CreateLoading`, `CreateSpinner`, `CreateSkeleton`, `CreateProgress`, `CreateTooltip`, `CreateEmptyState`, `CreateErrorState`, `CreateBanner`.

### Layout primitives

`CreateContainer`, `CreateStack`, `CreateRow`, `CreateColumn`, `CreateGrid`, `CreateResponsiveGrid`, `CreateSplitPane`, `CreateScrollContainer`, `CreateOverlay`, `CreateCard`, `CreatePanel`.

## Return-object conventions

Stateful controls generally expose:

- `Get()` — current value.
- `Set(value)` — update value.
- `OnChanged(callback)` — receive future changes.
- `Destroy()` — remove the control.

Text boxes also provide `getText`, `GetText`, `setText`, `SetText`, `clearText`, and `ClearText` compatibility names through their returned object shape where applicable.

## Slider options

```lua
{
    min = 0,
    max = 100,
    default = 50,
    precise = true,
    step = 0.5,
}
```

Legacy `defualt` is intentionally supported for compatibility.
