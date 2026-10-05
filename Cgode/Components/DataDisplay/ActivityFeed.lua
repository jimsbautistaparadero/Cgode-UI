return function(Cgode)
    return {Name="ActivityFeed",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createActivityFeed"]; assert(type(method)=="function", "Cgode UI: ActivityFeed is not available on this section"); return method(section,...) end}
end
