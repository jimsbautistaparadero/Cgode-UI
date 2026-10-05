return function(Cgode)
    return {Name="Loading",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createLoading"]; assert(type(method)=="function", "Cgode UI: Loading is not available on this section"); return method(section,...) end}
end
