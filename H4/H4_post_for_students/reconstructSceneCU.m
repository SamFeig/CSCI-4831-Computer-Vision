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
function [points3D] = reconstructSceneCU(disparityMap, stereoParams)
%   Average Focal length
%     f = mean([stereoParams.CameraParameters1.FocalLength, stereoParams.CameraParameters2.FocalLength]);
% % %   Baseline of translation between cameras
%     B = sqrt(sum(stereoParams.TranslationOfCamera2 .^2));
    [m, n] = size(disparityMap);
    points3D = zeros(m, n, 3);
    
    
    for i=1:m
        for j=1:n
%           Use Formula from 11.1 in the textbook for each pixel
%             points3D(i, j, :) = (f*B)/(disparityMap(i, j)); 
%              New Formula given in class
             if disparityMap(i, j) == 0
                 points3D(i, j, :) = 1;
             else
                 points3D(i, j, :) = 1/abs(disparityMap(i, j));
             end
        end
    end
end

