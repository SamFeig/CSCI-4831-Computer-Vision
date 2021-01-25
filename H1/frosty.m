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
function [ outImg ] = frosty( inImg, n, m )
    [x, y, z] = size(inImg);
    
    % Instantiate output image
    outImg = uint8(zeros(x, y, z));
    
    % Calculate bidirectional offset for n and m
    n_offset = floor(n / 2);
    m_offset = floor(m / 2);
    
    for i = 1:x
        % Left and right side of the m-window, bounded by the image size
        m_left = max([1 i - m_offset]);
        m_right = min([i + m_offset x]);
        for j = 1:y
            % Left and right side of the n-window, bounded by the image
            % size
            n_left = max([1 j - n_offset]);
            n_right = min([j + n_offset y]);
            
            % Map pixel to output image, choosing random m and n within the
            % specified windows
            outImg(i, j, :) = inImg(randi([m_left m_right]), randi([n_left n_right]), :);
        end
    end
end

