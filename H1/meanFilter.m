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
function [ outImg ] = meanFilter(inImg, kernel_size)
    outImg = inImg;
    [m, n, color] = size(inImg);
    
    % Calculate bidirectional kernel offset
    kernel_offset = floor(kernel_size / 2);
    
    for i = 1:size(inImg, 1)
        % Left and right sides of m-window of the kernel, bounded by the
        % image size
        i_left = max([1 i - kernel_offset]);
        i_right = min([i + kernel_offset m]);
        for j = 1:size(inImg, 2)
            % Left and ride sides of the n-window of the kernel, bounded by
            % the image size
            j_left = max([1 j - kernel_offset]);
            j_right = min([j + kernel_offset n]);
            for k = 1:size(inImg, 3)
                % Map kernel window's mean pixel to output image
                outImg(i, j, k) = mean(inImg(i_left:i_right, j_left:j_right, k), 'all');
            end
        end
    end
    
end