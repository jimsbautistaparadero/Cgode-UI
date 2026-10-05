return function(Cgode)
    return {Name="DatePicker",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createDatePicker"]; assert(type(method)=="function", "Cgode UI: DatePicker is not available on this section"); return method(section,...) end}
end
