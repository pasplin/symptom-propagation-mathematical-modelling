clear
%% Script for running ODE model (no interventions)

%% Set the runset for the model
%runsets = {'no_int_flu_1.5','no_int_flu_3.0','no_int_cov_3.0'};
runsets = {'no_int_flu_1.5_100','no_int_flu_3.0_100','no_int_cov_3.0_100'};

%Set the number of symptom severity levels 
n_severity = 2;

%Set the number of age classes
n_age_class = 1;

for run_itr = 1:length(runsets)
    
runset = runsets{run_itr};

%Get parameter options for the runset used
run_opts = define_run_opts(runset);

for ii = 1:length(run_opts{1})

fixed_val = run_opts{1}(ii);

%Define a struct array for the runset parameters
[para] = define_parameters(runset,n_severity,n_age_class, fixed_val);

%Set the severity of the initial case
init_sev = 1:n_severity; %Sets an initial case in each of the severity levels

%Define time to run model for (in days)
maxtime = 8*365;

%Define a struct containing the initial conditions
[ICs] = define_ICs(para, init_sev);

%% Run model for each runset option
for opts_itr = 1:length(run_opts{2})

%Run model using the parameters defined above and save into a struct array
[Classes(opts_itr)] = ODE_SEIR_model(para(opts_itr),ICs,maxtime);

end
outputs(ii,:) = Classes;
parameters(ii,:) = para;
end
%% Save parameters and outputs to results file for plots
%filename = ['C:\Users\Mike Asplin\Documents\symptom-severity-propagation-health-econ\results\model_output_' runset '.mat'];
filename = ['model_output_' runset '.mat'];
save(filename, 'parameters', 'outputs')

end
