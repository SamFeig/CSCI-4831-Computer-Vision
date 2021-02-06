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

%% Task 4.1: Mosiac of Provided Image
img1 = imread("Square0.jpg");
img2 = imread("Square1.jpg");

% Uncomment the two lines below to re-pick points on image
% points = getPoints(img1, img2, 10);
% save('points_square.mat', 'points')
load('points_square.mat', 'points')

H = computeH(points);

newPoints = zeros(10,3);
for i = 1:10
    newPoints(i, :) = H \ [points(i, 3); points(i, 4); 1];
    newPoints(i, :) = newPoints(i, :) / newPoints(i, 3);
end

figure
imagesc(img1)
hold on
title('Transformed Points')
plot(points(:, 2), points(:, 1), '.m', 'MarkerSize', 10)
plot(newPoints(:, 2), newPoints(:, 1), '.g', 'MarkerSize', 10)
hold off

outImg = warp1(H, img1, img2);

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

%% Task 4.2: Two Additional Mosaics

% Mosaic of mountains in Colorado Springs (photos taken by Vlad)
img1 = imread("Mountains0.jpg");
img2 = imread("Mountains1.jpg");

img1 = imresize(img1, .25);
img2 = imresize(img2, .25);

% Uncomment the two lines below to re-pick points on image
% points = getPoints(img1, img2, 10);
% save('points_mountains.mat', 'points')
load('points_mountains.mat', 'points')

H = computeH(points);
outImg = warp1(H, img1, img2);

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

% Mosaic of landscape in Arizona (photos taken by Sam)
img1 = imread("Arizona0.jpg");
img2 = imread("Arizona1.jpg");

img1 = imresize(img1, .25);
img2 = imresize(img2, .25);

% Uncomment the two lines below to re-pick points on image
% points = getPoints(img1, img2, 10);
% save('points_arizona.mat', 'points')
load('points_arizona.mat', 'points')

H = computeH(points);
outImg = warp1(H, img1, img2);

newPoints = zeros(10,3);
for i = 1:10
    newPoints(i, :) = H \ [points(i, 3); points(i, 4); 1];
    newPoints(i, :) = newPoints(i, :) / newPoints(i, 3);
end

figure
imagesc(img1)
hold on
title('Transformed Points')
plot(points(:, 2), points(:, 1), '.m', 'MarkerSize', 10)
plot(newPoints(:, 2), newPoints(:, 1), '.g', 'MarkerSize', 10)
hold off

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

%% Task 4.3: Frame Region

