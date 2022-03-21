# Multi-method Global Sensitivity Analysis of Mathematical Models
Author: An Dela; Blerta Shtylla; Lisette de Pillis

## Intro
We present a multi-method framework that incorporates three global sensitivity analysis methods: two variance-based methods (MeFAST and Sobol’s method) and one derivative-based method. We demonstrate the full methodology and workflow using two example mathematical models including HIV progression and cancer growth. The computational framework we provide generates graphics for visualizing and comparing the results of all three sensitivity analysis algorithms (DGSM, Sobol, and MeFAST).

This repository contains 2 directories associated with the two mathematical model examples that we discuss in the manuscript. Each directory contains the following folders: 
1.	Figures: Generate figures of ranking of important parameters by each method (DGSM, Sobol, and MeFAST) as reported in the manuscript. The analysis is done based on the pre-generated data in this study. 
2.	MeFAST, DGSM, SobolMethod folders: implementation of each method (DGSM, MeFAST, Sobol) is to help reproduce our results. 

## Reproducing results and figures in the manuscript
1.	Pre-simulated results are stored as .mat file under Figures folder of each model. To consolidate all figures for each model as reported in the manuscript, please excute combine_methods_fig.m. 
2.	To reproduce analysis figures as illustrated in the manuscript for any particular method, for example, MeFAST, please visit MeFAST_HIV_figures (or MeFAST_Cancer_figures) folder and execute the function MeFAST_HIV_figs.m (or MeFAST_Cancer_figs.m). 
3.	Please note, all figures generated from the Figures folder are based on the pre-simulated data. To reproduce all simulations and calculations, please visit the following folder: DGSM, MeFAST or SobolMethod and execute following functions:
    - MeFAST_Cancer_main.m or MeFAST_HIV_main.m: MeFAST study for cancer and HIV model
    - DGSM_Cancer_main.m or DGSM_HIV_main.m study for cancer and HIV model
    - Sobol_Cancer_main.m or Sobol_HIV_main.m: Sobol’s method study for cancer and HIV model

Overview of the repo: 
![repo_overview]


![This is an image](https://github.com/an-do/DeFAST/blob/main/repo_overview.pdf) 
