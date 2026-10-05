return function(Cgode)
    return {Name="Stack",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createStack"]; assert(type(method)=="function", "Cgode UI: Stack is not available on this section"); return method(section,...) end}
end
