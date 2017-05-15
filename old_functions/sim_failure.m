function [ end_network, diameters, frac_vec ] = sim_failure( network, frac_tot, resolution)
%sim_failure : Randomly removes a fraction of nodes in network
network_size = size(network,1);
n_of_datapoints = floor(frac_tot/resolution);
n_rem_each_step = round(resolution*network_size);

diameters = zeros(1,n_of_datapoints);
frac_vec  = zeros(1,n_of_datapoints);

removed_ind = [];
initial_d = find_diameter(network);

% Print stuff
disp(['network_size = ' num2str(network_size)])
disp(['datapoints = ' num2str(n_of_datapoints)])
disp(['rem_each = ' num2str(n_rem_each_step)])

for i=1:n_of_datapoints
    
    k = n_rem_each_step;
    while k > 0
        r_ind = ceil(rand()*network_size);
        if find(removed_ind == r_ind)
            % do nothing
        else
            removed_ind = [removed_ind r_ind];
            network(r_ind,:) = 0;
            network(:,r_ind) = 0;
            k = k-1;
        end
    end
    
    frac_vec(i) = length(removed_ind)/network_size;
    diameters(i) = find_diameter(network);

end

disp(['Removed nodes: ' num2str(length(removed_ind))])
% Prepare outputs
frac_vec = [0 frac_vec];
diameters = [initial_d diameters];
end_network = network;

