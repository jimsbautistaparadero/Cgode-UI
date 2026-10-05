local Draggable=require(script.Parent.Parent.Utils.Draggable)
local Resizable=require(script.Parent.Parent.Utils.Resizable)
local M={};M.__index=M
function M.new() return setmetatable({Windows={},Active=nil},M) end
function M:Register(window) table.insert(self.Windows,window); self.Active=window end
function M:BringToFront(window) self.Active=window; for i,w in ipairs(self.Windows) do if w==window then w.Root.ZIndex=1000; else w.Root.ZIndex=100+i end end end
function M:Snap(window,side,viewport) local p=window.Root; if side=="left" then p.Position=UDim2.fromOffset(0,0); p.Size=UDim2.fromOffset(viewport.X/2,viewport.Y) elseif side=="right" then p.Position=UDim2.fromOffset(viewport.X/2,0); p.Size=UDim2.fromOffset(viewport.X/2,viewport.Y) elseif side=="top" then p.Position=UDim2.fromOffset(0,0); p.Size=UDim2.fromOffset(viewport.X,viewport.Y/2) elseif side=="bottom" then p.Position=UDim2.fromOffset(0,viewport.Y/2); p.Size=UDim2.fromOffset(viewport.X,viewport.Y/2) end end
function M:AddDrag(window,handle) return Draggable.bind(handle,window.Root) end
function M:AddResize(window,handle,minSize,maxSize) return Resizable.bind(handle,window.Root,minSize,maxSize) end
return M
