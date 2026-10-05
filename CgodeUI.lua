local Players=game:GetService("Players")
local CoreGui=game:GetService("CoreGui")
local UIS=game:GetService("UserInputService")
local Themes={Light=require(script.Themes.Light),Dark=require(script.Themes.Dark)}
local ThemeManager=require(script.Core.ThemeManager)
local AnimationManager=require(script.Core.AnimationManager)
local InputManager=require(script.Core.InputManager)
local DeviceManager=require(script.Core.DeviceManager)
local LayoutManager=require(script.Core.LayoutManager)
local WindowManager=require(script.Core.WindowManager)
local ConfigManager=require(script.Core.ConfigManager)
local State=require(script.Core.StateManager)
local InstanceManager=require(script.Core.InstanceManager)
local Maid=require(script.Utils.Maid)
local NavigationManager=require(script.Core.NavigationManager)

local CgodeUI={Name="Cgode UI",Version="2.0.0",Themes=Themes,Icons=require(script.Assets.Icons)}
CgodeUI.State=State

local function safeParent() local ok,g=pcall(function()return CoreGui end); if ok and g then return g end; local p=Players.LocalPlayer; return p and p:WaitForChild("PlayerGui") end
local function context(parent,overlay,notif,tooltip,theme,anim,input,maid) return {Parent=parent,Overlay=overlay,NotificationLayer=notif,TooltipLayer=tooltip,Theme=theme,Anim=anim,Input=input,Maid=maid} end

local function makeSection(window,name,host)
    local frame=Instance.new("Frame",host);frame.Name=name or "Section";frame.Size=UDim2.new(1,0,0,0);frame.BackgroundTransparency=1;frame.AutomaticSize=Enum.AutomaticSize.Y;
    local title=Instance.new("TextLabel",frame);title.Size=UDim2.new(1,0,0,24);title.BackgroundTransparency=1;title.Text=name or "Section";title.TextColor3=window.Theme:Get("Text");title.Font=Enum.Font.GothamBold;title.TextSize=13;title.TextXAlignment=Enum.TextXAlignment.Left;
    local body=Instance.new("Frame",frame);body.Position=UDim2.fromOffset(0,28);body.Size=UDim2.new(1,0,0,0);body.AutomaticSize=Enum.AutomaticSize.Y;body.BackgroundTransparency=1;local layout=Instance.new("UIListLayout",body);layout.Padding=UDim.new(0,6);
    local ctx=context(body,window.Overlay,window.NotificationLayer,window.TooltipLayer,window.Theme,window.Anim,window.Input,window.Maid);
    local section={Instance=frame,Body=body}
    local mapping={Button="Button",Toggle="Toggle",Checkbox="Checkbox",Radio="Radio",Slider="Slider",RangeSlider="RangeSlider",Dropdown="Dropdown",MultiDropdown="MultiDropdown",Textbox="Textbox",NumberInput="NumberInput",Keybind="Keybind",ColorPicker="ColorPicker",Label="Label",Paragraph="Paragraph",Divider="Divider",Spacer="Spacer",IconButton="IconButton",PasswordBox="PasswordBox",CodeBox="CodeBox",SearchBox="SearchBox",ComboBox="ComboBox",SegmentedControl="SegmentedControl",ChipSelector="ChipSelector",TagInput="TagInput",Stepper="Stepper",Knob="Knob",Dial="Dial",XYPad="XYPad",Vector2Input="Vector2Input",Vector3Input="Vector3Input",GradientPicker="GradientPicker",FontPicker="FontPicker",IconPicker="IconPicker",DatePicker="DatePicker",TimePicker="TimePicker",DateTimePicker="DateTimePicker",TreeView="TreeView",Accordion="Accordion",Pagination="Pagination",Breadcrumbs="Breadcrumbs",Carousel="Carousel",Progress="Progress",Spinner="Spinner",EmptyState="EmptyState",ErrorState="ErrorState",Statistics="Statistics",Chart="Chart",Table="Table",List="List",Timeline="Timeline",ChatBox="ChatBox",ImageGallery="ImageGallery",FileList="FileList",LogViewer="LogViewer",Console="Console",MarkdownViewer="MarkdownViewer"}
    for method,module in pairs(mapping) do section["Add"..method]=function(self,...) return require(script.Components.Basic:FindFirstChild(module) or script.Components.Advanced:FindFirstChild(module) or script.Components.Feedback:FindFirstChild(module) or script.Components.DataDisplay:FindFirstChild(module)) (ctx,...) end end
    function section:AddPanel(...) return require(script.Components.Layout.Panel)(ctx,...) end
    function section:AddCard(...) return require(script.Components.Layout.Card)(ctx,...) end
    return section
end

