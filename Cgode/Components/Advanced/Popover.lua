return function(Cgode)
    return {Name="Popover",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createPopover"]; assert(type(method)=="function", "Cgode UI: Popover is not available on this section"); return method(section,...) end}
end
