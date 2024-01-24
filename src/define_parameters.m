%{ 
define_parameters(runset,n_severity,n_age_class)

A function for defining parameters for ODE model dependent on the current
runset

Input:
- runset: The name of the current runset
- n_severity: The number of severity classes
- n_age_class: The number of age classes
- fixed_val: The value of the parameter that is fixed for this set of runs

Output:
- para: A struct array where each struct contains the parameters for that
run
- run_opts: An array containing the values for the parameter that is
changed over the runset 
%}
function [para, run_opts] = define_parameters(runset,n_severity,n_age_class, fixed_val)

%Initialise parameter structure
para = struct('n_severity', n_severity, 'n_age_class', n_age_class);

para.R0 = 0; %Initialise R0 in parameter struct for calculating later
para.eigs = [0 0];

%Get parameter options for the runset used
run_opts = define_run_opts(runset);

%% Set up population parameters

if n_age_class == 3
    %Contact matrix for [0,18), [18,60), 60+
    cont_matrix = [7.7679157 5.673770 0.7950051;
                    2.1871906 7.953278 1.5176259;
                    0.8212769 4.066956 2.2932779];

    %Normalise the contact matrix so the average number of contacts per day
    %is 1
    m = mean(sum(cont_matrix,2));            
    para.cont_matrix = cont_matrix/m;

    %Vector containing population sizes for each age class
    para.pop_vec = [13214952; 34280781; 12792220];
elseif n_age_class == 1
    para.cont_matrix = 1;
    para.pop_vec = 67330000; %UK population
end

%% Define the default parameters
if n_severity == 2
    beta_mild = 0.2;
    %Severity dependent transmission rates
    para.beta = [beta_mild,2*beta_mild];
    
    %Age-dependent probability of symptoms 
    para.nu = [0.8, 0.2];

    %Severity dependent recovery rates
    para.gamma = [1/5, 1/7];
else
    %Severity dependent transmission rates
    para.beta = 0.3*ones(n_severity,1);
    
    %Age-dependent probability of symptoms 
    para.nu = ones(para.n_age_class,n_severity)./n_severity;
    
    %Severity dependent recovery rate
    para.gamma = 0.2*ones(para.n_severity, 1);
end

%Rate of becoming infectious
para.epsilon = 1/2;

%Dependence on severity of infector (0=independent, 1=fully dependent)
para.alpha = 0.5*ones(n_severity,1);



%% Change parameters parameters for each runset option

%Create a copy of the struct for initialising parameters for each run
para_temp = para;

for opts_itr = 1:length(run_opts{2})

%Copy the initial parameter structure
para(opts_itr) = para_temp;

%% Set up infection parameters
if contains(runset, 'fix_prop_sev')
    if contains(runset, 'sFlu')
        R0 = 1.5;
        ratio = 2;
        para(opts_itr).gamma=[1/5 1/7];
    elseif contains(runset, 'pFlu')
        R0 = 3.0;
        ratio = 2;
        para(opts_itr).gamma=[1/5 1/7];
    elseif contains(runset, 'cov')
        R0 = 3.0;
        ratio = 4;
        para(opts_itr).gamma=[1/7 1/14];
    end

    %Get the value of nu for this runset
    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(2),para(opts_itr).alpha, R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];

% Symptom-blocking intervention
elseif strcmp(runset,'sb_int') || strcmp(runset,'sb_int_fix_a_v')|| strcmp(runset, 'ib_int') ||strcmp(runset, 'ib_int_fix_a_v_flu_3') || strcmp(runset, 'isb_int')
    %R0 = 3.0; %Value of R0 that will be fixed in the no intervention case for each set of parameters
    R0 = 3.0;

    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

%     ratio = 2;
%     para(opts_itr).gamma=[1/5 1/5];

    %Get the value of nu for this runset
    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(2),para(opts_itr).alpha, R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];

%% Flu, R0 = 3
elseif contains(runset, 'vig_pFlu') || contains(runset, 'find_opt_up_pFlu')
    R0 = 3.0; %Value of R0 that will be fixed in the no intervention case for each set of parameters

    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

    %Get the value of nu for this runset
    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(2),para(opts_itr).alpha, R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
%% Flu, R0 = 1.5
elseif contains(runset, 'vig_sFlu') || contains(runset, 'find_opt_up_sFlu')
    R0 = 1.5; %Value of R0 that will be fixed in the no intervention case for each set of parameters

    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

    %Get the value of nu for this runset
    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(2),para(opts_itr).alpha, R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
