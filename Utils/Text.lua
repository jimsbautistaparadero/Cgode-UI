local M={}
function M.measure(text,font,size,maxWidth) local b=game:GetService("TextService"):GetTextSize(tostring(text or ""),size,font,Vector2.new(maxWidth or 1e6,1e6)); return b.X,b.Y end
function M.ellipsis(text,maxChars) text=tostring(text or ""); if #text<=maxChars then return text end return text:sub(1,math.max(0,maxChars-1)).."…" end
return M
