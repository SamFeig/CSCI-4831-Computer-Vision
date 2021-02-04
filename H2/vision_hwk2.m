%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 2
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc;

%% Task 1 Getting Correspondences
img1 = imread("Square0.jpg");
img2 = imread("Square1.jpg");

% points = getPoints(img1, img2);
% save('points.mat', 'points')
load('points.mat', 'points')


%% Task 2 Computing the Homography Parameters
H = computeH(points, 10);

Hinv = inv(H);
newPoints = zeros(10,3);

for i = 1:10
    newPoints(i, :) = H \ [points(i, 3); points(i, 4); 1];
    newPoints(i, :) = newPoints(i, :) / newPoints(i, 3);
end

imagesc(img1)
hold on
title('Transformed Points')

% Plot previously selected points
plot(points(:, 2), points(:, 1), '.m', 'MarkerSize', 10)
plot(newPoints(:, 2), newPoints(:, 1), '.g', 'MarkerSize', 10)
hold off

outImg = warp1(H, img1, img2);
imagesc(outImg)

%% Task 3 Warping images to produce the output mosaic








%% Task 4

