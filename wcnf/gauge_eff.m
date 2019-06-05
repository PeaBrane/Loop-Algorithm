function [v,h,Wv] = gauge_eff(n,m,vl,Wvi,Wv)

x_list = datasample(1:n-1,ceil((n-1)/2),'Replace',false);
y_list = datasample(1:m-1,ceil((m-1)/2),'Replace',false);
Wv(x_list,:) = -Wv(x_list,:);

for i = 1:n
    index = ismember(Wvi(i,1:vl(i)),y_list);
    Wv(i,index) = -Wv(i,index);
end

v(1:n-1) = 1; v(x_list) = -1;
h(1:m-1) = 1; h(y_list) = -1;

end