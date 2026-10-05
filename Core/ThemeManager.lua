local EventManager=require(script.Parent.EventManager)
local M={};M.__index=M
function M.new(preset) return setmetatable({Theme=preset,Events=EventManager.new(),Registry={}},M) end
function M:Get(key) return self.Theme.Colors[key] end
function M:SetTheme(t) self.Theme=t; self.Events:Fire("Changed",t); for i,fn in pairs(self.Registry) do pcall(fn,t); end end
function M:SetColor(key,color) self.Theme.Colors[key]=color; self.Events:Fire("Changed",self.Theme) end
function M:Subscribe(fn) local k={}; self.Registry[k]=fn; return function() self.Registry[k]=nil end end
function M:Destroy() self.Registry={}; self.Events:Destroy() end
return M
