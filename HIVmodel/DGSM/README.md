## Description

To reproduce all model simulations and sensitivity indices calculations, please execute the function DGSM_HIV_main.m 

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



### DGSM algorithm
Derivative-based global measures (DGSM) is a technique, proposed by Kucherenko et al. It involves taking the partial derivatives of the model output with respect to the parameter across the parameter space. 
The sensitivity measures of DGSM involves computing the mean and standard deviation of the distribution of all possible partial derivatives with respect to each parameter within their range of uncertainties. 
There are two sensitivity measures that are derived from DGSM including:
1. The sum of square of the mean and standard deviation of the partial derivatives, namely Gi
2. The ratio between the mean and the standard deviation.

The algorithm is illustrated in the diagram below:

![derivative_scheme](https://user-images.githubusercontent.com/20584697/122826650-3fab8780-d298-11eb-8939-e581599349f8.png)
