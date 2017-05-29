function out = p0_save_fig(fig, filename)
% p0_save_fig : Saves plot using standard options
resolution = '-r200';
filetype = '-dpng';

print(fig, filename, filetype, resolution);

out = 1;

end

