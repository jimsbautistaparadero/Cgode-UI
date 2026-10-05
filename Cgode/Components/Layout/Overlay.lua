return function(Cgode)
    return {Name="Overlay",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createOverlay"]; assert(type(method)=="function", "Cgode UI: Overlay is not available on this section"); return method(section,...) end}
end
