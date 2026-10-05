return function(Cgode)
    return {Name="Spinner",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createSpinner"]; assert(type(method)=="function", "Cgode UI: Spinner is not available on this section"); return method(section,...) end}
end
