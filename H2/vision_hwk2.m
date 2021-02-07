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
outImg = warp1(H, img1, img2, 0);

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

% imwrite(outImg, 'Task4-1_Result.jpg');


%% Task 4.2: Two Additional Mosaics

% Mosaic of mountains in Colorado Springs (photos taken by Vlad)
img1 = imread("Mountains0.jpg");
img2 = imread("Mountains1.jpg");

% Scaling both images to reduce computation time
img1 = imresize(img1, .25);
img2 = imresize(img2, .25);

% Uncomment the two lines below to re-pick points on image
% points = getPoints(img1, img2, 10);
% save('points_mountains.mat', 'points')
load('points_mountains.mat', 'points')

H = computeH(points);
outImg = warp1(H, img1, img2, 0);

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

imwrite(outImg, 'Task4-2_Result1.jpg');

% Mosaic of landscape in Arizona (photos taken by Sam)
img1 = imread("Arizona0.jpg");
img2 = imread("Arizona1.jpg");

% Scaling both images to reduce computation time
img1 = imresize(img1, .25);
img2 = imresize(img2, .25);

% Uncomment the two lines below to re-pick points on image
% points = getPoints(img1, img2, 10);
% save('points_arizona.mat', 'points')
load('points_arizona.mat', 'points')

H = computeH(points);
outImg = warp1(H, img1, img2, 0);

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

% imwrite(outImg, 'Task4-2_Result2.jpg');


%% Task 4.3: Frame Region

% Billboard image from https://www.marketingdonut.co.uk/sites/default/files/why-classic-billboards-are-here-to-stay_656163292.jpg
img1 = imread("Billboard.jpg");
% Cat image (photo taken by Vlad)
img2 = imread("Cat.jpg");

% Scaling both images to reduce computation time
% img1 = imresize(img1, .25);
img2 = imresize(img2, .25);

% Uncomment the two lines below to re-pick points on image
% points = getPoints(img1, img2, 4);
% save('points_frame.mat', 'points')
load('points_frame.mat', 'points')

H = computeH(points);

% Call warp with frame = 1 to put cat image into billboard frame
outImg = warp1(H, img1, img2, 1);

figure
subplot(1, 3, 1)
imagesc(img1);
subplot(1, 3, 2)
imagesc(img2);
subplot(1, 3, 3)
imagesc(outImg);

% imwrite(outImg, 'Task4-3_Result.jpg');

