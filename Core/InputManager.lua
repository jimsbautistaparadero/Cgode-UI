local UIS=game:GetService("UserInputService");local Maid=require(script.Parent.Parent.Utils.Maid);local M={};M.__index=M
function M.new()return setmetatable({Maid=Maid.new()},M)end
function M:BindHover(obj,onEnter,onLeave)self.Maid:Give(obj.MouseEnter:Connect(onEnter));self.Maid:Give(obj.MouseLeave:Connect(onLeave))end
function M:BindPress(obj,callback)self.Maid:Give(obj.Activated:Connect(callback))end
function M:BindDrag(handle,target,options)local Draggable=require(script.Parent.Parent.Utils.Draggable);self.Maid:Give(Draggable.bind(handle,target,options))end
function M:BindKey(key,fn)self.Maid:Give(UIS.InputBegan:Connect(function(i,gp)if not gp and (i.KeyCode==key)then fn(i)end end))end
function M:BindGamepad(key,fn)self.Maid:Give(UIS.InputBegan:Connect(function(i,gp)if gp and i.KeyCode==key then fn(i)end end))end
function M:SetGamepadMode(enabled)self.GamepadMode=enabled and true or false end
function M:Destroy()self.Maid:Destroy()end
return M
