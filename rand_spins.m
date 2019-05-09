function v = rand_spins(n)

% This function generates n spins of random configuration of values {-1,1}

v(1:n) = 0;
for i = 1:n
    x = rand();
    if x<0.5
        v(i) = -1;
    else
        v(i) = 1;
    end
end

end