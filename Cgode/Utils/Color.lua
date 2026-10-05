return function(Cgode)
    return {Lerp=function(_,a,b,t)return a:Lerp(b,t)end,ToHex=function(_,c)return string.format("#%02X%02X%02X",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255))end,FromRGB=function(_,r,g,b)return Color3.fromRGB(r,g,b)end}
end
