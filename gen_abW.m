function [a,b,w,v,h,E] = gen_abW(n,m,n_loops,loop_ratio,vers,frus)

% nl1 is the number of top loops
% nl2 is the number of left loops
% nl3 is the number of center loops
% By default, the function sets nl1 = nl2 and nl3/nl1 = loop_ratio, with
% the condition nl1 + nl2 + nl3 = n_loops
nl1 = ceil(n_loops/(2+loop_ratio));
nl2 = ceil(n_loops/(2+loop_ratio));
nl3 = ceil(n_loops*loop_ratio/(2+loop_ratio));

if vers == 0 % random loop algorithm
    W = loop_rand(n+1,m+1,frus,n_loops);
elseif vers == 1 % structured loop algorithm
    W = loop_struct(n+1,m+1,frus,nl1,nl2,nl3);
else
    printf('Version Error');
end
% W is the full gauged RBM weight matrix containing the biases

E = sum(W(:));
c = W(n+1,m+1);
E = E - c;
% E is the planted energy solution

[v,h,Wg] = gauge_inverse(n+1,m+1,W);
% Transform the gauged RBM weight matrix such that {v,h} is the new
% solution configuration

w = Wg(1:n,1:m);
% extract the two-body weight matrix from the full weight matrix
a(1:n) = Wg(1:n,m+1).';
% biases of the visible nodes
b(1:m) = Wg(n+1,1:m);
% biases of the hidden nodes

end