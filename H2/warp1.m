%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sam Feig 
% Vladimir Zhdanov
%
% CSCI 4831/5722
% Homework 2
% Instructor: Ioana Fleming
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ outImg ] = warp1(H, img1, img2)
    [m1, n1, ~] = size(img1);
    [m2, n2, ~] = size(img2);

    img2_corners = [1 1; m2 1; 1 n2; m2 n2];
    
    new_corners = zeros(4, 3);
    for i = 1:size(img2_corners, 1)
        p = [img2_corners(i, 1); img2_corners(i, 2); 1];
        new_corners(i, :) = H \ p;
        new_corners(i, :) = new_corners(i, :) / new_corners(i, 3);
    end
    
    min_m = min([new_corners(:, 1); 1; m1]);
    max_m = max([new_corners(:, 1); 1; m1]);
    min_n = min([new_corners(:, 2); 1; n1]);
    max_n = max([new_corners(:, 2); 1; n1]);

    outImg = uint8(zeros(ceil(max_m - min_m), ceil(max_n - min_n), 3));
    
    x_offset = ceil(1 - min_m);
    y_offset = ceil(1 - min_n);
        
    for i = 1:m1
        for j = 1:n1
            outImg(i + x_offset, j + y_offset, :) = img1(i, j, :);
        end
    end
    
    for i = 1:m2
        for j = 1:n2
            xy_mapping = H \ [i; j; 1];
            xy_mapping = xy_mapping / xy_mapping(3);
            x_map = ceil(xy_mapping(1) - min_m + 1);
            y_map = ceil(xy_mapping(2) - min_n + 1);
            
            outImg(x_map, y_map, :) = img2(i, j, :);
        end
    end
end