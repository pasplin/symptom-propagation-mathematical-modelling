%% File for creating legends for bar plots

purple = {[235/255,224/255,247/255],[0.6, 0.4, 0.85],[0.3, 0, 0.5]};
red = {[255,228,228]./255,[255,120,120]/255,[238,0,0]/255,[175,0,0]/255};
blue = {[235,245,255]./255,[153,204,255]/255,[50, 144,255]/255,[0,76,153]/255};
yellow = {[255,242,204]./255,[255,191,0]./255};
black = {[0.76,0.76,0.76],[0,0,0]};

%% Compartment bar plot legends

% figure(1)
% clf
% set(gcf,'units','inch','position',[0,0,10,0.2])
% hold on;
% bar1 = bar(1, 100, 'FaceColor', 'white');
% bar2 = bar(2, 50, 'FaceColor', 'black');
% hold off
% 
% bars = [bar1, bar2];
% hatchfill2(bars(1),'single','HatchAngle',-45,'hatchcolor','black','HatchLineWidth',1.5)
% 
% Legend = {'\alpha = 0.2','\alpha = 0.8'};
% [legend_h,object_h,plot_h,text_str] = legendflex(bars,Legend,'FontSize',12,'ncol',2,'box','off','anchor', [2 6], 'buffer', [0 -12]);
% 
% hatchfill2(object_h(3), 'single','HatchAngle',-65,'hatchcolor','black','HatchDensity',10,'HatchLineWidth',1.5)
% 
% for ii = 1:2
%     set(bars(ii),'visible','off')
% end
% set(gca, 'visible', 'off')

% figure(2)
% clf
% set(gcf,'units','inch','position',[0,0,10,1.5])
% hold on;
% bar1 = bar(1,nan, 'FaceColor', red{3});
% bar2 = bar(2, nan, 'FaceColor', yellow{2});
% % bar3 = bar(3, nan, 'FaceColor', blue{2});
% % bar4 = bar(4, nan, 'FaceColor', 'white');
% bars = [bar1, bar2];%,bar3,bar4];
% hold off
% 
% %legend('R_M','R_S','V','S','orientation','horizontal','box','off','fontsize',12,'location','north')
% legend('R_M','R_S','orientation','horizontal','box','off','fontsize',12,'location','north')
% 
% set(gca, 'visible', 'off')

%% TIC bar plot

figure(1)
set(gcf,'units','inch','position',[0,0,10,0.5])
hold on;
bar1 = bar(1, 100, 'FaceColor', black{1});
bar2 = bar(2, 50, 'FaceColor', black{2});
hold off

% Keep an array of the plots so that none of the hatchfill2 lines appear in the legend
bars = [bar1, bar2];

hatchfill2(bars(1),'single','HatchAngle',-45,'hatchcolor',black{2},'HatchLineWidth',1.5)

Legend = {'\alpha=0.2','\alpha=0.8'};
[legend_h,object_h,plot_h,text_str] = legendflex(bars,Legend,'FontSize',12,'ncol',2, 'anchor', [2 6], 'buffer', [0 -20],'box','off');
hatchfill2(object_h(3), 'single','HatchAngle',-65,'hatchcolor',black{2},'HatchDensity',8,'HatchLineWidth',1.5)

set(bar1,'visible','off')
set(bar2,'visible','off')
set(gca, 'visible', 'off')