
%{
health_econ_module(runset)

A function that calculates the health economic outputs from the data set

Input:
- runset: The name of the chosen runset

Output:
- tot_hosp_prev: Total hospitalisations prevented
- tot_inf_prev: Total infections prevented
- thresh_int_cost: Threshold unit intervention cost
- tot_sev_prev: Total severe cases prevented
- prop_hosp_prev: Proportion of hospitalisations prevented
- prop_inf_prev: Proportion of infections prevented
- prop_sev_prev: Proportion of severe infections prevented
- QALYs_prev_dis: QALYs prevented (discounted)
- hosp_cost_prev_dis: Hospital costs prevented (discounted)
- QALYs_dis: Total QALYs (discounted)
- hosp_cost_dis: Total hospital costs (discounted)
%}
function [tot_hosp_prev, tot_inf_prev, thresh_int_cost, tot_sev_prev, prop_hosp_prev, prop_inf_prev, prop_sev_prev, QALYs_prev_dis, hosp_cost_prev_dis, QALYs_dis, hosp_cost_dis] = health_econ_module(runset)

%% Define parameter dependent health econ parameters
if strcmp(runset, 'sb_int_fix_a_v') || strcmp(runset,'isb_test_duration') || strcmp(runset, 'sb_int') || strcmp(runset, 'isb_test') || strcmp(runset, 'sb_int_find_opt_up_flu_3.0') || strcmp(runset, 'sb_int_find_opt_up_flu_1.5') || strcmp(runset, 'ib_int_find_opt_up_flu_3.0') || strcmp(runset, 'ib_int_find_opt_up_flu_1.5')|| strcmp(runset, 'ib_sev_int_find_opt_up_flu_3.0') || strcmp(runset, 'ib_sev_int_find_opt_up_flu_1.5')|| strcmp(runset, 'isb_int_find_opt_up_flu_3.0') || strcmp(runset, 'isb_int_find_opt_up_flu_1.5')|| strcmp(runset,'ib_int') ||strcmp(runset, 'ib_int_fix_a_v_flu_3')||strcmp(runset, 'ib_int_fix_a_v_flu_1.5')

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


elseif strcmp(runset, 'sb_int_fix_a_v_covid')|| strcmp(runset, 'sb_int_find_opt_up_cov_3.0')|| strcmp(runset, 'ib_sev_int_find_opt_up_cov_3.0')|| strcmp(runset, 'isb_int_find_opt_up_cov_3.0')|| strcmp(runset, 'ib_int_find_opt_up_cov_3.0')||strcmp(runset, 'ib_int_fix_a_v_cov_3')
    
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

%Willingness to pay per QALY
WTP_thresh = 20000;

%Discounting rate
dis_rate = 0.035;

%% Choose runset and get run_opts

%Get the run options for this runset
run_opts = define_run_opts(runset);

%% Get results from .mat file
load(['model_output_' runset '.mat'], 'parameters','outputs')

%Population size
N = parameters(1).pop_vec;

%Number of years the simulation ran for
num_years = size(outputs, 5);

%% Initialize arrays

tot_death = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
tot_death_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

tot_hosp = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
tot_hosp_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

tot_non_hosp = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
tot_non_hosp_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

tot_mild = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
tot_mild_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

prop_hosp_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
prop_inf_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
prop_sev_prev = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

for eff_itr = 1:length(run_opts{4})      
    for uptake_itr = 1:length(run_opts{3})
        for nu_itr = 1:length(run_opts{1})
            for alpha_itr = 1:length(run_opts{2})
                %para = parameters(nu_itr,alpha_itr);

                inf_array = squeeze(outputs(nu_itr, alpha_itr, uptake_itr,eff_itr, :, :));
                tot_death(nu_itr,alpha_itr,uptake_itr,eff_itr) = death_rate*inf_array(end,2);
                tot_hosp(nu_itr,alpha_itr,uptake_itr,eff_itr) = hosp_rate*inf_array(end,2);
                tot_non_hosp(nu_itr,alpha_itr,uptake_itr,eff_itr) = (1-hosp_rate)*inf_array(end,2);
                tot_mild(nu_itr,alpha_itr,uptake_itr,eff_itr) = inf_array(end,1);


