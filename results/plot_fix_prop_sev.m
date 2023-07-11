%% File for creating intervention result figures 
%% (with nu chosen to fix the proportion of cases that are severe)

%Set the axis font size and line width for all graphs in this code
set(0,'defaultaxesfontsize',12)
set(0,'defaultlinelinewidth',2.5)

%Define colours for plots
red = {[255,120,120]/255,[238,0,0]/255,[175,0,0]/255};
blue = {[153,204,255]/255,[50, 144,255]/255,[0,76,153]/255};
purple = {[0.6, 0.4, 0.85],[0.3, 0, 0.5]};
yellow = {[255,191,0]./255};

N =67330000;

int_opts = {'no_int','sb','ib','isb'};
%int_opts = {'no_int','ib','ib_sev'};
param_opts = {'sFlu','pFlu','cov'};

%Define runset options
runset =  [int_opts{2} '_fix_prop_sev_' param_opts{1}];
run_opts = define_run_opts(runset);

%Maximum number of years to run for
num_years = 30;

%Willingness-to-pay threshold (£)
WTP_thresh = 20000;

%Discounting rate
dis_rate = 0.035;


%%Temporal plots
for param_itr = 1:length(param_opts)
    fig = figure(param_itr);
    fig.Units = 'inches';
    set(gcf,'units','inch','position',[0,0,10,6])
    tlo = tiledlayout(2,4);
    tlo.TileSpacing = 'compact';
    tlo.Padding = 'compact';

    for up_itr = [6,10]
        for int_itr = 1:length(int_opts)
        
        nexttile(tlo)
        if int_itr ==1
    
            runset =  [int_opts{2} '_fix_prop_sev_' param_opts{param_itr}];
            load(['model_output_' runset '.mat'],'I')

            up_itr_tmp = 1;
            
        else
            runset =  [int_opts{int_itr} '_fix_prop_sev_' param_opts{param_itr}];
            load(['model_output_' runset '.mat'],'I')

            up_itr_tmp = up_itr;
        end

            dur1 = find(squeeze(sum(I(1,1,up_itr_tmp,1,:,:),6))>0.01,1,'last');
            dur2 = find(squeeze(sum(I(1,2,up_itr_tmp,1,:,:),6))>0.01,1,'last');
            dur = max(dur1,dur2);
            dur = min(dur, 4500);
            h = plot(1:dur, squeeze(I(1,1,up_itr_tmp,1,1:dur,1)./N), 'Color',yellow{1});
            hold on
            plot(1:dur, squeeze(I(1,1,up_itr_tmp,1,1:dur,2)./N), 'Color',red{2})
            plot(1:dur, squeeze(I(1,2,up_itr_tmp,1,1:dur,1)./N),':', 'Color',yellow{1})
            plot(1:dur, squeeze(I(1,2,up_itr_tmp,1,1:dur,2)./N),':', 'Color',red{2})


            hold off

            if up_itr == 1
                if int_itr == 1
                    title({'No intervention' ''})
                elseif int_itr == 2
                   title({'SA intervention' ''})
                elseif int_itr == 3
                    title({'IB intervention' ''})
                elseif int_itr == 4
                    title({'IB\_MB intervention' ''})

                end

            end

            if int_itr == 4
              
                if param_itr == 1
                    if up_itr == 1
                        label_h = ylabel('Uptake 50%');
                        label_h.Position(1) = 225;
                    else
                        label_h = ylabel('Uptake 90%');
                        label_h.Position(1) = 50;
                    end
                elseif param_itr == 2
                    if up_itr == 1
                        label_h = ylabel('Uptake 50%');
                        label_h.Position(1) = 800;
                    else
                        label_h = ylabel('Uptake 90%');
                        label_h.Position(1) = 90;
                    end
                elseif param_itr == 3
                    if up_itr == 1
                        label_h = ylabel('Uptake 50%');
                        label_h.Position(1) = 1700;
                    else
                        label_h = ylabel('Uptake 90%');
                        label_h.Position(1) = 115;
                    end
                end

    
            end

        end
    end
        xlabel(tlo, {'Time (days)' ' '})

end
 
