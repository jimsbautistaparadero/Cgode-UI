return function(Cgode)
    return {Name="MultiDropdown",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createMultiDropdown"]; assert(type(method)=="function", "Cgode UI: MultiDropdown is not available on this section"); return method(section,...) end}
end
