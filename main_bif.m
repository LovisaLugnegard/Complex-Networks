% main_bif.m
% === main function for bifurcation diagram ===
DP = 0;

m_frac_val = 0.4;               % Fraction of nodes to remove 
N = 1000;                        % Number of individuals in network
pCon_vals = logspace(-4,-1,100);  % Probability of two individuals being connected
%pCon_vals = linspace(0.0001,1,50);
resolution = 100;               % Resolution of bifur diag y axis
nSim = 20;                      % # of sims to run for each network-pCon combination


% Matrix preallocation 
exp_fail_clusters = zeros(resolution,length(pCon_vals));
sf_fail_clusters = zeros(resolution,length(pCon_vals));
exp_attack_clusters = zeros(resolution,length(pCon_vals));
sf_attack_clusters = zeros(resolution,length(pCon_vals));

% To determine distribution along y axis
size_range = linspace(0,1,resolution);
size_range(end) = 500;

% Preallocation of debugging data
exp_G_sizes = zeros(1,length(pCon_vals));
exp_G_end_sizes = zeros(1,length(pCon_vals));
exp_G_degs = zeros(1, length(pCon_vals));

sf_G_maxes = zeros(1, length(pCon_vals));

w1 = waitbar(0, 'Generating bifurcation diagram data...');
disp('__')
disp('### Starting script ###')
for i=1:length(pCon_vals)
    waitbar(i/length(pCon_vals));
    
    % Load current pCon
    pCon = pCon_vals(i);
    dp(['Now handling pCon = ' num2str(pCon)], DP);
    for j=1:nSim
        
        % === Exponential network ===
        exp_network = build_exponential(N, pCon);
        exp_G = graph(exp_network);
        cluster_distribution = conncomp(exp_G);
        
        largest_cluster = mode(cluster_distribution);
        
        % =====
        % To build a network with only one cluster, uncomment these lies
%         
%         nodes_to_remove = find(cluster_distribution~=largest_cluster);
%         exp_G = rmnode(exp_G,nodes_to_remove);
%         
%         cluster_distribution = conncomp(exp_G);
%         num_clus = max(cluster_distribution);
%         assert(num_clus == 1, 'ERRROR: Numclus != 1')

%         largest_cluster = mode(cluster_distribution);
        % =====
        
        exp_cluster_max_0 = sum(cluster_distribution == largest_cluster) / numnodes(exp_G);
        
        exp_G_sizes(i) = numnodes(exp_G);
        exp_G_degs(i) = mean(degree(exp_G));
%         disp(['mean degree exp G ' num2str(mean_deg)])
%         disp(['number of clusters in exp_G ' num2str(max(conncomp(exp_G)))])
        dp(['Successfully constructed exp network with ' num2str(numnodes(exp_G)) ' nodes!'],DP);
        exp_mean_deg = mean(degree(sf_G));
        dp(['Mean exp deg : ' num2str(exp_mean_deg)],1);
        
        % === Scale-free network ===
        T = numnodes(exp_G);        % Time steps

        m = mean(degree(exp_G))/(2 - (0.9*pCon));
        disp(['m = ' num2str(m)])

        if m > 1
            m = round(m);
        end
        
        n0 = 4;

        sf_network = build_scaleFree(T, n0, m);
        
        sf_G = graph(sf_network);
% %         disp(['mean degree sf G ' num2str(mean(degree(sf_G)))])
% %         disp(['number of clusters in sf_G ' num2str(max(conncomp(sf_G)))])

        cluster_distribution = conncomp(sf_G);
        
        largest_cluster = mode(cluster_distribution);
        sf_cluster_max_0 = sum(cluster_distribution == largest_cluster) / numnodes(sf_G);
        dp('Successfully constructed sf network',DP);
        sf_mean_deg = mean(degree(sf_G));
        dp(['Mean sf deg : ' num2str(sf_mean_deg)],1);
