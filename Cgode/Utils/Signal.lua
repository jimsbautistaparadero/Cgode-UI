return function(Cgode)
    local S={};S.__index=S
    function S.new()return setmetatable({_listeners={}},S)end
    function S:Connect(fn)table.insert(self._listeners,fn);local dead=false;return {Disconnect=function()if dead then return end;dead=true;for i,v in ipairs(self._listeners)do if v==fn then table.remove(self._listeners,i);break end end end}end
    function S:Fire(...)
        local args={...}
        for _,fn in ipairs(self._listeners)do task.spawn(function()pcall(function()fn(table.unpack(args))end)end)end
    end
    return S
end
