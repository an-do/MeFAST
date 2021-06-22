# Cancer model

L. G. de Pillis, A. E. Radunskaya, C. L. Wiseman, A validated mathematical model of cell-mediated immune response to tumor growth, Cancer research 65 (17) (2005) 7950–7958

# Description
The model describes the cell-mediated immune response to the tumor growth. It focuses on the role of natural killer (NK) and CD8+ T cells in tumor surveillance. 
The model describes the dynamics of the following species: 1) tumor cells (T), 2) Natural killer (NK) cells (N), 3) CD8+ T cells (L). 

The initial conditions are: T(0) = 0.1 * 10^5, N(0)=0.003 * 10^5 ,L(0)=0 cells. 

The model is given below: 
![Cancer](https://user-images.githubusercontent.com/20584697/122597919-eede2980-d020-11eb-96e2-e8d2b1a721ae.png)

# Objective goal
There are 15 parameters in the model, whose ranges of uncertainties are discussed in the manuscript. Our primary goal is to find which parameters are important to the cancer volume so we can focus in finding better estimates. We implemented 3 methods: 
1. DeFAST
2. Sobol's method
3. Derivative global sensitivity measure. 
 
# Result

# Reference 
de Pillis, Lisette G., Ami E. Radunskaya, and Charles L. Wiseman. "A validated mathematical model of cell-mediated immune response to tumor growth." Cancer research 65.17 (2005): 7950-7958.
