return function(Cgode)
    local UIS=game:GetService("UserInputService")
    local RunService=game:GetService("RunService")
    local M={}
    function M:Get() return Cgode:GetDevice() end
    function M:Is(name) return self:Get()==name end
    function M:Capabilities()
        return {Touch=UIS.TouchEnabled,Keyboard=UIS.KeyboardEnabled,Mouse=UIS.MouseEnabled,Gamepad=UIS.GamepadEnabled,Viewport=Cgode:GetViewport()}
    end
    function M:Observe(callback)
        local last=self:Get()
        local conn=RunService.RenderStepped:Connect(function()
            local now=self:Get(); if now~=last then last=now; task.spawn(callback,now) end
        end)
        return conn
    end
    return M
end
