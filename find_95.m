function z = find_95(list)

% This function estimates the 95th percentile of a sample by assuming
% log-normal distribution

list = log(list);
list_mean = mean(list);
list_std = std(list);
z = exp(list_mean + 2*list_std);

end