return function(Cgode)
    return {Name="Skeleton",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createSkeleton"]; assert(type(method)=="function", "Cgode UI: Skeleton is not available on this section"); return method(section,...) end}
end
