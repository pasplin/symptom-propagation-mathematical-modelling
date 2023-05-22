%% Compare number of severe cases between SA and IB intervention

interventions = {'sb', 'ib'};
param_sets = {'flu_1.5','flu_3.0','cov_3.0'};

up_opts = [51,71,91];
eff_itr = 3;
N =60287953;

runset = [interventions{1} '_int_find_opt_up_' param_sets{1}];
run_opts = define_run_opts(runset);

figure(4)
set(gcf,'units','inch','position',[0,0,10,3])
tlo4 = tiledlayout(1,3);
tlo4.Padding = 'compact';

sev_inf = zeros(length(run_opts{1}), length(run_opts{2}), length(up_opts), length(param_sets), length(interventions));


for up_itr = 1:length(up_opts)

figure(up_itr)
set(gcf,'units','inch','position',[0,0,14,3])
if up_itr == 1
    tlo1 = tiledlayout(1,4);
    tlo = tlo1;
elseif up_itr == 2
    tlo2 = tiledlayout(1,4);
    tlo = tlo2;
elseif up_itr == 3
    tlo3 = tiledlayout(1,4);
    tlo = tlo3;
end

tlo.Padding = 'compact';
tlo.TileSpacing = 'compact';

for int_itr = 1:length(interventions)
for param_itr = 1:length(param_sets)

runset = [interventions{int_itr} '_int_find_opt_up_' param_sets{param_itr}];
run_opts = define_run_opts(runset);

load(['model_output_' runset '.mat'], 'parameters','outputs')


    for nu_itr = 1:length(run_opts{1})
        for alpha_itr = 1:length(run_opts{2})
        

            l_year = find(sum(outputs(nu_itr,alpha_itr,up_opts(up_itr),eff_itr,:, :),6) > 0, 1,'last');
            sev_inf(nu_itr,alpha_itr,up_itr,param_itr,int_itr) = outputs(nu_itr,alpha_itr,up_opts(up_itr),eff_itr,l_year, 2);


        end
    end
end

end

% if param_itr == 1
%         CL = [0 10];
%         cmap = customcolormap([0 0.99 1], {'#0000FF','#E3E3FF','#ffffff'});
%         ylabel(tlo,'Seasonal Influenza')
% elseif param_itr == 2
%         CL = [-45 15];
%         cmap = customcolormap([0 0.24, 0.25, 0.26, 1], {'#0000FF','#E3E3FF','#ffffff','#FFEBEB','#ee0000'});
%         ylabel(tlo,'Pandemic Influenza')
% elseif param_itr == 3
%         CL = [-30 10];
%         cmap = customcolormap([0 0.24, 0.25, 0.26, 1], {'#0000FF','#E3E3FF','#ffffff','#FFEBEB','#ee0000'});
%         ylabel(tlo,'SARS-CoV-2')
% end

CL = [-45 15];
cmap = customcolormap([0 0.24, 0.25, 0.26, 1], {'#0000FF','#E3E3FF','#ffffff','#FFEBEB','#ee0000'});

for param_itr = 1:length(param_sets)


    nexttile(tlo)
    hm = heatmap((sev_inf(:,:,up_itr,param_itr,1)-sev_inf(:,:,up_itr,param_itr,2)).*100/N,'GridVisible','off','ColorLimits',CL,'Colormap',cmap);
%hm = heatmap(squeeze(opt_up(:,:,eff_itr)),'Colormap', blue, 'ColorLimits', [0 100],'GridVisible','off','CellLabelColor','none');
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
    hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
    hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
    hm.FontSize=9;
    hm.NodeChildren(3).YDir='normal'; 

    ylabel('Baseline probability, \nu')
    xlabel('Dependence on infector, \alpha')

    if up_itr == 1
    if param_itr == 1
        title('Seasonal Influenza')
    elseif param_itr == 2
        title('Pandemic Influenza')
    elseif param_itr == 3
        title('SARS-CoV-2')
    end
    else
        title(' ')
    end
    s = struct(hm);
    s.XAxis.TickLabelRotation = 0; 
    set(s.Axes.Title,'FontSize', 12)

    axs = struct(gca); %ignore warning that this should be avoided
    cb = axs.Colorbar;
    cb.Ruler.TickLabelFormat='%g%%';

%     ax1 = nexttile(tlo);
%     h = pcolor(run_opts{1},run_opts{2},(sev_inf(:,:,eff_itr,param_itr,1)-sev_inf(:,:,eff_itr,param_itr,2)).*100/N);
%     c = colorbar;
%     c.Ruler.TickLabelFormat='%g%%';
%     set(h, 'EdgeColor', 'none');
%     clim(CL)
%     colormap(ax1, cmap)
%     
%     hold on
%     contour(run_opts{1},run_opts{2},(sev_inf(:,:,eff_itr,param_itr,1)-sev_inf(:,:,eff_itr,param_itr,2)).*100/N,[0.00001 0.00001],'k','LineWidth',1.5)
%     hold off
% 
%     ylabel('Baseline probability, \nu')
%     xlabel('Dependence on infector, \alpha')
    
    

end

nexttile(tlo)
set(gca,'YTickLabel',[]);
if up_itr == 1
label_h = ylabel('Uptake 50%','Rotation',-90,'FontSize',12,'FontWeight','bold');
elseif up_itr == 2
    label_h = ylabel('Uptake 70%','Rotation',-90,'FontSize',12,'FontWeight','bold');
elseif up_itr == 3
    label_h = ylabel('Uptake 90%','Rotation',-90,'FontSize',12,'FontWeight','bold');
end
label_h.Position(1) = -0.22;

% if up_itr == 1
%     ylabel(tlo, 'Uptake 50%','FontSize',12,'FontWeight','bold')
% elseif up_itr == 2
%     ylabel(tlo, 'Uptake 70%','FontSize',12,'FontWeight','bold')
% elseif up_itr == 3
%     ylabel(tlo, 'Uptake 90%','FontSize',12,'FontWeight','bold')
% end

%ylabel(tlo,{'Symptom attenuating' ''})
%ylabel(tlo,{'Infection blocking' ''})
%ylabel(tlo,{'Infection blocking' '(mild breakthrough infections)'})

% CL = [-15 10];
% cmap = customcolormap([0 0.4 1], {'#0000FF','#ffffff','#ee0000'});
% 
% nexttile(tlo4)
% hm = heatmap((sev_inf(:,:,2,param_itr,1)-sev_inf(:,:,2,param_itr,2)).*100/N,'GridVisible','off','ColorLimits',CL,'Colormap',cmap);
% %hm = heatmap(squeeze(opt_up(:,:,eff_itr)),'Colormap', blue, 'ColorLimits', [0 100],'GridVisible','off','CellLabelColor','none');
% %         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
% %         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
% hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
% hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
% hm.FontSize=8;
% hm.NodeChildren(3).YDir='normal'; 
% 
% ylabel('Baseline probability, \nu')
% xlabel('Dependence on infector, \alpha')
% title(sprintf('%d%%', run_opts{4}(eff_itr)*100))
% s = struct(hm);
% s.XAxis.TickLabelRotation = 0; 
% 
% axs = struct(gca); %ignore warning that this should be avoided
% cb = axs.Colorbar;
% cb.Ruler.TickLabelFormat='%g%%';
% 
% if param_itr == 1
%         title('Seasonal Influenza')
% elseif param_itr == 2
%         title('Pandemic Influenza')
% elseif param_itr == 3
%         title('SARS-CoV-2')
% end
% 
% title(tlo4,' ')


end