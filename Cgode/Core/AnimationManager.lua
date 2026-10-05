return function(Cgode)
    local TweenService = game:GetService("TweenService")
    local M = {Active={}}
    function M:Tween(instance, duration, properties, style, direction)
        assert(instance and instance:IsDescendantOf(game), "Cgode AnimationManager: invalid instance")
        local info = TweenInfo.new(duration or .2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
        local tween = TweenService:Create(instance, info, properties or {})
        table.insert(self.Active, tween)
        tween.Completed:Connect(function()
            for i, item in ipairs(self.Active) do if item == tween then table.remove(self.Active,i); break end end
        end)
        tween:Play()
        return tween
    end
    function M:Stop(tween) if tween then pcall(function() tween:Cancel() end) end end
    function M:Pulse(instance, color, duration)
        if not instance then return end
        local old = instance.BackgroundColor3
        local tween = self:Tween(instance, duration or .12, {BackgroundColor3=color})
        tween.Completed:Connect(function() if instance.Parent then self:Tween(instance, duration or .14, {BackgroundColor3=old}) end end)
        return tween
    end
    function M:Destroy()
        for _, tween in ipairs(self.Active) do pcall(function() tween:Cancel() end) end
        self.Active = {}
    end
    return M
end
