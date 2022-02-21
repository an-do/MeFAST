

### DGSM algorithm
Derivative-based global measures (DGSM) is a technique, proposed by Kucherenko et al. It involves taking the partial derivatives of the model output with respect to the parameter across the parameter space. 
The sensitivity measures of DGSM involves computing the mean and standard deviation of the distribution of all possible partial derivatives with respect to each parameter within their range of uncertainties. 
There are two sensitivity measures that are derived from DGSM including:
1. The sum of square of the mean and standard deviation of the partial derivatives, namely Gi
2. The ratio between the mean and the standard deviation.

The algorithm is illustrated in the diagram below:

![derivative_scheme](https://user-images.githubusercontent.com/20584697/122826650-3fab8780-d298-11eb-8939-e581599349f8.png)