figure(1)
L=legend('Mild', 'Severe','Orientation','horizontal','box','off');
newPosition = [0.425 0.005 0.18 0.025];
newUnits = 'inch';
set(L,'Position', newPosition,'Units', newUnits);

figure(2)
L=legend('Mild', 'Severe','Orientation','horizontal','box','off');
newPosition = [0.425 0.005 0.18 0.025];
newUnits = 'inch';
set(L,'Position', newPosition,'Units', newUnits);

figure(3)
L=legend('Mild', 'Severe','Orientation','horizontal','box','off');
newPosition = [0.425 0.005 0.18 0.025];
newUnits = 'inch';
set(L,'Position', newPosition,'Units', newUnits);


%% Initialise figures and create arrays for bar plots
figure(4)
tlo1 = tiledlayout(2,3);
set(gcf,'units','inch','position',[0,0,10,6])
tlo1.TileSpacing = 'compact';
tlo1.Padding = 'compact';

figure(5)
tlo2 = tiledlayout(3,3);
set(gcf,'units','inch','position',[0,0,10,9])
tlo2.TileSpacing = 'compact';
tlo2.Padding = 'compact';

up_opts = [0.5,0.9];

%Initialise arrays
tot_inf_array = zeros(length(int_opts), 2,length(param_opts),2);
peak_inf_array = zeros(length(int_opts), 2,length(param_opts),2,2);
peak_time_array = zeros(length(int_opts), 2,length(param_opts),2);
dur_array = zeros(length(int_opts), 2,length(param_opts),2);
TIC_array = zeros(length(int_opts)-1, 2,length(param_opts),length(run_opts{3}));
sev_inf_array = zeros(length(int_opts)-1, 2,length(param_opts),length(run_opts{3}));
compart_array = zeros(length(int_opts), 2,length(param_opts),2,4);

%Populate arrays from data file
for param_itr = 1:length(param_opts)
    for up_itr = 1:2
        for alpha_itr = 1:length(run_opts{2})
            for int_itr = 1:length(int_opts)
    
                if int_itr == 1 %If in no intervention case, take data from SA intervention with uptake = 0%
                    
                    runset =  [int_opts{2} '_fix_prop_sev_' param_opts{param_itr}];
                    load(['model_output_' runset '.mat'],'S','V','I','R')

                    s = sum(R(1,alpha_itr, 1,1,:,:),6);
                    ind = find(s>0,1,'last');
                    tot_inf_array(int_itr,alpha_itr,param_itr, up_itr) = sum(R(1,alpha_itr, 1,1,ind,:),6);

                    [M, peak_ind] = max(sum(I(1,alpha_itr, 1,1,:,:),6));

                    peak_inf_array(int_itr,alpha_itr,param_itr,up_itr,1) = I(1,alpha_itr, 1,1,peak_ind,2);
                    peak_inf_array(int_itr,alpha_itr,param_itr,up_itr,2) = I(1,alpha_itr, 1,1,peak_ind,1);
                    peak_time_array(int_itr,alpha_itr,param_itr,up_itr,:) = peak_ind - 1;
                    dur_array(int_itr,alpha_itr,param_itr,up_itr,:) = find(s>1,1,'last') - 1;

                    compart_array(int_itr,alpha_itr,param_itr, up_itr,4) = S(1,alpha_itr, 1,1,ind);
                    compart_array(int_itr,alpha_itr,param_itr, up_itr,3) = V(1,alpha_itr, 1,1,ind);
                    compart_array(int_itr,alpha_itr,param_itr, up_itr,2) = R(1,alpha_itr, 1,1,ind,1);
                    compart_array(int_itr,alpha_itr,param_itr, up_itr,1) = R(1,alpha_itr, 1,1,ind,2);

                else
                    runset =  [int_opts{int_itr} '_fix_prop_sev_' param_opts{param_itr}];
                    load(['model_output_' runset '.mat'],'S','V','I','R')

                    if up_itr == 1
                        up_itr_tmp = 51;
                    elseif up_itr == 2
                        up_itr_tmp = 91;
                    end

                    s = sum(R(1,alpha_itr, up_itr_tmp,1,:,:),6);
                    ind = find(s>0,1,'last');
                    tot_inf_array(int_itr,alpha_itr,param_itr, up_itr) = sum(R(1,alpha_itr, up_itr_tmp,1,ind,:),6);

                    [M, peak_ind] = max(sum(I(1,alpha_itr, up_itr_tmp,1,:,:),6));

                    peak_inf_array(int_itr,alpha_itr,param_itr,up_itr,1) = I(1,alpha_itr, up_itr_tmp,1,peak_ind,2);
                    peak_inf_array(int_itr,alpha_itr,param_itr,up_itr,2) = I(1,alpha_itr, up_itr_tmp,1,peak_ind,1);
                    peak_time_array(int_itr,alpha_itr,param_itr,up_itr,:) = peak_ind - 1;
                    dur_array(int_itr,alpha_itr,param_itr,up_itr,:) = find(s>1,1,'last') - 1;

                    compart_array(int_itr,alpha_itr,param_itr, up_itr,4) = S(1,alpha_itr, up_itr_tmp,1,ind);
                    compart_array(int_itr,alpha_itr,param_itr, up_itr,3) = V(1,alpha_itr, up_itr_tmp,1,ind);
                    compart_array(int_itr,alpha_itr,param_itr, up_itr,2) = R(1,alpha_itr, up_itr_tmp,1,ind,1);
                    compart_array(int_itr,alpha_itr,param_itr, up_itr,1) = R(1,alpha_itr, up_itr_tmp,1,ind,2);

                  
                end
            end
        end
    end