local Window={};Window.__index=Window
function Window:CreateTab(name,icon)
    local tabButton=Instance.new("TextButton",self.Sidebar);tabButton.Size=UDim2.new(1,-8,0,38);tabButton.BackgroundTransparency=1;tabButton.Text=tostring(name);tabButton.TextColor3=self.Theme:Get("Muted");tabButton.Font=Enum.Font.GothamMedium;tabButton.TextSize=13;tabButton.TextXAlignment=Enum.TextXAlignment.Left;local pad=Instance.new("UIPadding",tabButton);pad.PaddingLeft=UDim.new(0,12)
    local page=Instance.new("ScrollingFrame",self.Pages);page.Name=tostring(name);page.Size=UDim2.fromScale(1,1);page.BackgroundTransparency=1;page.BorderSizePixel=0;page.ScrollBarThickness=5;page.AutomaticCanvasSize=Enum.AutomaticSize.Y;page.Visible=false;local lay=Instance.new("UIListLayout",page);lay.Padding=UDim.new(0,10);
    local tab={Name=name,Button=tabButton,Page=page,Sections={},Window=self}
    local mb=Instance.new("TextButton",self.MobileNav);mb.Size=UDim2.new(1/math.max(1,#self.Tabs+1),0,1,0);mb.BackgroundTransparency=1;mb.Text=tostring(name);mb.TextColor3=self.Theme:Get("Muted");mb.Font=Enum.Font.GothamMedium;mb.TextSize=11;tabButton.LayoutOrder=#self.Tabs+1;tab.Button.LayoutOrder=#self.Tabs+1;tab.MobileButton=mb;self.Maid:Give(mb.Activated:Connect(function()self.Navigation:Go(tab)end))
    function tab:AddSection(secName) local sec=makeSection(tab.Window,secName,page);table.insert(tab.Sections,sec);return sec end
    function tab:AddParagraph(title,text) local sec=tab:AddSection(title or ""); return sec:AddParagraph(text or "") end
    self.Maid:Give(tabButton.Activated:Connect(function() self.Navigation:Go(tab) end));table.insert(self.Tabs,tab);for _,t in ipairs(self.Tabs)do if t.MobileButton then t.MobileButton.Size=UDim2.new(1/#self.Tabs,0,1,0) end end;if not self.Navigation.Current then self.Navigation:Go(tab,false) end;return tab
end
function Window:_showTab(tab) for _,t in ipairs(self.Tabs)do t.Page.Visible=(t==tab);t.Button.TextColor3=(t==tab) and self.Theme:Get("Text") or self.Theme:Get("Muted");if t.MobileButton then t.MobileButton.TextColor3=(t==tab) and self.Theme:Get("Text") or self.Theme:Get("Muted") end end end
function Window:NextTab() for i,t in ipairs(self.Tabs) do if t==self.Navigation.Current then local n=self.Tabs[(i%#self.Tabs)+1];if n then self.Navigation:Go(n) end;break end end end
function Window:PreviousTab() for i,t in ipairs(self.Tabs) do if t==self.Navigation.Current then local n=self.Tabs[((i-2)%#self.Tabs)+1];if n then self.Navigation:Go(n) end;break end end end end
function Window:SetResponsiveMode(bp) self.ResponsiveMode=bp; if bp=="Compact" or bp=="Small" then self.Sidebar.Size=UDim2.fromOffset(0,0);self.Sidebar.Visible=false;self.MobileNav.Visible=true;self.Content.Position=UDim2.fromOffset(12,56);self.Content.Size=UDim2.new(1,-24,1,-112) else self.Sidebar.Visible=true;self.MobileNav.Visible=false;self.Sidebar.Size=UDim2.fromOffset(150,0);self.Content.Position=UDim2.fromOffset(162,56);self.Content.Size=UDim2.new(1,-174,1,-68) end end
function Window:Minimize() self.Minimized=not self.Minimized;self.Content.Visible=not self.Minimized;self.Sidebar.Visible=not self.Minimized end
function Window:Maximize() local cam=workspace.CurrentCamera;local v=cam.ViewportSize;self.Root.Position=UDim2.fromOffset(0,0);self.Root.Size=UDim2.fromOffset(v.X,v.Y) end
function Window:Restore() self.Root.Position=self.DefaultPosition;self.Root.Size=self.DefaultSize end
function Window:Center() local cam=workspace.CurrentCamera;local v=cam.ViewportSize;local a=self.Root.AbsoluteSize;self.Root.Position=UDim2.fromOffset((v.X-a.X)/2,(v.Y-a.Y)/2) end
function Window:Destroy() if self.Destroyed then return end;self.Destroyed=true;self.Maid:Destroy();if self.Gui then self.Gui:Destroy() end;self.Manager=nil end

function CgodeUI:CreateWindow(options)
    options=options or {};local theme=Themes[options.Theme or "Light"] or Themes.Light;local themeManager=ThemeManager.new(theme);local anim=AnimationManager.new();anim:SetReducedMotion(options.ReducedMotion==true);local input=InputManager.new();local device=DeviceManager.new();local layout=LayoutManager.new(device);local wm=self._WindowManager or WindowManager.new();self._WindowManager=wm;
    local gui=Instance.new("ScreenGui");gui.Name=options.Name or "CgodeUI";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=options.IgnoreGuiInset==true;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;local parent=safeParent();local parentOk=pcall(function()gui.Parent=parent end);if not parentOk then local p=Players.LocalPlayer;if p then gui.Parent=p:WaitForChild("PlayerGui") end end
    local root=Instance.new("Frame",gui);root.Name="Window";root.AnchorPoint=Vector2.new(.5,.5);root.Position=UDim2.new(.5,0,.5,0);root.Size=options.Size or UDim2.fromOffset(760,510);root.BackgroundColor3=themeManager:Get("Background");root.BorderSizePixel=0;root.Active=true;Instance.new("UICorner",root).CornerRadius=UDim.new(0,16);local stroke=Instance.new("UIStroke",root);stroke.Color=themeManager:Get("Border");
    local header=Instance.new("Frame",root);header.Size=UDim2.new(1,0,0,48);header.BackgroundColor3=themeManager:Get("Surface");Instance.new("UICorner",header).CornerRadius=UDim.new(0,16);
    local title=Instance.new("TextLabel",header);title.Position=UDim2.fromOffset(16,0);title.Size=UDim2.new(1,-126,1,0);title.BackgroundTransparency=1;title.Text=options.Title or "Cgode UI";title.TextColor3=themeManager:Get("Text");title.Font=Enum.Font.GothamBold;title.TextSize=16;title.TextXAlignment=Enum.TextXAlignment.Left;
    local min=Instance.new("TextButton",header);min.Size=UDim2.fromOffset(36,32);min.Position=UDim2.new(1,-82,0,8);min.Text="−";min.BackgroundColor3=themeManager:Get("SurfaceAlt");min.TextColor3=themeManager:Get("Text");min.Font=Enum.Font.GothamBold;min.TextSize=18;Instance.new("UICorner",min).CornerRadius=UDim.new(0,9);
    local close=Instance.new("TextButton",header);close.Size=UDim2.fromOffset(36,32);close.Position=UDim2.new(1,-42,0,8);close.Text="×";close.BackgroundColor3=themeManager:Get("SurfaceAlt");close.TextColor3=themeManager:Get("Text");close.Font=Enum.Font.GothamBold;close.TextSize=18;Instance.new("UICorner",close).CornerRadius=UDim.new(0,9);
    local body=Instance.new("Frame",root);body.Position=UDim2.fromOffset(8,54);body.Size=UDim2.new(1,-16,1,-62);body.BackgroundTransparency=1;
    local sidebar=Instance.new("Frame",body);sidebar.Name="Sidebar";sidebar.Size=UDim2.fromOffset(150,0);sidebar.BackgroundColor3=themeManager:Get("Surface");sidebar.BorderSizePixel=0;sidebar.AutomaticSize=Enum.AutomaticSize.Y;Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,12);local sl=Instance.new("UIListLayout",sidebar);sl.Padding=UDim.new(0,4);
    local content=Instance.new("Frame",body);content.Name="Content";content.Position=UDim2.fromOffset(162,0);content.Size=UDim2.new(1,-162,1,0);content.BackgroundColor3=themeManager:Get("Surface");content.BorderSizePixel=0;Instance.new("UICorner",content).CornerRadius=UDim.new(0,12);
    local pages=Instance.new("Frame",content);pages.Position=UDim2.fromOffset(12,12);pages.Size=UDim2.new(1,-24,1,-24);pages.BackgroundTransparency=1;
    local mobileNav=Instance.new("Frame",body);mobileNav.Name="MobileNav";mobileNav.Position=UDim2.new(0,12,1,-48);mobileNav.Size=UDim2.new(1,-24,0,40);mobileNav.BackgroundColor3=themeManager:Get("Surface");mobileNav.Visible=false;Instance.new("UICorner",mobileNav).CornerRadius=UDim.new(0,10);local mnl=Instance.new("UIListLayout",mobileNav);mnl.FillDirection=Enum.FillDirection.Horizontal;mnl.SortOrder=Enum.SortOrder.LayoutOrder;
    local overlay=Instance.new("Frame",gui);overlay.Name="Overlay";overlay.Size=UDim2.fromScale(1,1);overlay.BackgroundTransparency=1;overlay.ZIndex=400;local notif=Instance.new("Frame",gui);notif.Name="Notifications";notif.AnchorPoint=Vector2.new(1,0);notif.Position=UDim2.new(1,-14,0,14);notif.Size=UDim2.fromOffset(310,500);notif.BackgroundTransparency=1;notif.ZIndex=700;local nl=Instance.new("UIListLayout",notif);nl.HorizontalAlignment=Enum.HorizontalAlignment.Right;nl.VerticalAlignment=Enum.VerticalAlignment.Top;nl.Padding=UDim.new(0,8);local tooltip=Instance.new("Frame",gui);tooltip.Name="Tooltips";tooltip.Size=UDim2.fromScale(1,1);tooltip.BackgroundTransparency=1;tooltip.ZIndex=900;
    local maid=Maid.new();local w=setmetatable({Root=root,Gui=gui,Header=header,Sidebar=sidebar,Content=content,Pages=pages,Overlay=overlay,NotificationLayer=notif,TooltipLayer=tooltip,Theme=themeManager,Anim=anim,Input=input,Device=device,Layout=layout,Manager=wm,Maid=maid,Tabs={},DefaultPosition=root.Position,DefaultSize=root.Size,ResponsiveMode="Large",MobileNav=mobileNav},Window);w.Navigation=NavigationManager.new(w);
    local resizeHandle=Instance.new("Frame",root);resizeHandle.Name="ResizeHandle";resizeHandle.AnchorPoint=Vector2.new(1,1);resizeHandle.Position=UDim2.fromScale(1,1);resizeHandle.Size=UDim2.fromOffset(16,16);resizeHandle.BackgroundTransparency=1;maid:Give(require(script.Utils.Resizable).bind(resizeHandle,root,Vector2.new(420,300),Vector2.new(1400,900)));
    CgodeUI._Windows=CgodeUI._Windows or {};table.insert(CgodeUI._Windows,w);wm:Register(w);input:BindPress(min,function()w:Minimize()end);input:BindPress(close,function()w:Destroy()end);input:BindDrag(header,root);
    local cam=workspace.CurrentCamera;local function resize() if workspace.CurrentCamera then layout:Apply(w,workspace.CurrentCamera.ViewportSize) end end;maid:Give(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize));if cam then maid:Give(cam:GetPropertyChangedSignal("ViewportSize"):Connect(resize)) end;resize();
    if device:IsMobile() and options.MobileToggle ~= false then local toggle=Instance.new("TextButton",gui);toggle.Name="CgodeUIToggle";toggle.AnchorPoint=Vector2.new(1,1);toggle.Position=UDim2.new(1,-16,1,-16);toggle.Size=UDim2.fromOffset(52,52);toggle.Text="UI";toggle.Font=Enum.Font.GothamBold;toggle.TextSize=13;toggle.TextColor3=themeManager:Get("Text");toggle.BackgroundColor3=themeManager:Get("Surface");toggle.ZIndex=1001;Instance.new("UICorner",toggle).CornerRadius=UDim.new(1,0);local ts=Instance.new("UIStroke",toggle);ts.Color=themeManager:Get("Border");maid:Give(toggle.Activated:Connect(function()root.Visible=not root.Visible end));end;
    function w:Notify(o) o=o or {}; return require(script.Components.Feedback.Notification)({Parent=body,Overlay=overlay,NotificationLayer=notif,TooltipLayer=tooltip,Theme=themeManager,Anim=anim,Input=input,Maid=maid},o.Title or "Cgode UI",o.Message or "",o.Duration or 4,o.Type) end
    function w:SetTheme(t)
        local old=themeManager.Theme;themeManager:SetTheme(t);root.BackgroundColor3=t.Colors.Background;header.BackgroundColor3=t.Colors.Surface;
        for _,obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if obj.TextColor3==old.Colors.Text then obj.TextColor3=t.Colors.Text elseif obj.TextColor3==old.Colors.Muted then obj.TextColor3=t.Colors.Muted end
                if obj:IsA("TextBox") and obj.PlaceholderColor3==old.Colors.Muted then obj.PlaceholderColor3=t.Colors.Muted end
            elseif obj:IsA("Frame") then
                if obj.BackgroundColor3==old.Colors.Surface then obj.BackgroundColor3=t.Colors.Surface elseif obj.BackgroundColor3==old.Colors.SurfaceAlt then obj.BackgroundColor3=t.Colors.SurfaceAlt elseif obj.BackgroundColor3==old.Colors.Border then obj.BackgroundColor3=t.Colors.Border end
            elseif obj:IsA("UIStroke") then
                if obj.Color==old.Colors.Border then obj.Color=t.Colors.Border end
            end
        end
    end
    return w
end

function CgodeUI:LoadTheme(name) return Themes[name] end
function CgodeUI:CreateConfig(namespace,defaults) return ConfigManager.new(namespace,defaults) end
function CgodeUI:GetDevice() return (self._DeviceManager or DeviceManager.new()) end
function CgodeUI:DestroyAll() for _,w in ipairs(self._Windows or {}) do pcall(function()w:Destroy()end) end self._Windows={} end
return CgodeUI
