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

img1 = imread("Square0.jpg");
img2 = imread("Square1.jpg");

% points = getPoints(img1, img2, 10);
% save('points_square.mat', 'points')
load('points_square.mat', 'points')


H = computeH(points);

Hinv = inv(H);
newPoints = zeros(10,3);

for i = 1:10
    newPoints(i, :) = H \ [points(i, 3); points(i, 4); 1];
    newPoints(i, :) = newPoints(i, :) / newPoints(i, 3);
end

[m, n, ~] = size(img2);
[X, Y] = meshgrid(1:n, 1:m);

figure(1)
imagesc(img1)
hold on
title('Transformed Points')

% Plot previously selected points
plot(points(:, 2), points(:, 1), '.m', 'MarkerSize', 10)
plot(newPoints(:, 2), newPoints(:, 1), '.g', 'MarkerSize', 10)
hold off

figure(2)
outImg = warp1(H, img1, img2);
imagesc(outImg)









%% Task 4

