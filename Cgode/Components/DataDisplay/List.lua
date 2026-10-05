return function(Cgode)
    return {Name="List",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createList"]; assert(type(method)=="function", "Cgode UI: List is not available on this section"); return method(section,...) end}
end
