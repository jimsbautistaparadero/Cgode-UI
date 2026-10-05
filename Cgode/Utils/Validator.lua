return function(Cgode)
    return {Required=function(_,v)return v~=nil and tostring(v)~=""end,Number=function(_,v)return tonumber(v)~=nil end,Range=function(_,v,a,b)local n=tonumber(v);return n and n>=a and n<=b end}
end
