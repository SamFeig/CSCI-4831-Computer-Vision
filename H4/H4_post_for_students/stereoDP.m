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
function [disparityRow] = stereoDP(e1, e2, maxDisp, occ)
    %% Part A: Disparity Matching along epipolar lines
    N = size(e1, 2);
    len = N + 1;
    
    % D: Cost matrix
    D = zeros(len, len);
    
    % dir: Direction matrix
    %   North = 1
    %   West = 2
    %   Northwest = 3
    dir = zeros(len, len);
    
    
    % Initialize D(i, 0) and D(0, i) = i * occ
    for i = 1:len
       D(1, i) = i * occ;
       D(i, 1) = i * occ;
       
       dir(i, 1) = -1;
       dir(1, i) = -1;
    end
    

    for i = 2:len
        for j = 2:len
            if i == 2 && j == 2 
                % d_11
                D(i, j) = (e1(i - 1) - e2(j - 1)) ^ 2; 
                % Northwest
                dir(i, j) = 3;
            else
                % Calculate all 3 possible directions
                north = D(i - 1, j) + occ;
                west = D(i, j - 1) + occ;
                northwest = D(i - 1, j - 1) + (e1(i - 1) - e2(j - 1)) ^ 2;
                % Assign min cost to D, and corresponding direction index
                % to dir.
                [D(i, j), dir(i, j)] = min([north, west, northwest]);
            end
        end
    end
    
    %% Part B: Backtracking
    disparityRow = NaN(1, N);
    
    i = len;
    j = len;
    
    while i > 1 && j > 1
        % North
        if dir(i, j) == 1
            i = i - 1;
        % West
        elseif dir(i, j) == 2
            j = j - 1;
        % Northwest
        else            
            disparityRow(i - 1) = abs(i - j);
            if disparityRow(i - 1) > maxDisp
                disparityRow(i - 1) = maxDisp;
            end
            
            i = i - 1;
            j = j - 1;
        end
    end
end

