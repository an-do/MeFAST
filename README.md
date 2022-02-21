# Multi-method Global Sensitivity Analysis of Mathematical Models
Author: An Dela; Blerta Shtylla; Lisette de Pillis

## Intro
We present a multi-method framework that incorporates three global sensitivity analysis methods: two variance-based methods (DeFAST and Sobol’s method) and one derivative-based method. Parameters that all three methods uniformly rank as highly significant can reasonably be considered to have the greatest impact on model output.

In MultiGSA we demonstrate the full methodology and workflow using two example mathematical models of increasing complexity. These models include HIV progression and cancer growth. The computational framework we provide generates graphics for visualizing and comparing the results of all three sensitivity analysis algorithms (DGSM, Sobol, and DeFAST).

This repository contains 2 directories associated with the two mathematical model examples that we discuss in the manuscript. Each directory contains the following folders: 
1.	Figures: Generate figures of ranking of important parameters by each method (DGSM, Sobol, and DeFAST) as reported in the manuscript. The analysis is done based on the pre-generated data in this study. 
2.	DeFAST, DGSM, SobolMethod folders: implementation of each method (DGSM, DeFAST, Sobol) is to help reproduce our results. 

## Reproducing results and figures in the manuscript
1.	Pre-simulated results are stored as .mat file under Figures folder of each model (E.g. https://github.com/an-do/DeFAST/tree/main/HIVmodel/Figures). To consolidate all figures for each model as reported in the manuscript, please excute combine_methods_fig.m. 
2.	To reproduce analysis figures as illustrated in the manuscript for any particular method, for example, DeFAST, please visit DeFAST_HIV_figures (or DeFAST_Cancer_figures) folder and execute the function DeFAST_HIV_figs.m (or DeFAST_Cancer_figs.m). 
3.	Please note, all figures generated from the Figures folder are based on the pre-simulated data. To reproduce all simulations and calculations, please visit the following folder: DGSM, DeFAST or SobolMethod and execute following functions:
    - DeFAST_Cancer_main.m or DeFAST_HIV_main.m: DeFAST study for cancer and HIV model
    - DGSM_Cancer_main.m or DGSM_HIV_main.m study for cancer and HIV model
    - Sobol_Cancer_main.m or Sobol_HIV_main.m: Sobol’s method study for cancer and HIV model

Overview of the repo: 
![repo_overview](https://user-images.githubusercontent.com/20584697/122489268-1aff9900-cf94-11eb-8f63-c20b665bec6e.png) 



