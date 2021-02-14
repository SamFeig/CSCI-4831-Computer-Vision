%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 3
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Question 5
clear all;close all;clc;
inImg = imread('peppers.png');

% Apply gaussian smoothing with sigma = 2
gaussianImg = imgaussfilt(inImg,2);


% Apply mean filter from H1 5 times with 3x3 kernal
kernel_size = 3;
N = 5;
outImg = inImg;
for i=1:N
    outImg = meanFilter(outImg, kernel_size);
end

RMSE_gaussian = sqrt(mean((inImg - gaussianImg).^2));
RMSE_mean = sqrt(mean((inImg - outImg).^2));

RMSE = mean(RMSE_gaussian - RMSE_mean, 'all');

figure
subplot(1, 3, 1)
imagesc(inImg);
title('Original Img')  

a =subplot(1, 3, 2);
imagesc(outImg);
title('Repeated Average Smoothed')  

subplot(1, 3, 3)
imagesc(gaussianImg);
title('Gaussian Smoothed')

set(gcf,'Position',[1 1 1000 500])

string = ['Average Difference in RMS Error of all pixels between Gaussian and Average: ' num2str(RMSE)];
annotation(gcf,'textbox',[0.35 0.015 0.35 0.054],'String',string,'FitBoxToText','off', 'EdgeColor', 'none');
saveas(gcf,'Q5_results.jpg')

%% Question 6.A: Corner Detection
clear all;close all;clc;

inImg = imread('cameraman.tif');
% inImg = rgb2gray(inImg);

rotImg = imrotate(inImg, 45);
transImg = imtranslate(inImg, [15, 15]);
scaleImg = imresize(inImg, 0.5);
scaleImg2 = imresize(inImg, 2);

% Original Img
cornersOrig = detectHarrisFeatures(inImg);


corners = detectHarrisFeatures(rotImg);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(rotImg);
title('Rotated Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6A_rot_results.jpg')

% Translated Img
corners = detectHarrisFeatures(transImg);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(transImg);
title('Translated Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6A_trans_results.jpg')

% Scaled 1/2x Img
corners = detectHarrisFeatures(scaleImg);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(scaleImg);
title('Scaled 1/2x Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6A_scale_results.jpg')

% Scaled 2x Img
corners = detectHarrisFeatures(scaleImg2);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(scaleImg2);
title('Scaled 2x Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6A_scale2_results.jpg')

%% Question 6.B: Corner Detection
clear all;close all;clc;

inImg = imread('cameraman.tif');
% inImg = rgb2gray(inImg);

brightness = 100;
sharpen = 5;

brightImg = inImg + brightness;
darkImg = inImg - brightness;

detail = inImg - meanFilter(inImg, 3);
sharp3Img = inImg + detail * sharpen;

detail = inImg - meanFilter(inImg, 5);
sharp5Img = inImg + detail * sharpen;

% Brightened Img
cornersOrig = detectHarrisFeatures(inImg);


corners = detectHarrisFeatures(brightImg);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(brightImg);
title('Brightened Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6B_bright_results.jpg')

% Darkened Img
corners = detectHarrisFeatures(darkImg);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(darkImg);
title('Darkened Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6B_dark_results.jpg')

% Sharpened 3x3 Img
corners = detectHarrisFeatures(sharp3Img);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(sharp3Img);
title('Sharpened 3x3 Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6B_sharp3_results.jpg')

% Sharpened 5x5 Img
corners = detectHarrisFeatures(sharp5Img);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig.selectStrongest(10));
hold off;
subplot(1, 2, 2)
imagesc(sharp5Img);
title('Sharpened 5x5 Img')
hold on;
plot(corners.selectStrongest(10));
hold off;
colormap gray;
saveas(gcf,'Q6B_sharp5_results.jpg')

%% Question 6.C: Corner Detection
clear all;close all;clc;

% Black background
inImg = zeros(100, 100);
% Add white squre
inImg(25:75, 025:75) = 1;

% 3 varying levels of gaussian noise
% outImg = imnoise(inImg, 'gaussian', 0, 0.05);
% outImg2 = imnoise(inImg, 'gaussian', 0, 0.2);
% outImg3 = imnoise(inImg, 'gaussian', 0, 0.6);

