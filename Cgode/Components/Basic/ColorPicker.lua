return function(Cgode)
    return {Name="ColorPicker",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createColorPicker"]; assert(type(method)=="function", "Cgode UI: ColorPicker is not available on this section"); return method(section,...) end}
end
