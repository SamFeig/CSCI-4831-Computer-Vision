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
function [disparityMap] = disparityDP(frameLeftGray, frameRightGray)
    % Convert both frames to doubles so that SSDs can be calculated
    % accurately
    frameLeftGray = im2double(frameLeftGray);
    frameRightGray = im2double(frameRightGray);
    
    % Get image size and initialize disparity map to default zero
    [m, n] = size(frameLeftGray);
    disparityMap = zeros(m, n);
    
    % Maximum disparity value & occlusion cost
    maxDisp = 64;
    occ = 0.01;
    
    for i = 1:m
        i
        disparityMap(i, :) = stereoDP(frameLeftGray(i, :), frameRightGray(i, :), maxDisp, occ);
    end
end

