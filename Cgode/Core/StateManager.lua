return function(Cgode)
    local M = {Data={}, Listeners={}}
    local Signal = {}
    Signal.__index = Signal
    function Signal.new() return setmetatable({_listeners={}},Signal) end
    function Signal:Connect(fn)
        table.insert(self._listeners,fn)
        local alive=true
        return {Disconnect=function() if not alive then return end; alive=false; for i,v in ipairs(self._listeners) do if v==fn then table.remove(self._listeners,i); break end end end}
    end
    function Signal:Fire(...)
        local args = {...}
        for _,fn in ipairs(self._listeners) do
            task.spawn(function() pcall(function() fn(table.unpack(args)) end) end)
        end
    end
    function M:Signal() return Signal.new() end
    function M:Create(key, initial)
        assert(type(key)=="string","Cgode StateManager: key must be a string")
        if self.Data[key] == nil then self.Data[key] = initial end
        local signal = self.Listeners[key] or Signal.new(); self.Listeners[key]=signal
        return {Get=function() return self.Data[key] end, Set=function(_,value) self:Set(key,value) end, Update=function(_,fn) self:Set(key,fn(self.Data[key])) end, Subscribe=function(_,fn) return signal:Connect(fn) end}
    end
    function M:Get(key) return self.Data[key] end
    function M:Set(key,value)
        self.Data[key]=value
        if self.Listeners[key] then self.Listeners[key]:Fire(value) end
        return value
    end
    function M:Update(key,fn) return self:Set(key,fn(self.Data[key])) end
    function M:Subscribe(key,fn) local signal=self.Listeners[key] or Signal.new(); self.Listeners[key]=signal; return signal:Connect(fn) end
    function M:Remove(key) self.Data[key]=nil; self.Listeners[key]=nil end
    function M:Clear() self.Data={}; self.Listeners={} end
    function M:Snapshot() local out={}; for k,v in pairs(self.Data) do out[k]=v end; return out end
    return M
end
