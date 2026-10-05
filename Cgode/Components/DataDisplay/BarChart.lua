return function(Cgode)
    return {Name="BarChart",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createBarChart"]; assert(type(method)=="function", "Cgode UI: BarChart is not available on this section"); return method(section,...) end}
end
