local UIS=game:GetService("UserInputService")
local M={}
function M.bind(handle,target,options)
    options=options or {}; local dragging=false; local startPos; local startInput; local changed=handle.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; startInput=input.Position; startPos=target.Position end end);
    local changed2=UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local d=input.Position-startInput; target.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end);
    local ended=UIS.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end);
    return function() changed:Disconnect(); changed2:Disconnect(); ended:Disconnect() end
end
return M
