return function(Cgode)
    return {Name="Grid",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createGrid"]; assert(type(method)=="function", "Cgode UI: Grid is not available on this section"); return method(section,...) end}
end
