function [ network ] = build_exponential( N, link_density )
% build_exponential : Builds an exponential network of N nodes and the
% specified link density

network = zeros(N,N);   % Network matrix

% Populate network matrix
for i=2:N
    
    
    for j=1:i-1
        if rand() < link_density
            network(i,j) = 1;
        end
    end
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

end

