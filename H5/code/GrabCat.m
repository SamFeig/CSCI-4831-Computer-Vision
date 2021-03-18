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
%% Task 7 - GrabCat: Transfer Segments between Images
% GrabCat.m starter code wasn't provided, but most of this code is from
% `RunComputeSegmentation.m`

% Read the input image and background image.
img = imread('../imgs/black_kitten.jpg');
bg = imread('../imgs/backgrounds/beach.jpg');

% Choose the number of clusters and the clustering method.
k = 5;
clusteringMethod = 'hac';

% Choose the feature function that will be used. The @ syntax creates a
% function handle; this allows us to pass a function as an argument to
% another function.
featureFn = @ComputeColorFeatures;

% Whether or not to normalize features before clustering.
normalizeFeatures = true;

% Whether or not to resize the image before clustering. If this script
% runs too slowly then you should set resize to a value less than 1.
resize = .15;

% Use all of the above parameters to actually compute a segmentation.
segments = ComputeSegmentation(img, k, clusteringMethod, featureFn, ...
                               normalizeFeatures, resize);
           
% Use ChooseSegments to move chosen segments to the background
[mask, simg] = ChooseSegments(segments, bg);

% Show the composite image
figure
imshow(simg)

% Save the final image
imwrite(simg, 'grabCatOutput.jpg')