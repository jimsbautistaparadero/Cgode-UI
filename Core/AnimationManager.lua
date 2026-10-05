return function(Cgode)
    local M={}
    function M:Play(instance,properties,duration)
        local TweenService=game:GetService("TweenService")
        local t=TweenService:Create(instance,TweenInfo.new(duration or .15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties)
        t:Play();return t
    end
    function M:Fade(instance,visible,duration)
        return self:Play(instance,{BackgroundTransparency=visible and 0 or 1},duration)
    end
    return M
end
