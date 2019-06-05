clear;

runs = 10; % number of instances
n_list = [100 200 500]; % sizes of RBM
n_length = length(n_list); 
frus_list = [0.2:0.01:0.24]; % frustration indices
frus_length = length(frus_list);
density_list = [0.5 1 2 5]; % loop densities
density_length = length(density_list);

density_opt = 0; % if true, use hardess loop density

tot_length = n_length*frus_length*density_length;

for tot = 1:tot_length

density_iter = mod(tot-1,density_length)+1;
quo = fix((tot-1)/density_length)+1;
frus_iter = mod(quo-1,frus_length)+1;
n_iter = fix((quo-1)/frus_length)+1;
    
n = n_list(n_iter); m = n;
frus = frus_list(frus_iter);
density = density_list(density_iter);

if density_opt
density = 0.3035 + 0.2952*exp(-0.0196*n);
end

% directory name
dn = strcat(num2str(n),"x",num2str(m),"RBM_",num2str(frus),'_',num2str(density));
mkdir(dn);

for run = 1:runs

n_loops = ceil(density*(n+1));

% generate bipartite lattice
[vl,Wvi,Wv,v,h,E,offset] = gen_abW_eff(n,m,n_loops,frus);
E_cost = (sum(abs(Wv(:))) - offset - E)/2;
v_sol = round((v+1)/2);
h_sol = round((h+1)/2);

% convert lattice instance to weighted MAX-2-SAT
[sat_entry, n_sat_size, cnf, weight_entry] = convert_to_SAT_eff(n,m,vl,Wvi,Wv);
w1 = weight_entry{1,1}.'; w2 = weight_entry{2,1}.'; weight = [w1 w2];
c1 = sat_entry{1,1}; c2 = sat_entry{1,2}; 
wmax = max(weight);
nclause = length(weight);

vars = abs([c1.' c2(:,1).' c2(:,2).']);
vars = unique(vars);
nvar = length(vars);

indices = zeros(1,n+m);
for i = 1:nvar
    indices(vars(i)) = i;
end

% create wcnf file and comment lines
filename = strcat(dn,'/',dn,'_',num2str(run),'.wcnf');
fid = fopen(filename,'w'); 
text = 'c\n';
text = [text 'c Generated using the random loop algorithm on a '];
text = [text num2str(n) 'x' num2str(m) ' RBM.' '\nc Frustration Index: ' num2str(frus)...
       '\nc Loop Density: ' num2str(density) '\nc Optimal Cost: ' num2str(E_cost) '\nc \n'...
       'p wcnf ' num2str(nvar) ' ' num2str(nclause) ' ' num2str(wmax+1) '\n'];

% record the clauses in wcnf format
chr_l = length(num2str(wmax)) + 2*length(num2str(nvar)) + 8;
ctxt_list = blanks(nclause*chr_l);
count = 0;
for i = 1:length(w1)
    c = c1(i,1); index = indices(abs(c))*sign(c);
    ctxt = [num2str(w1(i)) ' ' num2str(index) ' ' num2str(0) '\n'];
    l = length(ctxt);
    ctxt_list(count+1:count+l) = ctxt;
    count = count + l;
end
for i = 1:length(w2)
    c = c2(i,1); index1 = indices(abs(c))*sign(c);
    c = c2(i,2); index2 = indices(abs(c))*sign(c);
    ctxt = [num2str(w2(i)) ' ' num2str(index1) ' ' num2str(index2) ' ' num2str(0) '\n'];
    l = length(ctxt);
    ctxt_list(count+1:count+l) = ctxt;
    count = count + l;
end
text = [text ctxt_list(1:count-2)];
fprintf(fid,text);
fclose(fid);

end
end