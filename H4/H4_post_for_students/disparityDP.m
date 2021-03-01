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
function [disparityMap] = disparityDP(frameLeftGray, frameRightGray, windowSize)
    % Convert both frames to doubles so that SSDs can be calculated
    % accurately
    frameLeftGray = im2double(frameLeftGray);
    frameRightGray = im2double(frameRightGray);
    
    % Get image size and initialize disparity map to default zero
    [m, n] = size(frameLeftGray);
    disparityMap = zeros(m, n);
    
    % Calculate window width, gaussian weight matrix
    windowWidth = floor(windowSize / 2);
    gaussWeights = fspecial('gaussian', windowSize, 1);
    
    % Maximum disparity value & occlusion cost
    maxDisp = 64;
    occ = 0.01;
    
    % Loop over every pixel in the image
    for i = 1:m
        for j = 1:n
            
            
            
            
        end
        
    end
    


end

