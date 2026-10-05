return function(Cgode)
    local M={Windows={}}
    local Window={}
    Window.__index=Window
    local TabMethods={}
    local UIS=game:GetService("UserInputService")
    local ControlMethods=Cgode._fetch and Cgode._fetch("Core/Controls.lua")(Cgode) or {}
    local function corner(x,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=x end
    local function stroke(x,color)local s=Instance.new("UIStroke");s.Color=color;s.Parent=x end
    local function button(p,t)local b=Instance.new("TextButton");b.AutoButtonColor=false;b.Text=t;b.Font=Enum.Font.GothamMedium;b.TextSize=13;b.TextColor3=Cgode.ThemeManager.Current.Text;b.BackgroundColor3=Cgode.ThemeManager.Current.Surface2;b.BorderSizePixel=0;b.Parent=p;corner(b,7);return b end

    function M:Create(spec)
        local o=setmetatable({Title=tostring(spec.Title or "Cgode UI"),Name=tostring(spec.Name or "CgodeWindow"),Destroyed=false,Connections={},Tabs={}},Window)
        local opt=spec.Options or {}
        o.Resizable=opt.Resizable~=false
        o.MinSize=opt.MinSize or UDim2.fromOffset(400,350)
        o.MaxSize=opt.MaxSize or UDim2.fromOffset(900,700)
        local gui=Instance.new("ScreenGui");gui.Name=o.Name;gui.ResetOnSpawn=false;gui.Parent=Cgode:GetGuiParent();o.Gui=gui
        local main=Instance.new("Frame");main.AnchorPoint=Vector2.new(.5,.5);main.Position=UDim2.fromScale(.5,.5);main.Size=opt.Size or UDim2.fromOffset(560,420);main.BackgroundColor3=Cgode.ThemeManager.Current.Background;main.BorderSizePixel=0;main.ClipsDescendants=true;main.Parent=gui;corner(main,12);stroke(main,Cgode.ThemeManager.Current.Border);o.Main=main
        local top=Instance.new("Frame");top.Size=UDim2.new(1,0,0,48);top.BackgroundColor3=Cgode.ThemeManager.Current.Surface;top.BorderSizePixel=0;top.Parent=main;o.Top=top
        local title=Instance.new("TextLabel");title.BackgroundTransparency=1;title.Text=o.Title;title.TextColor3=Cgode.ThemeManager.Current.Text;title.Font=Enum.Font.GothamBold;title.TextSize=14;title.TextXAlignment=Enum.TextXAlignment.Left;title.Position=UDim2.fromOffset(15,0);title.Size=UDim2.new(1,-65,1,0);title.Parent=top
        local close=button(top,"×");close.Size=UDim2.fromOffset(34,34);close.Position=UDim2.new(1,-42,0,7);close.TextSize=20;o:Track(close);o:Connect(close.MouseButton1Click:Connect(function()o:Destroy()end))
        local side=Instance.new("Frame");side.Position=UDim2.fromOffset(0,48);side.Size=UDim2.new(0,145,1,-48);side.BackgroundColor3=Cgode.ThemeManager.Current.Surface;side.BorderSizePixel=0;side.Parent=main;o.Side=side
        local tabs=Instance.new("ScrollingFrame");tabs.BackgroundTransparency=1;tabs.BorderSizePixel=0;tabs.Size=UDim2.fromScale(1,1);tabs.ScrollBarThickness=2;tabs.Parent=side;o.TabList=tabs
        local tl=Instance.new("UIListLayout");tl.Padding=UDim.new(0,5);tl.Parent=tabs
        local content=Instance.new("Frame");content.Position=UDim2.fromOffset(145,48);content.Size=UDim2.new(1,-145,1,-48);content.BackgroundColor3=Cgode.ThemeManager.Current.Background;content.BorderSizePixel=0;content.Parent=main;o.Content=content
        local pages=Instance.new("Folder");pages.Parent=content;o.Pages=pages
        local dragging,ds,dp=false,nil,nil
        if spec.Draggable then
            o:Connect(top.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;ds=i.Position;dp=main.Position end end))
            o:Connect(UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
            o:Connect(UIS.InputChanged:Connect(function(i)if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-ds;main.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)end end))
        end
        table.insert(self.Windows,o);self.Active=o;return o
    end
    function Window:Track(i)table.insert(self.Connections,i);return i end
    function Window:Connect(c)return self:Track(c)end
    function Window:createTab(name)
        local t={Window=self,Name=tostring(name or "Tab"),Sections={}}
        local page=Instance.new("ScrollingFrame");page.BackgroundTransparency=1;page.BorderSizePixel=0;page.Size=UDim2.fromScale(1,1);page.Visible=false;page.ScrollBarThickness=3;page.Parent=self.Pages
        local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,10);layout.Parent=page
        local pad=Instance.new("UIPadding");pad.PaddingTop=UDim.new(0,12);pad.PaddingBottom=UDim.new(0,12);pad.PaddingLeft=UDim.new(0,12);pad.PaddingRight=UDim.new(0,12);pad.Parent=page
        local b=button(self.TabList,t.Name);b.Size=UDim2.new(1,0,0,36)
        t.Page,t.Button=page,b
        table.insert(self.Tabs,t);b.MouseButton1Click:Connect(function()self:SelectTab(t)end)
        if not self.ActiveTab then self:SelectTab(t)end
        setmetatable(t,{__index=function(_,k)return TabMethods[k]end});return t
    end
    function Window:SelectTab(t)for _,x in ipairs(self.Tabs)do x.Page.Visible=x==t;x.Button.BackgroundColor3=x==t and Cgode.ThemeManager.Current.Accent or Cgode.ThemeManager.Current.Surface2 end;self.ActiveTab=t end
    function Window:notification(title,message,duration)
        local h=Instance.new("Frame");h.BackgroundColor3=Cgode.ThemeManager.Current.Surface;h.BorderSizePixel=0;h.Size=UDim2.fromOffset(300,65);h.Position=UDim2.new(1,-315,1,-80);h.Parent=self.Gui;corner(h,9);stroke(h,Cgode.ThemeManager.Current.Border)
        local a=Instance.new("TextLabel");a.BackgroundTransparency=1;a.Text=tostring(title or "Notification");a.TextColor3=Cgode.ThemeManager.Current.Text;a.Font=Enum.Font.GothamBold;a.TextSize=13;a.TextXAlignment=Enum.TextXAlignment.Left;a.Position=UDim2.fromOffset(12,5);a.Size=UDim2.new(1,-24,0,22);a.Parent=h
        local b=Instance.new("TextLabel");b.BackgroundTransparency=1;b.Text=tostring(message or "");b.TextColor3=Cgode.ThemeManager.Current.Muted;b.Font=Enum.Font.Gotham;b.TextSize=11;b.TextXAlignment=Enum.TextXAlignment.Left;b.Position=UDim2.fromOffset(12,28);b.Size=UDim2.new(1,-24,0,30);b.Parent=h
        task.delay(duration or 3,function()if h.Parent then h:Destroy()end end);return h
    end
    Window.Notify=Window.notification
    function Window:SetTheme(theme)return Cgode.ThemeManager:Set(theme)end
    function Window:Destroy()
        if self.Destroyed then return end;self.Destroyed=true
        for _,c in ipairs(self.Connections)do pcall(function()c:Disconnect()end)end
        if self.Gui then self.Gui:Destroy()end
    end

    -- Controls are implemented as component modules and attached to sections.
    function Window:RefreshTheme()end
    function TabMethods:createSection(name,collapsed)
        local section={Tab=self,Name=tostring(name or "Section"),Collapsed=collapsed==true}
        local f=Instance.new("Frame");f.BackgroundColor3=Cgode.ThemeManager.Current.Surface;f.BorderSizePixel=0;f.Size=UDim2.new(1,0,0,42);f.AutomaticSize=Enum.AutomaticSize.Y;f.Parent=self.Page;corner(f,9);stroke(f,Cgode.ThemeManager.Current.Border)
        local title=button(f,(section.Collapsed and "▸  " or "▾  ")..section.Name);title.BackgroundTransparency=1;title.TextXAlignment=Enum.TextXAlignment.Left;title.Size=UDim2.new(1,0,0,32)
        local content=Instance.new("Frame");content.BackgroundTransparency=1;content.Size=UDim2.new(1,0,0,0);content.AutomaticSize=Enum.AutomaticSize.Y;content.Visible=not section.Collapsed;content.Parent=f
        local lay=Instance.new("UIListLayout");lay.Padding=UDim.new(0,7);lay.Parent=content
        local pad=Instance.new("UIPadding");pad.PaddingTop=UDim.new(0,5);pad.PaddingBottom=UDim.new(0,10);pad.PaddingLeft=UDim.new(0,10);pad.PaddingRight=UDim.new(0,10);pad.Parent=content
        section.Content=content
        title.MouseButton1Click:Connect(function()content.Visible=not content.Visible;title.Text=(content.Visible and "▾  " or "▸  ")..section.Name end)
        table.insert(self.Sections,section);return setmetatable(section,{__index=ControlMethods})
    end
    TabMethods.CreateSection=TabMethods.createSection
    function TabMethods:createText(text)
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Text=tostring(text or "");l.TextColor3=Cgode.ThemeManager.Current.Muted;l.Font=Enum.Font.Gotham;l.TextSize=12;l.TextXAlignment=Enum.TextXAlignment.Left;l.Size=UDim2.new(1,0,0,25);l.Parent=self.Page;return l
    end
    TabMethods.CreateText=TabMethods.createText
    function TabMethods:_section()
        if not self._controls then self._controls=self:createSection("Controls",false) end
        return self._controls
    end
    for _,method in ipairs({"createButton","createToggle","createSlider","createDropdown","createTextBox","createKeyBind","createColorPicker"}) do
        TabMethods[method]=function(self,...)return self:_section()[method](self:_section(),...)end
        TabMethods[method:gsub("^%l",string.upper)]=TabMethods[method]
    end
    local SectionMethods={}

    M.RefreshTheme=function()end
    M.Notify=function(self,title,message,duration)if self.Active then return self.Active:notification(title,message,duration)end end

    _G.__CGODE_WINDOW_CLASS=Window
    return M
end
