# MultiGSA 
Author: An Do Dela

Date: May 29, 2021 

Cite paper: 

## Intro
We present a multi-method framework that incorporates three global sensitivity analysis methods: two variance-based methods (DeFAST and Sobol’s method) and one derivative-based method. Parameters that all three methods uniformly rank as highly significant can reasonably be considered to have the greatest impact on model output.

In MultiGSA we demonstrate the full methodology and workflow using two example mathematical models of increasing complexity. These models include HIV progression and cancer growth. The computational framework we provide generates graphics for visualizing and comparing the results of all three sensitivity analysis algorithms (DGSM, Sobol, and DeFAST).

## Details
This repository contains 2 directories associated with the two mathematical model examples that we discuss in the manuscript. Each directory contains the following folders: 
1.	Figures: Generate figures of ranking of important parameters by each method (DGSM, Sobol, and DeFAST) as reported in the manuscript. The analysis is done based on the pre-generated data in this study. 
2.	DeFAST, DGSM, SobolMethod folders: implementation of each method (DGSM, DeFAST, Sobol) is to help reproduce our results. 

## Reproducing 
1.	If you would like to reproduce our figures in the manuscript, please go to either HIV or Cancer model directory, under Figures folder, call the function combine_methods_fig.m. 
2.	If you would like to reproduce the ranking for any particular method, for example, DeFAST, please visit DeFAST_HIV_figures (or DeFAST_Cancer_figures) folder under Figures directory of either model and call the function DeFAST_HIV_figs.m (or DeFAST_Cancer_figs.m) to generate DeFAST analysis figure as illustrated in the manuscript. 
3.	Similarly, you can reproduce the ranking result by Sobol’s method and DGSM by visiting Sobol_HIV_figures (or Sobol_Cancer_figures) and DGSM_HIV_figures (or DGSM_Cancer_figures) folder under Figures directory then call the functions Sobol_HIV_figs.m (or Sobol_Cancer_figs.m)  and Figure_DGSM_HIV.m (or Figure_DGSM_Cancer.m)
4.	Please notes, all figures generated from the Figures folder are based on the pre-simulated sensitivity indices in this study. To reproduce our study, model simulations and sensitivity indices, please visit each method folder such as DGSM, DeFAST or SobolMethod and call the following functions:
    - DeFAST_Cancer_main.m or DeFAST_HIV_main.m: DeFAST study for cancer and HIV model
    - DGSM study for cancer and HIV model
    - Sobol_Cancer_main.m or Sobol_HIV_main.m: Sobol’s method study for cancer and HIV model

Here is the overview of the repo: 
![repo_overview](https://user-images.githubusercontent.com/20584697/122489268-1aff9900-cf94-11eb-8f63-c20b665bec6e.png) 
    
## References
1.	S. Marino, I. B. Hogue, C. J. Ray, D. E. Kirschner, A methodology for performing global uncertainty and sensitivity analysis in systems biology, Journal of theoretical biology 254 (1) (2008) 178–196.
2.	Saltelli, P. Annoni, I. Azzini, F. Campolongo, M. Ratto, S. Tarantola, Variance based sensitivity analysis of model output. design and estimator for the total sensitivity index, Computer Physics Communications 181 (2) (2010) 259–270.
3.	M. J. Jansen, Analysis of variance designs for model output, Computer Physics Communications 117 (1-2) (1999) 35–43.
4.	Sobol, S. Kucherenko, Derivative based global sensitivity measures, Procedia-Social and Behavioral Sciences 2 (6) (2010) 7745–7746.
5.	S. Perelson, D. E. Kirschner, R. De Boer, Dynamics of hiv infection of cd4+ t cells, Mathematical biosciences 114 (1) (1993) 81–125.
6.	L. DePillis, A. Gallegos, A. Radunskaya, A model of dendritic cell therapy for melanoma, Frontiers in oncology 3.

