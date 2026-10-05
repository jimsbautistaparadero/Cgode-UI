return function(Cgode)
    return {Name="Autocomplete",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createAutocomplete"]; assert(type(method)=="function", "Cgode UI: Autocomplete is not available on this section"); return method(section,...) end}
end
