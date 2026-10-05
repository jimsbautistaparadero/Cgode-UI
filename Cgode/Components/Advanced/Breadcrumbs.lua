return function(Cgode)
    return {Name="Breadcrumbs",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createBreadcrumbs"]; assert(type(method)=="function", "Cgode UI: Breadcrumbs is not available on this section"); return method(section,...) end}
end
