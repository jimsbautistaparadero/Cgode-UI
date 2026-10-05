return function(Cgode)
    return {Name="Dropdown",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createDropdown"]; assert(type(method)=="function", "Cgode UI: Dropdown is not available on this section"); return method(section,...) end}
end
