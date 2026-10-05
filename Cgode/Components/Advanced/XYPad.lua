return function(Cgode)
    return {Name="XYPad",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createXYPad"]; assert(type(method)=="function", "Cgode UI: XYPad is not available on this section"); return method(section,...) end}
end
