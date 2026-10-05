return function(Cgode)
    return {Name="TreeView",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createTreeView"]; assert(type(method)=="function", "Cgode UI: TreeView is not available on this section"); return method(section,...) end}
end
