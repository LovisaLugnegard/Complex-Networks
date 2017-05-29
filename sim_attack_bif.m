function [ max_size, final_G ] = sim_attack_bif( G, frac_tot)
%sim_attack : Removes a fraction of nodes in network, targeting the nodes
%             with the highest degree first

% Debugging printout
DP = 0;

network_size = numnodes(G);
n_to_remove = round(frac_tot*network_size);

% Print stuff
% disp(['network_size = ' num2str(network_size)])
% disp(['datapoints = ' num2str(n_of_datapoints)])
% disp(['rem_each = ' num2str(n_rem_each_step)])

n_clusters = length(unique(conncomp(G)));
dp(['Initial number of clusters: ' num2str(n_clusters) ' (' num2str(n_clusters/numnodes(G)) ')'], DP);
for j=1:n_to_remove
    [~, ind] = max(degree(G));
    G = rmnode(G, ind);
end
n_clusters = length(unique(conncomp(G)));
dp(['Afterwards: ' num2str(n_clusters) ' (' num2str(n_clusters/numnodes(G)) ')'], DP);

cluster_distribution = conncomp(G);
largest_cluster = mode(cluster_distribution);
max_size = sum(cluster_distribution == largest_cluster) / numnodes(G);

% Prepare outputs
final_G = G;

