return function(Cgode)
    return {Name="Panel",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createPanel"]; assert(type(method)=="function", "Cgode UI: Panel is not available on this section"); return method(section,...) end}
end
