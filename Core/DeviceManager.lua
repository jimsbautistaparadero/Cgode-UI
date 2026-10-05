local Device=require(script.Parent.Parent.Utils.Device)
local M={};M.__index=M
function M.new() local self=setmetatable({Kind=Device.classify(),Touch=Device.hasTouch(),Mouse=Device.hasMouse(),Keyboard=Device.hasKeyboard(),Gamepad=Device.hasGamepad(),Listeners={}},M);local UIS=game:GetService("UserInputService");table.insert(self.Listeners,UIS:GetPropertyChangedSignal("TouchEnabled"):Connect(function(v)self.Touch=v;self.Kind=Device.classify()end));table.insert(self.Listeners,UIS.GamepadConnected:Connect(function()self.Gamepad=true;self.Kind=Device.classify()end));table.insert(self.Listeners,UIS.GamepadDisconnected:Connect(function()self.Gamepad=#UIS:GetConnectedGamepads()>0;self.Kind=Device.classify()end));return self end
function M:IsMobile()return self.Kind=="Mobile"end
function M:IsTablet()return self.Kind=="Tablet"end
function M:IsDesktop()return self.Kind=="Desktop"end
function M:Destroy()for _,c in ipairs(self.Listeners)do c:Disconnect()end end
return M
