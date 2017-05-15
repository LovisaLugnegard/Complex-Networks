function [ network ] = build_exponential( N, link_density )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% Build exponential network
network = zeros(N,N);   % Network matrix

% Populate network matrix
for i=1:N
    for j=1:i-1
        if rand() < link_density
            network(i,j) = 1;
        end
    end
end

network = network + network';

end

