return function(Cgode)
    return {Name="SplitPane",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createSplitPane"]; assert(type(method)=="function", "Cgode UI: SplitPane is not available on this section"); return method(section,...) end}
end
