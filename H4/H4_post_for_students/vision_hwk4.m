%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 4
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code from DepthEstimationFromStereoVideoExample.m
% Load the Parameters of the Stereo Camera
% Load the |stereoParameters| object, which is the result of calibrating the 
% camera using either the |stereoCameraCalibrator| app or the |estimateCameraParameters| 
% function.
close all;
clear all;
clc;

% Load the stereoParameters object.
load('handshakeStereoParams.mat');

% Create System Objects for reading and displaying the video.

videoFileLeft = 'handshake_left.avi';
videoFileRight = 'handshake_right.avi';

readerLeft = vision.VideoFileReader(videoFileLeft, 'VideoOutputDataType', 'uint8');
readerRight = vision.VideoFileReader(videoFileRight, 'VideoOutputDataType', 'uint8');
player = vision.DeployableVideoPlayer('Location', [20, 400]);

% Read and Rectify Video Frames
% The frames from the left and the right cameras must be rectified in order 
% to compute disparity and reconstruct the 3-D scene. Rectified images have horizontal 
% epipolar lines, and are row-aligned. This simplifies the computation of disparity 
% by reducing the search space for matching points to one dimension. Rectified 
% images can also be combined into an anaglyph, which can be viewed using the 
% stereo red-cyan glasses to see the 3-D effect.

frameLeft = readerLeft.step();
frameRight = readerRight.step();

[frameLeftRect, frameRightRect] = ...
    rectifyStereoImages(frameLeft, frameRight, stereoParams);

% Uncomment to show rectified video frames
% figure
% imshow(stereoAnaglyph(frameLeftRect, frameRightRect));
% title('Rectified Video Frames');

frameLeftGray  = rgb2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);
%% Task 1: Calculate disparity using SSD Algorithm

disparityMapML = disparity(frameLeftGray, frameRightGray);

disparityMap1 = disparitySSD(frameLeftGray, frameRightGray, 1);
disparityMap3 = disparitySSD(frameLeftGray, frameRightGray, 3);
disparityMap5 = disparitySSD(frameLeftGray, frameRightGray, 5);

figure
subplot(2, 2, 1)
imshow(disparityMapML, [0, 64]);
title('Disparity Map Matlab') 
colormap jet
colorbar
subplot(2, 2, 2)
imshow(disparityMap1, [0, 64]);
title('Disparity SSD Window Size 1')
colormap jet
colorbar
subplot(2, 2, 3)
imshow(disparityMap3, [0, 64]);
title('Disparity SSD Window Size 3')
colormap jet
colorbar
subplot(2, 2, 4)
imshow(disparityMap5, [0, 64]);
title('Disparity SSD Window Size 5')
colormap jet
colorbar
% saveas(gcf,'Q1_disparityMap.jpg')

%% Task 2: Uniqueness Constraint
disparityMapUnique = disparitySSDUnique(frameLeftGray, frameRightGray, 3);

figure
imshow(disparityMapUnique, [0, 64]);
title('Disparity Map Unique Constraint') 
colormap jet
colorbar
%% Task 3: Disparity Smoothness Constraint

%% Task 4: Generate Outliers Map
disparityMap3RL = disparitySSD(frameRightGray, frameLeftGray, 3);
disparityMap5RL = disparitySSD(frameRightGray, frameLeftGray, 5);

figure
subplot(2, 2, 1)
imshow(disparityMap3, [0, 64]);
title('SSD Window Size 3 LR')
colormap jet
colorbar
subplot(2, 2, 2)
imshow(disparityMap3RL, [0, 64]);
title('SSD Window Size 3 RL') 
colormap jet
colorbar
subplot(2, 2, 3)
imshow(disparityMap5, [0, 64]);
title('SSD Window Size 5 LR')
colormap jet
colorbar
subplot(2, 2, 4)
imshow(disparityMap5RL, [0, 64]);
title('SSD Window Size RL') 
colormap jet
colorbar

figure
subplot(1, 2, 1)
imshow(detectOutliers(disparityMap3, disparityMap3RL, 1));
title('Outliers SSD Window Size 3')
subplot(1, 2, 2)
imshow(detectOutliers(disparityMap5, disparityMap5RL, 1));
title('Outliers SSD Window Size 5') 
colormap gray
saveas(gcf,'Q4_OutliersMap.jpg')

%% Task 5: Compute Depth from Disparity

% disparityMap = disparity(frameLeftGray, frameRightGray);
disparityMap = disparitySSD(frameLeftGray, frameRightGray, 5);
figure
subplot(1, 2, 1)
imshow(disparityMap);
title('Disparity Map') 
subplot(1, 2, 2)
imshow(reconstructSceneCU(disparityMap, stereoParams));
title('Reconstructed Distances') 
saveas(gcf,'Q5_DistanceMap.jpg')

%% Task 6: Synthetic Stereo Sequences
im2 = imread("./teddy/im2.png");
im6 = imread("./teddy/im6.png");
im2Gray  = rgb2gray(im2);
im6Gray = rgb2gray(im6);
disp2 = disparitySSD(im2Gray, im6Gray, 5);
disp6 = disparitySSD(im6Gray, im2Gray, 5);
% disp2 = disparity(im2Gray, im6Gray);
% disp6 = disparity(im6Gray, im2Gray);
dispTruth2 = imread("./teddy/disp2.png");
dispTruth6 = imread("./teddy/disp6.png");

errors2 = dispTruth2 - uint8(disp6);
errors6 = dispTruth6 - uint8(disp2);

figure
subplot(2, 4, 1)
imshow(im2);
title('Teddy 2 Orig')
subplot(2, 4, 2)
imshow(im6);
title('Teddy 6 Orig') 
subplot(2, 4, 3)
imshow(dispTruth2);
title('Teddy 2 Truth')
% colormap jet
% colorbar
subplot(2, 4, 4)
imshow(dispTruth6);
title('Teddy 6 Truth')
% colormap jet
% colorbar
subplot(2, 4, 5)
imshow(disp2, [0, 64]);
title('Teddy 2 SSD')
colormap gray
% colormap jet
% colorbar
subplot(2, 4, 6)
imshow(disp6, [0, 64]);
title('Teddy 6 SSD')
colormap gray
% colormap jet
% colorbar
subplot(2, 4, 7)
imshow(errors2);
title('Teddy 2 Errors') 
colormap gray
subplot(2, 4, 8)
imshow(errors6);
title('Teddy 6 Errors')
colormap gray
saveas(gcf,'Q5_SyntheticImages.jpg')



%% Task 7: Dynamic Programming
% Commented out because it takes a while to run, uncomment to see dynamic
% programming, or look at `task7.png` to see output.

% disparityMapDP = disparityDP(frameLeftGray, frameRightGray);
% 
% figure
% imshow(displayDMap(disparityMapDP))

