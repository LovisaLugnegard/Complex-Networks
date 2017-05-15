function d_mean = find_diameter( G )
%find_diameter : Calculates the diameter of a network

d = distances(G);
d_mean = sum(sum(d))/nnz(d);

end

