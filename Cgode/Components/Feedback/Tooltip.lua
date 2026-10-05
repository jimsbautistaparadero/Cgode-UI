return function(Cgode)
    return {Name="Tooltip",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createTooltip"]; assert(type(method)=="function", "Cgode UI: Tooltip is not available on this section"); return method(section,...) end}
end
