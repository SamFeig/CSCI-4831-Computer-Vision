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
function [dColor] = displayDMap(disparityMap)

    %1. map disparity into the range [0,1]
    % max_d = maximum calculated value of disparity
    maxD = max(disparityMap, [], 'all');
    % min_d = minimum calculate value of disparity
    minD = min(disparityMap, [], 'all');
    
    % scale disparity values by subtracting min_d and dividing by
    % difference between max_d and min_d
    disparityMap = disparityMap-minD;
    disparityMap = disparityMap / (maxD-minD);
    
    %2. Colorize occluded pixels to be red. 
    % dColor = color image where RGB layer is equal to scaled disparity
    % matrix.
    dColor = repmat(disparityMap, 1, 1, 3);
    
    [rows, cols,~] = size(dColor);
    % find the position indices where each of the 3 values of dColor is
    % equal to NaN, store them in a variable. 
    % replace the values of these positions with dColor(at position in R
    % layer) = 1.
    % dColor (at position in G layer) = 0;
    % dColor (at position in B layer) = 0;
    for r = 1:rows
        for c = 1:cols
            if isnan(dColor(r,c,:))
                dColor(r,c,1) = 1;
                dColor(r,c,2) = 0; 
                dColor(r,c,3) = 0;
            end     
        end
    end
   
    %3. Display Color image using imshow.
    imshow(dColor);

end