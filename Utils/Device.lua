local UIS=game:GetService("UserInputService")
local M={}
function M.hasTouch() return UIS.TouchEnabled end
function M.hasKeyboard() return UIS.KeyboardEnabled end
function M.hasMouse() return UIS.MouseEnabled end
function M.hasGamepad() return #UIS:GetConnectedGamepads()>0 or UIS.GamepadEnabled end
function M.classify() local cam=workspace.CurrentCamera; local v=cam and cam.ViewportSize or Vector2.new(1280,720); if UIS.TouchEnabled and math.min(v.X,v.Y)<700 then return "Mobile" elseif UIS.TouchEnabled then return "Tablet" else return "Desktop" end end
return M
