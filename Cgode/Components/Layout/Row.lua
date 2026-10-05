return function(Cgode)
    return {Name="Row",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createRow"]; assert(type(method)=="function", "Cgode UI: Row is not available on this section"); return method(section,...) end}
end