%% Cov, R0 = 3
elseif contains(runset, 'vig_cov') || contains(runset, 'find_opt_up_cov')
    R0 = 3.0;%2.4; %Value of R0 that will be fixed in the no intervention case for each set of parameters

    ratio = 4;
    para(opts_itr).gamma=[1/7 1/14];

    para(opts_itr).epsilon = 0.2;

    %Get the value of nu for this runset
    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(2),para(opts_itr).alpha, R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
elseif strcmp(runset,'no_int_sFlu') || strcmp(runset,'no_int_pFlu')
    
    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

    nu = 0.2;%fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    fixed_R0 = fixed_val;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(1,2),para(opts_itr).alpha(1), fixed_R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
elseif strcmp(runset,'no_int_cov')

    if n_severity ~= 2
        error('The runset fix_R0 requires there to be only two severity levels')
    end
    
    ratio = 4;
    para(opts_itr).gamma=[1/7 1/14];

    para(opts_itr).epsilon = 0.2;

    nu = 0.2;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    fixed_R0 = fixed_val;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(1,2),para(opts_itr).alpha(1), fixed_R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
elseif strcmp(runset,'no_int_sFlu_fix_beta') || strcmp(runset,'no_int_pFlu_fix_beta')
    
    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

    nu = 0.2;%fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    beta_mild = fixed_val;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,beta_mild*ratio];

    %% Caculate R0
    % Initialise Next Generation Matrix for calculating R0
    K = zeros(n_severity);
    
    % Fill in the matrix with the average number of type u infections caused by
    % an individual of type v
    for u = 1:2
        for v = 1:2
            if u==v
                K(u,v) = para(opts_itr).beta(v)*(1-(1-para(opts_itr).alpha(1))*(1-para(opts_itr).nu(u)))/para(opts_itr).gamma(v);
            else
                K(u,v) = para(opts_itr).beta(v)*(1-para(opts_itr).alpha(1))*para(opts_itr).nu(u)/para(opts_itr).gamma(v);
            end
        end
    end
    
    %Calculate the eigenvalues
    [~,D]=eig(K);
    
    %Set R0 to be the dominant eigenvalue
    para(opts_itr).R0 = max(abs(D),[],'all');

elseif strcmp(runset,'no_int_cov_fix_beta')
    
    ratio = 4;
    para(opts_itr).gamma=[1/7 1/14];

    para(opts_itr).epsilon = 0.2;

    nu = 0.2;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    beta_mild = fixed_val;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,beta_mild*ratio];

    %% Caculate R0
    % Initialise Next Generation Matrix for calculating R0
    K = zeros(n_severity);
    
    % Fill in the matrix with the average number of type u infections caused by
    % an individual of type v
    for u = 1:2
        for v = 1:2
            if u==v
                K(u,v) = para(opts_itr).beta(v)*(1-(1-para(opts_itr).alpha(1))*(1-para(opts_itr).nu(u)))/para(opts_itr).gamma(v);
            else
                K(u,v) = para(opts_itr).beta(v)*(1-para(opts_itr).alpha(1))*para(opts_itr).nu(u)/para(opts_itr).gamma(v);
            end
        end
    end
    
    %Calculate the eigenvalues
    [~,D]=eig(K);
    
    %Set R0 to be the dominant eigenvalue
    para(opts_itr).R0 = max(abs(D),[],'all');
elseif strcmp(runset,'no_int_sFlu_100')

    if n_severity ~= 2
        error('The runset fix_R0 requires there to be only two severity levels')
    end
    
    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

    para(opts_itr).epsilon = 0.2;

    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    fixed_R0 = 1.5;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(1,2),para(opts_itr).alpha(1), fixed_R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
elseif strcmp(runset,'no_int_pFlu_100')

    if n_severity ~= 2
        error('The runset fix_R0 requires there to be only two severity levels')
    end
    
    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

    para(opts_itr).epsilon = 0.2;

    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    fixed_R0 = 3.0;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(1,2),para(opts_itr).alpha(1), fixed_R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
elseif strcmp(runset,'no_int_cov_100')

    if n_severity ~= 2
        error('The runset fix_R0 requires there to be only two severity levels')
    end
    
    ratio = 4;
    para(opts_itr).gamma=[1/7 1/14];

    para(opts_itr).epsilon = 0.2;

    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Get the value of R0 for this runset
    fixed_R0 = 3.0;

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr)*ones(n_severity,1);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(1,2),para(opts_itr).alpha(1), fixed_R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild];
    
end  

