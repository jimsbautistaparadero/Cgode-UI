return function(Cgode)
    local M={Stores={}}
    function M:Create(initial)
        local state=table.clone(initial or {});local listeners={}
        local obj={}
        function obj:Get(k)return state[k]end
        function obj:Set(k,v)state[k]=v;for _,fn in ipairs(listeners[k] or {}) do task.spawn(fn,v)end end
        function obj:Bind(k,fn)
            listeners[k]=listeners[k] or {};table.insert(listeners[k],fn);fn(state[k])
            return function()for i,x in ipairs(listeners[k])do if x==fn then table.remove(listeners[k],i)break end end end
        end
        function obj:Snapshot()return table.clone(state)end
        return obj
    end
    return M
end