end

%% Calculate threshold unit intervention costs

for param_itr = 1:length(param_opts)
    for int_itr = 2:length(int_opts)

        runset =  [int_opts{int_itr} '_fix_prop_sev_' param_opts{param_itr}];
        load(['model_output_' runset '.mat'],'S','V','I','R')

        for alpha_itr = 1:length(run_opts{2})
            for up_itr = 1:length(run_opts{3})

                s = sum(R(1,alpha_itr, up_itr,1,:,:),6);
                ind = find(s>0,1,'last');

                s = sum(R(1,alpha_itr, 1,1,:,:),6);
                ind_0 = find(s>0,1,'last');

                sev_inf_array(int_itr-1, alpha_itr, param_itr, up_itr) = R(1,alpha_itr, 1,1,ind_0,2)- R(1,alpha_itr, up_itr,1,ind,2);

                if up_itr == 1
                    inf_array = zeros(num_years,2);
                    for y = 1:num_years
                        if y*365 < ind
                            inf_array(y,:) = R(1,alpha_itr, 1,1,y*365,:);
                        else
                            inf_array(y,:) = R(1,alpha_itr, 1,1,ind,:);
                        end
                    end
                    [QALYs_base, hosp_cost_base] = Calc_HE(inf_array,dis_rate,num_years,param_itr);
                else
                    inf_array = zeros(num_years,2);
                    for y = 1:num_years
                        if y*365 < ind
                            inf_array(y,:) = R(1,alpha_itr, up_itr,1,y*365,:);
                        else
                            inf_array(y,:) = R(1,alpha_itr, up_itr,1,ind,:);
                        end
                    end
                    [QALYs, hosp_cost] = Calc_HE(inf_array,dis_rate,num_years,param_itr);

                    QALYs_prev = QALYs_base - QALYs;
                    hosp_cost_prev = hosp_cost_base - hosp_cost;
                    
                    TIC_array(int_itr-1, alpha_itr, param_itr, up_itr) = (WTP_thresh*QALYs_prev + hosp_cost_prev)/(run_opts{3}(up_itr)*N);

                end
            end
        end
    end
end
                    

%% Create arrays for bar plots - compartments

