return function(Cgode)
    return {Name="LogViewer",Group="DataDisplay",Version=Cgode.Version,Create=function(section,...) local method=section["createLogViewer"]; assert(type(method)=="function", "Cgode UI: LogViewer is not available on this section"); return method(section,...) end}
end
