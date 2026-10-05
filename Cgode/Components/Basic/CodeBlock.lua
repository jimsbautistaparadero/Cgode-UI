return function(Cgode)
    return {Name="CodeBlock",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createCodeBlock"]; assert(type(method)=="function", "Cgode UI: CodeBlock is not available on this section"); return method(section,...) end}
end
