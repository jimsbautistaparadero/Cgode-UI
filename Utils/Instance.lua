local M={}
function M.new(class,parent,props) local o=Instance.new(class); if props then for k,v in pairs(props) do o[k]=v end end; if parent then o.Parent=parent end; return o end
function M.destroyChildren(parent,keep) for _,c in ipairs(parent:GetChildren()) do if not keep or not keep[c] then c:Destroy() end end end
return M
