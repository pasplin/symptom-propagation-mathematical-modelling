
function find_opt_up(job_ID)

tic

%% Set the runset for the model

runsets = {'sb_int_find_opt_up_flu_1.5','sb_int_find_opt_up_flu_3.0','sb_int_find_opt_up_cov_3.0', 'ib_int_find_opt_up_flu_1.5','ib_int_find_opt_up_flu_3.0','ib_int_find_opt_up_cov_3.0', 'isb_int_find_opt_up_flu_1.5','isb_int_find_opt_up_flu_3.0','isb_int_find_opt_up_cov_3.0'};

runset = runsets{job_ID};

if strcmp(runset, 'sb_int_find_opt_up_flu_1.5')||strcmp(runset, 'sb_int_find_opt_up_flu_3.0')||strcmp(runset, 'sb_int_find_opt_up_cov_3.0')
    int = "sb";
elseif strcmp(runset, 'ib_int_find_opt_up_flu_1.5')||strcmp(runset, 'ib_int_find_opt_up_flu_3.0')||strcmp(runset, 'ib_int_find_opt_up_cov_3.0')
    int = "ib";
elseif strcmp(runset, 'isb_int_find_opt_up_flu_1.5')||strcmp(runset, 'isb_int_find_opt_up_flu_3.0')||strcmp(runset, 'isb_int_find_opt_up_cov_3.0')
    int = "isb";
elseif strcmp(runset, 'isb_test_duration')
    int = "isb";
end

%Get parameter options for the runset used
run_opts = define_run_opts(runset);

load(['model_output_' runset '.mat'], 'parameters','outputs', 'duration')

%Population size
N = parameters(1).pop_vec;

%Set the number of symptom severity levels 
n_severity = 2;

%Set the number of age classes
n_age_class = 1;

num_years = 100;

%Define time to run model for (in days)
maxtime = num_years*365;

%Set the severity of the initial case
init_sev = 1:n_severity; %Sets an initial case in each of the severity levels

%% Health Econ parameters 
if strcmp(runset, 'sb_int_fix_a_v') || strcmp(runset,'isb_test_duration') || strcmp(runset, 'sb_int') || strcmp(runset, 'isb_test') || strcmp(runset, 'sb_int_find_opt_up_flu_3.0') || strcmp(runset, 'sb_int_find_opt_up_flu_1.5') || strcmp(runset, 'ib_int_find_opt_up_flu_3.0') || strcmp(runset, 'ib_int_find_opt_up_flu_1.5')|| strcmp(runset, 'isb_int_find_opt_up_flu_3.0') || strcmp(runset, 'isb_int_find_opt_up_flu_1.5')|| strcmp(runset,'ib_int') ||strcmp(runset, 'ib_int_fix_a_v_flu_3')||strcmp(runset, 'ib_int_fix_a_v_flu_1.5')

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


elseif strcmp(runset, 'sb_int_fix_a_v_covid')|| strcmp(runset, 'sb_int_find_opt_up_cov_3.0')|| strcmp(runset, 'isb_int_find_opt_up_cov_3.0')|| strcmp(runset, 'ib_int_find_opt_up_cov_3.0')||strcmp(runset, 'ib_int_fix_a_v_cov_3')
    
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

[~, ~, thresh_int_cost, ~, ~, ~, ~, ~, ~, QALYs_dis, hosp_cost_dis] = health_econ_module(runset);

opt_up_array = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
dur_array = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
TIC_opt_array = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
TIC_comp_a0_array = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
QALY_array = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));
cost_array = zeros(length(run_opts{1}),length(run_opts{2}),length(run_opts{4}));

