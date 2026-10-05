return function(Cgode)
    return {Clamp=math.clamp,Lerp=function(_,a,b,t)return a+(b-a)*t end,Round=function(_,n,step)step=step or 1;return math.floor(n/step+.5)*step end,Map=function(_,n,a,b,c,d)return c+(n-a)/(b-a)*(d-c)end}
end
