%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 1
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ outImg ] = redFilter(inImg, redVal)
    outImg = inImg;
    
    % Calculate indices for each third of the image
    width = size(inImg, 2);
    mid1 = round(width / 3);
    mid2 = round(2 * width / 3);
   
    % The left 1/3 is the grayscale version of the original image
    grayscale = luminance_L(inImg(:, 1:mid1, :));
    
    % The green and blue components share remaining weight
    gbVal = (1 - redVal) / 2;
    
    % The right 1/3 of the image will have a red filter applied
    redFilter = redVal * inImg(:, mid2:width, 1) + gbVal * inImg(:, mid2:width, 2) + gbVal * inImg(:, mid2:width, 3);
    
    % Map filtered values to each color pixel in the image
    for k = 1:size(inImg, 3)
        outImg(:, 1:mid1, k) = grayscale;
        outImg(:, mid2:width, k) = redFilter;
    end
end