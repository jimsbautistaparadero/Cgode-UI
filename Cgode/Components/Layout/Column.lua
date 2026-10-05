return function(Cgode)
    return {Name="Column",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createColumn"]; assert(type(method)=="function", "Cgode UI: Column is not available on this section"); return method(section,...) end}
end
