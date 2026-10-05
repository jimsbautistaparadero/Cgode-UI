return function(Cgode)
    return {Name="Label",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createLabel"]; assert(type(method)=="function", "Cgode UI: Label is not available on this section"); return method(section,...) end}
end
