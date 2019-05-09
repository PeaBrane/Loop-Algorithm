function W = loop_struct(n,m,frus,nl1,nl2,nl3)

% This function generates an instance using the structured loop algorithm.
% nl1 denotes the number of top loops
% nl2 denotes the number of left loops
% nl3 denotes the number of center loops

n1 = ceil(n/2); m1 = ceil(m/2);
W = zeros(n,m);

Wpos = ones(n1,m1); 
% records the indices of the positive weight elements in the upper-left
Wneg = ones(n1,m1); 
% records the indices of the negative weight elements in the upper-left

loop = 0;

while loop < nl1 % generate top loops
   
% randomly select a non-positive weight element in the upper-left quadrant
% {v0,h0}
h0 = randsample(m1,1); 
v_list = find(Wneg(:,h0).');
if length(v_list) < 1
    continue;
elseif length(v_list) == 1
    v0 = v_list;
else
    v0 = randsample(v_list,1);
end

% randomly select a non-negative weight element in the upper-left quadrant
% in the same column {v1,h0}
v_list = find(Wpos(:,h0).');
if length(v_list) < 1
    continue;
end
v_list = setdiff(v_list,v0);
if length(v_list) < 1
    continue;
elseif length(v_list) == 1
    v1 = v_list;
else
    v1 = randsample(v_list,1);
end    

% randomly select a column in the right half of the weight matrix
h1 = randsample(m1+1:m,1);

% superpose a top loop on the weight matrix
W(v0,h0) = W(v0,h0) - 3*frus/(1-frus); Wpos(v0,h0) = 0;
W(v0,h1) = W(v0,h1) + 1; 
W(v1,h0) = W(v1,h0) + 1; Wneg(v1,h0) = 0;
W(v1,h1) = W(v1,h1) + 1; 

loop = loop + 1;

end

loop = 0;
while loop < nl2

% randomly select a non-positive weight element in the upper-left quadrant
% {v0,h0}
v0 = randsample(n1,1);
h_list = find(Wneg(v0,:));
if length(h_list) < 1
    continue;
elseif length(h_list) == 1
    h0 = h_list;
else
    h0 = randsample(h_list,1);
end

% randomly select a non-negative weight element in the upper-left quadrant
% of the same row {v0,h1}
h_list = find(Wpos(v0,:));
if length(h_list) < 1
    continue;
end
h_list = setdiff(h_list,h0);
if length(h_list) < 1
    continue;
elseif length(h_list) == 1
    h1 = h_list;
else
    h1 = randsample(h_list,1);
end

% randomly select a row in the bottom half of the weight matrix
v1 = randsample(n1+1:n,1);

% superpose a left loop on the weight matrix
W(v0,h0) = W(v0,h0) - 3*frus/(1-frus); Wpos(v0,h0) = 0;
W(v0,h1) = W(v0,h1) + 1; Wneg(v0,h1) = 0;
W(v1,h0) = W(v1,h0) + 1; 
W(v1,h1) = W(v1,h1) + 1; 

loop = loop + 1;

end

loop = 0;
while loop < nl3
 
% randomly select a non-positive weight element in the upper-left quadrant
% {v0,h0}    
h0 = randsample(m1,1);
v_list = find(Wneg(:,h0).');
if length(v_list) < 1
    continue;
elseif length(v_list) == 1
    v0 = v_list;
else
    v0 = randsample(v_list,1);
end

% randomly select a row in the bottom half of the weight matrix and a
% column in the right half of the weight matrix
v1 = randsample(n1+1:n,1);
h1 = randsample(m1+1:m,1);

% superpose a center loop on the weight matrix
W(v0,h0) = W(v0,h0) - 3*frus/(1-frus); Wpos(v0,h0) = 0;
W(v0,h1) = W(v0,h1) + 1;
W(v1,h0) = W(v1,h0) + 1; 
W(v1,h1) = W(v1,h1) + 1; 

loop = loop + 1;
end

end