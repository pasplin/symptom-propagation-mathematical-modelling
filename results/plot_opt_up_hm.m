%% Plot heatmaps for how optimal uptake varies

blue = customcolormap([0 0.5 1], {'#000000','#76A5DB','#ffffff'});
%blue = customcolormap([0 0.5 1], {'#000000','#2D9AAD','#ffffff'});
%blue = customcolormap([0 0.5 1], {'#000000','#B5386C','#ffffff'});
pink = customcolormap([0 0.5 1], {'#000000','#F26691','#ffffff'});
orange = customcolormap([0 0.5 1], {'#000000','#EB7D00','#ffffff'});
green = customcolormap([0 0.5 1], {'#000000','#69C988','#ffffff'});
purple = customcolormap([0 0.5 1], {'#000000','#9966D9','#ffffff'});

runsets = {'sb_int_find_opt_up_flu_1.5','sb_int_find_opt_up_flu_3.0','sb_int_find_opt_up_cov_3.0'};
%runsets = {'ib_int_find_opt_up_flu_1.5','ib_int_find_opt_up_flu_3.0','ib_int_find_opt_up_cov_3.0'};
%runsets = {'isb_int_find_opt_up_flu_1.5','isb_int_find_opt_up_flu_3.0','isb_int_find_opt_up_cov_3.0'};
%runsets = {'ib_sev_int_find_opt_up_flu_1.5','ib_sev_int_find_opt_up_flu_3.0','ib_sev_int_find_opt_up_cov_3.0'};

set(0,'defaultaxesfontsize',10)

figure(1)
set(gcf,'units','inch','position',[0,0,10,3])
tlo1 = tiledlayout(1,3);
tlo1.Padding = 'compact';

figure(2)
set(gcf,'units','inch','position',[0,0,10,3])
tlo2 = tiledlayout(1,3);
tlo2.Padding = 'compact';

figure(3)
set(gcf,'units','inch','position',[0,0,10,3])
tlo3 = tiledlayout(1,3);
tlo3.Padding = 'compact';

figure(4)
set(gcf,'units','inch','position',[0,0,10,3])
tlo4 = tiledlayout(1,3);
tlo4.Padding = 'compact';

figure(5)
set(gcf,'units','inch','position',[0,0,10,3])
tlo5 = tiledlayout(1,3);
tlo5.Padding = 'compact';

figure(6)
set(gcf,'units','inch','position',[0,0,10,3])
tlo6 = tiledlayout(1,3);
tlo6.Padding = 'compact';

figure(7)
set(gcf,'units','inch','position',[0,0,10,3])
tlo7 = tiledlayout(1,3);
tlo7.Padding = 'compact';

figure(8)
set(gcf,'units','inch','position',[0,0,10,3])
tlo8 = tiledlayout(1,3);
tlo8.Padding = 'compact';

figure(9)
set(gcf,'units','inch','position',[0,0,10,3])
tlo9 = tiledlayout(1,3);
tlo9.Padding = 'compact';

figure(10)
set(gcf,'units','inch','position',[0,0,10,3])
tlo10 = tiledlayout(1,3);
tlo10.Padding = 'compact';

figure(11)
set(gcf,'units','inch','position',[0,0,10,3])
tlo11 = tiledlayout(1,3);
tlo11.Padding = 'compact';

figure(12)
set(gcf,'units','inch','position',[0,0,10,3])
tlo12 = tiledlayout(1,3);
tlo12.Padding = 'compact';

tot_inf_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}),length(runsets));

for run_itr = 1:length(runsets)
runset = runsets{run_itr};
run_opts = define_run_opts(runset);

%% Get results from .mat file
load(['model_output_' runset '.mat'], 'parameters','outputs')

l_year = find(sum(outputs(nu_itr,alpha_itr,up_itr,eff_itr,:, :),6) > 0, 1,'last');
%tot_inf_prev(:,:,:,run_itr) = squeeze(sum(outputs(:,:,1,:,l_year, :),6)) - squeeze(sum(outputs(:,:,91,:,l_year, :),6));


%% Define parameters for use in plots
maxtime = 30*365;%length(outputs(1).uptake_str(1).nu_str(1).alpha_str(1).t);
%N = parameters(1).pop_vec;