for param_itr = 1:length(param_opts)
for up_itr = 1:2
    nexttile(tlo2,param_itr+(up_itr-1)*3)

    NumStacksPerGroup = 2;
    NumGroupsPerAxis = 4;
    NumStackElements = 4;
    
    % labels to use on tick marks for groups
    groupLabels = {'No','SA' 'IB','IB\_MB'};
    %groupLabels = {'No','IB','IB\_S'};

    h = plotBarStackGroups(compart_array(:,:,param_itr,up_itr,:)./N, groupLabels);

    box on
    
    %Set colours and hatching
    set(h(1,1),'FaceColor', red{2},'FaceAlpha',0.2)
    hatchfill2(h(1,1),'single','HatchAngle',-45,'hatchcolor',red{2},'HatchLineWidth',1.5)
    set(h(2,1),'FaceColor', red{2})
    set(h(1,2),'FaceColor', yellow{1},'FaceAlpha',0.2)
    hatchfill2(h(1,2),'single','HatchAngle',-45,'hatchcolor',yellow{1},'HatchLineWidth',1.5)
    set(h(2,2),'FaceColor', yellow{1})
    set(h(1,3),'FaceColor', blue{1},'FaceAlpha',0.2)
    hatchfill2(h(1,3),'single','HatchAngle',-45,'hatchcolor',blue{1},'HatchLineWidth',1.5)
    set(h(2,3),'FaceColor', blue{1})
    set(h(:,4),'FaceColor', 'none')
    
    ylim([0 1])

    %Axis labels and titles
    if param_itr == 1
        ylabel('Proportion of population')
    end

    if up_itr == 1
        if param_itr == 1
           title({'Seasonal Influenza'})
          
        elseif param_itr == 2
            title({'Pandemic Influenza'})
        else 
            title({'SARS-CoV-2'})
            label_h = ylabel({'Uptake 50%'},'Rotation',-90,'FontWeight','bold');
        label_h.Position(1) = 4.3;
        end
    else
        if param_itr == 3
        label_h = ylabel('Uptake 90%','Rotation',-90,'FontWeight','bold');
        label_h.Position(1) = 4.3;
        end
    end
end

end

%% Legend moved to separate file legend_creation.m
% L=legend('R_S','','R_M','','V','','S','R_S','R_M','V','S','Orientation','horizontal','FontSize',12,'NumColumns',4);
% newPosition = [0.36 0.3 0.38 0.05];
% newUnits = 'inch';
% set(L,'Position', newPosition,'Units', newUnits);
%legend boxoff
%[legend_h,object_h,plot_h,text_str] = legendflex(h(2,:),Legend,'FontSize',12,'orientation','horizontal','nrow',2,'anchor',[7,5],'buffer',[-10,0],'box','off');


%% Create arrays for bar plots - Threshold unit intervention cost
figure(6)
tlo3 = tiledlayout(2,3);
set(gcf,'units','inch','position',[0,0,10,6])
tlo3.TileSpacing = 'compact';
tlo3.Padding = 'compact';

for param_itr = 1:length(param_opts)
for up_itr = 1:2
    nexttile(tlo3,param_itr+(up_itr-1)*3)

    if up_itr == 1
        up_itr_tmp = 51;
    elseif up_itr == 2
        up_itr_tmp = 91;
    end

    m = max(TIC_array(:,:,param_itr,:),[],"all");

    b = bar(TIC_array(:,:,param_itr,up_itr_tmp)./m);
    b(1).FaceColor = purple{1};
    b(1).FaceAlpha = 0.2;
    b(2).FaceColor = purple{1};
    hatchfill2(b(1),'single','HatchAngle',-45,'hatchcolor',purple{1},'HatchLineWidth',1.5)
   
    set(gca, 'XTickLabel', {'SA' 'IB','IB\_MB'})
    %set(gca, 'XTickLabel', {'IB','IB\_S'})

    ylim([0 1.05])

    %Axis labels and titles
    if param_itr == 3
        if up_itr == 1
            label_h = ylabel('Uptake 50%','Rotation',-90,'FontWeight','bold');
        else
            label_h = ylabel('Uptake 90%','Rotation',-90,'FontWeight','bold');
        end
        
        %label_h.Position(1) = 3.6;
        label_h.Position(1) = 2.5; % change horizontal position of ylabel
    elseif param_itr == 1
        label_h = ylabel('Threshold intervention cost');
        if up_itr == 1