%% Calculate R0

if strcmp(runset, 'sb_int') || strcmp(runset, 'sb_int_baseline')|| strcmp(runset,'sb_int_fix_a_v') || strcmp(runset,'sb_int_fix_a_v_baseline') || strcmp(runset, 'sb_int_fix_a_v_covid')|| strcmp(runset,'sb_int_fix_a_v_covid_baseline')
    %R0 = 3.0; %Value of R0 that will be fixed in the no intervention case for each set of parameters
    R0 = 1.1;

    ratio = 2;
    para(opts_itr).gamma=[1/5 1/7];

%     ratio = 2;
%     para(opts_itr).gamma=[1/5 1/5];

    %Get the value of nu for this runset
    nu = fixed_val;
    para(opts_itr).nu = [1-nu, nu];

    %Value of alpha for this run
    para(opts_itr).alpha = run_opts{2}(opts_itr);
    
    %Calulate the value of beta required to give the fixed value of R0
    %(function is at the end of this script)
    beta_mild = calculate_beta(para(opts_itr).gamma(1),para(opts_itr).gamma(2),para(opts_itr).nu(2),para(opts_itr).alpha, R0,ratio);
    
    %Severity dependent transmission rates
    para(opts_itr).beta = [beta_mild,ratio*beta_mild]; 
    % Initialise Next Generation Matrix for calculating R0
    K = zeros(n_severity);
    
    % Fill in the matrix with the average number of type u infections caused by
    % an individual of type v
    for u = 1:n_severity
        for v = 1:n_severity
            if u==v
                K(u,v) = para(opts_itr).beta(v)*(1-(1-para(opts_itr).alpha)*(1-para(opts_itr).nu(u)))/para(opts_itr).gamma(v);
            else
                K(u,v) = para(opts_itr).beta(v)*(1-para(opts_itr).alpha)*para(opts_itr).nu(u)/para(opts_itr).gamma(v);
            end
        end
    end
    
    %Calculate the eigenvalues
    [~,D]=eig(K);
    
    %Set R0 to be the dominant eigenvalue
    para(opts_itr).R0 = max(abs(D),[],'all');
    para(opts_itr).eigs = [D(1,1), D(2,2)];
% else
% 
% % Initialise Next Generation Matrix for calculating R0
% K = zeros(n_severity);
% 
% % Fill in the matrix with the average number of type u infections caused by
% % an individual of type v
% for u = 1:n_severity
%     for v = 1:n_severity
%         if u==v
%             K(u,v) = para(opts_itr).beta(v)*(1-para(opts_itr).alpha(v)*(1-mean(para(opts_itr).nu(:,u))))/para(opts_itr).gamma(v);
%         else
%             K(u,v) = para(opts_itr).beta(v)*para(opts_itr).alpha(v)*mean(para(opts_itr).nu(:,u))/para(opts_itr).gamma(v);
%         end
%     end
% end
% 
% %Calculate the eigenvalues
% [~,D]=eig(K);
% 
% %Set R0 to be the dominant eigenvalue
% para(opts_itr).R0 = max(abs(D),[],'all');
% para(opts_itr).eigs = [D(1,1), D(2,2)];
end
end
end

%{ 
calculate_beta(gammaM,gammaS,nu,alpha,R0)

Calculates the value of beta for mild severity required to give a set value
of R0.

Input:
- gammaM: Recovery rate for mild disease
- gammaS: Recovery rate for severe disease
- nu: Probability of having severe symptoms
- alpha: Dependence of infectee symptom severity on infector symptom
severity (1=independent, 0=fully dependent)
- R0: Fixed value of R0 
- ratio: The ratio between betaM and betaS

Output:
- beta: The mild transmission rate
%}
function beta = calculate_beta(gammaM,gammaS,nu,alpha,R0, ratio)

%Define coefficients of the quadratic equation we need to solve to get beta
% a = 4*ratio*(1-alpha)/(gammaM*gammaS);
% b = -4*R0*((1-alpha*nu)/gammaM+ratio*(1-alpha*(1-nu))/gammaS);
% c = 4*R0^2;

a = ratio*alpha/(gammaM*gammaS);
b = -R0*((1-(1-alpha)*nu)/gammaM+ratio*(1-(1-alpha)*(1-nu))/gammaS);
c = R0^2;

%Solve for beta
if alpha==0 %Treat alpha=0 as a separate case to avoid dividing by zero
    beta = -c/b;
else
    beta = (-b - sqrt(b^2-4*a*c))/(2*a);
end
end