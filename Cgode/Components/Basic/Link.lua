return function(Cgode)
    return {Name="Link",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createLink"]; assert(type(method)=="function", "Cgode UI: Link is not available on this section"); return method(section,...) end}
end
