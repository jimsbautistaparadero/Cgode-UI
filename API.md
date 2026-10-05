# Cgode UI API

## Root
`CgodeUI:CreateWindow(options)`
`CgodeUI:CreateConfig(namespace, defaults)`
`CgodeUI:LoadTheme(name)`
`CgodeUI:DestroyAll()`

## Window
`CreateTab(name, icon)`
`Minimize()` / `Maximize()` / `Restore()` / `Center()` / `Destroy()`
`SetResponsiveMode(breakpoint)` / `SetTheme(theme)` / `Notify(options)`

## Controls
Button, Toggle/Switch, Checkbox, Radio, Slider, RangeSlider, Dropdown, MultiDropdown, Textbox, NumberInput, Keybind, ColorPicker, Label, Paragraph, Divider, Spacer, IconButton, ImageButton, Badge, Status, SearchBox, ComboBox, SegmentedControl, TagInput, Stepper, XYPad, DatePicker, TimePicker, TreeView, Accordion.

## Layout
Container, Panel, Card, Stack, Row, Column, Grid, ResponsiveGrid, SplitPane, ScrollContainer, Overlay.

## Data and feedback
List, VirtualList, Table, DataGrid, Timeline, ActivityFeed, Statistics, Chart, LineChart, BarChart, Notification, Toast, Dialog, ConfirmDialog, Alert, Loading, Progress, ProgressBar, Spinner, CircularProgress, Skeleton, Tooltip, EmptyState, ErrorState.

## Foundation
ThemeManager, AnimationManager, InputManager, StateManager, DeviceManager, LayoutManager, WindowManager, NavigationManager, EventManager, InstanceManager, ConfigManager, Maid, Signal, Validator, Draggable, Resizable.

## Supported behaviors
Responsive breakpoints, mobile drawer behavior, safe-area-aware placement, touch/mouse dragging, keyboard keybinds, controller detection, resize handles, window state, navigation history, reduced motion, cleanup ownership, theme presets, configuration JSON export/import, and adaptive viewport handling.
