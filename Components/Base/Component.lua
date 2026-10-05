local Maid=require(script.Parent.Parent.Parent.Utils.Maid)
local Component={}; Component.__index=Component
function Component.new(instance,context) return setmetatable({Instance=instance,Context=context,Maid=Maid.new(),Destroyed=false},Component) end
function Component:GetInstance() return self.Instance end
function Component:SetVisible(v) self.Instance.Visible=v~=false; return self end
function Component:SetEnabled(v) self.Enabled=v~=false; if self.Instance:IsA("GuiButton") then self.Instance.Active=self.Enabled; self.Instance.AutoButtonColor=self.Enabled end return self end
function Component:SetParent(parent) self.Instance.Parent=parent; return self end
function Component:SetSize(size) self.Instance.Size=size; return self end
function Component:SetPosition(pos) self.Instance.Position=pos; return self end
function Component:Destroy() if self.Destroyed then return end self.Destroyed=true; self.Maid:Destroy(); if self.Instance then self.Instance:Destroy() end end
return Component
