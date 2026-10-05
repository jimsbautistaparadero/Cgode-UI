local Component=require(script.Parent.Component)
local Interactive={};Interactive.__index=Interactive; setmetatable(Interactive,{__index=Component})
function Interactive.new(instance,context) local self=setmetatable(Component.new(instance,context),Interactive); self.Hovered=false; self.Pressed=false; return self end
function Interactive:SetHovered(v) self.Hovered=v; if self.OnHover then self.OnHover(v) end end
function Interactive:SetPressed(v) self.Pressed=v; if self.OnPressState then self.OnPressState(v) end end
return Interactive
