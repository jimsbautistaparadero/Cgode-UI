return function(Cgode)
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local M = {Windows = {}}
    local Window = {}
    Window.__index = Window
    local TabMethods = {}
    local ControlMethods = Cgode._fetch("Core/Controls.lua")(Cgode)

    local function theme()
        return Cgode.ThemeManager.Current
    end

    local function corner(x, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 10)
        c.Parent = x
        return c
    end

    local function stroke(x, role, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.Name = "CgodeStroke"
        s.Color = theme()[role or "Border"] or theme().Border
        s.Thickness = thickness or 1
        s.Transparency = transparency or 0
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = x
        return s
    end

    local function mark(x, role)
        x:SetAttribute("CgodeRole", role)
        local c = theme()[role]
        if not c then return x end
        if x:IsA("TextLabel") or x:IsA("TextButton") or x:IsA("TextBox") then
            x.TextColor3 = c
        end
        if x:IsA("Frame") or x:IsA("ScrollingFrame") or x:IsA("TextButton") then
            x.BackgroundColor3 = c
        end
        if x:IsA("UIStroke") then
            x.Color = c
        end
        return x
    end

    local function gradient(parent, aRole, bRole, rotation, transparency)
        local g = parent:FindFirstChild("CgodeGradient") or Instance.new("UIGradient")
        g.Name = "CgodeGradient"
        g:SetAttribute("CgodeGradientA", aRole)
        g:SetAttribute("CgodeGradientB", bRole)
        local a = theme()[aRole]
        local b = theme()[bRole]
        if a and b then
            g.Color = ColorSequence.new(a, b)
        end
        g.Rotation = rotation or 0
        if transparency then g.Transparency = transparency end
        g.Parent = parent
        return g
    end

    local function label(p, t, size, role, weight)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Text = tostring(t or "")
        l.Font = weight or Enum.Font.Gotham
        l.TextSize = size or 13
        l.TextColor3 = theme()[role or "Text"] or theme().Text
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Center
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Parent = p
        mark(l, role or "Text")
        return l
    end

    local function makeButton(p, t, opts)
        opts = opts or {}
        local b = Instance.new("TextButton")
        b.AutoButtonColor = false
        b.Text = tostring(t or "")
        b.Font = opts.Font or Enum.Font.GothamMedium
        b.TextSize = opts.TextSize or 13
        b.TextColor3 = theme().Text
        b.BackgroundColor3 = theme()[opts.Role or "Surface2"] or theme().Surface2
        b.BackgroundTransparency = opts.BackgroundTransparency or 0
        b.BorderSizePixel = 0
        b.TextXAlignment = opts.TextXAlignment or Enum.TextXAlignment.Left
        b.Parent = p
        b:SetAttribute("CgodeRole", opts.Role or "Surface2")
        corner(b, opts.CornerRadius or 8)
        stroke(b, "BorderSoft", 1, .15)

        local scale = Instance.new("UIScale")
        scale.Scale = 1
        scale.Parent = b

        local base = opts.Role or "Surface2"
        local hover = opts.HoverRole or "Surface3"
        local pressed = opts.PressedRole or "AccentSoft"
        local hovering = false
        local active = false

        local function paint(role, speed)
            local target = theme()[role] or theme().Surface2
            Cgode.AnimationManager:Tween(b, speed or .12, {BackgroundColor3 = target}, Enum.EasingStyle.Quad)
        end

        b.MouseEnter:Connect(function()
            hovering = true
            paint(hover, .1)
        end)
        b.MouseLeave:Connect(function()
            hovering = false
            paint(active and pressed or base, .14)
            Cgode.AnimationManager:Tween(scale, .12, {Scale = 1}, Enum.EasingStyle.Quad)
        end)
        b.MouseButton1Down:Connect(function()
            active = true
            paint(pressed, .07)
            Cgode.AnimationManager:Tween(scale, .08, {Scale = .975}, Enum.EasingStyle.Quad)
        end)
        b.MouseButton1Up:Connect(function()
            active = false
            paint(hovering and hover or base, .1)
            Cgode.AnimationManager:Tween(scale, .1, {Scale = 1}, Enum.EasingStyle.Quad)
        end)
        return b
    end

    local function makeShadow(gui, main)
        local shadow = Instance.new("Frame")
        shadow.Name = "CgodeShadow"
        shadow.AnchorPoint = Vector2.new(.5, .5)
        shadow.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset + 10)
        shadow.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset + 18, main.Size.Y.Scale, main.Size.Y.Offset + 18)
        shadow.BackgroundColor3 = theme().Shadow
        shadow.BackgroundTransparency = .78
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 1
        shadow.Parent = gui
        corner(shadow, 16)
        return shadow
    end

    local function updateShadow(window)
        if not window.Shadow or not window.Main then return end
        window.Shadow.Position = UDim2.new(window.Main.Position.X.Scale, window.Main.Position.X.Offset, window.Main.Position.Y.Scale, window.Main.Position.Y.Offset + 10)
        window.Shadow.Size = UDim2.new(window.Main.Size.X.Scale, window.Main.Size.X.Offset + 18, window.Main.Size.Y.Scale, window.Main.Size.Y.Offset + 18)
    end

    local function addThemeRefresh(window, fn)
        table.insert(window.UIRefreshers, fn)
    end

    local function updateTab(tab)
        local active = tab.Window.ActiveTab == tab
        tab.ActiveIndicator.Visible = active
        tab.Button.BackgroundColor3 = active and theme().Surface3 or theme().Surface2
        tab.Button.TextColor3 = active and theme().TextStrong or theme().Muted
        tab.IconLabel.TextColor3 = active and theme().Accent or theme().Muted
        tab.Badge.BackgroundColor3 = theme().AccentSoft
        tab.Badge.TextColor3 = theme().TextStrong
        if tab.Options.ActiveGradient ~= false then
            local g = tab.Button:FindFirstChild("CgodeTabGradient")
            if not g then
                g = Instance.new("UIGradient")
                g.Name = "CgodeTabGradient"
                g.Rotation = 90
                g.Parent = tab.Button
            end
            local c = theme().Surface3
            local d = theme().Surface2
            g.Color = ColorSequence.new(c, d)
            g.Enabled = active
        end
    end

    function M:Create(spec)
        local opt = spec.Options or {}
        local o = setmetatable({
            Title = tostring(spec.Title or "Cgode UI"),
            Name = tostring(spec.Name or "CgodeWindow"),
            Destroyed = false,
            Connections = {},
            Tabs = {},
            Options = opt,
            UIRefreshers = {},
        }, Window)

        o.Resizable = opt.Resizable ~= false
        o.MinSize = opt.MinSize or UDim2.fromOffset(420, 320)
        o.MaxSize = opt.MaxSize or UDim2.fromOffset(1100, 760)
        o.SidebarWidth = opt.SidebarWidth or 168
        o.Responsive = opt.Responsive ~= false

        local gui = Instance.new("ScreenGui")
        gui.Name = o.Name
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = opt.DisplayOrder or 100
        gui.Parent = Cgode:GetGuiParent()
        o.Gui = gui

        local main = Instance.new("Frame")
        main.Name = "Window"
        main.AnchorPoint = Vector2.new(.5, .5)
        main.Position = opt.Position or UDim2.fromScale(.5, .5)
        main.Size = opt.Size or UDim2.fromOffset(680, 500)
        main.BackgroundColor3 = theme().Background
        main.BorderSizePixel = 0
        main.ClipsDescendants = true
        main.ZIndex = 10
        main.Parent = gui
        mark(main, "Background")
        corner(main, opt.CornerRadius or 14)
        stroke(main, "Border", 1, .08)
        local outerStroke = stroke(main, "Accent", 1, .72)
        outerStroke.Name = "CgodeAccentGlow"
        o.Main = main

        o.Shadow = makeShadow(gui, main)
        local bodyGradient = gradient(main, "Background", "Surface", 90)
        bodyGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, .06),
            NumberSequenceKeypoint.new(1, .18),
        })

        local top = Instance.new("Frame")
        top.Name = "Header"
        top.Size = UDim2.new(1, 0, 0, opt.HeaderHeight or 56)
        top.BackgroundColor3 = theme().Surface
        top.BorderSizePixel = 0
        top.ZIndex = 12
        top.Parent = main
        mark(top, "Surface")
        gradient(top, "Surface", "Surface2", 0)
        o.Top = top

        local accentLine = Instance.new("Frame")
        accentLine.Name = "AccentLine"
        accentLine.Size = UDim2.new(1, 0, 0, 2)
        accentLine.Position = UDim2.new(0, 0, 1, -2)
        accentLine.BackgroundColor3 = theme().Accent
        accentLine.BorderSizePixel = 0
        accentLine.ZIndex = 15
        accentLine.Parent = top
        mark(accentLine, "Accent")
        gradient(accentLine, "Accent", "Info", 0)
        o.AccentLine = accentLine

        local brand = Instance.new("Frame")
        brand.Name = "BrandMark"
        brand.Size = UDim2.fromOffset(34, 34)
        brand.Position = UDim2.fromOffset(12, 11)
        brand.BackgroundColor3 = theme().AccentSoft
        brand.BorderSizePixel = 0
        brand.ZIndex = 14
        brand.Parent = top
        mark(brand, "AccentSoft")
        corner(brand, 10)
        gradient(brand, "Accent", "AccentSoft", 45)
        local glyph = label(brand, opt.Icon or "✦", 16, "TextStrong", Enum.Font.GothamBold)
        glyph.Size = UDim2.fromScale(1, 1)
        glyph.TextXAlignment = Enum.TextXAlignment.Center
        glyph.TextYAlignment = Enum.TextYAlignment.Center
        glyph.ZIndex = 16

        local title = label(top, o.Title, opt.TitleSize or 15, "TextStrong", Enum.Font.GothamBold)
        title.Position = UDim2.fromOffset(56, 7)
        title.Size = UDim2.new(1, -250, 0, 24)
        title.ZIndex = 14
        o.TitleLabel = title

        local subtitle = label(top, opt.Subtitle or "CGODE UI", 10, "Muted", Enum.Font.GothamMedium)
        subtitle.Position = UDim2.fromOffset(57, 29)
        subtitle.Size = UDim2.new(1, -250, 0, 17)
        subtitle.ZIndex = 14
        o.SubtitleLabel = subtitle

        local status = Instance.new("Frame")
        status.Name = "StatusPill"
        status.AnchorPoint = Vector2.new(1, .5)
        status.Position = UDim2.new(1, -128, .5, 0)
        status.Size = UDim2.fromOffset(74, 26)
        status.BackgroundColor3 = theme().Surface2
        status.BorderSizePixel = 0
        status.ZIndex = 14
        status.Parent = top
        mark(status, "Surface2")
        corner(status, 13)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(7, 7)
        dot.Position = UDim2.fromOffset(9, 9)
        dot.BackgroundColor3 = theme().Success
        dot.BorderSizePixel = 0
        dot.ZIndex = 16
        dot.Parent = status
        mark(dot, "Success")
        corner(dot, 4)
        local statusText = label(status, opt.StatusText or "READY", 9, "Muted", Enum.Font.GothamBold)
        statusText.Position = UDim2.fromOffset(21, 0)
        statusText.Size = UDim2.new(1, -25, 1, 0)
        statusText.ZIndex = 16
        o.StatusDot = dot
        o.StatusLabel = statusText

        local controls = Instance.new("Frame")
        controls.Name = "WindowControls"
        controls.AnchorPoint = Vector2.new(1, .5)
        controls.Position = UDim2.new(1, -9, .5, 0)
        controls.Size = UDim2.fromOffset(112, 38)
        controls.BackgroundTransparency = 1
        controls.ZIndex = 15
        controls.Parent = top

        local minimize = makeButton(controls, "—", {Role = "Surface2", HoverRole = "Surface3", TextXAlignment = Enum.TextXAlignment.Center, TextSize = 16, CornerRadius = 9})
        minimize.Name = "Minimize"
        minimize.Size = UDim2.fromOffset(32, 32)
        minimize.Position = UDim2.fromOffset(0, 3)

        local maximize = makeButton(controls, "□", {Role = "Surface2", HoverRole = "Surface3", TextXAlignment = Enum.TextXAlignment.Center, TextSize = 14, CornerRadius = 9})
        maximize.Name = "Maximize"
        maximize.Size = UDim2.fromOffset(32, 32)
        maximize.Position = UDim2.fromOffset(38, 3)

        local close = makeButton(controls, "×", {Role = "Surface2", HoverRole = "Danger", PressedRole = "Danger", TextXAlignment = Enum.TextXAlignment.Center, TextSize = 18, CornerRadius = 9})
        close.Name = "Close"
        close.Size = UDim2.fromOffset(32, 32)
        close.Position = UDim2.fromOffset(76, 3)

        o:Track(minimize.MouseButton1Click:Connect(function() o:Minimize() end))
        o:Track(maximize.MouseButton1Click:Connect(function() o:Maximize() end))
        o:Track(close.MouseButton1Click:Connect(function() o:Destroy() end))

        local side = Instance.new("Frame")
        side.Name = "Sidebar"
        side.Position = UDim2.fromOffset(0, top.Size.Y.Offset)
        side.Size = UDim2.new(0, o.SidebarWidth, 1, -top.Size.Y.Offset)
        side.BackgroundColor3 = theme().Surface
        side.BorderSizePixel = 0
        side.ZIndex = 11
        side.Parent = main
        mark(side, "Surface")
        o.Side = side

        local sideAccent = Instance.new("Frame")
        sideAccent.Size = UDim2.fromOffset(2, 1)
        sideAccent.Position = UDim2.fromOffset(o.SidebarWidth - 2, 0)
        sideAccent.BackgroundColor3 = theme().Border
        sideAccent.BorderSizePixel = 0
        sideAccent.ZIndex = 13
        sideAccent.Parent = side
        mark(sideAccent, "Border")
        o.SideAccent = sideAccent

        local navHeader = label(side, opt.SidebarHeader or "NAVIGATION", 9, "Muted", Enum.Font.GothamBold)
        navHeader.Position = UDim2.fromOffset(13, 10)
        navHeader.Size = UDim2.new(1, -26, 0, 18)
        navHeader.ZIndex = 14

        local tabs = Instance.new("ScrollingFrame")
        tabs.Name = "Tabs"
        tabs.Position = UDim2.fromOffset(9, 31)
        tabs.Size = UDim2.new(1, -18, 1, -74)
        tabs.BackgroundTransparency = 1
        tabs.BorderSizePixel = 0
        tabs.ScrollBarThickness = 3
        tabs.ScrollBarImageColor3 = theme().Accent
        tabs.ZIndex = 13
        tabs.Parent = side
        o.TabList = tabs

        local tl = Instance.new("UIListLayout")
        tl.Padding = UDim.new(0, 6)
        tl.SortOrder = Enum.SortOrder.LayoutOrder
        tl.Parent = tabs
        o:Track(tl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabs.CanvasSize = UDim2.new(0, 0, 0, tl.AbsoluteContentSize.Y + 10)
        end))

        local footer = Instance.new("Frame")
        footer.Name = "SidebarFooter"
        footer.AnchorPoint = Vector2.new(0, 1)
        footer.Position = UDim2.new(0, 9, 1, -10)
        footer.Size = UDim2.new(1, -18, 0, 28)
        footer.BackgroundColor3 = theme().Surface2
        footer.BorderSizePixel = 0
        footer.ZIndex = 13
        footer.Parent = side
        mark(footer, "Surface2")
        corner(footer, 9)
        local footerLabel = label(footer, opt.SidebarFooter or "v4 • polished", 9, "Muted", Enum.Font.GothamMedium)
        footerLabel.Size = UDim2.fromScale(1, 1)
        footerLabel.TextXAlignment = Enum.TextXAlignment.Center
        footerLabel.ZIndex = 15
        o.SidebarFooter = footer

        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Position = UDim2.fromOffset(o.SidebarWidth, top.Size.Y.Offset)
        content.Size = UDim2.new(1, -o.SidebarWidth, 1, -top.Size.Y.Offset)
        content.BackgroundColor3 = theme().Background
        content.BorderSizePixel = 0
        content.ClipsDescendants = true
        content.ZIndex = 11
        content.Parent = main
        mark(content, "Background")
        o.Content = content
        o.Pages = Instance.new("Folder")
        o.Pages.Name = "Pages"
        o.Pages.Parent = content

        if opt.ShowSidebar == false then
            side.Visible = false
            content.Position = UDim2.fromOffset(0, top.Size.Y.Offset)
            content.Size = UDim2.new(1, 0, 1, -top.Size.Y.Offset)
        end

        if spec.Draggable ~= false then o:EnableDragging(top, main) end
        if o.Resizable then o:EnableResize(main) end

        o._StatusKind = "Success"
        addThemeRefresh(o, function()
            updateShadow(o)
            local g = main:FindFirstChild("CgodeGradient")
            if g then g.Color = ColorSequence.new(theme().Background, theme().Surface) end
            local tg = top:FindFirstChild("CgodeGradient")
            if tg then tg.Color = ColorSequence.new(theme().Surface, theme().Surface2) end
            if o.StatusDot then o.StatusDot.BackgroundColor3 = theme()[o._StatusKind or "Success"] or theme().Success end
            for _, t in ipairs(o.Tabs) do updateTab(t) end
        end)

        o:Track(UIS.InputBegan:Connect(function(input, processed)
            if processed or o.Destroyed then return end
            if input.KeyCode == (opt.ToggleKey or Enum.KeyCode.RightShift) then o:Toggle() end
        end))

        local camera = workspace.CurrentCamera
        if o.Responsive and camera then
            o:Track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() o:ApplyResponsive() end))
        end
        o:ApplyResponsive()
        table.insert(self.Windows, o)
        self.Active = o
        o:Focus()
        return o
    end

    function Window:Track(conn)
        if conn then table.insert(self.Connections, conn) end
        return conn
    end

    function Window:Connect(conn)
        return self:Track(conn)
    end

    function Window:OnThemeRefresh(fn)
        if type(fn) == "function" then table.insert(self.UIRefreshers, fn) end
        return fn
    end

    function Window:EnableDragging(handle, main)
        local dragging = false
        local start
        local startPos
        self:Track(handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = i.Position
                startPos = main.Position
                self:Focus()
            end
        end))
        self:Track(UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - start
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                updateShadow(self)
            end
        end))
        self:Track(UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end))
    end

    function Window:EnableResize(main)
        local grip = Instance.new("TextButton")
        grip.Name = "ResizeGrip"
        grip.Text = ""
        grip.BackgroundTransparency = 1
        grip.Size = UDim2.fromOffset(22, 22)
        grip.Position = UDim2.new(1, -22, 1, -22)
        grip.ZIndex = 30
        grip.Parent = main

        for i = 1, 3 do
            local line = Instance.new("Frame")
            line.Size = UDim2.fromOffset(10, 1)
            line.Position = UDim2.new(1, -11, 1, -3 - (i * 4))
            line.Rotation = -45
            line.BackgroundColor3 = theme().Muted
            line.BorderSizePixel = 0
            line.ZIndex = 31
            line.Parent = grip
            mark(line, "Muted")
        end

        local resizing = false
        local start
        local startSize
        self:Track(grip.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                start = i.Position
                startSize = main.AbsoluteSize
                self:Focus()
            end
        end))
        self:Track(UIS.InputChanged:Connect(function(i)
            if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - start
                local minX, maxX = self.MinSize.X.Offset, self.MaxSize.X.Offset
                local minY, maxY = self.MinSize.Y.Offset, self.MaxSize.Y.Offset
                local x = math.clamp(startSize.X + d.X, minX, maxX)
                local y = math.clamp(startSize.Y + d.Y, minY, maxY)
                main.Size = UDim2.fromOffset(x, y)
                updateShadow(self)
            end
        end))
        self:Track(UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then resizing = false end
        end))
    end

    function Window:ApplyResponsive()
        if not self.Responsive or self.Destroyed or not self.Main then return end
        local viewport = Cgode:GetViewport()
        local device = Cgode:GetDevice()
        if self.Options.ShowSidebar ~= false then
            local width = self.Options.SidebarWidth or 168
            if device == "Mobile" then width = math.min(width, 124)
            elseif device == "Tablet" then width = math.min(width, 148) end
            self.Side.Size = UDim2.new(0, width, 1, -self.Top.Size.Y.Offset)
            local visibleWidth = math.max(280, viewport.X - 20)
            local visibleHeight = math.max(240, viewport.Y - 20)
            if device == "Mobile" then
                local current = self.Main.AbsoluteSize
                self.Main.Size = UDim2.fromOffset(math.min(math.max(current.X, self.MinSize.X.Offset), visibleWidth), math.min(math.max(current.Y, self.MinSize.Y.Offset), visibleHeight))
            end
            self.Content.Position = UDim2.fromOffset(width, self.Top.Size.Y.Offset)
            self.Content.Size = UDim2.new(1, -width, 1, -self.Top.Size.Y.Offset)
            self.SideAccent.Position = UDim2.fromOffset(width - 2, 0)
        end
        if self.TitleLabel then self.TitleLabel.TextSize = device == "Mobile" and 13 or (self.Options.TitleSize or 15) end
        updateShadow(self)
    end

    function Window:createTab(name, options)
        options = options or {}
        local t = setmetatable({Window = self, Name = tostring(name or "Tab"), Sections = {}, Options = options}, {__index = TabMethods})
        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. t.Name:gsub("%W", "")
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.fromScale(1, 1)
        page.Visible = false
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = theme().Accent
        page.ZIndex = 12
        page.Parent = self.Pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        self:Track(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 34)
        end))

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 16)
        pad.PaddingBottom = UDim.new(0, 18)
        pad.PaddingLeft = UDim.new(0, 16)
        pad.PaddingRight = UDim.new(0, 16)
        pad.Parent = page

        local pageHead = Instance.new("Frame")
        pageHead.Name = "PageHeader"
        pageHead.Size = UDim2.new(1, 0, 0, options.Description and 58 or 38)
        pageHead.BackgroundTransparency = 1
        pageHead.Parent = page
        local pageTitle = label(pageHead, options.Title or t.Name, 20, "TextStrong", Enum.Font.GothamBold)
        pageTitle.Size = UDim2.new(1, 0, 0, 28)
        pageTitle.ZIndex = 14
        if options.Description then
            local desc = label(pageHead, options.Description, 10, "Muted", Enum.Font.Gotham)
            desc.Position = UDim2.fromOffset(0, 29)
            desc.Size = UDim2.new(1, 0, 0, 22)
            desc.ZIndex = 14
        end

        local nav = Instance.new("TextButton")
        nav.Name = "Tab"
        nav.AutoButtonColor = false
        nav.Text = ""
        nav.Size = UDim2.new(1, 0, 0, options.Height or 42)
        nav.BackgroundColor3 = theme().Surface2
        nav.BorderSizePixel = 0
        nav.ZIndex = 15
        nav.Parent = self.TabList
        mark(nav, "Surface2")
        corner(nav, 10)
        stroke(nav, "BorderSoft", 1, .22)

        local indicator = Instance.new("Frame")
        indicator.Name = "ActiveIndicator"
        indicator.Size = UDim2.fromOffset(3, 24)
        indicator.Position = UDim2.new(0, 0, .5, -12)
        indicator.BackgroundColor3 = theme().Accent
        indicator.BorderSizePixel = 0
        indicator.ZIndex = 18
        indicator.Parent = nav
        mark(indicator, "Accent")
        corner(indicator, 3)

        local icon = label(nav, options.Icon or "•", 13, "Muted", Enum.Font.GothamBold)
        icon.Position = UDim2.fromOffset(13, 0)
        icon.Size = UDim2.fromOffset(20, nav.Size.Y.Offset)
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.ZIndex = 18

        local text = label(nav, t.Name, 11, "Muted", Enum.Font.GothamMedium)
        text.Position = UDim2.fromOffset(38, 0)
        text.Size = UDim2.new(1, -80, 1, 0)
        text.ZIndex = 18

        local badge = Instance.new("TextLabel")
        badge.Name = "Badge"
        badge.BackgroundColor3 = theme().AccentSoft
        badge.BackgroundTransparency = options.Badge and 0 or 1
        badge.Text = options.Badge and tostring(options.Badge) or ""
        badge.TextColor3 = theme().TextStrong
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 9
        badge.TextXAlignment = Enum.TextXAlignment.Center
        badge.Size = UDim2.fromOffset(28, 20)
        badge.Position = UDim2.new(1, -34, .5, -10)
        badge.ZIndex = 18
        badge.Parent = nav
        corner(badge, 8)
        if options.Badge then mark(badge, "AccentSoft") end

        t.Page = page
        t.Button = nav
        t.ActiveIndicator = indicator
        t.IconLabel = icon
        t.ButtonText = text
        t.Badge = badge
        self:Track(nav.MouseButton1Click:Connect(function() self:SelectTab(t) end))
        table.insert(self.Tabs, t)
        addThemeRefresh(self, function() updateTab(t) end)
        if not self.ActiveTab then self:SelectTab(t) end
        return t
    end

    Window.CreateTab = Window.createTab

    function Window:SelectTab(tab)
        self.ActiveTab = tab
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = t == tab
            updateTab(t)
        end
        return tab
    end
    Window.selectTab = Window.SelectTab

    function TabMethods:createSection(name, collapsed, options)
        options = options or {}
        local section = setmetatable({
            Tab = self,
            Window = self.Window,
            Name = tostring(name or "Section"),
            Collapsed = collapsed == true,
            Options = options,
            Sections = {},
        }, {__index = ControlMethods})

        local f = Instance.new("Frame")
        f.Name = "Section_" .. section.Name:gsub("%W", "")
        f.BackgroundColor3 = theme().Surface
        f.BorderSizePixel = 0
        f.Size = UDim2.new(1, 0, 0, 48)
        f.AutomaticSize = Enum.AutomaticSize.Y
        f.Parent = self.Page
        mark(f, "Surface")
        corner(f, options.CornerRadius or 11)
        stroke(f, "BorderSoft", 1, .14)

        local accent = Instance.new("Frame")
        accent.Size = UDim2.fromOffset(3, 24)
        accent.Position = UDim2.fromOffset(0, 11)
        accent.BackgroundColor3 = theme().Accent
        accent.BorderSizePixel = 0
        accent.Parent = f
        mark(accent, "Accent")
        corner(accent, 3)

        local title = makeButton(f, "", {Role = "Surface", HoverRole = "Surface2", TextXAlignment = Enum.TextXAlignment.Left, CornerRadius = 11})
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 42)
        title.Text = ""
        title.ZIndex = 14

        local chevron = label(title, section.Collapsed and "›" or "⌄", 16, "Accent", Enum.Font.GothamBold)
        chevron.Position = UDim2.fromOffset(12, 0)
        chevron.Size = UDim2.fromOffset(18, 42)
        chevron.TextXAlignment = Enum.TextXAlignment.Center
        chevron.ZIndex = 16

        local titleLabel = label(title, section.Name, 12, "TextStrong", Enum.Font.GothamBold)
        titleLabel.Position = UDim2.fromOffset(35, 0)
        titleLabel.Size = UDim2.new(1, options.Description and -180 or -50, 0, 42)
        titleLabel.ZIndex = 16

        if options.Description then
            local desc = label(title, options.Description, 9, "Muted")
            desc.Position = UDim2.new(1, -140, 0, 0)
            desc.Size = UDim2.fromOffset(125, 42)
            desc.TextXAlignment = Enum.TextXAlignment.Right
            desc.ZIndex = 16
            section.DescriptionLabel = desc
        end

        local content = Instance.new("Frame")
        content.BackgroundTransparency = 1
        content.Size = UDim2.new(1, 0, 0, 0)
        content.AutomaticSize = Enum.AutomaticSize.Y
        content.Visible = not section.Collapsed
        content.Parent = f

        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 8)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = content
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 5)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 11)
        pad.PaddingRight = UDim.new(0, 11)
        pad.Parent = content

        section.Content = content
        section.Frame = f
        section.TitleButton = title
        section.Chevron = chevron
        section.TitleLabel = titleLabel
        self.Sections[#self.Sections + 1] = section

        self.Window:Track(title.MouseButton1Click:Connect(function()
            section.Collapsed = not section.Collapsed
            content.Visible = not section.Collapsed
            chevron.Text = section.Collapsed and "›" or "⌄"
        end))
        return section
    end

    TabMethods.CreateSection = TabMethods.createSection

    function TabMethods:createText(text)
        local section = self._autoSection or self:createSection("Content", false)
        self._autoSection = section
        return section:createText(text)
    end
    TabMethods.CreateText = TabMethods.createText

    function TabMethods:_section()
        self._autoSection = self._autoSection or self:createSection("Controls", false)
        return self._autoSection
    end

    local forwarded = {
        "Button","IconButton","Toggle","Checkbox","Radio","RadioGroup","Slider","NumberInput","TextBox","Dropdown","MultiDropdown","KeyBind","ColorPicker","Badge","Link","Image","CodeBlock","SearchBox","ComboBox","CommandPalette","ContextMenu","Accordion","SegmentedControl","TagInput","Stepper","RangeSlider","XYPad","TreeView","DatePicker","TimePicker","Autocomplete","Pagination","Rating","Breadcrumbs","Popover","List","VirtualList","DataGrid","Table","Statistics","ActivityFeed","Timeline","Sparkline","BarChart","LogViewer","Container","Stack","Row","Column","Grid","ResponsiveGrid","SplitPane","ScrollContainer","Overlay","Card","Panel","Loading","Spinner","Skeleton","Progress","Notification","Toast","Dialog","ConfirmDialog","Tooltip","EmptyState","ErrorState","Banner"
    }

    for _, name in ipairs(forwarded) do
        local lower = name:sub(1, 1):lower() .. name:sub(2)
        TabMethods[lower] = function(self, ...)
            local section = self:_section()
            return section["create" .. name](section, ...)
        end
        TabMethods[name] = TabMethods[lower]
    end

    function Window:notification(titleText, messageText, duration, kind)
        local stack = self.Gui:FindFirstChild("CgodeNotifications")
        if not stack then
            stack = Instance.new("Frame")
            stack.Name = "CgodeNotifications"
            stack.BackgroundTransparency = 1
            stack.AnchorPoint = Vector2.new(1, 1)
            stack.Position = UDim2.new(1, -18, 1, -18)
            stack.Size = UDim2.fromOffset(360, 420)
            stack.ZIndex = 100
            stack.Parent = self.Gui
            local layout = Instance.new("UIListLayout")
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.Padding = UDim.new(0, 9)
            layout.Parent = stack
        end

        local accentRole = kind == "danger" and "Danger" or kind == "warning" and "Warning" or kind == "success" and "Success" or "Info"
        local h = Instance.new("Frame")
        h.Name = "Toast"
        h.Size = UDim2.fromOffset(344, 76)
        h.BackgroundColor3 = theme().Surface
        h.BorderSizePixel = 0
        h.ZIndex = 102
        h.Parent = stack
        mark(h, "Surface")
        corner(h, 12)
        stroke(h, "BorderSoft", 1, .1)
        local stripe = Instance.new("Frame")
        stripe.Size = UDim2.fromOffset(3, 46)
        stripe.Position = UDim2.fromOffset(0, 15)
        stripe.BackgroundColor3 = theme()[accentRole]
        stripe.BorderSizePixel = 0
        stripe.ZIndex = 105
        stripe.Parent = h
        mark(stripe, accentRole)
        corner(stripe, 2)
        local title = label(h, titleText or "Notification", 12, "TextStrong", Enum.Font.GothamBold)
        title.Position = UDim2.fromOffset(15, 11)
        title.Size = UDim2.new(1, -28, 0, 20)
        title.ZIndex = 105
        local msg = label(h, messageText or "", 10, "Muted")
        msg.Position = UDim2.fromOffset(15, 32)
        msg.Size = UDim2.new(1, -28, 0, 30)
        msg.TextWrapped = true
        msg.ZIndex = 105

        h.Position = UDim2.fromOffset(30, 0)
        h.BackgroundTransparency = 1
        Cgode.AnimationManager:Tween(h, .2, {Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0}, Enum.EasingStyle.Quint)
        task.delay(duration or 3, function()
            if not h.Parent then return end
            local tween = Cgode.AnimationManager:Tween(h, .18, {Position = UDim2.fromOffset(24, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
            tween.Completed:Connect(function()
                if h.Parent then h:Destroy() end
            end)
        end)
        return h
    end

    Window.Notify = Window.notification
    M.Notify = function(self, titleText, messageText, duration, kind)
        if self.Active then return self.Active:notification(titleText, messageText, duration, kind) end
    end

    function Window:ShowDialog(titleText, messageText, buttons)
        local overlay = Instance.new("Frame")
        overlay.Name = "CgodeModal"
        overlay.BackgroundColor3 = theme().Shadow
        overlay.BackgroundTransparency = .45
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.ZIndex = 200
        overlay.Parent = self.Gui

        local box = Instance.new("Frame")
        box.AnchorPoint = Vector2.new(.5, .5)
        box.Position = UDim2.fromScale(.5, .53)
        box.Size = UDim2.fromOffset(410, 216)
        box.BackgroundColor3 = theme().Surface
        box.BorderSizePixel = 0
        box.ZIndex = 205
        box.Parent = overlay
        mark(box, "Surface")
        corner(box, 14)
        stroke(box, "BorderSoft", 1, .08)
        gradient(box, "Surface", "Surface2", 90)

        local icon = Instance.new("Frame")
        icon.Size = UDim2.fromOffset(34, 34)
        icon.Position = UDim2.fromOffset(18, 18)
        icon.BackgroundColor3 = theme().AccentSoft
        icon.BorderSizePixel = 0
        icon.ZIndex = 210
        icon.Parent = box
        mark(icon, "AccentSoft")
        corner(icon, 10)
        local iconText = label(icon, "!", 15, "TextStrong", Enum.Font.GothamBold)
        iconText.Size = UDim2.fromScale(1, 1)
        iconText.TextXAlignment = Enum.TextXAlignment.Center
        iconText.ZIndex = 212

        local title = label(box, titleText, 15, "TextStrong", Enum.Font.GothamBold)
        title.Position = UDim2.fromOffset(64, 16)
        title.Size = UDim2.new(1, -84, 0, 28)
        title.ZIndex = 210
        local msg = label(box, messageText, 11, "Muted")
        msg.Position = UDim2.fromOffset(18, 62)
        msg.Size = UDim2.new(1, -36, 0, 88)
        msg.TextWrapped = true
        msg.ZIndex = 210

        local list = buttons or {{Text = "OK"}}
        for i, item in ipairs(list) do
            local b = makeButton(box, item.Text or tostring(item), {Role = i == #list and "Accent" or "Surface2", HoverRole = i == #list and "Accent" or "Surface3", PressedRole = i == #list and "AccentSoft" or "Surface3", TextXAlignment = Enum.TextXAlignment.Center, CornerRadius = 9})
            b.Size = UDim2.fromOffset(102, 34)
            b.Position = UDim2.new(1, -114 - (i - 1) * 110, 1, -48)
            b.ZIndex = 211
            b.MouseButton1Click:Connect(function()
                if item.Callback then task.spawn(item.Callback) end
                if item.Close ~= false and overlay.Parent then overlay:Destroy() end
            end)
        end

        box.Position = UDim2.fromScale(.5, .56)
        box.BackgroundTransparency = 1
        Cgode.AnimationManager:Tween(box, .18, {Position = UDim2.fromScale(.5, .5), BackgroundTransparency = 0}, Enum.EasingStyle.Quint)
        return overlay
    end

    function Window:ShowConfirm(titleText, messageText, onConfirm, onCancel)
        return self:ShowDialog(titleText, messageText, {
            {Text = "Cancel", Callback = onCancel},
            {Text = "Confirm", Callback = onConfirm},
        })
    end

    function Window:ShowCommandPalette(items, callback, commands)
        local overlay = self:ShowDialog("Command Palette", "Choose an action", {})
        local box = overlay:FindFirstChildOfClass("Frame")
        local search = Instance.new("TextBox")
        search.PlaceholderText = "Search commands..."
        search.Text = ""
        search.ClearTextOnFocus = false
        search.Font = Enum.Font.Gotham
        search.TextSize = 11
        search.TextColor3 = theme().Text
        search.BackgroundColor3 = theme().Surface2
        search.BorderSizePixel = 0
        search.Position = UDim2.fromOffset(16, 88)
        search.Size = UDim2.new(1, -32, 0, 32)
        search.ZIndex = 214
        search.Parent = box
        mark(search, "Surface2")
        corner(search, 9)
        stroke(search, "BorderSoft", 1, .18)
        local list = Instance.new("ScrollingFrame")
        list.BackgroundTransparency = 1
        list.BorderSizePixel = 0
        list.Position = UDim2.fromOffset(16, 128)
        list.Size = UDim2.new(1, -32, 0, 60)
        list.ScrollBarThickness = 3
        list.ZIndex = 214
        list.Parent = box
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.Parent = list
        for i, item in ipairs(items or {}) do
            local b = makeButton(list, item, {Role = "Surface2", HoverRole = "Surface3", TextXAlignment = Enum.TextXAlignment.Left, CornerRadius = 8})
            b.Size = UDim2.new(1, 0, 0, 30)
            b.ZIndex = 216
            b.MouseButton1Click:Connect(function()
                if commands and commands[i] and commands[i].callback then task.spawn(commands[i].callback) end
                if callback then task.spawn(callback, item, i) end
                overlay:Destroy()
            end)
        end
        return overlay
    end

    function Window:ShowContextMenu(items, callback)
        local overlay = Instance.new("Frame")
        overlay.BackgroundTransparency = 1
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.ZIndex = 250
        overlay.Parent = self.Gui
        local menu = Instance.new("Frame")
        menu.AnchorPoint = Vector2.new(.5, .5)
        menu.Position = UDim2.fromScale(.5, .5)
        menu.Size = UDim2.fromOffset(250, math.min(340, 18 + #items * 34))
        menu.BackgroundColor3 = theme().Surface
        menu.BorderSizePixel = 0
        menu.ZIndex = 252
        menu.Parent = overlay
        mark(menu, "Surface")
        corner(menu, 12)
        stroke(menu, "BorderSoft", 1, .08)
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 7)
        pad.PaddingBottom = UDim.new(0, 7)
        pad.PaddingLeft = UDim.new(0, 7)
        pad.PaddingRight = UDim.new(0, 7)
        pad.Parent = menu
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.Parent = menu
        for i, item in ipairs(items or {}) do
            local b = makeButton(menu, item.Text or tostring(item), {Role = "Surface", HoverRole = "Surface2", TextXAlignment = Enum.TextXAlignment.Left})
            b.Size = UDim2.new(1, 0, 0, 31)
            b.ZIndex = 255
            b.MouseButton1Click:Connect(function()
                if callback then task.spawn(callback, item, i) end
                overlay:Destroy()
            end)
        end
        return overlay
    end

    function Window:Focus()
        if self.Gui then
            self.Gui.DisplayOrder = math.max(self.Gui.DisplayOrder, 200)
            self.Gui.Enabled = true
        end
        for _, w in ipairs(M.Windows) do
            if w ~= self and w.Gui then w.Gui.DisplayOrder = math.min(w.Gui.DisplayOrder, 150) end
        end
        M.Active = self
    end

    function Window:SetTitle(value)
        self.Title = tostring(value)
        if self.TitleLabel then self.TitleLabel.Text = self.Title end
        return self
    end

    function Window:SetSubtitle(value)
        if self.SubtitleLabel then self.SubtitleLabel.Text = tostring(value or "") end
        return self
    end

    function Window:SetStatus(text, kind)
        self._StatusKind = kind or self._StatusKind or "Success"
        if self.StatusLabel then self.StatusLabel.Text = tostring(text or "READY") end
        if self.StatusDot then
            self.StatusDot.BackgroundColor3 = theme()[self._StatusKind] or theme().Success
        end
        return self
    end

    function Window:Center()
        if self.Main then self.Main.Position = UDim2.fromScale(.5, .5); updateShadow(self) end
        return self
    end

    function Window:SetPosition(pos)
        self.Main.Position = pos
        updateShadow(self)
        return self
    end

    function Window:GetPosition()
        return self.Main.Position
    end

    function Window:SetSize(size)
        self.Main.Size = size
        updateShadow(self)
        return self
    end

    function Window:GetSize()
        return self.Main.Size
    end

    function Window:SetVisible(v)
        self.Gui.Enabled = v
        return self
    end

    function Window:IsVisible()
        return self.Gui.Enabled
    end

    function Window:Toggle()
        self.Gui.Enabled = not self.Gui.Enabled
        if self.Gui.Enabled then self:Focus() end
        return self
    end

    function Window:Minimize()
        if self._savedSize then
            return self:Restore()
        end
        self._savedSize = self.Main.Size
        self.Content.Visible = false
        self.Side.Visible = false
        self.StatusLabel.Text = "MIN"
        self.Main.Size = UDim2.fromOffset(math.max(self.MinSize.X.Offset, 420), self.Top.Size.Y.Offset)
        updateShadow(self)
        return self
    end

    function Window:Maximize()
        local viewport = Cgode:GetViewport()
        self._savedSize = self._savedSize or self.Main.Size
        self.Main.Position = UDim2.fromScale(.5, .5)
        self.Main.Size = UDim2.fromOffset(
            math.min(self.MaxSize.X.Offset, math.max(self.MinSize.X.Offset, viewport.X - 32)),
            math.min(self.MaxSize.Y.Offset, math.max(self.MinSize.Y.Offset, viewport.Y - 32))
        )
        self.Content.Visible = true
        self.Side.Visible = self.Options.ShowSidebar ~= false
        self.StatusLabel.Text = "MAX"
        updateShadow(self)
        return self
    end

    function Window:Restore()
        if self._savedSize then
            self.Main.Size = self._savedSize
            self.Content.Visible = true
            self.Side.Visible = self.Options.ShowSidebar ~= false
            self._savedSize = nil
        end
        self.StatusLabel.Text = "READY"
        updateShadow(self)
        return self
    end

    function Window:SetTheme(themeName)
        return Cgode.ThemeManager:Set(themeName)
    end

    function Window:RefreshTheme()
        for _, inst in ipairs(self.Gui:GetDescendants()) do
            local role = inst:GetAttribute("CgodeRole")
            if role then
                local c = theme()[role]
                if c then
                    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then inst.TextColor3 = c end
                    if inst:IsA("Frame") or inst:IsA("ScrollingFrame") then inst.BackgroundColor3 = c end
                    if inst:IsA("TextButton") and inst:GetAttribute("CgodeRole") then inst.BackgroundColor3 = c end
                    if inst:IsA("UIStroke") then inst.Color = c end
                end
            end
            if inst:IsA("UIGradient") then
                local aRole = inst:GetAttribute("CgodeGradientA")
                local bRole = inst:GetAttribute("CgodeGradientB")
                if aRole and bRole then
                    local a = theme()[aRole] or theme().Surface
                    local b = theme()[bRole] or theme().Surface2
                    inst.Color = ColorSequence.new(a, b)
                end
            end
        end
        for _, fn in ipairs(self.UIRefreshers) do pcall(fn) end
        updateShadow(self)
    end

    function Window:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
        self.Connections = {}
        self.UIRefreshers = {}
        if self.Gui then self.Gui:Destroy() end
        for i, w in ipairs(Cgode.Windows or {}) do
            if w == self then table.remove(Cgode.Windows, i); break end
        end
        for i, w in ipairs(M.Windows) do
            if w == self then table.remove(M.Windows, i); break end
        end
        if M.Active == self then M.Active = M.Windows[#M.Windows] end
    end

    function M:RefreshAllThemes()
        for _, w in ipairs(self.Windows) do
            if not w.Destroyed then w:RefreshTheme() end
        end
    end

    return M
end
