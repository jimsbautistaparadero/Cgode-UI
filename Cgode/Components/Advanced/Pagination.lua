return function(Cgode)
    return {Name="Pagination",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createPagination"]; assert(type(method)=="function", "Cgode UI: Pagination is not available on this section"); return method(section,...) end}
end
