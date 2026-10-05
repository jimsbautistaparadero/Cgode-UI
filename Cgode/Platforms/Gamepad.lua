return function(Cgode)
    return {Name="Gamepad",Active=function() return Cgode:GetDevice()=="Gamepad" end,Capabilities=function() return Cgode.DeviceManager:Capabilities() end}
end
