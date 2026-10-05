local Cgode = {}
Cgode.__index = Cgode
Cgode.Name = "Cgode UI"
Cgode.Version = "4.1.0"
Cgode.Build = "visual-polish"
Cgode.Components = {}
Cgode.Platforms = {}
Cgode.Themes = {}
Cgode.Windows = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

function Cgode:GetGuiParent()
    local ok, gui = pcall(function()
        if type(gethui) == "function" then return gethui() end
    end)
    if ok and gui then return gui end
    local okCore = pcall(function() return CoreGui.Name end)
    if okCore then return CoreGui end
    return player:WaitForChild("PlayerGui")
end

function Cgode:GetViewport()
    local cam = workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(800, 600)
end

function Cgode:GetDevice()
    local viewport = self:GetViewport()
    if UIS.GamepadEnabled and not UIS.TouchEnabled and not UIS.KeyboardEnabled then return "Gamepad" end
    if UIS.TouchEnabled and viewport.X < 700 then return "Mobile" end
    if UIS.TouchEnabled and viewport.X < 1050 then return "Tablet" end
    return "Desktop"
end

function Cgode:IsTouch() return UIS.TouchEnabled end
function Cgode:IsMobile() return self:GetDevice() == "Mobile" end
function Cgode:IsTablet() return self:GetDevice() == "Tablet" end
function Cgode:IsDesktop() return self:GetDevice() == "Desktop" end
function Cgode:IsGamepad() return self:GetDevice() == "Gamepad" end

function Cgode:createWindow(title, name, draggable, options)
    local window = self.WindowManager:Create({
        Title = title,
        Name = name,
        Draggable = draggable ~= false,
        Options = options or {},
    })
    table.insert(self.Windows, window)
    return window
end
Cgode.CreateWindow = Cgode.createWindow
Cgode.CreateMain = Cgode.createWindow

function Cgode:GetWindows()
    return self.Windows
end
function Cgode:GetWindow(name)
    for _, window in ipairs(self.Windows) do
        if not window.Destroyed and window.Name == name then return window end
    end
end
function Cgode:DestroyAll()
    for _, window in ipairs(self.Windows) do pcall(function() window:Destroy() end) end
    self.Windows = {}
end
function Cgode:Notify(title, message, duration, kind)
    return self.WindowManager:Notify(title, message, duration, kind)
end
function Cgode:SetTheme(theme) return self.ThemeManager:Set(theme) end
function Cgode:GetTheme() return self.ThemeManager:Get() end
function Cgode:RegisterTheme(name, theme) return self.ThemeManager:Register(name, theme) end
function Cgode:CreateState(key, initial) return self.StateManager:Create(key, initial) end
function Cgode:GetState(key) return self.StateManager:Get(key) end
function Cgode:SetState(key, value) return self.StateManager:Set(key, value) end
function Cgode:SaveConfig(name, data) return self.ConfigManager:Save(name, data) end
function Cgode:LoadConfig(name, defaults) return self.ConfigManager:Load(name, defaults) end
function Cgode:CreateSignal() return self.StateManager:Signal() end
function Cgode:IsAvailable(name) return self.ComponentIndex and self.ComponentIndex[name] ~= nil end
function Cgode:GetComponent(name) return self.ComponentIndex and self.ComponentIndex[name] end

return Cgode
