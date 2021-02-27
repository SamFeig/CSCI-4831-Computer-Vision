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
    f = stereoParams.CameraParameters1.FocalLength
    B = stereoParams.TranslationOfCamera2
    points3D = f*B/disparityMap;
end

