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
1.	If you would like to reproduce combine ranking result as in the manuscript, please go to either HIV or Cancer model directory, under Figures folder, call the function combine_methods_fig.m. 
2.	If you would like to reproduce the ranking result for any particular method, for example, DeFAST, also under Figures folder of either model, please visit DeFAST_HIV_figures (or DeFAST_Cancer_figures) folder and call the function DeFAST_HIV_figs.m (or DeFAST_Cancer_figs.m) to generate DeFAST analysis figure as illustrated in the manuscript. 
3.	Similarly, you can reproduce the ranking result by Sobol’s method and DGSM.
4.	Please note, all figures generated from the Figures folder are based on the pre-simulated data. To reproduce our study, simulations and sensitivity indices, please visit the following folder: DGSM, DeFAST or SobolMethod and call the following functions:
    - DeFAST_Cancer_main.m or DeFAST_HIV_main.m: DeFAST study for cancer and HIV model
    - DGSM_Cancer_main.m or DGSM_HIV_main.m study for cancer and HIV model
    - Sobol_Cancer_main.m or Sobol_HIV_main.m: Sobol’s method study for cancer and HIV model

Here is the overview of the repo: 
![repo_overview](https://user-images.githubusercontent.com/20584697/122489268-1aff9900-cf94-11eb-8f63-c20b665bec6e.png) 

## Detailed implementation 

### DeFAST algorithm 
Key steps involved in the DeFAST method can be summarized as following:
1. Sampling parameter values using sinusoidal search curves.
2. Generate sampling matrix.
4. Estimate the full set of first and total-order sensitivity indices.
5. Resampling scheme. Repeat this process NR number of times with respect
to each parameter.

#### Algorithm parameters 
1. *Sampling frequencies for search curves*. Parameters values are sampled via Fourier transformation functions (namely, search curves). We use the following functions: 
<img width="699" alt="Screen Shot 2021-06-21 at 3 24 45 PM" src="https://user-images.githubusercontent.com/20584697/122835243-daaa5e80-d2a4-11eb-952b-bddb8f17b8bf.png">

where: 
* s is a random variable uniformly distributioned between (−π,π),
* * F^(−1)(·) is the parameter’s inverse cumulative distribution function. We chose uniform distribution because we do not know specific information about the model parameters’
distributions.
* ωi and φi are the function’s frequency and phase shift, respectively. 

Equation (4) generates a uniform sample between [0,1], which equation (5) uses as an input to generate a sampling value for Xi within the range of uncertainty.

The sampling curves frequencies are the critical components of the scheme, which are used to estimate the partial variance contributed by the parameter Xi and the complementary parameters X∼i. A list of frequencies is pregenerated as proposed by Saltelli et al. that must satisfy the following conditions: 
    * The highest frequency ωmax is be assigned to the parameter of interest $X_i$ while the lower ones are assigned to the remaining parameters. 
    * There has to be a significant difference in magnitude between ωmax and other frequencies to avoid the problem of interference. 


2. *Resampling scheme* Due to the symmetry properties of the sampling
functions, parameter samples will eventually repeat. Therefore, to ensure
an adequate sampling, each parameter must be resampled by introducing
a small adjustment to the phase shift φi of the search curve function (4).
The sensitivity indices should be re-computed. This procedure is called a
resampling scheme.  The resampling size NR is the number of times that the scheme repeats. One can increase the number of NR for better statistical power. 

3. The resampling size NR, number of sampling points NS and the maximal frequency ωmax must be chosen to satisfy equation 12 to guarantee a fair and balanced sampling scheme.

<img width="376" alt="Screen Shot 2021-06-21 at 3 52 55 PM" src="https://user-images.githubusercontent.com/20584697/122837536-19daae80-d2a9-11eb-891d-9a2394304134.png">

4. *Convergence test*. We use the two-sample Komogorov-Smirnov (K-S) test to check for the covergence of sensitivity indices distributions. Specifically, for each NR, we calculate the K-S distance between sampling sensitivity indices distributions of sizes NR and (NR − 1). A distribution is converged if the K-S statistics between the two consecutive distributions is significantly less than 0.05. 

6. *Dummy parameters*. A parameter that does not appear in the model and does not affect the model in anyway is called a "dummy parameter", which should be assigned with zero sensitivity indices. However, eFAST still assigns it with a small and non-zero values. We utilize the usage of the hypothesis test to determine the significance of parameters. Specifically, we compare the sensitivity indices distribution mean of each model parameter Xi with that of the dummy parameter. If the average sensitivity indices of Xi are significantly less than that of the dummy then it is considered to be insignificant, otherwise it is significant.

5. *Statistical analysis*. We implement 4 statistical tests to determine the significance of parameters including: 
    * Two sample student t-test
    * Wilcoxon rank sum test (or Mann-Whitney U-test)
    * Permutation test
    * ANOVA combining with Tukey procedure.
    
However, when multiple pairwise hypothesis tests are carried out, the likelihood of incorrectly rejecting a null hypothesis (Type 1 error) also increases. The Bonferroni correction is thus employed in conjunction with two sample student t-test, Wilcoxon and Permutation test to control for occurrence of false positives. Specifically, the critical p-value needs to be divided by the number of hypotheses tests perform. 


![efast_algorithm](https://user-images.githubusercontent.com/20584697/122826422-f8bd9200-d297-11eb-989a-4f01365e5229.png)

### Sobol's method algorithm 

There are two main steps involved in computing the sensitivity indices: 
1. First, draw sample values for the model parameters. Here, we use Latin
Hypercube sampling (LHS), which is a stratified Monte Carlo sampling scheme
that assigns a distribution for each parameter, partitioning them into N subin-tervals of equal probability then independently sampling without replacement
from each subinterval. 
2. The second step is to calculate the sensitivity indices using the samples generated from LHS, which is adapted from Jansen’s algorithm. 

![Sobol_scheme](https://user-images.githubusercontent.com/20584697/122826524-1db20500-d298-11eb-9ed7-9a3f9b6c90cb.png)

### DGSM algorithm
Derivative-based global measures (DGSM) is a technique, proposed by Kucherenko et al. It involves taking the partial derivatives of the model output with respect to the parameter across the parameter space. 
The sensitivity measures of DGSM involves computing the mean and standard deviation of the distribution of all possible partial derivatives with respect to each parameter within their range of uncertainties. 
There are two sensitivity measures that are derived from DGSM including:
1. The sum of square of the mean and standard deviation of the partial derivatives, namely Gi
2. The ratio between the mean and the standard deviation.

The algorithm is illustrated in the diagram below:

![derivative_scheme](https://user-images.githubusercontent.com/20584697/122826650-3fab8780-d298-11eb-8939-e581599349f8.png)

## References
1.	S. Marino, I. B. Hogue, C. J. Ray, D. E. Kirschner, A methodology for performing global uncertainty and sensitivity analysis in systems biology, Journal of theoretical biology 254 (1) (2008) 178–196.
2.	Saltelli, P. Annoni, I. Azzini, F. Campolongo, M. Ratto, S. Tarantola, Variance based sensitivity analysis of model output. design and estimator for the total sensitivity index, Computer Physics Communications 181 (2) (2010) 259–270.
3.	M. J. Jansen, Analysis of variance designs for model output, Computer Physics Communications 117 (1-2) (1999) 35–43.
4.	Sobol, S. Kucherenko, Derivative based global sensitivity measures, Procedia-Social and Behavioral Sciences 2 (6) (2010) 7745–7746.
5.	S. Perelson, D. E. Kirschner, R. De Boer, Dynamics of hiv infection of cd4+ t cells, Mathematical biosciences 114 (1) (1993) 81–125.
6.	L. DePillis, A. Gallegos, A. Radunskaya, A model of dendritic cell therapy for melanoma, Frontiers in oncology 3.

