return function(Cgode)
    return {Name="Radio",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createRadio"]; assert(type(method)=="function", "Cgode UI: Radio is not available on this section"); return method(section,...) end}
end
