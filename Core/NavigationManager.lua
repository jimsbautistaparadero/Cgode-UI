local M={};M.__index=M
function M.new(window) return setmetatable({Window=window,Current=nil,History={},Index=0},M) end
function M:Go(tab,record) if record~=false and self.Current then self.History[self.Index+1]=tab; self.Index+=1 end self.Current=tab; self.Window:_showTab(tab) end
function M:Back() if self.Index>0 then self.Index-=1; local t=self.History[self.Index]; if t then self.Current=t; self.Window:_showTab(t) end end end
function M:Forward() local t=self.History[self.Index+1]; if t then self.Index+=1; self.Current=t; self.Window:_showTab(t) end end
return M
