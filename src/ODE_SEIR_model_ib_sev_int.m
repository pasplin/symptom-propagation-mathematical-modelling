%{ 
ODE_SEIR_model_isb_int(para,ICs,maxtime)

A function for running the ODE model with a infection-blocking intervention
for a given set of parameters (defined for two symptom severity classes)

Input:
- para: A struct containing the parameters for the run
- ICs: A struct containing the initial conditions for the run
- maxtime: The time span of the simulation in days

Output:
- Classes: A struct containing the number of people in S,E,I,R at each
timestep
%}
function [Classes] = ODE_SEIR_model_ib_sev_int(para,ICs,maxtime)

%Run ODE using ODE45
opts = odeset('RelTol',1e-5, 'Events', @myEventsFcn);
tspan = 0:1:maxtime;
init_conds = [ICs.S ICs.V ICs.E ICs.I ICs.R];
[t, pop] = ode45(@diff_SEIR_model, tspan , init_conds , opts);

function [value,isterminal,direction] = myEventsFcn(t, pop)
    value      = pop(5) + pop(6) - 0.02;
    isterminal = 1;   % Stop the integration
    direction  = 0;
end

%Rename these parameters to simplify code
%n = para.n_age_class;
m = para.n_severity;

%Convert output to structure
Classes = struct('t',t);
Classes.S = pop(:,1);
Classes.V = pop(:,2);

%Initialise arrays
Classes.E = zeros(length(Classes.t), m);
Classes.I = zeros(length(Classes.t), m);
Classes.R = zeros(length(Classes.t), m);

%Convert 2D pop array to output arrays
for ii = 1:m
    Classes.E(:, ii) = pop(:,ii+2);
    Classes.I(:, ii) = pop(:,(m+ii)+2);
    Classes.R(:, ii) = pop(:,(2*m+ii)+2);
end

%Differential equation
function dPop = diff_SEIR_model(t,pop)

%Rename these parameters to simplify code
n = 1; %para.n_age_class;
m = 2; %para.n_severity;

%Convert 1D pop array to separate arrays for each class 
S=pop(1);
V=pop(2);

E = zeros(m,1);
I = zeros(m,1);
R = zeros(m,1);
for ii = 1:m
    E(ii) = pop(ii+2);
    I(ii) = pop((m+ii)+2);
    R(ii) = pop((2*m+ii)+2);
end

%Initialise differential equation arrays
dE = zeros(2);
dI = zeros(2);
dR = zeros(2);

%Calculate the force of infection from each severity level
FOI = zeros(2,1);

FOI(1) = para.beta(1)*I(1)./para.pop_vec;
FOI(2) = para.beta(2)*I(2)./para.pop_vec;

dS = -sum(FOI)*S;
dV = -(1-para.eta)*FOI(2)*V;

dE(1) = (1-(1-para.alpha)*(1-para.nu(1)))*FOI(1)*S + para.nu(1)*(1-para.alpha)*FOI(2)*(S + (1-para.eta)*V) - para.epsilon*E(1);
dE(2) = (1-(1-para.alpha)*(1-para.nu(2)))*FOI(2)*(S + (1-para.eta)*V) + para.nu(2)*(1-para.alpha)*FOI(1)*S  - para.epsilon*E(2);

for s = 1:m  
    dI(s) = para.epsilon*E(s) - para.gamma(s)*I(s);
    dR(s) = para.gamma(s)*I(s);
end    


%Convert output to a vector [S; V; E; I; R]
dPop = zeros(2+3*m,1);
dPop(1) = dS;
dPop(2) = dV;

for ii = 1:m
    dPop(ii+2) = dE(ii);
    dPop((m+ii)+2) = dI(ii);
    dPop((2*m+ii)+2) = dR(ii);
end
end

end




