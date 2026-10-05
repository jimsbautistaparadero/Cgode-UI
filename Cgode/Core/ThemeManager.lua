return function(Cgode)
    local M = {}
    local function copy(source)
        local out = {}
        for k, v in pairs(source) do out[k] = v end
        return out
    end
    local base = {
        Background = Color3.fromRGB(17, 19, 24),
        Surface = Color3.fromRGB(24, 27, 34),
        Surface2 = Color3.fromRGB(32, 36, 45),
        Surface3 = Color3.fromRGB(40, 45, 55),
        Surface4 = Color3.fromRGB(48, 53, 64),
        Text = Color3.fromRGB(245, 247, 250),
        TextStrong = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(160, 169, 183),
        Border = Color3.fromRGB(63, 69, 82),
        BorderSoft = Color3.fromRGB(73, 80, 95),
        Accent = Color3.fromRGB(92, 136, 255),
        AccentSoft = Color3.fromRGB(55, 79, 140),
        AccentStrong = Color3.fromRGB(120, 155, 255),
        Success = Color3.fromRGB(71, 205, 131),
        Warning = Color3.fromRGB(241, 181, 77),
        Danger = Color3.fromRGB(235, 91, 91),
        Info = Color3.fromRGB(86, 173, 239),
        Shadow = Color3.fromRGB(0, 0, 0),
    }
    M.Presets = {
        Dark = copy(base),
        Light = {
            Background = Color3.fromRGB(244, 246, 249),
            Surface = Color3.fromRGB(255, 255, 255),
            Surface2 = Color3.fromRGB(236, 239, 244),
            Surface3 = Color3.fromRGB(222, 226, 233),
            Surface4 = Color3.fromRGB(214, 219, 228),
            Text = Color3.fromRGB(28, 31, 36),
            TextStrong = Color3.fromRGB(16, 19, 24),
            Muted = Color3.fromRGB(95, 103, 116),
            Border = Color3.fromRGB(205, 210, 219),
            BorderSoft = Color3.fromRGB(220, 224, 232),
            Accent = Color3.fromRGB(69, 111, 238),
            AccentSoft = Color3.fromRGB(188, 204, 255),
            AccentStrong = Color3.fromRGB(45, 90, 230),
            Success = Color3.fromRGB(39, 167, 101),
            Warning = Color3.fromRGB(202, 142, 25),
            Danger = Color3.fromRGB(202, 65, 65),
            Info = Color3.fromRGB(49, 134, 193),
            Shadow = Color3.fromRGB(0, 0, 0),
        },
    }
    M.Current = copy(M.Presets.Dark)
    M.Name = "Dark"
    M._listeners = {}
    function M:Register(name, theme)
        assert(type(name) == "string" and type(theme) == "table", "Cgode ThemeManager:Register(name, theme)")
        local merged = copy(M.Current)
        for k, v in pairs(theme) do merged[k] = v end
        M.Presets[name] = merged
        return merged
    end
    function M:Get() return M.Current end
    function M:GetName() return M.Name end
    function M:Bind(fn)
        table.insert(M._listeners, fn)
        return {Disconnect=function()
            for i, cb in ipairs(M._listeners) do if cb == fn then table.remove(M._listeners, i); break end end
        end}
    end
    function M:Set(theme)
        local nextTheme = theme
        local name = "Custom"
        if type(theme) == "string" then
            nextTheme = M.Presets[theme]
            name = theme
            assert(nextTheme, "Cgode ThemeManager: unknown theme " .. theme)
        end
        assert(type(nextTheme) == "table", "Cgode ThemeManager:Set expects a theme name or table")
        local merged = copy(M.Current)
        for k, v in pairs(nextTheme) do merged[k] = v end
        M.Current, M.Name = merged, name
        if Cgode.WindowManager and Cgode.WindowManager.RefreshAllThemes then Cgode.WindowManager:RefreshAllThemes() end
        for _, fn in ipairs(M._listeners) do task.spawn(function() pcall(fn, merged, name) end) end
        return merged
    end
    function M:Extend(theme)
        local merged = copy(M.Current)
        for k,v in pairs(theme or {}) do merged[k] = v end
        return merged
    end
    return M
end
