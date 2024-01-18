function [D_Base] = Baseline_FC(y_hist,D_hist,T,eta,p1,P_FA_L,P_MD_L)

% Function that implements the Baseline approach for a given time history T
% and threshold value, eta.

% Description of inputs:

% y_hist - n x N matrix of previous measurements (N columns, 1 for each robot, and n rows corresponding to n previous measurements)
% D_hist - matrix of previous FC decisions to compare against sensor measurements to determine trust
% T - number of past measurements and decisions to use (how far back in the history to go)
% eta - trust threshold (trust a robot if its measurement disagreed with the FC decision less than eta times)
% p1 - the probability of the event occuring (Xi = 1)
% P_FA_L - the probability of false alarm for a legitimate robot
% P_MD_L - the probability of missed detection for a legitimate robot

% Description of Outputs:

% D_base - the binary decision of the FC after running the Baseline Approach with the given input parameters

    N = size(y_hist,2);
    t_hat = zeros(1,N);
    y = y_hist(size(y_hist,1),:);
    
    %choose who to trust
    if size(y_hist,1) > T %use last T measurements to determine reputation
        for i = 1:N
            eta_i = 0; count = 1;
            for j = size(y_hist,1)-T:size(y_hist,1)-1
                if D_hist(count,i) ~= y_hist(j,i)
                    eta_i = eta_i + 1; %increment eta_i if sensor i measurement disagrees with decision made by FC
                end
                count = count + 1;
            end
            if eta_i < eta %trust sensor i if it mostly agreed with the FC
                t_hat(i) = 1;
            end
        end
    else %trust everyone
        t_hat = ones(1,N);
    end
    
    %perform decision with trusted sensors
    p0 = 1 - p1;
    gam_FC = p0/p1;
    prod_num = 1; prod_denom = 1;
    for i = 1:N
        if t_hat(i) == 1 %only use trusted sensors information
            prod_num = prod_num*(P_MD_L^(1-y(i)))*((1-P_MD_L)^y(i));
            prod_denom = prod_denom*((1-P_FA_L)^(1-y(i)))*(P_FA_L^y(i));
        end
    end
    
    if prod_num/prod_denom >= gam_FC
        D_Base = 1;
    else
        D_Base = 0;
    end
    
end

