return function(Cgode)
    return {Name="NumberInput",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createNumberInput"]; assert(type(method)=="function", "Cgode UI: NumberInput is not available on this section"); return method(section,...) end}
end
