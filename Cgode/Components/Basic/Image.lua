return function(Cgode)
    return {Name="Image",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createImage"]; assert(type(method)=="function", "Cgode UI: Image is not available on this section"); return method(section,...) end}
end
