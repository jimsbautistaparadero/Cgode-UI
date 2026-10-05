return function(Cgode)
    local UIS=game:GetService("UserInputService")
    local TextService=game:GetService("TextService")
    local function theme() return Cgode.ThemeManager.Current end
    local function mark(inst,role)
        inst:SetAttribute("CgodeRole",role)
        local value=theme()[role]
        if value then
            if inst:IsA("TextLabel") or inst:IsA("TextBox") then inst.TextColor3=value end
            if inst:IsA("Frame") or inst:IsA("ScrollingFrame") or inst:IsA("TextButton") then inst.BackgroundColor3=value end
        end
        return inst
    end
    local function corner(inst,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=inst;return c end
    local function stroke(inst) local s=Instance.new("UIStroke");s.Thickness=1;s.Color=theme().Border;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=inst;return s end
    local function frame(parent,height)
        local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,height or 40);f.BorderSizePixel=0;f.BackgroundColor3=theme().Surface2;f.Parent=parent;mark(f,"Surface2");corner(f,8);stroke(f);return f
    end
    local function label(parent,text,size,role)
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Text=tostring(text or "");l.Font=Enum.Font.Gotham;l.TextSize=size or 12;l.TextWrapped=true;l.TextXAlignment=Enum.TextXAlignment.Left;l.TextYAlignment=Enum.TextYAlignment.Center;l.Size=UDim2.new(1,0,0,24);l.Parent=parent;mark(l,role or "Text");return l
    end
    local function button(parent,text)
        local b=Instance.new("TextButton");b.AutoButtonColor=false;b.Text=tostring(text or "");b.Font=Enum.Font.GothamMedium;b.TextSize=13;b.TextColor3=theme().Text;b.BorderSizePixel=0;b.BackgroundColor3=theme().Surface2;b.Parent=parent;mark(b,"Surface2");corner(b,7);return b
    end
    local function track(section,conn) if section and section.Window and section.Window.Track then section.Window:Track(conn) end; return conn end
    local function call(fn,...) if type(fn)=="function" then task.spawn(fn,...) end end
    local function clamp(n,a,b) return math.max(a,math.min(b,n)) end
    local function round(n,step) step=step or 1; return math.floor(n/step+0.5)*step end
    local function valObj(getter,setter,destroyer,signal)
        local o={Get=getter,Set=setter,Destroy=destroyer or function() end,OnChanged=function(_,fn) return signal and signal:Connect(fn) end}
        o.get=o.Get;o.set=o.Set;o.Destroy=o.Destroy
        return o
    end
    local function signal() return Cgode.StateManager:Signal() end
    local function addTitle(parent,name)
        local l=label(parent,name,12,"Text");l.Position=UDim2.fromOffset(10,0);l.Size=UDim2.new(1,-20,0,28);return l
    end

    local S={}
    function S:createText(text) local l=label(self.Content,text,12,"Muted");return l end
    S.createLabel=S.createText; S.createParagraph=S.createText
    function S:createDivider() local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,1);f.BorderSizePixel=0;f.Parent=self.Content;mark(f,"Border");return f end
    function S:createSpacer(height) local f=Instance.new("Frame");f.BackgroundTransparency=1;f.Size=UDim2.new(1,0,0,height or 10);f.Parent=self.Content;return f end
    function S:createButton(name,cb,opt)
        local f=frame(self.Content,42);local b=button(f,name);b.Size=UDim2.new(1,-10,1,-10);b.Position=UDim2.fromOffset(5,5);local sig=signal();
        track(self,b.MouseButton1Click:Connect(function() if opt==nil or opt.animated~=false then Cgode.AnimationManager:Pulse(b,theme().Accent,.08) end;sig:Fire(b);call(cb,b) end))
        local o=valObj(function() return b.Text end,function(_,v)b.Text=tostring(v)end,function()f:Destroy()end,sig);o.Instance=b;return o
    end
    function S:createIconButton(icon,cb,opt) return self:createButton(icon,cb,opt) end
    function S:createToggle(name,default,cb)
        local f=frame(self.Content,42);addTitle(f,name);local b=button(f,"");b.Size=UDim2.fromOffset(46,24);b.Position=UDim2.new(1,-56,.5,-12);local v=default==true;local sig=signal();
        local function render() b.Text=v and "✓" or ""; b.BackgroundColor3=v and theme().Accent or theme().Surface3 end;render()
        track(self,b.MouseButton1Click:Connect(function()v=not v;render();sig:Fire(v);call(cb,v)end));return valObj(function()return v end,function(_,z)v=not not z;render();sig:Fire(v);call(cb,v)end,function()f:Destroy()end,sig)
    end
    S.createCheckbox=S.createToggle
    function S:createRadio(name,default,cb) return self:createToggle(name,default,cb) end
    function S:createRadioGroup(name,options,default,cb)
        local f=frame(self.Content,math.max(44,#options*34+34));addTitle(f,name);local current=default or options[1];local sig=signal()
        for i,opt in ipairs(options or {}) do local b=button(f,(current==opt and "● " or "○ ")..tostring(opt));b.Position=UDim2.fromOffset(5,28+(i-1)*34);b.Size=UDim2.new(1,-10,0,28);track(self,b.MouseButton1Click:Connect(function()current=opt;for _,c in ipairs(f:GetChildren())do if c:IsA("TextButton") then c.Text=(c==b and "● " or "○ ")..tostring(c:GetAttribute("CgodeOption") or c.Text:gsub("^[●○] ","")) end end;sig:Fire(current);call(cb,current)end));b:SetAttribute("CgodeOption",tostring(opt)) end
        return valObj(function()return current end,function(_,v)current=v;sig:Fire(v);call(cb,v)end,function()f:Destroy()end,sig)
    end
    function S:createSlider(name,o,cb)
        o=o or {};local min=tonumber(o.min) or 0;local max=tonumber(o.max) or 100;local step=tonumber(o.step) or (o.precise and .1 or 1);local v=tonumber(o.default);if v==nil then v=tonumber(o.defualt) end;v=v or min
        local f=frame(self.Content,60);addTitle(f,name);local value=label(f,"",11,"Muted");value.Position=UDim2.new(1,-70,0,0);value.Size=UDim2.fromOffset(60,28);value.TextXAlignment=Enum.TextXAlignment.Right
        local bar=Instance.new("Frame");bar.Position=UDim2.fromOffset(10,38);bar.Size=UDim2.new(1,-20,0,6);bar.BorderSizePixel=0;bar.BackgroundColor3=theme().Border;bar.Parent=f;mark(bar,"Border");corner(bar,4)
        local fill=Instance.new("Frame");fill.BorderSizePixel=0;fill.BackgroundColor3=theme().Accent;fill.Size=UDim2.new();fill.Parent=bar;mark(fill,"Accent");corner(fill,4)
        local hit=Instance.new("TextButton");hit.BackgroundTransparency=1;hit.Text="";hit.Size=UDim2.new(1,12,0,24);hit.Position=UDim2.fromOffset(-6,-9);hit.Parent=bar
        local drag=false;local sig=signal();local function set(n,fire) n=clamp(n,min,max);n=round(n,step);if o.precise then n=tonumber(string.format("%.4f",n)) end;v=n;local pct=(max==min and 0 or (n-min)/(max-min));fill.Size=UDim2.new(pct,0,1,0);value.Text=tostring(n);if fire then sig:Fire(n);call(cb,n)end end
        local function update(x) set(min+(max-min)*clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1),true) end
        track(self,hit.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;update(i.Position.X)end end))
        track(self,UIS.InputChanged:Connect(function(i)if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then update(i.Position.X)end end))
        track(self,UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end));set(v,false)
        return valObj(function()return v end,function(_,z)set(tonumber(z) or min,true)end,function()f:Destroy()end,sig)
    end
    function S:createNumberInput(name,default,cb,o)
        o=o or {};local min=tonumber(o.min) or -math.huge;local max=tonumber(o.max) or math.huge;local step=tonumber(o.step) or 1;local current=tonumber(default) or min;if current==-math.huge then current=0 end
        local f=frame(self.Content,42);local x=Instance.new("TextBox");x.BackgroundTransparency=1;x.ClearTextOnFocus=false;x.Text=tostring(current);x.PlaceholderText=tostring(name or "Number");x.Font=Enum.Font.Gotham;x.TextSize=12;x.TextXAlignment=Enum.TextXAlignment.Left;x.Size=UDim2.new(1,-20,1,0);x.Position=UDim2.fromOffset(10,0);x.Parent=f;mark(x,"Text");local sig=signal()
        local function set(v,fire) v=round(clamp(tonumber(v) or current,min,max),step);current=v;x.Text=tostring(v);if fire then sig:Fire(v);call(cb,v)end end
        track(self,x.FocusLost:Connect(function()set(x.Text,true)end));return valObj(function()return current end,function(_,v)set(v,true)end,function()f:Destroy()end,sig)
    end
    function S:createTextBox(name,default,cb)
        local f=frame(self.Content,42)
        local x=Instance.new("TextBox")
        x.BackgroundTransparency=1;x.ClearTextOnFocus=false;x.Text=tostring(default or "");x.PlaceholderText=tostring(name or "Text")
        x.Font=Enum.Font.Gotham;x.TextSize=12;x.TextXAlignment=Enum.TextXAlignment.Left;x.Size=UDim2.new(1,-20,1,0);x.Position=UDim2.fromOffset(10,0);x.Parent=f;mark(x,"Text")
        local sig=signal()
        track(self,x.FocusLost:Connect(function()sig:Fire(x.Text);call(cb,x.Text)end))
        local o=valObj(function()return x.Text end,function(_,v)x.Text=tostring(v);sig:Fire(x.Text);call(cb,x.Text)end,function()f:Destroy()end,sig)
        o.getText=o.Get;o.GetText=o.Get;o.setText=o.Set;o.SetText=o.Set
        o.clearText=function()x.Text="";sig:Fire(x.Text);call(cb,x.Text)end;o.ClearText=o.clearText
        return o
    end
    S.CreateTextBox=S.createTextBox
    function S:createDropdown(name,options,default,cb)
        options=options or {};local current=default or options[1];local f=frame(self.Content,42);local b=button(f,tostring(name)..": "..tostring(current or "None"));b.Size=UDim2.new(1,-10,1,-10);b.Position=UDim2.fromOffset(5,5);local sig=signal();local popup
        local function close()if popup then popup:Destroy();popup=nil end end
        track(self,b.MouseButton1Click:Connect(function()if popup then close();return end;popup=Instance.new("ScrollingFrame");popup.BackgroundColor3=theme().Surface;popup.BorderSizePixel=0;popup.ScrollBarThickness=3;popup.Size=UDim2.new(1,0,0,math.min(#options*32+8,220));popup.Position=UDim2.fromOffset(0,44);popup.ZIndex=50;popup.Parent=f;mark(popup,"Surface");corner(popup,8);stroke(popup);local lay=Instance.new("UIListLayout");lay.Padding=UDim.new(0,3);lay.Parent=popup;local pad=Instance.new("UIPadding");pad.PaddingTop=UDim.new(0,4);pad.PaddingLeft=UDim.new(0,4);pad.PaddingRight=UDim.new(0,4);pad.Parent=popup;for _,opt in ipairs(options)do local q=button(popup,opt);q.Size=UDim2.new(1,0,0,28);q.ZIndex=51;track(self,q.MouseButton1Click:Connect(function()current=opt;b.Text=tostring(name)..": "..tostring(opt);close();sig:Fire(opt);call(cb,opt)end))end end));return valObj(function()return current end,function(_,v)current=v;b.Text=tostring(name)..": "..tostring(v);sig:Fire(v)end,function()close();f:Destroy()end,sig)
    end
    function S:createMultiDropdown(name,options,defaults,cb)
        local selected={};for _,v in ipairs(defaults or {})do selected[v]=true end;local f=frame(self.Content,42);local b=button(f,name..": "..tostring(#defaults));b.Size=UDim2.new(1,-10,1,-10);b.Position=UDim2.fromOffset(5,5);local sig=signal();local popup
        local function close()if popup then popup:Destroy();popup=nil end end
        local function emit()local out={};for _,opt in ipairs(options or {})do if selected[opt] then table.insert(out,opt)end end;b.Text=name..": "..tostring(#out);sig:Fire(out);call(cb,out);return out end
        track(self,b.MouseButton1Click:Connect(function()if popup then close();return end;popup=Instance.new("ScrollingFrame");popup.BackgroundColor3=theme().Surface;popup.BorderSizePixel=0;popup.Size=UDim2.new(1,0,0,math.min(#options*32+8,220));popup.Position=UDim2.fromOffset(0,44);popup.ZIndex=50;popup.Parent=f;mark(popup,"Surface");corner(popup,8);for i,opt in ipairs(options or {})do local q=button(popup,(selected[opt] and "✓ " or "□ ")..tostring(opt));q.Size=UDim2.new(1,-8,0,28);q.Position=UDim2.fromOffset(4,4+(i-1)*30);q.ZIndex=51;track(self,q.MouseButton1Click:Connect(function()selected[opt]=not selected[opt];q.Text=(selected[opt] and "✓ " or "□ ")..tostring(opt);emit()end))end end));return valObj(function()local out={};for _,o in ipairs(options or {})do if selected[o]then table.insert(out,o)end end;return out end,function(_,arr)selected={};for _,v in ipairs(arr or {})do selected[v]=true end;emit()end,function()close();f:Destroy()end,sig)
    end
    function S:createKeyBind(name,default,cb)
        local f=frame(self.Content,42);local b=button(f,"");b.Size=UDim2.new(1,-10,1,-10);b.Position=UDim2.fromOffset(5,5);local key=default or Enum.KeyCode.RightShift;local listening=false;local sig=signal();local function render()b.Text=name..": "..key.Name end;render()
        track(self,b.MouseButton1Click:Connect(function()listening=true;b.Text=name..": Press key..."end));track(self,UIS.InputBegan:Connect(function(i,g)if g then return end;if listening and i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode;listening=false;render();sig:Fire(key);call(cb,key);elseif not listening and i.KeyCode==key then call(cb,key) end end));return valObj(function()return key end,function(_,v)key=v;render();sig:Fire(key)end,function()f:Destroy()end,sig)
    end
    function S:createColorPicker(name,default,cb)
        local palette={Color3.fromRGB(92,136,255),Color3.fromRGB(71,205,131),Color3.fromRGB(235,91,91),Color3.fromRGB(241,181,77),Color3.fromRGB(190,100,240),Color3.fromRGB(86,173,239)};local index=1;local current=default or palette[1];local f=frame(self.Content,42);local b=button(f,name);b.Size=UDim2.new(1,-10,1,-10);b.Position=UDim2.fromOffset(5,5);local sig=signal();b.BackgroundColor3=current;track(self,b.MouseButton1Click:Connect(function()index=index%#palette+1;current=palette[index];b.BackgroundColor3=current;sig:Fire(current);call(cb,current)end));return valObj(function()return current end,function(_,v)current=v;b.BackgroundColor3=v;sig:Fire(v);call(cb,v)end,function()f:Destroy()end,sig)
    end
    function S:createBadge(text,role)
        local b=Instance.new("TextLabel");b.BackgroundColor3=theme().Accent;b.TextColor3=theme().Text;b.Font=Enum.Font.GothamMedium;b.TextSize=11;b.Size=UDim2.fromOffset(70,24);b.Text=tostring(text or "Badge");b.Parent=self.Content;mark(b,role or "Accent");corner(b,12);return b
    end
    function S:createLink(text,url,cb)
        local b=self:createButton("↗  "..tostring(text),function()call(cb,url);if type(setclipboard)=="function"then pcall(setclipboard,url)end end);return b
    end
    function S:createImage(assetId,height)
        local img=Instance.new("ImageLabel");img.BackgroundColor3=theme().Surface2;img.Size=UDim2.new(1,0,0,height or 120);img.ScaleType=Enum.ScaleType.Fit;img.Image=tostring(assetId or "");img.Parent=self.Content;mark(img,"Surface2");corner(img,8);return img
    end
    function S:createCodeBlock(text)
        local box=frame(self.Content,math.max(54,(select(2,string.gsub(tostring(text or ""),"\n","\n"))+1)*18+20));local l=label(box,text,11,"Muted");l.Position=UDim2.fromOffset(10,8);l.Size=UDim2.new(1,-20,1,-16);l.Font=Enum.Font.Code;l.TextYAlignment=Enum.TextYAlignment.Top;return l
    end

    function S:createSearchBox(name,items,cb)
        local f=frame(self.Content,42);local x=Instance.new("TextBox");x.BackgroundTransparency=1;x.ClearTextOnFocus=false;x.PlaceholderText=tostring(name or "Search");x.Text="";x.Font=Enum.Font.Gotham;x.TextSize=12;x.TextXAlignment=Enum.TextXAlignment.Left;x.Size=UDim2.new(1,-20,1,0);x.Position=UDim2.fromOffset(10,0);x.Parent=f;mark(x,"Text");local sig=signal();local source=items or {}
        local function filter(query) local out={};query=tostring(query or ""):lower();for _,item in ipairs(source)do local text=tostring(item.label or item.name or item);if query=="" or text:lower():find(query,1,true)then out[#out+1]=item end end;sig:Fire(out,query);call(cb,out,query);return out end
        track(self,x:GetPropertyChangedSignal("Text"):Connect(function()filter(x.Text)end));local o=valObj(function()return x.Text end,function(_,v)x.Text=tostring(v);filter(x.Text)end,function()f:Destroy()end,sig);o.Filter=filter;return o
    end
    function S:createComboBox(name,options,cb) return self:createDropdown(name,options,options[1],cb) end
    function S:createCommandPalette(commands,cb)
        local b=self:createButton("⌘  Command Palette",function()
            local items={};for _,cmd in ipairs(commands or {})do items[#items+1]=(cmd.title or cmd.name or tostring(cmd)) end
            self.Window:ShowCommandPalette(items,cb,commands)
        end);return b
    end
    function S:createContextMenu(items,cb)
        local b=self:createButton("⋯  Context menu",function()self.Window:ShowContextMenu(items,cb)end);return b
    end
    function S:createAccordion(name,body,open)
        local f=frame(self.Content,open and 84 or 42);local b=button(f,(open and "▾  " or "▸  ")..name);b.BackgroundTransparency=1;b.Size=UDim2.new(1,0,0,34);b.TextXAlignment=Enum.TextXAlignment.Left;local l=label(f,body,11,"Muted");l.Position=UDim2.fromOffset(10,36);l.Size=UDim2.new(1,-20,0,40);l.Visible=open;track(self,b.MouseButton1Click:Connect(function()l.Visible=not l.Visible;f.Size=UDim2.new(1,0,0,l.Visible and 84 or 42);b.Text=(l.Visible and "▾  " or "▸  ")..name end));return {Get=function()return l.Visible end,Set=function(_,v)l.Visible=v end,Destroy=function()f:Destroy()end}
    end
    function S:createSegmentedControl(name,options,default,cb) return self:createRadioGroup(name,options,default,cb) end
    function S:createTagInput(name,defaults,cb)
        local current={table.unpack(defaults or {})};local input=self:createTextBox(name,"",function(text)if text~=""then table.insert(current,text);call(cb,current)end end);return valObj(function()return current end,function(_,v)current=v;call(cb,current)end,function()input:Destroy()end,signal())
    end
    function S:createStepper(name,default,min,max,step,cb)
        local value=tonumber(default) or 0;step=step or 1;min=min or -math.huge;max=max or math.huge;local f=frame(self.Content,42);local l=addTitle(f,name);l.Size=UDim2.new(1,-100,1,0);local minus=button(f,"−");minus.Size=UDim2.fromOffset(26,26);minus.Position=UDim2.new(1,-64,.5,-13);local plus=button(f,"+");plus.Size=UDim2.fromOffset(26,26);plus.Position=UDim2.new(1,-34,.5,-13);local sig=signal();local function set(v,fire)value=clamp(v,min,max);l.Text=name..": "..tostring(value);if fire then sig:Fire(value);call(cb,value)end end;track(self,minus.MouseButton1Click:Connect(function()set(value-step,true)end));track(self,plus.MouseButton1Click:Connect(function()set(value+step,true)end));set(value,false);return valObj(function()return value end,function(_,v)set(v,true)end,function()f:Destroy()end,sig)
    end
    function S:createRangeSlider(name,options,cb)
        options=options or {};local a=self:createSlider(name.." Min",{min=options.min or 0,max=options.max or 100,default=(options.default and options.default[1]) or options.min or 0,step=options.step},function()end);local b=self:createSlider(name.." Max",{min=options.min or 0,max=options.max or 100,default=(options.default and options.default[2]) or options.max or 100,step=options.step},function()end);local sig=signal();local function emit()local lo,hi=a:Get(),b:Get();if lo>hi then lo,hi=hi,lo end;sig:Fire(lo,hi);call(cb,lo,hi)end;a:OnChanged(emit);b:OnChanged(emit);return valObj(function()local lo,hi=a:Get(),b:Get();return lo,hi end,function(_,lo,hi)a:Set(lo);b:Set(hi);emit()end,function()a:Destroy();b:Destroy()end,sig)
    end
    function S:createXYPad(name,default,cb)
        local f=frame(self.Content,150);addTitle(f,name);local pad=Instance.new("Frame");pad.Position=UDim2.fromOffset(10,32);pad.Size=UDim2.new(1,-20,0,108);pad.BackgroundColor3=theme().Surface3;pad.BorderSizePixel=0;pad.Parent=f;mark(pad,"Surface3");corner(pad,8);local dot=Instance.new("Frame");dot.Size=UDim2.fromOffset(10,10);dot.BackgroundColor3=theme().Accent;dot.BorderSizePixel=0;dot.Parent=pad;mark(dot,"Accent");corner(dot,5);local value=default or {0.5,0.5};local sig=signal();local drag=false;local function set(x,y) value={clamp(x,0,1),clamp(y,0,1)};dot.Position=UDim2.new(value[1],-5,value[2],-5);sig:Fire(value);call(cb,value) end;local function move(px,py)set((px-pad.AbsolutePosition.X)/math.max(1,pad.AbsoluteSize.X),(py-pad.AbsolutePosition.Y)/math.max(1,pad.AbsoluteSize.Y))end;track(self,pad.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;move(i.Position.X,i.Position.Y)end end));track(self,UIS.InputChanged:Connect(function(i)if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then move(i.Position.X,i.Position.Y)end end));track(self,UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end));set(value[1],value[2]);return valObj(function()return value end,function(_,v)set(v[1],v[2])end,function()f:Destroy()end,sig)
    end
    function S:createTreeView(name,nodes,cb)
        local f=frame(self.Content,42);local title=addTitle(f,name);local lines={};local height=34
        local function render(list,depth)
            for _,node in ipairs(list or {})do height+=28;local b=button(f,string.rep("  ",depth or 0).."• "..tostring(node.name or node.title or node));b.Position=UDim2.fromOffset(5,height-28);b.Size=UDim2.new(1,-10,0,24);track(self,b.MouseButton1Click:Connect(function()call(cb,node)end));if node.children then render(node.children,(depth or 0)+1)end end
            f.Size=UDim2.new(1,0,0,height)
        end;render(nodes,0);return {Destroy=function()f:Destroy()end,Refresh=function(_,newNodes)for _,c in ipairs(f:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end;height=34;render(newNodes,0)end}
    end
    function S:createDatePicker(name,default,cb) return self:createTextBox(name,default or os.date("%Y-%m-%d"),cb) end
    function S:createTimePicker(name,default,cb) return self:createTextBox(name,default or os.date("%H:%M"),cb) end
    function S:createAutocomplete(name,options,cb) return self:createComboBox(name,options,cb) end
    function S:createPagination(total,current,cb)
        total=math.max(1,tonumber(total) or 1);current=clamp(tonumber(current) or 1,1,total);local f=frame(self.Content,42);local prev=button(f,"‹");prev.Size=UDim2.fromOffset(32,28);prev.Position=UDim2.fromOffset(5,7);local l=addTitle(f,"Page "..current.." / "..total);l.Position=UDim2.fromOffset(45,7);l.Size=UDim2.new(1,-90,0,28);l.TextXAlignment=Enum.TextXAlignment.Center;local next=button(f,"›");next.Size=UDim2.fromOffset(32,28);next.Position=UDim2.new(1,-37,0,7);local sig=signal();local function set(v)current=clamp(v,1,total);l.Text="Page "..current.." / "..total;sig:Fire(current);call(cb,current)end;track(self,prev.MouseButton1Click:Connect(function()set(current-1)end));track(self,next.MouseButton1Click:Connect(function()set(current+1)end));return valObj(function()return current end,function(_,v)set(v)end,function()f:Destroy()end,sig)
    end
    function S:createRating(name,max,default,cb)
        max=max or 5;local current=default or 0;local f=frame(self.Content,42);addTitle(f,name);local sig=signal();for i=1,max do local b=button(f,i<=current and "★" or "☆");b.Size=UDim2.fromOffset(26,26);b.Position=UDim2.new(1,-(max-i+1)*28,.5,-13);track(self,b.MouseButton1Click:Connect(function()current=i;for j,c in ipairs(f:GetChildren())do if c:IsA("TextButton")then local n=tonumber(c.Text:gsub("[☆★]",""));if n then c.Text=j<=i and "★" or "☆" end end end;sig:Fire(current);call(cb,current)end))end;return valObj(function()return current end,function(_,v)current=v;sig:Fire(v);call(cb,v)end,function()f:Destroy()end,sig)
    end
    function S:createBreadcrumbs(items,cb)
        local b=self:createButton(table.concat(items or {},"  /  "),function()call(cb,items)end);return b
    end
    function S:createPopover(title,content) return self:createAccordion(title,content,false) end

    function S:createList(items,cb)
        local count=#(items or {});local f=frame(self.Content,math.min(220,34+count*30));for i,item in ipairs(items or {})do local b=button(f,item);b.Size=UDim2.new(1,-10,0,26);b.Position=UDim2.fromOffset(5,5+(i-1)*30);track(self,b.MouseButton1Click:Connect(function()call(cb,item,i)end))end;return {Refresh=function(_,new)for _,c in ipairs(f:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end;for i,item in ipairs(new or {})do local b=button(f,item);b.Size=UDim2.new(1,-10,0,26);b.Position=UDim2.fromOffset(5,5+(i-1)*30);track(self,b.MouseButton1Click:Connect(function()call(cb,item,i)end))end;f.Size=UDim2.new(1,0,0,math.min(220,34+#(new or {})*30)) end,Destroy=function()f:Destroy()end}
    end
    function S:createVirtualList(items,cb) return self:createList(items,cb) end
    function S:createTable(headers,rows)
        local total=math.min(320,40+(#rows)*28);local f=frame(self.Content,total);for c,h in ipairs(headers or {})do local l=label(f,h,11,"Text");l.Position=UDim2.new((c-1)/math.max(1,#headers),5,0,5);l.Size=UDim2.new(1/math.max(1,#headers),-10,0,24) end;for r,row in ipairs(rows or {})do for c,v in ipairs(row)do local l=label(f,v,10,"Muted");l.Position=UDim2.new((c-1)/math.max(1,#headers),5,0,25+r*28);l.Size=UDim2.new(1/math.max(1,#headers),-10,0,24)end end;return f
    end
    function S:createDataGrid(headers,rows) return self:createTable(headers,rows) end
    function S:createStatistics(stats)
        local cols=math.max(1,#stats);local f=frame(self.Content,64);for i,item in ipairs(stats or {})do local title=item.label or item[1] or "Value";local value=item.value or item[2] or "-";local l=label(f,title,10,"Muted");l.Position=UDim2.new((i-1)/cols,5,0,6);l.Size=UDim2.new(1/cols,-10,0,20);local v=label(f,value,18,"Text");v.Position=UDim2.new((i-1)/cols,5,0,27);v.Size=UDim2.new(1/cols,-10,0,28);v.TextXAlignment=Enum.TextXAlignment.Center end;return f
    end
    function S:createActivityFeed(items)
        local lines={};for i,item in ipairs(items or {})do lines[#lines+1]=(item.time and ("["..item.time.."] ") or "")..tostring(item.text or item.message or item) end;return self:createCodeBlock(table.concat(lines,"\n"))
    end
    function S:createTimeline(items,cb) return self:createActivityFeed(items) end
    function S:createSparkline(values)
        local f=frame(self.Content,60);for i,v in ipairs(values or {})do local bar=Instance.new("Frame");bar.BorderSizePixel=0;bar.BackgroundColor3=theme().Accent;bar.Size=UDim2.new(1/math.max(1,#values)-.01,0,clamp(tonumber(v) or 0,0,1),0);bar.Position=UDim2.new((i-1)/math.max(1,#values),0,1-clamp(tonumber(v) or 0,0,1),0);bar.AnchorPoint=Vector2.new(0,0);bar.Parent=f;mark(bar,"Accent");corner(bar,3)end;return f
    end
    function S:createBarChart(values) return self:createSparkline(values) end
    function S:createLogViewer(lines) return self:createCodeBlock(table.concat(lines or {},"\n")) end

    local function layoutMaker(self,name)
        return {Name=name,Parent=self.Content,Refresh=function()end}
    end
    for _,name in ipairs({"Container","Stack","Row","Column","Grid","ResponsiveGrid","SplitPane","ScrollContainer","Overlay","Card","Panel"}) do
        S["create"..name]=function(self,options) return layoutMaker(self,name) end
    end
    function S:createLoading(text) return self:createText("⟳  "..tostring(text or "Loading…")) end
    S.createSpinner=S.createLoading
    function S:createSkeleton(text) return self:createText("░░░  "..tostring(text or "Loading placeholder")) end
    function S:createProgress(value,labelText)
        local f=frame(self.Content,52);local l=addTitle(f,labelText or "Progress");local bar=Instance.new("Frame");bar.Position=UDim2.fromOffset(10,34);bar.Size=UDim2.new(1,-20,0,7);bar.BackgroundColor3=theme().Border;bar.BorderSizePixel=0;bar.Parent=f;mark(bar,"Border");corner(bar,4);local fill=Instance.new("Frame");fill.BackgroundColor3=theme().Accent;fill.BorderSizePixel=0;fill.Parent=bar;mark(fill,"Accent");corner(fill,4);local v=clamp(tonumber(value) or 0,0,1);fill.Size=UDim2.new(v,0,1,0);return {Get=function()return v end,Set=function(_,x)v=clamp(tonumber(x) or 0,0,1);fill.Size=UDim2.new(v,0,1,0)end,Destroy=function()f:Destroy()end}
    end
    function S:createNotification(title,message,duration,kind) return self.Window:notification(title,message,duration,kind) end
    S.createToast=S.createNotification
    function S:createDialog(title,message,buttons) return self.Window:ShowDialog(title,message,buttons) end
    function S:createConfirmDialog(title,message,onConfirm,onCancel) return self.Window:ShowConfirm(title,message,onConfirm,onCancel) end
    function S:createTooltip(text) return self:createText("ⓘ  "..tostring(text)) end
    function S:createEmptyState(title,message) return self:createText((title or "Nothing here").."\n"..tostring(message or "")) end
    function S:createErrorState(title,message) return self:createText("⚠  "..tostring(title or "Error").."\n"..tostring(message or "")) end
    function S:createBanner(message,kind)
        local f=frame(self.Content,38);local l=label(f,message,11,kind=="danger" and "Danger" or kind=="success" and "Success" or "Info");l.Position=UDim2.fromOffset(10,0);l.Size=UDim2.new(1,-20,1,0);return f
    end
    -- Expose both idiomatic createX and compatibility X aliases.
    for method,fn in pairs(S) do
        if type(method)=="string" and method:sub(1,6)=="create" and #method>6 then
            local short=method:sub(7);S[short]=fn;S[short:sub(1,1):lower()..short:sub(2)]=fn;S[short:sub(1,1):upper()..short:sub(2)]=fn
        end
    end
    return S
end
