return function(Cgode)
    return {Name="RangeSlider",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createRangeSlider"]; assert(type(method)=="function", "Cgode UI: RangeSlider is not available on this section"); return method(section,...) end}
end
