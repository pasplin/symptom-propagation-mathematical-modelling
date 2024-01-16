%% Script for running ODE model with interventions 
% Here nu is chosen to fix the proportion of cases that are severe
% If wanting to generate data for all intervention options and parameter
% sets, run as:
% for ii = 1:3
%     for jj = 1:3
%         Run_model_fix_prop_sev(ii,jj)
%     end
% end

% Generates data for figs 5,7,8,S5-S9

function Run_model_fix_prop_sev(int_itr,param_itr)

tic

int_opts = {'sb', 'ib', 'isb', 'ib_sev'};
param_opts = {'sFlu','pFlu','cov'};

runset = [int_opts{int_itr} '_fix_prop_sev_' param_opts{param_itr}];

%Get parameter options for the runset used
run_opts = define_run_opts(runset);

%Set the number of symptom severity levels 
n_severity = 2;

%Set the number of age classes
n_age_class = 1;

num_years = 100;

%Define time to run model for (in days)
maxtime = num_years*365;

%Set the severity of the initial case
init_sev = 1:n_severity; %Sets an initial case in each of the severity levels

%Set up output array
S = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365);
V = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365);

I = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365, n_severity);
R = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365, n_severity);


%duration = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}));

for alpha_itr = 1:length(run_opts{2}) 
    nu_itr = 1;

    nu = run_opts{1}(alpha_itr);
    
    %Define a struct array for the runset parameters
    [para] = define_parameters(runset,n_severity,n_age_class, nu);
    

   
    %% Run model for each runset option
        for eff_itr = 1:length(run_opts{4})
            for uptake_itr = 1:length(run_opts{3})

                para(alpha_itr).eta = run_opts{4}(eff_itr);
                para(alpha_itr).u = run_opts{3}(uptake_itr);

                %Define a struct containing the initial conditions
                [ICs] = define_ICs(para, init_sev);

                ICs.V = ICs.S*para(alpha_itr).u;
                ICs.S = ICs.S - ICs.V;

                if contains(runset, 'isb')
                    [Classes] = ODE_SEIR_model_isb_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;

                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;
                elseif contains(runset, 'sb')
                    [Classes] = ODE_SEIR_model_sb_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;
                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;
                
                elseif contains(runset, 'ib')
                    [Classes] = ODE_SEIR_model_ib_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;

                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;

                elseif contains(runset, 'ib_sev')
                    [Classes] = ODE_SEIR_model_ib_sev_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;

                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;

                end
                

                %duration(nu_itr, alpha_itr, uptake_itr,eff_itr) = length(Classes.t);

                
            end
        end
                %eff_str(eff_itr).uptake_str(uptake_itr).nu_str(nu_itr).alpha_str(alpha_itr) = Classes_end;
                %outputs = eff_str;
                parameters(nu_itr,alpha_itr) = para(alpha_itr);
            
end
   
%% Save parameters and outputs to results file for plots

filename = ['model_output_' runset '.mat'];
save(filename, 'parameters','S','V', 'I', 'R')

toc

end

