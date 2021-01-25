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
function [ outImg ] = makeBright_NL(inImg, brightness)
    % Add brightness to each pixel value in the image
    outImg = inImg + brightness;
end