% %% Get health econ outputs
% [tot_hosp_prev, tot_inf_prev, thresh_int_cost, tot_sev_prev, prop_hosp_prev, prop_inf_prev, prop_sev_prev] = health_econ_module(runset);
% 
% opt_up = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
% opt_thresh_cost = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
% thresh_diff_from_a0 = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
% R_0S = zeros(length(run_opts{1}),length(run_opts{2}));
% 
%  for nu_itr = 1:length(run_opts{1})
%     
% 
%     %R_0S(nu_itr,alpha_itr)=parameters(nu_itr,alpha_itr).beta(2)/parameters(nu_itr,alpha_itr).gamma(2);
% 
%     for eff_itr = 1:length(run_opts{4})
%         for alpha_itr = 1:length(run_opts{2})
%             x = 0:0.05:1;
%             TIC_interp = interp1(run_opts{3},squeeze(thresh_int_cost(nu_itr,alpha_itr, :,eff_itr)),x,'spline');
%             [M, I] = max(thresh_int_cost(nu_itr,alpha_itr, :,eff_itr));
%             %[N, J] = min(TIC_interp);
%             opt_up(nu_itr,alpha_itr,eff_itr) = run_opts{3}(I)*100;
%             if alpha_itr == 1
%                 opt_up_ind_alpha_0 = I;
%             end
%             opt_thresh_cost(nu_itr,alpha_itr,eff_itr) = M;
%             thresh_diff_from_a0(nu_itr,alpha_itr,eff_itr) = M-thresh_int_cost(nu_itr,alpha_itr,opt_up_ind_alpha_0,eff_itr);
%         end
%     end
%  end

[~, ~, thresh_int_cost, ~, ~, ~, ~, ~, ~, ~, ~] = health_econ_module(runset);

load(['opt_up_' runset '_dis.mat'], 'opt_up_array','TIC_comp_a0_array','TIC_opt_array')
opt_up = opt_up_array*100;
thresh_diff_from_a0 = TIC_opt_array - TIC_comp_a0_array;
thresh_diff_from_a0(:,1,:) = zeros(21,3);

for nu_itr = 1:length(run_opts{1})
    for alpha_itr = 1:length(run_opts{2})
        for eff_itr = 1:length(run_opts{4})

            if thresh_diff_from_a0(nu_itr,alpha_itr,eff_itr) < 0
                thresh_diff_from_a0(nu_itr,alpha_itr,eff_itr) = 0;
            end

        end
    end
end

% %% Heatmap of how the optimal uptake varies
% if run_itr == 1 
%     figure(1)
%     tlo = tlo1;
%     %ylabel(tlo,{'Seasonal Influenza'})
% elseif run_itr == 2
%     figure(2)
%     tlo = tlo2;
%     %ylabel(tlo,{'Pandemic Influenza'})
% elseif run_itr == 3
%     figure(3)
%     tlo = tlo3;
%     %ylabel(tlo,{'SARS-CoV-2'})
% end
% 
% for eff_itr = 1:length(run_opts{4})
%     nexttile(tlo)
%     hm = heatmap(squeeze(opt_up(:,:,eff_itr)),'Colormap', blue, 'ColorLimits', [0 100],'GridVisible','off','CellLabelColor','none');
% %         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
% %         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
%     hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
%     hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
%     hm.FontSize=8;
%     hm.NodeChildren(3).YDir='normal'; 
% 
%     ylabel('Baseline probability, \nu')
%     xlabel('Dependence on infector, \alpha')
%     title(sprintf('%d%%', run_opts{4}(eff_itr)*100))
%     s = struct(hm);
%     s.XAxis.TickLabelRotation = 0; 
% 
%     axs = struct(gca); %ignore warning that this should be avoided
%     cb = axs.Colorbar;
%     cb.TickLabels = {'0%','20%','40%','60%','80%','100%'};
% end
%    
% %ylabel(tlo,{'Symptom attenuating' ''})
% %ylabel(tlo,{'Infection blocking' ''})
% ylabel(tlo,{'Infection blocking' '(mild breakthrough infections)'})
% 
% title(tlo,'Efficacy')


m = max(thresh_int_cost(:,:,51,:),[],'all');


%% Heatmap showing TIC for 50% uptake
if run_itr == 1 
    figure(4)
    tlo = tlo4;
    CL = [0 1400];
    ylabel(tlo,{'Seasonal Influenza'})
elseif run_itr == 2
    figure(5)
    tlo = tlo5;
    CL = [0 1400];%[0 1000];%[0 1400];
    ylabel(tlo,{'Pandemic Influenza'})
elseif run_itr == 3
    figure(6)
    tlo = tlo6;
    CL = [0 9000];%[0 6000];
    ylabel(tlo,{'SARS-CoV-2'})
end

CL = [0 1];

