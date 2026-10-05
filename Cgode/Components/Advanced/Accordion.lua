return function(Cgode)
    return {Name="Accordion",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createAccordion"]; assert(type(method)=="function", "Cgode UI: Accordion is not available on this section"); return method(section,...) end}
end
