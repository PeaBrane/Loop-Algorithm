function [c2,w2] = get_c2(w,i,j)

if w > 0
    c2 = [i, -j; -i, j]; w2 = [w; w];
elseif w < 0
    c2 = [i, j; -i, -j]; w2 = [-w; -w];
end

end