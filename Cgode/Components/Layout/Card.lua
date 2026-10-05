return function(Cgode)
    return {Name="Card",Group="Layout",Version=Cgode.Version,Create=function(section,...) local method=section["createCard"]; assert(type(method)=="function", "Cgode UI: Card is not available on this section"); return method(section,...) end}
end
