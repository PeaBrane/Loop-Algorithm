function [sat_entry, n_sat_size, cnf, weight_entry] = convert_to_SAT_eff(n,m,vl,Wvi,Wv)

c1 = zeros(n+m,1);
w1 = zeros(n+m,1);
c2 = zeros(sum(vl(1:n))*2,2);
w2 = zeros(sum(vl(1:n))*2,1);

count1 = 1; count2 = 1;
for i = 1:n
    for ii = 1:vl(i)
        j = Wvi(i,ii); w = Wv(i,ii);
        if j == m+1
            [c1(count1),w1(count1)] = get_c1(w,i);
            count1 = count1 + 1;
        else
            [c2(count2:count2+1,:),w2(count2:count2+1,:)] = get_c2(w,i,n+j);
            count2 = count2 + 2;
        end
    end
end

for ii = 1:vl(n+1)
    j = Wvi(n+1,ii); w = Wv(n+1,ii);
    if j ~= m+1
        [c1(count1),w1(count1)] = get_c1(w,n+j);
        count1 = count1 + 1;
    end
end

c1 = c1(1:count1-1,:);
w1 = w1(1:count1-1,:);
c2 = c2(1:count2-1,:);
w2 = w2(1:count2-1,:);

sat_entry{1, 1} = c1;
sat_entry{1, 2} = c2;

weight_entry{1, 1} = w1;
weight_entry{2, 1} = w2;

n_sat_size = [1, 2];
cnf = [size(c1,1), size(c2,1)];

end