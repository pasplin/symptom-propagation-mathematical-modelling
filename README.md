# symptom-propagation-mathematical-modelling
This repository contains files for the analysis presented in the scientific paper "Epidemiological and health economic implications of symptom propagation: A mathematical modelling investigation" by Phoebe Asplin, Matt J. Keeling, Rebecca Mancy and Edward M. Hill. 

[![DOI](https://zenodo.org/badge/643822738.svg)](https://zenodo.org/badge/latestdoi/643822738)

## Software
Model simulations and figure generation were performed using Matlab R2022a.

## Repository structure
Please find below an explainer of the directory structure within this repository.

### src
* Run_ODE_SEIR_model: Runs ODE model for each of the run options (no interventions & fixed value of nu)
* Run_ODE_SEIR_model_int: Runs ODE model for each of the run options (interventions & fixed value of nu)
* Run_model_fix_prop_sev: Runs ODE model for each of the run options (interventions & fixed proportion of cases that are severe)

These scripts call the following functions:
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


### results
* plot_no_int: Generates no intervention figures - Figs 3,4,S1,S2,S6
* plot_vig: Generates intervention figures (fixed value of nu) - Figs S12, S13
* plot_fix_prop_sev: Generates intervention figures (fixed proportion of cases that are severe) - Figs 5,7,8, S7-S11
* plot_int_comp: Generates figures comparing between SA and IB interventions - Fig 6
* plot_opt_up_hm: Generates supplementary heatmaps (e.g. most cost-effective uptake) - Figs S24-S32
* legend_creation: Generates figure legends
