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
function [ outImg ] = famousMe( inImg, famousImg, factor, n, m)
    % Scale image to proper size
    famousImg = scaleBilinear(famousImg, factor);
    % Mask image
    famousMask = binaryMask(famousImg);
      
    outImg = inImg;
    
    % Place famousImg in inImg starting at location n,m
    for i = 1:size(famousImg, 1)
        for j = 1:size(famousImg, 2)
            if famousMask(i, j)
                outImg(n + i, m + j, :) = famousImg(i, j, :);
            end   
        end
    end
end

