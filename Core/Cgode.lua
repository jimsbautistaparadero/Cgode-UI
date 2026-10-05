local Cgode = {}
Cgode.__index = Cgode
Cgode.Name = "Cgode UI"
Cgode.Version = "3.1.0"
Cgode.Components = {}
Cgode.Platforms = {}
Cgode.Themes = {}

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local CoreGui=game:GetService("CoreGui")
local player=Players.LocalPlayer

function Cgode:GetGuiParent()
    local ok,g=pcall(function() return gethui and gethui() end)
    if ok and g then return g end
    local ok2=pcall(function() return CoreGui:GetChildren() end)
    if ok2 then return CoreGui end
    return player:WaitForChild("PlayerGui")
end

function Cgode:GetDevice()
    local v=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    if UIS.TouchEnabled and v.X<700 then return "Mobile" end
    if UIS.TouchEnabled and v.X<1000 then return "Tablet" end
    return "Desktop"
end

function Cgode:createWindow(title,name,draggable,options)
    return self.WindowManager:Create({
        Title=title,Name=name,Draggable=draggable~=false,Options=options or {}
    })
end
Cgode.CreateWindow=Cgode.createWindow
Cgode.CreateMain=Cgode.createWindow

function Cgode:Notify(title,message,duration)
    return self.WindowManager:Notify(title,message,duration)
end

function Cgode:SetTheme(theme)
    return self.ThemeManager:Set(theme)
end
function Cgode:GetTheme()
    return self.ThemeManager:Get()
end

return Cgode
