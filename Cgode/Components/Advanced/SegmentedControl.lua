return function(Cgode)
    return {Name="SegmentedControl",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createSegmentedControl"]; assert(type(method)=="function", "Cgode UI: SegmentedControl is not available on this section"); return method(section,...) end}
end
