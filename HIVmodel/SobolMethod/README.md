## Description
To reproduce all model simulations and sensitivity indices calculations, please execute the function DGSM_HIV_main.m 


We provide below detailed description of all subroutine functions involved in the main function
1. LHS_Call.m: Latin hypercube sampling scheme
2. Model_LHS.m: Generate sampled parameters matrix
3. ODE_model.m: Dynamical model implementation
4. Parameter_settings.m: setting of model parameters names and range of uncertainty
5. Sobol_HIV_main.m: main function to execute the model simulations and calculation of sensitivity indices

### Sobol's method algorithm 

There are two main steps involved in computing the sensitivity indices: 
1. First, draw sample values for the model parameters. Here, we use Latin
Hypercube sampling (LHS), which is a stratified Monte Carlo sampling scheme
that assigns a distribution for each parameter, partitioning them into N subin-tervals of equal probability then independently sampling without replacement
from each subinterval. 
2. The second step is to calculate the sensitivity indices using the samples generated from LHS, which is adapted from Jansen’s algorithm. 

![Sobol_scheme](https://user-images.githubusercontent.com/20584697/122826524-1db20500-d298-11eb-9ed7-9a3f9b6c90cb.png)
