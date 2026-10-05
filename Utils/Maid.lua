local Maid={}; Maid.__index=Maid
function Maid.new() return setmetatable({_tasks={}},Maid) end
function Maid:Give(task) table.insert(self._tasks,task); return task end
function Maid:Cleanup() for i=#self._tasks,1,-1 do local t=self._tasks[i]; self._tasks[i]=nil; local k=typeof(t); if k=="RBXScriptConnection" then t:Disconnect() elseif k=="Instance" then t:Destroy() elseif type(t)=="function" then pcall(t) elseif type(t)=="table" then if t.Destroy then pcall(function() t:Destroy() end) elseif t.Disconnect then pcall(function() t:Disconnect() end) elseif t.Cleanup then pcall(function() t:Cleanup() end) end end end end
function Maid:Destroy() self:Cleanup() end
return Maid
