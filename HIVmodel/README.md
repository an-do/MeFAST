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

The bifurcation analysis showed that the system admits two equilibrium solutions: an uninfected stead state with no virus present and endemically infected steady state. Combination of parameters $N_V, \mu_T, \mu_V, k_1$ and $k_2$ on the intervals defined above can determine the existence and stabilities of the model. Our primary goal 
