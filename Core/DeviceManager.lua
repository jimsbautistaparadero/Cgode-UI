return function(Cgode)
    local UIS=game:GetService("UserInputService")
    local M={}
    function M:Get() return Cgode:GetDevice() end
    function M:Capabilities()
        return {Touch=UIS.TouchEnabled,Keyboard=UIS.KeyboardEnabled,Mouse=UIS.MouseEnabled,Gamepad=UIS.GamepadEnabled}
    end
    return M
end