%         
        % === Simulate failure (random removal of nodes) ===
        % EXP
        dp('Simulating exp_fail...', DP);
        [exp_fail_max, exp_G_end] = sim_failure_bif(exp_G, m_frac_val);
        dp('Done!', DP);
        % Determine size relative to largest cluster from before failure
        exp_max_fail_rel = exp_fail_max/exp_cluster_max_0;
        dp(['rel = ' num2str(exp_fail_max) ' / ' num2str(exp_cluster_max_0) ' = ' num2str(exp_max_fail_rel)], DP);
        
        % SF
        dp('Simulating sf_fail...', DP);
        [sf_fail_max, sf_G_end] = sim_failure_bif(sf_G, m_frac_val);
        dp('Done!', DP);
        % Determine size relative to largest cluster from before failure
        sf_max_fail_rel = sf_fail_max/sf_cluster_max_0;
            
        % INDEXING
        exp_ind = find(size_range >= exp_max_fail_rel,1);
        sf_ind = find(size_range >= sf_max_fail_rel,1);
%         disp(['Indices found: ' int2str(exp_ind) ' ' int2str(sf_ind)])
        
        exp_fail_clusters(exp_ind,i) = exp_fail_clusters(exp_ind,i)+1;
        sf_fail_clusters(sf_ind,i) = sf_fail_clusters(sf_ind,i)+1;
        
        % === Simulate attack (targeted removal of nodes) ===
        [exp_attack_max, ~] = sim_attack_bif(exp_G, m_frac_val);
        exp_max_attack_rel = exp_attack_max/exp_cluster_max_0;
        [sf_attack_max, ~] = sim_attack_bif(sf_G, m_frac_val);
        sf_max_attack_rel = sf_attack_max/sf_cluster_max_0;

        % INDEXING
        exp_ind = find(size_range >= exp_max_attack_rel,1);
        sf_ind = find(size_range >= sf_max_attack_rel,1);
%         disp(['Indices found: ' int2str(exp_ind) ' ' int2str(sf_ind)])
        
        exp_attack_clusters(exp_ind,i) = exp_attack_clusters(exp_ind,i)+1;
        sf_attack_clusters(sf_ind,i) = sf_attack_clusters(sf_ind,i)+1;
        
    end
    exp_G_end_sizes(i) = numnodes(exp_G_end);
%     sf_G_end_sizes(i) = numnodes(sf_G_end);
end
close(w1)
disp('### Reached end of script without errors ###')
disp('¨¨¨')
%%
size_range(end) = 1;
clim = [0 10];
y_lab = 'Relative size of largest cluster';
x_lab = 'log_{10}(link density)';
xrange = log10(pCon_vals);

fig1 = figure(1);
h1 = imagesc(xrange, size_range, exp_fail_clusters, clim);
% title('Exponential network, random removal (failure)')
colormap(hot)
xlabel(x_lab)
ylabel(y_lab)
p0_plot_properties(h1);
p0_save_fig(fig1, ['plot_bifur_exp_fail_N' num2str(N) '_nSim' num2str(nSim)]);

fig2 = figure(2);
h2 = imagesc(xrange, size_range, exp_attack_clusters, clim);
% title('Exponential network, targeted removal (attack)')
colormap(hot)
xlabel(x_lab)
ylabel(y_lab)
p0_plot_properties(h2);
p0_save_fig(fig2, ['plot_bifur_exp_attack_N' num2str(N) '_nSim' num2str(nSim)]);

fig3 = figure(3);
h3 = imagesc(xrange, size_range, sf_fail_clusters, clim);
% title('Scale-free network, random removal (failure)')
colormap(hot)
xlabel(x_lab)
ylabel(y_lab)
p0_plot_properties(h3);
p0_save_fig(fig3, ['plot_bifur_sf_fail_N' num2str(N) '_nSim' num2str(nSim)]);

fig4 = figure(4);
h4 = imagesc(xrange, size_range, sf_attack_clusters, clim);
% title('Scale-free network, targeted removal (attack)')
colormap(hot)
xlabel(x_lab)
ylabel(y_lab)
p0_plot_properties(h4);
p0_save_fig(fig4, ['plot_bifur_sf_attack_N' num2str(N) '_nSim' num2str(nSim)]);

% 



