return function(Cgode)
    return {Name="DataGrid",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createDataGrid"]; assert(type(method)=="function", "Cgode UI: DataGrid is not available on this section"); return method(section,...) end}
end
