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
function [ outImg ] = invert_L(inImg)
    outImg = inImg;
    
    % Loop through each value in the image
    for i = 1:size(inImg, 1)
        for j = 1:size(inImg, 2)
            for k = 1:size(inImg, 3)
                % Invert each pixel value
                outImg(i, j, k) = 255 - inImg(i, j, k);
            end
        end
    end
end