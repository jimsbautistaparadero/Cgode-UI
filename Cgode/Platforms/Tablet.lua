return function(Cgode)
    return {Name="Tablet",Active=function() return Cgode:GetDevice()=="Tablet" end,Capabilities=function() return Cgode.DeviceManager:Capabilities() end}
end
