return function(Cgode)
    return {New=function(_,class,props,parent)local i=Instance.new(class);for k,v in pairs(props or {})do pcall(function()i[k]=v end)end;i.Parent=parent;return i end,Find=function(_,root,name)return root and root:FindFirstChild(name,true)end}
end
