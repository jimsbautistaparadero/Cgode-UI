local Component=require(script.Parent.Parent.Base.Component)
return function(ctx,size) local f=Instance.new("Frame",ctx.Parent);f.Name="Container";f.Size=size or UDim2.new(1,0,0,100);f.BackgroundColor3=ctx.Theme:Get("Surface");f.BorderSizePixel=0;Instance.new("UICorner",f).CornerRadius=UDim.new(0,12);Instance.new("UIStroke",f).Color=ctx.Theme:Get("Border");return Component.new(f,ctx) end
