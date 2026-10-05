return function(Cgode)
    return {Name="Checkbox",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createCheckbox"]; assert(type(method)=="function", "Cgode UI: Checkbox is not available on this section"); return method(section,...) end}
end
