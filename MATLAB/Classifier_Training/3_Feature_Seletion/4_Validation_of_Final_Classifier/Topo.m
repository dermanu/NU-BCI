%% Creates topographic map of the EEG voltage distribution over time

close all
cfg.layout = 'GSN-HydroCel-129.sfp';
layout = ft_prepare_layout(cfg)
load('Layout.mat')
hpos = 0.02;
xScaling = 0.80;
trlen = [];
data = mean(mean(looms{2},2),3);
data(124:128) = data(124:128)./3;
trlen = vertcat(trlen,data');
xi=linspace(min(X(4:131)),max(X(4:131)),30);
yi=linspace(min(Y(4:131)),max(Y(4:131)),30);
[XI YI]=meshgrid(xi,yi);
ZI = griddata(X(4:131),Y(4:131),trlen,XI,YI,'cubic');
contourf(XI,YI,ZI,30, 'LineColor' , 'none');
hold on
hcb = colorbar;
title(hcb,'Amplitude in \muV/sec', 'Rotation',270, 'FontSize', 10, 'Position', [41,117,0])
colormap jet
%plot(X, Y, 'marker', '.', 'color', 'b', 'linestyle', 'none');
%text(X+labelxoffset, Y+labelyoffset, Lbl , 'interpreter', interpreter, 'horizontalalignment', labelalignh, 'verticalalignment', labelalignv, 'color', fontcolor, 'fontunits', fontunits, 'fontsize', fontsize, 'fontname', fontname, 'fontweight', fontweight);

  for i=1:length(layout.mask)
    if ~isempty(layout.mask{i})
      X = layout.mask{i}(:,1)*xScaling;
      Y = layout.mask{i}(:,2)*xScaling + hpos;
      % the polygon representing the mask should be closed
      X(end+1) = X(1);
      Y(end+1) = Y(1);
      h = line(X, Y);
      set(h, 'color', 'k');
      set(h, 'linewidth', 1.5);
      set(h, 'linestyle', ':');
    end
  end
  
     for i=1:length(layout.outline)
    if ~isempty(layout.outline{i})
      X = layout.outline{i}(:,1)*xScaling;
      Y = layout.outline{i}(:,2)*xScaling + hpos;
      h = line(X, Y);
      set(h, 'color', 'k');
      set(h, 'linewidth', 2);
    end
     end
  