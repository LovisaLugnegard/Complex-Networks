function [ diameters, frac_vec ] = sim_failure( network, frac_tot, resolution)
%sim_failure : Randomly removes a fraction of nodes in network

G = graph(network);

network_size = size(network,1);
n_of_datapoints = floor(frac_tot/resolution);
n_rem_each_step = round(resolution*network_size);

diameters = zeros(1,n_of_datapoints);
frac_vec  = zeros(1,n_of_datapoints);

initial_d = find_diameter(G);

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

end

% Prepare outputs
frac_vec = [0 frac_vec];
diameters = [initial_d diameters];

