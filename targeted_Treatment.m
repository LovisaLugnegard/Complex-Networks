function [ infected_Count ] = targeted_Treatment( G, infected, pInf, fCure, T )
N = numnodes(G);
C = round(fCure*N);
infected_Count = zeros(1,T);
healthy_Neighbors = zeros(1,N);
h = plot(G,'Layout','force');
C = round(pInf*N); %How many to cure each time-step 

for t = 1:T
    %Infecting individuals each time-step
    for i = 1:N
        if infected(i) == 0
            %Spreading disease
            n = sum(infected(neighbors(G,i))); %checking how many neighors are sick
            P = 1 - exp(-pInf*n);
            if rand < P
                infected(i) = 1;
            end
        end
    end 
    
    %Treating individuals each time-step
    for i = 1:N
        if infected(i) == 1
            healthy_Neighbors(i) = length(neighbors(G,i)) - ...
                sum(infected(neighbors(G,i))); %See how many healthy 
                          %individuals all sick people are linked to
        end
    end
    %Choose which ones to cure
    [~, sorted_Index] = sort(healthy_Neighbors, 'descend');
    max_Index = sorted_Index(1:C);
    infected(max_Index) = 0; %only cure those with the most number of 
                             %healthy links
    
                             
                           
    infected_Count(t) = sum(infected);
     
        

end

