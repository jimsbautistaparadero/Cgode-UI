return function(Cgode)
    return {Name="Paragraph",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createParagraph"]; assert(type(method)=="function", "Cgode UI: Paragraph is not available on this section"); return method(section,...) end}
end
