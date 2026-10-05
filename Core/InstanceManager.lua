local Maid=require(script.Parent.Parent.Utils.Maid)
local M={};M.__index=M
function M.new() return setmetatable({Maid=Maid.new(),Instances={}},M) end
function M:Add(i) table.insert(self.Instances,i); self.Maid:Give(i); return i end
function M:Connect(c) self.Maid:Give(c); return c end
function M:Destroy() self.Maid:Destroy(); self.Instances={} end
return M
