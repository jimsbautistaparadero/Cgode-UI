return function(Cgode)
    return {Name="Slider",Group="Basic",Version=Cgode.Version,Create=function(section,...) local method=section["createSlider"]; assert(type(method)=="function", "Cgode UI: Slider is not available on this section"); return method(section,...) end}
end