%             Legend = {'\alpha=0.2','\alpha=0.8'};
%             [legend_h,object_h,plot_h,text_str] = legendflex(b,Legend);
            %,'FontSize',12);%,'anchor',[1,1],'buffer',[10, -15],'box','off');
            %hatchfill2(object_h(3),'single','HatchAngle',-45,'hatchcolor',purple{1},'HatchLineWidth',1.5)
        %label_h.Position(1) = -0.27; % change horizontal position of ylabel
        end
        
    end

    if up_itr == 1
        if param_itr == 1
              title({'Seasonal Influenza'})
        elseif param_itr == 2
            title({'Pandemic Influenza'})
        else 
            title({'SARS-CoV-2'})
        end
    end
end
end

%% Create arrays for bar plots - duration
figure(7)
tlo7 = tiledlayout(2,3);
set(gcf,'units','inch','position',[0,0,10,6])
tlo7.TileSpacing = 'compact';
tlo7.Padding = 'compact';

for param_itr = 1:length(param_opts)
for up_itr = 1:2
    nexttile(tlo7,param_itr+(up_itr-1)*3)

    

    b = bar(dur_array(:,:,param_itr,up_itr));
    color = 'k';
    b(1).FaceColor = color;
    b(1).FaceAlpha = 0.2;
    b(2).FaceColor = color;
    hatchfill2(b(1),'single','HatchAngle',-45,'hatchcolor',color,'HatchLineWidth',1.5)

    %candystripe(b(2),'Color','w','Units','native','width',1);
    set(gca, 'XTickLabel', {'No','SA' 'IB','IB\_MB'})

    set(gca,'YScale','log')
    set(gca, 'YLim',[10 15000])
    set(gca, 'YTickLabel', {'10' '100','1,000','10,000'})


    if param_itr == 3
        if up_itr == 1
            label_h = ylabel('Uptake 50%','Rotation',-90,'FontWeight','bold');
        else
            label_h = ylabel('Uptake 90%','Rotation',-90,'FontWeight','bold');
        end
        label_h.Position(1) = 4.6; % change horizontal position of ylabel
    elseif param_itr == 1
        ylabel('Duration (days)')
    end

    if up_itr == 1
        if param_itr == 1
              title({'Seasonal Influenza'})
        elseif param_itr == 2
            title({'Pandemic Influenza'})
        else 
            title({'SARS-CoV-2'})
        end
    end
end
end

%% Create arrays for bar plots - peak prevalence
figure(8)
tlo8 = tiledlayout(3,3);
set(gcf,'units','inch','position',[0,0,10,9])
tlo8.TileSpacing = 'compact';
tlo8.Padding = 'compact';

for param_itr = 1:length(param_opts)
for up_itr = 1:2
    nexttile(tlo8,param_itr+(up_itr-1)*3)

    NumStacksPerGroup = 2;
    NumGroupsPerAxis = 4;
    NumStackElements = 2;
    
    % labels to use on tick marks for groups
    groupLabels = {'No','SA' 'IB','IB\_MB'};

    h = plotBarStackGroups(peak_inf_array(:,:,param_itr,up_itr,:)./N, groupLabels);

    set(h(1,1),'FaceColor', red{2},'FaceAlpha',0.2)
    hatchfill2(h(1,1),'single','HatchAngle',-45,'hatchcolor',red{2},'HatchLineWidth',1.5)
    set(h(2,1),'FaceColor', red{2})
    set(h(1,2),'FaceColor', yellow{1},'FaceAlpha',0.2)
    hatchfill2(h(1,2),'single','HatchAngle',-45,'hatchcolor',yellow{1},'HatchLineWidth',1.5)
    set(h(2,2),'FaceColor', yellow{1})
   

    box on
   

    %ylim([0 1])
%     set(gca, 'XTickLabel', {'No','SB' 'IB','ISB'})

    if param_itr == 1
        ylabel('Proportion of population')
    end

    if up_itr == 1
        if param_itr == 1
           title({'Seasonal Influenza'})
           
        elseif param_itr == 2
            title({'Pandemic Influenza'})
        else 
            title({'SARS-CoV-2'})
            label_h = ylabel('Uptake 50%','Rotation',-90,'FontWeight','bold');
        label_h.Position(1) = 5.3;
        end
    else
        if param_itr == 3
        label_h = ylabel('Uptake 90%','Rotation',-90,'FontWeight','bold');
        label_h.Position(1) = 5.3;
        end
    end
