return function(Cgode)
    return {Name="Banner",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createBanner"]; assert(type(method)=="function", "Cgode UI: Banner is not available on this section"); return method(section,...) end}
end
