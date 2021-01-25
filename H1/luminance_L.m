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
function [ outImg ] = luminance_L(inImg)
    % Apply lumininance formula to convert output image to grayscale
    outImg = .299 * inImg(:, :, 1) + .587 * inImg(:, :, 2) + .114 * inImg(:, :, 3);
end