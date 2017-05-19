function max_size = sim_failure_bif( network, frac_tot)
%sim_failure : Randomly removes a fraction of nodes in network

G = graph(network);
network_size = size(network,1);
n_to_remove = round(frac_tot*network_size);

for j=1:n_to_remove
    r_ind = ceil(rand()*numnodes(G));
    G = rmnode(G,r_ind);
end

cluster_distribution = conncomp(G);
cluster_size = [];
num_nodes = numnodes(G);


i = 1;
while(true)
    
    c_size = sum(cluster_distribution == i);
    if(c_size>0)
        cluster_size(i) = c_size;
        i = i+1;
    else
        break;
    end
end

%calculate S_max
max_size = max(cluster_size)/num_nodes;



