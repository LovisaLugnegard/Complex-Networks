function d_mean = find_diameter( G )
%find_diameter : Calculates the diameter of a network

d = distances(G);
d_mean = mean(nonzeros(d(~isinf(d))));


end

