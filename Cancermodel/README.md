# Cancer model

L. G. de Pillis, A. E. Radunskaya, C. L. Wiseman, A validated mathematical model of cell-mediated immune response to tumor growth, Cancer research 65 (17) (2005) 7950–7958

# Description
The model describes the cell-mediated immune response to the tumor growth. It focuses on the role of natural killer (NK) and CD8+ T cells in tumor surveillance. 
The model describes the dynamics of the following species: 1) tumor cells (T), 2) Natural killer (NK) cells (N), 3) CD8+ T cells (L). 

The initial conditions are: T(0) = 0.1 * 10^5, N(0)=0.003 * 10^5 ,L(0)=0 cells. 

The model is given below: 
![Cancer](https://user-images.githubusercontent.com/20584697/122597919-eede2980-d020-11eb-96e2-e8d2b1a721ae.png)

# Objective goal
Our primary goal is to find which parameters are important to the cancer volume using 3 sensitivity analysis methods: 
1. MeFAST
2. Sobol's method
3. Derivative global sensitivity measure. 
 

## To generate figures in the manuscript 

All pre-simulated results are stored under Figures folder. To generate all figures as reported in the manuscript, please execute the function combine_methods_fig.m (https://github.com/an-do/MeFAST/tree/main/Cancermodel/Figures)

## To reproduce all model simulations and calculation of sensitivity indices

To reproduce our simulations and calculations, please visit any particular method of interest (MeFAST, SobolMethod or DGSM) then excute the function [method]_[model]_main (E.g. MeFAST_Cancer_main) 
 

# Reference 
de Pillis, Lisette G., Ami E. Radunskaya, and Charles L. Wiseman. "A validated mathematical model of cell-mediated immune response to tumor growth." Cancer research 65.17 (2005): 7950-7958.
