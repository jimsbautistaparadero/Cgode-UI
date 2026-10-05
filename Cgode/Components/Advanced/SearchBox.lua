return function(Cgode)
    return {Name="SearchBox",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createSearchBox"]; assert(type(method)=="function", "Cgode UI: SearchBox is not available on this section"); return method(section,...) end}
end