std1 = 0.1;
std2 = 0.5;
std3 = 1;
outImg = inImg + std1 * randn(size(inImg));
outImg2 = inImg + std2 * randn(size(inImg));
outImg3 = inImg + std3 * randn(size(inImg));

cornersOrig = detectHarrisFeatures(inImg).selectStrongest(4);

% Gaussian 1
corners1 = detectHarrisFeatures(outImg).selectStrongest(4);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig);
hold off;
subplot(1, 2, 2)
imagesc(outImg);
title('Gaussian Noise 1')
hold on;
plot(corners1);
hold off;
colormap gray;
saveas(gcf,'Q6C_gaussian1_results.jpg')

% Gaussian 2
corners2 = detectHarrisFeatures(outImg2).selectStrongest(4);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig);
hold off;
subplot(1, 2, 2)
imagesc(outImg2);
title('Gaussian Noise 2')
hold on;
plot(corners2);
hold off;
colormap gray;
saveas(gcf,'Q6C_gaussian2_results.jpg')

% Gaussian 3
corners3 = detectHarrisFeatures(outImg3).selectStrongest(4);

figure
subplot(1, 2, 1)
imagesc(inImg);
title('Original Img')
hold on;
plot(cornersOrig);
hold off;
subplot(1, 2, 2)
imagesc(outImg3);
title('Gaussian Noise 3')
hold on;
plot(corners3);
hold off;
colormap gray;
saveas(gcf,'Q6C_gaussian3_results.jpg')

% Due to weirdness with matching corners/points between runs of Harris, 
% calculate RMSE for every combination of points, and assume the lowest 
% from each row is the coresponding corner detected in the noisy image 
% as matched to the original image corner. 

% RMS Error Estimation 1
RMSE = zeros(4);
for i = 1:size(cornersOrig)
    pt1 = cornersOrig.Location(i, :);
    for j = 1:size(cornersOrig)
        pt2 = corners1.Location(j, :);
        RMSE(i,j) = sqrt(mean((pt1(:)-pt2(:)).^2));
    end
end
RMSE = min(RMSE,[],2);

% RMS Error Estimation 2
RMSE2 = zeros(4);
for i = 1:size(cornersOrig)
    pt1 = cornersOrig.Location(i, :);
    for j = 1:size(cornersOrig)
        pt2 = corners2.Location(j, :);
        RMSE2(i,j) = sqrt(mean((pt1(:)-pt2(:)).^2));
    end
end
RMSE2 = min(RMSE2,[],2);

% RMS Error Estimation 3
RMSE3 = zeros(4);
for i = 1:size(cornersOrig)
    pt1 = cornersOrig.Location(i, :);
    for j = 1:size(cornersOrig)
        pt2 = corners3.Location(j, :);
        RMSE3(i,j) = sqrt(mean((pt1(:)-pt2(:)).^2));
    end
end
RMSE3 = min(RMSE3,[],2);


% xmin = min([RMSE, RMSE2, RMSE3], [], 'all');
% xmax = max([RMSE, RMSE2, RMSE3], [], 'all');
% ymin = min([std1, std2, std3], [], 'all');
% ymax = max([std1, std2, std3], [], 'all');


f = figure
ax = axes('Parent',f);
hold on;
bar([std1 std2 std3], [RMSE, RMSE2, RMSE3]);
title("RMS Error vs Standard Deviation of Noise for Each Corner Point Detected in Images");
ylabel("RMS Error");
xlabel("Gaussian Noise Standard Dev");
set(ax,'XTick',[std1 std2 std3]);
hold off;
saveas(gcf,'Q6C_final_distribution_result.jpg')

% plot(std1, std2, std3, RMSE, RMSE2, RMSE3);
% subplot(1, 3, 1)
% plot(RMSE, std1, 'o');
% subplot(1, 3, 2)
% plot(RMSE2, std2, 'o');
% 
% subplot(1, 3, 3)
% plot(RMSE3, std3, 'o');

