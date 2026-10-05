return function(Cgode)
    return {Name="Toggle",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createToggle"]; assert(type(method)=="function", "Cgode UI: Toggle is not available on this section"); return method(section,...) end}
end
