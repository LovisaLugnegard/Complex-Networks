% FINAL PROJECT
clear all;
m_frac_val = 0.04; %max fraction value
res = 0.002; %resolution
N = 1000;               % Number of individuals in network
pCon = 0.0004;          % Probability of two individuals being connected

%To build a network with only one cluster


exp_network = build_exponential(N, pCon);
exp_G = graph(exp_network);
cluster_distribution = conncomp(exp_G);

nodes_to_remove = find(cluster_distribution>1);
exp_G = rmnode(exp_G,nodes_to_remove);

cluster_distribution = conncomp(exp_G);
num_clus = max(cluster_distribution);
disp(num_clus)
mean_deg = mean(degree(exp_G));
disp('hej')
disp(['mean degree exp G ' num2str(mean_deg)])
disp(['number of clusters in exp_G ' num2str(max(conncomp(exp_G)))])
% Build scale-free network
%
T = numnodes(exp_G);        % Time steps
m = pCon*T/2;           % Nodes to add each time step (to get aprox same deg)
offset = 4;
sf_network = build_scaleFree(T, offset, m);

sf_G = graph(sf_network);
disp(['mean degree sf G ' num2str(mean(degree(sf_G)))])
disp(['number of clusters in sf_G ' num2str(max(conncomp(sf_G)))])

% Simulate failure (random removal of nodes)
[exp_diameters, exp_frac_vals,exp_S_avg, exp_S_max] = sim_failure(exp_network, m_frac_val, res);
[sf_diameters, sf_frac_vals, sf_S_avg, sf_S_max] = sim_failure(sf_network, m_frac_val, res);

% Simulate attack (targeted removal of nodes)
[a_exp_diameters, a_exp_frac_vals] = sim_attack(exp_network, m_frac_val, res);
[a_sf_diameters, a_sf_frac_vals] = sim_attack(sf_network, m_frac_val, res);



% Plot : visualize the networks

% Plot : changes in diameter vs fraction of removed nodes (both failure and attack)

% PLOT
figure
plot(exp_frac_vals, exp_diameters, 'b*')
hold on
plot(exp_frac_vals, a_exp_diameters, 'bo')
plot(exp_frac_vals, sf_diameters, 'r*')
plot(exp_frac_vals, a_sf_diameters, 'ro')
legend('Failure, exp', 'Attack exp', 'Failure SF', 'Attack SF')
hold off

% % figure
% % plot(exp_frac_vals, exp_S_avg, 'b*')
% % hold on
% % plot(exp_frac_vals, exp_S_max, 'bo')
% % plot(exp_frac_vals, a_exp_S_avg, 'r*')
% % plot(exp_frac_vals, a_exp_S_max, 'ro')
% % legend('Failure, <s>','Failure S', 'Attack <s>', 'Attack S')
% % title('Exponential network')
% % figure
% %
% %
% % plot(sf_frac_vals, sf_S_avg, 'b*')
% % hold on
% % plot(sf_frac_vals, sf_S_max, 'bo')
% % plot(sf_frac_vals, a_sf_S_avg, 'r*')
% % plot(sf_frac_vals, a_sf_S_max, 'ro')
% % legend('Failure, <s>','Failure S', 'Attack <s>', 'Attack S')
% % title('Scale free network')

