function d_mean = find_diameter( network )
%find_diameter : Calculates the diameter of a network
temp = network(any(network,2), any(network,1));

G = graph(temp);
d = distances(G);
d_mean = sum(sum(d))/nnz(d);

end

