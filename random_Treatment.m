
function [ infected_Count ] = random_Treatment( G, infected, pInf, fCure, T )
%   Detailed explanation goes here
N = numnodes(G);
C = round(fCure*N);
infected_Count = zeros(1,T);
temp_Infected = infected;
h = plot(G,'Layout','force');
% figure;
% hold on
inf_0 = sum(infected);

for t = 1:T
    
    n0 = sum(infected);
    for i = 1:N
        if infected(i) == 0
            %Spreading the disease
            n = sum(infected(neighbors(G,i))); %checking how many neighbors are sick
            P = 1 - exp(-pInf*n);
            if rand < P
                temp_Infected(i) = 1;
            end
        end
    end
    
    infected = temp_Infected;
    n1 = sum(infected);
    %Treating disease randomly
    c = 1;
    while c <= C && sum(infected) > 0
        indInfect = find(infected == 1); %vector with infected index
        cInd = indInfect(ceil(rand*length(indInfect)));
        infected(cInd) = 0;
        c = c + 1;
    end
    n2 = sum(infected);
    
    disp('___')
    disp(['Initial inf count: ' num2str(n0)])
    disp(['After inf spread:  ' num2str(n1) ' (Diff: +' num2str(n1-n0) ')'])
    disp(['After cure :       ' num2str(n2) ' (Diff: -' num2str(n2-n1) ')'])
    
    infected_Count(t) = sum(infected);
    
    highlight(h,1:N,'NodeColor','b');
    highlight(h,indInfect,'NodeColor','r');
    pause(0.01)
    
    if n2 == 0
        break;
    end
end

infected_Count = [inf_0 infected_Count]; 
end

