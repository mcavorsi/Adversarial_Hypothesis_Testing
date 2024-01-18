# Adversarial_Hypothesis_Testing
Code repository for the functions used in the experiments in the paper "[Exploiting Trust for Resilent Hypothesis Testing with Malicious Robots](https://arxiv.org/pdf/2303.04075.pdf)" by Matthew Cavorsi, Orhan Eren Akgün, Michal Yemini, Andrea J. Goldsmith, and Stephanie Gil [1].


<img src="https://github.com/mcavorsi/Adversarial_Hypothesis_Testing/blob/main/figure.png" width="750">

The experiment is described in detail in the paper, but code pieces that would be useful for recreating or running similar experiments can be found in the src folder of this repository. Descriptions for each code file are included below:
* TSA.m - This is a MATLAB script that performs binary hypothesis testing using the Two Stage Approach (2SA) algorithm described in [1]. It also implements the strategy for the Oblivious FC and the Oracle FC.
* GLRT_fn.m - This is a MATLAB script that performs binary hypothesis testing using the Adversarial Generalized Likelihood Ratio Test (A-GLRT) algorithm described in [1].
* Baseline_FC.m - This is a MATLAB script that performs binary hypothesis testing using the Baseline Approach described in [1] from the work in [2].

Trust values are found by using the opensource toolbox in [3] to analyze the similarity between different fingerprints from communicated WiFi signals to detect spoofed transmissions using the methods described in [4]. The opensource toolbox can be found here: https://github.com/Harvard-REACT/WSR-Toolbox

References:

[1] M. Cavorsi, O. E. Akgün, M. Yemini, A. J. Goldsmith, and S. Gil, “Exploiting trust for resilient hypothesis testing with malicious robots”, in 2023 IEEE International Conference on Robotics and Automation (ICRA), 2023, pp. 7663–7669.

[2] A. S. Rawat, P. Anand, H. Chen, and P. K. Varshney, “Collaborative spectrum sensing in the presence of byzantine attacks in cognitive radio networks,” IEEE Transactions on Signal Processing, vol. 59, no. 2, pp. 774–786, 2010.

[3] N. Jadhav, W. Wang, D. Zhang, S. Kumar, and S. Gil, “Toolbox release: A wifi-based relative bearing sensor for robotics,” ArXiv, vol. abs/2109.12205, 2021.

[4] S. Gil, S. Kumar, M. Mazumder, D. Katabi, and D. Rus, “Guaranteeing spoof-resilient multi-robot networks,” AuRo, p. 1383–1400, 2017.