for eff_itr = 1:length(run_opts{4})
    nexttile(tlo)

    hm = heatmap(thresh_int_cost(:,:, 51,eff_itr)./m,'Colormap', purple,'ColorLimits',CL,'GridVisible','off','CellLabelColor','none');
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
    hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
    hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
    hm.FontSize=8;
    hm.NodeChildren(3).YDir='normal'; 

    ylabel('Baseline probability, \nu')
    xlabel('Dependence on infector, \alpha')
    title(sprintf('%d%%', run_opts{4}(eff_itr)*100))
    s = struct(hm);
    s.XAxis.TickLabelRotation = 0; 

    axs = struct(gca); %ignore warning that this should be avoided
    cb = axs.Colorbar;
    %cb.Ruler.TickLabelFormat='£%g';

end

%ylabel(tlo,{'Symptom attenuating' ''})
%ylabel(tlo,{'Infection blocking' ''})
ylabel(tlo,{'Infection blocking' '(mild breakthrough infections)'})


title(tlo,'Efficacy')

% %% Heatmap showing cases prevented for 50% uptake
% if run_itr == 1 
%     figure(10)
%     tlo = tlo10;
%     CL = [0 0.6];
%     ylabel(tlo,{'Seasonal Influenza'})
% elseif run_itr == 2
%     figure(11)
%     tlo = tlo11;
%     CL = [0 0.3];%[0 1000];%[0 1400];
%     ylabel(tlo,{'Pandemic Influenza'})
% elseif run_itr == 3
%     figure(12)
%     tlo = tlo12;
%     CL = [0 0.3];%[0 6000];
%     ylabel(tlo,{'SARS-CoV-2'})
% end
% 
% 
% for eff_itr = 1:length(run_opts{4})
%     nexttile(tlo)
% 
%     hm = heatmap(tot_inf_prev(:,:,eff_itr,run_itr)./N,'Colormap', blue,'ColorLimits',[0 1],'GridVisible','off','CellLabelColor','none');
% %         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
% %         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
%     hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
%     hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
%     hm.FontSize=8;
%     hm.NodeChildren(3).YDir='normal'; 
% 
%     ylabel('Baseline probability, \nu')
%     xlabel('Dependence on infector, \alpha')
%     title(sprintf('%d%%', run_opts{4}(eff_itr)*100))
%     s = struct(hm);
%     s.XAxis.TickLabelRotation = 0; 
% 
%     axs = struct(gca); %ignore warning that this should be avoided
%     cb = axs.Colorbar;
%     cb.TickLabels = {'0%','20%','40%','60%','80%','100%'};
% 
% %     axs = struct(gca); %ignore warning that this should be avoided
% %     cb = axs.Colorbar;
% %     cb.TickLabels = {'1','10','100','1000','10000'};
% % 
% %     %
% %     set(gca,'ColorScaling','log')
% %     set(gca,'ColorLimits',[0 9.22])
% 
% end
% 
% ylabel(tlo,{'Symptom attenuating' ''})
% %ylabel(tlo,{'Infection blocking' ''})
% %ylabel(tlo,{'Infection blocking' '(mild breakthrough infections)'})
% 
% 
% title(tlo,'Efficacy')



%% Heatmap showing the difference between the maximum TIC and TIC for opt up when alpha=0
if run_itr == 1 
    figure(7)
    tlo = tlo7;
    CL = [0 500];
    %ylabel(tlo,{'Seasonal Influenza'})
elseif run_itr == 2
    figure(8)
    tlo = tlo8;
    CL = [0 50];
    %ylabel(tlo,{'Pandemic Influenza'})
elseif run_itr == 3
    figure(9)
    tlo = tlo9;
    CL = [0 500];%[0 2000];%[0 7500];
    %ylabel(tlo,{'SARS-CoV-2'})
end

CL = [0 0.5];
for eff_itr = 1:length(run_opts{4})
    nexttile(tlo)
    hm = heatmap(squeeze(thresh_diff_from_a0(:,:,eff_itr))./m,'Colormap', green,'ColorLimits',CL,'GridVisible','off','CellLabelColor','none');
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
    hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
    hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1'};
    hm.FontSize=8;
    hm.NodeChildren(3).YDir='normal'; 

    ylabel('Baseline probability, \nu')
    xlabel('Dependence on infector, \alpha')
    title(sprintf('%d%%', run_opts{4}(eff_itr)*100))
    s = struct(hm);
    s.XAxis.TickLabelRotation = 0; 

    axs = struct(gca); %ignore warning that this should be avoided
    cb = axs.Colorbar;
    %cb.TickLabels = {'£1','£10','£100','£1000','£10000'};

    %
%     set(gca,'ColorScaling','log')
%     set(gca,'ColorLimits',[0 9.22])
end
ylabel(tlo,{'Symptom attenuating' ''})
%ylabel(tlo,{'Infection blocking' ''})
%ylabel(tlo,{'Infection blocking' '(mild breakthrough infections)'})


title(tlo,'Efficacy')
end

