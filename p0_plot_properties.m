function h = p0_plot_properties(h)
% p0_plot_properties : Sets default plot properties
fontsize = 16;
linewidth = 3;

set(gca,'fontsize',fontsize)

linestyles = {'-', '--', ':', '-.', '-'};

if(0)
    for i=1:length(h)
        set(h(i),'linewidth', linewidth);
    end
end
 

end

