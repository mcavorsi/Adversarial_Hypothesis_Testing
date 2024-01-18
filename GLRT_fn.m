function [decision] = GLRT_fn(measurements,alpha_vec,p_H1,p_FA_l,p_MD_l,p_fa_alpha,p_md_alpha)
% Arguments: measurements: A vector of measurements coming from sensors
%            alpha_vec: A vector of stochastic trust values 
%            p_H1: Prior probability of the event
%            p_FA_l: Probability of false alarm for legitimate sensors
%            p_MD_l: Probability of misdetection for legitimate sensors
%            the P_FA_M and P_MD_M. Otherwise, these values are estimated.
%            p_fa_alpha: P(alpha=1|true legitimacy=0)
%            p_md_alpha: P(alpha=0|true legitimacy=1)
% Returns:   decision
N = length(measurements);
p_H0 = 1-p_H1;
gamma = log(p_H0/p_H1);

 % create a list of possible p_fa_m and p_md_m values:
total_ones = sum(measurements);
total_zeros = N-total_ones;
p_fa_list = [];
p_md_list = [];

counter=1;
for i=1:total_ones
    for j=i:i+total_zeros
        p_fa_list(counter) = i/j;
        counter = counter+1;
    end
end
p_fa_list(counter) = 0+eps;
p_fa_list = p_fa_list(p_fa_list<=1);

counter=1;
for i=1:total_zeros
    for j=i:i+total_ones
        p_md_list(counter) = i/j;
        counter = counter+1;
    end
end
p_md_list(counter) = 0+eps;
p_md_list = p_md_list(p_md_list<=1);

for i=1:length(p_fa_list)
    if p_fa_list(i)==1
        p_fa_list(i) = p_fa_list(i)-eps;
    end
end

for i=1:length(p_md_list)
    if p_md_list(i)==1
        p_md_list(i) = p_md_list(i)-eps;
    end
end

% maximize the numerator and denominator
num_max = -inf;
denom_max = -inf;
for P_MD_m = p_md_list
    
    % find the maximum of numerator
    lhs_num = (1-alpha_vec)*log(p_md_alpha)+ alpha_vec*log(1-p_md_alpha)...
             + (1-measurements)*log(p_MD_l)+measurements*log(1-p_MD_l);
    rhs_num = alpha_vec*log(p_fa_alpha)+ (1-alpha_vec)*log(1-p_md_alpha)...
             + (1-measurements)*log(P_MD_m)+ measurements*log(1-P_MD_m);
    
    t_num = lhs_num>rhs_num;
    num = sum(lhs_num(t_num))+sum(rhs_num(~t_num));

    if num>num_max
        num_max=num;
    end

end

for P_FA_m = p_fa_list

    % find the maximum of denominator
    lhs_denom = (1-alpha_vec)*log(p_md_alpha)+ alpha_vec*log(1-p_md_alpha)...
             + measurements*log(p_FA_l)+(1-measurements)*log(1-p_FA_l);
    rhs_denom = alpha_vec*log(p_fa_alpha)+ (1-alpha_vec)*log(1-p_md_alpha)...
             + measurements*log(P_FA_m)+(1-measurements)*log(1-P_FA_m);
    
    t_denom = lhs_denom>rhs_denom;
    denom = sum(lhs_denom(t_denom))+sum(rhs_denom(~t_denom));

    if denom>denom_max
        denom_max=denom;
    end
end

% make the decision
difference = round(num_max-denom_max,12);
if difference==gamma
    decision = binornd(1,p_H1);
elseif difference>gamma
    decision=1;
else
    decision=0;
end

end