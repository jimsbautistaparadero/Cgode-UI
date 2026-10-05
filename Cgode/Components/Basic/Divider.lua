return function(Cgode)
    return {Name="Divider",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createDivider"]; assert(type(method)=="function", "Cgode UI: Divider is not available on this section"); return method(section,...) end}
end
