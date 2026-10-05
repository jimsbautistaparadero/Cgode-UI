local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({_bindable = Instance.new("BindableEvent")}, Signal)
end
function Signal:Connect(fn)
    return self._bindable.Event:Connect(fn)
end
function Signal:Once(fn)
    local c; c = self._bindable.Event:Connect(function(...) c:Disconnect(); fn(...) end); return c
end
function Signal:Fire(...) self._bindable:Fire(...) end
function Signal:Destroy() if self._bindable then self._bindable:Destroy(); self._bindable=nil end end
return Signal
