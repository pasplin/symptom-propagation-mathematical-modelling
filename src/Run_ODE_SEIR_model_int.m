function Run_ODE_SEIR_model_int(job_ID)

%% Script for running ODE model with interventions

tic

%% Set the runset for the model

runsets = {'sb_int_find_opt_up_flu_1.5','sb_int_find_opt_up_flu_3.0','sb_int_find_opt_up_cov_3.0', 'ib_int_find_opt_up_flu_1.5','ib_int_find_opt_up_flu_3.0','ib_int_find_opt_up_cov_3.0', 'isb_int_find_opt_up_flu_1.5','isb_int_find_opt_up_flu_3.0','isb_int_find_opt_up_cov_3.0','isb_test_duration'};
%runsets = {'sb_vig_flu_1.5','sb_vig_flu_3.0','sb_vig_cov_3.0','ib_vig_flu_1.5','ib_vig_flu_3.0','ib_vig_cov_3.0','isb_vig_flu_1.5','isb_vig_flu_3.0','isb_vig_cov_3.0'};


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
if strcmp(runset,'sb_vig_flu_1.5')||strcmp(runset,'sb_vig_flu_3.0')||strcmp(runset,'sb_vig_cov_3.0')||strcmp(runset,'ib_vig_flu_1.5')||strcmp(runset,'ib_vig_flu_3.0')||strcmp(runset,'ib_vig_cov_3.0')||strcmp(runset,'isb_vig_flu_1.5')||strcmp(runset,'isb_vig_flu_3.0')||strcmp(runset,'isb_vig_cov_3.0')
    S = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365);
    V = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365);

    I = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365, n_severity);
    R = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years*365, n_severity);

else
    outputs = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}), num_years, n_severity);
end
duration = zeros(length(run_opts{1}), length(run_opts{2}), length(run_opts{3}), length(run_opts{4}));

for nu_itr = 1:length(run_opts{1})    
    nu = run_opts{1}(nu_itr);
    
    %Define a struct array for the runset parameters
    [para] = define_parameters(runset,n_severity,n_age_class, nu);
    

   
    %% Run model for each runset option
    for alpha_itr = 1:length(run_opts{2})
        for eff_itr = 1:length(run_opts{4})
            for uptake_itr = 1:length(run_opts{3})

                para(alpha_itr).eta = run_opts{4}(eff_itr);
                para(alpha_itr).u = run_opts{3}(uptake_itr);

                %Define a struct containing the initial conditions
                [ICs] = define_ICs(para, init_sev);

                ICs.V = ICs.S*para(alpha_itr).u;
                ICs.S = ICs.S - ICs.V;

                if strcmp(runset,'sb_vig_flu_1.5')||strcmp(runset,'sb_vig_flu_3.0')||strcmp(runset,'sb_vig_cov_3.0')
                    [Classes] = ODE_SEIR_model_sb_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;
                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;
                
                elseif strcmp(runset,'ib_vig_flu_1.5')||strcmp(runset,'ib_vig_flu_3.0')||strcmp(runset,'ib_vig_cov_3.0')
                    [Classes] = ODE_SEIR_model_ib_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;

                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;
                elseif strcmp(runset,'isb_vig_flu_1.5')||strcmp(runset,'isb_vig_flu_3.0')||strcmp(runset,'isb_vig_cov_3.0')
                    [Classes] = ODE_SEIR_model_isb_int(para(alpha_itr),ICs,maxtime);
                    S(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.S;
                    V(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t)) = Classes.V;

                    I(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.I;
                    R(nu_itr, alpha_itr, uptake_itr, eff_itr, 1:length(Classes.t), :) = Classes.R;
                
                elseif int == "ib"
                    [Classes] = ODE_SEIR_model_ib_int(para(alpha_itr),ICs,maxtime);
                    %Fill output array with number of cumulative infections
                    %at the end of each year
                    for year = 1:num_years
                        if year*365 < length(Classes.t)
                            outputs(nu_itr, alpha_itr, uptake_itr, eff_itr, year, :) = Classes.R(year*365,:,:);
                        else %If the simulation has ended by that year, take the value at the end of the simulation
                            outputs(nu_itr, alpha_itr, uptake_itr,eff_itr, year, :) = Classes.R(end,:,:);
                        end
                    end 
                elseif int == "isb"
                    [Classes] = ODE_SEIR_model_isb_int(para(alpha_itr),ICs,maxtime);
                    
                    %Fill output array with number of cumulative infections
                    %at the end of each year
                    for year = 1:num_years
                        if year*365 < length(Classes.t)
                            outputs(nu_itr, alpha_itr, uptake_itr, eff_itr, year, :) = Classes.R(year*365,:);
                        else %If the simulation has ended by that year, take the value at the end of the simulation
                            outputs(nu_itr, alpha_itr, uptake_itr,eff_itr, year, :) = Classes.R(end,:);
                        end
                    end
      
                elseif int == "sb"
                    [Classes] = ODE_SEIR_model_sb_int(para(alpha_itr),ICs,maxtime);
                    %Fill output array with number of cumulative infections
                    %at the end of each year
                    for year = 1:num_years
                        if year*365 < length(Classes.t)
                            outputs(nu_itr, alpha_itr, uptake_itr, eff_itr, year, :) = Classes.R(year*365,:);
                        else %If the simulation has ended by that year, take the value at the end of the simulation
                            outputs(nu_itr, alpha_itr, uptake_itr,eff_itr, year, :) = Classes.R(end,:);
                        end
                    end 
                end

                duration(nu_itr, alpha_itr, uptake_itr,eff_itr) = length(Classes.t);

                
                %eff_str(eff_itr).uptake_str(uptake_itr).nu_str(nu_itr).alpha_str(alpha_itr) = Classes_end;
                %outputs = eff_str;
                parameters(nu_itr,alpha_itr) = para(alpha_itr);
            end
        end
            
    end

end    
%% Save parameters and outputs to results file for plots

filename = ['model_output_' runset '.mat'];
if strcmp(runset,'sb_vig_flu_1.5')||strcmp(runset,'sb_vig_flu_3.0')||strcmp(runset,'sb_vig_cov_3.0')||strcmp(runset,'ib_vig_flu_1.5')||strcmp(runset,'ib_vig_flu_3.0')||strcmp(runset,'ib_vig_cov_3.0')||strcmp(runset,'isb_vig_flu_1.5')||strcmp(runset,'isb_vig_flu_3.0')||strcmp(runset,'isb_vig_cov_3.0')
    save(filename, 'parameters','S','V', 'I', 'R')
else
    save(filename, 'parameters', 'outputs', 'duration')
end
toc

