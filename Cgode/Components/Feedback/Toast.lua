return function(Cgode)
    return {Name="Toast",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createToast"]; assert(type(method)=="function", "Cgode UI: Toast is not available on this section"); return method(section,...) end}
end
