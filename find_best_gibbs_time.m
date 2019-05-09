function t = find_best_gibbs_time(n,m,a,b,W,n_monte,beta_list,E_sol,dev)

% this function is the SA solver that attempts to solve the instance
% [n,m,a,b,W] are the problem parameters
% n_monte is the number of sweeps 
% beta_list is the inverse temperature schedule
% E_sol is the known solution energy
% dev is the allowed percentage deviation from the energy solution
% t records the number of sweeps to solution, and returns Inf if the
% solution isn't found after n_monte runs

v = rand_spins(n); v_best = v; % random visible spin initialization
h = rand_spins(m); h_best = h; % random hidden spin initialization
E = a*v.' + b*h.' + v*W*h.'; E_best = E; % initial energy
theta = v*W + b; % initial theta angle 
phi = h*W.' + a; % initial phi angle

t = Inf; 

if dev == 0
    eng_dev = 0.01;
else
    eng_dev = E_sol*dev;
end

for monte = 1:n_monte
    
    beta_min = beta_list(1); beta_max = beta_list(2);
    beta = beta_min + (monte-1)/(n_monte-1)*(beta_max - beta_min); 
    % update inverse temperature for every iteration
    
    % visible spin update
    for j = 1:m 
        h(j) = -h(j);
        ratio = exp(2*beta*theta(j)*h(j)); % find acceptance ratio
        x = rand();
        if x > ratio 
            h(j) = -h(j); % reject the update
        else
            % accept the update
            E = E + 2*theta(j)*h(j); % update the energy
            phi = phi + 2*h(j)*W(:,j).'; % update the angle
        end
    end
    
    % hidden spin update
    for i = 1:n
        v(i) = -v(i);
        ratio = exp(2*beta*phi(i)*v(i));
        x = rand();
        if x > ratio
            v(i) = -v(i);
        else
            E = E + 2*phi(i)*v(i);
            theta = theta + 2*v(i)*W(i,:);
        end
    end
    
    if E >= E_best
        E_best = E; % record best energy obtained so far
        v_best = v; % record best visible layer configuration so far
        h_best = h; % record best hidden layer configuration so far
    end
    
    % check if the best energy found by SA is within the allowed deviation
    % from the actual energy solution
    if abs(E_best - E_sol) < eng_dev
        t = monte;
        break;
    end
        
end
    
end