function T = get_time_gibbs(n,m,a,b,w,n_monte,beta,E,t_cap,dev)

% This function records the total number of sweeps for SA to solve the
% instances. See the main function "find_best_gibbs_time" for more
% documentation.

t = Inf; 
T = 0; % T records the total number of sweeps

% If SA fails to solve the instance within a given run, a random
% re-initialization is triggered, and the number of allotted sweeps
% "n_monte" per run is incremented to the total number of sweeps.
while t == Inf
    t = find_best_gibbs_time(n,m,a,b,w,n_monte,beta,E,dev);
    if t == Inf
        T = T + n_monte;
    else
        T = T + t;
    end
    if T > t_cap
        T = t_cap;
        break; 
        % the solver aborts if it exceeds the maximum allotted number of
        % sweeps
    end
end

end