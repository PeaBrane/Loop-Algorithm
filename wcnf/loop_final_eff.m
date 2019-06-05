function [vl,hl,Wvi,Whi,Wv,Wh] = loop_final_eff(n,m,frus,n_loops)

Wvi = zeros(n,min(5*ceil(n_loops/n),m));
Whi = zeros(m,min(5*ceil(n_loops/m),n));
Wv = zeros(n,min(5*ceil(n_loops/n),m));
Wh = zeros(m,min(5*ceil(n_loops/m),n));
vl = zeros(1,n);
hl = zeros(1,m);

loop = 0;
alpha = 3*frus/(1-frus)*1000;
alpha = floor(alpha);

while loop < n_loops
    
h0 = randsample(m,1); 

if hl(h0) > 0

vneg = setdiff(1:n,Whi(h0,Wh(h0,1:hl(h0)) > 0));
vpos = setdiff(1:n,Whi(h0,Wh(h0,1:hl(h0)) < 0));

if length(vpos) > 1
v1 = randsample(vpos,1);
elseif length(vpos) == 1
v1 = vpos;
else
continue;
end

vneg = setdiff(vneg,v1);
if length(vneg) > 1
v0 = randsample(vneg,1);
elseif length(vneg) == 1
v0 = vneg;
else
continue;
end

else
    
vlist = randsample(1:n,2); v0 = vlist(1); v1 = vlist(2);

end

harr0 = setdiff(1:m,Wvi(v0,Wv(v0,1:vl(v0)) < 0)); 
harr1 = setdiff(1:m,Wvi(v1,Wv(v1,1:vl(v1)) < 0));

harr = intersect(harr0, harr1);
if isempty(harr)
    continue;
else
    harr = setdiff(harr,h0);
    hlen = length(harr);
end

if hlen == 0
    continue;
elseif hlen == 1
    h1 = harr;
else
    h1 = randsample(harr,1);
end

vlist = [v0 v1]; hlist = [h0 h1];
for v = vlist
for h = hlist

if v == v0 && h == h0
    add = -alpha;
else
    add = 1000;
end
    
if hl(h) == 0 
    vl(v) = vl(v) + 1; Wv(v,vl(v)) = add; Wvi(v,vl(v)) = h;
    hl(h) = hl(h) + 1; Wh(h,hl(h)) = add; Whi(h,hl(h)) = v;
elseif ~ismember(h,Wvi(v,1:vl(v)))
    vl(v) = vl(v) + 1; Wv(v,vl(v)) = add; Wvi(v,vl(v)) = h;
    hl(h) = hl(h) + 1; Wh(h,hl(h)) = add; Whi(h,hl(h)) = v;
else
    hi = h == Wvi(v,1:vl(v));
    vi = v == Whi(h,1:hl(h));
    Wv(v,hi) = Wv(v,hi) + add;
    Wh(h,vi) = Wh(h,vi) + add;
end

end
end

loop = loop + 1;
    
end

end