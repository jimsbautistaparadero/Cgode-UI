return function(Cgode)
    return {Name="Badge",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createBadge"]; assert(type(method)=="function", "Cgode UI: Badge is not available on this section"); return method(section,...) end}
end
