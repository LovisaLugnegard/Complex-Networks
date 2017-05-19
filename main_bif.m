%Bifurcation main

% FINAL PROJECT
clear all;
m_frac_val = 0.04; %max fraction value
res = 0.002; %resolution
N = 500;               % Number of individuals in network
pCon_vals = logspace(-4,0,10);          % Probability of two individuals being connected
resolution = 100;
exp_fail_clusters = zeros(resolution,length(pCon_vals));
sf_fail_clusters = zeros(resolution,length(pCon_vals));
exp_attack_clusters = zeros(resolution,length(pCon_vals));
sf_attack_clusters = zeros(resolution,length(pCon_vals));

nSim = 5;

size_range = linspace(0,1,resolution);
size_range_cum = cumsum(size_range);

w1 = waitbar(0, 'Generating bifurcation diagram data...');
disp('__')
disp('### Starting script ###')
for i=1:length(pCon_vals)
    waitbar(i/length(pCon_vals));
    pCon = pCon_vals(i);
    disp(['Now handling pCon = ' num2str(pCon)])
    for j=1:nSim
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
%         disp(['mean degree exp G ' num2str(mean_deg)])
%         disp(['number of clusters in exp_G ' num2str(max(conncomp(exp_G)))])
        disp('Successfully constructed exp network')

        % Build scale-free network
        %
        T = numnodes(exp_G);        % Time steps
        %m = pCon*T/2;           % Nodes to add each time step (to get aprox same deg)
        m = 4;
        offset = 4;
        sf_network = build_scaleFree(T, offset, m);
        
        sf_G = graph(sf_network);
%         disp(['mean degree sf G ' num2str(mean(degree(sf_G)))])
%         disp(['number of clusters in sf_G ' num2str(max(conncomp(sf_G)))])
        disp('Successfully constructed sf network')
        
        % Simulate failure (random removal of nodes)
        disp('Simulating exp_fail...')
        exp_fail_max = sim_failure_bif(exp_network, m_frac_val);
        disp('Done!')
        disp('Simulating sf_fail...')
        sf_fail_max = sim_failure_bif(sf_network, m_frac_val);
        disp('Done!')
        exp_ind = find(size_range_cum > exp_fail_max,1);
        sf_ind = find(size_range_cum > sf_fail_max,1);
        disp(['Indices found: ' int2str(exp_ind) ' ' int2str(sf_ind)])
        
        exp_fail_clusters(exp_ind,i) = exp_fail_clusters(exp_ind,i)+1;
        sf_fail_clusters(sf_ind,i) = sf_fail_clusters(sf_ind,i)+1;
        
        % Simulate attack (targeted removal of nodes)
%         [a_exp_diameters, a_exp_frac_vals] = sim_attack(exp_network, m_frac_val, res);
%         [a_sf_diameters, a_sf_frac_vals] = sim_attack(sf_network, m_frac_val, res);
    end
end
close(w1)
imagesc(pCon_vals, size_range, exp_fail_clusters)

