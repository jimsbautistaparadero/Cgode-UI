return function(Cgode)
    return {Name="Button",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createButton"]; assert(type(method)=="function", "Cgode UI: Button is not available on this section"); return method(section,...) end}
end
