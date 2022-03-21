# Description 
Run DeFAST_Cancer_main to simulate model output and sensitivity indices for the cancer model. The script calls the following functions: 
- Model_efast: simulating output 
- DeFAST_analysis: computing sensitivity indices 
- Parameter_settings: Table of parameters and ranges as is given in the manuscript
- SETFREQ: sampling frequencies generating function 
- ligandOde: cancer ode model 


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


2. *Resampling size NR.* Due to the symmetry properties of the sampling
functions, parameter samples will eventually repeat. Therefore, to ensure
an adequate sampling, each parameter must be resampled by introducing
a small adjustment to the phase shift φi of the search curve function (4).
The sensitivity indices should be re-computed. This procedure is called a
resampling scheme.  The resampling size NR is the number of times that the scheme repeats. One can increase the number of NR for better statistical power. 

3. The resampling size NR, number of sampling points NS and the maximal frequency ωmax must be chosen to satisfy following equation to guarantee a fair and balanced sampling scheme.

<img width="376" alt="Screen Shot 2021-06-21 at 3 52 55 PM" src="https://user-images.githubusercontent.com/20584697/122837536-19daae80-d2a9-11eb-891d-9a2394304134.png">

4. *Convergence test*. We use the two-sample Komogorov-Smirnov (K-S) test to check for the covergence of sensitivity indices distributions. Specifically, for each NR, we calculate the K-S distance between sampling sensitivity indices distributions of sizes NR and (NR − 1). A distribution is converged if the K-S statistics between the two consecutive distributions is significantly less than 0.05. 

6. *Dummy parameters*. A parameter that does not appear in the model and does not affect the model in anyway is called a "dummy parameter", which should be assigned with zero sensitivity indices. However, MeFAST still assigns it with a small and non-zero values. We utilize the usage of the hypothesis test to determine the significance of parameters. Specifically, we compare the sensitivity indices distribution mean of each model parameter Xi with that of the dummy parameter. If the average sensitivity indices of Xi are significantly less than that of the dummy then it is considered to be insignificant, otherwise it is significant.

5. *Statistical analysis*. We implement 4 statistical tests to determine the significance of parameters including: 
    * Two sample student t-test
    * Wilcoxon rank sum test (or Mann-Whitney U-test)
    * Permutation test
    * ANOVA combining with Tukey procedure.
    
When multiple pairwise hypothesis tests such as student t-test, Wilcoxon, Permutation test are carried out, the likelihood of incorrectly rejecting a null hypothesis (Type 1 error) also increases. The Bonferroni correction is needed to control for occurrence of false positives. Specifically, the critical p-value needs to be divided by the number of hypotheses tests perform. 

Below is the overall MeFAST scheme: 


![efast_algorithm](https://user-images.githubusercontent.com/20584697/122826422-f8bd9200-d297-11eb-989a-4f01365e5229.png)
