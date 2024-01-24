
%% Bar and line plots showing impact of symptom propagation on epidemiological outcomes 
%% (Outbreak size, peak prevalence and duration)

%Set the axis font size and line width for all graphs in this code
set(0,'defaultaxesfontsize',12)
set(0,'defaultlinelinewidth',2.5)

%% Define colours for plots
red = {[255,120,120]/255,[238,0,0]/255,[175,0,0]/255};
blue = {[153,204,255]/255,[50, 144,255]/255,[0,76,153]/255};
yellow = {[255,191,0]./255};

%Colour map for heatmap
prop_sev_cmap = customcolormap([0 0.5 1], {'#EE0000','#ffbf00','#FFFFFF'});

%% Define runsets used in these plots
%Used for bar/line plots, alpha in increments of 0.1 (Figs 3, S4)
%runsets = {'no_int_sFlu','no_int_pFlu','no_int_cov'};

%Used for heatmap, alpha in increments of 0.05 (Fig 4)
%runsets = {'no_int_sFlu_100','no_int_pFlu_100','no_int_cov_100'}; 

%Used for bar/line plots, alpha in increments of 0.1 with fixed beta (Figs )
runsets = {'no_int_sFlu_fix_beta','no_int_pFlu_fix_beta','no_int_cov_fix_beta'};

if strcmp(runsets,{'no_int_sFlu_100','no_int_pFlu_100','no_int_cov_100'})
    figure(4)
    set(gcf,'units','inch','position',[0,0,12,3])
    tlo = tiledlayout(1,3);
    
    %tlo.TileSpacing = 'compact';
    tlo.Padding = 'compact';

    %Iterate through the runsets
    for run_itr = 1:length(runsets)
        
    runset = runsets{run_itr};
    
    %Get the run options for this runset
    run_opts = define_run_opts(runset);
    
    % Get results from .mat file
    load(['model_output_' runset '.mat'], 'parameters','outputs')

    R_tot = zeros(length(run_opts{1}),length(run_opts{2}),parameters(1).n_severity);
    prop_sev = zeros(length(run_opts{1}),length(run_opts{2}));
    
    for nu_itr = 1:length(run_opts{1})
    for alpha_itr = 1:length(run_opts{2})
        R_tot(nu_itr,alpha_itr,:) = sum(outputs(nu_itr,alpha_itr).R(end,:,:),2);
        prop_sev(nu_itr, alpha_itr) = R_tot(nu_itr,alpha_itr,2)/(R_tot(nu_itr,alpha_itr,1) + R_tot(nu_itr,alpha_itr,2));
    end
    end

    nexttile(tlo)
    hold on
    p = pcolor(run_opts{1},run_opts{2},prop_sev);
    colormap(prop_sev_cmap)
    set(p,'EdgeColor','none')
    clim([0 1])
    [c h] = contour(0:0.05:1,0.05:0.05:1,prop_sev(2:21,:),[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9],'k','LineWidth',1.2);
    clabel(c,h, 'labelspacing', 250);
    hold off
    %cl = colorbar;
    %[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]

        if run_itr == 1
           title({'Seasonal Influenza'})
        elseif run_itr == 2
            title({'Pandemic Influenza'})
        else 
            title({'SARS-CoV-2'})
        end
        ylabel('Baseline probability, \nu','FontSize',12)
        xlabel('Dependence on infector, \alpha','FontSize',12)
      
    end

    cl = colorbar;
    

elseif strcmp(runsets,{'no_int_sFlu','no_int_pFlu','no_int_cov'})

%% Initialise figures
figure(1)
set(gcf,'units','inch','position',[0,0,12,6])
tlo = tiledlayout(2,3);
%tlo.TileSpacing = 'compact';
tlo.Padding = 'compact';

figure(2)
set(gcf,'units','inch','position',[0,0,12,6])
tlo2 = tiledlayout(2,3);
%tlo2.TileSpacing = 'compact';
tlo2.Padding = 'compact';

figure(4) 
set(gcf,'units','inch','position',[0,0,12,3])
tlo4 = tiledlayout(1,3);
tlo4.Padding = 'compact';

figure(5) 
set(gcf,'units','inch','position',[0,0,12,3])
tlo5 = tiledlayout(1,3);
tlo5.Padding = 'compact';

figure(6) 
set(gcf,'units','inch','position',[0,0,12,3])
tlo6 = tiledlayout(1,3);
%tlo6.TileSpacing = 'compact';
tlo6.Padding = 'compact';

