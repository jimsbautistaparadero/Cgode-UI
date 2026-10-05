return function(Cgode)
    local M={}
    function M:Encode(data) return game:GetService("HttpService"):JSONEncode(data) end
    function M:Decode(data) return game:GetService("HttpService"):JSONDecode(data) end
    function M:Merge(base,partial)for k,v in pairs(partial or {})do base[k]=v end;return base end
    return M
end
