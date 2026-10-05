return function(Cgode)
    return {Name="KeyBind",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createKeyBind"]; assert(type(method)=="function", "Cgode UI: KeyBind is not available on this section"); return method(section,...) end}
end
