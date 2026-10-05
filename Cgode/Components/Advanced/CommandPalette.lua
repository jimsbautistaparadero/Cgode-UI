return function(Cgode)
    return {Name="CommandPalette",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createCommandPalette"]; assert(type(method)=="function", "Cgode UI: CommandPalette is not available on this section"); return method(section,...) end}
end
