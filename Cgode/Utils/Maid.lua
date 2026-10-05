return function(Cgode)
    local M={};M.__index=M
    function M.new()return setmetatable({Tasks={}},M)end
    function M:Give(taskItem)table.insert(self.Tasks,taskItem);return taskItem end
    function M:Cleanup()for _,taskItem in ipairs(self.Tasks)do pcall(function()if typeof(taskItem)=="RBXScriptConnection"then taskItem:Disconnect()elseif type(taskItem)=="function"then taskItem()elseif type(taskItem)=="table"and taskItem.Destroy then taskItem:Destroy()elseif type(taskItem)=="table"and taskItem.Disconnect then taskItem:Disconnect()end end)end;table.clear(self.Tasks)end
    M.Destroy=M.Cleanup
    return M
end
