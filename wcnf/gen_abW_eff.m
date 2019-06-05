function [vl,Wvi,Wv,v,h,E,offset] = gen_abW_eff(n,m,n_loops,frus)

[vl,~,Wvi,~,Wv,~] = loop_final_eff(n+1,m+1,frus,n_loops);

E = sum(Wv(:));

index = find(Wvi(n+1,:) == m+1);
if ~isempty(index)
offset = Wv(n+1,index);
E = E - offset;
else
offset = 0;
end

[v,h,Wv] = gauge_eff(n+1,m+1,vl,Wvi,Wv);

end