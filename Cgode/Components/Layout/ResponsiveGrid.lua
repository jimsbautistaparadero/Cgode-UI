return function(Cgode)
    return {Name="ResponsiveGrid",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createResponsiveGrid"]; assert(type(method)=="function", "Cgode UI: ResponsiveGrid is not available on this section"); return method(section,...) end}
end
