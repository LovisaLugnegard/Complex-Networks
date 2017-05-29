function [ s_avg, s_max ] = find_clusters( G )
% find_clusters : Finds average cluster sizes and the maximum cluster size
% in the network G

cluster_distribution = conncomp(G);
cluster_size = [];
num_nodes = numnodes(G);

i = 1;
while(true)
    C_size = sum(cluster_distribution == i);
    if(C_size>0)
        cluster_size(i) = C_size;
        i = i+1;
    else
        break;
    end
end
num_clusters = length(cluster_size);

s_max = max(cluster_size)/num_nodes;

if(num_clusters>1)
    s_avg = (sum(cluster_size)-max(cluster_size))/(num_clusters-1);
else
    s_avg = 0;
end
end

