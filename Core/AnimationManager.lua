local TweenService=game:GetService("TweenService")
local M={};M.__index=M
function M.new() return setmetatable({ReducedMotion=false,Active={}},M) end
function M:Tween(obj,props,duration,style,direction) if self.ReducedMotion then for k,v in pairs(props) do obj[k]=v end; return nil end local t=TweenService:Create(obj,TweenInfo.new(duration or .18,style or Enum.EasingStyle.Quad,direction or Enum.EasingDirection.Out),props); self.Active[t]=true; t.Completed:Connect(function() self.Active[t]=nil end); t:Play(); return t end
function M:SetReducedMotion(v) self.ReducedMotion=v and true or false end
function M:CancelAll() for t in pairs(self.Active) do pcall(function() t:Cancel() end) end self.Active={} end
return M
