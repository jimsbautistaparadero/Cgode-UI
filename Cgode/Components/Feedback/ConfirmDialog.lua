return function(Cgode)
    return {Name="ConfirmDialog",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createConfirmDialog"]; assert(type(method)=="function", "Cgode UI: ConfirmDialog is not available on this section"); return method(section,...) end}
end
