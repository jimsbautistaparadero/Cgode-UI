local Signal=require(script.Parent.Parent.Utils.Signal)
local M={};M.__index=M
function M.new() return setmetatable({Signals={}},M) end
function M:Get(name) if not self.Signals[name] then self.Signals[name]=Signal.new() end return self.Signals[name] end
function M:Fire(name,...) self:Get(name):Fire(...) end
function M:Destroy() for _,s in pairs(self.Signals) do s:Destroy() end self.Signals={} end
return M
