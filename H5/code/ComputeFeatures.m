%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 5
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function features = ComputeFeatures(img)
% Compute a feature vector for all pixels of an image. You can use this
% function as a starting point to implement your own custom feature
% vectors.
%
% INPUT
% img - Array of image data of size h x w x 3.
%
% OUTPUT
% features - Array of computed features for all pixels of size h x w x f
%            such that features(i, j, :) is the feature vector (of
%            dimension f) for the pixel img(i, j, :).

    img = double(img);
    height = size(img, 1);
    width = size(img, 2);
    features = zeros(height, width, 8);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                         %
    %                              YOUR CODE HERE                             %
    %                                                                         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % First three positions are the RGB values of the image
    features(:, :, 1:3) = double(img);
    
    % 4th position is the x-value of the image
    features(:, :, 4) = meshgrid(1:width, 1:height);
    
    % 5th position is the y-value of the image
    features(:, :, 5) = meshgrid(1:height, 1:width)';
    
    % 6th position is binary value if pixel is at an edge
    features(:, :, 6) = edge(rgb2gray(img));
    
    % 7th and 8th positions are x & y directional gradients
    [features(:, :, 7), features(:, :, 8)] = imgradient(rgb2gray(img));
    
end