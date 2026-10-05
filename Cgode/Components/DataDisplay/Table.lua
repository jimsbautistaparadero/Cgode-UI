return function(Cgode)
    return {Name="Table",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createTable"]; assert(type(method)=="function", "Cgode UI: Table is not available on this section"); return method(section,...) end}
end
