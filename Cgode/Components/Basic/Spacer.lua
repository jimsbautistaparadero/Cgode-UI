return function(Cgode)
    return {Name="Spacer",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createSpacer"]; assert(type(method)=="function", "Cgode UI: Spacer is not available on this section"); return method(section,...) end}
end
