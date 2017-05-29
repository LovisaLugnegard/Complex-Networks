function [ network ] = build_scaleFree( N, n0, m )
% build_scaleFree : Build a scale-free network of N nodes using 
% preferential attachment, starting with n0 nodes and connecting every new
% node to m of the existing ones.

% Modified to account for m < 1

mode2 = 0;
if m < 1
    mode2 = 1;
end

T = N;           % Time steps
offset = n0;

network = zeros(N,N);
degree  = zeros(1,N);

i = 1;
while i < n0
    network(i,i+1) = 1;
    network(i+1,i) = 1;
    i = i + 2;
end

degree(1:n0) = 1;
for t=(1 + offset):T
    
    % Determine probabilities
    sumK = sum(degree(1:t-1));
    p = degree(1:t-1)/sumK;
    q = cumsum(p);
    
    % Link new individual t to m individuals
    if mode2 == 1
        ml = rand() < m;
    elseif m >= t
        ml = t - 1;
    else
        ml = m;
    end
    while ml > 0
        ind = find(rand() < q, 1);
        if network(t,ind) == 0  % Not linked yet
            network(t,ind)  = 1;
            network(ind,t)  = 1;
            degree(t)       = degree(t) + 1;
            degree(ind)     = degree(ind) + 1;
            ml = ml - 1;
        end
    end
end


end

