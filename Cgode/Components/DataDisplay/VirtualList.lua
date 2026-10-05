return function(Cgode)
    return {Name="VirtualList",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createVirtualList"]; assert(type(method)=="function", "Cgode UI: VirtualList is not available on this section"); return method(section,...) end}
end
