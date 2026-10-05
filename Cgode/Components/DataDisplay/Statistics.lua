return function(Cgode)
    return {Name="Statistics",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createStatistics"]; assert(type(method)=="function", "Cgode UI: Statistics is not available on this section"); return method(section,...) end}
end
