return function(Cgode)
    return {Name="Timeline",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createTimeline"]; assert(type(method)=="function", "Cgode UI: Timeline is not available on this section"); return method(section,...) end}
end
