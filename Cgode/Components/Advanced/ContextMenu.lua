return function(Cgode)
    return {Name="ContextMenu",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createContextMenu"]; assert(type(method)=="function", "Cgode UI: ContextMenu is not available on this section"); return method(section,...) end}
end
