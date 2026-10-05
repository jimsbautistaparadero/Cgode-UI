return function(Cgode)
    return {Name="Progress",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createProgress"]; assert(type(method)=="function", "Cgode UI: Progress is not available on this section"); return method(section,...) end}
end
