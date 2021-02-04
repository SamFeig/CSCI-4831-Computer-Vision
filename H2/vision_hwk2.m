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
points = getPoints(img1, img2);


%% Task 2 Computing bh Homography Parameters
[H, minDis] = computeH(points, 10);

Hinv = pinv(H);
newPoints = zeros(10,3);

for i = 1:10
    newPoints(i, :) = H * [points(i, 1); points(i, 2); 1];
    newPoints(i, :) = newPoints(i, :) / newPoints(i, 3);
end

imagesc(img1)
%hold on
title(['Transformed Points'])

% Plot previously selected points
plot(points(:, 1), points(:, 2), '.m', 'MarkerSize', 10)
plot(newPoints(:, 1). newPoints(:, 1), '.g', 'MarkerSize', 10)
     