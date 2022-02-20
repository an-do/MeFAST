## Functions description
1. DeFAST_HIV_data.mat: Presimulated and calculated sensitivity indices for the model, which is used to generate all figures in the manuscript
2. DeFAST_HIV_main.m: Main function to simuldate the model and calculate the sensitivity indices
3. DeFAST_analysis.m: Statistical analysis routine which includes the convergence test and tests for significance 
4. Model_efast.m: Sensitivity indices calculation 
5. ODE_model.m: Dynamical model implementation
Parameter_settings.m: Contains model parameters of interest information such as: names and ranges of uncertainty 
SETFREQ.m: DeFAST hyperparameter algorithm, frequency of search curves
compute_variance.m: Computing variance of the model correspoding to the variance of each parameter
loadparameters.m
myevent.m: set-up so that matlab ode solver will quit if integration takes too long time 
parameterdist.m: DeFAST hyperparameter, model parameter sampling distribution 
permutation.m: statitical hypothesis test for significance 
permutationTest.m
runtime.csv: record simulation time 
