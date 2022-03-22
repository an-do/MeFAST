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

Our goal is to find the subset of important parameters to a specified model outcomes. 

## To generate figures in the manuscript 

All pre-simulated results are stored under Figures folder. To generate all figures as reported in the manuscript, please execute the function combine_methods_fig.m to generate under Figures folder (https://github.com/an-do/MeFAST/tree/main/HIVmodel/Figures)

## To reproduce all model simulations and calculation of sensitivity indices

To reproduce our simulations and calculations, please visit any particular method of your interest (MeFAST, SobolMethod or DGSM) in this directory then excute the function [method]_[model]_main (E.g. MeFAST_HIV_main) 



## References 
1. A. S. Perelson, D. E. Kirschner, R. De Boer, Dynamics of hiv infection of cd4+ t cells, Mathematical biosciences 114 (1) (1993) 81–125.
2. S. Marino, I. B. Hogue, C. J. Ray, D. E. Kirschner, A methodology for performing global uncertainty and sensitivity analysis in systems biology, Journal of theoretical biology 254 (1) (2008) 178–196.
