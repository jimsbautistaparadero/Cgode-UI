return function(Cgode)
    return {Name="ScrollContainer",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createScrollContainer"]; assert(type(method)=="function", "Cgode UI: ScrollContainer is not available on this section"); return method(section,...) end}
end
