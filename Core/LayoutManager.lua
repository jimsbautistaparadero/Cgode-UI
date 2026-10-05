local M={};M.__index=M
function M.new(device) return setmetatable({Device=device,Breakpoints={Compact=420,Small=600,Medium=900,Large=1200,Wide=1600}},M) end
function M:GetBreakpoint(width) if width<self.Breakpoints.Compact then return "Compact" elseif width<self.Breakpoints.Small then return "Small" elseif width<self.Breakpoints.Medium then return "Medium" elseif width<self.Breakpoints.Large then return "Large" elseif width<self.Breakpoints.Wide then return "Wide" end return "Ultrawide" end
function M:Apply(window,viewport) local bp=self:GetBreakpoint(viewport.X); window:SetResponsiveMode(bp) end
return M
