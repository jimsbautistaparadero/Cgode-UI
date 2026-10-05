return function(Cgode)
    local UIS=game:GetService("UserInputService")
    local Players=game:GetService("Players")
    local M={Windows={}}
    local Window={};Window.__index=Window
    local TabMethods={}
    local ControlMethods=Cgode._fetch("Core/Controls.lua")(Cgode)
    local function theme()return Cgode.ThemeManager.Current end
    local function corner(x,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=x;return c end
    local function stroke(x) local s=Instance.new("UIStroke");s.Color=theme().Border;s.Thickness=1;s.Parent=x;return s end
    local function mark(x,role)x:SetAttribute("CgodeRole",role);local c=theme()[role];if not c then return x end;if x:IsA("TextLabel")or x:IsA("TextBox")then x.TextColor3=c end;if x:IsA("Frame")or x:IsA("ScrollingFrame")or x:IsA("TextButton")then x.BackgroundColor3=c end;return x end
    local function button(p,t)local b=Instance.new("TextButton");b.AutoButtonColor=false;b.Text=tostring(t or "");b.Font=Enum.Font.GothamMedium;b.TextSize=13;b.TextColor3=theme().Text;b.BackgroundColor3=theme().Surface2;b.BorderSizePixel=0;b.Parent=p;mark(b,"Surface2");corner(b,7);return b end
    local function label(p,t,size)local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Text=tostring(t or "");l.TextColor3=theme().Text;l.Font=Enum.Font.GothamMedium;l.TextSize=size or 13;l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=p;mark(l,"Text");return l end
    function M:Create(spec)
        local opt=spec.Options or {};local o=setmetatable({Title=tostring(spec.Title or "Cgode UI"),Name=tostring(spec.Name or "CgodeWindow"),Destroyed=false,Connections={},Tabs={},Options=opt},Window)
        o.Resizable=opt.Resizable~=false;o.MinSize=opt.MinSize or UDim2.fromOffset(420,320);o.MaxSize=opt.MaxSize or UDim2.fromOffset(1100,760)
        local gui=Instance.new("ScreenGui");gui.Name=o.Name;gui.ResetOnSpawn=false;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.DisplayOrder=opt.DisplayOrder or 100;gui.Parent=Cgode:GetGuiParent();o.Gui=gui
        local main=Instance.new("Frame");main.AnchorPoint=Vector2.new(.5,.5);main.Position=opt.Position or UDim2.fromScale(.5,.5);main.Size=opt.Size or UDim2.fromOffset(620,460);main.BackgroundColor3=theme().Background;main.BorderSizePixel=0;main.ClipsDescendants=true;main.Parent=gui;mark(main,"Background");corner(main,opt.CornerRadius or 12);stroke(main);o.Main=main
        local top=Instance.new("Frame");top.Size=UDim2.new(1,0,0,48);top.BackgroundColor3=theme().Surface;top.BorderSizePixel=0;top.Parent=main;mark(top,"Surface");o.Top=top
        local title=label(top,o.Title,14);title.Position=UDim2.fromOffset(15,0);title.Size=UDim2.new(1,-170,1,0);o.TitleLabel=title
        local minimize=button(top,"—");minimize.Size=UDim2.fromOffset(34,34);minimize.Position=UDim2.new(1,-118,0,7)
        local maximize=button(top,"□");maximize.Size=UDim2.fromOffset(34,34);maximize.Position=UDim2.new(1,-80,0,7)
        local close=button(top,"×");close.Size=UDim2.fromOffset(34,34);close.Position=UDim2.new(1,-42,0,7);close.TextSize=20
        o:Track(minimize.MouseButton1Click:Connect(function()o:Minimize()end));o:Track(maximize.MouseButton1Click:Connect(function()o:Maximize()end));o:Track(close.MouseButton1Click:Connect(function()o:Destroy()end))
        local side=Instance.new("Frame");side.Position=UDim2.fromOffset(0,48);side.Size=UDim2.new(0,opt.SidebarWidth or 155,1,-48);side.BackgroundColor3=theme().Surface;side.BorderSizePixel=0;side.Parent=main;mark(side,"Surface");o.Side=side
        local tabs=Instance.new("ScrollingFrame");tabs.BackgroundTransparency=1;tabs.BorderSizePixel=0;tabs.Size=UDim2.fromScale(1,1);tabs.ScrollBarThickness=3;tabs.CanvasSize=UDim2.new();tabs.Parent=side;o.TabList=tabs;local tl=Instance.new("UIListLayout");tl.Padding=UDim.new(0,5);tl.Parent=tabs;tl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()tabs.CanvasSize=UDim2.new(0,0,0,tl.AbsoluteContentSize.Y+10)end)
        local content=Instance.new("Frame");content.Position=UDim2.fromOffset(opt.SidebarWidth or 155,48);content.Size=UDim2.new(1,-(opt.SidebarWidth or 155),1,-48);content.BackgroundColor3=theme().Background;content.BorderSizePixel=0;content.Parent=main;mark(content,"Background");o.Content=content;o.Pages=Instance.new("Folder");o.Pages.Parent=content
        if spec.Draggable~=false then o:EnableDragging(top,main) end
        if o.Resizable then o:EnableResize(main) end
        o:Track(UIS.InputBegan:Connect(function(input,processed)
            if processed or o.Destroyed then return end
            if input.KeyCode==Enum.KeyCode.RightShift then o:Toggle() end
        end))
        table.insert(self.Windows,o);self.Active=o;return o
    end
    function Window:Track(conn)if conn then table.insert(self.Connections,conn)end;return conn end
    function Window:Connect(conn)return self:Track(conn)end
    function Window:EnableDragging(handle,main)
        local dragging=false;local start;local startPos
        self:Track(handle.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;start=i.Position;startPos=main.Position;self:Focus()end end))
        self:Track(UIS.InputChanged:Connect(function(i)if dragging and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-start;main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)end end))
        self:Track(UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
    end
    function Window:EnableResize(main)
        local grip=Instance.new("TextButton");grip.Text="";grip.BackgroundTransparency=1;grip.Size=UDim2.fromOffset(18,18);grip.Position=UDim2.new(1,-18,1,-18);grip.Parent=main;grip.ZIndex=20
        local resizing=false;local start;local startSize
        self:Track(grip.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then resizing=true;start=i.Position;startSize=main.AbsoluteSize end end))
        self:Track(UIS.InputChanged:Connect(function(i)if resizing and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-start;local x=math.clamp(startSize.X+d.X,self.MinSize.X.Offset,self.MaxSize.X.Offset);local y=math.clamp(startSize.Y+d.Y,self.MinSize.Y.Offset,self.MaxSize.Y.Offset);main.Size=UDim2.fromOffset(x,y)end end))
        self:Track(UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then resizing=false end end))
    end
    function Window:createTab(name,options)
        local t=setmetatable({Window=self,Name=tostring(name or "Tab"),Sections={},Options=options or {}},{__index=TabMethods});local page=Instance.new("ScrollingFrame");page.BackgroundTransparency=1;page.BorderSizePixel=0;page.Size=UDim2.fromScale(1,1);page.Visible=false;page.ScrollBarThickness=3;page.Parent=self.Pages;local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,10);layout.Parent=page;layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()page.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+24)end);local pad=Instance.new("UIPadding");pad.PaddingTop=UDim.new(0,12);pad.PaddingBottom=UDim.new(0,12);pad.PaddingLeft=UDim.new(0,12);pad.PaddingRight=UDim.new(0,12);pad.Parent=page;local b=button(self.TabList,t.Name);b.Size=UDim2.new(1,0,0,36);b.MouseButton1Click:Connect(function()self:SelectTab(t)end);t.Page,t.Button=page,b;table.insert(self.Tabs,t);if not self.ActiveTab then self:SelectTab(t)end;return t
    end
    Window.CreateTab=Window.createTab
    function Window:SelectTab(tab)for _,t in ipairs(self.Tabs)do t.Page.Visible=t==tab;t.Button.BackgroundColor3=t==tab and theme().Accent or theme().Surface2 end;self.ActiveTab=tab;return tab end
    Window.selectTab=Window.SelectTab
    function TabMethods:createSection(name,collapsed,options)
        local section=setmetatable({Tab=self,Window=self.Window,Name=tostring(name or "Section"),Collapsed=collapsed==true,Options=options or {},Sections={}},{__index=ControlMethods});local f=Instance.new("Frame");f.BackgroundColor3=theme().Surface;f.BorderSizePixel=0;f.Size=UDim2.new(1,0,0,42);f.AutomaticSize=Enum.AutomaticSize.Y;f.Parent=self.Page;mark(f,"Surface");corner(f,9);stroke(f);local title=button(f,(section.Collapsed and "▸  " or "▾  ")..section.Name);title.BackgroundTransparency=1;title.Size=UDim2.new(1,0,0,32);title.TextXAlignment=Enum.TextXAlignment.Left;local content=Instance.new("Frame");content.BackgroundTransparency=1;content.Size=UDim2.new(1,0,0,0);content.AutomaticSize=Enum.AutomaticSize.Y;content.Visible=not section.Collapsed;content.Parent=f;local lay=Instance.new("UIListLayout");lay.Padding=UDim.new(0,7);lay.Parent=content;local pad=Instance.new("UIPadding");pad.PaddingTop=UDim.new(0,5);pad.PaddingBottom=UDim.new(0,10);pad.PaddingLeft=UDim.new(0,10);pad.PaddingRight=UDim.new(0,10);pad.Parent=content;section.Content=content;section.Frame=f;section.TitleButton=title;self.Sections[#self.Sections+1]=section;self.Window:Track(title.MouseButton1Click:Connect(function()content.Visible=not content.Visible;title.Text=(content.Visible and "▾  " or "▸  ")..section.Name end));return section
    end
    TabMethods.CreateSection=TabMethods.createSection
    function TabMethods:createText(text) local section=self._autoSection or self:createSection("Content",false);self._autoSection=section;return section:createText(text) end
    TabMethods.CreateText=TabMethods.createText
    function TabMethods:_section()self._autoSection=self._autoSection or self:createSection("Controls",false);return self._autoSection end
    local forwarded={
        "Button","IconButton","Toggle","Checkbox","Radio","RadioGroup","Slider","NumberInput","TextBox","Dropdown","MultiDropdown","KeyBind","ColorPicker","Badge","Link","Image","CodeBlock","SearchBox","ComboBox","CommandPalette","ContextMenu","Accordion","SegmentedControl","TagInput","Stepper","RangeSlider","XYPad","TreeView","DatePicker","TimePicker","Autocomplete","Pagination","Rating","Breadcrumbs","Popover","List","VirtualList","DataGrid","Table","Statistics","ActivityFeed","Timeline","Sparkline","BarChart","LogViewer","Container","Stack","Row","Column","Grid","ResponsiveGrid","SplitPane","ScrollContainer","Overlay","Card","Panel","Loading","Spinner","Skeleton","Progress","Notification","Toast","Dialog","ConfirmDialog","Tooltip","EmptyState","ErrorState","Banner"
    }
    for _,name in ipairs(forwarded)do local lower=name:sub(1,1):lower()..name:sub(2);TabMethods[lower]=function(self,...)return self:_section()["create"..name](self:_section(),...)end;TabMethods[name]=TabMethods[lower]end
    function Window:notification(title,message,duration,kind)
        local stack=self.Gui:FindFirstChild("CgodeNotifications") or Instance.new("Frame");stack.Name="CgodeNotifications";stack.BackgroundTransparency=1;stack.AnchorPoint=Vector2.new(1,1);stack.Position=UDim2.fromScale(1,1);stack.Size=UDim2.fromOffset(340,400);stack.Parent=self.Gui;local layout=stack:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout");layout.HorizontalAlignment=Enum.HorizontalAlignment.Right;layout.VerticalAlignment=Enum.VerticalAlignment.Bottom;layout.Padding=UDim.new(0,8);layout.Parent=stack;local h=Instance.new("Frame");h.Size=UDim2.fromOffset(320,68);h.BackgroundColor3=theme().Surface;h.BorderSizePixel=0;h.Parent=stack;mark(h,"Surface");corner(h,9);stroke(h);local a=label(h,title or "Notification",13);a.Position=UDim2.fromOffset(12,6);a.Size=UDim2.new(1,-24,0,22);local b=label(h,message or "",11);b.Position=UDim2.fromOffset(12,29);b.Size=UDim2.new(1,-24,0,30);mark(b,"Muted");task.delay(duration or 3,function()if h.Parent then h:Destroy()end end);return h
    end
    Window.Notify=Window.notification;M.Notify=function(self,title,message,duration,kind)if self.Active then return self.Active:notification(title,message,duration,kind)end end
    function Window:ShowDialog(titleText,message,buttons)
        local overlay=Instance.new("Frame");overlay.BackgroundColor3=Color3.new(0,0,0);overlay.BackgroundTransparency=.35;overlay.Size=UDim2.fromScale(1,1);overlay.Parent=self.Gui;local box=Instance.new("Frame");box.AnchorPoint=Vector2.new(.5,.5);box.Position=UDim2.fromScale(.5,.5);box.Size=UDim2.fromOffset(360,190);box.BackgroundColor3=theme().Surface;box.BorderSizePixel=0;box.Parent=overlay;mark(box,"Surface");corner(box,10);stroke(box);local title=label(box,titleText,15);title.Position=UDim2.fromOffset(16,14);title.Size=UDim2.new(1,-32,0,25);local msg=label(box,message,12);msg.Position=UDim2.fromOffset(16,45);msg.Size=UDim2.new(1,-32,0,70);mark(msg,"Muted");local list=buttons or {{Text="OK",Callback=function()overlay:Destroy()end}};for i,item in ipairs(list)do local b=button(box,item.Text or tostring(item));b.Size=UDim2.fromOffset(90,32);b.Position=UDim2.new(1,-100-(i-1)*98,1,-45);b.MouseButton1Click:Connect(function()if item.Callback then task.spawn(item.Callback)end;if item.Close~=false and overlay.Parent then overlay:Destroy()end end)end;return overlay
    end
    function Window:ShowConfirm(titleText,message,onConfirm,onCancel)return self:ShowDialog(titleText,message,{{Text="Cancel",Callback=onCancel},{Text="Confirm",Callback=onConfirm}})end
    function Window:ShowCommandPalette(items,callback,commands)
        local overlay=self:ShowDialog("Command Palette","Select a command",{})
        local box=overlay:FindFirstChildOfClass("Frame");local list=Instance.new("ScrollingFrame");list.BackgroundTransparency=1;list.BorderSizePixel=0;list.Position=UDim2.fromOffset(14,76);list.Size=UDim2.new(1,-28,0,95);list.ScrollBarThickness=3;list.Parent=box;local layout=Instance.new("UIListLayout");layout.Parent=list;for i,item in ipairs(items or {})do local b=button(list,item);b.Size=UDim2.new(1,0,0,28);b.MouseButton1Click:Connect(function()if commands and commands[i] and commands[i].callback then task.spawn(commands[i].callback)end; if callback then task.spawn(callback,item,i)end;overlay:Destroy()end)end;return overlay
    end
    function Window:ShowContextMenu(items,callback)
        local overlay=Instance.new("Frame");overlay.BackgroundTransparency=1;overlay.Size=UDim2.fromScale(1,1);overlay.Parent=self.Gui;local menu=Instance.new("Frame");menu.AnchorPoint=Vector2.new(.5,.5);menu.Position=UDim2.fromScale(.5,.5);menu.Size=UDim2.fromOffset(220,math.min(300,40+#items*32));menu.BackgroundColor3=theme().Surface;menu.BorderSizePixel=0;menu.Parent=overlay;mark(menu,"Surface");corner(menu,8);stroke(menu);for i,item in ipairs(items or {})do local b=button(menu,item.Text or tostring(item));b.Position=UDim2.fromOffset(5,5+(i-1)*32);b.Size=UDim2.new(1,-10,0,28);b.MouseButton1Click:Connect(function()call(callback,item,i);overlay:Destroy()end)end;return overlay
    end
    function Window:Focus()if self.Gui then self.Gui.DisplayOrder=math.max(self.Gui.DisplayOrder,200);self.Gui.Enabled=true end;Cgode.WindowManager.Active=self end
    function Window:SetTitle(value)self.Title=tostring(value);if self.TitleLabel then self.TitleLabel.Text=self.Title end;return self end
    function Window:Center()if self.Main then self.Main.Position=UDim2.fromScale(.5,.5) end;return self end
    function Window:SetPosition(pos)self.Main.Position=pos;return self end
    function Window:GetPosition()return self.Main.Position end
    function Window:SetSize(size)self.Main.Size=size;return self end
    function Window:GetSize()return self.Main.Size end
    function Window:SetVisible(v)self.Gui.Enabled=v;return self end
    function Window:IsVisible()return self.Gui.Enabled end
    function Window:Toggle()self.Gui.Enabled=not self.Gui.Enabled;return self end
    function Window:Minimize()if self._savedSize then return self:SetVisible(false) end;self._savedSize=self.Main.Size;self.Main.Size=UDim2.fromOffset(math.max(self.MinSize.X.Offset,420),48);self.Content.Visible=false;self.Side.Visible=false;return self end
    function Window:Maximize()local viewport=Cgode:GetViewport();self.Main.Position=UDim2.fromScale(.5,.5);self.Main.Size=UDim2.fromOffset(math.min(self.MaxSize.X.Offset,math.max(self.MinSize.X.Offset,viewport.X-40)),math.min(self.MaxSize.Y.Offset,math.max(self.MinSize.Y.Offset,viewport.Y-40)));self.Content.Visible=true;self.Side.Visible=true;return self end
    function Window:Restore()if self._savedSize then self.Main.Size=self._savedSize;self.Content.Visible=true;self.Side.Visible=true;self._savedSize=nil end;return self end
    function Window:SetTheme(themeName)return Cgode.ThemeManager:Set(themeName)end
    function Window:RefreshTheme()
        for _,inst in ipairs(self.Gui:GetDescendants())do local role=inst:GetAttribute("CgodeRole");if role then local c=theme()[role];if c then if inst:IsA("TextLabel")or inst:IsA("TextButton")or inst:IsA("TextBox")then inst.TextColor3=c elseif inst:IsA("Frame")or inst:IsA("ScrollingFrame")or inst:IsA("TextButton")then inst.BackgroundColor3=c elseif inst:IsA("UIStroke")then inst.Color=c end end end end
    end
    function Window:Destroy()
        if self.Destroyed then return end;self.Destroyed=true;for _,c in ipairs(self.Connections)do pcall(function()c:Disconnect()end)end;self.Connections={};if self.Gui then self.Gui:Destroy()end;for i,w in ipairs(Cgode.Windows or {})do if w==self then table.remove(Cgode.Windows,i);break end end;for i,w in ipairs(M.Windows)do if w==self then table.remove(M.Windows,i);break end end;if M.Active==self then M.Active=M.Windows[#M.Windows] end
    end
    function M:RefreshAllThemes()for _,w in ipairs(self.Windows)do if not w.Destroyed then w:RefreshTheme()end end end
    return M
end
