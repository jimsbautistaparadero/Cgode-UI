return function(Cgode)
    return {Trim=function(_,s)return tostring(s or ""):gsub("^%s+"," "):gsub("%s+$"," ")end,Words=function(_,s)local out={};for w in tostring(s or ""):gmatch("%S+")do out[#out+1]=w end;return out end}
end
