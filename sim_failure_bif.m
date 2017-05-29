function [max_size, final_G] = sim_failure_bif( G, frac_tot)
%sim_failure : Randomly removes a fraction of nodes in network

network_size = numnodes(G);
n_to_remove = round(frac_tot*network_size);

for j=1:n_to_remove
    r_ind = ceil(rand()*numnodes(G));
    G = rmnode(G,r_ind);
end

cluster_distribution = conncomp(G);
largest_cluster = mode(cluster_distribution);
max_size = sum(cluster_distribution == largest_cluster) / numnodes(G);

% disp(['Removed ' num2str(network_size - num_nodes) ' nodes!'])
% disp(['Max size is: ' num2str(max(cluster_size)) ' / ' num2str(num_nodes)])

final_G = G;



