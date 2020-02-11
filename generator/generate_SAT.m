function generate_SAT(n,m,scale,density,loop_ratio,vers,frus,sz,runs)
% generates wcnf files for a given class of instances

a = zeros(1,n); b = zeros(1,m);
n_loops = floor(n*density);

dirname = strcat(num2str(n),'x',num2str(m),'_',num2str(vers),'_',num2str(density));
mkdir(dirname);   

for run = 1:runs

[w,~,cost] = generate(n,m,scale,n_loops,loop_ratio,vers,frus,sz);
[sat_entry, ~, ~, weight_entry] = convert_to_SAT(n,m,a,b,w);
w1 = weight_entry{1,1}.'; w2 = weight_entry{2,1}.'; weight = [w1 w2];
c1 = sat_entry{1,1}; c2 = sat_entry{1,2}; 
wmax = max(weight);
nclause = length(weight);

filename = strcat(dirname,'\instance_',num2str(run),'.wcnf');
fid = fopen(filename,'w'); 
text = "c " + num2str(n) + "x" + num2str(m) + " RBM\n";
text = text + "c Loop Density: " + num2str(density) + "\n";
text = text + "c Optimal Cost: " + cost + "\n";
text = text + "p wcnf " + num2str(n+m) + " " + num2str(nclause) + " " + num2str(wmax+1) + "\n";
for i = 1:length(w1)
    index = c1(i,1);
    text = text + num2str(w1(i)) + " " + num2str(index) + " " + num2str(0) + "\n";
end
for i = 1:length(w2)
    index1 = c2(i,1); index2 = c2(i,2);
    text = text + num2str(w2(i)) + " " + num2str(index1) + " " + num2str(index2) + " " + num2str(0) + "\n";
end
fprintf(fid,text);
fclose(fid);

end

end