%% Iterate through the runsets
for run_itr = 1:length(runsets)
    
    runset = runsets{run_itr};
    
    %Get the run options for this runset
    run_opts = define_run_opts(runset);
    
    % Get results from .mat file
    load(['model_output_' runset '.mat'], 'parameters','outputs')
    
    %Initialse arrays for plots
    R_tot = zeros(length(run_opts{2}),parameters(1).n_severity);
    prop_sev = zeros(length(run_opts{2}),parameters(1).n_severity);
    I_peak = zeros(length(run_opts{2}),parameters(1).n_severity);
    dur = zeros(1,length(run_opts{2}));
    
    fix_itr = 1;
    
    N = parameters(1).pop_vec;
    
    %% Populate arrays
    for opts_itr = 1:length(run_opts{2})
        %Total cases
        R_tot(opts_itr,:) = sum(outputs(fix_itr,opts_itr).R(end,:,:),2);
        
        %Proportion severe
        prop_sev = R_tot(opts_itr,2)/(R_tot(opts_itr,1) + R_tot(opts_itr,2));

        %Find time with the peak in infections across all age classes and severity levels
        [M,I]=max(sum(outputs(fix_itr,opts_itr).I,[2,3]));
        I_peak(opts_itr,:) = outputs(fix_itr,opts_itr).I(I,:,:);
    
        LastInft = find(sum(outputs(fix_itr,opts_itr).I,[2,3])>0.9,1,'last'); %find last '1' elements to meet condition
        Duration = ceil(outputs(fix_itr,opts_itr).t(LastInft));
        if isempty(Duration)
            Duration = maxtime;
        end

        %Duration
        dur(fix_itr,opts_itr) = Duration; 
    end
    
    
    %% Plot total proportion against alpha - bar (Fig 3)
    figure(1) 
   
    nexttile(tlo)
    b=bar(run_opts{2},R_tot(:,[2,1])./N,'stacked');
    
    b(2).FaceColor = yellow{1};
    b(1).FaceColor = red{2};
    
    xlabel('Dependence on infector, \alpha')
    if run_itr == 1
    ylabel('Final outbreak size')
    title('Seasonal Influenza')
    elseif run_itr ==2
        title('Pandemic Influenza')
    else
        title('SARS-CoV-2')
    end
    ylim([0 1])
    
       
    %% Plot peak proportion against alpha - bar (Fig 3)
    figure(2) 
    nexttile(tlo2)
    b=bar(run_opts{2},I_peak(:,[2,1])./N,'stacked');
    
    b(2).FaceColor = yellow{1};
    b(1).FaceColor = red{2};
    
    xlabel('Dependence on infector, \alpha')
    if run_itr == 1
    ylabel('Peak prevalence')
    end
    ylim([0 0.275])



%% Plot final outbreak size against alpha - line (Fig S4)
nexttile(tlo4)
plot(run_opts{2},sum(R_tot./N,2),'color',blue{3});

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('Final outbreak size')
    title('Seasonal Influenza')
    elseif run_itr ==2
        title('Pandemic Influenza')
    else
        title('SARS-CoV-2')
end

   
%% Plot peak proportion against alpha - line (Fig S4)
figure(5) 
nexttile(tlo5)
plot(run_opts{2},sum(I_peak./N,2),'color',red{3});

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('Peak prevalence')
end

title(' ')


%% Plot duration against alpha - line (Fig 3)

nexttile(tlo6)
plot(run_opts{2},dur(fix_itr,:),'-k');

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('Duration (days)')
end

end
elseif strcmp(runsets, {'no_int_sFlu_fix_beta','no_int_pFlu_fix_beta','no_int_cov_fix_beta'})
    %% Initialise figures
figure(1)
set(gcf,'units','inch','position',[0,0,12,6])
tlo = tiledlayout(2,3);
%tlo.TileSpacing = 'compact';
tlo.Padding = 'compact';

figure(2)
set(gcf,'units','inch','position',[0,0,12,6])
tlo2 = tiledlayout(2,3);
%tlo2.TileSpacing = 'compact';
tlo2.Padding = 'compact';

figure(3)
set(gcf,'units','inch','position',[0,0,12,3])
tlo3 = tiledlayout(1,3);
%tlo3.TileSpacing = 'compact';
tlo3.Padding = 'compact';

figure(4) 
set(gcf,'units','inch','position',[0,0,12,3])
tlo4 = tiledlayout(1,3);
tlo4.Padding = 'compact';

figure(5) 
set(gcf,'units','inch','position',[0,0,12,3])
tlo5 = tiledlayout(1,3);
tlo5.Padding = 'compact';

figure(6) 
set(gcf,'units','inch','position',[0,0,12,3])
tlo6 = tiledlayout(1,3);
%tlo6.TileSpacing = 'compact';
tlo6.Padding = 'compact';

