
% This file is the main script that generates problem instances using
% both the random and structured loop algorithm, solves the instances
% using simulated annealing (SA), and records the number of sweeps to solution.

clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Generator Parameters %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale = 1; % the scale of the weights

n_list = [30:10:50]; % the list of system sizes
n_length = length(n_list);

loop_ratio = 1; 
% the ratio between the number of center loops and upper/left loops
vers = 0; 
% version 0 is the random version, and version 1 is the structured version
frus = 0.2;
% the frustration index, note that this value should be set below 0.25

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%    Run Parameters    %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runs = 100;
% number of instances to be generated and solved per system size
dev = 0;
% the allowed percentage deviation from the planted ground state energy
sweep_cap = 10^9;
% the maximum allowed number of sweeps before the solver aborts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instance Generation & Solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_list = zeros(n_length,runs);
% records the total number of sweeps to solution (N_tot)
time_95 = zeros(1,n_length);
% records the 95th percentile of N_tot from the run samples

for n_iter = 1:n_length
    
n = n_list(n_iter); % number of visible layer nodes
m = n_list(n_iter); % number of hiddne layer nodes

beta = [0.01 log(n)]; % inverse temperature schedule [beta_min, beta_max]

density = 0.3035 + 0.2952*exp(-0.0196*n);
% estimated hardest loop density for a given system size

n_monte = (1.29*n^2 - 33.1*n + 1664)*...
          (41.4*frus^3 - 11.7*frus^2 + 1.06*frus - 0.018);
% optimal number of sweeps per SA run
n_monte = floor(n_monte);

n_loops = ceil(density*(n+1));

for run = 1:runs

[a,b,w,v,h,E] = gen_abW(n,m,n_loops,loop_ratio,vers,frus);
% generates a problem instance with known energy solution E

time_list(n_iter,run) = get_time_gibbs(n,m,a,b,w,n_monte,beta,E,sweep_cap,dev);
% solves the instance and records the total number of sweeps

end

time_95(n_iter) = find_95(time_list(n_iter,:));
% estimates the 95th percentile of the N_tot samples

end

%%%%%%%%%%%%%%%%%%%
%%%%%   Plot  %%%%%
%%%%%%%%%%%%%%%%%%%

plot(n_list,time_95);
set(gca,'XScale','log','YScale','log');
xlabel('n');
ylabel('No. of Sweeps');