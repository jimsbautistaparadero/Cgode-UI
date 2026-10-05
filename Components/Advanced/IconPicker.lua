local icons=require(script.Parent.Parent.Parent.Assets.Icons)
return function(ctx,callback) local names={};for k in pairs(icons)do table.insert(names,k)end;table.sort(names);return require(script.Parent.Parent.Basic.Dropdown)(ctx,"Icon",names,nil,callback,false) end
