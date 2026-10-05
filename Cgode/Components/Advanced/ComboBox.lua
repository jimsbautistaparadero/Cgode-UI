return function(Cgode)
    return {Name="ComboBox",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createComboBox"]; assert(type(method)=="function", "Cgode UI: ComboBox is not available on this section"); return method(section,...) end}
end