%% Iterate through the runsets
for run_itr = 1:length(runsets)
    
    runset = runsets{run_itr};
    
    %Get the run options for this runset
    run_opts = define_run_opts(runset);
    
    % Get results from .mat file
    load(['model_output_' runset '.mat'], 'parameters','outputs')
    
    %Initialse arrays for plots
    R_tot = zeros(length(run_opts{2}),parameters(1).n_severity);
    prop_sev = zeros(length(run_opts{2}),parameters(1).n_severity);
    I_peak = zeros(length(run_opts{2}),parameters(1).n_severity);
    dur = zeros(1,length(run_opts{2}));
    R0 = zeros(1,length(run_opts{2}));
    
    fix_itr = 1;
    
    N = parameters(1).pop_vec;
    
    %% Populate arrays
    for opts_itr = 1:length(run_opts{2})
        %Total cases
        R_tot(opts_itr,:) = sum(outputs(fix_itr,opts_itr).R(end,:,:),2);
        
        %Proportion severe
        prop_sev = R_tot(opts_itr,2)/(R_tot(opts_itr,1) + R_tot(opts_itr,2));

        %Find time with the peak in infections across all age classes and severity levels
        [M,I]=max(sum(outputs(fix_itr,opts_itr).I,[2,3]));
        I_peak(opts_itr,:) = outputs(fix_itr,opts_itr).I(I,:,:);
    
        LastInft = find(sum(outputs(fix_itr,opts_itr).I,[2,3])>0.9,1,'last'); %find last '1' elements to meet condition
        Duration = ceil(outputs(fix_itr,opts_itr).t(LastInft));
        if isempty(Duration)
            Duration = maxtime;
        end

        %Duration
        dur(fix_itr,opts_itr) = Duration; 

        R0(opts_itr) = parameters(opts_itr).R0;
    end
    
    
    %% Plot total proportion against alpha - bar (Fig 3)
    figure(1) 
   
    nexttile(tlo)
    b=bar(run_opts{2},R_tot(:,[2,1])./N,'stacked');
    
    b(2).FaceColor = yellow{1};
    b(1).FaceColor = red{2};
    
    xlabel('Dependence on infector, \alpha')
    if run_itr == 1
    ylabel('Final outbreak size')
    title('Seasonal Influenza')
    elseif run_itr ==2
        title('Pandemic Influenza')
    else
        title('SARS-CoV-2')
    end
    ylim([0 1])
    
       
    %% Plot peak proportion against alpha - bar (Fig 3)
    figure(2) 
    nexttile(tlo2)
    b=bar(run_opts{2},I_peak(:,[2,1])./N,'stacked');
    
    b(2).FaceColor = yellow{1};
    b(1).FaceColor = red{2};
    
    xlabel('Dependence on infector, \alpha')
    if run_itr == 1
    ylabel('Peak prevalence')
    end
    ylim([0 0.5])

%% Plot R0 against alpha - bar (Fig
nexttile(tlo3)
b=bar(run_opts{2},R0);
b.FaceColor = blue{3};

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('R0')
    title('Seasonal Influenza')
    elseif run_itr ==2
        title('Pandemic Influenza')
    else
        title('SARS-CoV-2')
end
ylim([0 10.1])

%% Plot final outbreak size against alpha - line (Fig S4)
nexttile(tlo4)
plot(run_opts{2},sum(R_tot./N,2),'color',blue{3});

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('Final outbreak size')
    title('Seasonal Influenza')
    elseif run_itr ==2
        title('Pandemic Influenza')
    else
        title('SARS-CoV-2')
end

   
%% Plot peak proportion against alpha - line (Fig S4)
figure(5) 
nexttile(tlo5)
plot(run_opts{2},sum(I_peak./N,2),'color',red{3});

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('Peak prevalence')
end

title(' ')


%% Plot duration against alpha - line (Fig 3)

nexttile(tlo6)
plot(run_opts{2},dur(fix_itr,:),'-k');

xlabel('Dependence on infector, \alpha')
if run_itr == 1
    ylabel('Duration (days)')
end
%ylim([180 600])

end
end

figure(2)
L=legend('Severe', 'Mild','Orientation','horizontal','FontSize',12);
newPosition = [0.43 0.43 0.16 0.05];
newUnits = 'inch';
set(L,'Position', newPosition,'Units', newUnits);
legend boxoff

%L=legend('Mild', 'Severe','Orientation','horizontal');
% newPosition = [0.73 0.4 0.1 0.15];
% newUnits = 'inch';
% set(L,'Position', newPosition,'Units', newUnits);

