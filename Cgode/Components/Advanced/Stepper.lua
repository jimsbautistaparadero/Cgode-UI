return function(Cgode)
    return {Name="Stepper",Group="Advanced",Version=Cgode.Version,Create=function(section,...) local method=section["createStepper"]; assert(type(method)=="function", "Cgode UI: Stepper is not available on this section"); return method(section,...) end}
end