%                 Classes = outputs(eff_itr).uptake_str(uptake_itr).nu_str(nu_itr).alpha_str(alpha_itr);
%                  
%                 if strcmp(runset,'intervention_2') 
%                     %In this case, those with intervention & severe have
%                     %QALY loss same as mild with prob eta i.e. run_opts{4}(eff_itr)
%                     tot_death(nu_itr,alpha_itr,uptake_itr,eff_itr) = death_rate*(Classes.R(end,1,2)+(1-run_opts{4}(eff_itr))*Classes.R(end,2,2));
%                     tot_hosp(nu_itr,alpha_itr,uptake_itr,eff_itr) = hosp_rate*(Classes.R(end,1,2)+(1-run_opts{4}(eff_itr))*Classes.R(end,2,2));
%                     tot_non_hosp(nu_itr,alpha_itr,uptake_itr,eff_itr) = (1-hosp_rate)*(Classes.R(end,1,2)+(1-run_opts{4}(eff_itr))*Classes.R(end,2,2));
%                     tot_mild(nu_itr,alpha_itr,uptake_itr,eff_itr) = Classes.R(end,1,1) + Classes.R(end,2,1) + run_opts{4}(eff_itr)*Classes.R(end,2,2);
%                 else
%                     tot_death(nu_itr,alpha_itr,uptake_itr,eff_itr) = death_rate*Classes.R(end,2);
%                     tot_hosp(nu_itr,alpha_itr,uptake_itr,eff_itr) = hosp_rate*Classes.R(end,2);
%                     tot_non_hosp(nu_itr,alpha_itr,uptake_itr,eff_itr) = (1-hosp_rate)*Classes.R(end,2);
%                     tot_mild(nu_itr,alpha_itr,uptake_itr,eff_itr) = Classes.R(end,1);
%                 end 
            end
        end

        
        if uptake_itr ~= 1
        % Subtract from baseline 
        tot_death_prev(:,:,uptake_itr,eff_itr)= tot_death(:,:,1,1) - tot_death(:,:,uptake_itr,eff_itr);

        tot_hosp_prev(:,:,uptake_itr,eff_itr)= tot_hosp(:,:,1,1) - tot_hosp(:,:,uptake_itr,eff_itr);
        prop_hosp_prev(:,:,uptake_itr,eff_itr) = tot_hosp_prev(:,:,uptake_itr,eff_itr)./tot_hosp(:,:,1,1);

        tot_non_hosp_prev(:,:,uptake_itr,eff_itr)= tot_non_hosp(:,:,1,1) - tot_non_hosp(:,:,uptake_itr,eff_itr);
        tot_mild_prev(:,:,uptake_itr,eff_itr)= tot_mild(:,:,1,1) - tot_mild(:,:,uptake_itr,eff_itr);
        end
    end
end

tot_sev = (tot_hosp+tot_non_hosp);
tot_sev_prev = tot_sev(:,:,1,1) - tot_sev;

tot_inf = tot_mild + tot_sev;
tot_inf_prev = tot_sev_prev + tot_mild_prev;

for eff_itr = 1:length(run_opts{4})      
    for uptake_itr = 1:length(run_opts{3})
        prop_inf_prev(:,:,uptake_itr,eff_itr) = tot_inf_prev(:,:,uptake_itr,eff_itr)./tot_inf(:,:,1,1);
        prop_sev_prev(:,:,uptake_itr,eff_itr) = tot_sev_prev(:,:,uptake_itr,eff_itr)./tot_sev(:,:,1,1);
    end
end




%% Calculate QALYs

QALYs_dis = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
QALYs_prev_dis = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

