# Cancer model

L. G. de Pillis, A. E. Radunskaya, C. L. Wiseman, A validated mathematical model of cell-mediated immune response to tumor growth, Cancer research 65 (17) (2005) 7950–7958

# Description
The model describes the cell-mediated immune response to the tumor growth. It focuses on the role of natural killer (NK) and CD8+ T cells in tumor surveillance. 
The model describes the dynamics of the following species: 1) tumor cells (T), 2) Natural killer (NK) cells (N), 3) CD8+ T cells (L). 

The initial conditions are: T(0) = 0.1 * 10^5, N(0)=0.003 * 10^5 ,L(0)=0 cells. 

The model is given below: 
![Cancer](https://user-images.githubusercontent.com/20584697/122597919-eede2980-d020-11eb-96e2-e8d2b1a721ae.png)

# Objective goal
There are 15 parameters in the model, whose ranges of uncertainties are discussed in the manuscript. Our primary goal is to find which parameters are important to the cancer volume so we can focus in finding better estimates. We implemented 3 methods: 
1. DeFAST
2. Sobol's method
3. Derivative global sensitivity measure. 
 
# Result
We perform DeFAST for NR up to 400. The maximum frequencies ωmax is
kept at 8. Our DeFAST analysis is displayed below: 

<img width="617" alt="Screen Shot 2021-06-22 at 3 11 15 PM" src="https://user-images.githubusercontent.com/20584697/123006765-0a249e00-d36d-11eb-8b16-59ec2c994abb.png">

All parameters’ total order sensitivity indices converge as early as NR = 50. There are 6 highly influential parameters including: 
1. the exponent of fractional tumor cells killed by CD8+ T cell (λ)
2. the tumor growth rate a
3. the source of natural killer cells (σ)
4. the rate at which T cells are stimulated by the tumor cells (r)
5. the saturated level of tumor cells killed by T cells (d)
6. the steepness coefficient of the T cell competition (s).

It is challenging to determine the number of significant parameters from the student t-test, Wilcoxon and Permutation test. Their conclusions fluctuate and keep increasing as NR grows (panel (C)) while the the ANOVA-Tukey test’s conclusion is “less noisy” and convergent at 6 significant parameters. We further consider the physiological pathways of each significant parameter in association with the tumor cell, and agree with the ANOVA-Tukey test.

We combine DeFAST’s result with Sobol’s method and DGSM and present our result in Figure 9 for two different time points t = 25 and t = 50. We rank the important of parameters by DeFAST and shade the significant parameters indicated by ANOVA-Tukey test below:

<img width="872" alt="Screen Shot 2021-06-22 at 3 11 34 PM" src="https://user-images.githubusercontent.com/20584697/123006770-0bee6180-d36d-11eb-99c6-617f3fb6642d.png">


# Reference 
de Pillis, Lisette G., Ami E. Radunskaya, and Charles L. Wiseman. "A validated mathematical model of cell-mediated immune response to tumor growth." Cancer research 65.17 (2005): 7950-7958.
