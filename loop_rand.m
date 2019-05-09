function W = loop_rand(n,m,frus,n_loops)

% This function generates an instance using the random loop algorithm while
% imposing the non-intersecting condition

W = zeros(n,m);
Wneg = ones(n,m);
Wpos = ones(n,m);
loop = 0;

while loop < n_loops
    
h0 = randsample(m,1); % choose a random column h0

% randomly select two elements in that column such that W(v1,h0) <= 0 and
% W(v0,h0) >= 0. If no such elements exists in h0, select another column.
vpos = find(Wpos(:,h0).'); vneg = find(Wneg(:,h0).');
if length(vpos) > 1
v0 = randsample(vpos,1);
elseif length(vpos) == 1
v0 = vpos;
else
continue;
end
vneg = setdiff(vneg,v0);
if length(vneg) > 1
v1 = randsample(vneg,1);
elseif length(vneg) == 1
v1 = vneg;
else
continue;
end

% Find another column h1 such that W(v0,h1) >= 0 and W(v1,h1) >= 0. If no
% such column exists, restart from the beginning of the algorithm.
hindices = [];
for j = setdiff(1:m,h0)
    if Wpos(v0,j) && Wpos(v1,j) 
        hindices = [hindices j];
    end
end
hl = length(hindices);
if hl == 0
    continue;
elseif hl == 1
    h1 = hindices;
else
    h1 = randsample(hindices,1);
end

% superpose the loop on the weight matrix
W(v1,h0) = W(v1,h0) - 3*frus/(1-frus); Wpos(v1,h0) = 0;
W(v0,h0) = W(v0,h0) + 1; Wneg(v0,h0) = 0;
W(v1,h1) = W(v1,h1) + 1; Wneg(v1,h1) = 0;
W(v0,h1) = W(v0,h1) + 1; Wneg(v0,h1) = 0;

loop = loop + 1;
    
end

end