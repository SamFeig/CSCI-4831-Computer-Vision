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
function [ outImg ] = addRandomNoise_NL(inImg)
    inImg = double(inImg);
    
    % Generate random noise
    noise = randi([-255, 255], size(inImg, 1), size(inImg, 2), size(inImg, 3));
    
    % Add random noise to each pixel and convert back to uint8s
    outImg = uint8(inImg + noise);
end