end

end

figure(8)
L=legend('Severe','Mild','Orientation','horizontal','FontSize',12);
newPosition = [0.39 0.3 0.3 0.04];
newUnits = 'inch';
set(L,'Position', newPosition,'Units', newUnits);

legend boxoff

%% TIC vs uptake plots
figure(9)
tlo9 = tiledlayout(3,3);
set(gcf,'units','inch','position',[0,0,10,9])
tlo9.TileSpacing = 'compact';
tlo9.Padding = 'compact';


for param_itr = 1:length(param_opts)
    for int_itr = 2:length(int_opts)
        nexttile(tlo9)

            m = max(TIC_array(:,:,param_itr,:),[],"all");

            plot(run_opts{3}(2:end),squeeze(TIC_array(int_itr-1, 1, param_itr, 2:end))./m,'Color',purple{1},'LineStyle','--')
            hold on
            plot(run_opts{3}(2:end),squeeze(TIC_array(int_itr-1, 2, param_itr, 2:end))./m,'Color',purple{2})

            hold off

            if param_itr == 1 && int_itr == 4
                legend('\alpha=0.2','\alpha=0.8','Location','northeast')
            end
        

            ylim([0 1.05])
            xticklabels({'0%','50%','100%'})
            xlabel('Uptake')

            if int_itr == 2
                ylabel('Threshold intervention cost')
            end
        
            if param_itr == 1
                if int_itr == 2
                   title({'Symptom-attenuating' ''})
                   
                elseif int_itr == 3
                    title({'Infection-blocking' ''})
                elseif int_itr == 4
                    title({'Infection-blocking' '(mild breakthroughs)'})
                    label_h = ylabel('Seasonal Influenza','Rotation',-90,'FontWeight','bold');
                    label_h.Position(1) = 1.05;
                end

            else
                if int_itr == 4
                    if param_itr == 2
                        label_h = ylabel('Pandemic Influenza','Rotation',-90,'FontWeight','bold');
                    elseif param_itr == 3
                        label_h = ylabel('SARS-CoV-2','Rotation',-90,'FontWeight','bold');
                    end
                    label_h.Position(1) = 1.05;
                end
            end
    end
end

%% Severe cases prevented vs uptake plots
% figure(10)
% tlo10 = tiledlayout(3,3);
% set(gcf,'units','inch','position',[0,0,10,9])
% tlo10.TileSpacing = 'compact';
% tlo10.Padding = 'compact';
% 
% 
% for param_itr = 1:length(param_opts)
%     for int_itr = 2:length(int_opts)
%         nexttile(tlo10)
% 
%             plot(run_opts{3}(2:end),squeeze(sev_inf_array(int_itr-1, 1, param_itr, 2:end))./N,'Color',red{2})
%             hold on
%             plot(run_opts{3}(2:end),squeeze(sev_inf_array(int_itr-1, 2, param_itr, 2:end))./N,'Color',red{1},'LineStyle','--')
%             hold off
% 
%             legend('\alpha=0.2','\alpha=0.8','Location','northwest')
%             ylim([0 1])
% 
%             xticklabels({'0%','50%','100%'})
%             xlabel('Uptake')
% 
%             if int_itr == 2
%                 ylabel('Severe infections prevented')
%             end
%         
%             if param_itr == 1
%                 if int_itr == 2
%                    title({'Symptom-attenuating' ''})
%                    
%                 elseif int_itr == 3
%                     title({'Infection-blocking' ''})
%                 elseif int_itr == 4
%                     title({'Infection-blocking' '(mild breakthroughs)'})
%                     label_h = ylabel('Seasonal Influenza','Rotation',-90,'FontWeight','bold');
%                     label_h.Position(1) = 1.05;
%                 end
% 
%             else
%                 if int_itr == 4
%                     if param_itr == 2
%                         label_h = ylabel('Pandemic Influenza','Rotation',-90,'FontWeight','bold');
%                     elseif param_itr == 3
%                         label_h = ylabel('SARS-CoV-2','Rotation',-90,'FontWeight','bold');
%                     end
%                     label_h.Position(1) = 1.05;
%                 end
%             end
%     end
% end
%             

