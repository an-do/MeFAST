## Functions description
1. DeFAST_HIV_data.mat: Presimulated and calculated sensitivity indices for the model, which is used to generate all figures in the manuscript
2. DeFAST_HIV_main.m: Main function to simuldate the model and calculate the sensitivity indices
3. DeFAST_analysis.m: Statistical analysis routine which includes the convergence test and tests for significance 
4. Model_efast.m: Sensitivity indices calculation 
5. ODE_model.m: Dynamical model implementation
6. Parameter_settings.m: Contains model parameters of interest information such as: names and ranges of uncertainty 
7. SETFREQ.m: DeFAST hyperparameter algorithm, frequency of search curves
8. compute_variance.m: Computing variance of the model correspoding to the variance of each parameter
9. loadparameters.m
10. myevent.m: set-up so that matlab ode solver will quit if integration takes too long time 
11. parameterdist.m: DeFAST hyperparameter, model parameter sampling distribution 
12. permutation.m: statitical hypothesis test for significance 
13. permutationTest.m
14. runtime.csv: record simulation time 
