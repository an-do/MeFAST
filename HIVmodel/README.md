# HIV model 
 

## Description 
We examine the human immunodeficiency HIV infection model. 
The model describes interactions between the following species: 
1. Uninfected T cells ($T$)
2. Latently infected T cells ($T^*$) that contains provirus but yet to produce new viruses
3. Actively infected T cells ($T^{**}$) that produce new viruses
4. Free virus ($V$) 
with the initial conditions where $T(0) = 1000mm^{-3}, T^*(0)= T^{**}(0)=0$ and $V(0)= 10^{-3}mm^{-3}$ (illustrated below).

The model consists of four ordinary differential equations and contains a total of nine parameters.  


![HIVmodel](https://user-images.githubusercontent.com/20584697/122605364-30c09d00-d02c-11eb-9459-6e08a5fac45f.png)

## To generate figures in the manuscript 

All pre-simulated results are stored under Figures folder. To generate all figures as reported in the manuscript, please execute the function combine_methods_fig.m to generate under Figures folder (https://github.com/an-do/DeFAST/tree/main/HIVmodel/Figures)

## To reproduce all model simulations and calculation of sensitivity indices

To reproduce our simulations and calculations, please visit any particular method of your interest (DeFAST, SobolMethod or DGSM) in this directory then excute the function [method]_[model]_main (E.g. DeFAST_HIV_main) 

## Objective goal 

The bifurcation analysis showed that the system admits two equilibrium solutions: an uninfected stead state with no virus present and endemically infected steady state. Combination of parameters $N_V, \mu_T, \mu_V, k_1$ and $k_2$ on the intervals defined above can determine the existence and stabilities of the model. Our primary goal is to find which parameters are important to the free viruses so we can focus in finding better estimates. We implemented 3 methods: 
1. DeFAST
2. Sobol's method
3. Derivative global sensitivity measure. 

## Results
We conduct DeFAST using the viral load after 2000 days as
sensitivity metrics. We rank the important parameters using total order sensitivity index. Our analysis was done with NR up to 400. We fixed the maximum frequencies ωmax = 8.

![eFAST_HIV_STi_day2000](https://user-images.githubusercontent.com/20584697/122861113-bca82280-d2d3-11eb-8ede-625b9d4d9624.png)


According to panel B, parameter μV (the death rate of free virus), NV (the number of free viruses produced by infected T cells), and k2 (the rate latently infected cells convert to actively infected) contribute most to the model output's variation. Panel C displays the number of statistically significant parameters indicated by four statistical tests as functions of NR. The ANOVA-Tukey test detects that there are three important parameters, namely μV ,NV ,k2, which is agreeable to our visual inspection. Meanwhile, the student t-test, Wilcoxon and Permutation test’s conclusions fluctuate between 3-4 important parameters.


We combine the ranking of DeFAST, Sobol's method, and DGSM to effectively choose the most important parameters. The four parameters that are consistently ranked highly across three methods are: 1) the death  rate of free virus (μV ), 2) the number of free viruses produced by infected T cells (NV ), 3) the rate latently infected cells convert to actively infected (k2), and 4) the rate at which T cells becoming infected by free viruses (k1). 

![HIV_analysis](https://user-images.githubusercontent.com/20584697/122860895-60dd9980-d2d3-11eb-9e28-a73beaa29ced.png)


## References 
1. A. S. Perelson, D. E. Kirschner, R. De Boer, Dynamics of hiv infection of cd4+ t cells, Mathematical biosciences 114 (1) (1993) 81–125.
2. S. Marino, I. B. Hogue, C. J. Ray, D. E. Kirschner, A methodol- ogy for performing global uncertainty and sensitivity analysis in systems biology, Journal of theoretical biology 254 (1) (2008) 178–196.
