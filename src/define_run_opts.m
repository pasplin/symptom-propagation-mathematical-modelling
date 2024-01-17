%{ 
define_run_opts(runset)

A function for defining the run options for each run set

Input:
- runset: The name of the chosen runset

Output:
- run_opts{1}: An array containing values for the fixed parameter, usually
nu
- run_opts{2}: An array containing the values that alpha takes
- run_opts{3}: An array containing intervention efficacy options (if
relevent)
- run_opts{4}: An array containing intervention uptake options (if
relevent)
%}
function run_opts = define_run_opts(runset)

%% Define the variable options for the runset

%% Runsets for no interventions
if strcmp(runset,'no_int_sFlu')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 1.5;

    %Values of alpha
    run_opts{2}=0:0.1:1;
elseif strcmp(runset,'no_int_pFlu')||strcmp(runset,'no_int_cov')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 3.0;

    %Values of alpha
    run_opts{2}=0:0.1:1;

elseif strcmp(runset,'no_int_sFlu_fix_beta')
    %Value of beta_sev that is fixed for each set of runs
    run_opts{1} = 0.3;

    %Values of alpha
    run_opts{2}=0:0.1:1;
elseif strcmp(runset,'no_int_pFlu_fix_beta')
    %Value of beta_sev that is fixed for each set of runs
    run_opts{1} = 0.5;

    %Values of alpha
    run_opts{2}=0:0.1:1;
elseif strcmp(runset,'no_int_cov_fix_beta')
    %Value of beta_sev that is fixed for each set of runs
    run_opts{1} = 0.3;

    %Values of alpha
    run_opts{2}=0:0.1:1;

%% Runset for intervention comparison plots, two values of alpha, nu chosen
%% to fix proportion of cases that are severe
elseif contains(runset, 'fix_prop_sev')
    %Intervention uptake
    run_opts{3} = 0:0.01:1;%[0,0.5,0.9];

    %Intervention efficacy
    run_opts{4} = 0.7;

    %Values that alpha take
    run_opts{2} = [0.2, 0.8];
  
    if contains(runset, 'sFlu')
        %Values that nu takes
        run_opts{1} = [0.7707, 0.3326];
    elseif contains(runset, 'pFlu')
        %Values that nu takes
        run_opts{1} = [0.7721, 0.3566];
    elseif contains(runset, 'cov')
        %Values that nu takes
        run_opts{1} = [0.7589, 0.1436];
    end

elseif strcmp(runset,'sb_int') || strcmp(runset, 'ib_int') || strcmp(runset,'isb_int')
    %Values that nu takes
    run_opts{1} = 0:0.1:1;

    %Values that alpha take
    run_opts{2} = 0:0.1:1;
  
    %Intervention uptake
    run_opts{3} = [0, 0.25,0.5,0.7,0.9];

    %Intervention efficacy
    run_opts{4} = [0.25,0.5,0.7,0.9];
elseif strcmp(runset,'sb_int_fix_a_v') || strcmp(runset,'sb_int_fix_a_v_covid') || strcmp(runset, 'ib_int_fix_a_v_flu_3')||strcmp(runset, 'ib_int_fix_a_v_sFlu')||strcmp(runset, 'ib_int_fix_a_v_cov_3')
    %Values that nu takes
    run_opts{1} = [0.2,0.5,0.8];

    %Values that alpha take
    run_opts{2} = [0,0.2,0.5,0.8,1.0];
  
    %Intervention uptake
    run_opts{3} = 0:0.02:1;

    %Intervention efficacy
    run_opts{4} = [0.25,0.5,0.7,0.9];%0:0.01:1;

elseif strcmp(runset, 'sb_int_find_opt_up_pFlu')||strcmp(runset, 'sb_int_find_opt_up_sFlu')|| strcmp(runset,'sb_int_find_opt_up_cov') || strcmp(runset, 'ib_int_find_opt_up_pFlu')||strcmp(runset, 'ib_int_find_opt_up_sFlu')|| strcmp(runset,'ib_int_find_opt_up_cov')||strcmp(runset, 'ib_sev_int_find_opt_up_sFlu')||strcmp(runset, 'ib_sev_int_find_opt_up_pFlu')|| strcmp(runset,'ib_sev_int_find_opt_up_cov') || strcmp(runset, 'isb_int_find_opt_up_pFlu')||strcmp(runset, 'isb_int_find_opt_up_sFlu')|| strcmp(runset,'isb_int_find_opt_up_cov')
     %Values that nu takes
    run_opts{1} = 0:0.05:1;

    %Values that alpha take
    run_opts{2} = 0:0.05:1;
  
    %Intervention uptake
    run_opts{3} = 0:0.01:1;

    %Intervention efficacy
    run_opts{4} = [0.5,0.7,0.9];


%% No interventions with 100 
elseif strcmp(runset,'no_int_sFlu_100')
    %Value of nu that is fixed for each set of runs
    run_opts{1} = 0:0.05:1;

    %Values of alpha
    run_opts{2}=0:0.05:1;
elseif strcmp(runset,'no_int_pFlu_100')
    %Value of nu that is fixed for each set of runs
    run_opts{1} = 0:0.05:1;

    %Values of alpha
    run_opts{2}=0:0.05:1;
elseif strcmp(runset,'no_int_cov_100')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 0:0.05:1;

    %Values of alpha
    run_opts{2}=0:0.05:1;
elseif strcmp(runset,'sb_vig_sFlu')||strcmp(runset,'sb_vig_pFlu')||strcmp(runset,'sb_vig_cov')||strcmp(runset,'ib_vig_sFlu')||strcmp(runset,'ib_vig_pFlu')||strcmp(runset,'ib_vig_cov')||strcmp(runset,'isb_vig_sFlu')||strcmp(runset,'isb_vig_pFlu')||strcmp(runset,'isb_vig_cov')
    %Values that nu takes
    run_opts{1} = 0.2;

    %Values that alpha take
    run_opts{2} = [0.2,0.8];
  
    %Intervention uptake
    run_opts{3} = [0.5,0.9];

    %Intervention efficacy
    run_opts{4} = 0.8;
end

end