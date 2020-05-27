% GA_FC = mean(mean(looms{1},3),2);
% cfg = [];
% cfg.xlim = [0.3 0.5];
% cfg.zlim = [0 6e-14];
% % layout.pos = layout.pos(4:131,:)
% % layout.width = layout.width(4:131,:);
% % layout.height = layout.height(4:131,:);
% % layout.label = layout.label(4:131,:);
cfg.layout = 'GSN-HydroCel-129.sfp';

elec = ft_read_sens(cfg.layout, 'senstype', 'eeg')
 
% cfg.parameter = 'individual'; % the default 'avg' is not present in the data
% %figure; ft_topoplotER(cfg,GA_FC); colorbar
 layout = ft_prepare_layout(cfg)
ft_plot_layout(layout)
% % ft_plot_layout(cfg.layout, 'box', 'no', 'label', 'no', 'point', 'no')
% ft_plot_topo(layout.pos(4:131,1),layout.pos(4:131,2),GA_FC)
data  = mean(mean(looms{2},3),2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% Author: Isuru Jayarathne %
% %
% Input: 14xn matrix %
% Output: Figure of the topographic plot %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define electrodes placement according to the Emotiv Epoc+ headset
xc = layout.pos(4:131,1);
yc = layout.pos(4:131,2);
lbls = layout.label(4:131);
trlen = [];

% Calculating power of each electrode

trlen = vertcat(trlen,data');


xi=linspace(min(xc),max(xc),30);
yi=linspace(min(yc),max(yc),30);

[XI YI]=meshgrid(xi,yi);
ZI = griddata(xc,yc,trlen,XI,YI,'natural');

figure;
contourf(XI,YI,ZI,20);
hold on;
scatter(xc,yc,'b','filled');
text(xc+0.1,yc+0.1,lbls);

% Turn off the plot labels and axis
set(gca,'Visible','off');
colormap(jet);
hold off;
