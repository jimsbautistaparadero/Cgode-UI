local M={}
function M.toHex(c) return string.format("#%02X%02X%02X",math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5)) end
function M.fromHex(hex) hex=hex:gsub("#",""); if #hex~=6 then return Color3.new(1,1,1) end local r=tonumber(hex:sub(1,2),16) or 255; local g=tonumber(hex:sub(3,4),16) or 255; local b=tonumber(hex:sub(5,6),16) or 255; return Color3.fromRGB(r,g,b) end
function M.withAlpha(c,a) return {Color=c,Alpha=a} end
return M