for eff_itr = 1:length(run_opts{4})      
    for nu_itr = 1:length(run_opts{1})
        for alpha_itr = 1:length(run_opts{2})
            for uptake_itr = 1:length(run_opts{3})

            inf_array = squeeze(outputs(nu_itr, alpha_itr, uptake_itr, eff_itr, :, :));

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

            %Apply discounting
            for y = 1:num_years
                QALYs_dis(nu_itr,alpha_itr,uptake_itr, eff_itr) = QALYs_dis(nu_itr,alpha_itr,uptake_itr, eff_itr) + QALYs(y)*(1/(1+dis_rate))^(y-1);
            end


            %Calculate QALYs gained compared to the baseline
            QALYs_prev_dis(nu_itr,alpha_itr,uptake_itr, eff_itr) = QALYs_dis(nu_itr,alpha_itr,1, eff_itr) - QALYs_dis(nu_itr,alpha_itr,uptake_itr, eff_itr);

            end
        end
    end
end

% % QALY losses prevented by the intervention
% death_QALY = death_QALY_loss*tot_death_prev;
% hosp_QALY = hosp_QALY_loss*(tot_hosp_prev-tot_death_prev);
% non_hosp_sev_QALY = non_hosp_sev_QALY_loss*tot_non_hosp_prev;
% mild_QALY = mild_QALY_loss*tot_mild_prev;
% 
% tot_QALY_gained = death_QALY + hosp_QALY + non_hosp_sev_QALY + mild_QALY;
% 
% tot_QALY = death_QALY_loss*tot_death + hosp_QALY_loss*(tot_hosp-tot_death) + non_hosp_sev_QALY_loss*tot_non_hosp + mild_QALY_loss*tot_mild;

%% Calcuate hospitalisation costs

hosp_cost_dis = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
hosp_cost_prev_dis = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));

for eff_itr = 1:length(run_opts{4})      
    for nu_itr = 1:length(run_opts{1})
        for alpha_itr = 1:length(run_opts{2})
            for uptake_itr = 1:length(run_opts{3})

            inf_array = squeeze(outputs(nu_itr, alpha_itr, uptake_itr, eff_itr, :, :));

            % Initialise array for storing hospital costs per year
            hosp_cost = zeros(num_years);
            
            % Calculate QALY losses for each year
            for y = 1:num_years
                if y == 1
                    hosp_cost(y) = hosp_fatal*death_rate*inf_array(y,2)+ hosp_non_fatal*(hosp_rate-death_rate)*inf_array(y,2);
                else
                    hosp_cost(y) = hosp_fatal*death_rate*(inf_array(y,2)-inf_array(y-1,2)) + hosp_non_fatal*(hosp_rate-death_rate)*(inf_array(y,2)-inf_array(y-1,2));
                end
            end

            %Apply discounting
            for y = 1:num_years
                hosp_cost_dis(nu_itr,alpha_itr,uptake_itr, eff_itr) = hosp_cost_dis(nu_itr,alpha_itr,uptake_itr, eff_itr) + hosp_cost(y)*(1/(1+dis_rate))^(y-1);
            end


            %Calculate QALYs gained compared to the baseline
            hosp_cost_prev_dis(nu_itr,alpha_itr,uptake_itr, eff_itr) = hosp_cost_dis(nu_itr,alpha_itr,1, eff_itr) - hosp_cost_dis(nu_itr,alpha_itr,uptake_itr, eff_itr);

            end
        end
    end
end


% % Hospitalisation costs prevented by the interventions
% hosp_cost = hosp_non_fatal*(tot_hosp-tot_death) + hosp_fatal*tot_death;
% hosp_cost_prev = hosp_non_fatal*(tot_hosp_prev-tot_death_prev) + hosp_fatal*tot_death_prev;


%% Calculate threshold intervention cost

thresh_int_cost = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{3}),length(run_opts{4}));
for eff_itr = 1:length(run_opts{4}) 
    
    for uptake_itr = 1:length(run_opts{3})

        thresh_int_cost(:,:,uptake_itr,eff_itr) = (WTP_thresh*QALYs_prev_dis(:,:,uptake_itr,eff_itr) + hosp_cost_prev_dis(:,:,uptake_itr,eff_itr))/(run_opts{3}(uptake_itr)*N);

    end
end
