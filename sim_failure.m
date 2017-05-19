function [ diameters, frac_vec, S_avg, S_max ] = sim_failure(network, frac_tot, resolution)
%sim_failure : Randomly removes a fraction of nodes in network

G = graph(network);

network_size = size(network,1);
n_of_datapoints = floor(frac_tot/resolution);
n_rem_each_step = round(resolution*network_size);

diameters = zeros(1,n_of_datapoints);
frac_vec  = zeros(1,n_of_datapoints);
S_avg = zeros(1, n_of_datapoints);
S_max = zeros(1, n_of_datapoints);

initial_d = find_diameter(G);
%[initial_S_avg, initial_S_max] = find_clusters(G);

% Print stuff
disp(['network_size = ' num2str(network_size)])
disp(['datapoints = ' num2str(n_of_datapoints)])
disp(['rem_each = ' num2str(n_rem_each_step)])

for i=1:n_of_datapoints
    
    for j=1:n_rem_each_step
        r_ind = ceil(rand()*numnodes(G));
        G = rmnode(G,r_ind);
        
    end
    
    frac_vec(i) = i*n_rem_each_step/network_size;
    diameters(i) = find_diameter(G);
    [S_avg(i), S_max(i)] = find_clusters(G);
    disp(diameters(i))
end

% Prepare outputs
frac_vec = [0 frac_vec];
diameters = [initial_d diameters];

S_avg = [0 S_avg];
S_max = [1 S_max];

