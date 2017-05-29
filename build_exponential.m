function [ network ] = build_exponential( N, link_density )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% Build exponential network
network = zeros(N,N);   % Network matrix
%w1 = waitbar(0, 'Building exponential network...');
% Populate network matrix
for i=2:N
    
    
    for j=1:i-1
        if rand() < link_density
            network(i,j) = 1;
        end
    end
   % waitbar(i/N);
end

network = network + network';

%disp(length(find(all(network == 0, 2))));
% 
% 
% for i=1:N
%     if(sum(network(i,:)) ==0)
%         linked = false;
%         while ~linked
%             for j=1:N
%                 if rand() < link_density
%                     network(i,j) = 1;
%                     network(j,i) = 1;
%                     linked = true;
%                 end
%             end
%         end
%     end
% end

%close(w1)

end

