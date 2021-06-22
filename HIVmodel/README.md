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

## Objective goal 

The bifurcation analysis showed that the system admits two equilibrium solutions: an uninfected stead state with no virus present and endemically infected steady state. Combination of parameters $N_V, \mu_T, \mu_V, k_1$ and $k_2$ on the intervals defined above can determine the existence and stabilities of the model. Our primary goal is to find which parameters are important to the free viruses so we can focus in finding better estimates. We implemented 3 methods: 
1. DeFAST
2. Sobol's method
3. Derivative global sensitivity measure. 

## Results
![HIV_analysis](https://user-images.githubusercontent.com/20584697/122860895-60dd9980-d2d3-11eb-9e28-a73beaa29ced.png)


## References 
1. A. S. Perelson, D. E. Kirschner, R. De Boer, Dynamics of hiv infection of cd4+ t cells, Mathematical biosciences 114 (1) (1993) 81–125.
2. S. Marino, I. B. Hogue, C. J. Ray, D. E. Kirschner, A methodol- ogy for performing global uncertainty and sensitivity analysis in systems biology, Journal of theoretical biology 254 (1) (2008) 178–196.
