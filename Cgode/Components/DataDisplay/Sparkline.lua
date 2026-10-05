return function(Cgode)
    return {Name="Sparkline",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createSparkline"]; assert(type(method)=="function", "Cgode UI: Sparkline is not available on this section"); return method(section,...) end}
end
