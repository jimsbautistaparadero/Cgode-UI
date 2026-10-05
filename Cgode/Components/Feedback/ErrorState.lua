return function(Cgode)
    return {Name="ErrorState",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createErrorState"]; assert(type(method)=="function", "Cgode UI: ErrorState is not available on this section"); return method(section,...) end}
end
