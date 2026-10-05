return function(Cgode)
    return {Name="Universal",Active=function() return Cgode:GetDevice()=="Universal" end,Capabilities=function() return Cgode.DeviceManager:Capabilities() end}
end
