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

% saveas(gcf,'Q2_disparityUniqueneMap.jpg')

%% Task 3: Disparity Smoothness Constraint
disparityMapSmooth1 = disparitySSDSmooth(frameLeftGray, frameRightGray, 1, .5);
disparityMapSmooth2 = disparitySSDSmooth(frameLeftGray, frameRightGray, 1, .1);


figure
subplot(1,2,1);
imshow(disparityMapSmooth1, [0, 64]);
title('Disparity Map Smoothness Constraint (s = 0.5)') 
colormap jet
colorbar
subplot(1,2,2);
imshow(disparityMapSmooth2, [0, 64]);
title('Disparity Map Smoothness Constraint (s = 0.1)') 
colormap jet
colorbar

% saveas(gcf,'Q3_disparitySmoothnessMap.jpg')

%% Task 4: Generate Outliers Map
disparityMap3 = disparitySSDSmooth(frameLeftGray, frameRightGray, 3, 0.5);
disparityMap5 = disparitySSDSmooth(frameLeftGray, frameRightGray, 5, 0.5);
% disparityMap3RL = disparitySSD(frameRightGray, frameLeftGray, 3);
% disparityMap5RL = disparitySSD(frameRightGray, frameLeftGray, 5);
disparityMap3RL = disparitySSDSmooth(frameRightGray, frameLeftGray, 3, 0.5);
disparityMap5RL = disparitySSDSmooth(frameRightGray, frameLeftGray, 5, 0.5);

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

% saveas(gcf,'Q4_OutliersMap.jpg')

%% Task 5: Compute Depth from Disparity

% disparityMap = disparity(frameLeftGray, frameRightGray);
% disparityMap = disparitySSDUnique(frameLeftGray, frameRightGray, 5);
disparityMap = disparitySSDSmooth(frameLeftGray, frameRightGray, 5, 0.5);
figure
subplot(1, 2, 1)
imshow(disparityMap, [0, 64]);
title('Disparity Map') 
subplot(1, 2, 2)
imshow(reconstructSceneCU(disparityMap, stereoParams));
title('Reconstructed Distances') 

% saveas(gcf,'Q5_DistanceMap.jpg')

%% Task 6: Synthetic Stereo Sequences
im2 = imread("./teddy/im2.png");
im6 = imread("./teddy/im6.png");
im2Gray  = rgb2gray(im2);
im6Gray = rgb2gray(im6);
disp2 = disparitySSDSmooth(im2Gray, im6Gray, 5, 0.5);
disp6 = disparitySSDSmooth(im6Gray, im2Gray, 5, 0.5);

dispTruth2 = imread("./teddy/disp2.png");
dispTruth6 = imread("./teddy/disp6.png");

% errors2 = double(dispTruth2) - disp2;
% errors6 = double(dispTruth6) - disp6;

% Calculate error from truth image
errors2 = dispTruth2 - uint8(disp2);
errors6 = dispTruth6 - uint8(disp6);

figure
subplot(5, 2, 1)
imshow(im2);
title('Teddy 2 Orig')
subplot(5, 2, 2)
imshow(im6);
title('Teddy 6 Orig') 
subplot(5, 2, 3)
imshow(dispTruth2);
title('Teddy 2 Truth')
subplot(5, 2, 4)
imshow(dispTruth6);
title('Teddy 6 Truth')
subplot(5, 2, 5)
imshow(disp2, [0, 64]);
title('Teddy 2 SSD')
colormap gray
subplot(5, 2, 6)
imshow(disp6, [0, 64]);
title('Teddy 6 SSD')
colormap gray
subplot(5, 2, 7)
imshow(errors2, [0, 64]);
title('Teddy 2 Errors') 
colormap gray
subplot(5, 2, 8)
imshow(errors6, [0, 64]);
title('Teddy 6 Errors')
colormap gray
subplot(5, 2, 9)
histogram(errors2, 25);
title('Hist Teddy 2 Errors');
subplot(5, 2, 10)
histogram(errors6, 25);
title('Hist Teddy 6 Errors');

% saveas(gcf,'Q6_SyntheticImages.jpg')



%% Task 7: Dynamic Programming
% Commented out because it takes a while to run, uncomment to see dynamic
% programming, or look at `task7.png` to see output.

% disparityMapDP = disparityDP(frameLeftGray, frameRightGray);
% 
% figure
% imshow(displayDMap(disparityMapDP))

