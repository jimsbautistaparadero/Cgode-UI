return function(Cgode)
    local UIS=game:GetService("UserInputService")
    local M={Connections={}}
    function M:Connect(signal,fn)
        local c=signal:Connect(fn);table.insert(self.Connections,c);return c
    end
    function M:IsTouch() return UIS.TouchEnabled end
    function M:IsKeyboard() return UIS.KeyboardEnabled end
    function M:IsMouse() return UIS.MouseEnabled end
    function M:IsGamepad() return UIS.GamepadEnabled end
    function M:Cleanup()
        for _,c in ipairs(self.Connections) do pcall(function()c:Disconnect()end) end
        table.clear(self.Connections)
    end
    return M
end
