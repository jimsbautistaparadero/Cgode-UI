return function(Cgode)
    local HttpService=game:GetService("HttpService")
    local M={Memory={}}
    local function merge(a,b) local out={}; for k,v in pairs(a or {}) do out[k]=v end; for k,v in pairs(b or {}) do out[k]=v end; return out end
    function M:Encode(data) return HttpService:JSONEncode(data or {}) end
    function M:Decode(raw) return HttpService:JSONDecode(raw) end
    function M:Save(name,data)
        assert(type(name)=="string" and name~="","Cgode ConfigManager: invalid name")
        self.Memory[name]=data or {}
        if type(writefile)=="function" then
            local ok,err=pcall(function() writefile("Cgode_"..name..".json",self:Encode(data)) end)
            return ok,err
        end
        return true
    end
    function M:Load(name,defaults)
        local data
        if type(readfile)=="function" and type(isfile)=="function" then
            local ok,raw=pcall(function() if isfile("Cgode_"..name..".json") then return readfile("Cgode_"..name..".json") end end)
            if ok and raw then local ok2,result=pcall(function() return self:Decode(raw) end); if ok2 then data=result end end
        end
        if data==nil then data=self.Memory[name] end
        return merge(defaults or {},data or {})
    end
    function M:Delete(name)
        self.Memory[name]=nil
        if type(delfile)=="function" and type(isfile)=="function" and isfile("Cgode_"..name..".json") then pcall(function() delfile("Cgode_"..name..".json") end) end
    end
    function M:Exists(name) if self.Memory[name]~=nil then return true end; return type(isfile)=="function" and isfile("Cgode_"..name..".json") or false end
    return M
end
