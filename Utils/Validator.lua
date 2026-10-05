local M={}
function M.number(v,min,max) v=tonumber(v); if not v then return nil,"Expected a number" end; if min and v<min then return nil,"Below minimum" end; if max and v>max then return nil,"Above maximum" end; return v end
function M.string(v) if v==nil then return nil,"Expected text" end return tostring(v) end
function M.oneOf(v,list) for _,x in ipairs(list or {}) do if v==x then return v end end return nil,"Invalid value" end
return M
