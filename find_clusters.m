function [ s_avg, s_max ] = find_clusters( G )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cluster_distribution = conncomp(G);
cluster_size = [];
num_nodes = numnodes(G);


i = 1;
while(true)
    
    size = sum(cluster_distribution == i);
    if(size>0)
        cluster_size(i) = size;
        i = i+1;
    else
        break;
    end
end

%calculate S_avg and S_max

%# of clusters
num_clusters = length(cluster_size);

s_max = max(cluster_size)/num_nodes;

if(num_clusters>1)
    s_avg = (sum(cluster_size)-s_max)/(num_clusters-1);
else
    s_avg = 0;
end
end
