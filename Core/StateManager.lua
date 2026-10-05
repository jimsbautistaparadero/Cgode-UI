local Signal=require(script.Parent.Parent.Utils.Signal)
local State={}; State.__index=State
function State.new(initial) local self=setmetatable({Values=initial or {},Signals={}},State); return self end
function State:Get(k) return self.Values[k] end
function State:Set(k,v) local old=self.Values[k]; if old==v then return end; self.Values[k]=v; if self.Signals[k] then self.Signals[k]:Fire(v,old) end end
function State:Bind(k,fn) if not self.Signals[k] then self.Signals[k]=Signal.new() end; fn(self.Values[k]); return self.Signals[k]:Connect(fn) end
function State:Observe(k) if not self.Signals[k] then self.Signals[k]=Signal.new() end; return self.Signals[k] end
function State:Destroy() for _,s in pairs(self.Signals) do s:Destroy() end end
return State
