%{ 
define_ICs(para, init_sev)

A function for defining the initial conditions for the ODE model

Input:
- para: A struct array containing the parameters for each run
- init_sev: An array containing the severity classes in which an infected
person will initially be seeded

Output:
- ICs: A struct containing the initial conditions for each class
%}
function [ICs] = define_ICs(para, init_sev)

%Define p to simplify code
p = para(1);

%Initialise initial conditions arrays
E0 = zeros(p.n_age_class, p.n_severity);
I0 = zeros(p.n_age_class, p.n_severity);
R0 = zeros(p.n_age_class, p.n_severity);

%Set up index patient(s)
for ii = 1:length(init_sev)
    I0(1, init_sev(ii)) = p.nu(ii);
end


%Set the remaining population to susceptible
S0 = p.pop_vec-sum(E0,2)-sum(I0,2)-sum(R0,2);

%Define initial conditions as a structure
ICs = struct('S',S0,'E',E0,'I',I0,'R',R0);

end