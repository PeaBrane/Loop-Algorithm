function [v,h,W] = gauge_inverse(n,m,W)

% This function takes a gauged RBM weight matrix and randomly flips half of
% the rows followed by randomly flipping half of the columns

x_list = datasample(1:n-1,ceil((n-1)/2),'Replace',false);
% indices of the rows to be flipped
y_list = datasample(1:m-1,ceil((m-1)/2),'Replace',false);
% indices of the columns to be flipped

W(x_list,:) = -W(x_list,:);
W(:,y_list) = -W(:,y_list);
% flipping the weight matrix elements

v(1:n-1) = 1; v(x_list) = -1;
h(1:m-1) = 1; h(y_list) = -1;
% the spin configurations corresponding to the switching subset

end