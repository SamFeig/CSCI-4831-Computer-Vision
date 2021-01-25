%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 1
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ outImg ] = scaleNearest(inImg, factor) 
    [m, n, color] = size(inImg);
    
    % Instantiate output image in the scaled size
    outImg = uint8(zeros(floor(m * factor), floor(n * factor), color));
    
    % Loop through each pixel
    for i = 1:size(outImg, 1)
        for j = 1:size(outImg, 2)
            % Calculate pixel's relative nearest neighbor
            x = min([round((i - 1)/ factor)+1 m]);
            y = min([round((j - 1)/factor)+1 n]);
            
            % Map nearest neighbor pixel to output image pixel
            outImg(i, j, :) = inImg(x, y, :);
        end
    end
end