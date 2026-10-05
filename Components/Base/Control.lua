local Interactive=require(script.Parent.Interactive)
local Control={};Control.__index=Control;setmetatable(Control,{__index=Interactive})
function Control.new(instance,context,default) local self=setmetatable(Interactive.new(instance,context),Control); self.Value=default; self.Changed=require(script.Parent.Parent.Parent.Utils.Signal).new(); return self end
function Control:GetValue() return self.Value end
function Control:SetValue(v,silent) local old=self.Value; self.Value=v; if not silent and old~=v then self.Changed:Fire(v,old); if self.Callback then task.spawn(self.Callback,v,old) end end; return self end
function Control:OnChanged(fn) return self.Changed:Connect(fn) end
function Control:Destroy() if self.Changed then self.Changed:Destroy() end; Interactive.Destroy(self) end
return Control
