%% Plotting results from interventions
tic
%% Define color maps
len = 20;
white = [1,1,1];
black = [0, 0, 0];

lRed = [1,1,1];%[255, 192, 203]/255;
mRed = [1, 0, 0];
dRed = [0.2, 0, 0];
colors_r1 = [linspace(lRed(1),mRed(1),len*2)', linspace(lRed(2),mRed(2),len*2)', linspace(lRed(3),mRed(3),len*2)'];
colors_r2 = [linspace(mRed(1),dRed(1),len*2)', linspace(mRed(2),dRed(2),len*2)', linspace(mRed(3),dRed(3),len*2)'];
colors_r = [colors_r1; colors_r2(2:end,:);];

lBlue = [193,244,255]/255;
mBlue = [50, 144,255]/255;
dBlue = [0,0,0.4];

colors_b1 = [linspace(white(1),lBlue(1),len/2)', linspace(white(2),lBlue(2),len/2)', linspace(white(3),lBlue(3),len/2)'];
colors_b2 = [linspace(lBlue(1),mBlue(1),len)', linspace(lBlue(2),mBlue(2),len)', linspace(lBlue(3),mBlue(3),len)'];
colors_b3 = [linspace(mBlue(1),dBlue(1),len*2)', linspace(mBlue(2),dBlue(2),len*2)', linspace(mBlue(3),dBlue(3),len*2)'];
colors_b = [colors_b1; colors_b2; colors_b3];

lGreen = [1,1,1];%[0.7, 1, 0.6];
mGreen = [0.5, 1, 0];
dGreen = [0.2, 0.4, 0];
colors_g1 = [linspace(lGreen(1),mGreen(1),len)', linspace(lGreen(2),mGreen(2),len)', linspace(lGreen(3),mGreen(3),len)'];
colors_g2 = [linspace(mGreen(1),dRed(1),len)', linspace(mGreen(2),dRed(2),len)', linspace(mGreen(3),dRed(3),len)'];
colors_g = [colors_g1; colors_g2(2:end,:)];

lPurple = [1,1,1];%[0.7, 1, 0.6];
mPurple = [0.6, 0.4, 0.85];
dPurple = [0.3, 0, 0.5];
colors_p1 = [linspace(lPurple(1),mPurple(1),len)', linspace(lPurple(2),mPurple(2),len)', linspace(lPurple(3),mPurple(3),len)'];
colors_p2 = [linspace(mPurple(1),dRed(1),len)', linspace(mPurple(2),dRed(2),len)', linspace(mPurple(3),dRed(3),len)'];
colors_p = [colors_p1; colors_p2(2:end,:)];

%Colours
green = [50,205,50]/255;
orange = {[255,230,0]/255,[255,185,15]/255,[255, 128,0]/255};
red = {[255,120,120]/255,[238,0,0]/255,[175,0,0]/255};
blue = {[153,204,255]/255,[50, 144,255]/255,[0,76,153]/255};

%Set the axis font size and line width for all graphs in this code
set(0,'defaultaxesfontsize',14)
set(0,'defaultlinelinewidth',2.5)


%% Set runset plotting for
%runset = 'sb_int';
%runset = 'sb_int_fix_a_v_covid';

%runset = 'sb_int_fix_a_v';
%runset = 'ib_int';
%runset = 'ib_int_fix_a_v_flu_1.5';
%runset = 'ib_int_fix_a_v_flu_3';
%runset = 'ib_int_fix_a_v_cov_3';

%runset = 'ib_int_find_opt_up_flu_1.5';
%runset = 'ib_int_find_opt_up_flu_3.0';
%runset = 'ib_int_find_opt_up_cov_3.0';
run_opts = define_run_opts(runset);

%% Get results from .mat file
load(['model_output_' runset '.mat'], 'parameters','outputs')

%% Define parameters for use in plots
maxtime = length(outputs(1).uptake_str(1).nu_str(1).alpha_str(1).t);
N = parameters(1).pop_vec;

%% Get health econ outputs


[tot_hosp_prev, tot_inf_prev, thresh_int_cost, tot_sev_prev, prop_hosp_prev, prop_inf_prev, prop_sev_prev] = health_econ_module(runset);

if strcmp(runset,'sb_int_fix_a_v') || strcmp(runset,'sb_int_fix_a_v_covid') || strcmp(runset,'ib_int_fix_a_v_flu_1.5')|| strcmp(runset,'ib_int_fix_a_v_flu_3')|| strcmp(runset,'ib_int_fix_a_v_cov_3') || strcmp(runset, 'ib_int_find_opt_up_flu_1.5') || strcmp(runset, 'ib_int_find_opt_up_flu_3.0')|| strcmp(runset,'ib_int_find_opt_up_cov_3.0')
blue = {[193,244,255]/255,[153,204,255]/255,[50, 144,255]/255,[0,76,153]/255,[0,0,0]/255};
purple = {colors_p(10,:),colors_p(15,:),colors_p(20,:),colors_p(25,:),colors_p(35,:)};
grey = {[212,212,212]./255, [180,180,180]./255, [120,120,120]./255, [72,72,72]./255, [32,32,32]./255};
green = {[191,255,41]./255, [147, 211, 63]./255, [80, 165,72]./255, [28,117,68]./255, [2, 71,52]./255};
red = {colors_r(10,:),colors_r(15,:),colors_r(20,:),colors_r(25,:),colors_r(35,:)};

set(0,'defaultaxesfontsize',10)

%% Plotting how the optimal uptake varies with the efficacy
% figure(1)
% %set(gcf,'units','inch','position',[0,0,8,3])
% tlo = tiledlayout(2,3);
% opt_up = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
% 
% for nu_itr = 1:length(run_opts{1})
%     nexttile(tlo)
%     for alpha_itr = 1:length(run_opts{2})
%         for eff_itr = 1:length(run_opts{4})
%             [M, I] = max(thresh_int_cost(nu_itr,alpha_itr, :,eff_itr));
%             opt_up(nu_itr,alpha_itr,eff_itr) = run_opts{3}(I)*100;
%         end
%         plot(run_opts{4}(2:end)*100,squeeze(opt_up(nu_itr,alpha_itr,2:end)),'Color', blue{6-alpha_itr})
%         hold on
%     end
%     xlabel('Efficacy','FontSize',14)
%     ylabel('Uptake','FontSize',14)
%     xtickformat('percentage')
%     ytickformat('percentage')
%     ylim([0 100])
%     title(sprintf('\\nu = %.1f', parameters(nu_itr,alpha_itr).nu(2)),'FontWeight','Normal','FontSize',16)
% end
% 
% legend('\alpha = 0.0','\alpha = 0.2','\alpha = 0.5','\alpha = 0.8','\alpha = 1.0','Orientation','horizontal')

% figure(2)
% tlo = tiledlayout(4,3);
% % title(tlo,'Global title')
% % ylabel(tlo, 'Threshold intervention cost')
% % xlabel(tlo, 'Uptake')
% 
% for eff_itr = [26,51,76,101]
%     for nu_itr = 1:length(run_opts{1})
%         nexttile(tlo)
%         for alpha_itr = length(run_opts{2}):-1:1
%             plot(run_opts{3}*100,squeeze(thresh_int_cost(nu_itr,alpha_itr,:,eff_itr)),'Color', purple{6-alpha_itr})
%             hold on
%         end
%         %ylim([0 1500])
%         xtickformat('percentage')
%          ytickformat('£%,.0f')
%         xlabel('Uptake','FontSize',10)
%         ylabel('Threshold intervention cost','FontSize',10)
%     end
% end
% %[0,0.25,0.5,0.75,1]
% %legend('\alpha=1.0','\alpha=0.75','\alpha=0.5','\alpha=0.25','\alpha=0.0','Orientation','horizontal')
% legend('\alpha=0.0','\alpha=0.25','\alpha=0.5','\alpha=0.75','\alpha=1.0','Orientation','horizontal')

%% Total infections prevented against uptake
figure(3)
set(gcf,'units','inch','position',[0,0,10,10])
tlo = tiledlayout(5,3);
% title(tlo,'Global title')
% ylabel(tlo, 'Threshold intervention cost')
% xlabel(tlo, 'Uptake')

% Find indicies for the required efficacy percentages
eff_opts = 1:4;
%[0.25,0.5,0.7,0.9]*(length(run_opts{4})-1) + 1; 
for alpha_itr = 1:length(run_opts{2})
    for nu_itr = 1:length(run_opts{1})
        nexttile(tlo)
        for eff_itr = 1:4
            plot(run_opts{3}*100,squeeze(tot_inf_prev(nu_itr,alpha_itr,:,eff_opts(eff_itr))),'Color', blue{eff_itr})
            hold on
        end
%         if alpha_itr ==2
%             ylim([0 350])
%         elseif alpha_itr == 3
%             ylim([0 600])
%         elseif alpha_itr == 4
%             ylim([0 900])
%         end
        xtickformat('percentage')

        if nu_itr == 1
        ylabel("\alpha = " + run_opts{2}(alpha_itr),'fontweight','bold','fontsize',14)
        end
        if alpha_itr == 1
        title("\nu = " + run_opts{1}(nu_itr),'fontweight','bold','fontsize',14)
        end

        if alpha_itr == 5 && nu_itr == 2
            xlabel('Uptake', 'fontsize', 16)
            legend('Efficacy 25%','Efficacy 50%','Efficacy 70%','Efficacy 90%','Orientation','horizontal','FontSize',12, 'Location', 'southoutside')
        end
    end
end


ylabel(tlo,'Proportion of infections prevented', 'fontsize', 16)




if strcmp(runset, 'ib_int_find_opt_up_flu_1.5') || strcmp(runset, 'ib_int_find_opt_up_flu_3.0') || strcmp( runset, 'ib_int_find_opt_up_cov_3.0')

    %% Threshold intervention cost against uptake
    figure(4)
    set(gcf,'units','inch','position',[0,0,10,10])
    tlo = tiledlayout(5,3, 'TileSpacing','compact');
    
    % Find indicies for the required efficacy percentages
    eff_opts = 1:4;%[0.25,0.5,0.7,0.9]*(length(run_opts{4})-1) + 1; 
    for alpha_itr = [1,5,11,17,21]
        for nu_itr = [5,11,17]
            nexttile(tlo)
            for eff_itr = 1:3
                plot(run_opts{3}*100,squeeze(thresh_int_cost(nu_itr,alpha_itr,:,eff_opts(eff_itr))),'Color', green{eff_itr})
                hold on
            end
    
            %ylim([0 1250])
            %ylim([0 1800])
    
            title(tlo, 'Influenza like parameters and health economic values (R_0 = 1.5)')
    
            xtickformat('percentage')
            ytickformat('£%,.0f')
    
            if nu_itr == 5
            ylabel("\alpha = " + run_opts{2}(alpha_itr),'fontweight','bold','fontsize',14)
            end
            if alpha_itr == 1
            title("\nu = " + run_opts{1}(nu_itr),'fontweight','bold','fontsize',14)
            end
    
            if alpha_itr == 21 && nu_itr == 11
                xlabel('Uptake', 'fontsize', 16)
                legend('Efficacy 25%','Efficacy 50%','Efficacy 70%','Efficacy 90%','Orientation','horizontal','FontSize',12, 'Location', 'southoutside')
            end
        end
    end
    
    ylabel(tlo,'Threshold intervention cost', 'fontsize', 16)

    %% Threshold intervention cost against uptake
    figure(5)
    set(gcf,'units','inch','position',[0,0,10,10])
    tlo5 = tiledlayout(5,3, 'TileSpacing','compact');
    
    % Find indicies for the required efficacy percentages
    eff_opts = 1:4;%[0.25,0.5,0.7,0.9]*(length(run_opts{4})-1) + 1; 
    for alpha_itr = [1,5,11,17,21]
        for nu_itr = [5,11,17]
            nexttile(tlo5)
            for eff_itr = 1:3
                plot(run_opts{3}*100,squeeze(tot_inf_prev(nu_itr,alpha_itr,:,eff_opts(eff_itr))),'Color', green{eff_itr})
                hold on
            end
    
            %ylim([0 1250])
            %ylim([0 1800])
    
            title(tlo, 'Influenza like parameters and health economic values (R_0 = 1.5)')
    
            xtickformat('percentage')
            ytickformat('£%,.0f')
    
            if nu_itr == 5
            ylabel("\alpha = " + run_opts{2}(alpha_itr),'fontweight','bold','fontsize',14)
            end
            if alpha_itr == 1
            title("\nu = " + run_opts{1}(nu_itr),'fontweight','bold','fontsize',14)
            end
    
            if alpha_itr == 21 && nu_itr == 11
                xlabel('Uptake', 'fontsize', 16)
                legend('Efficacy 25%','Efficacy 50%','Efficacy 70%','Efficacy 90%','Orientation','horizontal','FontSize',12, 'Location', 'southoutside')
            end
        end
    end
    
    ylabel(tlo5,'Infections prevented', 'fontsize', 16)

else
    %% Threshold intervention cost against uptake
figure(4)
set(gcf,'units','inch','position',[0,0,10,10])
tlo = tiledlayout(5,3, 'TileSpacing','compact');

% Find indicies for the required efficacy percentages
eff_opts = 1:4;%[0.25,0.5,0.7,0.9]*(length(run_opts{4})-1) + 1; 
for alpha_itr = 1:length(run_opts{2})
    for nu_itr = 1:length(run_opts{1})
        nexttile(tlo)
        for eff_itr = 1:4
            plot(run_opts{3}*100,squeeze(thresh_int_cost(nu_itr,alpha_itr,:,eff_opts(eff_itr))),'Color', green{eff_itr})
            hold on
        end

        if strcmp(runset,'sb_int_fix_a_v_covid')
%             if alpha_itr == 1
%                 ylim([0 4500])
%             elseif alpha_itr == 2
%                 ylim([0 4500])
%             elseif alpha_itr == 3
%                 ylim([0 5500])
%             elseif alpha_itr == 4
%                 ylim([0 6500])
%             elseif alpha_itr == 5
%                 ylim([0 7000])
%             end
%             title(tlo, 'SARS-CoV-2 like parameters and health economic values')

            if alpha_itr == 1
                ylim([0 800])
            elseif alpha_itr == 2
                ylim([0 900])
            elseif alpha_itr == 3
                ylim([0 1100])
            elseif alpha_itr == 4
                ylim([0 1200])
            elseif alpha_itr == 5
                ylim([0 1400])
            end
            title(tlo, 'SARS-CoV-2 like parameters and Influenza health economic values')
        elseif strcmp(runset,'sb_int_fix_a_v')
%             if alpha_itr == 1
%                 ylim([0 250])
%             elseif alpha_itr == 2
%                 ylim([0 350])
%             elseif alpha_itr == 3
%                 ylim([0 600])
%             elseif alpha_itr == 4
%                 ylim([0 900])
%             elseif alpha_itr == 5
%                 ylim([0 1500])
%             end
%             title(tlo, 'Influenza like parameters and health economic values (R_0 = 3)')
%             if alpha_itr == 1
%                 ylim([0 900])
%             elseif alpha_itr == 2
%                 ylim([0 900])
%             elseif alpha_itr == 3
%                 ylim([0 1000])
%             elseif alpha_itr == 4
%                 ylim([0 1000])
%             elseif alpha_itr == 5
%                 ylim([0 1000])
%             end
%             title(tlo, 'Influenza like parameters and health economic values (R_0 = 1.1)')

            if alpha_itr == 1
                ylim([0 650])
            elseif alpha_itr == 2
                ylim([0 800])
            elseif alpha_itr == 3
                ylim([0 1100])
            elseif alpha_itr == 4
                ylim([0 1500])
            elseif alpha_itr == 5
                ylim([0 2000])
            end
            title(tlo, 'Influenza like parameters and health economic values (R_0 = 2.0)')
        elseif strcmp(runset,'ib_int_fix_a_v_flu_3')
            ylim([0 1250])
            title(tlo, 'Influenza like parameters and health economic values (R_0 = 3.0)')
        elseif strcmp(runset,'ib_int_fix_a_v_flu_1.5')
            ylim([0 1800])
            title(tlo, 'Influenza like parameters and health economic values (R_0 = 1.5)')
        elseif strcmp(runset,'ib_int_fix_a_v_cov_3')
            ylim([0 7000])
            title(tlo, 'SARS-CoV-2 like parameters and health economic values (R_0 = 3.0)')

        end
        xtickformat('percentage')
        ytickformat('£%,.0f')

        if nu_itr == 1
        ylabel("\alpha = " + run_opts{2}(alpha_itr),'fontweight','bold','fontsize',14)
        end
        if alpha_itr == 1
        title("\nu = " + run_opts{1}(nu_itr),'fontweight','bold','fontsize',14)
        end

        if alpha_itr == 5 && nu_itr == 2
            xlabel('Uptake', 'fontsize', 16)
            legend('Efficacy 25%','Efficacy 50%','Efficacy 70%','Efficacy 90%','Orientation','horizontal','FontSize',12, 'Location', 'southoutside')
        end
    end
end

ylabel(tlo,'Threshold intervention cost', 'fontsize', 16)
end



% % Proportion of severe infections prevented against uptake
% figure(5)
% set(gcf,'units','inch','position',[0,0,10,10])
% tlo = tiledlayout(5,3);
% % title(tlo,'Global title')
% % ylabel(tlo, 'Threshold intervention cost')
% % xlabel(tlo, 'Uptake')
% 
% % Find indicies for the required efficacy percentages
% eff_opts = 1:4;%[0.25,0.5,0.7,0.9]*(length(run_opts{4})-1) + 1; 
% for alpha_itr = 1:length(run_opts{2})
%     for nu_itr = 1:length(run_opts{1})
%         nexttile(tlo)
%         for eff_itr = 1:4
%             plot(run_opts{3}*100,squeeze(prop_sev_prev(nu_itr,alpha_itr,:,eff_opts(eff_itr))),'Color', red{eff_itr})
%             hold on
%         end
% %         if alpha_itr ==2
% %             ylim([0 350])
% %         elseif alpha_itr == 3
% %             ylim([0 600])
% %         elseif alpha_itr == 4
% %             ylim([0 900])
% %         end
%         xtickformat('percentage')
% 
%         if nu_itr == 1
%         ylabel("\alpha = " + run_opts{2}(alpha_itr),'fontweight','bold','fontsize',14)
%         end
%         if alpha_itr == 1
%         title("\nu = " + run_opts{1}(nu_itr),'fontweight','bold','fontsize',14)
%         end
% 
%         if alpha_itr == 5 && nu_itr == 2
%             xlabel('Uptake', 'fontsize', 16)
%             legend('Efficacy 25%','Efficacy 50%','Efficacy 70%','Efficacy 90%','Orientation','horizontal','FontSize',12, 'Location', 'southoutside')
%         end
%     end
% end
% 
% 
% ylabel(tlo,'Proportion of severe infections prevented', 'fontsize', 16)
% 
















elseif strcmp(runset,'sb_int') || strcmp(runset, 'ib_int')

%% Initialise figures
figure(1)
set(gcf,'units','inch','position',[0,0,11,8])
tlo1 = tiledlayout(4,4);
tlo1.TileSpacing = 'tight';

figure(2)
set(gcf,'units','inch','position',[0,0,11,8])
tlo2 = tiledlayout(4,4);
tlo2.TileSpacing = 'tight';

figure(3)
set(gcf,'units','inch','position',[0,0,11,8])
tlo3 = tiledlayout(4,4);
tlo3.TileSpacing = 'tight';

figure(4)
set(gcf,'units','inch','position',[0,0,11,8])
tlo4 = tiledlayout(4,4);

%% Plot heatmaps
for eff_itr = 1:length(run_opts{4})      
    for uptake_itr = 2:length(run_opts{3})  
        %% Proportion heatmaps
%         subplot_itr = uptake_itr+length(run_opts{3})*(eff_itr-1);

        prop = 0;
        if prop == 1
        figure(1)
        nexttile(tlo1); % Get axis handle 
        hm=heatmap(squeeze(prop_inf_prev(:,:,uptake_itr,eff_itr)),'Colormap', colors_b, 'ColorLimits', [0 1],'GridVisible','off');
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  
        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 

        axs = struct(gca); %ignore warning that this should be avoided
        cb = axs.Colorbar;
        cb.TickLabels = {'0%','20%','40%','60%','80%','100%'};

        figure(2)
        nexttile(tlo2); % Get axis handle 
        hm=heatmap(squeeze(prop_sev_prev(:,:,uptake_itr,eff_itr)),'Colormap', colors_r, 'ColorLimits', [0 1],'GridVisible','off');
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  
 
        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 

        axs = struct(gca); %ignore warning that this should be avoided
        cb = axs.Colorbar;
        cb.TickLabels = {'0%','20%','40%','60%','80%','100%'};
        
        figure(3)
        nexttile(tlo3); % Get axis handle 
        hm=heatmap(squeeze(prop_hosp_prev(:,:,uptake_itr,eff_itr)),'Colormap', colors_g, 'ColorLimits', [0 1],'GridVisible','off');

%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  

        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 
        axs = struct(gca); %ignore warning that this should be avoided
        cb = axs.Colorbar;
        cb.TickLabels = {'0%','20%','40%','60%','80%','100%'};


        else
      
        figure(1)
        nexttile(tlo1); % Get axis handle 
        hm=heatmap(squeeze(tot_inf_prev(:,:,uptake_itr,eff_itr)./N),'Colormap', colors_b,'ColorLimits', [0 1],'GridVisible','off');
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  
 
        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        %xlabel(sprintf('u=%.1f, eff = %.1f', up_itr))
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 

        figure(2)
        nexttile(tlo2); % Get axis handle 
        hm=heatmap(squeeze(tot_sev_prev(:,:,uptake_itr,eff_itr)./N),'Colormap', colors_r,'ColorLimits', [0 1], 'GridVisible','off');
%         hm.XDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
%         hm.YDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
%         hm.XDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1.0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','0.5','','','','','','','','','','1.0'};
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  

        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 
        
        figure(3)
        nexttile(tlo3); % Get axis handle 
        hm=heatmap(squeeze(tot_hosp_prev(:,:,uptake_itr,eff_itr)./N),'Colormap', colors_g, 'ColorLimits', [0 0.01],'GridVisible','off');
%         hm.XDisplayLabels = {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'};
%         hm.YDisplayLabels = {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'};
%         hm.XDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
%         hm.YDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
%         hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
%         hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  

        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 

        end

        figure(4)
        nexttile(tlo4); % Get axis handle 
        hm=heatmap(squeeze(thresh_int_cost(:,:,uptake_itr,eff_itr)),'Colormap', colors_p,'GridVisible','off');%,'ColorLimits',[0 1600]);
%         hm.XDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
%         hm.YDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
        %hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
        %hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
        hm.FontSize=8;
        hm.NodeChildren(3).YDir='normal';  
 
        
        axs = struct(gca); %ignore warning that this should be avoided
        cb = axs.Colorbar;
        %cb.TickLabels = {'£0','£500','£1000','£1500'};
        
        ylabel('Baseline probability, \nu')
        xlabel('Dependence on infector, \alpha')
        s = struct(hm);
        s.XAxis.TickLabelRotation = 0; 

        if eff_itr == 4
            if uptake_itr == 1
                figure(5)
                tlo5 = tiledlayout(1,1);
                hm=heatmap(squeeze(thresh_int_cost(:,:,uptake_itr,eff_itr)),'Colormap', colors_p,'ColorLimits',[0 1600],'GridVisible','off');
        %         hm.XDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
        %         hm.YDisplayLabels = {'0','','','','','0.5','','','','','1.0'};
                %hm.XDisplayLabels = {'1','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','0'};
                %hm.YDisplayLabels = {'0','','','','','','','','','','','','','','','','','','','','','','','','','0.5','','','','','','','','','','','','','','','','','','','','','','','','','1'};
                hm.FontSize=8;
                hm.NodeChildren(3).YDir='normal';  
                 
                
                axs = struct(gca); %ignore warning that this should be avoided
                cb = axs.Colorbar;
                %cb.TickLabels = {'£0','£500','£1000','£1500'};
                
                ylabel('Baseline probability, \nu')
                xlabel('Dependence on infector, \alpha')
                s = struct(hm);
                s.XAxis.TickLabelRotation = 0; 
            end
        end
    end
    
end

figure(1)
title(tlo1,'  Uptake 25%                       Uptake 50%                       Uptake 70%                       Uptake 90%')
ylabel(tlo1,'  Efficacy 90%            Efficacy 70%            Efficacy 50%            Efficacy 25%')

figure(2)
title(tlo2,'  Uptake 25%                       Uptake 50%                       Uptake 70%                       Uptake 90%')
ylabel(tlo2,'  Efficacy 90%            Efficacy 70%            Efficacy 50%            Efficacy 25%')

figure(3)
title(tlo3,'  Uptake 25%                       Uptake 50%                       Uptake 70%                       Uptake 90%')
ylabel(tlo3,'  Efficacy 90%            Efficacy 70%            Efficacy 50%            Efficacy 25%')

figure(4)
title(tlo4,'  Uptake 25%                       Uptake 50%                       Uptake 70%                       Uptake 90%')
ylabel(tlo4,'  Efficacy 90%            Efficacy 70%            Efficacy 50%            Efficacy 25%')
toc
end
