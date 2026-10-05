return function(Cgode)
    return {Name="Gamepad",Active=function() return Cgode:GetDevice()=="Gamepad" end}
end
