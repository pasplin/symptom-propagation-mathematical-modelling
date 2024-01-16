%% Compare number of severe cases between SA and IB intervention - Fig 6

interventions = {'sb', 'ib'};
param_sets = {'sFlu','pFlu','cov'};

up_opts = [51,71,91];

%Change eff_itr to vary efficacy 1: 50%, 2:70%, 3:90%
eff_itr = 2;

%Define population size
N =67330000;

% Get run options for array initialisation
runset = [interventions{1} '_int_find_opt_up_' param_sets{1}];
run_opts = define_run_opts(runset);

figure(4)
set(gcf,'units','inch','position',[0,0,10,3])
tlo4 = tiledlayout(1,3);
tlo4.Padding = 'compact';

sev_inf = zeros(length(run_opts{1}), length(run_opts{2}), length(up_opts), length(param_sets), length(interventions));


for up_itr = 1:length(up_opts)

%% Initialse figures
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

%% Populate arrays from data
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

%% Define colour map
CL = [-45 45];
cmap = customcolormap([0 0.49, 0.5, 0.51, 1], {'#0000ff','#E3E3FF','#ffffff','#FFEBEB','#ee0000'});

%% Create heatmaps
for param_itr = 1:length(param_sets)


    nexttile(tlo)
    hm = heatmap((sev_inf(:,:,up_itr,param_itr,1)-sev_inf(:,:,up_itr,param_itr,2)).*100/N,'GridVisible','off','ColorLimits',CL,'Colormap',cmap);
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
   

end

%% Create axis labels
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


end