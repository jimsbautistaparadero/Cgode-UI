local HttpService=game:GetService("HttpService")
local M={};M.__index=M
function M.new(namespace,defaults) return setmetatable({Namespace=namespace or "CgodeUI",Defaults=defaults or {},Data=table.clone(defaults or {})},M) end
function M:Reset() self.Data=table.clone(self.Defaults); return self.Data end
function M:Set(k,v) self.Data[k]=v end
function M:Get(k) return self.Data[k] end
function M:Export() return HttpService:JSONEncode(self.Data) end
function M:Import(json) local ok,data=pcall(function() return HttpService:JSONDecode(json) end); if ok and type(data)=="table" then self.Data=data; return true end return false end
return M
