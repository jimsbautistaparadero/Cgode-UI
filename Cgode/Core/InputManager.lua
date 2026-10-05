return function(Cgode)
    local UIS = game:GetService("UserInputService")
    local M = {Bindings={}, Captures={}}
    function M:Bind(name, keyCode, callback, options)
        assert(type(name)=="string" and type(callback)=="function")
        self:Unbind(name)
        local connection = UIS.InputBegan:Connect(function(input, processed)
            if (options and options.IgnoreProcessed) == true and processed then return end
            if input.KeyCode == keyCode then task.spawn(callback, input, processed) end
        end)
        self.Bindings[name] = connection
        return {Disconnect=function() self:Unbind(name) end}
    end
    function M:Unbind(name)
        local c=self.Bindings[name]
        if c then pcall(function() c:Disconnect() end); self.Bindings[name]=nil end
    end
    function M:UnbindAll() for name in pairs(self.Bindings) do self:Unbind(name) end end
    function M:CaptureKey(promptCallback, callback)
        local done=false
        local conn
        conn=UIS.InputBegan:Connect(function(input, processed)
            if processed or done or input.KeyCode==Enum.KeyCode.Unknown then return end
            done=true; conn:Disconnect()
            if callback then task.spawn(callback,input.KeyCode) end
        end)
        self.Captures[conn]=true
        if promptCallback then task.spawn(promptCallback) end
        return {Cancel=function() if not done then done=true; conn:Disconnect() end end}
    end
    function M:IsKeyDown(keyCode) return UIS:IsKeyDown(keyCode) end
    function M:GetBindings() return self.Bindings end
    return M
end
