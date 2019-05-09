function [sat_entry, n_sat_size, cnf, weight_entry] = convert_to_SAT(n,m,a,b,W)
    
% This function converts a spin-glass instance into a MAX-2-SAT problem
% sat_entry records the clauses
% weight_entry records the weights associated with the clauses
% n_sat_size is simply [1,2], denoting that the problem only contains
% 1-clauses and 2-clauses
% cnf records the number of 1-clauses and the number of 2-clauses

c_1 = zeros(n+m, 1); % 1-clauses
w_1 = zeros(n+m, 1); % weights associated with the 1-clauses

for i = 1:n
    if a(i) > 0
        c_1(i) = i;
        w_1(i) = a(i);
    else
        c_1(i) = -i;
        w_1(i) = -a(i);
    end
end

for i = 1:m
    if b(i) > 0
        c_1(n+i) = n+i;
        w_1(n+i) = b(i);
    else
        c_1(n+i) = -(n+i);
        w_1(n+i) = -b(i);
    end
end

c_2 = zeros(2*n*m, 2); % 2-clauses
w_2 = zeros(2*n*m, 1); % weights associated with the 2-clauses

for i = 1:n
    for j = 1:m
        k = m*(i-1)+j;
        k1 = n+m+2*k-1;
        k2 = n+m+2*k;
        if W(i,j) > 0
            c_2(2*k-1, 1) = i;
            c_2(2*k-1, 2) = -(n+j);
            c_2(2*k, 1) = -i;
            c_2(2*k, 2) = n+j;
            w_2(2*k-1) = W(i,j);
            w_2(2*k) = W(i,j);
        else 
            c_2(2*k-1, 1) = i;
            c_2(2*k-1, 2) = n+j;
            c_2(2*k, 1) = -i;
            c_2(2*k, 2) = -(n+j);
            w_2(2*k-1) = -W(i,j);
            w_2(2*k) = -W(i,j);
        end
    end
end

sat_entry{1, 1} = c_1;
sat_entry{1, 2} = c_2;

weight_entry{1, 1} = w_1;
weight_entry{2, 1} = w_2;

n_sat_size = [1, 2];
cnf = [n + m, 2*n*m];

end