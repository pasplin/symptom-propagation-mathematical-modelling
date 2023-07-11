# symptom-propagation-mathematical-modelling
This repository contains files for the analysis presented in the scientific paper "Epidemiological and health economic implications of symptom propagation: A mathematical modelling investigation" by Phoebe Asplin, Matt J. Keeling, Rebecca Mancy and Edward M. Hill. 

DOI: 10.5281/zenodo.8136533

## Software
Model simulations and figure generation were performed using Matlab R2022a.

## Repository structure
Please find below an explainer of the directory structure within this repository.

### src
* define_run_opts: Defines the run options for each runset
* define_parameters: Defines parameters for a given runset
* define_ICs: Sets up the initial conditions
* find_opt_up: Function that finds the most cost-effective uptake
* health_econ_module: Function that calculates health economic outputs (e.g. QALYs, hospital costs)
* ODE_SEIR_model... : Contains ODE model equations
  * ODE_SEIR_model: Equations for no interventions
  * ODE_SEIR_model_sb_int: Equations with a symptom-attenuating intervention
  * ODE_SEIR_model_ib_int: Equations with an infection-blocking intervention
  * ODE_SEIR_model_isb_int: Equations with an infection-blocking intervention which only admits mild breakthroughs
  * ODE_SEIR_model_ib_sev_int: Equations with an infection-blocking intervention where breakthroughs are only caused by severely infected individuals
* Run_ODE_SEIR_model: Runs ODE model for each of the run options (no interventions & fixed value of nu)
* Run_ODE_SEIR_model_int: Runs ODE model for each of the run options (interventions & fixed value of nu)
* Run_model_fix_prop_sev: Runs ODE model for each of the run options (interventions & fixed proportion of cases that are severe) 

### results
* plot_no_int: Generates no intervention figures
* plot_vig: Generates intervention figures (fixed value of nu)
* plot_fix_prop_sev: Generates intervention figures (fixed proportion of cases that are severe)
* plot_int_comp: Generates figures comparing between SA and IB interventions
* plot_opt_up_hm: Generates supplementary heatmaps (e.g. most cost-effective uptake)
* legend_creation: Generates figure legends
