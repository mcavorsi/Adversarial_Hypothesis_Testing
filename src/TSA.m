function [D_TSA,D_oblivious,D_nom,time_TSA] = TSA(gamma_t,pt,y,alpha,t,N,p1,P_FA_L,P_MD_L,q_M,q_L)

% TSA Function that implements the Two Stage Approach (TSA) for a given
% threshold value, gamma_t, assuming a Bernoulli distribution for the trust values, alpha.
% Function also computes the Oblivious FC and Oracle FC decisions

% Description of inputs:

% gamma_t - threshold value used in the first stage of the Two Stage Approach
% pt - the FC trusts a robot with probability pt if the Likelihood Ratio Test yields an equality
% y - N x 1 vector of sensor measurements
% alpha - N x 1 vector of trust values (since a Bernoulli distribution is assumed, each entry in alpha should be a 0 or a 1)
% t - N x 1 vector of the true robot trustworthiness (t(i) = 1 if the robot is legitimate and t(i) = 0 otherwise. Used for the Oracle FC)
% N - the number of robots in the system (legitimate and malicious)
% p1 - the probability of the event occuring (Xi = 1)
% P_FA_L - the probability of false alarm for a legitimate robot
% P_MD_L - the probability of missed detection for a legitimate robot
% q_M - the probability of obtaining a trust value that is 1 when the respective robot is malicious
% q_L - the probability of obtaining a trust value that is 1 when the respective robot is legitimate

% Description of Outputs:

% D_TSA - the binary decision of the FC after running the Two Stage Approach with the given input parameters
% D_oblivious - the binary decision of the Oblivious FC with the given input parameters
% D_nom - the binary decision of the Oracle FC with the given input parameters
% time_TSA - the time required to run one instance of the Two Stage Approach with the given input parameters

    %choose who to trust
    gam_t_tilde = log(gamma_t*((1-q_M)/(1-q_L)))/log((q_L*(1-q_M)/(q_M*(1-q_L))));
    t_hat = zeros(1,N); % t_hat represents the vector of trust estimates
    for i = 1:N
        %legitimacy decision TSA
        if alpha(i) > gam_t_tilde
            t_hat(i) = 1;
        elseif alpha(i) < gam_t_tilde
            t_hat(i) = 0;
        else
            t_hat(i) = random('Binomial',1,pt);
        end
    end
    %oblivious FC trusts everybody, nominal case uses only legitimate information
    t_hat_oblivious = ones(1,N); t_hat_nom = t;
    
    %perform decision with trusted sensors
    p0 = 1 - p1;
    gam_FC = p0/p1;
    prod_num = 1; prod_denom = 1;
    prod_num_omn = 1; prod_denom_omn = 1;
    prod_num_naive = 1; prod_denom_naive = 1;

    %TSA
    tic
    for i = 1:N
        if t_hat(i) == 1 %only use trusted sensors information
            prod_num = prod_num*(P_MD_L^(1-y(i)))*((1-P_MD_L)^y(i));
            prod_denom = prod_denom*((1-P_FA_L)^(1-y(i)))*(P_FA_L^y(i));
        end
    end
    
    if prod_num/prod_denom >= gam_FC
        D_TSA = 1;
    else
        D_TSA = 0;
    end
    time_TSA = toc;
    
    % Oracle FC and Oblivious FC
    for i = 1:N
        % Oracle
        if t_hat_nom(i) == 1 %only use trusted sensors information
            prod_num_omn = prod_num_omn*(P_MD_L^(1-y(i)))*((1-P_MD_L)^y(i));
            prod_denom_omn = prod_denom_omn*((1-P_FA_L)^(1-y(i)))*(P_FA_L^y(i));
        end
        % Oblivious
        if t_hat_oblivious(i) == 1 %only use trusted sensors information
            prod_num_naive = prod_num_naive*(P_MD_L^(1-y(i)))*((1-P_MD_L)^y(i));
            prod_denom_naive = prod_denom_naive*((1-P_FA_L)^(1-y(i)))*(P_FA_L^y(i));
        end
    end
    % Oracle decision
    if prod_num_omn/prod_denom_omn >= gam_FC
        D_nom = 1;
    else
        D_nom = 0;
    end
    % Oblivious decision
    if prod_num_naive/prod_denom_naive >= gam_FC
        D_oblivious = 1;
    else
        D_oblivious = 0;
    end
    
end

