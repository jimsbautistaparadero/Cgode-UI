return function(Cgode)
    return {Name="Notification",Group="Feedback",Version=Cgode.Version,Create=function(section,...) local method=section["createNotification"]; assert(type(method)=="function", "Cgode UI: Notification is not available on this section"); return method(section,...) end}
end
