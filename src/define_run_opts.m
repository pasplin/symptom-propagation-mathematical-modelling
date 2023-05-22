%{ 
define_run_opts(runset)

A function for defining the run options for each run set

Input:
- runset: The name of the chosen runset

Output:
- run_opts{1}: An array containing values for the fixed parameter. For each
value in this array the model will be run length(run_opts{2}) times
- run_opts{2}: An array containing values for the parameter that is varied
during each set of runs.
%}
function run_opts = define_run_opts(runset)

%% Define the variable options for the runset

if contains(runset, 'fix_prop_sev')
    %Intervention uptake
    run_opts{3} = 0:0.01:1;%[0,0.5,0.9];

    %Intervention efficacy
    run_opts{4} = [0.9];

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
elseif strcmp(runset, 'isb_test_duration')
    %Values that nu takes
    run_opts{1} = 0.5;

    %Values that alpha take
    run_opts{2} = 0:0.05:1;
  
    %Intervention uptake
    run_opts{3} = 0:0.001:1;

    %Intervention efficacy
    run_opts{4} = 0.7;
elseif strcmp(runset,'sb_int_fix_a_v') || strcmp(runset,'sb_int_fix_a_v_covid') || strcmp(runset, 'ib_int_fix_a_v_flu_3')||strcmp(runset, 'ib_int_fix_a_v_flu_1.5')||strcmp(runset, 'ib_int_fix_a_v_cov_3')
    %Values that nu takes
    run_opts{1} = [0.2,0.5,0.8];

    %Values that alpha take
    run_opts{2} = [0,0.2,0.5,0.8,1.0];
  
    %Intervention uptake
    run_opts{3} = 0:0.02:1;

    %Intervention efficacy
    run_opts{4} = [0.25,0.5,0.7,0.9];%0:0.01:1;
elseif strcmp(runset, 'isb_test')
    %Values that nu takes
    run_opts{1} = 0.75;

    %Values that alpha take
    run_opts{2} = [0.2,0.25];
  
    %Intervention uptake
    run_opts{3} = 0:0.01:1;

    %Intervention efficacy
    run_opts{4} = 0.5;

elseif strcmp(runset, 'sb_int_find_opt_up_flu_3.0')||strcmp(runset, 'sb_int_find_opt_up_flu_1.5')|| strcmp(runset,'sb_int_find_opt_up_cov_3.0') || strcmp(runset, 'ib_int_find_opt_up_flu_3.0')||strcmp(runset, 'ib_int_find_opt_up_flu_1.5')|| strcmp(runset,'ib_int_find_opt_up_cov_3.0')||strcmp(runset, 'ib_sev_int_find_opt_up_flu_1.5')||strcmp(runset, 'ib_sev_int_find_opt_up_flu_3.0')|| strcmp(runset,'ib_sev_int_find_opt_up_cov_3.0') || strcmp(runset, 'isb_int_find_opt_up_flu_3.0')||strcmp(runset, 'isb_int_find_opt_up_flu_1.5')|| strcmp(runset,'isb_int_find_opt_up_cov_3.0')
     %Values that nu takes
    run_opts{1} = 0:0.05:1;

    %Values that alpha take
    run_opts{2} = 0:0.05:1;
  
    %Intervention uptake
    run_opts{3} = 0:0.01:1;

    %Intervention efficacy
    run_opts{4} = [0.5,0.7,0.9];

elseif strcmp(runset,'single_run')
    %Set to 1 so that only one run occurs
    run_opts{1} = 1;

    %Value of alpha
    run_opts{2} = 1;
elseif strcmp(runset,'no_int_flu_1.5')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 1.5;

    %Values of alpha
    run_opts{2}=0:0.1:1;
elseif strcmp(runset,'no_int_flu_3.0')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 3.0;

    %Values of alpha
    run_opts{2}=0:0.1:1;
elseif strcmp(runset,'no_int_cov_3.0')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 3.0;

    %Values of alpha
    run_opts{2}=0:0.1:1;
    elseif strcmp(runset,'no_int_flu_1.5_100')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 0:0.05:1;

    %Values of alpha
    run_opts{2}=0:0.05:1;
elseif strcmp(runset,'no_int_flu_3.0_100')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 0:0.05:1;

    %Values of alpha
    run_opts{2}=0:0.05:1;
elseif strcmp(runset,'no_int_cov_3.0_100')
    %Value of R_0 that is fixed for each set of runs
    run_opts{1} = 0:0.05:1;

    %Values of alpha
    run_opts{2}=0:0.05:1;
elseif strcmp(runset,'sb_vig_flu_1.5')||strcmp(runset,'sb_vig_flu_3.0')||strcmp(runset,'sb_vig_cov_3.0')||strcmp(runset,'ib_vig_flu_1.5')||strcmp(runset,'ib_vig_flu_3.0')||strcmp(runset,'ib_vig_cov_3.0')||strcmp(runset,'isb_vig_flu_1.5')||strcmp(runset,'isb_vig_flu_3.0')||strcmp(runset,'isb_vig_cov_3.0')
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