%% Function to calculate health economic outputs from data file in order to generate TICs
function [QALYs, hosp_cost] = Calc_HE(inf_array, dis_rate,num_years, param_itr)

    if param_itr == 1 || param_itr == 2
        %% Define death and hosp rates
    %These rates apply only to those with severe disease
    hosp_rate = 0.01;
    death_rate = 0.001;
    
    %% Define QALY losses
    death_QALY_loss = 37.5;
    hosp_QALY_loss = 0.018;
    non_hosp_sev_QALY_loss = 0.008;
    mild_QALY_loss = 0;
    
    %% Define costs
    
    hosp_non_fatal = 1300;
    hosp_fatal = 2600;
    else
     %% Define death and hosp rates
    %These rates apply only to those with severe disease
    hosp_rate = 0.065;
    death_rate = 0.02;
    
    %% Define QALY losses
    death_QALY_loss = 11.29;
    hosp_QALY_loss = 0.00587;
    non_hosp_sev_QALY_loss = 0.00348;
    mild_QALY_loss = 0;
    
    %% Define costs
    
    hosp_non_fatal = 1300*2;
    hosp_fatal = 2600*2;
    end


    %% Calculate QALYs

    % Initialise array for storing QALYs lost per year
    QALYs = zeros(num_years,1);
    
    
    % Calculate QALY losses for each year
    for y = 1:num_years
        if y == 1
            death_QALY = death_QALY_loss*death_rate*inf_array(y,2);
            hosp_QALY = hosp_QALY_loss*(hosp_rate-death_rate)*inf_array(y,2);
            non_hosp_sev_QALY = non_hosp_sev_QALY_loss*(1-hosp_rate)*inf_array(y,2);
            mild_QALY = mild_QALY_loss*inf_array(y,1);
        else
            death_QALY = death_QALY_loss*death_rate*(inf_array(y,2)-inf_array(y-1,2));
            hosp_QALY = hosp_QALY_loss*(hosp_rate-death_rate)*(inf_array(y,2)-inf_array(y-1,2));
            non_hosp_sev_QALY = non_hosp_sev_QALY_loss*(1-hosp_rate)*(inf_array(y,2)-inf_array(y-1,2));
            mild_QALY = mild_QALY_loss*(inf_array(y,1)-inf_array(y-1,1));
        end
        QALYs(y) = death_QALY + hosp_QALY + non_hosp_sev_QALY + mild_QALY;
    end

    QALYs_dis_new = 0;
    %Apply discounting
    for y = 1:num_years
        QALYs_dis_new = QALYs_dis_new + QALYs(y)*(1/(1+dis_rate))^(y-1);
    end

    %Calculate QALYs gained compared to the baseline
    QALYs = QALYs_dis_new;


    %% Calculate hosp cost
    % Initialise array for storing hospital costs per year
    hosp_cost = zeros(num_years,1);
    
    % Calculate QALY losses for each year
    for y = 1:num_years
        if y == 1
            hosp_cost(y) = hosp_fatal*death_rate*inf_array(y,2)+ hosp_non_fatal*(hosp_rate-death_rate)*inf_array(y,2);
        else
            hosp_cost(y) = hosp_fatal*death_rate*(inf_array(y,2)-inf_array(y-1,2)) + hosp_non_fatal*(hosp_rate-death_rate)*(inf_array(y,2)-inf_array(y-1,2));
        end
    end

    hosp_cost_dis_new = 0;
    %Apply discounting
    for y = 1:num_years
        hosp_cost_dis_new = hosp_cost_dis_new + hosp_cost(y)*(1/(1+dis_rate))^(y-1);
    end

    hosp_cost = hosp_cost_dis_new;

%     %Calculate QALYs gained compared to the baseline
%     hosp_cost_prev_dis = - hosp_cost_dis_new + hosp_cost_base;
% 
%     
% 
%     %% Calculate TIC 
%     TIC = (WTP_thresh*QALYs_prev_dis + hosp_cost_prev_dis)/(u*N);

end
    


