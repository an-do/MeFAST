To reproduce all model simulations and sensitivity indices calculations, please execute the function DGSM_HIV_main.m 

## Simulation time


We provide below detailed description of all subroutine functions involved in the main function

1. DGSM_HIV_main.m: main function to simulate the model and calculate the sensitvity metrics Gi and ratio
2. DGSM_data.mat: presimulated data, which can be used to generate figures in the manuscript 
3. Der_Tutorial.m
4. LHS.csv: sampled parameter combinations using Latin hypercube sampling scheme
5. LHS_Call.m: Latain hypercube sampling scheme 
6. Model_LHS.m
7. ODE_model.m: dynamical model implementation
8. Parameter_settings.m: parameter setting includes: names and ranges of uncertainty
9. Tutorial.mlx
10. nhist.m : histogram plot
