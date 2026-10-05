local M={}
function M.clamp(v,a,b) return math.max(a,math.min(b,v)) end
function M.lerp(a,b,t) return a+(b-a)*t end
function M.round(v,p) local m=10^(p or 0); return math.floor(v*m+0.5)/m end
function M.snap(v,step) if not step or step<=0 then return v end return math.floor(v/step+0.5)*step end
return M
