%% FINAL PROJECT 
%% Build exponential network
N = 10000;               % Number of individuals in network
pCon = 0.004;          % Probability of two individuals being connected
network = zeros(N,N);   % Network matrix

% Populate network matrix
for i=1:N
    for j=1:i-1
        if rand() < pCon
            network(i,j) = 1;
        end
    end
end

network = network + network';
degrees = zeros(1,N);

for i=1:N
    degrees(i) = sum(network(i,:));
end

% fig = figure(1);
% hist(degrees, 20);
% ylabel('Number of nodes')
% xlabel('Degree (number of connections)')
% set(gca,'fontsize',16)
avCon = mean(degrees);

disp(['Average degree: ' num2str(avCon)])

%% Build scale-free network

T = 5000;        % Time steps
m = 4;           % Nodes to add each time step
offset = 4;

t = 1 + offset;

network = zeros(N,N);
degree  = zeros(1,N);

degree(1:4) = 1;

w1 = waitbar(0, 'Please wait...');
for t=(1 + offset):T
    waitbar(t/T)
    % Determine probabilities
    sumK = sum(degree(1:t-1));
    p = degree(1:t-1)/sumK;
    q = cumsum(p);
    
    % Link new individual t to m individuals
    ml = m;
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
close(w1)

%% Simulate failure (random removal of nodes)
tic;
[end_network, diameters1, frac_vals1] = sim_failure(network, 0.04, 0.004);
t1 = toc;

plot(frac_vals1, diameters1, 'b*', frac_vals2, diameters2, 'ro')

disp(t1)
disp(t2)

%disp(num2str(diameters))

%% Simulate attack (targeted removal of nodes)
[diameters, frac_vals] = sim_attack(network, 0.04, 0.004);
plot(frac_vals, diameters, 'r*')


%% Plot : visualize the networks

%% Plot : changes in diameter vs fraction of removed nodes (both failure and attack)

