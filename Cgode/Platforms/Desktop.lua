return function(Cgode)
    return {Name="Desktop",Active=function() return Cgode:GetDevice()=="Desktop" end,Capabilities=function() return Cgode.DeviceManager:Capabilities() end}
end
