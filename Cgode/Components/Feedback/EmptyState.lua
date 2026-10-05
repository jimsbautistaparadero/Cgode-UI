return function(Cgode)
    return {Name="EmptyState",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createEmptyState"]; assert(type(method)=="function", "Cgode UI: EmptyState is not available on this section"); return method(section,...) end}
end
