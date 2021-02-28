%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 4
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outImg] = detectOutliers(D_LR, D_RL, T_LR)
    [m, n] = size(D_LR);
    outImg = zeros(m, n);
    
    for i=1:m
        for j=1:n
%           If outlier, set pixel value to 1
            if abs(D_LR(i,j) - D_RL(i ,j)) > T_LR
                outImg(i,j) = 1;
            end
        end
    end
end