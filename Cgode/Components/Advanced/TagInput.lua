return function(Cgode)
    return {Name="TagInput",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createTagInput"]; assert(type(method)=="function", "Cgode UI: TagInput is not available on this section"); return method(section,...) end}
end
