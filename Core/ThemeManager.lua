return function(Cgode)
    local M={Current={}}
    local Light={Background=Color3.fromRGB(245,247,250),Surface=Color3.fromRGB(255,255,255),Surface2=Color3.fromRGB(239,242,246),Border=Color3.fromRGB(220,224,230),Text=Color3.fromRGB(28,31,36),Muted=Color3.fromRGB(103,109,118),Accent=Color3.fromRGB(72,122,255),Danger=Color3.fromRGB(220,75,75),Success=Color3.fromRGB(53,166,103)}
    local Dark={Background=Color3.fromRGB(20,22,26),Surface=Color3.fromRGB(28,31,37),Surface2=Color3.fromRGB(35,39,46),Border=Color3.fromRGB(54,59,68),Text=Color3.fromRGB(238,241,245),Muted=Color3.fromRGB(155,161,171),Accent=Color3.fromRGB(92,135,255),Danger=Color3.fromRGB(235,92,92),Success=Color3.fromRGB(67,190,120)}
    M.Presets={Light=Light,Dark=Dark}
    M.Current=table.clone(Light)
    function M:Set(theme)
        if type(theme)=="string" then theme=self.Presets[theme] end
        if type(theme)=="table" then for k,v in pairs(theme) do self.Current[k]=v end end
        if Cgode.WindowManager then Cgode.WindowManager:RefreshTheme() end
        return self
    end
    function M:Get() return table.clone(self.Current) end
    return M
end
