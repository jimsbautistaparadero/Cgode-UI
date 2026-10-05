local Control=require(script.Parent.Parent.Base.Control)
return function(ctx,placeholder,callback) local c=require(script.Parent.Parent.Basic.Textbox)(ctx,placeholder or "Search"); c.Changed:Connect(function(v) if callback then callback(v) end end); return c end
