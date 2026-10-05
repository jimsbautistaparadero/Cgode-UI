return function(Cgode)
    return {Name="IconButton",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createIconButton"]; assert(type(method)=="function", "Cgode UI: IconButton is not available on this section"); return method(section,...) end}
end
