return function(Cgode)
    return {Name="Dialog",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createDialog"]; assert(type(method)=="function", "Cgode UI: Dialog is not available on this section"); return method(section,...) end}
end
