% Model extension for final project 

% Build exponential network
N = 10000;               % Number of individuals in network
pCon = 0.0004;           % Probability of two individuals being connected
T = 100;                 % number of time-steps
pInf = 0.01;             % probability in linked infection
fCure = 0.09;            % fraction cured each time-step
f_start_inf = 0.1;

%To build a network with only one cluster

exp_network = build_exponential(N, pCon);
exp_G = graph(exp_network);
cluster_distribution = conncomp(exp_G);

nodes_to_remove = find(cluster_distribution>1);
exp_G = rmnode(exp_G,nodes_to_remove);

% % Build a scale-free network 
t_S = numnodes(exp_G);        % Time steps, days
%m = pCon*t_S/2;           % Nodes to add each time step (to get aprox same deg)
m = 2;
offset = 4;
sf_network = build_scaleFree(t_S, offset, m);

sf_G = graph(sf_network);
% disp(['mean degree sf G ' num2str(mean(degree(sf_G)))])
% disp(['number of clusters in sf_G ' num2str(max(conncomp(sf_G)))])

% Properties of networks
size_Exp = numnodes(exp_G);
size_Sf = numnodes(sf_G);

% Infecting a starting number of random people

infected_exp = infect_network(exp_G, f_start_inf);
infected_sf  = infect_network(sf_G, f_start_inf);
assert(sum(infected_exp)==sum(infected_sf));
%Plot with colors


% Spreading and treating disease randomly
disp('___')
disp('Random treatment')
infected_Count_Random_exp = random_Treatment(exp_G, infected_exp, pInf, fCure, T);

infected_Count_Random_sf  = random_Treatment(sf_G, infected_sf, pInf, fCure, T);

% Spreading and treating the disease targeted 
disp('Targeted treatment')
infected_Count_Targeted_exp = targeted_Treatment(exp_G, infected_exp, pInf, fCure, T);
infected_Count_Targeted_sf = targeted_Treatment(sf_G, infected_sf, pInf, fCure, T);

figure()
plot(1:(T+1), infected_Count_Random_exp, 1:(T+1), infected_Count_Random_sf)
title(['Random treatment, fCure= ' num2str(fCure)])
legend('Exponential network', 'Scale Free network');
figure()
plot(1:(T+1), infected_Count_Targeted_exp, 1:(T+1), infected_Count_Targeted_sf)
title(['Targeted treatment, fCure= ' num2str(fCure)]);
legend('Exponential network', 'Scale Free network');