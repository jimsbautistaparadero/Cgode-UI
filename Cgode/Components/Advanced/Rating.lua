return function(Cgode)
    return {Name="Rating",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createRating"]; assert(type(method)=="function", "Cgode UI: Rating is not available on this section"); return method(section,...) end}
end
