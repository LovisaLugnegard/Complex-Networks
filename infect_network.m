function [ infected ] = infect_network( G, f_inf )
% infect_network : Infects the fraction f_inf of nodes in the network G

size_G = numnodes(G);
infected = zeros(1,size_G);

start_Inf = round(f_inf*size_G); % Number of nodes to infect initially
infected = zeros(1,size_G);
infected_ind = randperm(size_G,start_Inf); %randomizing the infected start nodes
infected(infected_ind) = 1;

end

