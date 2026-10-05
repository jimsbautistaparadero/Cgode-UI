local Component=require(script.Parent.Parent.Base.Component)
return function(ctx) local f=Instance.new("Frame",ctx.Overlay);f.Name="Overlay";f.Size=UDim2.fromScale(1,1);f.BackgroundTransparency=1;return Component.new(f,ctx) end