%% Find most cost-effective uptake to 0.1%
for eff_itr = 1:length(run_opts{4})      
    for nu_itr = 1:length(run_opts{1})
        nu = run_opts{1}(nu_itr);
        %Define a struct array for the runset parameters
        [para] = define_parameters(runset,n_severity,n_age_class, nu);
        
        
        for alpha_itr = 1:length(run_opts{2})
            para(alpha_itr).eta = run_opts{4}(eff_itr);
            
            %% Find optimal uptake

            [M, I] = max(squeeze(thresh_int_cost(nu_itr,alpha_itr, :,eff_itr)));
            dur_opt = duration(nu_itr,alpha_itr,I,eff_itr);

            opt_up = run_opts{3}(I);

            TIC = M;

            %% Test 0.1% increments above current most cost-effective uptake

            u = opt_up; 

            while u < 1
                u = opt_up + 0.001;
                [TIC_tmp, dur_tmp] = Find_TIC(u, QALYs_dis(nu_itr,alpha_itr,1,eff_itr), hosp_cost_dis(nu_itr,alpha_itr,1,eff_itr));

                if TIC_tmp > TIC
                    opt_up = u;
                    dur_opt = dur_tmp;
                    TIC = TIC_tmp;
                else
                    break
                end
            end

            if opt_up == run_opts{3}(I)
            while u > 0
                u = opt_up - 0.001;
                [TIC_tmp, dur_tmp] = Find_TIC(u, QALYs_dis(nu_itr,alpha_itr,1,eff_itr), hosp_cost_dis(nu_itr,alpha_itr,1,eff_itr));

                %% Test 0.1% increments below current most cost-effective uptake
                if TIC_tmp > TIC
                    opt_up = u;
                    dur_opt = dur_tmp;
                    TIC = TIC_tmp;
                else
                    break
                end
            end
            end

           
            opt_up_array(nu_itr,alpha_itr,eff_itr) = opt_up;
            dur_array(nu_itr,alpha_itr, eff_itr) = dur_opt;
    
            %% Rerun code to get QALYs and costs?
            TIC_opt_array(nu_itr,alpha_itr,eff_itr) = TIC;

            [~, ~, QALYs_dis_new, hosp_cost_dis_new] = Find_TIC(opt_up, QALYs_dis(nu_itr,alpha_itr,1,eff_itr), hosp_cost_dis(nu_itr,alpha_itr,1,eff_itr));

            QALY_array(nu_itr,alpha_itr,eff_itr) = QALYs_dis_new;
            cost_array(nu_itr,alpha_itr,eff_itr) = hosp_cost_dis_new;

            if alpha_itr ~= 1
                [TIC_tmp] = Find_TIC(opt_up_array(nu_itr,1,eff_itr), QALYs_dis(nu_itr,alpha_itr,1,eff_itr), hosp_cost_dis(nu_itr,alpha_itr,1,eff_itr));
                TIC_comp_a0_array(nu_itr,alpha_itr,eff_itr) = TIC_tmp;
            end

        end
    end
end

function [TIC_tmp, dur_tmp, QALYs_dis_new, hosp_cost_dis_new] = Find_TIC(u, QALYs_base, hosp_cost_base)

    %Define a struct containing the initial conditions
    [ICs] = define_ICs(para, init_sev);
    para(alpha_itr).u = u;

    ICs.V = ICs.S*para(alpha_itr).u;
    ICs.S = ICs.S - ICs.V;

    
    inf_array = zeros(num_years, 2);

    if int == "ib"
        [Classes] = ODE_SEIR_model_ib_int(para(alpha_itr),ICs,maxtime);

        for year = 1:num_years
            if year*365 < length(Classes.t)
                inf_array(year, :) = Classes.R(year*365,:,:);
            else %If the simulation has ended by that year, take the value at the end of the simulation
                inf_array(year, :) = Classes.R(end,:,:);
            end
        end
    elseif int == "isb"
        [Classes] = ODE_SEIR_model_isb_int(para(alpha_itr),ICs,maxtime);

        for year = 1:num_years
            if year*365 < length(Classes.t)
                inf_array(year, :) = Classes.R(year*365,:);
            else %If the simulation has ended by that year, take the value at the end of the simulation
                inf_array(year, :) = Classes.R(end,:);
            end
        end
    elseif int == "sb"
        [Classes] = ODE_SEIR_model_sb_int(para(alpha_itr),ICs,maxtime);

        for year = 1:num_years
            if year*365 < length(Classes.t)
                inf_array(year, :) = Classes.R(year*365,:);
            else %If the simulation has ended by that year, take the value at the end of the simulation
                inf_array(year, :) = Classes.R(end,:);
            end
        end
    end

    dur_tmp = length(Classes.t);
     

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
    QALYs_prev_dis = - QALYs_dis_new + QALYs_base;


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


    %Calculate QALYs gained compared to the baseline
    hosp_cost_prev_dis = - hosp_cost_dis_new + hosp_cost_base;

    

    %% Calculate TIC 
    TIC_tmp = (WTP_thresh*QALYs_prev_dis + hosp_cost_prev_dis)/(u*N);

end

filename = ['opt_up_' runset '_dis.mat'];
save(filename, 'opt_up_array', 'dur_array','QALY_array','cost_array','TIC_opt_array','TIC_comp_a0_array')

end



        