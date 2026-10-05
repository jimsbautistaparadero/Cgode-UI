return function(Cgode)
    return {Name="TextBox",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createTextBox"]; assert(type(method)=="function", "Cgode UI: TextBox is not available on this section"); return method(section,...) end}
end
