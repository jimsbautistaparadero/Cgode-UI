return function(Cgode)
    return {Name="TimePicker",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createTimePicker"]; assert(type(method)=="function", "Cgode UI: TimePicker is not available on this section"); return method(section,...) end}
end
