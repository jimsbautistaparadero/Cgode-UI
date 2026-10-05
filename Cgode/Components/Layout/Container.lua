return function(Cgode)
    return {Name="Container",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createContainer"]; assert(type(method)=="function", "Cgode UI: Container is not available on this section"); return method(section,...) end}
end
