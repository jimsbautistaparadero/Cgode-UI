return function(Cgode)
    return {Name="RadioGroup",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createRadioGroup"]; assert(type(method)=="function", "Cgode UI: RadioGroup is not available on this section"); return method(section,...) end}
end
