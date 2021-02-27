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
    f = mean(stereoParams.CameraParameters1.FocalLength);
    B = stereoParams.TranslationOfCamera2';
    
    for i=1:size(disparityMap, 1)
        for j=1:size(disparityMap, 2)
            points3D(i, j, :) = f*B./disparityMap(i, j);   
        end
    end
    
end

