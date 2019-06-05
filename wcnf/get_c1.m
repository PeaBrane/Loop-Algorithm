function [c1,w1] = get_c1(a,i)

if a > 0
    c1 = i; w1 = a;
elseif a < 0
    c1 = -i; w1 = -a;
end

end